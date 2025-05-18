/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package ai;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.util.Base64;
import javax.imageio.ImageIO;
import org.json.JSONArray;
import org.json.JSONObject;

public class teste_gemini {

    private static final String API_KEY = "AIzaSyDLmPzZINauO8pFeU1ygfSqQbLpP60jlE4"; // Substitua pela sua chave de API
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=" + API_KEY;

    // Função para redimensionar a imagem
    public static void resizeImage(String inputPath, String outputPath, int width, int height) throws IOException {
        File inputFile = new File(inputPath);
        BufferedImage originalImage = ImageIO.read(inputFile);

        BufferedImage resizedImage = new BufferedImage(width, height, originalImage.getType());
        Graphics2D g = resizedImage.createGraphics();
        g.drawImage(originalImage, 0, 0, width, height, null);
        g.dispose();

        File outputFile = new File(outputPath);
        ImageIO.write(resizedImage, "png", outputFile);
    }

    // Função para codificar a imagem em Base64
    public static String encodeImage(String imagePath) throws IOException {
        File imageFile = new File(imagePath);
        byte[] imageBytes = Files.readAllBytes(imageFile.toPath());
        return Base64.getEncoder().encodeToString(imageBytes);
    }

    // Função para enviar a requisição para a API Gemini
    public static String sendRequest(String base64Image, String prompt) throws IOException, InterruptedException {
        // Construção do payload
        JSONObject inlineData = new JSONObject()
                .put("mime_type", "image/png")
                .put("data", base64Image);

        JSONArray parts = new JSONArray()
                .put(new JSONObject().put("text", prompt))
                .put(new JSONObject().put("inline_data", inlineData));

        JSONObject content = new JSONObject()
                .put("parts", parts);

        JSONObject payload = new JSONObject()
                .put("contents", new JSONArray().put(content));

        // Configuração da requisição HTTP
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(API_URL))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(payload.toString()))
                .build();

        // Envio da requisição e obtenção da resposta
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        // Log da resposta completa
        System.out.println("Status Code: " + response.statusCode());
        System.out.println("Resposta Bruta: " + response.body());

        // Verifica se a resposta foi bem-sucedida
        if (response.statusCode() != 200) {
            throw new RuntimeException("Erro na requisição: " + response.statusCode() + " - " + response.body());
        }

        // Processamento da resposta
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

        return "Nenhum resultado encontrado na resposta.";
    }

    public static void main(String[] args) {
        try {
            String prompt = "Descreva os alimentos encontrados na imagem no formato JSON com os campos 'nome' (string) e 'detalhes' (string).";
            String inputImagePath = "C:\\Users\\piero\\OneDrive\\Imagens\\prato comida.jpg";
            String resizedImagePath = "C:\\Users\\piero\\OneDrive\\Imagens\\prato comida.jpg";

            // Redimensionar a imagem para reduzir o tamanho (exemplo: 500x500 pixels)
            resizeImage(inputImagePath, resizedImagePath, 500, 500);

            // Codificar a imagem redimensionada em Base64
            String base64Image = encodeImage(resizedImagePath);

            // Enviar a requisição para a API Gemini
            String response = sendRequest(base64Image, prompt);

            // Exibir a resposta
            System.out.println("Resposta da API Gemini: " + response);
        } catch (Exception ex) {
            System.err.println("ERRO: " + ex.getMessage());
            ex.printStackTrace();
        }
    }
}
