<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.liveteam.database.DatabaseConnection" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Admin</title>
  <link rel="stylesheet" href="assets/css/pages/admin.css">
  <!-- Reset, layout e .button já estão aí -->
  <style>
    /* ----------------------------------------------------
       Modal de edição
    ---------------------------------------------------- */
    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0; top: 0;
      width: 100%; height: 100%;
      background: rgba(0,0,0,0.4);
      align-items: center;
      justify-content: center;
    }
    .modal-content {
      background: #fff;
      padding: 25px;
      border-radius: 10px;
      max-width: 500px;
      width: 90%;
      box-shadow: 0 8px 20px rgba(0,0,0,0.2);
      position: relative;
    }
    .modal-content h2 {
      margin-bottom: 20px;
      color: #2c3e50;
      text-align: center;
    }
    .close {
      position: absolute;
      top: 12px; right: 12px;
      font-size: 1.5rem;
      font-weight: bold;
      color: #aaa;
      cursor: pointer;
    }
    .close:hover {
      color: #555;
    }
    .edit-user-form .form-group label {
      color: #555;
      font-weight: 600;
    }
  </style>
</head>
<body>
<div class="container">
  <h1 class="main-heading">Gerenciamento de Usuários</h1>

  <div class="nav">
    <button onclick="showSection('userManagement')" class="button">Gerenciar Usuários</button>
    <button onclick="showSection('addUserForm')" class="button">Adicionar Usuário</button>
  </div>

  <!-- Seção de Adicionar Usuário (inalterada) -->
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
      <button type="submit" class="button">Adicionar</button>
    </form>
  </div>

  <!-- Seção de Gerenciar Usuários -->
  <div id="userManagement" class="section active-section">
    <% String errorMsg = (String) request.getAttribute("errorMsg");
       if (errorMsg != null) { %>
      <p class="error-message"><%= errorMsg %></p>
    <% } %>

    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Nome</th>
          <th>Role</th>
          <th>Ações</th>
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
            <button 
              class="button edit-button"
              data-id="<%=user.id%>"
              data-nome="<%=user.nome%>"
              data-email="<%=user.email%>"
              data-role="<%=user.role%>">
              Editar
            </button>
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

  <!-- Modal de Edição -->
  <div id="editModal" class="modal">
    <div class="modal-content">
      <span class="close">&times;</span>
      <h2>Editar Usuário</h2>
      <form id="editUserForm" action="${pageContext.request.contextPath}/admin" method="post">
      <!-- aplica a classe add-user-form e mantém a edit-user-form -->
      <form id="editUserForm"
            action="${pageContext.request.contextPath}/admin"
            method="post"
            class="add-user-form edit-user-form">
        <input type="hidden" name="action" value="updateUser">
        <input type="hidden" name="userId" id="editUserId">
      
      <div class="form-group">
        <label for="editNome">Nome:</label>
        <input type="text" name="nome" id="editNome" required>
      </div>
      <div class="form-group">
        <label for="editEmail">Email:</label>
        <input type="email" name="email" id="editEmail" required>
      </div>
      <div class="form-group">
        <label for="editSenha">Senha:</label>
        <input type="password" name="senha" id="editSenha" placeholder="Deixe em branco para manter">
      </div>
      <div class="form-group">
        <label for="editRole">Role:</label>
        <select name="role" id="editRole" required>
          <option value="usuario">Usuário</option>
          <option value="administrador">Administrador</option>
        </select>
      </div>
      <button type="submit" class="button">Atualizar Usuário</button>
    </form>
  </div>
</div>

<script>
  function showSection(sectionId) {
    document.querySelectorAll('.section')
      .forEach(s => s.classList.remove('active-section'));
    document.getElementById(sectionId)
      .classList.add('active-section');
  }

  // Modal logic
  const editModal = document.getElementById('editModal');
  const closeBtn   = editModal.querySelector('.close');

  document.querySelectorAll('.edit-button').forEach(btn => {
    btn.addEventListener('click', () => {
      document.getElementById('editUserId').value = btn.dataset.id;
      document.getElementById('editNome').value   = btn.dataset.nome;
      document.getElementById('editEmail').value  = btn.dataset.email;
      document.getElementById('editSenha').value  = '';
      document.getElementById('editRole').value   = btn.dataset.role;
      editModal.style.display = 'flex';
    });
  });

  closeBtn.addEventListener('click', () => {
    editModal.style.display = 'none';
  });
  window.addEventListener('click', e => {
    if (e.target === editModal) editModal.style.display = 'none';
  });
</script>
</body>
</html>
