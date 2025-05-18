<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulário</title>
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

        .btn-group {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .btn {
            background-color: #f8f9fa;
            border-color: #ccc;
            color: #495057;
            font-weight: bold;
            padding: 10px 15px;
            border-radius: 5px;
            box-shadow: none;
            transition: all 0.3s ease;
        }

        .btn-check:checked + .btn {
            background-color: #4CAF50;
            border-color: #388E3C;
            color: white;
        }

        .btn:hover {
            background-color: #e9ecef;
            border-color: #b0b0b0;
        }

        @media (max-width: 768px) {
            .btn-group {
                flex-direction: column;
                align-items: stretch;
            }
            .btn {
                width: 100%;
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
    <div class="container mt-4 form-container">
        <h2>Formulário</h2>
        <form id="formulario" method="post" action="${pageContext.request.contextPath}/ExibirDietaServlet" novalidate>
            <!-- Dados Pessoais -->
            <div class="form-section">
                <h3>Dados Pessoais</h3>
                <div class="mb-3">
                    <label for="idade" class="form-label">Idade</label>
                    <input type="number" id="idade" name="idade" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="sexo" class="form-label">Sexo</label>
                    <select id="sexo" name="sexo" class="form-select" required>
                        <option value="">Selecione</option>
                        <option value="Masculino">Masculino</option>
                        <option value="Feminino">Feminino</option>
                        <option value="Outro">Outro</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="altura_cm" class="form-label">Altura (cm)</label>
                    <input type="number" id="altura_cm" name="altura_cm" class="form-control" step="0.1" required>
                </div>
                <div class="mb-3">
                    <label for="peso_kg" class="form-label">Peso (kg)</label>
                    <input type="number" id="peso_kg" name="peso_kg" class="form-control" step="0.1" required>
                </div>
                <div class="mb-3">
                    <label for="objetivo_principal" class="form-label">Objetivo Principal</label>
                    <textarea id="objetivo_principal" name="objetivo_principal" class="form-control" required></textarea>
                </div>
            </div>

            <!-- Nível de Atividade Física -->
            <div class="form-section">
                <h3>Nível de Atividade Física</h3>
                <div class="mb-3">
                    <label for="frequencia_semanal_treino" class="form-label">Frequência Semanal de Treino</label>
                    <input type="number" id="frequencia_semanal_treino" name="frequencia_semanal_treino" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="duracao_media_treino_minutos" class="form-label">Duração Média do Treino (minutos)</label>
                    <input type="number" id="duracao_media_treino_minutos" name="duracao_media_treino_minutos" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="tipo_atividade_fisica" class="form-label">Tipo de Atividade Física</label>
                    <textarea id="tipo_atividade_fisica" name="tipo_atividade_fisica" class="form-control" required></textarea>
                </div>
                <div class="mb-3">
                    <label for="objetivos_treino" class="form-label">Objetivos do Treino</label>
                    <textarea id="objetivos_treino" name="objetivos_treino" class="form-control" required></textarea>
                </div>
            </div>

            <!-- Hábitos Alimentares -->
            <div class="form-section">
                <h3>Hábitos Alimentares</h3>
                <div class="mb-3">
                    <label for="nacionalidade" class="form-label">Nacionalidade</label>
                    <input type="text" id="nacionalidade" name="nacionalidade" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="residencia_atual" class="form-label">Residência Atual</label>
                    <input type="text" id="residencia_atual" name="residencia_atual" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="alimentos_favoritos" class="form-label">Alimentos Favoritos</label>
                    <textarea id="alimentos_favoritos" name="alimentos_favoritos" class="form-control"></textarea>
                </div>
                <div class="mb-3">
                    <label for="alimentos_que_evita" class="form-label">Alimentos que Evita/ Restrições Alimentares</label>
                    <textarea id="alimentos_que_evita" name="alimentos_que_evita" class="form-control"></textarea>
                </div>
                <div class="mb-3">
                    <label for="alimentos_para_incluir_excluir" class="form-label">Alimentos para Incluir/Excluir</label>
                    <textarea id="alimentos_para_incluir_excluir" name="alimentos_para_incluir_excluir" class="form-control"></textarea>
                </div>
            </div>

            <!-- Suplementação -->
            <div class="form-section">
                <h3>Suplementação</h3>
                <div class="mb-3">
                    <label for="usa_suplementos" class="form-label">Usa Suplementos?</label>
                    <select id="usa_suplementos" name="usa_suplementos" class="form-select" required>
                        <option value="">Selecione</option>
                        <option value="true">Sim</option>
                        <option value="false">Não</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="suplementos_usados" class="form-label">Suplementos Usados</label>
                    <textarea id="suplementos_usados" name="suplementos_usados" class="form-control"></textarea>
                </div>
            </div>

            <!-- Tempo Disponível -->
            <div class="form-section">
                <h3>Tempo Disponível</h3>
                <div class="mb-3">
                    <label for="tempo_por_treino_minutos" class="form-label">Tempo por Treino (minutos)</label>
                    <input type="number" id="tempo_por_treino_minutos" name="tempo_por_treino_minutos" class="form-control" required>
                </div>
            </div>

            <!-- Cardápio Diário -->
            <div class="form-section">
                <h3>Cardápio Diário</h3>
                <div class="mb-3">
                    <label for="cardapio_dia" class="form-label">Cardápio do Dia</label>
                    <textarea id="cardapio_dia" name="cardapio_dia" class="form-control" required></textarea>
                </div>
            </div>

            <!-- Botões -->
            <div class="btn-group">
                <button type="submit" class="btn btn-success">Enviar</button>
            </div>
        </form>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="modalMensagem" tabindex="-1" aria-labelledby="modalMensagemLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalMensagemLabel">Mensagem</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Preencha todos os campos obrigatórios corretamente antes de enviar o formulário.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const formulario = document.getElementById('formulario');
        formulario.addEventListener('submit', function(event) {
            let isValid = true;

            // Verificar campos obrigatórios
            const requiredFields = document.querySelectorAll('[required]');
            requiredFields.forEach(field => {
                if (!field.value) {
                    isValid = false;
                    field.classList.add('is-invalid');
                } else {
                    field.classList.remove('is-invalid');
                }
            });

            if (!isValid) {
                event.preventDefault();
                new bootstrap.Modal(document.getElementById('modalMensagem')).show();
            }
        });
    </script>
</body>
</html>