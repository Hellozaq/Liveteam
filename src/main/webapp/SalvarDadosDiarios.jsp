<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%
    
    if (request.getSession(false) == null || request.getSession(false).getAttribute("usuarioLogado") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    JSONObject responseJson = new JSONObject();

    // Recuperar o ID do usu�rio logado da sess�o
    Integer idUsuario = (Integer) session.getAttribute("idUsuario");

    if (idUsuario == null) {
        responseJson.put("status", "error");
        responseJson.put("message", "ID de usu�rio n�o encontrado.");
        response.setContentType("application/json");
        response.getWriter().print(responseJson.toString());
        return;
    }

    // Receber os par�metros enviados via requisi��o
    String cafeDaManha = request.getParameter("cafe_da_manha");
    String almoco = request.getParameter("almoco");
    String jantar = request.getParameter("jantar");
    String lanches = request.getParameter("lanches");
    String observacoesAlimentacao = request.getParameter("observacoes_alimentacao");
    String agua = request.getParameter("agua");
    String outrosLiquidos = request.getParameter("outros_liquidos");
    String observacoesLiquidos = request.getParameter("observacoes_liquidos");
    String tipoTreino = request.getParameter("tipo_treino");
    String duracaoTreino = request.getParameter("duracao_treino");
    String intensidadeTreino = request.getParameter("intensidade_treino");
    String detalhesExercicio = request.getParameter("detalhes_exercicio");
    String observacoesExercicio = request.getParameter("observacoes_exercicio");
    String nivelFome = request.getParameter("nivel_fome");
    String nivelEnergia = request.getParameter("nivel_energia");
    String qualidadeSono = request.getParameter("qualidade_sono");
    String observacoesAvaliacao = request.getParameter("observacoes_avaliacao");
    String diaStr = request.getParameter("dia");
    String mesStr = request.getParameter("mes");
    String anoStr = request.getParameter("ano");

    // Valida��o inicial dos par�metros obrigat�rios
    if (diaStr == null || mesStr == null || anoStr == null || diaStr.trim().isEmpty() || mesStr.trim().isEmpty() || anoStr.trim().isEmpty()) {
        responseJson.put("status", "error");
        responseJson.put("message", "Par�metros de data (dia, m�s e ano) s�o obrigat�rios.");
        response.setContentType("application/json");
        response.getWriter().print(responseJson.toString());
        return;
    }

    int dia, mes, ano;
    try {
        dia = Integer.parseInt(diaStr);
        mes = Integer.parseInt(mesStr);
        ano = Integer.parseInt(anoStr);
    } catch (NumberFormatException e) {
        responseJson.put("status", "error");
        responseJson.put("message", "Par�metros de data inv�lidos.");
        response.setContentType("application/json");
        response.getWriter().print(responseJson.toString());
        return;
    }

    // Tratar campos opcionais
    observacoesAlimentacao = (observacoesAlimentacao == null || observacoesAlimentacao.trim().isEmpty()) ? null : observacoesAlimentacao;
    observacoesLiquidos = (observacoesLiquidos == null || observacoesLiquidos.trim().isEmpty()) ? null : observacoesLiquidos;
    detalhesExercicio = (detalhesExercicio == null || detalhesExercicio.trim().isEmpty()) ? null : detalhesExercicio;
    observacoesExercicio = (observacoesExercicio == null || observacoesExercicio.trim().isEmpty()) ? null : observacoesExercicio;
    observacoesAvaliacao = (observacoesAvaliacao == null || observacoesAvaliacao.trim().isEmpty()) ? null : observacoesAvaliacao;

    // Conex�o com o banco de dados
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Carregar propriedades do arquivo db.properties
        Properties props = new Properties();
        InputStream input = getServletContext().getResourceAsStream("/WEB-INF/classes/db.properties");
        if (input == null) {
            throw new Exception("Arquivo db.properties n�o encontrado.");
        }
        props.load(input);

        String url = props.getProperty("db.url");
        String username = props.getProperty("db.username");
        String password = props.getProperty("db.password");
        String driver = props.getProperty("db.driver");

        // Registrar o driver
        Class.forName(driver);

        // Estabelecer conex�o
        conn = DriverManager.getConnection(url, username, password);

        if (conn == null || conn.isClosed()) {
            responseJson.put("status", "error");
            responseJson.put("message", "Falha ao conectar ao banco de dados.");
        } else {
            // Inserir os dados na tabela, agora incluindo o ID do usu�rio
            String sql = "INSERT INTO dados_diarios (" +
                    "id_usuario, dia, mes, ano, " +
                    "cafe_da_manha, almoco, jantar, lanches, observacoes_alimentacao, " +
                    "agua, outros_liquidos, observacoes_liquidos, " +
                    "tipo_treino, duracao_treino, intensidade_treino, detalhes_exercicio, observacoes_exercicio, " +
                    "nivel_fome, nivel_energia, qualidade_sono, observacoes_avaliacao" +
                    ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, idUsuario); // Agora inclu�mos o ID do usu�rio
            pstmt.setInt(2, dia);
            pstmt.setInt(3, mes);
            pstmt.setInt(4, ano);
            pstmt.setString(5, cafeDaManha);
            pstmt.setString(6, almoco);
            pstmt.setString(7, jantar);
            pstmt.setString(8, lanches);
            pstmt.setString(9, observacoesAlimentacao);
            pstmt.setString(10, agua);
            pstmt.setString(11, outrosLiquidos);
            pstmt.setString(12, observacoesLiquidos);
            pstmt.setString(13, tipoTreino);
            pstmt.setString(14, duracaoTreino);
            pstmt.setString(15, intensidadeTreino);
            pstmt.setString(16, detalhesExercicio);
            pstmt.setString(17, observacoesExercicio);
            pstmt.setString(18, nivelFome);
            pstmt.setString(19, nivelEnergia);
            pstmt.setString(20, qualidadeSono);
            pstmt.setString(21, observacoesAvaliacao);

            int rowsInserted = pstmt.executeUpdate();

            if (rowsInserted > 0) {
                responseJson.put("status", "success");
                responseJson.put("message", "Dados salvos com sucesso!");
            } else {
                responseJson.put("status", "error");
                responseJson.put("message", "Nenhum dado foi inserido.");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        responseJson.put("status", "error");
        responseJson.put("message", "Erro ao executar a opera��o no banco: " + e.getMessage());
    } catch (Exception e) {
        e.printStackTrace();
        responseJson.put("status", "error");
        responseJson.put("message", "Erro inesperado: " + e.getMessage());
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // Retornar a resposta em JSON
    response.setContentType("application/json");
    response.getWriter().print(responseJson.toString());
%>