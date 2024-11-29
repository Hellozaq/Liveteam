package servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "RedefinirSenhaServlet", urlPatterns = {"/RedefinirSenhaServlet"})
public class RedefinirSenhaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioEmail") == null) {
            response.sendRedirect("login.jsp?error=notLoggedIn");
            return;
        }

        String emailUsuario = (String) session.getAttribute("usuarioEmail");
        String senhaAtual = request.getParameter("senhaAtual");
        String novaSenha = request.getParameter("novaSenha");
        String confirmarSenha = request.getParameter("confirmarSenha");

        if (novaSenha == null || confirmarSenha == null || !novaSenha.equals(confirmarSenha)) {
            request.setAttribute("error", "Nova senha e confirmação não coincidem.");
            request.getRequestDispatcher("perfil.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Carregar propriedades de conexão
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

            // Verificar a senha atual
            String sqlVerificaSenha = "SELECT senha FROM usuario WHERE email = ?";
            ps = conn.prepareStatement(sqlVerificaSenha);
            ps.setString(1, emailUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {
                String senhaBanco = rs.getString("senha");
                if (!BCrypt.checkpw(senhaAtual, senhaBanco)) {
                    request.setAttribute("error", "Senha atual incorreta.");
                    request.getRequestDispatcher("perfil.jsp").forward(request, response);
                    return;
                }
            } else {
                response.sendRedirect("login.jsp?error=userNotFound");
                return;
            }

            // Atualizar para a nova senha
            String novaSenhaHash = BCrypt.hashpw(novaSenha, BCrypt.gensalt());
            String sqlAtualizaSenha = "UPDATE usuario SET senha = ? WHERE email = ?";
            try (PreparedStatement psUpdate = conn.prepareStatement(sqlAtualizaSenha)) {
                psUpdate.setString(1, novaSenhaHash);
                psUpdate.setString(2, emailUsuario);
                int rowsUpdated = psUpdate.executeUpdate();
                if (rowsUpdated > 0) {
                    request.setAttribute("success", "Senha redefinida com sucesso.");
                } else {
                    request.setAttribute("error", "Erro ao atualizar a senha. Tente novamente.");
                }
            }

            request.getRequestDispatcher("perfil.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Ocorreu um erro inesperado.");
            request.getRequestDispatcher("perfil.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null && !conn.isClosed()) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para redefinir a senha do usuário.";
    }
}
