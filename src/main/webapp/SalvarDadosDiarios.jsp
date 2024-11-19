<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%
    JSONObject responseJson = new JSONObject();

    // Receber os parâmetros enviados via requisição
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

    // Validação inicial dos parâmetros obrigatórios
    if (diaStr == null || mesStr == null || anoStr == null || diaStr.trim().isEmpty() || mesStr.trim().isEmpty() || anoStr.trim().isEmpty()) {
        responseJson.put("status", "error");
        responseJson.put("message", "Parâmetros de data (dia, mês e ano) são obrigatórios.");
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
        responseJson.put("message", "Parâmetros de data inválidos.");
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

    // Conexão com o banco de dados
    Connection conn = null;
    PreparedStatement pstmt = null;

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

        if (conn == null || conn.isClosed()) {
            responseJson.put("status", "error");
            responseJson.put("message", "Falha ao conectar ao banco de dados.");
        } else {
            // Inserir os dados na tabela
            String sql = "INSERT INTO dados_diarios (" +
                    "dia, mes, ano, " +
                    "cafe_da_manha, almoco, jantar, lanches, observacoes_alimentacao, " +
                    "agua, outros_liquidos, observacoes_liquidos, " +
                    "tipo_treino, duracao_treino, intensidade_treino, detalhes_exercicio, observacoes_exercicio, " +
                    "nivel_fome, nivel_energia, qualidade_sono, observacoes_avaliacao" +
                    ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dia);
            pstmt.setInt(2, mes);
            pstmt.setInt(3, ano);
            pstmt.setString(4, cafeDaManha);
            pstmt.setString(5, almoco);
            pstmt.setString(6, jantar);
            pstmt.setString(7, lanches);
            pstmt.setString(8, observacoesAlimentacao);
            pstmt.setString(9, agua);
            pstmt.setString(10, outrosLiquidos);
            pstmt.setString(11, observacoesLiquidos);
            pstmt.setString(12, tipoTreino);
            pstmt.setString(13, duracaoTreino);
            pstmt.setString(14, intensidadeTreino);
            pstmt.setString(15, detalhesExercicio);
            pstmt.setString(16, observacoesExercicio);
            pstmt.setString(17, nivelFome);
            pstmt.setString(18, nivelEnergia);
            pstmt.setString(19, qualidadeSono);
            pstmt.setString(20, observacoesAvaliacao);

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
        responseJson.put("message", "Erro ao executar a operação no banco: " + e.getMessage());
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
