package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.time.LocalDate;
import java.util.Properties;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idUsuario = -1;
        HttpSession session = request.getSession(false);

        if (session != null) {
            Object idObj = session.getAttribute("idUsuario");

            if (idObj != null) {
                try {
                    idUsuario = Integer.parseInt(idObj.toString());
                    System.out.println("ID do usuário na sessão: " + idUsuario);
                } catch (NumberFormatException e) {
                    System.err.println("ID inválido na sessão.");
                    response.sendRedirect("login.jsp?error=idInvalido");
                    return;
                }
            } else {
                System.err.println("idUsuario ausente na sessão.");
                response.sendRedirect("login.jsp?error=naoLogado");
                return;
            }
        } else {
            System.err.println("Sessão inexistente.");
            response.sendRedirect("login.jsp?error=naoLogado");
            return;
        }

        LocalDate today = LocalDate.now();
        int dia = today.getDayOfMonth();
        int mes = today.getMonthValue();
        int ano = today.getYear();

        Connection conn = null;

        try {
            Properties props = new Properties();
            try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/classes/db.properties")) {
                props.load(input);
            }

            Class.forName(props.getProperty("db.driver"));
            conn = DriverManager.getConnection(
                    props.getProperty("db.url"),
                    props.getProperty("db.username"),
                    props.getProperty("db.password")
            );

            String sql = "SELECT * FROM dados_diarios WHERE id_usuario = ? AND dia = ? AND mes = ? AND ano = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, dia);
            stmt.setInt(3, mes);
            stmt.setInt(4, ano);

            ResultSet rs = stmt.executeQuery();
            int cafe = 0, almoco = 0, jantar = 0, lanches = 0;
            if (rs.next()) {
                cafe = rs.getInt("cafe_da_manha_calorias");
                almoco = rs.getInt("almoco_calorias");
                jantar = rs.getInt("jantar_calorias");
                lanches = rs.getInt("lanches_calorias");
                request.setAttribute("cafe", cafe);
                request.setAttribute("almoco", almoco);
                request.setAttribute("jantar", jantar);
                request.setAttribute("lanches", lanches);
                request.setAttribute("agua", rs.getString("agua"));
                request.setAttribute("energia", rs.getString("nivel_energia"));
                request.setAttribute("sono", rs.getString("qualidade_sono"));
            } else {
                // Se não houver dados do dia, envie 0 para as calorias
                request.setAttribute("cafe", 0);
                request.setAttribute("almoco", 0);
                request.setAttribute("jantar", 0);
                request.setAttribute("lanches", 0);
                request.setAttribute("agua", "");
                request.setAttribute("energia", "");
                request.setAttribute("sono", "");
            }

            int totalCalorias = cafe + almoco + jantar + lanches;
            request.setAttribute("totalCalorias", totalCalorias);

            // Buscar meta de calorias do usuário (última dieta cadastrada)
            String metaSql = "SELECT d.calorias_totais FROM dieta d " +
                             "JOIN plano p ON d.plano_id = p.id " +
                             "WHERE p.id_usuario = ? ORDER BY d.id DESC LIMIT 1";
            try (PreparedStatement metaStmt = conn.prepareStatement(metaSql)) {
                metaStmt.setInt(1, idUsuario);
                ResultSet metaRs = metaStmt.executeQuery();
                if (metaRs.next()) {
                    String metaCaloriasStr = metaRs.getString("calorias_totais");
                    int metaCalorias = 0;
                    try {
                        metaCalorias = Integer.parseInt(metaCaloriasStr.replaceAll("[^0-9]", ""));
                    } catch (Exception e) { metaCalorias = 0; }
                    request.setAttribute("metaCalorias", metaCalorias);
                } else {
                    request.setAttribute("metaCalorias", 0);
                }
            }

        } catch (IOException | ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null && !conn.isClosed()) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
