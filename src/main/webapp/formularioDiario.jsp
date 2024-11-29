<%@ page import="java.time.LocalDate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inserir Dados Diários</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free/css/all.min.css" rel="stylesheet">
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
    <style>
        .form-section {
            margin-bottom: 30px;
        }

        .form-section h3 {
            color: #198754;
        }

        .form-container form {
            width: 100%;
            max-width: 100%;
        }

        .btn-primary {
            max-width: 300px;
            max-height: 300px;
            margin-right: 8%;
            font-size: 1.5rem;
        }

        .btn-group {
            display: flex; /* Organiza os botões lado a lado */
            flex-wrap: wrap; /* Permite quebra de linha se necessário */
            gap: 10px; /* Espaçamento entre os botões */
        }

        /* Estilo padrão dos botões */
        .btn {
            background-color: #f8f9fa; /* Cor de fundo padrão */
            border-color: #ccc; /* Cor da borda padrão */
            color: #495057; /* Cor do texto */
            font-weight: bold;
            padding: 10px 15px; /* Ajusta o tamanho do botão */
            text-align: center; /* Centraliza o texto */
            border-radius: 5px; /* Bordas arredondadas */
            box-shadow: none; /* Remove sombras extras */
            transition: all 0.3s ease; /* Animação suave */
        }

        /* Estilo quando selecionado */
        .btn-check:checked + .btn {
            background-color: #4CAF50; /* Verde mais forte */
            border-color: #388E3C;
            color: white;
            box-shadow: 0 0 10px rgba(0, 128, 0, 0.5); /* Destaque visual */
        }

        /* Efeito ao passar o mouse */
        .btn:hover {
            background-color: #e9ecef;
            border-color: #b0b0b0;
        }

        /* Estilo para níveis de avaliação */
        .btn-check:checked + .btn-dark {
            background-color: #1c1c1c; /* Nível 1 */
            border-color: #121212;
            color: white;
        }

        .btn-check:checked + .btn-danger {
            background-color: #ff4d4d; /* Nível 2 */
            border-color: #e60000;
            color: white;
        }

        .btn-check:checked + .btn-warning {
            background-color: #ffb74d; /* Nível 4 */
            border-color: #f57c00;
            color: white;
        }

        .btn-check:checked + .btn-info {
            background-color: #29b6f6; /* Nível 6 */
            border-color: #0288d1;
            color: white;
        }

        .btn-check:checked + .btn-success {
            background-color: #66bb6a; /* Nível 8 */
            border-color: #388e3c;
            color: white;
        }

        /* Adaptação para mobile */
        @media (max-width: 768px) {
            .btn-group {
                flex-direction: column; /* Botões em coluna no mobile */
                align-items: stretch; /* Ocupam toda a largura */
            }
            .btn {
                width: 100%; /* Cada botão ocupa 100% da largura disponível */
                text-align: center;
            }
        }
    </style>

