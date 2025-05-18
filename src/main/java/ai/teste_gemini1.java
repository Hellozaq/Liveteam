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

public class teste_gemini1 {

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

    // Função para enviar a requisição para a API Gemini e retornar a resposta bruta como String
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

        // Retorna a resposta bruta como String para ser processada como JSON no main
        return response.body();
    }

    public static void main(String[] args) {
        try {
            String prompt = "Descreva os alimentos encontrados na imagem no formato JSON com os campos 'nome' (string) e 'detalhes' (string).";
            String inputImagePath = "C:\\Users\\piero\\OneDrive\\Imagens\\prato comida.jpg";
            String resizedImagePath = "C:\\Users\\piero\\OneDrive\\Imagens\\prato comida_resized.jpg"; // Use um nome diferente para o arquivo redimensionado

            // Redimensionar a imagem para reduzir o tamanho (exemplo: 500x500 pixels)
            resizeImage(inputImagePath, resizedImagePath, 500, 500);

            // Codificar a imagem redimensionada em Base64
            String base64Image = encodeImage(resizedImagePath);

            // Enviar a requisição para a API Gemini e obter a resposta JSON como String
            String jsonResponseString = sendRequest(base64Image, prompt);

            try {
                // Analisar a string JSON principal
                JSONObject responseJson = new JSONObject(jsonResponseString);
                JSONArray candidates = responseJson.optJSONArray("candidates");

                if (candidates != null && candidates.length() > 0) {
                    JSONObject firstCandidate = candidates.getJSONObject(0);
                    JSONObject contentObj = firstCandidate.optJSONObject("content");
                    if (contentObj != null) {
                        JSONArray partsArray = contentObj.optJSONArray("parts");
                        if (partsArray != null && partsArray.length() > 0) {
                            String responseText = partsArray.getJSONObject(0).getString("text");
                            try {
                                // Tentar analisar o texto da resposta como um JSONObject
                                JSONObject jsonOutput = new JSONObject(responseText);
                                System.out.println("Resposta JSON Analisada:");
                                if (jsonOutput.has("nome")) {
                                    String nomeAlimento = jsonOutput.getString("nome");
                                    System.out.println("Nome do Alimento: " + nomeAlimento);
                                }
                                if (jsonOutput.has("detalhes")) {
                                    String detalhesAlimento = jsonOutput.getString("detalhes");
                                    System.out.println("Detalhes: " + detalhesAlimento);
                                }
                                // Se a resposta for um JSONArray de alimentos
                                if (jsonOutput.has("alimentos")) {
                                    JSONArray alimentosArray = jsonOutput.getJSONArray("alimentos");
                                    System.out.println("Lista de Alimentos:");
                                    for (int i = 0; i < alimentosArray.length(); i++) {
                                        JSONObject alimento = alimentosArray.getJSONObject(i);
                                        String nome = alimento.optString("nome", "Nome não encontrado");
                                        String detalhes = alimento.optString("detalhes", "Detalhes não encontrados");
                                        System.out.println("  Alimento " + (i + 1) + ": Nome=" + nome + ", Detalhes=" + detalhes);
                                    }
                                } else {
                                    System.out.println("Resposta JSON: " + jsonOutput.toString(2));
                                }
                            } catch (org.json.JSONException e) {
                                System.err.println("Erro ao analisar a resposta como JSONObject: " + responseText);
                                System.out.println("Resposta Bruta (não é um JSONObject válido): " + responseText);
                            }
                        }
                    }
                } else {
                    System.out.println("Nenhum candidato encontrado na resposta.");
                    System.out.println("Resposta Bruta: " + jsonResponseString);
                }

            } catch (org.json.JSONException e) {
                System.err.println("Erro ao analisar a string de resposta principal como JSON: " + jsonResponseString);
                System.out.println("Resposta Bruta: " + jsonResponseString);
            }

        } catch (Exception ex) {
            System.err.println("ERRO: " + ex.getMessage());
            ex.printStackTrace();
        }
    }
}