<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Dados do Dia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <h1 class="mt-4">Dados do Dia</h1>

        <% 
            if (request.getSession(false) == null || request.getSession(false).getAttribute("usuarioLogado") == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String dia = request.getParameter("dia");
            String mes = request.getParameter("mes");
            String ano = request.getParameter("ano");

            System.out.println("Dia: " + dia);
            System.out.println("Mês: " + mes);
            System.out.println("Ano: " + ano);

            String alimentacao = "";
            String liquidos = "";
            String exercicios = "";
            String avaliacao = "";

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                // Carregar propriedades do arquivo db.properties
                Properties props = new Properties();
                InputStream input = getServletContext().getResourceAsStream("/WEB-INF/classes/db.properties");
                if (input == null) {
                    throw new Exception("Arquivo db.properties não encontrado.");
                }
                props.load(input);

                String url = props.getProperty("db.url");
                String username = props.getProperty("db.username");
                String password = props.getProperty("db.password");
                String driver = props.getProperty("db.driver");

                // Registrar o driver
                Class.forName(driver);

                // Estabelecer conexão
                conn = DriverManager.getConnection(url, username, password);

                // Usando PreparedStatement para evitar injeção de SQL
                String sql = "SELECT * FROM dados_diarios WHERE dia = ? AND mes = ? AND ano = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(dia));  // Definindo o valor do parâmetro dia
                ps.setInt(2, Integer.parseInt(mes));  // Definindo o valor do parâmetro mes
                ps.setInt(3, Integer.parseInt(ano));  // Definindo o valor do parâmetro ano
                rs = ps.executeQuery();

                if (rs.next()) {
                    // Alimentação
                    alimentacao = "Café da manhã: " + rs.getString("cafe_da_manha") + "<br>" +
                                  "Almoço: " + rs.getString("almoco") + "<br>" +
                                  "Jantar: " + rs.getString("jantar") + "<br>" +
                                  "Lanches: " + rs.getString("lanches") + "<br>" +
                                  "Observações: " + rs.getString("observacoes_alimentacao");

                    // Líquidos
                    liquidos = "Água: " + rs.getString("agua") + "<br>" +
                               "Outros líquidos: " + rs.getString("outros_liquidos") + "<br>" +
                               "Observações: " + rs.getString("observacoes_liquidos");

                    // Exercícios
                    exercicios = "Tipo de treino: " + rs.getString("tipo_treino") + "<br>" +
                                 "Duração: " + rs.getString("duracao_treino") + "<br>" +
                                 "Intensidade: " + rs.getString("intensidade_treino") + "<br>" +
                                 "Detalhes: " + rs.getString("detalhes_exercicio") + "<br>" +
                                 "Observações: " + rs.getString("observacoes_exercicio");

                    // Avaliação
                    avaliacao = "Fome: " + rs.getString("nivel_fome") + "<br>" +
                                "Energia: " + rs.getString("nivel_energia") + "<br>" +
                                "Sono: " + rs.getString("qualidade_sono") + "<br>" +
                                "Observações: " + rs.getString("observacoes_avaliacao");
                } else {
                    alimentacao = "Nenhum dado encontrado.";
                    liquidos = "Nenhum dado encontrado.";
                    exercicios = "Nenhum dado encontrado.";
                    avaliacao = "Nenhum dado encontrado.";
                }
            } catch (Exception e) {
                alimentacao = "Erro ao buscar dados: " + e.getMessage();
                liquidos = "Erro ao buscar dados.";
                exercicios = "Erro ao buscar dados.";
                avaliacao = "Erro ao buscar dados.";
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        %>

        <h2 class="mt-4">Dados para o Dia <%= dia %>/<%= mes %>/<%= ano %></h2>

        <table class="table table-striped mt-3">
            <thead>
                <tr>
                    <th>Categoria</th>
                    <th>Detalhes</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Alimentação</strong></td>
                    <td><%= alimentacao %></td>
                </tr>
                <tr>
                    <td><strong>Líquidos</strong></td>
                    <td><%= liquidos %></td>
                </tr>
                <tr>
                    <td><strong>Exercícios</strong></td>
                    <td><%= exercicios %></td>
                </tr>
                <tr>
                    <td><strong>Avaliação</strong></td>
                    <td><%= avaliacao %></td>
                </tr>
            </tbody>
        </table>
    </div>
</body>
</html>
