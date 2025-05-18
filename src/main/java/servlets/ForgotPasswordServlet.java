package servlets;

import java.io.IOException;
import java.util.UUID;
import java.sql.*;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.mail.*;
import jakarta.mail.internet.*;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String email = request.getParameter("email");
        if (email == null || email.isEmpty()) {
            response.sendRedirect("forgotPassword.jsp?error=missing");
            return;
        }

        String token = UUID.randomUUID().toString();
        long expiry = System.currentTimeMillis() + 1000 * 60 * 60; // 1 hour

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Properties props = new Properties();

        try {
            // Carregar propriedades do banco E do email
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

            ps = conn.prepareStatement("SELECT id FROM usuario WHERE email = ?");
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                int userId = rs.getInt("id");

                // Insere token e expiração na tabela
                PreparedStatement ps2 = conn.prepareStatement(
                  "INSERT INTO password_reset_tokens (user_id, token, expires_at) VALUES (?, ?, ?)");
                ps2.setInt(1, userId);
                ps2.setString(2, token);
                ps2.setTimestamp(3, new Timestamp(expiry));
                ps2.executeUpdate();
                ps2.close();

                // Monta o link de redefinição
                String link = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                        + request.getContextPath() + "/redefinirSenha.jsp?token=" + token;
                sendResetEmail(email, link, props);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?error=exception");
            return;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null && !conn.isClosed()) conn.close(); } catch (Exception e) {}
        }

        // Sempre mostra mensagem de sucesso
        response.sendRedirect("forgotPassword.jsp?success=1");
    }

    private void sendResetEmail(String toEmail, String link, Properties props) throws MessagingException {
        String subject = "Recuperação de senha - Liveteam";
        String body = "Olá!\n\n"
            + "Recebemos uma solicitação para redefinir a senha da sua conta Liveteam.\n"
            + "Para criar uma nova senha, clique no link abaixo:\n\n"
            + link + "\n\n"
            + "Se você não solicitou a redefinição de senha, ignore este e-mail.\n\n"
            + "Atenciosamente,\nEquipe Liveteam";

        // Carrega as propriedades do email
        final String fromEmail = props.getProperty("mail.smtp.user");
        final String mailPassword = props.getProperty("mail.smtp.password");

        Properties mailProps = new Properties();
        mailProps.put("mail.smtp.host", props.getProperty("mail.smtp.host", "smtp.gmail.com"));
        mailProps.put("mail.smtp.port", props.getProperty("mail.smtp.port", "587"));
        mailProps.put("mail.smtp.auth", "true");
        mailProps.put("mail.smtp.starttls.enable", "true");
        
        mailProps.put("mail.smtp.ssl.socketFactory", new TrustAllSSLSocketFactory());
        mailProps.put("mail.smtp.ssl.checkserveridentity", "false");

        Session session = Session.getInstance(mailProps, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, mailPassword);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setText(body);
        Transport.send(message);
    }
}