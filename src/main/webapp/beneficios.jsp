<%-- 
    Document   : beneficios
    Created on : 15 de out. de 2024, 16:11:51
    Author     : hugod
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Benefícios</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Roboto&display=swap" rel="stylesheet">
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
            <main class="central-container">
                <div class="page-specific">
                    <h2>Benefícios da Ferramenta IA para Nutricionistas</h2>
                    <ul>
                        <li>Análise de dietas e planejamento nutricional baseado em IA.</li>
                        <li>Otimização do tempo de consulta com sugestões personalizadas.</li>
                        <li>Acompanhamento de evolução e automação de relatórios.</li>
                    </ul>
                </div>
            </main>
        <%@ include file="WEB-INF/jspf/footer.jspf" %>

    </body>
</html>
