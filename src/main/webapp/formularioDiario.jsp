<%@ page import="java.time.LocalDate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inserir Dados Diários</title>

    <!-- Inclusão dos arquivos CSS e ícones do Bootstrap e FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free/css/all.min.css" rel="stylesheet">
    
    <!-- Estilo personalizado para a página -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/pages/formulario-diario-page.css">

    <!-- Inclusão de cabeçalho HTML -->
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
</head>
<body>
    <%
        // Verificar se o usuário está logado
        if (request.getSession(false) == null || request.getSession(false).getAttribute("usuarioLogado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>

    <!-- Inclusão do cabeçalho da página -->
    <%@ include file="WEB-INF/jspf/header.jspf" %>

    <%
        // Obtendo a data atual
        LocalDate dataAtual = LocalDate.now();
        int diaAtual = dataAtual.getDayOfMonth();
        int mesAtual = dataAtual.getMonthValue();
        int anoAtual = dataAtual.getYear();
    %>

    <!-- Container principal do formulário -->
    <div class="container mt-4 form-container">
        <h2>Inserir Informações do dia <%= diaAtual %>/<%= mesAtual %></h2>

        <!-- Formulário para salvar dados diários -->
        <form action="SalvarDadosDiarios.jsp" method="post" novalidate>
        
            <!-- Seção de Data (ocultada para o usuário) -->
            <div class="form-section" style="display:none;">
                <h3>Data</h3>
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
            </div>

            <!-- Seção de Alimentação -->
            <div class="row">
                <div class="form-section col-md-3">
                    <h3>Alimentação</h3>
                    <!-- Campos para entrada de dados sobre alimentação -->
                    <div class="mb-3">
                        <label for="cafe_da_manha" class="form-label">Café da Manhã</label>
                        <textarea id="cafe_da_manha" name="cafe_da_manha" class="form-control" maxlength="500" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="almoco" class="form-label">Almoço</label>
                        <textarea id="almoco" name="almoco" class="form-control" maxlength="500" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="jantar" class="form-label">Jantar</label>
                        <textarea id="jantar" name="jantar" class="form-control" maxlength="500" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="lanches" class="form-label">Lanches</label>
                        <textarea id="lanches" name="lanches" class="form-control" maxlength="500"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="observacoes_alimentacao" class="form-label">Observações</label>
                        <textarea id="observacoes_alimentacao" name="observacoes_alimentacao" class="form-control" maxlength="500"></textarea>
                    </div>
                </div>

                <!-- Seção de Ingestão de Líquidos -->
                <div class="form-section col-md-3">
                    <h3>Ingestão de Líquidos</h3>
                    <!-- Campos para entrada de dados sobre líquidos -->
                    <div class="mb-3">
                        <label for="agua" class="form-label">Água (em litros)</label>
                        <input type="number" id="agua" name="agua" class="form-control" min="0" step="0.1" required>
                    </div>
                    <div class="mb-3">
                        <label for="outros_liquidos" class="form-label">Outros Líquidos</label>
                        <input type="text" id="outros_liquidos" name="outros_liquidos" class="form-control" maxlength="100">
                    </div>
                    <div class="mb-3">
                        <label for="observacoes_liquidos" class="form-label">Observações</label>
                        <textarea id="observacoes_liquidos" name="observacoes_liquidos" class="form-control" maxlength="500"></textarea>
                    </div>
                </div>

                <!-- Seção de Exercícios -->
                <div class="form-section col-md-3">
                    <h3>Exercícios</h3>
                    <!-- Campos para entrada de dados sobre exercícios -->
                    <div class="mb-3">
                        <label for="tipo_treino" class="form-label">Tipo de Treino</label>
                        <input type="text" id="tipo_treino" name="tipo_treino" class="form-control" maxlength="100" required>
                    </div>
                    <div class="mb-3">
                        <label for="duracao_treino" class="form-label">Duração (minutos)</label>
                        <input type="number" id="duracao_treino" name="duracao_treino" class="form-control" min="1" required>
                    </div>
                    <div class="mb-3">
                        <label for="intensidade_treino" class="form-label">Intensidade</label>
                        <div class="btn-group" role="group">
                            <input type="radio" class="btn-check" name="intensidade_treino" id="intensidade_treino1" value="BAIXO" autocomplete="off" required>
                            <label class="btn btn-dark" for="intensidade_treino1">BAIXA</label>

                            <input type="radio" class="btn-check" name="intensidade_treino" id="intensidade_treino2" value="MEDIO" autocomplete="off" required>
                            <label class="btn btn-warning" for="intensidade_treino2">MÉDIA</label>

                            <input type="radio" class="btn-check" name="intensidade_treino" id="intensidade_treino3" value="ALTO" autocomplete="off" required>
                            <label class="btn btn-danger" for="intensidade_treino3">ALTA</label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="detalhes_exercicio" class="form-label">Detalhes</label>
                        <textarea id="detalhes_exercicio" name="detalhes_exercicio" class="form-control" maxlength="500"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="observacoes_exercicio" class="form-label">Observações</label>
                        <textarea id="observacoes_exercicio" name="observacoes_exercicio" class="form-control" maxlength="500"></textarea>
                    </div>
                </div>

                <!-- Seção de Avaliação Pessoal -->
                <div class="form-section col-md-3">
                    <h3>Avaliação Pessoal</h3>

                    <!-- Nível de Fome -->
                    <div class="mb-3">
                        <label class="form-label">Nível de Fome (1-5)</label>
                        <div class="btn-group" role="group">
                            <input type="radio" class="btn-check" name="nivel_fome" id="nivel_fome_1" value="1" autocomplete="off" required>
                            <label class="btn btn-dark" for="nivel_fome_1">1</label>

                            <input type="radio" class="btn-check" name="nivel_fome" id="nivel_fome_2" value="2" autocomplete="off" required>
                            <label class="btn btn-warning" for="nivel_fome_2">2</label>

                            <input type="radio" class="btn-check" name="nivel_fome" id="nivel_fome_3" value="3" autocomplete="off" required>
                            <label class="btn btn-danger" for="nivel_fome_3">3</label>

                            <input type="radio" class="btn-check" name="nivel_fome" id="nivel_fome_4" value="4" autocomplete="off" required>
                            <label class="btn btn-success" for="nivel_fome_4">4</label>

                            <input type="radio" class="btn-check" name="nivel_fome" id="nivel_fome_5" value="5" autocomplete="off" required>
                            <label class="btn btn-primary" for="nivel_fome_5">5</label>
                        </div>
                    </div>

                    <!-- Nível de Energia -->
                    <div class="mb-3">
                        <label class="form-label">Nível de Energia (1-5)</label>
                        <div class="btn-group" role="group">
                            <input type="radio" class="btn-check" name="nivel_energia" id="nivel_energia_1" value="1" autocomplete="off" required>
                            <label class="btn btn-dark" for="nivel_energia_1">1</label>

                            <input type="radio" class="btn-check" name="nivel_energia" id="nivel_energia_2" value="2" autocomplete="off" required>
                            <label class="btn btn-warning" for="nivel_energia_2">2</label>

                            <input type="radio" class="btn-check" name="nivel_energia" id="nivel_energia_3" value="3" autocomplete="off" required>
                            <label class="btn btn-danger" for="nivel_energia_3">3</label>

                            <input type="radio" class="btn-check" name="nivel_energia" id="nivel_energia_4" value="4" autocomplete="off" required>
                            <label class="btn btn-success" for="nivel_energia_4">4</label>

                            <input type="radio" class="btn-check" name="nivel_energia" id="nivel_energia_5" value="5" autocomplete="off" required>
                            <label class="btn btn-primary" for="nivel_energia_5">5</label>
                        </div>
                    </div>

                    <!-- Observações Gerais -->
                    <div class="mb-3">
                        <label for="observacoes_gerais" class="form-label">Observações Gerais</label>
                        <textarea id="observacoes_gerais" name="observacoes_gerais" class="form-control" maxlength="500"></textarea>
                    </div>
                </div>
            </div> <!-- Fim da linha de seções -->

            <!-- Botão de Enviar -->
            <div class="d-flex justify-content-center mt-4">
                <button type="submit" class="btn btn-success">Salvar Dados</button>
            </div>

        </form>
    </div> <!-- Fim do container -->

    <!-- Scripts do Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
