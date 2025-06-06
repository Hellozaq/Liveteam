<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<html>
<head>
    <title>Dashboard Nutricional</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .card {
            display: inline-block;
            width: 200px;
            padding: 15px;
            margin: 10px;
            background: #f0f8ff;
            border-radius: 10px;
            box-shadow: 2px 2px 6px #ccc;
            text-align: center;
        }
        .dashboard {
            text-align: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <h2 style="text-align:center;">Meu Dashboard de Hoje</h2>

    <div class="dashboard">
        <div class="card">Água: <strong><%= request.getAttribute("agua") %></strong></div>
        <div class="card">Energia: <strong><%= request.getAttribute("energia") %></strong></div>
        <div class="card">Qualidade do Sono: <strong><%= request.getAttribute("sono") %></strong></div>
    </div>

    <div style="width: 500px; margin: auto;">
        <canvas id="caloriasChart"></canvas>
    </div>

    <div style="width: 400px; margin: 40px auto;">
        <canvas id="comparativoCalorias"></canvas>
    </div>

    <script>
        // Gráfico de calorias por refeição
        const data = {
            labels: ['Café', 'Almoço', 'Jantar', 'Lanches'],
            datasets: [{
                label: 'Calorias (kcal)',
                data: [
                    <%= request.getAttribute("cafe") != null ? request.getAttribute("cafe") : 0 %>,
                    <%= request.getAttribute("almoco") != null ? request.getAttribute("almoco") : 0 %>,
                    <%= request.getAttribute("jantar") != null ? request.getAttribute("jantar") : 0 %>,
                    <%= request.getAttribute("lanches") != null ? request.getAttribute("lanches") : 0 %>
                ],
                backgroundColor: ['#ffa07a', '#f08080', '#20b2aa', '#87cefa']
            }]
        };

        new Chart(document.getElementById('caloriasChart'), {
            type: 'bar',
            data: data
        });

        // Gráfico comparativo de calorias consumidas vs meta
        const totalCalorias = <%= request.getAttribute("totalCalorias") != null ? request.getAttribute("totalCalorias") : 0 %>;
        const metaCalorias = <%= request.getAttribute("metaCalorias") != null ? request.getAttribute("metaCalorias") : 0 %>;

        new Chart(document.getElementById('comparativoCalorias'), {
            type: 'bar',
            data: {
                labels: ['Consumido', 'Meta'],
                datasets: [{
                    label: 'Calorias (kcal)',
                    data: [totalCalorias, metaCalorias],
                    backgroundColor: ['#4caf50', '#2196f3']
                }]
            },
            options: {
                plugins: {
                    title: {
                        display: true,
                        text: 'Comparativo de Calorias do Dia'
                    }
                }
            }
        });
    </script>
</body>
</html>
