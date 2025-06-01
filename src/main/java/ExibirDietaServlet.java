import gemini.Gemini;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import servlets.SalvarPlanoNoBanco;

@WebServlet("/ExibirDietaServlet")
public class ExibirDietaServlet extends HttpServlet {

        private final SalvarPlanoNoBanco salvarPlanoNoBanco = new SalvarPlanoNoBanco();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        exibirPlanoCompleto(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        exibirPlanoCompleto(request, response);
    }

    private void exibirPlanoCompleto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
            int idUsuario = -1; // valor padrão inválido (ou 0), só pra garantir que seja inicializado
            HttpSession session = request.getSession(false);

            if (session != null) {
                String idUsuarioStr = (String) session.getAttribute("idUsuario");
                if (idUsuarioStr != null) {
                    try {
                        idUsuario = Integer.parseInt(idUsuarioStr);
                        System.out.println("ID do usuário logado: " + idUsuario);
                    } catch (NumberFormatException e) {
                        e.printStackTrace();
                        response.sendRedirect("login.jsp?error=idInvalido");
                        return;
                    }
                } else {
                    response.sendRedirect("login.jsp?error=naoLogado");
                    return;
                }
            } else {
                response.sendRedirect("login.jsp?error=naoLogado");
                return;
            }
        
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

        // Monta a mensagem a ser enviada para o Gemini com especificação detalhada do JSON
        String mensagem = "Por favor, crie um plano completo de dieta e treino para academia com base nas seguintes informações:\n\n" +
                "Idade: " + idade + "\n" +
                "Sexo: " + sexo + "\n" +
                "Altura (cm): " + alturaCm + "\n" +
                "Peso (kg): " + pesoKg + "\n" +
                "Objetivo Principal: " + objetivoPrincipal + "\n" +
                "Frequência Semanal de Treino: " + frequenciaSemanalTreino + "\n" +
                "Duração Média do Treino (minutos): " + duracaoMediaTreino + "\n" +
                "Tipo de Atividade Física: " + tipoAtividadeFisica + "\n" +
                "Objetivos do Treino: " + objetivosTreino + "\n" +
                "Nacionalidade: " + nacionalidade + "\n" +
                "Residência Atual: " + residenciaAtual + "\n" +
                "Alimentos Favoritos: " + alimentosFavoritos + "\n" +
                "Alimentos que Evita: " + alimentosQueEvita + "\n" +
                "Alimentos para Incluir/Excluir: " + alimentosParaIncluirExcluir + "\n" +
                "Usa Suplementos: " + usaSuplementos + "\n" +
                "Suplementos Usados: " + suplementosUsados + "\n" +
                "Tempo por Treino (minutos): " + tempoPorTreino + "\n" +
                "Café da Manhã (sugestão): " + cafeDaManha + "\n" +
                "Almoço (sugestão): " + almoco + "\n" +
                "Jantar (sugestão): " + jantar + "\n\n" +
                "Retorne a resposta em um objeto JSON com a seguinte estrutura EXATA:\n\n" +
                "{\n" +
                "  \"plano_completo\": {\n" +
                "    \"plano_dieta\": {\n" +
                "      \"objetivo\": \"[string: objetivo principal da dieta]\",\n" +
                "      \"calorias_totais\": \"[string: estimativa de calorias totais]\",\n" +
                "      \"macronutrientes\": {\n" +
                "        \"proteinas\": \"[string: percentual ou gramas de proteína]\",\n" +
                "        \"carboidratos\": \"[string: percentual ou gramas de carboidrato]\",\n" +
                "        \"gorduras\": \"[string: percentual ou gramas de gordura]\"\n" +
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
                "          },\n" +
                "          {\n" +
                "            \"nome\": \"[string: nome do exercício]\",\n" +
                "            \"series\": \"[string: número de séries (ex: '3')]\",\n" +
                "            \"repeticoes\": \"[string: número de repetições (ex: '10-15')]\"\n" +
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
                "          },\n" +
                "          {\n" +
                "            \"nome\": \"[string: nome do exercício]\",\n" +
                "            \"series\": \"[string: número de séries (ex: '3')]\",\n" +
                "            \"repeticoes\": \"[string: número de repetições (ex: '10-15')]\"\n" +
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
                "          },\n" +
                "          {\n" +
                "            \"nome\": \"[string: nome do exercício]\",\n" +
                "            \"series\": \"[string: número de séries (ex: '3')]\",\n" +
                "            \"repeticoes\": \"[string: número de repetições (ex: '10-15')]\"\n" +
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
            respostaGemini = Gemini.getCompletion(mensagem);
            System.out.println("Resposta Bruta do Gemini (no Servlet - Original): " + respostaGemini);

            // Limpeza da resposta
            respostaGemini = respostaGemini.trim();
            respostaGemini = respostaGemini.replace("```json", "").trim();
            respostaGemini = respostaGemini.replace("```", "").trim();
            respostaGemini = respostaGemini.replace("|#]", "").trim();
            respostaGemini = respostaGemini.replace("\n", "");
            respostaGemini = respostaGemini.replace("\t", "");
            // respostaGemini = respostaGemini.replace(" ", ""); // Manter espaços por enquanto

            System.out.println("Resposta Bruta do Gemini (no Servlet - Limpa): " + respostaGemini);

            respostaJson = new JSONObject(respostaGemini);
            planoCompletoJson = respostaJson.optJSONObject("plano_completo");

