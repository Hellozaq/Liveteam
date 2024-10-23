<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Benefícios</title>
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
    <!-- Vue 3 -->
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
    <%@ include file="WEB-INF/jspf/header.jspf" %>

    <!-- Vue Container -->
    <main id="benefits-app" class="benefits-page">
        <div class="global-vue">
            <h2 :class="{ 'animate': isLoaded[0] }">Benefícios</h2>
            
            <div v-for="(benefit, index) in benefits" :key="index" class="benefit-item">
                <h3 :class="{ 'animate': isLoaded[index + 1] }">{{ benefit.title }}</h3>
                <p :class="{ 'animate': isLoaded[index + 1 + benefits.length] }">{{ benefit.description }}</p>
            </div>
        </div>
    </main>

    <%@ include file="WEB-INF/jspf/footer.jspf" %>

    <!-- Script Vue -->
    <script>
        const app = Vue.createApp({
            data() {
                return {
                    isLoaded: Array(15).fill(false), // Controle para cada elemento animado
                    benefits: [
                        {
                            title: 'Planos Alimentares Personalizados',
                            description: 'Nossa plataforma oferece planos alimentares individualizados, adaptados às suas restrições alimentares, preferências e condições de saúde. As recomendações são continuamente ajustadas para garantir que sua dieta seja sempre adequada às suas necessidades.'
                        },
                        {
                            title: 'Relatórios Nutricionais Detalhados',
                            description: 'Usuários cadastrados e logados podem acessar relatórios nutricionais personalizados, contendo planos de ingestão de líquidos, receitas ajustadas às suas necessidades, informações calóricas e lista de alimentos a serem evitados para alcançar melhores resultados.'
                        },
                        {
                            title: 'Acompanhamento em Tempo Real',
                            description: 'Monitore sua ingestão de líquidos, refeições e atividades físicas diárias em um calendário interativo. Receba feedback personalizado da IA e ajustes nas recomendações para manter sua saúde em dia.'
                        },
                        {
                            title: 'Suporte e Atendimento ao Cliente',
                            description: 'Na área administrativa, você tem acesso a suporte ao vivo, incluindo: <ul><li>Chat em tempo real para esclarecer dúvidas.</li><li>Telefone e e-mail para comunicação com a equipe de suporte.</li></ul>'
                        },
                        {
                            title: 'Atualização de Informações de Saúde',
                            description: 'Você pode atualizar seus dados pessoais e de saúde a qualquer momento, permitindo que a plataforma ajuste as recomendações conforme suas necessidades mudam.'
                        },
                        {
                            title: 'Ajuda e Documentação',
                            description: 'Oferecemos uma seção de ajuda detalhada e documentação para guiá-lo em todas as etapas, desde o cadastro até a personalização de seus planos alimentares e acompanhamento de seu progresso.'
                        },
                        {
                            title: 'Incentivo à Saúde Integral',
                            description: 'Nossa plataforma incentiva hábitos saudáveis através do monitoramento de atividades físicas, ingestão de líquidos e alimentação equilibrada, promovendo uma saúde integral.'
                        }
                    ]
                };
            },
            mounted() {
                // Animação em cascata
                this.animateElements();
            },
            methods: {
                animateElements() {
                    this.isLoaded.forEach((_, index) => {
                        setTimeout(() => {
                            this.isLoaded[index] = true;  // Define isLoaded para cada elemento com delay
                        }, index * 75);  // Atraso de 200ms entre cada item
                    });
                }
            }
        });
        app.mount('#benefits-app');
    </script>
</body>
</html>