</head>
<body>
    <% 
    if (request.getSession(false) == null || request.getSession(false).getAttribute("usuarioLogado") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
    <%@ include file="WEB-INF/jspf/header.jspf" %>
    <%
        // Obtendo a data atual
        LocalDate dataAtual = LocalDate.now();
        int diaAtual = dataAtual.getDayOfMonth();
        int mesAtual = dataAtual.getMonthValue();
        int anoAtual = dataAtual.getYear();
    %>
    <div class=" container mt-4 form-container">
        <h2>Inserir Informações do dia <%= diaAtual %>/<%= mesAtual %></h2>
        <form action="SalvarDadosDiarios.jsp" method="post" novalidate>
            <!-- Data -->
             <!-- Data (ocultada para o usuário) -->
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
            <!-- Alimentação -->
            <fiv class="row">
            <div class="form-section col-md-3">
                <h3>Alimentação</h3>
                <div class="mb-3">
                    <label for="cafe_da_manha" class="form-label">Café da Manhã</label>
                    <textarea id="cafe_da_manha" name="cafe_da_manha" class="form-control" maxlength="500"></textarea>
                </div>
                <div class="mb-3">
                    <label for="almoco" class="form-label">Almoço</label>
                    <textarea id="almoco" name="almoco" class="form-control" maxlength="500"></textarea>
                </div>
                <div class="mb-3">
                    <label for="jantar" class="form-label">Jantar</label>
                    <textarea id="jantar" name="jantar" class="form-control" maxlength="500"></textarea>
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

            <!-- Líquidos -->
            <div class="form-section col-md-3">
                <h3>Ingestão de Líquidos</h3>
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

            <!-- Exercícios -->
            <div class="form-section col-md-3">
                <h3>Exercícios</h3>
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

            <div class="form-section col-md-3">
            <h3>Avaliação Pessoal</h3>

                        <!-- Nível de Fome -->
            <div class="mb-3">
                <label class="form-label">Nível de Fome (1-5)</label>
                <div class="btn-group" role="group">
                    <input type="radio" class="btn-check" name="nivel_fome" id="nivel_fome_1" value="1" autocomplete="off" required>
                    <label class="btn btn-dark" for="nivel_fome_1">1</label>

                    <input type="radio" class="btn-check" name="nivel_fome" id="nivel_fome_2" value="2" autocomplete="off" required>
                    <label class="btn btn-danger" for="nivel_fome_2">2</label>

                    <input type="radio" class="btn-check" name="nivel_fome" id="nivel_fome_3" value="3" autocomplete="off" required>
                    <label class="btn btn-warning" for="nivel_fome_3">3</label>

                    <input type="radio" class="btn-check" name="nivel_fome" id="nivel_fome_4" value="4" autocomplete="off" required>
                    <label class="btn btn-info" for="nivel_fome_4">4</label>

                    <input type="radio" class="btn-check" name="nivel_fome" id="nivel_fome_5" value="5" autocomplete="off" required>
                    <label class="btn btn-success" for="nivel_fome_5">5</label>
                </div>
            </div>

            <!-- Nível de Energia -->
            <div class="mb-3">
                <label class="form-label">Nível de Energia (1-5)</label>
                <div class="btn-group" role="group">
                    <input type="radio" class="btn-check" name="nivel_energia" id="nivel_energia_1" value="1" autocomplete="off" required>
                    <label class="btn btn-dark" for="nivel_energia_1">1</label>

                    <input type="radio" class="btn-check" name="nivel_energia" id="nivel_energia_2" value="2" autocomplete="off" required>
                    <label class="btn btn-danger" for="nivel_energia_2">2</label>

                    <input type="radio" class="btn-check" name="nivel_energia" id="nivel_energia_3" value="3" autocomplete="off" required>
                    <label class="btn btn-warning" for="nivel_energia_3">3</label>

                    <input type="radio" class="btn-check" name="nivel_energia" id="nivel_energia_4" value="4" autocomplete="off" required>
                    <label class="btn btn-info" for="nivel_energia_4">4</label>

                    <input type="radio" class="btn-check" name="nivel_energia" id="nivel_energia_5" value="5" autocomplete="off" required>
                    <label class="btn btn-success" for="nivel_energia_5">5</label>
                </div>
            </div>

            <!-- Qualidade do Sono -->
            <div class="mb-3">
                <label class="form-label">Qualidade do Sono (1-5)</label>
                <div class="btn-group" role="group">
                    <input type="radio" class="btn-check" name="qualidade_sono" id="qualidade_sono_1" value="1" autocomplete="off" required>
                    <label class="btn btn-dark" for="qualidade_sono_1">1</label>

                    <input type="radio" class="btn-check" name="qualidade_sono" id="qualidade_sono_2" value="2" autocomplete="off" required>
                    <label class="btn btn-danger" for="qualidade_sono_2">2</label>

                    <input type="radio" class="btn-check" name="qualidade_sono" id="qualidade_sono_3" value="3" autocomplete="off" required>
                    <label class="btn btn-warning" for="qualidade_sono_3">3</label>

                    <input type="radio" class="btn-check" name="qualidade_sono" id="qualidade_sono_4" value="4" autocomplete="off" required>
                    <label class="btn btn-info" for="qualidade_sono_4">4</label>

                    <input type="radio" class="btn-check" name="qualidade_sono" id="qualidade_sono_5" value="5" autocomplete="off" required>
                    <label class="btn btn-success" for="qualidade_sono_5">5</label>
                </div>
            </div>

            <!-- Outras Observações -->
            <div class="mb-3">
                <label for="observacoes_avaliacao" class="form-label">Outras Observações</label>
                <textarea id="observacoes_avaliacao" name="observacoes_avaliacao" class="form-control" maxlength="500"></textarea>
            </div>
        </div>

            </div>
                <div class="text-end mt-3">
                    <button type="submit" class="btn btn-primary">Salvar</button>
                </div>
        </form>
    </div>
    <%@ include file="WEB-INF/jspf/footer.jspf" %>
</body>
</html>
