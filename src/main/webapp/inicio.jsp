<%-- 
    Document   : inicio
    Created on : 15 de out. de 2024, 16:11:24
    Author     : hugod
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inicio</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
        <main>
            <div class="central-container">
                <div class="page-specific">
                    <h1>Bem-vindo à Nossa Plataforma</h1>
                     <p>Na nossa plataforma, oferecemos ferramentas inovadoras para nutricionistas, permitindo que eles melhorem o atendimento aos pacientes e otimizem suas rotinas.</p>
                    <form action="${pageContext.request.contextPath}/registro.jsp" method="get">
                        <button type="submit" class="button-primary">Comece Agora</button>
                    </form>
                        
                </div>
            </div>
        </main>
        <%@ include file="WEB-INF/jspf/footer.jspf" %>
    </body>
</html>
