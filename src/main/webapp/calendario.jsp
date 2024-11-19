<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<% 
    if (request.getSession(false) == null || request.getSession(false).getAttribute("usuarioLogado") == null) {
        response.sendRedirect("login.jsp");
        return;  
    }
%>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Calendário Interativo</title>
    <script src="https://cdn.jsdelivr.net/npm/vue@3"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/pages/calendario-page.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">  
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
</head>
<body>
    <%@ include file="WEB-INF/jspf/header.jspf" %>
    
    <div id="app" class="app-container">
        <div class="calendario-container">
            <div class="calendario-header">
                <button @click="prevMonth" class="nav-btn">❮</button>
                <h2 class="calendario-title">{{ currentMonthName }} {{ currentYear }}</h2>
                <button @click="nextMonth" class="nav-btn">❯</button>
            </div>
            <table class="calendario-table">
                <thead class="calendario-thead">
                    <tr class="calendario-tr">
                        <th class="calendario-th">DOM</th>
                        <th class="calendario-th">SEG</th>
                        <th class="calendario-th">TER</th>
                        <th class="calendario-th">QUA</th>
                        <th class="calendario-th">QUI</th>
                        <th class="calendario-th">SEX</th>
                        <th class="calendario-th">SAB</th>
                    </tr>
                </thead>
                <tbody class="calendario-tbody">
                    <tr v-for="(week, index) in calendarDays" :key="index" class="calendario-week">
                        <td v-for="(day, idx) in week" :key="idx" class="calendario-day" 
                            :class="{'current-day rounded-pill': isToday(day), 'inactive': day.isOtherMonth}">
                            <form action="teste.jsp" method="GET">
                                <input type="hidden" name="dia" :value="day.date">
                                <input type="hidden" name="mes" :value="currentMonth + 1">
                                <input type="hidden" name="ano" :value="currentYear">
                                <button type="submit" class="btn btn-link p-0" v-if="!day.isOtherMonth && day.date">
                                    {{ day.date }}
                                </button>
                                <span v-else>{{ day.date }}</span>
                            </form>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <script type="text/javascript">
        const app = Vue.createApp({
            data() {
                return {
                    currentMonth: new Date().getMonth(),
                    currentYear: new Date().getFullYear(),
                    calendarDays: []
                };
            },
            computed: {
                currentMonthName() {
                    const months = [
                        "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
                        "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
                    ];
                    return months[this.currentMonth];
                }
            },
            methods: {
                prevMonth() {
                    this.currentMonth--;
                    if (this.currentMonth < 0) {
                        this.currentMonth = 11;
                        this.currentYear--;
                    }
                    this.generateCalendar();
                },
                nextMonth() {
                    this.currentMonth++;
                    if (this.currentMonth > 11) {
                        this.currentMonth = 0;
                        this.currentYear++;
                    }
                    this.generateCalendar();
                },
                isToday(day) {
                    const today = new Date();
                    return (
                        day.date &&
                        day.date === today.getDate() &&
                        this.currentMonth === today.getMonth() &&
                        this.currentYear === today.getFullYear()
                    );
                },
                generateCalendar() {
                    const firstDayOfMonth = new Date(this.currentYear, this.currentMonth, 1);
                    const lastDayOfMonth = new Date(this.currentYear, this.currentMonth + 1, 0);
                    const totalDaysInMonth = lastDayOfMonth.getDate();
                    let calendar = [];
                    let week = [];
                    for (let i = 0; i < firstDayOfMonth.getDay(); i++) {
                        week.push({ date: '', isOtherMonth: true });
                    }
                    for (let day = 1; day <= totalDaysInMonth; day++) {
                        week.push({ date: day, isOtherMonth: false });
                        if (week.length === 7) {
                            calendar.push(week);
                            week = [];
                        }
                    }
                    while (week.length < 7) {
                        week.push({ date: '', isOtherMonth: true });
                    }
                    if (week.length > 0) calendar.push(week);
                    this.calendarDays = calendar;
                }
            },
            mounted() {
                this.generateCalendar();
            }
        });
        app.mount("#app");
    </script>
</body>
</html>
