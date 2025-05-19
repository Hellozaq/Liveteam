<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Home</title>
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
    <!-- Main and Home-specific CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/home-page.css">
    <!-- Vue 3 -->
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
    <% 
        // Verificação de sessão para garantir que o usuário esteja logado
        if (request.getSession(false) == null || request.getSession(false).getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp");
            return;  
        }
        String status = request.getParameter("status");
        String message = request.getParameter("message");
    %>

    <% if (status != null && message != null) { %>
        <div class="alert alert-<%= status %>">
            <%= message %>
        </div>
    <% } %>
    
    <%@ include file="WEB-INF/jspf/header.jspf" %>

    <main id="home-app" class="home-page">
        <div class="global-vue">
            <h1 :class="{ 'animate': isLoaded[0] }">
                <i class="ph ph-house"></i>
                Bem-vindo!
            </h1>
            <p :class="{ 'animate': isLoaded[1] }">
                Estamos felizes em tê-lo conosco. Nossa plataforma oferece soluções inovadoras para nutricionistas, ajudando você a oferecer um atendimento de qualidade aos seus pacientes.
            </p>

            <h2 :class="{ 'animate': isLoaded[2] }">
                <i class="ph ph-lightbulb"></i>
                Sobre Nosso Produto
            </h2>
            <p :class="{ 'animate': isLoaded[3] }">
                Nosso produto é uma ferramenta inteligente que utiliza inteligência artificial para auxiliar nutricionistas em suas rotinas diárias. Ele proporciona:
            </p>
            <ul>
                <li :class="{ 'animate': isLoaded[4] }"><strong>Agilidade:</strong> Facilita a criação de planos alimentares personalizados e otimizados.</li>
                <li :class="{ 'animate': isLoaded[5] }"><strong>Precisão:</strong> Fornece informações nutricionais atualizadas e detalhadas.</li>
                <li :class="{ 'animate': isLoaded[6] }"><strong>Integração:</strong> Possui recursos que se integram a outras plataformas utilizadas na área da saúde.</li>
            </ul>

            <h2 :class="{ 'animate': isLoaded[7] }">
                <i class="ph ph-gift"></i>
                Benefícios de Usar Nossa Plataforma
            </h2>
            <p :class="{ 'animate': isLoaded[8] }">
                Ao escolher nossa solução, você terá acesso a diversos benefícios, incluindo:
            </p>
            <ul>
                <li :class="{ 'animate': isLoaded[9] }">Maior eficiência no atendimento ao paciente.</li>
                <li :class="{ 'animate': isLoaded[10] }">Relatórios e análises personalizadas que ajudam no acompanhamento do progresso.</li>
                <li :class="{ 'animate': isLoaded[11] }">Suporte técnico dedicado para auxiliá-lo em todas as etapas.</li>
            </ul>

            <h2 :class="{ 'animate': isLoaded[12] }">
                <i class="ph ph-rocket-launch"></i>
                Pronto para Começar?
            </h2>
            <p :class="{ 'animate': isLoaded[13] }">
                Explore todas as funcionalidades da nossa plataforma.
            </p>
        </div>
    </main>

    <%@ include file="WEB-INF/jspf/footer.jspf" %>

    <!-- Script Vue -->
    <script>
        const app = Vue.createApp({
            data() {
                return {
                    isLoaded: Array(14).fill(false)  // Controle para cada elemento animado
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
                        }, index * 100);  // Atraso de 100ms entre cada item
                    });
                }
            }
        });
        app.mount('#home-app');
    </script>
</body>
</html>