package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.sql.*;
import java.util.Properties;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/BuscarUltimoPlano")
public class BuscarUltimoPlanoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuarioEmail") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String email = (String) session.getAttribute("usuarioEmail");
        JSONObject result = new JSONObject();

        try {
            // Carrega propriedades do banco
            Properties props = new Properties();
            InputStream input = getClass().getClassLoader().getResourceAsStream("db.properties");
            if (input == null) throw new Exception("Arquivo db.properties não encontrado.");
            props.load(input);

            Class.forName(props.getProperty("db.driver"));
            try (Connection conn = DriverManager.getConnection(
                    props.getProperty("db.url"), props.getProperty("db.username"), props.getProperty("db.password"))) {

                // Busca ID do usuário
                int idUsuario = -1;
                try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM usuario WHERE email = ?")) {
                    ps.setString(1, email);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) idUsuario = rs.getInt("id");
                    }
                }
                if (idUsuario == -1) throw new Exception("Usuário não encontrado!");

                // Busca o último plano (maior id)
                int planoId = -1;
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT id FROM plano WHERE id_usuario = ? ORDER BY id DESC LIMIT 1")) {
                    ps.setInt(1, idUsuario);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) planoId = rs.getInt("id");
                    }
                }
                if (planoId == -1) {
                    resp.setContentType("application/json");
                    resp.getWriter().write("{\"error\":\"Nenhum preenchimento encontrado.\"}");
                    return;
                }

                // Busca dieta
                JSONObject dietaJson = new JSONObject();
                int dietaId = -1;
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT * FROM dieta WHERE plano_id = ?")) {
                    ps.setInt(1, planoId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            dietaId = rs.getInt("id");
                            dietaJson.put("objetivo", rs.getString("objetivo"));
                            dietaJson.put("calorias_totais", rs.getString("calorias_totais"));
                            dietaJson.put("observacoes", rs.getString("observacoes"));
                        }
                    }
                }
                // Macronutrientes
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT * FROM macronutrientes WHERE dieta_id = ?")) {
                    ps.setInt(1, dietaId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            JSONObject macro = new JSONObject();
                            macro.put("proteinas", rs.getString("proteinas"));
                            macro.put("carboidratos", rs.getString("carboidratos"));
                            macro.put("gorduras", rs.getString("gorduras"));
                            dietaJson.put("macronutrientes", macro);
                        }
                    }
                }
                // Refeições
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT * FROM refeicoes WHERE dieta_id = ?")) {
                    ps.setInt(1, dietaId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            JSONObject refeicoes = new JSONObject();
                            refeicoes.put("cafe_da_manha", rs.getString("cafe_da_manha"));
                            refeicoes.put("almoco", rs.getString("almoco"));
                            refeicoes.put("lanche_tarde", rs.getString("lanche_tarde"));
                            refeicoes.put("jantar", rs.getString("jantar"));
                            dietaJson.put("refeicoes", refeicoes);
                        }
                    }
                }
                result.put("dieta", dietaJson);

                // Busca treino
                JSONObject treinoJson = new JSONObject();
                int treinoId = -1;
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT * FROM treino WHERE plano_id = ?")) {
                    ps.setInt(1, planoId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            treinoId = rs.getInt("id");
                            treinoJson.put("divisao", rs.getString("divisao"));
                            treinoJson.put("justificativa_divisao", rs.getString("justificativa_divisao"));
                            treinoJson.put("observacoes", rs.getString("observacoes"));
                        }
                    }
                }

                // Subtreinos e exercícios
                JSONArray subtreinosArray = new JSONArray();
                if (treinoId != -1) {
                    try (PreparedStatement ps = conn.prepareStatement(
                            "SELECT * FROM subtreino WHERE treino_id = ?")) {
                        ps.setInt(1, treinoId);
                        try (ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                                JSONObject subtreino = new JSONObject();
                                int subtreinoId = rs.getInt("id");
                                subtreino.put("nome", rs.getString("nome"));
                                subtreino.put("foco", rs.getString("foco"));

                                // Exercícios do subtreino
                                JSONArray exerciciosArray = new JSONArray();
                                try (PreparedStatement psEx = conn.prepareStatement(
                                        "SELECT * FROM exercicio WHERE subtreino_id = ?")) {
                                    psEx.setInt(1, subtreinoId);
                                    try (ResultSet rsEx = psEx.executeQuery()) {
                                        while (rsEx.next()) {
                                            JSONObject ex = new JSONObject();
                                            ex.put("nome", rsEx.getString("nome"));
                                            ex.put("series", rsEx.getString("series"));
                                            ex.put("repeticoes", rsEx.getString("repeticoes"));
                                            exerciciosArray.put(ex);
                                        }
                                    }
                                }
                                subtreino.put("exercicios", exerciciosArray);
                                subtreinosArray.put(subtreino);
                            }
                        }
                    }
                }
                treinoJson.put("subtreinos", subtreinosArray);
                result.put("treino", treinoJson);

                // Retorna JSON
                resp.setContentType("application/json");
                resp.getWriter().write(result.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"Erro ao buscar dados.\"}");
        }
    }
}