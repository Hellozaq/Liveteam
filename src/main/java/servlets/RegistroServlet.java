package servlets;

import com.liveteam.database.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
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
        String senha = request.getParameter("senha1");

        // Conexão com o banco de dados e inserção do usuário
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement("INSERT INTO usuario (nome, email, senha) VALUES (?, ?, ?)")) {

            ps.setString(1, nome);
            ps.setString(2, email);
            ps.setString(3, senha); // Em produção, recomenda-se armazenar a senha com hashing

            // Executar a inserção
            int result = ps.executeUpdate();
            if (result > 0) {
                response.sendRedirect("login.jsp"); // Redireciona para a página de login
            } else {
                response.sendRedirect("registro.jsp?error=database"); // Redireciona em caso de erro
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("registro.jsp?error=exception"); // Redireciona em caso de exceção
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("registro.jsp"); // Redireciona para a página de registro
    }

    @Override
    public String getServletInfo() {
        return "Servlet para registro de usuários.";
    }
}