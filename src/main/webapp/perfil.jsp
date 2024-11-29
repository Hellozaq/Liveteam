<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Perfil do Usuário</title>
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
    <style>
        /* Estilo para o modal */
        .modal {
            display: none; /* Escondido por padrão */
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4); /* Fundo escuro */
        }

        .modal-content {
            background-color: #fff;
            margin: 10% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 50%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            border-radius: 8px;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <%@ include file="WEB-INF/jspf/header.jspf" %>

    <% 
        String emailUsuario = null;
        String nomeUsuario = null;

        // Verificar se a sessão existe e se os atributos estão definidos
        if (session != null) {
            nomeUsuario = (String) session.getAttribute("usuarioLogado");
            emailUsuario = (String) session.getAttribute("usuarioEmail");
        }

        if (nomeUsuario == null || emailUsuario == null) {
            // Redirecionar para a página de login caso não esteja logado
            response.sendRedirect("login.jsp?error=notLoggedIn");
            return;
        }
    %>
    
    <!-- Inclusão do cabeçalho -->
    <div>
    </div>

    <!-- Conteúdo principal da página -->
    <main class="contact-page container my-5">
        <h1>Perfil do Usuário</h1>
        <h2>Bem-vindo, <%= nomeUsuario %>!</h2>
        <p><strong>Email:</strong> <%= emailUsuario %></p>

        <!-- Botão para abrir o modal -->
        <button id="redefinirSenhaBtn" class="btn btn-primary">Redefinir Senha</button>

        <!-- Modal para redefinição de senha -->
        <div id="senhaModal" class="modal">
            <div class="modal-content">
                <span class="close" id="closeModal">&times;</span>
                <h2>Redefinir Senha</h2>
                <!-- Formulário para redefinir a senha -->
                <form action="RedefinirSenhaServlet" method="post">
                    <label for="senhaAtual">Senha Atual:</label>
                    <input type="password" id="senhaAtual" name="senhaAtual" class="form-control mb-3" required>
                    
                    <label for="novaSenha">Nova Senha:</label>
                    <input type="password" id="novaSenha" name="novaSenha" class="form-control mb-3" required>
                    
                    <label for="confirmarSenha">Confirmar Nova Senha:</label>
                    <input type="password" id="confirmarSenha" name="confirmarSenha" class="form-control mb-3" required>
                    
                    <button type="submit" class="btn btn-success">Redefinir Senha</button>
                </form>
            </div>
        </div>

        <!-- Exibir mensagens de erro ou sucesso -->
        <%
            if (request.getAttribute("error") != null) {
        %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
        <% 
            } 
            if (request.getAttribute("success") != null) {
        %>
            <div class="alert alert-success">
                <%= request.getAttribute("success") %>
            </div>
        <% 
            }
        %>
    </main>

    <!-- Inclusão do rodapé -->
    <%@ include file="WEB-INF/jspf/footer.jspf" %>

    <script>
        // Script para controlar o modal
        const modal = document.getElementById("senhaModal");
        const btn = document.getElementById("redefinirSenhaBtn");
        const closeBtn = document.getElementById("closeModal");

        // Abrir o modal ao clicar no botão
        btn.onclick = function() {
            modal.style.display = "block";
        };

        // Fechar o modal ao clicar no "x"
        closeBtn.onclick = function() {
            modal.style.display = "none";
        };

        // Fechar o modal ao clicar fora dele
        window.onclick = function(event) {
            if (event.target === modal) {
                modal.style.display = "none";
            }
        };
    </script>
</body>
</html>
