import java.io.*;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.util.Base64;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.json.JSONArray;
import org.json.JSONObject;

@MultipartConfig
public class ImageAnalysisServlet extends HttpServlet {
    private static final String API_KEY = "";
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=" + API_KEY;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("image");
        File tempFile = File.createTempFile("upload", ".jpg");
        filePart.write(tempFile.getAbsolutePath());

        String base64Image = encodeImage(tempFile.getAbsolutePath());
        String prompt = "Descreva os alimentos encontrados na imagem";

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String aiResponse = sendRequest(base64Image, prompt);
            response.getWriter().write("{\"response\": \"" + aiResponse.replace("\"", "\\\"") + "\"}");
        } catch (Exception e) {
            response.getWriter().write("{\"response\": \"Erro ao processar imagem: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
    
    private String encodeImage(String imagePath) throws IOException {
        byte[] imageBytes = Files.readAllBytes(new File(imagePath).toPath());
        return Base64.getEncoder().encodeToString(imageBytes);
    }
    
    private String sendRequest(String base64Image, String prompt) throws IOException, InterruptedException {
        JSONObject inlineData = new JSONObject().put("mime_type", "image/jpeg").put("data", base64Image);
        JSONArray parts = new JSONArray().put(new JSONObject().put("text", prompt)).put(new JSONObject().put("inline_data", inlineData));
        JSONObject content = new JSONObject().put("parts", parts);
        JSONObject payload = new JSONObject().put("contents", new JSONArray().put(content));
        
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(API_URL))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(payload.toString()))
                .build();
        
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() != 200) {
            throw new RuntimeException("Erro na API: " + response.statusCode() + " - " + response.body());
        }
        
        JSONObject responseJson = new JSONObject(response.body());
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
}
