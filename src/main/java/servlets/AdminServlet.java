package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

import com.liveteam.database.DatabaseConnection;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * GET /admin — exibe a página de administração apenas para administradores.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp?error=notLogged");
            return;
        }

        // Tenta obter o role da sessão; se não existir, carrega do banco
        String userEmail = (String) session.getAttribute("usuarioEmail");
        String userRole  = (String) session.getAttribute("userRole");
        if (userRole == null) {
            try {
                userRole = DatabaseConnection.getUserRole(userEmail);
                session.setAttribute("userRole", userRole);
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("perfil.jsp");
                return;
            }
        }

        // Se não for administrador, redireciona para perfil
        if (!"administrador".equals(userRole)) {
            response.sendRedirect("perfil.jsp");
            return;
        }

        // Usuário é admin: exibe admin.jsp
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    /**
     * POST /admin — trata ações de deleteUser, addUser e updateUserRole.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp?error=notLogged");
            return;
        }

        String action = request.getParameter("action");
        try {
            switch (action) {
                case "deleteUser":
                    handleDelete(request, response);
                    return;

                case "addUser":
                    handleAdd(request, response);
                    return;

                case "updateUser":               
                    handleUpdateUser(request, response);
                    return;

                default:
                    request.setAttribute("errorMsg", "Ação inválida.");
                    request.getRequestDispatcher("/admin.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "ID de usuário inválido.");
            request.getRequestDispatcher("/admin.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Erro ao acessar o banco de dados.");
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String idParam = request.getParameter("userId");
        if (idParam == null || idParam.isEmpty()) {
            request.setAttribute("errorMsg", "Nenhum ID de usuário fornecido.");
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
            return;
        }

        int userId = Integer.parseInt(idParam);
        DatabaseConnection.deleteUser(userId);
        response.sendRedirect("admin.jsp");
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String nome  = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String role  = request.getParameter("role");

        if (nome == null || nome.isEmpty() ||
            email == null || email.isEmpty() ||
            senha == null || senha.isEmpty() ||
            role == null || role.isEmpty()) {

            request.setAttribute("errorMsg", "Todos os campos são obrigatórios.");
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
            return;
        }

        DatabaseConnection.addUser(nome, email, senha, role);
        response.sendRedirect("admin.jsp");
    }

    private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String idParam = request.getParameter("userId");
        String nome    = request.getParameter("nome");
        String email   = request.getParameter("email");
        String senha   = request.getParameter("senha"); // pode ser vazio (sem alteração)
        String role    = request.getParameter("role");

        if (idParam == null || idParam.isEmpty() ||
            nome == null || nome.isEmpty() ||
            email == null || email.isEmpty() ||
            role == null || role.isEmpty()) {

            request.setAttribute("errorMsg", "Todos os campos, exceto senha, são obrigatórios.");
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
            return;
        }

        if (!"usuario".equals(role) && !"administrador".equals(role)) {
            request.setAttribute("errorMsg", "Role inválida.");
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
            return;
        }

        int userId = Integer.parseInt(idParam);
        DatabaseConnection.updateUser(userId, nome, email, senha, role);
        response.sendRedirect("admin.jsp");
    }
}
