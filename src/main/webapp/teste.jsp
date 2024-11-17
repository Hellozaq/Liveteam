

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.liveteam.database.DatabaseConnection"%>
<html>
<head>
    <title>Dados do Dia 14/11/2024</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1 class="mt-4">Dados para o Dia 14/11/2024</h1>
        <table class="table table-striped mt-3">
            <thead>
                <tr>
                    <th>Categoria</th>
                    <th>Detalhes</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Definir os parâmetros fixos (dia, mês e ano)
                    String dia = "14";
                    String mes = "11";
                    String ano = "2024";

                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        // Obter a conexão do banco de dados usando a classe DatabaseConnection
                        conn = com.liveteam.database.DatabaseConnection.getConnection();

                        // Consulta SQL para buscar dados do dia, mês e ano fornecidos
                        String sql = "SELECT * FROM dados_diarios WHERE dia = ? AND mes = ? AND ano = ?";
                        ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(dia));  // Definindo o valor do parâmetro dia
                        ps.setInt(2, Integer.parseInt(mes));  // Definindo o valor do parâmetro mes
                        ps.setInt(3, Integer.parseInt(ano));  // Definindo o valor do parâmetro ano
                        rs = ps.executeQuery();

                        // Verificando se há resultados
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
                                    Duração: <%= rs.getString("duracao") %><br>
                                    Intensidade: <%= rs.getString("intensidade") %><br>
                                    Detalhes: <%= rs.getString("detalhes") %><br>
                                    Observações: <%= rs.getString("observacoes_exercicios") %>
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
                                <td colspan="2">Nenhum dado encontrado para o dia 14/11/2024.</td>
                            </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                        <tr>
                            <td colspan="2">Erro ao buscar os dados.</td>
                        </tr>
                <%
                    } finally {
                        try {
                            // Fechar todos os recursos de forma segura
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
