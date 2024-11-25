<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.util.Properties, java.io.InputStream" %>

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

        JSONArray dailyDataArray = new JSONArray();

        while (rs.next()) {
            JSONObject dailyData = new JSONObject();

            // Alimentação
            JSONObject alimentacao = new JSONObject();
            alimentacao.put("cafeDaManha", rs.getString("cafe_da_manha"));
            alimentacao.put("almoco", rs.getString("almoco"));
            alimentacao.put("jantar", rs.getString("jantar"));
            alimentacao.put("lanches", rs.getString("lanches"));
            alimentacao.put("observacoes", rs.getString("observacoes_alimentacao"));

            // Líquidos
            JSONObject liquidos = new JSONObject();
            liquidos.put("agua", rs.getString("agua"));
            liquidos.put("outros", rs.getString("outros_liquidos"));
            liquidos.put("observacoes", rs.getString("observacoes_liquidos"));

            // Exercícios
            JSONObject exercicios = new JSONObject();
            exercicios.put("tipoTreino", rs.getString("tipo_treino"));
            exercicios.put("duracao", rs.getString("duracao_treino"));
            exercicios.put("intensidade", rs.getString("intensidade_treino"));
            exercicios.put("detalhes", rs.getString("detalhes_exercicio"));
            exercicios.put("observacoes", rs.getString("observacoes_exercicio"));

            // Avaliação
            JSONObject avaliacao = new JSONObject();
            avaliacao.put("fome", rs.getString("nivel_fome"));
            avaliacao.put("energia", rs.getString("nivel_energia"));
            avaliacao.put("sono", rs.getString("qualidade_sono"));
            avaliacao.put("observacoes", rs.getString("observacoes_avaliacao"));

            dailyData.put("alimentacao", alimentacao);
            dailyData.put("liquidos", liquidos);
            dailyData.put("exercicios", exercicios);
            dailyData.put("avaliacao", avaliacao);

            dailyDataArray.put(dailyData);
        }

        // Escrever a resposta no formato JSON
        response.setContentType("application/json");
        response.getWriter().write(dailyDataArray.toString());
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().write("[erro]");  // Retorna um array vazio em caso de erro
    } finally {
        try {
            // Fechar todos os recursos de forma segura
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();  // Fecha a conexão ao banco
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
