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

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
// Capturar parâmetros do usuário
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        // Validação de inputs
        if (email == null || email.trim().isEmpty() || senha == null || senha.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=empty");
            return;
        }

        // Normalizar email (remover espaços e converter para minúsculas)
        email = email.trim().toLowerCase();

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
            // Conectar ao banco
            conn = DriverManager.getConnection(url, username, password);

             // Consulta SQL
            String sql = "SELECT nome, id, senha, role FROM usuario WHERE email = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            // Executar a consulta
            rs = ps.executeQuery();

            if (rs.next()) {
                String senhaBanco = rs.getString("senha");

                // Comparar a senha fornecida com o hash no banco
                if (BCrypt.checkpw(senha, senhaBanco)) {
                    String nomeUsuario = rs.getString("nome");
                    String idUsuario = rs.getString("id");
                    String roleUsuario = rs.getString("role");

                     // Criar uma nova sessão
                    HttpSession session = request.getSession();
                    session.setAttribute("usuarioLogado", nomeUsuario);
                    session.setAttribute("idUsuario", idUsuario);
                    session.setAttribute("usuarioEmail", email);
                    session.setAttribute("usuarioRole", roleUsuario);

                    System.out.println("Email configurado na sessão: " + email);

                    response.sendRedirect("home.jsp");
                } else {
                     // Senha incorreta
                    System.out.println("Senha incorreta para o email: " + email);
                    response.sendRedirect("login.jsp?error=invalid");
                }
            } else {
                // Usuário não encontrado
                System.out.println("Usuário não encontrado: " + email);
                response.sendRedirect("login.jsp?error=invalid");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=exception");
        } finally {
            // Fechar recursos
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para login de usuários.";
    }
}
