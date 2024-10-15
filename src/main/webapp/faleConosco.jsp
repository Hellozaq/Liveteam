<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Fale Conosco</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"> 
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Roboto&display=swap" rel="stylesheet">
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
        <main class="central-container">
            <div class="page-specific">
                <h1>Sobre Nós</h1>
                <p>Bem-vindo à nossa ferramenta de suporte para nutricionistas! Somos dedicados a fornecer soluções que facilitam a prática profissional e melhoram a qualidade do atendimento aos pacientes.</p>

                <h2>Nosso Compromisso</h2>
                <p>Nosso objetivo é utilizar a inteligência artificial para otimizar a experiência dos nutricionistas, oferecendo informações precisas e apoio em suas atividades diárias.</p>

                <h2>Entre em Contato Conosco</h2>
                <p>Você pode entrar em contato conosco através dos seguintes meios:</p>
                <ul>
                    <li>Email: <a href="mailto:contato@empresa.com">contato@empresa.com</a></li>
                    <li>Telefone: <a href="tel:+5511987654321">(11) 98765-4321</a></li>
                    <li>Redes Sociais: 
                        <a href="https://facebook.com/empresa" target="_blank">Facebook</a>, 
                        <a href="https://instagram.com/empresa" target="_blank">Instagram</a>, 
                        <a href="https://twitter.com/empresa" target="_blank">Twitter</a>
                    </li>
                </ul>
            </div>
        </main>
        <%@ include file="WEB-INF/jspf/footer.jspf" %>
    </body>
</html>
