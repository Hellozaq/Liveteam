<%-- 
    Document   : registro
    Created on : 15 de out. de 2024, 16:11:40
    Author     : hugod
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registro</title>
        <%@ include file="WEB-INF/jspf/html-head.jspf" %>
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
<main>
    <div class="form-container">
        <h2>Crie sua conta</h2>

        <!-- Exibe mensagens de erro -->
        <%
            String error = request.getParameter("error");
            if (error != null) {
                switch (error) {
                    case "missing":
                        out.println("<p class='error'>Por favor, preencha todos os campos.</p>");
                        break;
                    case "nomatch":
                        out.println("<p class='error'>As senhas não coincidem.</p>");
                        break;
                    case "emailtaken":
                        out.println("<p class='error'>E-mail já está registrado.</p>");
                        break;
                    case "database":
                        out.println("<p class='error'>Erro ao registrar. Tente novamente.</p>");
                        break;
                    case "exception":
                        out.println("<p class='error'>Erro no servidor. Tente mais tarde.</p>");
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

            <button type="submit" class="button-success">Registrar</button>
        </form>

        <p>Já tem um registro? <a href="${pageContext.request.contextPath}/login.jsp">Faça login aqui.</a></p>
    </div>
</main>

        <%@ include file="WEB-INF/jspf/footer.jspf" %>
        
        <script type="text/javascript" src="assets/script/senha.js" defer></script>
    </body>
</html>
