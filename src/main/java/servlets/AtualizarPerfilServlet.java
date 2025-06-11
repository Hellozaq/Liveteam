package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/atualizarPerfil")
public class AtualizarPerfilServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Obtém o id do usuário da sessão
        Integer idUsuario = (session != null) ? (Integer) session.getAttribute("id_usuario") : null;
        // Também tenta obter o email do usuário da sessão, caso queira usar por email
        String emailUsuario = (session != null) ? (String) session.getAttribute("usuarioEmail") : null;

        if (idUsuario == null && (emailUsuario == null || emailUsuario.isEmpty())) {
            response.sendRedirect("login.jsp?error=naoLogado");
            return;
        }

        // Pega as informações do formulário
        String idade = request.getParameter("idade");
        String alturaCm = request.getParameter("altura_cm");
        String pesoKg = request.getParameter("peso_kg");

        // Atualiza os dados no banco
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            Properties props = new Properties();
            props.load(getServletContext().getResourceAsStream("/WEB-INF/classes/db.properties"));

            Class.forName(props.getProperty("db.driver"));
            conn = DriverManager.getConnection(
                props.getProperty("db.url"),
                props.getProperty("db.username"),
                props.getProperty("db.password")
            );

            // Atualiza por id se id_usuario existir, senão por email
            String sql;
            if (idUsuario != null) {
                sql = "UPDATE usuario SET idade = ?, altura_cm = ?, peso_kg = ? WHERE id = ?";
            } else {
                sql = "UPDATE usuario SET idade = ?, altura_cm = ?, peso_kg = ? WHERE email = ?";
            }
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(idade));
            pstmt.setBigDecimal(2, new java.math.BigDecimal(alturaCm));
            pstmt.setBigDecimal(3, new java.math.BigDecimal(pesoKg));
            if (idUsuario != null) {
                pstmt.setInt(4, idUsuario);
            } else {
                pstmt.setString(4, emailUsuario);
            }

            pstmt.executeUpdate();

            response.sendRedirect("perfil.jsp?status=ok");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("perfil.jsp?status=erro");
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}