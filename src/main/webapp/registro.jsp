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
                <form action="${pageContext.request.contextPath}/login.jsp" method="post">
                    <label for="nome">Nome:</label>
                    <input type="text" id="nome" name="nome" required>

                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>

                    <label for="senha">Senha:</label>
                    <input type="password" id="senha" name="senha" required>

                    <button type="submit" class="button-success">Registrar</button>
                </form>
                    <p>Já tem um registro? <a href="${pageContext.request.contextPath}/login.jsp">Faça login aqui.</a></p> 
            </div>
        </main>
        <%@ include file="WEB-INF/jspf/footer.jspf" %>

    </body>
</html>
