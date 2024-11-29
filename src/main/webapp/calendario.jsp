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
    <style>
        .calendario-container {
            max-width: 800px;
            margin: auto;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            background-color: #f9f9f9;
        }

        .calendario-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .nav-btn {
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            font-size: 18px;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        .nav-btn:hover {
            background-color: #0056b3;
        }

        .calendario-title {
            font-size: 2rem;
            font-weight: 600;
            color: #333;
            text-align: center;
        }

        .calendario-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .calendario-thead th {
            font-weight: 600;
            color: #555;
            padding: 12px;
            text-align: center;
        }

        .calendario-day {
            text-align: center;
            vertical-align: middle;
            font-size: 2rem;
            font-weight: 500;
            padding: 20px;
            transition: background-color 0.3s;
            position: relative;
        }

        .calendario-day a {
            display: block; /* Faz o link ocupar toda a célula */
            width: 100%; /* Ocupa toda a célula */
            height: 100%; /* Ocupa toda a célula */
            color: inherit; /* Herda a cor do texto */
            text-decoration: none; /* Remove o sublinhado */
            font-size: 2rem;
            text-align: center;
            line-height: 60px; /* Ajusta a altura da linha para centralizar o número */
        }

        .current-day {
            background-color: #e0f7fa; /* Cor de fundo do dia atual */
            color: #007bff; /* Cor do texto */
            font-weight: bold;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            position: relative;
            border-radius: 0; /* Remove o arredondamento para um quadrado */
        }

        .calendario-day:hover {
            background-color: #f0f8ff;
        }

        .inactive {
            color: #bbb;
            opacity: 0.5;
            pointer-events: none; /* Evita o clique em dias de outro mês */
        }

        .page-description {
            text-align: center;
            margin-bottom: 20px;
            font-size: 1.2rem;
            color: #555;
        }

        .calendario-week {
            border-bottom: 2px solid #e0e0e0;
        }
    </style>
</head>
<body>
    <%@ include file="WEB-INF/jspf/header.jspf" %>
    
    <div id="app" class="app-container">
        <div class="page-description">
            <p></P>
            <p>Use este calendário para navegar pelos dias e acessar dados que registrou em cada data.</p>
        </div>
        
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
                            :class="{'current-day': isToday(day), 'inactive': day.isOtherMonth}">
                            <a v-if="day.date && !day.isOtherMonth" 
                               :href="'exibicaoDadosDiarios.jsp?dia=' + day.date + '&mes=' + (currentMonth + 1) + '&ano=' + currentYear">
                               {{ day.date }}
                            </a>
                            <span v-else>{{ day.date || '-' }}</span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <%@ include file="WEB-INF/jspf/footer.jspf" %>
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
            },
            isCurrentMonth() {
                const today = new Date();
                return today.getMonth() === this.currentMonth && today.getFullYear() === this.currentYear;
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

                const firstWeekday = firstDayOfMonth.getDay();
                const lastWeekday = lastDayOfMonth.getDay();

                let calendar = [];
                let week = [];

                const previousMonth = this.currentMonth === 0 ? 11 : this.currentMonth - 1;
                const previousYear = this.currentMonth === 0 ? this.currentYear - 1 : this.currentYear;
                const lastDayOfPreviousMonth = new Date(previousYear, previousMonth + 1, 0).getDate();

                for (let i = firstWeekday - 1; i >= 0; i--) {
                    week.push({ date: lastDayOfPreviousMonth - i, isOtherMonth: true });
                }

                for (let day = 1; day <= totalDaysInMonth; day++) {
                    week.push({ date: day, isOtherMonth: false });
                    if (week.length === 7) {
                        calendar.push(week);
                        week = [];
                    }
                }

                const daysNeededFromNextMonth = 6 - lastWeekday;
                for (let i = 1; i <= daysNeededFromNextMonth; i++) {
                    week.push({ date: i, isOtherMonth: true });
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
