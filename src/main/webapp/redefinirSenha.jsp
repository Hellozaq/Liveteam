<%-- 
    Document   : redefinirSenha
    Created on : 23 de out. de 2024, 20:55:32
    Author     : hugod
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Redefinir Senha</title>
        <%@ include file="WEB-INF/jspf/html-head.jspf" %>
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
        <main>
            <div class="form-container">
                <h2>Redefina a sua senha</h2>
                <form action="${pageContext.request.contextPath}/login.jsp" method="post">
                    
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>
                    
                    <label for="senha">Senha:</label>
                    <input type="password" id="senha1" name="senha1" required>

                    <label for="senha">Confirme a Senha:</label>
                    <input type="password" id="senha2" name="senha2" required>

                    <button type="submit" class="button-success">Redefinir</button>
                </form>
                    <p>Caso não seja redirecionado, <a href="${pageContext.request.contextPath}/login.jsp">faça login aqui.</a></p> 
            </div>
        </main>
        <%@ include file="WEB-INF/jspf/footer.jspf" %>
        
         <script type="text/javascript" src="assets/script/senha.js" defer></script>
    </body>
</html>
