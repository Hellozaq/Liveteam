<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Perfil do Usuário</title>
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
    <style>
        body {
            background: #181c1f;
            color: #f7f7f7;
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1050;
            left: 0;
            top: 0;
            width: 100vw;
            height: 100vh;
            overflow: auto;
            background: rgba(24, 28, 31, 0.93);
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: #23272b;
            color: #f7f7f7;
            margin: 0 auto;
            padding: 32px 28px 24px 28px;
            border-radius: 14px;
            border: 1.5px solid #A0D683;
            box-shadow: 0 4px 28px #A0D68333, 0 0 0 1.5px #A0D683;
            max-width: 420px;
            width: 92vw;
            position: relative;
            animation: modalShow 0.22s cubic-bezier(.6,.2,.5,1.2);
        }
        @keyframes modalShow {
            from { opacity: 0; transform: translateY(-32px) scale(0.98);}
            to   { opacity: 1; transform: translateY(0) scale(1);}
        }
        .modal-content h2 {
            color: #A0D683;
            font-size: 1.6rem;
            font-weight: bold;
            margin-bottom: 1.4rem;
            text-align: center;
            letter-spacing: 0.01em;
            background: linear-gradient(90deg, #A0D683 70%, #8b5cf6 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        /* CORREÇÃO VISUAL DO BOTÃO DE FECHAR */
        .close {
            color: #A0D683;
            position: absolute;
            top: 18px;
            right: 18px;
            font-size: 2.2rem;
            font-weight: bold;
            cursor: pointer;
            background: none !important;
            border: none !important;
            z-index: 10;
            transition: color 0.18s;
            outline: none !important;
            box-shadow: none !important;
            padding: 0 !important;
            appearance: none !important;
            -webkit-appearance: none !important;
            -moz-appearance: none !important;
        }
        .close:focus,
        .close:active,
        .close:focus-visible,
        .close:hover {
            color: #8b5cf6;
            outline: none !important;
            box-shadow: none !important;
            background: none !important;
        }
        .modal-content label {
            color: #A0D683;
            font-weight: 700;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 0.5em;
            font-size: 1rem;
        }
        .modal-content input[type="password"] {
            background: #181c1f;
            color: #f7f7f7;
            border: 1.5px solid #A0D683;
            border-radius: 7px;
            font-size: 1.13rem;
            margin-bottom: 18px;
            margin-top: 3px;
            padding: 12px 11px;
            width: 100%;
            transition: border 0.3s, background 0.3s;
            font-family: inherit;
        }
        .modal-content input[type="password"]:focus {
            border-color: #8B5CF6;
            background: #23272b;
            outline: none;
        }
        .modal-content button[type="submit"] {
            background: linear-gradient(90deg, #A0D683 0%, #7DD23B 100%);
            color: #23272b;
            font-weight: bold;
            padding: 12px 24px;
            border-radius: 7px;
            border: none;
            box-shadow: 0 2px 8px 0 rgba(160, 214, 131, 0.16);
            font-size: 1.13rem;
            width: 100%;
            margin-top: 8px;
            transition: background 0.3s, color 0.3s, filter 0.2s;
            cursor: pointer;
        }
        .modal-content button[type="submit"]:hover,
        .modal-content button[type="submit"]:focus {
            background: linear-gradient(90deg, #7DD23B 0%, #A0D683 100%);
            color: #181c1f;
            filter: brightness(0.97);
        }
        @media (max-width: 600px) {
            .modal-content {
                padding: 18px 6vw 18px 6vw;
                min-width: unset;
                max-width: 98vw;
            }
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

    <main class="inicio-page container my-5">
        <h1>Perfil do Usuário</h1>
        <h2>Bem-vindo, <%= nomeUsuario %>!</h2>
        <p><strong>Email:</strong> <%= emailUsuario %></p>
        <p><strong>Função:</strong> <%= roleUsuario %></p>

        <!-- Botão para redefinir senha -->
        <button id="redefinirSenhaBtn" class="btn btn-primary">Redefinir Senha</button>

        <!-- Botão para administradores -->
        <% if ("administrador".equalsIgnoreCase(roleUsuario)) { %>
            <div class="mt-3">
                <a href="admin.jsp" class="btn btn-warning">Ir para o Painel de Administração</a>
            </div>
        <% } %>

        <!-- Modal redefinição de senha -->
        <div id="senhaModal" class="modal">
            <div class="modal-content">
                <button class="close" id="closeModal" title="Fechar" tabindex="0" aria-label="Fechar">&times;</button>
                <h2>Redefinir Senha</h2>
                <form action="RedefinirSenhaServlet" method="post" autocomplete="off">
                    <label for="senhaAtual">Senha Atual:</label>
                    <input type="password" id="senhaAtual" name="senhaAtual" required autocomplete="current-password">

                    <label for="novaSenha">Nova Senha:</label>
                    <input type="password" id="novaSenha" name="novaSenha" required autocomplete="new-password">

                    <label for="confirmarSenha">Confirmar Nova Senha:</label>
                    <input type="password" id="confirmarSenha" name="confirmarSenha" required autocomplete="new-password">

                    <button type="submit" class="btn btn-success">Redefinir Senha</button>
                </form>
            </div>
        </div>

        <!-- Mensagens de erro ou sucesso -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger mt-3" id="alertMensagem">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success mt-3" id="alertMensagem">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
    </main>

    <%@ include file="WEB-INF/jspf/footer.jspf" %>

    <script>
        // Modal JS
        const modal = document.getElementById("senhaModal");
        const btn = document.getElementById("redefinirSenhaBtn");
        const closeBtn = document.getElementById("closeModal");

        btn.onclick = function () {
            modal.style.display = "flex";
        };

        closeBtn.onclick = function () {
            modal.style.display = "none";
        };

        window.onclick = function (event) {
            if (event.target === modal) {
                modal.style.display = "none";
            }
        };

        // Remove outline azul do botão de fechar para todos navegadores
        closeBtn.addEventListener('focus', function() {
            this.style.outline = 'none';
            this.style.boxShadow = 'none';
        });
        closeBtn.addEventListener('mousedown', function(event) {
            event.preventDefault();
            this.blur();
        });

        // Esconde mensagem de alerta (erro/sucesso) após 1.5s
        window.addEventListener('DOMContentLoaded', function() {
            var alerta = document.getElementById('alertMensagem');
            if (alerta) {
                setTimeout(function() {
                    alerta.style.transition = 'opacity 0.35s';
                    alerta.style.opacity = 0;
                    setTimeout(function() {
                        if (alerta && alerta.parentNode) alerta.parentNode.removeChild(alerta);
                    }, 400);
                }, 1500);
            }
        });
    </script>
</body>
</html>