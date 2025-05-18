<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Registro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/auth-page.css">
    <link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.0.3/src/regular/style.css" />
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
  </head>
  <body style="background: var(--surface);">
    <%@ include file="WEB-INF/jspf/header.jspf" %>
    <main>
      <section class="inicio-page card-tilt reveal-on-scroll" style="max-width:420px;margin:48px auto;">
        <h2>
          <i class="ph ph-user-plus"></i>
          Crie sua conta
        </h2>

        <!-- Exibe mensagens de erro -->
        <%
            String error = request.getParameter("error");
            if (error != null) {
                switch (error) {
                    case "missing":
                        out.println("<p style='color:#ff5252;font-weight:600;'>Por favor, preencha todos os campos.</p>");
                        break;
                    case "nomatch":
                        out.println("<p style='color:#ff5252;font-weight:600;'>As senhas não coincidem.</p>");
                        break;
                    case "emailtaken":
                        out.println("<p style='color:#ff5252;font-weight:600;'>E-mail já está registrado.</p>");
                        break;
                    case "database":
                        out.println("<p style='color:#ff5252;font-weight:600;'>Erro ao registrar. Tente novamente.</p>");
                        break;
                    case "exception":
                        out.println("<p style='color:#ff5252;font-weight:600;'>Erro no servidor. Tente mais tarde.</p>");
                        break;
                }
            }
        %>

        <form action="${pageContext.request.contextPath}/RegistroServlet" method="post">
            <label for="nome">Nome:</label>
            <input type="text" id="nome" name="nome" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>

            <label for="senha1">Senha:</label>
            <input type="password" id="senha1" name="senha1" required>

            <label for="senha2">Repetir a Senha:</label>
            <input type="password" id="senha2" name="senha2" required>

            <button type="submit" class="button button-primary">Registrar</button>
        </form>

        <p style="margin-top:1.5rem;">Já tem um registro? <a href="${pageContext.request.contextPath}/login.jsp">Faça login aqui.</a></p>
      </section>
    </main>
    <%@ include file="WEB-INF/jspf/footer.jspf" %>
    <script type="text/javascript" src="assets/script/senha.js" defer></script>
  </body>
</html>