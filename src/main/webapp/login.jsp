<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login</title>
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
          <i class="ph ph-sign-in"></i>
          Faça Login
        </h2>
        <%
          String success = request.getParameter("success");
          String error = request.getParameter("error");
          if ("reset".equals(success)) {
        %>
          <p style="color:var(--primary, #A0D683);font-weight:600;">Senha redefinida com sucesso. Faça login com sua nova senha.</p>
        <% } else if ("invalid".equals(error)) { %>
          <p style="color:#ff5252;font-weight:600;">Email ou senha inválidos.</p>
        <% } %>
        <form action="${pageContext.request.contextPath}/LoginServlet" method="post" style="margin-bottom: 0;">
          <label for="email">Email:</label>
          <input type="email" id="email" name="email" required autocomplete="username">

          <label for="senha">Senha:</label>
          <input type="password" id="senha" name="senha" required autocomplete="current-password">

          <button type="submit" class="button button-primary">Entrar</button>
        </form>
        <p style="margin-top:1.5rem;">Não tem um registro? <a href="${pageContext.request.contextPath}/registro.jsp">Faça seu registro aqui.</a></p>
        <p>Esqueceu sua senha? <a href="${pageContext.request.contextPath}/forgotPassword.jsp">Redefina aqui.</a></p>
      </section>
    </main>
    <%@ include file="WEB-INF/jspf/footer.jspf" %>
  </body>
</html>