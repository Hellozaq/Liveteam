<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Início</title>
        <%@ include file="WEB-INF/jspf/html-head.jspf" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">        
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
        <main>
            <!-- Carrossel no topo do main -->
            <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
                <ol class="carousel-indicators">
                    <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
                    <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
                    <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
                </ol>
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img class="d-block w-100" src="${pageContext.request.contextPath}/assets/img/ingredientes-para-alimentos-saudaveis.jpg" alt="First slide">
                        <div class="carousel-caption d-none d-md-block">
                            <h5>Título do Primeiro Slide</h5>
                            <p>Descrição do primeiro slide.</p>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img class="d-block w-100" src="${pageContext.request.contextPath}/assets/img/ingredientes-para-alimentos-saudaveis.jpg" alt="Second slide">
                        <div class="carousel-caption d-none d-md-block">
                            <h5>Título do Segundo Slide</h5>
                            <p>Descrição do segundo slide.</p>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img class="d-block w-100" src="${pageContext.request.contextPath}/assets/img/ingredientes-para-alimentos-saudaveis.jpg" alt="Third slide">
                        <div class="carousel-caption d-none d-md-block">
                            <h5>Título do Terceiro Slide</h5>
                            <p>Descrição do terceiro slide.</p>
                        </div>
                    </div>
                </div>
                <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="sr-only">Next</span>
                </a>
            </div>

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
