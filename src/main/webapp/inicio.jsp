<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Início</title>
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/inicio-page.css">
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
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

        <!-- Seção de Benefícios (Vue.js) -->
        <section id="benefits-app" class="benefits-page">
            <div class="global-vue">
                <h2 :class="{ 'animate': isLoaded[0] }">Benefícios</h2>
                
                <div v-for="(benefit, index) in benefits" :key="index" class="benefit-item">
                    <h3 :class="{ 'animate': isLoaded[index + 1] }">{{ benefit.title }}</h3>
                    <p :class="{ 'animate': isLoaded[index + 1 + benefits.length] }">{{ benefit.description }}</p>
                </div>
            </div>
        </section>
        
        <div class="contact-page">
                      <h1>O que é o Liveteam?</h1>
                      <p>O Liveteam é uma plataforma que utiliza inteligência artificial para criar planos alimentares personalizados, 
                      baseados em suas restrições, exigências e resultados esperados.</p>

                      <h2>O que buscamos com nosso projeto?</h2>
                      <p>Com o Liveteam, buscamos auxiliar profissionais da área nutricional a planejar e criar rotinas alimentares saudáveis, 
                      além de oferecer um norte para quem deseja começar dietas personalizadas.</p>

                      <h2>Quem somos?</h2>
                      <p>A equipe do Liveteam é composta por três desenvolvedores: Victor Hugo Delfino Araújo, 
                      Luccas Lima Pierotti e Enzo Uemura Fernandes.</p>
                  </div>
        
           <div class="contact-page">
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
        <section class="contact-page">
          <h1>Perguntas Frequentes</h1>

          <h2>Como funciona a IA?</h2>
          <p>A inteligência artificial funciona por meio de algoritmos treinados com grandes volumes de dados. Esses algoritmos aprendem padrões e realizam tarefas como reconhecimento de voz, tomada de decisão, previsão de resultados, entre outros.</p>

          <h2>A IA pode aprender sozinha?</h2>
          <p>Sim. Existem modelos de IA que usam aprendizado de máquina (machine learning), onde o sistema aprende com os dados fornecidos e melhora seu desempenho ao longo do tempo, sem intervenção humana direta.</p>

          <h2>Ela substitui humanos?</h2>
          <p>Não totalmente. A IA auxilia em tarefas repetitivas e analíticas, mas ainda depende de decisões humanas em muitos contextos. Ela é uma ferramenta de apoio, não uma substituição completa.</p>

          <h2>É segura?</h2>
          <p>Sim, desde que implementada com responsabilidade. Ética, segurança de dados e supervisão humana são fundamentais no uso da IA.</p>
        </section>
    </main>

    <%@ include file="WEB-INF/jspf/footer.jspf" %>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    isLoaded: Array(15).fill(false),
                    benefits: [
                        {
                            title: 'Planos Alimentares Personalizados',
                            description: 'Nossa plataforma oferece planos alimentares individualizados, adaptados às suas restrições alimentares, preferências e condições de saúde.'
                        },
                        {
                            title: 'Relatórios Nutricionais Detalhados',
                            description: 'Usuários cadastrados e logados podem acessar relatórios nutricionais personalizados com diversas informações importantes.'
                        },
                        {
                            title: 'Acompanhamento em Tempo Real',
                            description: 'Monitore sua ingestão de líquidos, refeições e atividades físicas com feedback da IA.'
                        },
                        {
                            title: 'Suporte e Atendimento ao Cliente',
                            description: 'Acesso a suporte via chat, telefone e e-mail na área administrativa.'
                        },
                        {
                            title: 'Atualização de Informações de Saúde',
                            description: 'Atualize seus dados a qualquer momento e receba recomendações personalizadas.'
                        },
                        {
                            title: 'Ajuda e Documentação',
                            description: 'Seção de ajuda detalhada para apoiar o uso da plataforma.'
                        },
                        {
                            title: 'Incentivo à Saúde Integral',
                            description: 'Monitoramento de hábitos saudáveis para uma vida equilibrada.'
                        }
                    ]
                };
            },
            mounted() {
                this.animateElements();
            },
            methods: {
                animateElements() {
                    this.isLoaded.forEach((_, index) => {
                        setTimeout(() => {
                            this.isLoaded[index] = true;
                        }, index * 75);
                    });
                }
            }
        });
        app.mount('#benefits-app');
    </script>
</body>
</html>
