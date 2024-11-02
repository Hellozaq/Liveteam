package servlets;

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

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement("SELECT * FROM usuario WHERE email = ? AND senha = ?")) {
            
            ps.setString(1, email);
            ps.setString(2, senha);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogado", email);

                response.sendRedirect("home.jsp");
            } else {
                System.out.println("Usuário não encontrado ou senha incorreta.");
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (SQLException e) {
            System.err.println("Erro ao conectar ou executar a query no banco de dados:");
            e.printStackTrace();  // Log completo da exceção
            response.sendRedirect("login.jsp?error=exception");
        } catch (Exception e) {
            System.err.println("Erro inesperado: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=exception");
        }
    }
}
