<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Dados do Dia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Estilos customizados */
        .data-container {
            background-color: #ffffff;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .data-title {
            color: #2d6a4f;
        }

        .table-custom {
            background-color: #f1fdf2;
            border-radius: 8px;
            margin-top: 20px;
        }

        .table-custom th {
            background-color: #4caf50;
            color: white;
            text-align: center;
        }

        .table-custom td {
            text-align: center;
            padding: 10px;
        }
    </style>
</head>
<body>

    <%@ include file="WEB-INF/jspf/header.jspf" %>

    <div class="container data-container">
        <h1 class="mt-4 data-title">Dados do Dia (<%= LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) %>)</h1>


        <%
            String idUsuarioStr = (String) session.getAttribute("idUsuario");
            Integer idUsuario = (idUsuarioStr != null) ? Integer.parseInt(idUsuarioStr) : null;
            if (request.getSession(false) == null || request.getSession(false).getAttribute("usuarioLogado") == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String dia = request.getParameter("dia");
            String mes = request.getParameter("mes");
            String ano = request.getParameter("ano");

            String cafeDaManha = "nenhum";
            String almoco = "nenhum";
            String jantar = "nenhum";
            String lanches = "nenhum";
            String observacoesAlimentacao = "nenhum";

            String agua = "nenhum";
            String outrosLiquidos = "nenhum";
            String observacoesLiquidos = "nenhum";

            String tipoTreino = "nenhum";
            String duracaoTreino = "nenhum";
            String intensidadeTreino = "nenhum";
            String detalhesExercicio = "nenhum";
            String observacoesExercicio = "nenhum";

            String nivelFome = "nenhum";
            String nivelEnergia = "nenhum";
            String qualidadeSono = "nenhum";
            String observacoesAvaliacao = "nenhum";

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
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

                Class.forName(driver);

                conn = DriverManager.getConnection(url, username, password);

                String sql = "SELECT * FROM dados_diarios WHERE dia = ? AND mes = ? AND ano = ? and id_usuario = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(dia));
                ps.setInt(2, Integer.parseInt(mes));
                ps.setInt(3, Integer.parseInt(ano));
                ps.setInt(4, idUsuario);
                rs = ps.executeQuery();

                if (rs.next()) {
                    cafeDaManha = rs.getString("cafe_da_manha") != null ? rs.getString("cafe_da_manha") : "nenhum";
                    almoco = rs.getString("almoco") != null ? rs.getString("almoco") : "nenhum";
                    jantar = rs.getString("jantar") != null ? rs.getString("jantar") : "nenhum";
                    lanches = rs.getString("lanches") != null ? rs.getString("lanches") : "nenhum";
                    observacoesAlimentacao = rs.getString("observacoes_alimentacao") != null ? rs.getString("observacoes_alimentacao") : "nenhum";

                    agua = rs.getString("agua") != null ? rs.getString("agua") : "nenhum";
                    outrosLiquidos = rs.getString("outros_liquidos") != null ? rs.getString("outros_liquidos") : "nenhum";
                    observacoesLiquidos = rs.getString("observacoes_liquidos") != null ? rs.getString("observacoes_liquidos") : "nenhum";

                    tipoTreino = rs.getString("tipo_treino") != null ? rs.getString("tipo_treino") : "nenhum";
                    duracaoTreino = rs.getString("duracao_treino") != null ? rs.getString("duracao_treino") : "nenhum";
                    intensidadeTreino = rs.getString("intensidade_treino") != null ? rs.getString("intensidade_treino") : "nenhum";
                    detalhesExercicio = rs.getString("detalhes_exercicio") != null ? rs.getString("detalhes_exercicio") : "nenhum";
                    observacoesExercicio = rs.getString("observacoes_exercicio") != null ? rs.getString("observacoes_exercicio") : "nenhum";

                    nivelFome = rs.getString("nivel_fome") != null ? rs.getString("nivel_fome") : "nenhum";
                    nivelEnergia = rs.getString("nivel_energia") != null ? rs.getString("nivel_energia") : "nenhum";
                    qualidadeSono = rs.getString("qualidade_sono") != null ? rs.getString("qualidade_sono") : "nenhum";
                    observacoesAvaliacao = rs.getString("observacoes_avaliacao") != null ? rs.getString("observacoes_avaliacao") : "nenhum";
                } else {
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Nenhum dado para o dia selecionado!');");
                    out.println("window.location.href = 'calendario.jsp';");
                    out.println("</script>");
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Erro ao buscar dados!');");
                out.println("window.location.href = 'calendario.jsp';");
                out.println("</script>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Erro inesperado: " + e.getMessage() + "');");
                out.println("window.location.href = 'calendario.jsp';");
                out.println("</script>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        %>

        <!-- Tabela de Alimentação -->
        <h2 class="mt-4 data-title">Alimentação</h2>
        <table class="table table-custom">
            <thead>
                <tr>
                    <th scope="col">Café da Manhã</th>
                    <th scope="col">Almoço</th>
                    <th scope="col">Jantar</th>
                    <th scope="col">Lanches</th>
                    <th scope="col">Observações</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= cafeDaManha %></td>
                    <td><%= almoco %></td>
                    <td><%= jantar %></td>
                    <td><%= lanches %></td>
                    <td><%= observacoesAlimentacao %></td>
                </tr>
            </tbody>
        </table>

        <!-- Tabela de Líquidos -->
        <h2 class="mt-4 data-title">Líquidos</h2>
        <table class="table table-custom">
            <thead>
                <tr>
                    <th scope="col">Água</th>
                    <th scope="col">Outros Líquidos</th>
                    <th scope="col">Observações</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= agua %></td>
                    <td><%= outrosLiquidos %></td>
                    <td><%= observacoesLiquidos %></td>
                </tr>
            </tbody>
        </table>

        <!-- Tabela de Treino -->
        <h2 class="mt-4 data-title">Treino</h2>
        <table class="table table-custom">
            <thead>
                <tr>
                    <th scope="col">Tipo de Treino</th>
                    <th scope="col">Duração</th>
                    <th scope="col">Intensidade</th>
                    <th scope="col">Detalhes</th>
                    <th scope="col">Observações</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= tipoTreino %></td>
                    <td><%= duracaoTreino %></td>
                    <td><%= intensidadeTreino %></td>
                    <td><%= detalhesExercicio %></td>
                    <td><%= observacoesExercicio %></td>
                </tr>
            </tbody>
        </table>

        <!-- Tabela de Avaliação Pessoal -->
        <h2 class="mt-4 data-title">Avaliação Pessoal</h2>
        <table class="table table-custom">
            <thead>
                <tr>
                    <th scope="col">Nível de Fome</th>
                    <th scope="col">Nível de Energia</th>
                    <th scope="col">Qualidade do Sono</th>
                    <th scope="col">Observações</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= nivelFome %></td>
                    <td><%= nivelEnergia %></td>
                    <td><%= qualidadeSono %></td>
                    <td><%= observacoesAvaliacao %></td>
                </tr>
            </tbody>
        </table>
    </div>

</body>
</html>
