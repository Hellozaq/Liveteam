<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Perguntas Frequentes</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">  
        <%@ include file="WEB-INF/jspf/html-head.jspf" %>   
        <style>
            /* Estilos globais para a página de FAQ */
            .faq-container {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                color: #333;
                margin: 0;
                padding: 0;
            }
            
            .faq-header {
                text-align: center;
                color: #006400; /* Verde mais escuro */
                padding-top: 20px;
                font-size: 36px;
                font-weight: bold;
            }

            .faq-section-title {
                font-size: 28px;
                color: #006400; /* Verde mais escuro */
                margin-top: 30px;
                padding-bottom: 10px;
                border-bottom: 2px solid #006400;
                text-align: center;
            }

            .faq-accordion {
                margin: 0 auto;
                max-width: 800px;
                padding: 20px;
            }

            .accordion-button {
                background-color: #28a745; /* Verde */
                color: white;
                font-size: 18px;
                text-align: left;
                padding: 10px 20px;
            }

            .accordion-button.collapsed {
                background-color: #218838; /* Verde escuro */
            }

            .accordion-body {
                background-color: #f9f9f9;
                color: #333;
                padding: 15px;
                font-size: 16px;
                line-height: 1.5;
            }

            .accordion-item {
                margin-bottom: 15px;
            }

            .accordion-header {
                text-align: center;
            }

            .accordion-button:focus {
                box-shadow: none;
            }

            a {
                color: #28a745;
                text-decoration: none;
            }

            a:hover {
                text-decoration: underline;
            }

            /* Rodapé */
            .faq-footer {
                background-color: #006400;
                color: white;
                text-align: center;
                padding: 20px 0;
                position: fixed;
                width: 100%;
                bottom: 0;
            }

        </style>
    </head>
    <body class="faq-container">
        <% 
            if (request.getSession(false) == null || request.getSession(false).getAttribute("usuarioLogado") == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        
        <!-- Inclusão do header -->
        <div class="faq-header-container"><%@include file="WEB-INF/jspf/header.jspf" %></div>
        
        <!-- Título da página -->
        <h1 class="faq-header">Perguntas Frequentes</h1>

        <!-- Seção de funcionamento da IA -->
        <h2 class="faq-section-title">Funcionamento da IA</h2>
        <div class="faq-accordion" id="accordionAI">
            <!-- Pergunta 1 -->
            <div class="accordion-item">
                <h2 class="accordion-header" id="headingOne">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                        <strong>Como funciona a IA para gerar minhas dietas?</strong>
                    </button>
                </h2>
                <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#accordionAI">
                    <div class="accordion-body">
                        <p>A IA do nosso site analisa suas informações pessoais, como idade, peso, altura, objetivos (perda de peso, ganho muscular, manutenção), preferências alimentares e possíveis restrições dietéticas. Com base nesses dados, ela cria um plano alimentar personalizado e ajustado às suas necessidades.</p>
                    </div>
                </div>
            </div>

            <!-- Pergunta 2 -->
            <div class="accordion-item">
                <h2 class="accordion-header" id="headingTwo">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                        <strong>A dieta gerada é adequada para todos os tipos de objetivos?</strong>
                    </button>
                </h2>
                <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#accordionAI">
                    <div class="accordion-body">
                        <p>Sim, a IA cria dietas adaptadas a diferentes objetivos, como emagrecimento, ganho de massa muscular, dieta equilibrada para manutenção de peso, entre outros. Você pode selecionar seu objetivo durante o processo de cadastro.</p>
                    </div>
                </div>
            </div>

            <!-- Pergunta 3 -->
            <div class="accordion-item">
                <h2 class="accordion-header" id="headingThree">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                        <strong>Preciso seguir a dieta rigorosamente ou posso fazer ajustes?</strong>
                    </button>
                </h2>
                <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#accordionAI">
                    <div class="accordion-body">
                        <p>As dietas geradas pela IA são sugestões personalizadas, mas você pode fazer ajustes conforme necessário, considerando suas preferências e estilo de vida. No entanto, recomendamos que siga as orientações gerais para obter melhores resultados.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Seção de segurança e restrições alimentares -->
        <h2 class="faq-section-title">Segurança e Restrições Alimentares</h2>
        <div class="faq-accordion" id="accordionSecurity">
            <!-- Pergunta 4 -->
            <div class="accordion-item">
                <h2 class="accordion-header" id="headingFour">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour" aria-expanded="true" aria-controls="collapseFour">
                        <strong>Como alterar minha senha?</strong>
                    </button>
                </h2>
                <div id="collapseFour" class="accordion-collapse collapse show" aria-labelledby="headingFour" data-bs-parent="#accordionSecurity">
                    <div class="accordion-body">
                        <p>Na tela de perfil existe um botão para recuperação e troca da senha. Você pode acessar a opção "Alterar Senha" nas configurações de conta.</p>
                    </div>
                </div>
            </div>

            <!-- Pergunta 5 -->
            <div class="accordion-item">
                <h2 class="accordion-header" id="headingFive">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFive" aria-expanded="true" aria-controls="collapseFive">
                        <strong>A dieta gerada considera minhas alergias alimentares?</strong>
                    </button>
                </h2>
                <div id="collapseFive" class="accordion-collapse collapse show" aria-labelledby="headingFive" data-bs-parent="#accordionSecurity">
                    <div class="accordion-body">
                        <p>Sim, ao se cadastrar, você pode informar se tem alguma alergia alimentar. A IA irá excluir alimentos incompatíveis com suas restrições e sugerir alternativas seguras para o seu plano alimentar.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Seção de suporte e contato -->
        <h2 class="faq-section-title">Suporte e Contato</h2>
        <div class="faq-accordion" id="accordionSupport">
            <!-- Pergunta 9 -->
            <div class="accordion-item">
                <h2 class="accordion-header" id="headingNine">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseNine" aria-expanded="true" aria-controls="collapseNine">
                        <strong>Como posso entrar em contato com o suporte?</strong>
                    </button>
                </h2>
                <div id="collapseNine" class="accordion-collapse collapse show" aria-labelledby="headingNine" data-bs-parent="#accordionSupport">
                    <div class="accordion-body">
                        <p>Temos uma página de Fale Conosco com nossas informações de contato. Os meios são:</p>
                        <ul>
                            <li>Email: <a href="mailto:contato@empresa.com">contato@empresa.com</a></li>
                            <li>Telefone: (11) 98765-4321</li>
                            <li>Redes Sociais: Facebook, Instagram, Twitter</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="WEB-INF/jspf/footer.jspf" %>
    </body>
</html>
