<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.liveteam.database.DatabaseConnection" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin</title>
    <link rel="stylesheet" href="assets/css/pages/admin.css">
    <style>
        .section { display: none; }
        .active-section { display: block; }
        .error-message { color: red; margin-bottom: 1em; }
    </style>
</head>
<body>
<div class="container">
    <h1 class="main-heading">Gerenciamento de Usuários</h1>

    <div class="nav">
        <button onclick="showSection('userManagement')" class="button">Gerenciar Usuários</button>
        <button onclick="showSection('addUserForm')" class="button">Adicionar Usuário</button>
    </div>

    <!-- Adicionar Usuário -->
    <div id="addUserForm" class="section">
        <h2>Adicionar Novo Usuário</h2>
        <form action="${pageContext.request.contextPath}/admin" method="post" class="add-user-form">
            <input type="hidden" name="action" value="addUser">

            <div class="form-group">
                <label for="nome">Nome:</label>
                <input type="text" name="nome" id="nome" required>
            </div>

            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" name="email" id="email" required>
            </div>

            <div class="form-group">
                <label for="senha">Senha:</label>
                <input type="password" name="senha" id="senha" required>
            </div>

            <div class="form-group">
                <label for="role">Role:</label>
                <select name="role" id="role" required>
                    <option value="usuario">Usuário</option>
                    <option value="administrador">Administrador</option>
                </select>
            </div>

            <!-- Botão dentro do formulário -->
            <button type="submit" class="button">Adicionar</button>
        </form>
    </div>

    <!-- Gerenciamento de Usuários -->
    <div id="userManagement" class="section active-section">
        <% 
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (errorMsg != null) {
        %>
            <p class="error-message"><%= errorMsg %></p>
        <% } %>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Role</th>
                    <th>Alterar Role</th>
                    <th>Deletar</th>
                </tr>
            </thead>
            <tbody>
            <%
                try {
                    List<DatabaseConnection.User> users = DatabaseConnection.getAllUsers();
                    if (users.isEmpty()) {
            %>
                <tr><td colspan="5">Nenhum usuário encontrado.</td></tr>
            <%
                    } else {
                        for (DatabaseConnection.User user : users) {
            %>
                <tr>
                    <td><%= user.id %></td>
                    <td><%= user.nome %></td>
                    <td><%= user.role %></td>
                    <td>
                        <form action="${pageContext.request.contextPath}/admin" method="post" class="update-role-form">
                            <input type="hidden" name="action" value="updateUserRole">
                            <input type="hidden" name="userId" value="<%= user.id %>">
                            <select name="newRole">
                                <option value="usuario" <%= "usuario".equals(user.role) ? "selected" : "" %>>Usuário</option>
                                <option value="administrador" <%= "administrador".equals(user.role) ? "selected" : "" %>>Administrador</option>
                            </select>
                            <button type="submit" class="button">Atualizar</button>
                        </form>
                    </td>
                    <td>
                        <form action="${pageContext.request.contextPath}/admin" method="post">
                            <input type="hidden" name="action" value="deleteUser">
                            <input type="hidden" name="userId" value="<%= user.id %>">
                            <button type="submit" class="button">Deletar</button>
                        </form>
                    </td>
                </tr>
            <%
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                <tr><td colspan="5">Erro ao carregar usuários.</td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<script>
function showSection(sectionId) {
    document.querySelectorAll('.section').forEach(section =>
        section.classList.remove('active-section')
    );
    document.getElementById(sectionId).classList.add('active-section');
}
</script>

</body>
</html>
