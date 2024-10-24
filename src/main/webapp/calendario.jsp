<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Calendário Interativo</title>
    <script src="https://cdn.jsdelivr.net/npm/vue@3"></script>
    
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-TX8t27EcRE3e/ihU7zmQCTmo/sBieD/cH7i7fa/WPvB9E2W5/qOGeTAfF0lC5HEt" crossorigin="anonymous">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/pages/calendario-page.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">  
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
</head>
<body>
    <%@ include file="WEB-INF/jspf/header.jspf" %>
    
    <div id="app">
        <div class="calendario-container">
            <div class="calendar-header">
                <button @click="prevMonth" class="nav-btn">❮</button>
                <h2>{{ currentMonthName }} {{ currentYear }}</h2>
                <button @click="nextMonth" class="nav-btn">❯</button>
            </div>
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

     <script type="text/javascript" src="assets/script/Calendario_script.js" defer></script>
      <%@ include file="WEB-INF/jspf/footer.jspf" %>
</body>
</html>
