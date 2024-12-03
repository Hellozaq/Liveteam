import gemini.Gemini;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
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

        // Monta a mensagem a ser enviada para o Gemini com os dados do formulário
        String mensagem = "Por favor, crie um plano de dieta e treino com base nas seguintes informações:\n\n" +
                "Idade: " + idade + "\n" + 
                "Sexo: " + sexo + "\n" +
                "Altura (cm): " + alturaCm + "\n" +
                "Peso (kg): " + pesoKg + "\n" +
                "Objetivo Principal: " + objetivoPrincipal + "\n" +
                "Frequência Semanal de Treino: " + frequenciaSemanalTreino + "\n" +
                "Duração Média do Treino: " + duracaoMediaTreino + "\n" +
                "Tipo de Atividade Física: " + tipoAtividadeFisica + "\n" +
                "Objetivos do Treino: " + objetivosTreino + "\n" +
                "Nacionalidade: " + nacionalidade + "\n" +
                "Residência Atual: " + residenciaAtual + "\n" +
                "Alimentos Favoritos: " + alimentosFavoritos + "\n" +
                "Alimentos que Evita: " + alimentosQueEvita + "\n" +
                "Alimentos para Incluir/Excluir: " + alimentosParaIncluirExcluir + "\n" +
                "Usa Suplementos: " + usaSuplementos + "\n" +
                "Suplementos Usados: " + suplementosUsados + "\n" +
                "Tempo de Treino por Sessão: " + tempoPorTreino + "\n" +
                "Café da Manhã: " + cafeDaManha + "\n" +
                "Almoço: " + almoco + "\n" +
                "Jantar: " + jantar +
                        "e com base no seguinte prompt de resposta '\n" +
                "Cálculo da Taxa de Metabolismo Basal (TMB)\n" +
                "•	Sexo: [Masculino / Feminino]\n" +
                "•	Idade: [Idade em anos]\n" +
                "•	Altura: [Altura em cm]\n" +
                "•	Peso: [Peso em kg]\n" +
                "•	Nível de Atividade Física: [Leve / Moderado / Intenso]\n" +
                "Cálculo da TMB (fórmula de Harris-Benedict para Homens ou Mulheres):\n" +
                "•	Homens: TMB=66,5+(13,75×Peso)+(5,003×Altura)−(6,75×Idade)TMB = 66,5 + (13,75 \\times Peso) + (5,003 \\times Altura) - (6,75 \\times Idade)TMB=66,5+(13,75×Peso)+(5,003×Altura)−(6,75×Idade)\n" +
                "•	Mulheres: TMB=655+(9,563×Peso)+(1,850×Altura)−(4,676×Idade)TMB = 655 + (9,563 \\times Peso) + (1,850 \\times Altura) - (4,676 \\times Idade)TMB=655+(9,563×Peso)+(1,850×Altura)−(4,676×Idade)\n" +
                "Necessidades Calóricas Diárias:\n" +
                "(Se aplicável, multiplique a TMB pelo fator de atividade para estimar a quantidade de calorias diárias necessárias.)\n" +
                "\n" +
                "Plano de Dieta\n" +
                "Objetivos de Dieta: [Preencher conforme objetivo]\n" +
                "•	Calorias Totais: [Número de calorias sugeridas para o objetivo]\n" +
                "Distribuição de Macronutrientes:\n" +
                "•	Proteínas: [Percentual ou gramas]\n" +
                "•	Carboidratos: [Percentual ou gramas]\n" +
                "•	Gorduras: [Percentual ou gramas]\n" +
                "\n" +
                "Exemplo de Cardápio (Com Calorias de Cada Refeição e Alimento )\n" +
                "Café da manhã:\n" +
                "•	[Alimento 1] [Quantidade e calorias]\n" +
                "•	[Alimento 2] [Quantidade e calorias]\n" +
                "•	[Alimento 3] [Quantidade e calorias]\n" +
                "Total do Café da Manhã: [Total de calorias]\n" +
                "\n" +
                "Almoço:\n" +
                "•	[Alimento 1] [Quantidade e calorias]\n" +
                "•	[Alimento 2] [Quantidade e calorias]\n" +
                "•	[Alimento 3] [Quantidade e calorias]\n" +
                "Total do Almoço: [Total de calorias]\n" +
                "\n" +
                "Lanche da Tarde:\n" +
                "•	[Alimento 1] [Quantidade e calorias]\n" +
                "•	[Alimento 2] [Quantidade e calorias]\n" +
                "Total do Lanche da Tarde: [Total de calorias]\n" +
                "\n" +
                "Jantar:\n" +
                "•	[Alimento 1] [Quantidade e calorias]\n" +
                "•	[Alimento 2] [Quantidade e calorias]\n" +
                "•	[Alimento 3] [Quantidade e calorias]\n" +
                "Total do Jantar: [Total de calorias]\n" +
                "\n" +
                "Total de Calorias do Dia: [Total de calorias do dia]\n" +
                "\n" +
                "Plano de Treino (Musculação)\n" +
                "Objetivo: [Preencher com objetivo do treino]\n" +
                "Estrutura do Treino (Baseado na quantia de dias indicada)\n" +
                "\n" +
                "Conclusão:\n" +
                "Com base nas informações preenchidas, este plano de dieta e treino foi "
                + "ajustado para [objetivo principal], com detalhamento de calorias por refeição e alimento, "
                + "e com uma estratégia de treino adequada para atingir seus objetivos.\n" +
                "'";

        String respostaGemini = "";
        try {
            // Envia a mensagem para o Gemini e obtém a resposta
            respostaGemini = Gemini.getCompletion(mensagem).replaceAll("[\\n\\r]+", " ");
        } catch (Exception e) {
            respostaGemini = "Erro ao obter resposta do Gemini: " + e.getMessage();
        }

        // Conexão com o banco de dados
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // Carrega as propriedades do banco de dados
            Properties props = loadDbProperties();
            String url = props.getProperty("db.url");
            String username = props.getProperty("db.username");
            String password = props.getProperty("db.password");

            // Estabelece a conexão com o banco
            conn = DriverManager.getConnection(url, username, password);

            // SQL de inserção
            String sql = "INSERT INTO plano_dieta_treino (" +
                    "idade, sexo, altura_cm, peso_kg, objetivo_principal, frequencia_semanal_treino, " +
                    "duracao_media_treino_minutos, tipo_atividade_fisica, objetivos_treino, nacionalidade, " +
                    "residencia_atual, alimentos_favoritos, alimentos_que_evita, alimentos_para_incluir_excluir, " +
                    "usa_suplementos, suplementos_usados, tempo_por_treino_minutos, cafe_da_manha, almoco, jantar) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            // Prepara a query para execução
            ps = conn.prepareStatement(sql);

            // Preenche os parâmetros da query com os dados do formulário
           ps.setInt(1, Integer.parseInt(idade));  // Adiciona a idade
           ps.setString(2, sexo);
           ps.setBigDecimal(3, new BigDecimal(alturaCm));
           ps.setBigDecimal(4, new BigDecimal(pesoKg));
           ps.setString(5, objetivoPrincipal);
           ps.setInt(6, Integer.parseInt(frequenciaSemanalTreino));
           ps.setInt(7, Integer.parseInt(duracaoMediaTreino));
           ps.setString(8, tipoAtividadeFisica);
           ps.setString(9, objetivosTreino);
           ps.setString(10, nacionalidade);
           ps.setString(11, residenciaAtual);
           ps.setString(12, alimentosFavoritos);
           ps.setString(13, alimentosQueEvita);
           ps.setString(14, alimentosParaIncluirExcluir);
           ps.setBoolean(15, Boolean.parseBoolean(usaSuplementos));
           ps.setString(16, suplementosUsados);
           ps.setInt(17, Integer.parseInt(tempoPorTreino));
           ps.setString(18, cafeDaManha);
           ps.setString(19, almoco);
           ps.setString(20, jantar);

            // Executa a inserção no banco de dados
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro de SQL: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
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
                contentStream.setFont(PDType1Font.HELVETICA_BOLD, 16);
                contentStream.setLeading(20f);
                contentStream.newLineAtOffset(50, 700);
                //Limpa caracteres invalidos
                 String cleanText = respostaGemini.replaceAll("[\\p{Cntrl}&&[^\n\r]]", " ").replaceAll("\\s+", " ");
                // Adiciona os dados do usuário ao PDF
                contentStream.showText("Plano de Dieta e Treino");
                contentStream.newLine();
                contentStream.setFont(PDType1Font.HELVETICA, 12);
                contentStream.showText("Sexo: " + sexo);
                contentStream.newLine();
                contentStream.showText("Altura (cm): " + alturaCm);
                contentStream.newLine();
                contentStream.showText("Peso (kg): " + pesoKg);
                contentStream.newLine();
                contentStream.showText("Objetivo Principal: " + objetivoPrincipal);
                contentStream.newLine();
                contentStream.showText("Frequência Semanal de Treino: " + frequenciaSemanalTreino);
                contentStream.newLine();
                contentStream.showText("Duração Média do Treino: " + duracaoMediaTreino);
                contentStream.newLine();
                contentStream.showText("Tipo de Atividade Física: " + tipoAtividadeFisica);
                contentStream.newLine();
                contentStream.showText("Objetivos do Treino: " + objetivosTreino);
                contentStream.newLine();
                contentStream.showText("Nacionalidade: " + nacionalidade);
                contentStream.newLine();
                contentStream.showText("Residência Atual: " + residenciaAtual);
                contentStream.newLine();
                contentStream.showText("Alimentos Favoritos: " + alimentosFavoritos);
                contentStream.newLine();
                contentStream.showText("Alimentos que Evita: " + alimentosQueEvita);
                contentStream.newLine();
                contentStream.showText("Alimentos para Incluir/Excluir: " + alimentosParaIncluirExcluir);
                contentStream.newLine();
                contentStream.showText("Usa Suplementos: " + usaSuplementos);
                contentStream.newLine();
                contentStream.showText("Suplementos Usados: " + suplementosUsados);
                contentStream.newLine();
                contentStream.showText("Tempo de Treino por Sessão: " + tempoPorTreino);
                contentStream.newLine();
                contentStream.newLine();
               
                contentStream.showText(cleanText);
            }

            document.save(response.getOutputStream());
        } catch (IOException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao gerar PDF: " + e.getMessage());
        }
    }

    private Properties loadDbProperties() throws IOException {
        Properties props = new Properties();
        try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/classes/db.properties")) {
            props.load(input);
        }
        return props;
    }
}