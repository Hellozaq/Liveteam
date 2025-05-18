<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String token = request.getParameter("token");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Redefinir Senha</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <%@ include file="WEB-INF/jspf/html-head.jspf" %>
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
        <div class="form-container">
            <h2>Redefina sua senha</h2>
            <form action="${pageContext.request.contextPath}/ResetPasswordServlet" method="post">
                <input type="hidden" name="token" value="<%= token != null ? token : "" %>">
                <label for="senha1">Nova Senha:</label>
                <input type="password" id="senha1" name="senha1" required>
                <label for="senha2">Confirme a Senha:</label>
                <input type="password" id="senha2" name="senha2" required>
                <button type="submit" class="button-success">Redefinir</button>
            </form>
            <% if ("invalid".equals(error)) { %>
                <p class="error-message">Token inválido ou senha não conferem.</p>
            <% } else if ("expired".equals(error)) { %>
                <p class="error-message">Token expirado. Solicite um novo link.</p>
            <% } else if ("exception".equals(error)) { %>
                <p class="error-message">Ocorreu um erro. Tente novamente.</p>
            <% } %>
            <p>Caso não seja redirecionado, <a href="${pageContext.request.contextPath}/login.jsp">faça login aqui.</a></p>
        </div>
        <%@ include file="WEB-INF/jspf/footer.jspf" %>
        <script type="text/javascript" src="assets/script/senha.js" defer></script>
    </body>
</html>