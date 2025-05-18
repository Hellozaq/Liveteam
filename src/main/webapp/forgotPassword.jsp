<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Esqueci minha senha</title>
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
          <i class="ph ph-key"></i>
          Esqueceu sua senha?
        </h2>
        <form action="${pageContext.request.contextPath}/ForgotPasswordServlet" method="post">
          <label for="email">Digite seu e-mail:</label>
          <input type="email" id="email" name="email" required>
          <button type="submit" class="button button-primary">Enviar link de redefinição</button>
        </form>
        <%
          String error = request.getParameter("error");
          String success = request.getParameter("success");
          if ("missing".equals(error)) {
        %>
          <p style="color:#ff5252;font-weight:600;">Por favor, informe um e-mail.</p>
        <% } else if ("exception".equals(error)) { %>
          <p style="color:#ff5252;font-weight:600;">Ocorreu um erro. Tente novamente.</p>
        <% } else if ("1".equals(success)) { %>
          <p style="color:var(--primary,#A0D683);font-weight:600;">Se o e-mail existir, um link de redefinição foi enviado.</p>
        <% } %>
        <p style="margin-top:1.5rem;"><a href="${pageContext.request.contextPath}/login.jsp">Voltar para login</a></p>
      </section>
    </main>
    <%@ include file="WEB-INF/jspf/footer.jspf" %>
  </body>
</html>