<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Calendário com Vue</title>
    <link rel="stylesheet" type="text/css" href="assets/css/Calendario_estilo.css">
    <script src="https://cdn.jsdelivr.net/npm/vue@3"></script>
    <script type="text/javascript" src="assets/script/Calendario_script.js" defer></script>
</head>
<body>
    <%@ include file="WEB-INF/jspf/header.jspf" %>
    <div id="app">
        <div class="calendario-container">
            <header>
                <button @click="prevMonth" class="nav-btn">❮</button>
                <h2>{{ currentMonthName }} {{ currentYear }}</h2>
                <button @click="nextMonth" class="nav-btn">❯</button>
            </header>
            <table>
                <thead>
                    <tr>
                        <th>DOM</th>
                        <th>SEG</th>
                        <th>TER</th>
                        <th>QUA</th>
                        <th>QUI</th>
                        <th>SEX</th>
                        <th>SAB</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(week, index) in calendarDays" :key="index">
                        <td v-for="(day, idx) in week" :key="idx" :class="{'current-day': isToday(day), 'inactive': day.isOtherMonth}">
                            {{ day.date }}
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