            if (planoCompletoJson != null) {
                planoDietaJson = planoCompletoJson.optJSONObject("plano_dieta");
                planoTreinoJson = planoCompletoJson.optJSONObject("plano_treino");
                System.out.println("planoDietaJson (no Servlet): " + planoDietaJson);
                System.out.println("planoTreinoJson (no Servlet): " + planoTreinoJson);
                salvarPlanoNoBanco.salvarPlanoNoBanco(idUsuario, planoDietaJson, planoTreinoJson);
                System.out.println("Plano salvo no banco com sucesso.");
            } else {
                System.err.println("Seção 'plano_completo' não encontrada no JSON.");
            }

        } catch (JSONException e) {
            System.err.println("Erro ao analisar JSON: " + e.getMessage());
            if (respostaGemini != null && respostaGemini.length() > 500) {
                System.err.println("Últimos 500 caracteres da resposta Gemini:\n" + respostaGemini.substring(respostaGemini.length() - 500));
            } else if (respostaGemini != null) {
                System.err.println("Resposta Gemini completa:\n" + respostaGemini);
            }
            respostaGemini = "Erro ao obter e analisar a resposta do Gemini: " + e.getMessage();
            e.printStackTrace();
        } catch (Exception e) {
            respostaGemini = "Erro ao obter resposta do Gemini: " + e.getMessage();
            e.printStackTrace();
        }

        // Configura a resposta para HTML
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html lang=\"pt-BR\">");
        out.println("<head>");
        out.println("<meta charset=\"UTF-8\">");
        out.println("<title>Plano de Dieta e Treino</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Plano de Dieta e Treino</h1>");

        if (planoCompletoJson != null) {
            out.println("<h2>Plano de Dieta</h2>");
            if (planoDietaJson != null) {
                out.println("<p><strong>Objetivo:</strong> " + planoDietaJson.optString("objetivo") + "</p>");
                out.println("<p><strong>Calorias Totais Estimadas:</strong> " + planoDietaJson.optString("calorias_totais") + "</p>");

                JSONObject macroJson = planoDietaJson.optJSONObject("macronutrientes");
                if (macroJson != null) {
                    out.println("<h3>Macronutrientes:</h3>");
                    out.println("<ul>");
                    out.println("<li><strong>Proteínas:</strong> " + macroJson.optString("proteinas") + "</li>");
                    out.println("<li><strong>Carboidratos:</strong> " + macroJson.optString("carboidratos") + "</li>");
                    out.println("<li><strong>Gorduras:</strong> " + macroJson.optString("gorduras") + "</li>");
                    out.println("</ul>");
                }

                JSONObject refeicoesJson = planoDietaJson.optJSONObject("refeicoes");
                if (refeicoesJson != null) {
                    out.println("<h3>Cardápio:</h3>");
                    out.println("<ul>");
                    out.println("<li><strong>Café da Manhã:</strong> " + refeicoesJson.optString("cafe_da_manha") + "</li>");
                    out.println("<li><strong>Almoço:</strong> " + refeicoesJson.optString("almoco") + "</li>");
                    out.println("<li><strong>Lanche da Tarde:</strong> " + refeicoesJson.optString("lanche_tarde") + "</li>");
                    out.println("<li><strong>Jantar:</strong> " + refeicoesJson.optString("jantar") + "</li>");
                    out.println("</ul>");
                }

                String observacoesDieta = planoDietaJson.optString("observacoes");
                if (!observacoesDieta.isEmpty()) {
                    out.println("<h3>Observações da Dieta:</h3>");
                    out.println("<p>" + observacoesDieta + "</p>");
                }
            } else {
                out.println("<p>Erro ao exibir o plano de dieta.</p>");
            }

            out.println("<h2>Plano de Treino</h2>");
            if (planoTreinoJson != null) {
                out.println("<p><strong>Divisão do Treino:</strong> " + planoTreinoJson.optString("divisao") + "</p>");
                out.println("<p><strong>Justificativa da Divisão:</strong> " + planoTreinoJson.optString("justificativa_divisao") + "</p>");

                exibirTreino(out, planoTreinoJson.optJSONObject("treino_a"), "A");
                exibirTreino(out, planoTreinoJson.optJSONObject("treino_b"), "B");
                exibirTreino(out, planoTreinoJson.optJSONObject("treino_c"), "C");

                String observacoesTreino = planoTreinoJson.optString("observacoes");
                if (!observacoesTreino.isEmpty()) {
                    out.println("<h3>Observações do Treino:</h3>");
                    out.println("<p>" + observacoesTreino + "</p>");
                }

            } else {
                out.println("<p>Erro ao exibir o plano de treino.</p>");
            }

        } else {
            out.println("<p>Erro ao exibir o plano completo.</p>");
            out.println("<p>Resposta Bruta do Gemini (Limpa): " + respostaGemini + "</p>");
        }

        out.println("</body>");
        out.println("</html>");
    }

    private void exibirTreino(PrintWriter out, JSONObject treinoJson, String nomeTreino) {
        if (treinoJson != null) {
            out.println("<h3>Treino " + nomeTreino + " (" + treinoJson.optString("foco") + "):</h3>");
            JSONArray exercicios = treinoJson.optJSONArray("exercicios");
            if (exercicios != null) {
                out.println("<ul>");
                for (int i = 0; i < exercicios.length(); i++) {
                    try {
                        JSONObject exercicio = exercicios.getJSONObject(i);
                        out.println("<li><strong>" + exercicio.optString("nome") + ":</strong> " +
                                exercicio.optString("series") + " séries de " + exercicio.optString("repeticoes") + " repetições</li>");
                    } catch (JSONException e) {
                        out.println("<p>Erro ao exibir exercício no Treino " + nomeTreino + ": " + e.getMessage() + "</p>");
                        e.printStackTrace();
                    }
                }
                out.println("</ul>");
            }
        }
    }
}