<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="com.liveteam.database.DatabaseConnection" %>
<%
    int dia = Integer.parseInt(request.getParameter("dia"));
    int mes = Integer.parseInt(request.getParameter("mes"));
    int ano = Integer.parseInt(request.getParameter("ano"));

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONObject dailyData = new JSONObject();

    try {
        // Usa a classe DatabaseConnection para obter a conexão
        conn = DatabaseConnection.getConnection();

        String sql = "SELECT * FROM dados_diarios WHERE dia = ? AND mes = ? AND ano = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, dia);
        pstmt.setInt(2, mes);
        pstmt.setInt(3, ano);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            JSONObject alimentacao = new JSONObject();
            alimentacao.put("cafeDaManha", rs.getString("cafe_da_manha"));
            alimentacao.put("almoco", rs.getString("almoco"));
            alimentacao.put("jantar", rs.getString("jantar"));
            alimentacao.put("lanches", rs.getString("lanches"));
            alimentacao.put("observacoes", rs.getString("observacoes_alimentacao"));

            JSONObject liquidos = new JSONObject();
            liquidos.put("agua", rs.getString("agua"));
            liquidos.put("outros", rs.getString("outros_liquidos"));
            liquidos.put("observacoes", rs.getString("observacoes_liquidos"));

            JSONObject exercicios = new JSONObject();
            exercicios.put("tipoTreino", rs.getString("tipo_treino"));
            exercicios.put("duracao", rs.getString("duracao_treino"));
            exercicios.put("intensidade", rs.getString("intensidade_treino"));
            exercicios.put("detalhes", rs.getString("detalhes_exercicio"));
            exercicios.put("observacoes", rs.getString("observacoes_exercicio"));

            JSONObject avaliacao = new JSONObject();
            avaliacao.put("fome", rs.getString("nivel_fome"));
            avaliacao.put("energia", rs.getString("nivel_energia"));
            avaliacao.put("sono", rs.getString("qualidade_sono"));
            avaliacao.put("observacoes", rs.getString("observacoes_avaliacao"));

            dailyData.put("alimentacao", alimentacao);
            dailyData.put("liquidos", liquidos);
            dailyData.put("exercicios", exercicios);
            dailyData.put("avaliacao", avaliacao);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Fecha o ResultSet, PreparedStatement e Connection após o uso
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        DatabaseConnection.closeConnection();  // Fecha a conexão via método centralizado
    }

    response.setContentType("application/json");
    response.getWriter().print(dailyData.toString());
%>
