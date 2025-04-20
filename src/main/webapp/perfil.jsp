<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Perfil do Usuário</title>
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
    <style>
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
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
        HttpSession sessao = request.getSession(false);
        String nomeUsuario = null;
        String emailUsuario = null;
        String roleUsuario = null;

        if (sessao != null) {
            nomeUsuario = (String) sessao.getAttribute("usuarioLogado");
            emailUsuario = (String) sessao.getAttribute("usuarioEmail");
            roleUsuario = (String) sessao.getAttribute("usuarioRole");
        }

        if (nomeUsuario == null || emailUsuario == null) {
            response.sendRedirect("login.jsp?error=notLoggedIn");
            return;
        }
    %>

    <main class="contact-page container my-5">
        <h1>Perfil do Usuário</h1>
        <h2>Bem-vindo, <%= nomeUsuario %>!</h2>
        <p><strong>Email:</strong> <%= emailUsuario %></p>
        <p><strong>Função:</strong> <%= roleUsuario %></p>

        <!-- Botão para redefinir senha -->
        <button id="redefinirSenhaBtn" class="btn btn-primary">Redefinir Senha</button>

        <!-- Botão para administradores -->
        <% if ("administrador".equalsIgnoreCase(roleUsuario)) { %>
            <a href="admin.jsp" class="btn btn-warning mt-3">Ir para o Painel de Administração</a>
        <% } %>

        <!-- Modal redefinição de senha -->
        <div id="senhaModal" class="modal">
            <div class="modal-content">
                <span class="close" id="closeModal">&times;</span>
                <h2>Redefinir Senha</h2>
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

        <!-- Mensagens de erro ou sucesso -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger mt-3">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success mt-3">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
    </main>

    <%@ include file="WEB-INF/jspf/footer.jspf" %>

    <script>
        const modal = document.getElementById("senhaModal");
        const btn = document.getElementById("redefinirSenhaBtn");
        const closeBtn = document.getElementById("closeModal");

        btn.onclick = function () {
            modal.style.display = "block";
        };

        closeBtn.onclick = function () {
            modal.style.display = "none";
        };

        window.onclick = function (event) {
            if (event.target === modal) {
                modal.style.display = "none";
            }
        };
    </script>
</body>
</html>
