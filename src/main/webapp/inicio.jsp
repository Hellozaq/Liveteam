<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Início</title>
        <%@ include file="WEB-INF/jspf/html-head.jspf" %>        
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
        <main>
            <div class="inicio-page">
                <h1>Bem-vindo à Nossa Plataforma</h1>
                <p>Na nossa plataforma, oferecemos ferramentas inovadoras para nutricionistas, permitindo que eles melhorem o atendimento aos pacientes e otimizem suas rotinas.</p>
                <p>Explore funcionalidades que incluem criação de planos alimentares personalizados, relatórios detalhados e integração com plataformas de saúde. Tudo isso para facilitar sua rotina e maximizar o atendimento de qualidade.</p>
                
                <form action="${pageContext.request.contextPath}/registro.jsp" method="get">
                    <button type="submit" class="button-success">Comece Agora</button>
                </form>
            </div>
        </main>
        <%@ include file="WEB-INF/jspf/footer.jspf" %>
    </body>
</html>
