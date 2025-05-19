<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Início</title>
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
    <!-- Modern theme and utility CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global/buttons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/utilitarios/effects.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/inicio-page.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/auth-page.css">
    <!-- PHOSPHOR ICONS CDN -->
    <link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.0.3/src/regular/style.css" />
    <script src="${pageContext.request.contextPath}/assets/script/effects.js" defer></script>
</head>
<body data-theme-dark>
    <%@ include file="WEB-INF/jspf/header.jspf" %>
    <main>
        <!-- HERO SECTION -->
        <section class="inicio-page card-tilt parallax-bg reveal-on-scroll" style="margin-bottom: 2rem;">
            <h1 style="margin-bottom: 1.2rem; animation: fadeInHeading 1s;">
              <i class="ph ph-rocket-launch" style="font-size:4rem;color:var(--primary);margin-right:8px;"></i>
              Bem-vindo à Nossa Plataforma
            </h1>
            <p style="font-size:1.16rem; margin-bottom: 1rem;">
                <i class="ph ph-lightbulb" style="font-size: 2rem;color:var(--primary);margin-right:8px;"></i>
                Na nossa plataforma, oferecemos ferramentas inovadoras para nutricionistas, permitindo que eles melhorem o atendimento aos pacientes e otimizem suas rotinas.
            </p>
            <p style="font-size:1.08rem; margin-bottom: 1.8rem;">
                <i class="ph ph-list-checks" style="font-size:2rem;color:var(--primary);margin-right:8px;"></i>
                Explore funcionalidades que incluem criação de planos alimentares personalizados, relatórios detalhados e integração com plataformas de saúde. Tudo isso para facilitar sua rotina e maximizar o atendimento de qualidade.
            </p>
            <form action="${pageContext.request.contextPath}/registro.jsp" method="get">
              <button type="submit" class="button button-primary">
                <i class="ph ph-arrow-right"></i>
                <span style="vertical-align: middle; font-weight: 600;">Comece Agora</span>
              </button>
            </form>
        </section>

        <!-- Seção de Benefícios (HTML Estático) -->
        <section class="benefits-page reveal-on-scroll">
            <div>
                <h2><i class="ph ph-gift"></i>Benefícios</h2>
                <div class="benefit-item card-tilt">
                    <i class="ph ph-user-circle" style="font-size:2rem;color:var(--primary);margin-right:8px;"></i>
                    <div>
                        <h3 style="display:inline">Planos Alimentares Personalizados</h3>
                        <p>Nossa plataforma oferece planos alimentares individualizados, adaptados às suas restrições alimentares, preferências e condições de saúde.</p>
                    </div>
                </div>
                <div class="benefit-item card-tilt">
                    <i class="ph ph-file-text" style="font-size:2rem;color:var(--primary);margin-right:8px;"></i>
                    <div>
                        <h3 style="display:inline">Relatórios Nutricionais Detalhados</h3>
                        <p>Usuários cadastrados e logados podem acessar relatórios nutricionais personalizados com diversas informações importantes.</p>
                    </div>
                </div>
                <div class="benefit-item card-tilt">
                    <i class="ph ph-clock" style="font-size:2rem;color:var(--primary);margin-right:8px;"></i>
                    <div>
                        <h3 style="display:inline">Acompanhamento em Tempo Real</h3>
                        <p>Monitore sua ingestão de líquidos, refeições e atividades físicas com feedback da IA.</p>
                    </div>
                </div>
                <div class="benefit-item card-tilt">
                    <i class="ph ph-headset" style="font-size:2rem;color:var(--primary);margin-right:8px;"></i>
                    <div>
                        <h3 style="display:inline">Suporte e Atendimento ao Cliente</h3>
                        <p>Acesso a suporte via chat, telefone e e-mail na área administrativa.</p>
                    </div>
                </div>
                <div class="benefit-item card-tilt">
                    <i class="ph ph-notebook" style="font-size:2rem;color:var(--primary);margin-right:8px;"></i>
                    <div>
                        <h3 style="display:inline">Atualização de Informações de Saúde</h3>
                        <p>Atualize seus dados a qualquer momento e receba recomendações personalizadas.</p>
                    </div>
                </div>
                <div class="benefit-item card-tilt">
                    <i class="ph ph-question" style="font-size:2rem;color:var(--primary);margin-right:8px;"></i>
                    <div>
                        <h3 style="display:inline">Ajuda e Documentação</h3>
                        <p>Seção de ajuda detalhada para apoiar o uso da plataforma.</p>
                    </div>
                </div>
                <div class="benefit-item card-tilt">
                    <i class="ph ph-heartbeat" style="font-size:2rem;color:var(--primary);margin-right:8px;"></i>
                    <div>
                        <h3 style="display:inline">Incentivo à Saúde Integral</h3>
                        <p>Monitoramento de hábitos saudáveis para uma vida equilibrada.</p>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- SOBRE E CONTATO -->
        <section class="contact-page reveal-on-scroll">
            <h1><i class="ph ph-info"></i> O que é o Liveteam?</h1>
            <p>O Liveteam é uma plataforma que utiliza inteligência artificial para criar planos alimentares personalizados, baseados em suas restrições, exigências e resultados esperados.</p>
            <h2><i class="ph ph-target"></i> O que buscamos com nosso projeto?</h2>
            <p>Com o Liveteam, buscamos auxiliar profissionais da área nutricional a planejar e criar rotinas alimentares saudáveis, além de oferecer um norte para quem deseja começar dietas personalizadas.</p>
            <h2><i class="ph ph-users"></i> Quem somos?</h2>
            <p>A equipe do Liveteam é composta por três desenvolvedores: Victor Hugo Delfino Araújo, Luccas Lima Pierotti e Enzo Uemura Fernandes.</p>
        </section>
        <section class="contact-page reveal-on-scroll">
            <h1><i class="ph ph-users-three"></i> Sobre Nós</h1>
            <p>Bem-vindo à nossa ferramenta de suporte para nutricionistas! Somos dedicados a fornecer soluções que facilitam a prática profissional e melhoram a qualidade do atendimento aos pacientes.</p>
            <h2><i class="ph ph-handshake"></i> Nosso Compromisso</h2>
            <p>Nosso objetivo é utilizar a inteligência artificial para otimizar a experiência dos nutricionistas, oferecendo informações precisas e apoio em suas atividades diárias.</p>
            <h2><i class="ph ph-phone"></i> Entre em Contato Conosco</h2>
            <ul>
                <li>
                  <i class="ph ph-envelope"></i>
                  Email: <a href="mailto:contato@empresa.com">contato@empresa.com</a>
                </li>
                <li>
                  <i class="ph ph-phone"></i>
                  Telefone: <a href="tel:+5511987654321">(11) 98765-4321</a>
                </li>
                <li>
                  <i class="ph ph-globe"></i>
                  Redes Sociais: 
                  <a href="https://facebook.com/empresa" target="_blank"><i class="ph ph-facebook-logo"></i> Facebook</a>, 
                  <a href="https://instagram.com/empresa" target="_blank"><i class="ph ph-instagram-logo"></i> Instagram</a>, 
                  <a href="https://twitter.com/empresa" target="_blank"><i class="ph ph-twitter-logo"></i> Twitter</a>
                </li>
            </ul>
        </section>
        <section class="contact-page reveal-on-scroll">
            <h1><i class="ph ph-question"></i> Perguntas Frequentes</h1>
            <h2><i class="ph ph-brain"></i> Como funciona a IA?</h2>
            <p>A inteligência artificial funciona por meio de algoritmos treinados com grandes volumes de dados. Esses algoritmos aprendem padrões e realizam tarefas como reconhecimento de voz, tomada de decisão, previsão de resultados, entre outros.</p>
            <h2><i class="ph ph-graduation-cap"></i> A IA pode aprender sozinha?</h2>
            <p>Sim. Existem modelos de IA que usam aprendizado de máquina (machine learning), onde o sistema aprende com os dados fornecidos e melhora seu desempenho ao longo do tempo, sem intervenção humana direta.</p>
            <h2><i class="ph ph-user-switch"></i> Ela substitui humanos?</h2>
            <p>Não totalmente. A IA auxilia em tarefas repetitivas e analíticas, mas ainda depende de decisões humanas em muitos contextos. Ela é uma ferramenta de apoio, não uma substituição completa.</p>
            <h2><i class="ph ph-lock-key"></i> É segura?</h2>
            <p>Sim, desde que implementada com responsabilidade. Ética, segurança de dados e supervisão humana são fundamentais no uso da IA.</p>
        </section>
    </main>
    <%@ include file="WEB-INF/jspf/footer.jspf" %>
</body>
</html>