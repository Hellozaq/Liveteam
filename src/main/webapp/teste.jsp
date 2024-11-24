<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Dados do Dia</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/vue@3.2.47/dist/vue.global.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div class="container" id="app">
        <h1 class="mt-4">Dados do Dia</h1>
        <h2 class="mt-4">Dados para o Dia <span>{{ dia }}/{{ mes }}/{{ ano }}</span></h2>

        <table class="table table-striped mt-3">
            <thead>
                <tr>
                    <th>Categoria</th>
                    <th>Detalhes</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Alimentação</strong></td>
                    <td>{{ dados.alimentacao }}</td>
                </tr>
                <tr>
                    <td><strong>Líquidos</strong></td>
                    <td>{{ dados.liquidos }}</td>
                </tr>
                <tr>
                    <td><strong>Exercícios</strong></td>
                    <td>{{ dados.exercicios }}</td>
                </tr>
                <tr>
                    <td><strong>Avaliação</strong></td>
                    <td>{{ dados.avaliacao }}</td>
                </tr>
            </tbody>
        </table>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    dia: '<%= request.getParameter("dia") != null ? request.getParameter("dia") : "" %>',
                    mes: '<%= request.getParameter("mes") != null ? request.getParameter("mes") : "" %>',
                    ano: '<%= request.getParameter("ano") != null ? request.getParameter("ano") : "" %>',
                    dados: {
                        alimentacao: "",
                        liquidos: "",
                        exercicios: "",
                        avaliacao: ""
                    }
                };
            },
            mounted() {
                this.fetchData();
            },
            methods: {
                fetchData() {
                    const url = `obterDadosDiarios.jsp?dia=${this.dia}&mes=${this.mes}&ano=${this.ano}`;
                    fetch(url)
                        .then(response => response.json())
                        .then(data => {
                            if (data.length > 0) {
                                const dayData = data[0];  // Assume que temos um único registro para a data
                                this.dados.alimentacao = `
                                    Café da manhã: ${dayData.alimentacao.cafeDaManha}<br>
                                    Almoço: ${dayData.alimentacao.almoco}<br>
                                    Jantar: ${dayData.alimentacao.jantar}<br>
                                    Lanches: ${dayData.alimentacao.lanches}<br>
                                    Observações: ${dayData.alimentacao.observacoes}
                                `;
                                this.dados.liquidos = `
                                    Água: ${dayData.liquidos.agua}<br>
                                    Outros líquidos: ${dayData.liquidos.outros}<br>
                                    Observações: ${dayData.liquidos.observacoes}
                                `;
                                this.dados.exercicios = `
                                    Tipo de treino: ${dayData.exercicios.tipoTreino}<br>
                                    Duração: ${dayData.exercicios.duracao}<br>
                                    Intensidade: ${dayData.exercicios.intensidade}<br>
                                    Detalhes: ${dayData.exercicios.detalhes}<br>
                                    Observações: ${dayData.exercicios.observacoes}
                                `;
                                this.dados.avaliacao = `
                                    Fome: ${dayData.avaliacao.fome}<br>
                                    Energia: ${dayData.avaliacao.energia}<br>
                                    Sono: ${dayData.avaliacao.sono}<br>
                                    Observações: ${dayData.avaliacao.observacoes}
                                `;
                            } else {
                                alert("Nenhum dado encontrado para a data selecionada.");
                            }
                        })
                        .catch(error => {
                            console.error("Erro ao carregar os dados:", error);
                            alert("Erro ao carregar os dados.");
                        });
                }
            }
        });

        app.mount("#app");
    </script>
</body>
</html>
