<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home</title>
        <%@ include file="WEB-INF/jspf/html-head.jspf" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Roboto&display=swap" rel="stylesheet">
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
        <main>
            <div class="home-page">
                <h1>Bem-vindo!</h1>
                <p>Estamos felizes em tê-lo conosco. Nossa plataforma oferece soluções inovadoras para nutricionistas, ajudando você a oferecer um atendimento de qualidade aos seus pacientes.</p>
                
                <h2>Sobre Nosso Produto</h2>
                <p>Nosso produto é uma ferramenta inteligente que utiliza inteligência artificial para auxiliar nutricionistas em suas rotinas diárias. Ele proporciona:</p>
                <ul>
                    <li><strong>Agilidade:</strong> Facilita a criação de planos alimentares personalizados e otimizados.</li>
                    <li><strong>Precisão:</strong> Fornece informações nutricionais atualizadas e detalhadas.</li>
                    <li><strong>Integração:</strong> Possui recursos que se integram a outras plataformas utilizadas na área da saúde.</li>
                </ul>

                <h2>Benefícios de Usar Nossa Plataforma</h2>
                <p>Ao escolher nossa solução, você terá acesso a diversos benefícios, incluindo:</p>
                <ul>
                    <li>Maior eficiência no atendimento ao paciente.</li>
                    <li>Relatórios e análises personalizadas que ajudam no acompanhamento do progresso.</li>
                    <li>Suporte técnico dedicado para auxiliá-lo em todas as etapas.</li>
                </ul>

                <h2>Pronto para Começar?</h2>
                <p>Explore todas as funcionalidades da nossa plataforma.</p>
            </div>
        </main>
        <%@ include file="WEB-INF/jspf/footer.jspf" %>
    </body>
</html>
