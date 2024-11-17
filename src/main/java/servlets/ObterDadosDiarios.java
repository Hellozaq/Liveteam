package servlets;


import org.json.JSONArray;
import org.json.JSONObject;

import com.liveteam.database.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ObterDadosDiarios")
public class ObterDadosDiarios extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtendo os parâmetros passados na URL
        String dia = request.getParameter("dia");
        String mes = request.getParameter("mes");
        String ano = request.getParameter("ano");

        // Configurando o tipo de conteúdo como JSON
        response.setContentType("application/json;charset=UTF-8");

        // Objetos para manipulação da conexão e consulta
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Estabelecendo a conexão com o banco de dados
            conn = DatabaseConnection.getConnection();

            // Consulta SQL
            String sql = "SELECT * FROM dados_diarios WHERE dia = ? AND mes = ? AND ano = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(dia));
            ps.setInt(2, Integer.parseInt(mes));
            ps.setInt(3, Integer.parseInt(ano));

            rs = ps.executeQuery();

            // Criando o array JSON para armazenar os dados
            JSONArray dailyDataArray = new JSONArray();

            // Iterando os resultados da consulta
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
                exercicios.put("duracao", rs.getString("duracao"));
                exercicios.put("intensidade", rs.getString("intensidade"));
                exercicios.put("detalhes", rs.getString("detalhes"));
                exercicios.put("observacoes", rs.getString("observacoes_exercicios"));

                // Avaliação
                JSONObject avaliacao = new JSONObject();
                avaliacao.put("fome", rs.getString("nivel_fome"));
                avaliacao.put("energia", rs.getString("nivel_energia"));
                avaliacao.put("sono", rs.getString("qualidade_sono"));
                avaliacao.put("observacoes", rs.getString("observacoes_avaliacao"));

                // Adicionando os dados ao objeto JSON principal
                dailyData.put("alimentacao", alimentacao);
                dailyData.put("liquidos", liquidos);
                dailyData.put("exercicios", exercicios);
                dailyData.put("avaliacao", avaliacao);

                // Adicionando o objeto diário ao array JSON
                dailyDataArray.put(dailyData);
            }

            // Escrevendo a resposta JSON
            response.getWriter().write(dailyDataArray.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");  // Retorna um array vazio em caso de erro
        } finally {
            // Fechando os recursos de forma segura
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
