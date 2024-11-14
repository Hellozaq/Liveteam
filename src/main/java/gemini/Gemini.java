package gemini;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import org.json.JSONArray;
import org.json.JSONObject;

public class Gemini {
    private static final String API_KEY = "";

    public static String getCompletion(String prompt) throws Exception {
        // Estruturando o corpo da requisição
        JSONObject data = new JSONObject();
        JSONArray partsArray = new JSONArray()
                .put(new JSONObject().put("text", prompt));
        data.put("contents", new JSONArray()
                .put(new JSONObject().put("parts", partsArray)));

        // Configuração do cliente e requisição HTTP
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(new URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=" + API_KEY))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(data.toString()))
                .build();

        // Envio da requisição e tratamento da resposta
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
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
