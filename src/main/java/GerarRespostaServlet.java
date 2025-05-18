import gemini.Gemini;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType0Font;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Properties;

@WebServlet("/GerarRespostaServlet")
public class GerarRespostaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        gerarPdf(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        gerarPdf(request, response);
    }

    private void gerarPdf(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recupera os dados enviados pelo formulário
        String idade = request.getParameter("idade");
        String sexo = request.getParameter("sexo");
        String alturaCm = request.getParameter("altura_cm");
        String pesoKg = request.getParameter("peso_kg");
        String objetivoPrincipal = request.getParameter("objetivo_principal");
        String frequenciaSemanalTreino = request.getParameter("frequencia_semanal_treino");
        String duracaoMediaTreino = request.getParameter("duracao_media_treino_minutos");
        String tipoAtividadeFisica = request.getParameter("tipo_atividade_fisica");
        String objetivosTreino = request.getParameter("objetivos_treino");
        String nacionalidade = request.getParameter("nacionalidade");
        String residenciaAtual = request.getParameter("residencia_atual");
        String alimentosFavoritos = request.getParameter("alimentos_favoritos");
        String alimentosQueEvita = request.getParameter("alimentos_que_evita");
        String alimentosParaIncluirExcluir = request.getParameter("alimentos_para_incluir_excluir");
        String usaSuplementos = request.getParameter("usa_suplementos");
        String suplementosUsados = request.getParameter("suplementos_usados");
        String tempoPorTreino = request.getParameter("tempo_por_treino_minutos");
        String cafeDaManha = request.getParameter("cafe_da_manha");
        String almoco = request.getParameter("almoco");
        String jantar = request.getParameter("jantar");

        // Monta a mensagem a ser enviada para o Gemini com os dados do formulário e instrução para JSON
        String mensagem = "Por favor, crie um plano de dieta e treino com base nas seguintes informações, " +
                "retornando a resposta em formato JSON:\n\n" +
                "{\n" +
                "  \"metabolismo_basal\": {\n" +
                "    \"sexo\": \"" + sexo + "\",\n" +
                "    \"idade\": \"" + idade + "\",\n" +
                "    \"altura_cm\": \"" + alturaCm + "\",\n" +
                "    \"peso_kg\": \"" + pesoKg + "\",\n" +
                "    \"nivel_atividade\": \"[Leve / Moderado / Intenso]\",\n" +
                "    \"tmb_homens\": \"[Cálculo TMB Homens]\",\n" +
                "    \"tmb_mulheres\": \"[Cálculo TMB Mulheres]\",\n" +
                "    \"calorias_diarias\": \"[Calorias Diárias Estimadas]\"\n" +
                "  },\n" +
                "  \"plano_dieta\": {\n" +
                "    \"objetivo\": \"" + objetivoPrincipal + "\",\n" +
                "    \"calorias_totais\": \"[Número]\",\n" +
                "    \"macronutrientes\": {\n" +
                "      \"proteinas\": \"[Percentual ou gramas]\",\n" +
                "      \"carboidratos\": \"[Percentual ou gramas]\",\n" +
                "      \"gorduras\": \"[Percentual ou gramas]\"\n" +
                "    },\n" +
                "    \"refeicoes\": {\n" +
                "      \"cafe_da_manha\": \"" + cafeDaManha + "\",\n" +
                "      \"almoco\": \"" + almoco + "\",\n" +
                "      \"lanche_tarde\": \"[Sugestões]\",\n" +
                "      \"jantar\": \"" + jantar + "\"\n" +
                "    },\n" +
                "    \"observacoes\": \"[Observações sobre a dieta]\"\n" +
                "  },\n" +
                "  \"plano_treino\": {\n" +
                "    \"objetivo\": \"" + objetivosTreino + "\",\n" +
                "    \"frequencia\": \"" + frequenciaSemanalTreino + "\",\n" +
                "    \"duracao_media\": \"" + duracaoMediaTreino + "\",\n" +
                "    \"tempo_sessao\": \"" + tempoPorTreino + "\",\n" +
                "    \"tipo_atividade\": \"" + tipoAtividadeFisica + "\",\n" +
                "    \"estrutura\": \"[Estrutura do treino]\",\n" +
                "    \"observacoes\": \"[Observações sobre o treino]\"\n" +
                "  },\n" +
                "  \"informacoes_usuario\": {\n" +
                "    \"nacionalidade\": \"" + nacionalidade + "\",\n" +
                "    \"residencia\": \"" + residenciaAtual + "\",\n" +
                "    \"alimentos_favoritos\": \"" + alimentosFavoritos + "\",\n" +
                "    \"alimentos_evita\": \"" + alimentosQueEvita + "\",\n" +
                "    \"alimentos_incluir_excluir\": \"" + alimentosParaIncluirExcluir + "\",\n" +
                "    \"suplementos_usa\": \"" + usaSuplementos + "\",\n" +
                "    \"suplementos_usados\": \"" + suplementosUsados + "\"\n" +
                "  },\n" +
                "  \"conclusao\": \"[Conclusão e recomendações finais]\"\n" +
                "}";

        String respostaGemini = "";
        JSONObject respostaJson = null;
        try {
            // Envia a mensagem para o Gemini e obtém a resposta
            respostaGemini = Gemini.getCompletion(mensagem);

            // Tenta analisar a resposta como JSONObject
            respostaGemini = respostaGemini.trim();
            if (respostaGemini.startsWith("{")) {
                respostaJson = new JSONObject(respostaGemini);
            } else if (respostaGemini.startsWith("[")) {
                // Se a resposta for um JSONArray
                System.err.println("Resposta do Gemini é um JSONArray, adaptando para extrair informações...");
                JSONArray respostaArrayJson = new JSONArray(respostaGemini);
                if (respostaArrayJson.length() > 0) {
                    // Assumindo que o primeiro elemento do array é o objeto desejado
                    respostaJson = respostaArrayJson.getJSONObject(0);
                } else {
                    System.err.println("JSONArray da resposta do Gemini está vazio.");
                    respostaGemini = "Resposta do Gemini (JSONArray vazio): " + respostaGemini;
                }
            } else {
                System.err.println("Resposta do Gemini não começou com '{' ou '[': " + respostaGemini);
                // Se não for um JSON válido, use a resposta bruta para o PDF
            }

        } catch (Exception e) {
            respostaGemini = "Erro ao obter resposta do Gemini: " + e.getMessage();
            e.printStackTrace();
        }

        // Conexão com o banco de dados
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Properties props = loadDbProperties();
            String url = props.getProperty("db.url");
            String username = props.getProperty("db.username");
            String password = props.getProperty("db.password");

            conn = DriverManager.getConnection(url, username, password);

            String sql = "INSERT INTO respostas_gemini (resposta) VALUES (?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, respostaGemini);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        // Configura a resposta para download do PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"plano_dieta_treino.pdf\"");

        // Cria o documento PDF
        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage();
            document.addPage(page);

            try (PDPageContentStream contentStream = new PDPageContentStream(document, page)) {
                contentStream.beginText();
                contentStream.setLeading(15f);
                contentStream.newLineAtOffset(50, 750);

                PDType0Font arialFont = PDType0Font.load(document, new File("C:/Windows/Fonts/arial.ttf"));
                contentStream.setFont(arialFont, 10);

                contentStream.showText("Plano de Dieta e Treino");
                contentStream.newLine();
                contentStream.newLine();

                if (respostaJson != null) {
                    // Exibe os dados do JSON no PDF
                    exibirJsonNoPdf(contentStream, respostaJson);
                } else {
                    contentStream.showText("Resposta do Gemini (não formatada como JSON esperado):\n" + respostaGemini);
                }

                contentStream.endText();
            }

            document.save(response.getOutputStream());
        } catch (IOException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao gerar PDF: " + e.getMessage());
        }
    }

    private void exibirJsonNoPdf(PDPageContentStream contentStream, JSONObject jsonObject) throws IOException {
        for (String key : jsonObject.keySet()) {
            Object value = jsonObject.get(key);
            contentStream.showText(key + ": ");
            if (value instanceof JSONObject) {
                contentStream.newLine();
                contentStream.newLineAtOffset(20, 0);
                exibirJsonNoPdf(contentStream, (JSONObject) value);
                contentStream.newLineAtOffset(-20, 0);
            } else if (value instanceof JSONArray) {
                contentStream.newLine();
                contentStream.newLineAtOffset(20, 0);
                JSONArray jsonArray = (JSONArray) value;
                for (int i = 0; i < jsonArray.length(); i++) {
                    Object arrayValue = jsonArray.get(i);
                    contentStream.showText("- Item " + (i + 1) + ": ");
                    if (arrayValue instanceof JSONObject) {
                        contentStream.newLine();
                        contentStream.newLineAtOffset(20, 0);
                        exibirJsonNoPdf(contentStream, (JSONObject) arrayValue);
                        contentStream.newLineAtOffset(-20, 0);
                    } else {
                        contentStream.showText(arrayValue.toString());
                        contentStream.newLine();
                    }
                }
                contentStream.newLineAtOffset(-20, 0);
            } else {
                contentStream.showText(value.toString());
                contentStream.newLine();
            }
        }
    }


    private Properties loadDbProperties() {
        Properties props = new Properties();
        try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/database.properties")) {
            if (input != null) {
                props.load(input);
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        return props;
    }
}