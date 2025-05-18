<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Esqueci minha senha</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    </head>
    <body>
        <div class="form-container">
            <h2>Esqueceu sua senha?</h2>
            <form action="${pageContext.request.contextPath}/ForgotPasswordServlet" method="post">
                <label for="email">Digite seu e-mail:</label>
                <input type="email" id="email" name="email" required>
                <button type="submit" class="button-primary">Enviar link de redefinição</button>
            </form>
            <%
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                if ("missing".equals(error)) {
            %>
                <p class="error-message">Por favor, informe um e-mail.</p>
            <% } else if ("exception".equals(error)) { %>
                <p class="error-message">Ocorreu um erro. Tente novamente.</p>
            <% } else if ("1".equals(success)) { %>
                <p class="success-message">Se o e-mail existir, um link de redefinição foi enviado.</p>
            <% } %>
        </div>
    </body>
</html>