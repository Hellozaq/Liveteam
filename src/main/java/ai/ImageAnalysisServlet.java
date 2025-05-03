package ai;

import java.io.*;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Base64;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.net.URL;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLParameters;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import org.json.JSONArray;
import org.json.JSONObject;




@WebServlet("/ImageAnalysisServlet")
@MultipartConfig
public class ImageAnalysisServlet extends HttpServlet {
    private static final String API_KEY = "";
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=" + API_KEY;

    @Override
    public void init(jakarta.servlet.ServletConfig config) throws ServletException { // Corrigido: jakarta.servlet.ServletConfig
        super.init(config);
        try {
            TrustAllCertificates.trustAllCerts();  // CHAME AQUI!
            System.out.println("Certificados SSL configurados para confiar em todos (INSEGURO)!");
        } catch (Exception e) {
            System.err.println("Falha ao configurar TrustAllCertificates: " + e.getMessage());
            // Lidar com a exceção de forma apropriada (talvez lançar ServletException)
            throw new ServletException("Falha ao inicializar o servlet", e);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        File tempFile = null;

        try {
            Part filePart = request.getPart("image");
            if (filePart == null || filePart.getSize() == 0) {
                throw new ServletException("Nenhum arquivo enviado.");
            }

            String contentType = filePart.getContentType();
            if (!"image/jpeg".equals(contentType)) {
                throw new ServletException("Apenas imagens JPEG são suportadas.");
            }

            // Criar um arquivo temporário de forma robusta
            String fileName = "upload_" + System.currentTimeMillis() + ".jpg";
            Path tempDirPath = Path.of(System.getProperty("java.io.tmpdir"));
            Path tempFilePath = tempDirPath.resolve(fileName);

            // Copiar o arquivo da requisição para o diretório temporário
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, tempFilePath, StandardCopyOption.REPLACE_EXISTING);
                tempFile = tempFilePath.toFile();
            }

            System.out.println("Arquivo recebido: " + tempFile.getAbsolutePath());

            String base64Image = encodeImage(tempFile.getAbsolutePath());
            System.out.println("Imagem convertida para Base64: " + base64Image.substring(0, 50) + "...");

            String prompt = "Descreva os alimentos encontrados na imagem, mas apenas diga os alimentos encontrados e quantia média ex: tomate 150g (em lista e apenas ela, sem texto anterior nem nada)";

            System.out.println("Enviando requisição para a API...");
            String aiResponse = sendRequest(base64Image, prompt);

            JSONObject jsonResponse = new JSONObject().put("response", aiResponse);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonResponse.toString());

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject errorJson = new JSONObject().put("response", "Erro ao processar imagem: " + e.getMessage());
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(errorJson.toString());
        } finally {
            // Remover o arquivo temporário após o processamento
            if (tempFile != null && tempFile.exists()) {
                tempFile.delete();
            }
        }
    }

    private String encodeImage(String imagePath) throws IOException {
        byte[] imageBytes = Files.readAllBytes(Path.of(imagePath));
        return Base64.getEncoder().encodeToString(imageBytes);
    }

    private String sendRequest(String base64Image, String prompt) throws Exception {
    JSONObject inlineData = new JSONObject()
            .put("mime_type", "image/jpeg")
            .put("data", base64Image);

    JSONArray parts = new JSONArray()
            .put(new JSONObject().put("text", prompt))
            .put(new JSONObject().put("inline_data", inlineData));

    JSONObject content = new JSONObject().put("parts", parts);
    JSONObject payload = new JSONObject().put("contents", new JSONArray().put(content));

    // Criar conexão HTTPS insegura (apenas para testes!)
    URL url = new URL(API_URL);
    HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();

    // Aceita todos os certificados SSL
    trustAllCertificates();

    // Ignora verificação de hostname
    connection.setHostnameVerifier((hostname, session) -> true);

    // Configurações da requisição
    connection.setRequestMethod("POST");
    connection.setRequestProperty("Content-Type", "application/json");
    connection.setDoOutput(true);

    // Enviar JSON
    try (OutputStream os = connection.getOutputStream()) {
        byte[] input = payload.toString().getBytes("utf-8");
        os.write(input, 0, input.length);
    }

    int status = connection.getResponseCode();
    System.out.println("Status Code da API: " + status);

    InputStream responseStream = (status >= 200 && status < 300)
            ? connection.getInputStream()
            : connection.getErrorStream();

    String responseText = new String(responseStream.readAllBytes(), "utf-8");
    System.out.println("Resposta da API: " + responseText);

    if (status != 200) {
        throw new RuntimeException("Erro na API: " + status + " - " + responseText);
    }

    JSONObject responseJson = new JSONObject(responseText);
    JSONArray candidates = responseJson.optJSONArray("candidates");

    if (candidates != null && candidates.length() > 0) {
        JSONObject firstCandidate = candidates.getJSONObject(0);
        JSONObject contentObj = firstCandidate.optJSONObject("content");
        if (contentObj != null) {
            JSONArray partsArray = contentObj.optJSONArray("parts");
            if (partsArray != null && partsArray.length() > 0) {
                return partsArray.getJSONObject(0).getString("text");
            }
        }
    }

    return "Nenhuma descrição encontrada.";
}


private void trustAllCertificates() throws Exception {
    TrustManager[] trustAllCerts = new TrustManager[]{
        new X509TrustManager() {
            public void checkClientTrusted(X509Certificate[] certs, String authType) {}
            public void checkServerTrusted(X509Certificate[] certs, String authType) {}
            public X509Certificate[] getAcceptedIssuers() { return new X509Certificate[0]; }
        }
    };

    SSLContext sc = SSLContext.getInstance("TLS");
    sc.init(null, trustAllCerts, new SecureRandom());
    HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
}

}

