package servlets;

import gemini.Gemini;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONObject;
import org.json.JSONException;
import java.io.*;
import java.sql.*;
import java.util.Properties;

@WebServlet("/AtualizarPlano")
public class AtualizarPlanoServlet extends HttpServlet {

    private final SalvarPlanoNoBanco salvarPlanoNoBanco = new SalvarPlanoNoBanco();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        resp.setContentType("application/json");
        JSONObject responseJson = new JSONObject();

        try {
            if (session == null || session.getAttribute("usuarioEmail") == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                responseJson.put("erro", "Usuário não autenticado.");
                resp.getWriter().write(responseJson.toString());
                return;
            }

            String email = (String) session.getAttribute("usuarioEmail");
            BufferedReader reader = req.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
            JSONObject json = new JSONObject(sb.toString());

            String comentario = json.optString("comentario", "");
            JSONObject ultimoPlano = json.optJSONObject("ultimoPlano");

            int idUsuario = -1;
            Properties props = new Properties();
            InputStream input = getClass().getClassLoader().getResourceAsStream("db.properties");
            if (input == null) throw new Exception("Arquivo db.properties não encontrado.");
            props.load(input);

            Class.forName(props.getProperty("db.driver"));
            try (Connection conn = DriverManager.getConnection(
                    props.getProperty("db.url"), props.getProperty("db.username"), props.getProperty("db.password"))) {

                try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM usuario WHERE email = ?")) {
                    ps.setString(1, email);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) idUsuario = rs.getInt("id");
                    }
                }
                if (idUsuario == -1) throw new Exception("Usuário não encontrado.");

                String prompt =
                    "Plano anterior:\n" + (ultimoPlano != null ? ultimoPlano.toString(2) : "(vazio)") +
                    "\n\nComentário do usuário: " + comentario +
                    "\n\nRetorne a resposta em um objeto JSON com a seguinte estrutura EXATA:\n\n" +
                    "{\n" +
                    "  \"plano_completo\": {\n" +
                    "    \"plano_dieta\": {\n" +
                    "      \"objetivo\": \"[string: objetivo principal da dieta]\",\n" +
                    "      \"calorias_totais\": \"[int: estimativa de calorias totais]\",\n" +
                    "      \"meta_agua\": \"[int: litros ]\",\n" +
                    "      \"macronutrientes\": {\n" +
                    "        \"proteinas\": \"[int: percentual d]\",\n" +
                    "        \"carboidratos\": \"[int: percentual ]\",\n" +
                    "        \"gorduras\": \"[int: percentual ]\",\n" +
                    "        \"meta_agua\": \"[int: litros ]\"\n" +
                    "      },\n" +
                    "      \"refeicoes\": {\n" +
                    "        \"cafe_da_manha\": \"[string: sugestão para o café da manhã]\",\n" +
                    "        \"almoco\": \"[string: sugestão para o almoço]\",\n" +
                    "        \"lanche_tarde\": \"[string: sugestão para o lanche da tarde]\",\n" +
                    "        \"jantar\": \"[string: sugestão para o jantar]\"\n" +
                    "      },\n" +
                    "      \"observacoes\": \"[string: observações adicionais sobre a dieta]\"\n" +
                    "    },\n" +
                    "    \"plano_treino\": {\n" +
                    "      \"divisao\": \"[string: 'ABC', 'ABAB' ou outra divisão]\",\n" +
                    "      \"justificativa_divisao\": \"[string: justificativa para a escolha da divisão]\",\n" +
                    "      \"treino_a\": {\n" +
                    "        \"foco\": \"[string: grupo muscular principal do treino A]\",\n" +
                    "        \"exercicios\": [\n" +
                    "          {\n" +
                    "            \"nome\": \"[string: nome do exercício]\",\n" +
                    "            \"series\": \"[string: número de séries (ex: '3') ]\",\n" +
                    "            \"repeticoes\": \"[string: número de repetições (ex: '8-12')]\"\n" +
                    "          }\n" +
                    "          // ... mais exercícios seguindo a mesma estrutura ...\n" +
                    "        ]\n" +
                    "      },\n" +
                    "      \"treino_b\": {\n" +
                    "        \"foco\": \"[string: grupo muscular principal do treino B]\",\n" +
                    "        \"exercicios\": [\n" +
                    "          {\n" +
                    "            \"nome\": \"[string: nome do exercício]\",\n" +
                    "            \"series\": \"[string: número de séries (ex: '3')]\",\n" +
                    "            \"repeticoes\": \"[string: número de repetições (ex: '8-12')]\"\n" +
                    "          }\n" +
                    "          // ... mais exercícios seguindo a mesma estrutura ...\n" +
                    "        ]\n" +
                    "      },\n" +
                    "      \"treino_c\": {\n" +
                    "        \"foco\": \"[string: grupo muscular principal do treino C]\",\n" +
                    "        \"exercicios\": [\n" +
                    "          {\n" +
                    "            \"nome\": \"[string: nome do exercício]\",\n" +
                    "            \"series\": \"[string: número de séries (ex: '3')]\",\n" +
                    "            \"repeticoes\": \"[string: número de repetições (ex: '8-12')]\"\n" +
                    "          }\n" +
                    "          // ... mais exercícios seguindo a mesma estrutura (apenas se divisão ABC) ...\n" +
                    "        ]\n" +
                    "      },\n" +
                    "      \"observacoes\": \"[string: observações adicionais sobre o treino, como descanso, aquecimento, etc.]\"\n" +
                    "    }\n" +
                    "  }\n" +
                    "}";

                String respostaGemini = "";
                JSONObject respostaJson = null;
                JSONObject planoCompletoJson = null;
                JSONObject planoDietaJson = null;
                JSONObject planoTreinoJson = null;

                try {
                    respostaGemini = Gemini.getCompletion(prompt);
                    respostaGemini = respostaGemini.trim();
                    respostaGemini = respostaGemini.replace("```json", "").trim();
                    respostaGemini = respostaGemini.replace("```", "").trim();
                    respostaGemini = respostaGemini.replace("|#]", "").trim();
                    respostaGemini = respostaGemini.replace("\n", "");
                    respostaGemini = respostaGemini.replace("\t", "");

                    respostaJson = new JSONObject(respostaGemini);

                    if (respostaJson.has("plano_completo")) {
                        planoCompletoJson = respostaJson.getJSONObject("plano_completo");
                    } else if (respostaJson.has("plano_dieta") && respostaJson.has("plano_treino")) {
                        planoCompletoJson = respostaJson;
                    } else {
                        responseJson.put("sucesso", false);
                        responseJson.put("erro", "Seção 'plano_completo' não encontrada na resposta da IA.");
                        resp.getWriter().write(responseJson.toString());
                        return;
                    }

                    planoDietaJson = planoCompletoJson.optJSONObject("plano_dieta");
                    planoTreinoJson = planoCompletoJson.optJSONObject("plano_treino");
                    if (planoDietaJson == null || planoTreinoJson == null) {
                        responseJson.put("sucesso", false);
                        responseJson.put("erro", "Campos 'plano_dieta' ou 'plano_treino' não encontrados.");
                        resp.getWriter().write(responseJson.toString());
                        return;
                    }

                    salvarPlanoNoBanco.salvarPlanoNoBanco(idUsuario, planoDietaJson, planoTreinoJson);
                    responseJson.put("sucesso", true);
                    resp.getWriter().write(responseJson.toString());
                } catch (JSONException e) {
                    responseJson.put("sucesso", false);
                    responseJson.put("erro", "Erro ao obter e analisar a resposta do Gemini: " + e.getMessage());
                    resp.getWriter().write(responseJson.toString());
                } catch (Exception e) {
                    responseJson.put("sucesso", false);
                    responseJson.put("erro", "Erro ao obter resposta do Gemini: " + e.getMessage());
                    resp.getWriter().write(responseJson.toString());
                }
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseJson.put("sucesso", false);
            responseJson.put("erro", e.getMessage());
            resp.getWriter().write(responseJson.toString());
        }
    }
}