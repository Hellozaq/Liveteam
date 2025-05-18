<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String token = request.getParameter("token");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Redefinir Senha</title>
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
          <i class="ph ph-lock-key"></i>
          Redefina sua senha
        </h2>
        <form action="${pageContext.request.contextPath}/ResetPasswordServlet" method="post">
          <input type="hidden" name="token" value="<%= token != null ? token : "" %>">
          <label for="senha1">Nova Senha:</label>
          <input type="password" id="senha1" name="senha1" required>
          <label for="senha2">Confirme a Senha:</label>
          <input type="password" id="senha2" name="senha2" required>
          <button type="submit" class="button button-primary">Redefinir</button>
        </form>
        <% if ("invalid".equals(error)) { %>
          <p style="color:#ff5252;font-weight:600;">Token inválido ou senha não conferem.</p>
        <% } else if ("expired".equals(error)) { %>
          <p style="color:#ff5252;font-weight:600;">Token expirado. Solicite um novo link.</p>
        <% } else if ("exception".equals(error)) { %>
          <p style="color:#ff5252;font-weight:600;">Ocorreu um erro. Tente novamente.</p>
        <% } %>
        <p style="margin-top:1.5rem;">Caso não seja redirecionado, <a href="${pageContext.request.contextPath}/login.jsp">faça login aqui.</a></p>
      </section>
    </main>
    <%@ include file="WEB-INF/jspf/footer.jspf" %>
    <script type="text/javascript" src="assets/script/senha.js" defer></script>
  </body>
</html>