package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "PerfilUsuario", urlPatterns = {"/PerfilUsuario"})
public class PerfilUsuario extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("usuarioEmail") != null) {
            String emailUsuario = (String) session.getAttribute("usuarioEmail");

            System.out.println("Email obtido na sessão: " + emailUsuario);

            request.setAttribute("emailUsuario", emailUsuario);
            request.getRequestDispatcher("perfil.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp?error=notLoggedIn");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para exibir perfil do usuário logado.";
    }
}
