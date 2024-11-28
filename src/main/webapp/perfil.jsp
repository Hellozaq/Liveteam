<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Perfil do Usuário</title>
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
</head>
<body>
    <%@ include file="WEB-INF/jspf/header.jspf" %>
    <main>
         <div class="contact-page">
            <h1>Perfil do Usuário</h1>
            <p><strong>Email:</strong> <%-- Aqui você exibe o email do usuário vindo do backend --%>
                <%= request.getAttribute("email") != null ? request.getAttribute("email") : "Não disponível" %>
            </p>
            <p><strong>Senha:</strong> <%-- Por segurança, a senha pode estar mascarada ou não exibida --%>
                ****
            </p>

            <h2>Redefinir Senha</h2>
            <form action="RedefinirSenhaServlet" method="post">
                <label for="novaSenha">Nova Senha:</label>
                <input type="password" id="novaSenha" name="novaSenha" required>
                <br>
                <label for="confirmarSenha">Confirmar Nova Senha:</label>
                <input type="password" id="confirmarSenha" name="confirmarSenha" required>
                <br>
                <button type="submit">Redefinir Senha</button>
            </form>
        </div>
    </main>
    <%@ include file="WEB-INF/jspf/footer.jspf" %>
</body>
</html>