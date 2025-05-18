package servlets;

import java.io.IOException;
import java.sql.*;
import java.util.Properties;
import org.mindrot.jbcrypt.BCrypt; // Add the jBCrypt library to your project!
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/ResetPasswordServlet"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String senha1 = request.getParameter("senha1");
        String senha2 = request.getParameter("senha2");

        if (token == null || senha1 == null || senha2 == null || !senha1.equals(senha2)) {
            response.sendRedirect("redefinirSenha.jsp?token=" + (token != null ? token : "") + "&error=invalid");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Properties props = new Properties();

        try {
            // Load DB properties
            try (java.io.InputStream input = getServletContext().getResourceAsStream("/WEB-INF/classes/db.properties")) {
                if (input == null) throw new Exception("Arquivo db.properties não encontrado.");
                props.load(input);
            }
            String url = props.getProperty("db.url");
            String username = props.getProperty("db.username");
            String password = props.getProperty("db.password");
            String driver = props.getProperty("db.driver");
            Class.forName(driver);

            conn = DriverManager.getConnection(url, username, password);

            // Find token
            ps = conn.prepareStatement("SELECT user_id, expires_at FROM password_reset_tokens WHERE token = ?");
            ps.setString(1, token);
            rs = ps.executeQuery();
            if (!rs.next()) {
                response.sendRedirect("redefinirSenha.jsp?error=invalid");
                return;
            }
            int userId = rs.getInt("user_id");
            Timestamp expiresAt = rs.getTimestamp("expires_at");
            if (expiresAt.before(new Timestamp(System.currentTimeMillis()))) {
                response.sendRedirect("redefinirSenha.jsp?error=expired");
                return;
            }

            // Hash the new password
            String senhaCriptografada = BCrypt.hashpw(senha1, BCrypt.gensalt());

            // Update user's password
            PreparedStatement ps2 = conn.prepareStatement("UPDATE usuario SET senha = ? WHERE id = ?");
            ps2.setString(1, senhaCriptografada);
            ps2.setInt(2, userId);
            ps2.executeUpdate();
            ps2.close();

            // Delete used token
            PreparedStatement ps3 = conn.prepareStatement("DELETE FROM password_reset_tokens WHERE token = ?");
            ps3.setString(1, token);
            ps3.executeUpdate();
            ps3.close();

            response.sendRedirect("login.jsp?success=reset");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("redefinirSenha.jsp?token=" + token + "&error=exception");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null && !conn.isClosed()) conn.close(); } catch (Exception e) {}
        }
    }

    // You don't need doGet or processRequest for this servlet, since only POST is used.
}