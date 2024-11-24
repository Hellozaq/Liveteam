package servlets;

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
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obter parâmetros do formulário
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

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

            // Estabelecer conexão
            conn = DriverManager.getConnection(url, username, password);

            // Preparar a consulta SQL
            String sql = "SELECT nome, id, senha FROM usuario WHERE email = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            // Executar a consulta e obter o resultado
            rs = ps.executeQuery();

            // Verificar se o usuário foi encontrado
            if (rs.next()) {
                // Recupera a senha armazenada no banco de dados
                String senhaBanco = rs.getString("senha");

                // Verificar se a senha fornecida corresponde à armazenada no banco
                if (senha.equals(senhaBanco)) {
                    // Se a senha estiver correta, recupera os dados do usuário
                    String nomeUsuario = rs.getString("nome");
                    String idUsuario = rs.getString("id");

                    // Criar a sessão do usuário e armazenar as informações
                    HttpSession session = request.getSession();
                    session.invalidate();  // Garantir que a sessão anterior seja invalidada
                    session = request.getSession(true);  // Criar uma nova sessão

                    session.setAttribute("usuarioLogado", nomeUsuario);  // Armazena o nome do usuário na sessão
                    session.setAttribute("idUsuario", idUsuario);        // Armazena o id do usuário na sessão

                    // Redirecionar para a página inicial após login bem-sucedido
                    response.sendRedirect("home.jsp");
                } else {
                    // Senha incorreta
                    System.out.println("Senha incorreta.");
                    response.sendRedirect("login.jsp?error=invalid");
                }
            } else {
                // Usuário não encontrado
                System.out.println("Usuário não encontrado.");
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (SQLException e) {
            // Tratar SQLException
            System.err.println("Erro ao conectar ou executar a query no banco de dados:");
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=exception");
        } catch (ClassNotFoundException e) {
            // Tratar ClassNotFoundException
            System.err.println("Erro ao carregar o driver JDBC:");
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=exception");
        } catch (IOException e) {
            // Tratar IOException
            System.err.println("Erro ao ler propriedades do banco de dados:");
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=exception");
        } catch (Exception e) {
            // Tratar exceções gerais
            System.err.println("Erro inesperado: " + e.getMessage());
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
        // Redireciona para a página de login quando acessado via GET
        response.sendRedirect("login.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para login de usuários.";
    }
}
