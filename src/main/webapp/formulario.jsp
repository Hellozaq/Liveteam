<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulário</title>
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
    <style>
        body {
            background: #181c1f;
            color: #f7f7f7;
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
        }
        .container.form-container {
            background: #181c1f;
            border-radius: 18px;
            box-shadow: 0 0 40px #A0D68333;
            padding: 36px 0 48px 0;
            margin-bottom: 48px;
        }
        h2 {
            color: #A0D683;
            font-size: 2.1rem;
            font-weight: bold;
            text-align: center;
            letter-spacing: 0.01em;
            background: linear-gradient(90deg, #A0D683 70%, #8b5cf6 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 2rem;
        }
        .form-section {
            margin-bottom: 30px;
        }
        .form-section h3 {
            color: #A0D683;
        }
        .form-container form {
            width: 100%;
            max-width: 100%;
            background: #23272b;
            border-radius: 14px;
            padding: 32px 24px 16px 24px;
            box-shadow: 0 2px 16px #A0D68322;
            margin: 0 auto;
        }
        label, .form-label {
            background: transparent;
            color: #A0D683;
            font-weight: 700;
            margin-bottom: 8px;
            margin-top: 6px;
            padding: 0;
            border-radius: 0;
            display: inline-block;
            font-size: 1rem;
            box-shadow: none;
        }
        .form-control, .form-select, textarea {
            background: #181c1f;
            color: #f7f7f7;
            border: 1.5px solid #A0D683;
            border-radius: 7px;
            font-size: 1.13rem;
            margin-bottom: 18px;
            margin-top: 3px;
            padding: 12px 11px;
            transition: border 0.3s, background 0.3s;
            font-family: inherit;
        }
        .form-control:focus, .form-select:focus, textarea:focus {
            border-color: #8B5CF6;
            background: #23272b;
            outline: none;
        }
        .form-control.is-invalid, .form-select.is-invalid, textarea.is-invalid {
            border-color: #ff4d4d;
            background: #2a2323;
            color: #ffb3b3;
        }
        textarea.form-control {
            min-height: 58px;
            resize: vertical;
        }
        .btn-group {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
        }
        .btn {
            background: linear-gradient(90deg, #A0D683 0%, #7DD23B 100%);
            color: #23272b;
            font-weight: bold;
            padding: 12px 24px;
            border-radius: 7px;
            border: none;
            box-shadow: 0 2px 8px 0 rgba(160, 214, 131, 0.12);
            font-size: 1.13rem;
            transition: background 0.3s, color 0.3s, filter 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .btn-success,
        .btn-primary {
            background: linear-gradient(90deg, #A0D683 0%, #7DD23B 100%) !important;
            color: #23272b !important;
        }
        .btn-success:hover, .btn-primary:hover,
        .btn-success:focus, .btn-primary:focus {
            background: linear-gradient(90deg, #7DD23B 0%, #A0D683 100%) !important;
            color: #181c1f !important;
            filter: brightness(0.98);
        }
        .btn-secondary {
            background: #23272b !important;
            color: #A0D683 !important;
            border: 1px solid #A0D683 !important;
        }
        .btn-secondary:hover, .btn-secondary:focus {
            background: #181c1f !important;
            color: #C5FFB1 !important;
        }
        /* Modal adjustments for dark theme */
        .modal-content {
            background: #23272b;
            color: #f7f7f7;
            border-radius: 10px;
        }
        .modal-header, .modal-footer {
            border-color: #A0D683;
        }
        .modal-title {
            color: #A0D683;
        }
        @media (max-width: 900px) {
            .container.form-container, .form-container form {
                max-width: 98vw;
                padding: 1rem 0.4rem;
            }
        }
        @media (max-width: 700px) {
            .container.form-container, .form-container form {
                padding: 1rem 0.2rem;
                max-width: 99vw;
            }
            .btn-group {
                flex-direction: column;
                align-items: stretch;
            }
            .btn {
                width: 100%;
                justify-content: center;
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