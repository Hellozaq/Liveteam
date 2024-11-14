<%@ page import="java.time.LocalDate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inserir Dados Diários</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
</head>
<body>
    
    <%@ include file="WEB-INF/jspf/header.jspf" %>
    <%
        // Obtendo a data atual
        LocalDate dataAtual = LocalDate.now();
        int diaAtual = dataAtual.getDayOfMonth();
        int mesAtual = dataAtual.getMonthValue();
        int anoAtual = dataAtual.getYear();
    %>
    <div class="container mt-4">
        <h2>Inserir Informações Diárias</h2>
        <form action="SalvarDadosDiarios.jsp" method="post">
            <!-- Data -->
            <div class="mb-3">
                <label for="dia" class="form-label">Dia</label>
                <input type="number" id="dia" name="dia" class="form-control" value="<%= diaAtual %>" readonly>
            </div>
            <div class="mb-3">
                <label for="mes" class="form-label">Mês</label>
                <input type="number" id="mes" name="mes" class="form-control" value="<%= mesAtual %>" readonly>
            </div>
            <div class="mb-3">
                <label for="ano" class="form-label">Ano</label>
                <input type="number" id="ano" name="ano" class="form-control" value="<%= anoAtual %>" readonly>
            </div>

            <!-- Alimentação -->
            <h3>Alimentação</h3>
            <div class="mb-3">
                <label for="cafe_da_manha" class="form-label">Café da Manhã</label>
                <textarea id="cafe_da_manha" name="cafe_da_manha" class="form-control"></textarea>
            </div>
            <div class="mb-3">
                <label for="almoco" class="form-label">Almoço</label>
                <textarea id="almoco" name="almoco" class="form-control"></textarea>
            </div>
            <div class="mb-3">
                <label for="jantar" class="form-label">Jantar</label>
                <textarea id="jantar" name="jantar" class="form-control"></textarea>
            </div>
            <div class="mb-3">
                <label for="lanches" class="form-label">Lanches</label>
                <textarea id="lanches" name="lanches" class="form-control"></textarea>
            </div>
            <div class="mb-3">
                <label for="observacoes_alimentacao" class="form-label">Observações</label>
                <textarea id="observacoes_alimentacao" name="observacoes_alimentacao" class="form-control"></textarea>
            </div>

            <!-- Líquidos -->
            <h3>Ingestão de Líquidos</h3>
            <div class="mb-3">
                <label for="agua" class="form-label">Água</label>
                <input type="text" id="agua" name="agua" class="form-control">
            </div>
            <div class="mb-3">
                <label for="outros_liquidos" class="form-label">Outros Líquidos</label>
                <input type="text" id="outros_liquidos" name="outros_liquidos" class="form-control">
            </div>
            <div class="mb-3">
                <label for="observacoes_liquidos" class="form-label">Observações</label>
                <textarea id="observacoes_liquidos" name="observacoes_liquidos" class="form-control"></textarea>
            </div>

            <!-- Exercícios -->
            <h3>Exercícios</h3>
            <div class="mb-3">
                <label for="tipo_treino" class="form-label">Tipo de Treino</label>
                <input type="text" id="tipo_treino" name="tipo_treino" class="form-control">
            </div>
            <div class="mb-3">
                <label for="duracao_treino" class="form-label">Duração</label>
                <input type="text" id="duracao_treino" name="duracao_treino" class="form-control">
            </div>
            <div class="mb-3">
                <label for="intensidade_treino" class="form-label">Intensidade</label>
                <input type="text" id="intensidade_treino" name="intensidade_treino" class="form-control">
            </div>
            <div class="mb-3">
                <label for="detalhes_exercicio" class="form-label">Detalhes</label>
                <textarea id="detalhes_exercicio" name="detalhes_exercicio" class="form-control"></textarea>
            </div>
            <div class="mb-3">
                <label for="observacoes_exercicio" class="form-label">Observações</label>
                <textarea id="observacoes_exercicio" name="observacoes_exercicio" class="form-control"></textarea>
            </div>

            <!-- Avaliação Pessoal -->
            <h3>Avaliação Pessoal</h3>
            <div class="mb-3">
                <label for="nivel_fome" class="form-label">Nível de Fome</label>
                <input type="text" id="nivel_fome" name="nivel_fome" class="form-control">
            </div>
            <div class="mb-3">
                <label for="nivel_energia" class="form-label">Nível de Energia</label>
                <input type="text" id="nivel_energia" name="nivel_energia" class="form-control">
            </div>
            <div class="mb-3">
                <label for="qualidade_sono" class="form-label">Qualidade do Sono</label>
                <input type="text" id="qualidade_sono" name="qualidade_sono" class="form-control">
            </div>
            <div class="mb-3">
                <label for="observacoes_avaliacao" class="form-label">Outras Observações</label>
                <textarea id="observacoes_avaliacao" name="observacoes_avaliacao" class="form-control"></textarea>
            </div>

            <button type="submit" class="btn btn-primary">Salvar</button>
        </form>
    </div>
            <%@ include file="WEB-INF/jspf/footer.jspf" %>
</body>
</html>
