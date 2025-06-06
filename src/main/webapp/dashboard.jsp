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

    <script>
        const data = {
            labels: ['Café', 'Almoço', 'Jantar', 'Lanches'],
            datasets: [{
                label: 'Calorias (kcal)',
                data: [<%= request.getAttribute("cafe") %>, <%= request.getAttribute("almoco") %>, 
                       <%= request.getAttribute("jantar") %>, <%= request.getAttribute("lanches") %>],
                backgroundColor: ['#ffa07a', '#f08080', '#20b2aa', '#87cefa']
            }]
        };

        new Chart(document.getElementById('caloriasChart'), {
            type: 'bar',
            data: data
        });
    </script>
</body>
</html>
    