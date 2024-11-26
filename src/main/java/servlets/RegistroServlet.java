package servlets;

import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroServlet", urlPatterns = {"/RegistroServlet"})
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtendo os parâmetros do formulário
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha1 = request.getParameter("senha1");
        String senha2 = request.getParameter("senha2");

        // Verifica se os parâmetros obrigatórios estão presentes
        if (nome == null || email == null || senha1 == null || senha2 == null ||
                nome.isEmpty() || email.isEmpty() || senha1.isEmpty() || senha2.isEmpty()) {
            response.sendRedirect("registro.jsp?error=missing");
            return;
        }

        // Verifica se as senhas coincidem
        if (!senha1.equals(senha2)) {
            response.sendRedirect("registro.jsp?error=nomatch");
            return;
        }

        Connection conn = null;
        PreparedStatement psCheck = null;
        PreparedStatement psInsert = null;

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

            // Verificar se o e-mail já existe
            String checkEmailSql = "SELECT id FROM usuario WHERE email = ?";
            psCheck = conn.prepareStatement(checkEmailSql);
            psCheck.setString(1, email);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // E-mail já registrado
                response.sendRedirect("registro.jsp?error=emailtaken");
                return;
            }

            // Gerar o hash da senha com BCrypt
            String senhaCriptografada = BCrypt.hashpw(senha1, BCrypt.gensalt());

            // Inserir novo usuário
            String insertSql = "INSERT INTO usuario (nome, email, senha) VALUES (?, ?, ?)";
            psInsert = conn.prepareStatement(insertSql);
            psInsert.setString(1, nome);
            psInsert.setString(2, email);
            psInsert.setString(3, senhaCriptografada);

            // Executar a inserção
            int result = psInsert.executeUpdate();
            if (result > 0) {
                response.sendRedirect("login.jsp"); // Redireciona para login após sucesso
            } else {
                response.sendRedirect("registro.jsp?error=database"); // Redireciona em caso de falha
            }

        } catch (Exception e) {
            e.printStackTrace(); // Exibe detalhes do erro no console
            response.sendRedirect("registro.jsp?error=exception&message=" + e.getMessage());
        } finally {
            // Fechar recursos
            try {
                if (psCheck != null) psCheck.close();
                if (psInsert != null) psInsert.close();
                if (conn != null && !conn.isClosed()) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("registro.jsp"); // Redireciona para a página de registro
    }

    @Override
    public String getServletInfo() {
        return "Servlet para registro de usuários com senha criptografada.";
    }
}
