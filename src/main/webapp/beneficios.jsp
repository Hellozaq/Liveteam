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
        <%@ include file="WEB-INF/jspf/html-head.jspf" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Roboto&display=swap" rel="stylesheet">
    </head>
    <body>
        <%@ include file="WEB-INF/jspf/header.jspf" %>
          <main>
           <section class="benefits-page">
            <h2>Benefícios</h2>

            <div class="benefit-item">
                <h3>Planos Alimentares Personalizados</h3>
                <p>
                    Nossa plataforma oferece planos alimentares individualizados, adaptados às suas
                    restrições alimentares, preferências e condições de saúde. As recomendações
                    são continuamente ajustadas para garantir que sua dieta seja sempre adequada às suas
                    necessidades.
                </p>
            </div>

            <div class="benefit-item">
                <h3>Relatórios Nutricionais Detalhados</h3>
                <p>
                    Usuários cadastrados e logados podem acessar relatórios nutricionais personalizados,
                    contendo planos de ingestão de líquidos, receitas ajustadas às suas necessidades,
                    informações calóricas e lista de alimentos a serem evitados para alcançar melhores
                    resultados.
                </p>
            </div>

            <div class="benefit-item">
                <h3>Acompanhamento em Tempo Real</h3>
                <p>
                    Monitore sua ingestão de líquidos, refeições e atividades físicas diárias em um
                    calendário interativo. Receba feedback personalizado da IA e ajustes nas recomendações
                    para manter sua saúde em dia.
                </p>
            </div>

            <div class="benefit-item">
                <h3>Suporte e Atendimento ao Cliente</h3>
                <p>
                    Na área administrativa, você tem acesso a suporte ao vivo, incluindo:
                </p>
                <ul>
                    <li>Chat em tempo real para esclarecer dúvidas.</li>
                    <li>Telefone e e-mail para comunicação com a equipe de suporte.</li>
                </ul>
            </div>

            <div class="benefit-item">
                <h3>Atualização de Informações de Saúde</h3>
                <p>
                    Você pode atualizar seus dados pessoais e de saúde a qualquer momento, permitindo que
                    a plataforma ajuste as recomendações conforme suas necessidades mudam.
                </p>
            </div>

            <div class="benefit-item">
                <h3>Ajuda e Documentação</h3>
                <p>
                    Oferecemos uma seção de ajuda detalhada e documentação para guiá-lo em todas as
                    etapas, desde o cadastro até a personalização de seus planos alimentares e
                    acompanhamento de seu progresso.
                </p>
            </div>

            <div class="benefit-item">
                <h3>Incentivo à Saúde Integral</h3>
                <p>
                    Nossa plataforma incentiva hábitos saudáveis através do monitoramento de atividades
                    físicas, ingestão de líquidos e alimentação equilibrada, promovendo uma saúde integral.
                </p>
            </div>
           </section>
          </main>
        <%@ include file="WEB-INF/jspf/footer.jspf" %>

    </body>
</html>
