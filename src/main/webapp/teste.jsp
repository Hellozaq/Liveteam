<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Properties" %>
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

        <h2 class="mt-4">Dados para o Dia <%= request.getParameter("dia") != null ? request.getParameter("dia") + "/" + request.getParameter("mes") + "/" + request.getParameter("ano") : "" %></h2>
        
        <table class="table table-striped mt-3">
            <thead>
                <tr>
                    <th>Categoria</th>
                    <th>Detalhes</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Recuperar parâmetros da requisição
                    String dia = request.getParameter("dia");
                    String mes = request.getParameter("mes");
                    String ano = request.getParameter("ano");

                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    if (dia != null && mes != null && ano != null) {
                        try {
                            // Carregar propriedades do arquivo db.properties
                            Properties props = new Properties();
                            java.io.InputStream input = getServletContext().getResourceAsStream("/WEB-INF/classes/db.properties");

                            if (input == null) {
                                throw new Exception("Arquivo db.properties não encontrado.");
                            }

                            props.load(input);
                            String url = props.getProperty("db.url");
                            String username = props.getProperty("db.username");
                            String password = props.getProperty("db.password");
                            String driver = props.getProperty("db.driver");

                            // Registrar o driver do banco de dados
                            Class.forName(driver);

                            // Estabelecer a conexão
                            conn = DriverManager.getConnection(url, username, password);

                            // Consulta SQL para buscar dados
                            String sql = "SELECT * FROM dados_diarios WHERE dia = ? AND mes = ? AND ano = ?";
                            ps = conn.prepareStatement(sql);
                            ps.setInt(1, Integer.parseInt(dia));
                            ps.setInt(2, Integer.parseInt(mes));
                            ps.setInt(3, Integer.parseInt(ano));
                            rs = ps.executeQuery();

                            if (rs.next()) {
                %>
                                <tr>
                                    <td><strong>Alimentação</strong></td>
                                    <td>
                                        Café da manhã: <%= rs.getString("cafe_da_manha") %><br>
                                        Almoço: <%= rs.getString("almoco") %><br>
                                        Jantar: <%= rs.getString("jantar") %><br>
                                        Lanches: <%= rs.getString("lanches") %><br>
                                        Observações: <%= rs.getString("observacoes_alimentacao") %>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Líquidos</strong></td>
                                    <td>
                                        Água: <%= rs.getString("agua") %><br>
                                        Outros líquidos: <%= rs.getString("outros_liquidos") %><br>
                                        Observações: <%= rs.getString("observacoes_liquidos") %>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Exercícios</strong></td>
                                    <td>
                                        Tipo de treino: <%= rs.getString("tipo_treino") %><br>
                                        Duração: <%= rs.getString("duracao_treino") %><br>
                                        Intensidade: <%= rs.getString("intensidade_treino") %><br>
                                        Detalhes: <%= rs.getString("detalhes_exercicio") %><br>
                                        Observações: <%= rs.getString("observacoes_exercicio") %>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Avaliação</strong></td>
                                    <td>
                                        Fome: <%= rs.getString("nivel_fome") %><br>
                                        Energia: <%= rs.getString("nivel_energia") %><br>
                                        Sono: <%= rs.getString("qualidade_sono") %><br>
                                        Observações: <%= rs.getString("observacoes_avaliacao") %>
                                    </td>
                                </tr>
                <%
                            } else {
                %>
                                <tr>
                                    <td colspan="2">Nenhum dado encontrado para a data selecionada.</td>
                                </tr>
                <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                %>
                                <tr>
                                    <td colspan="2">Erro ao buscar os dados. Verifique os logs para mais detalhes.</td>
                                </tr>
                <%
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (ps != null) ps.close();
                                if (conn != null) conn.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
