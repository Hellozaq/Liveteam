package gemini;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import org.json.JSONArray;
import org.json.JSONObject;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.security.cert.X509Certificate;

public class Gemini {

    private static final String API_KEY = "AIzaSyB19JsIDVfwnh5piLUBqxy6tgn_sGzmXLw";

    // Fake SSL HttpClient
    private static final HttpClient httpClient = createHttpClient();

    private static HttpClient createHttpClient() {
        try {
            TrustManager[] trustAllCerts = new TrustManager[]{
                new X509TrustManager() {
                    public X509Certificate[] getAcceptedIssuers() { return null; }
                    public void checkClientTrusted(X509Certificate[] certs, String authType) {}
                    public void checkServerTrusted(X509Certificate[] certs, String authType) {}
                }
            };

            SSLContext sslContext = SSLContext.getInstance("SSL");
            sslContext.init(null, trustAllCerts, new java.security.SecureRandom());

            return HttpClient.newBuilder()
                .sslContext(sslContext)
                .build();
        } catch (Exception e) {
            throw new RuntimeException("Erro ao configurar HttpClient: " + e.getMessage());
        }
    }

    public static String getCompletion(String prompt) throws Exception {
        // Estruturando o corpo da requisição
        JSONObject data = new JSONObject();
        JSONArray partsArray = new JSONArray()
                .put(new JSONObject().put("text", prompt));
        data.put("contents", new JSONArray()
                .put(new JSONObject().put("parts", partsArray)));

        // Configuração da requisição HTTP usando o HttpClient configurado com SSL
        HttpRequest request = HttpRequest.newBuilder()
                .uri(new URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=" + API_KEY))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(data.toString()))
                .build();

        // Envio da requisição e tratamento da resposta
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() != 200) {
            throw new RuntimeException("Erro na requisição: " + response.statusCode() + " - " + response.body());
        } else {
            JSONObject jsonResponse = new JSONObject(response.body());
            // Verifica se "candidates" contém conteúdo gerado
            if (jsonResponse.has("candidates")) {
                JSONArray candidatesArray = jsonResponse.getJSONArray("candidates");
                if (candidatesArray.length() > 0 && candidatesArray.getJSONObject(0).has("content")) {
                    // Acessa o conteúdo dentro de "content" -> "parts" -> "text"
                    JSONArray parts = candidatesArray.getJSONObject(0).getJSONObject("content").getJSONArray("parts");
                    if (parts.length() > 0) {
                        return parts.getJSONObject(0).getString("text");
                    } else {
                        throw new RuntimeException("Nenhum texto gerado encontrado em 'parts'.");
                    }
                } else {
                    throw new RuntimeException("Campo 'content' não encontrado na resposta.");
                }
            } else {
                throw new RuntimeException("Campo 'candidates' não encontrado na resposta.");
            }
        }
    }

    public static void main(String[] args) {
        try {
            System.out.println(Gemini.getCompletion("Gere uma lista de frutas"));
        } catch (Exception ex) {
            System.out.println("ERRO: " + ex.getLocalizedMessage());
        }
    }
}
