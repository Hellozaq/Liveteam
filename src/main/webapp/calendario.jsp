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
                            :class="{'current-day rounded-pill': isToday(day), 'inactive': day.isOtherMonth}" 
                            @click="selectDay(day)">
                            {{ day.date }}
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <div v-if="selectedDay" class="day-info mt-4">
            <h3>Informações para o dia {{ selectedDay.date }}/{{ currentMonth + 1 }}/{{ currentYear }}</h3>
            
            <div v-if="dailyInfo && dailyInfo.alimentacao" class="info-section">
                <h4>Alimentação</h4>
                <ul>
                    <li><strong>Café da Manhã:</strong> {{ dailyInfo.alimentacao.cafeDaManha }}</li>
                    <li><strong>Almoço:</strong> {{ dailyInfo.alimentacao.almoco }}</li>
                    <li><strong>Jantar:</strong> {{ dailyInfo.alimentacao.jantar }}</li>
                    <li><strong>Lanches:</strong> {{ dailyInfo.alimentacao.lanches }}</li>
                    <li><strong>Observações:</strong> {{ dailyInfo.alimentacao.observacoes }}</li>
                </ul>
            </div>

            <div v-if="dailyInfo && dailyInfo.liquidos" class="info-section">
                <h4>Líquidos</h4>
                <ul>
                    <li><strong>Água:</strong> {{ dailyInfo.liquidos.agua }}</li>
                    <li><strong>Outros Líquidos:</strong> {{ dailyInfo.liquidos.outros }}</li>
                    <li><strong>Observações:</strong> {{ dailyInfo.liquidos.observacoes }}</li>
                </ul>
            </div>

            <div v-if="dailyInfo && dailyInfo.exercicios" class="info-section">
                <h4>Exercícios</h4>
                <ul>
                    <li><strong>Tipo de Treino:</strong> {{ dailyInfo.exercicios.tipoTreino }}</li>
                    <li><strong>Duração:</strong> {{ dailyInfo.exercicios.duracao }}</li>
                    <li><strong>Intensidade:</strong> {{ dailyInfo.exercicios.intensidade }}</li>
                    <li><strong>Detalhes:</strong> {{ dailyInfo.exercicios.detalhes }}</li>
                    <li><strong>Observações:</strong> {{ dailyInfo.exercicios.observacoes }}</li>
                </ul>
            </div>

            <div v-if="dailyInfo && dailyInfo.avaliacao" class="info-section">
                <h4>Avaliação</h4>
                <ul>
                    <li><strong>Nível de Fome:</strong> {{ dailyInfo.avaliacao.fome }}</li>
                    <li><strong>Nível de Energia:</strong> {{ dailyInfo.avaliacao.energia }}</li>
                    <li><strong>Qualidade do Sono:</strong> {{ dailyInfo.avaliacao.sono }}</li>
                    <li><strong>Observações:</strong> {{ dailyInfo.avaliacao.observacoes }}</li>
                </ul>
            </div>

            <p v-else>Não há atualizações para o dia selecionado.</p>
        </div>
    </div>

    <script type="text/javascript">
const app = Vue.createApp({
    data() {
        return {
            currentMonth: new Date().getMonth(),
            currentYear: new Date().getFullYear(),
            selectedDay: null, // Corrigido
            dailyInfo: null,
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
        selectDay(day) {
            if (!day.isOtherMonth && day.date) {
                console.log('Dia selecionado:', day); 
                this.selectedDay = day;
                const url = "/Liveteam/obterDadosDiarios.jsp?dia=${day.date}&mes=${this.currentMonth + 1}&ano=${this.currentYear}";
                console.log(`URL de requisição: ${url}`);
                fetch(url)
                    .then(response => {
                        if (!response.ok) throw new Error(`Erro na resposta: ${response.status}`);
                        return response.json();
                    })
                    .then(data => {
                        console.log("Dados recebidos:", data);
                        this.dailyInfo = data.length > 0 ? data : null;
                    })
                    .catch(error => {
                        console.error("Erro no fetch:", error);
                        this.dailyInfo = null;
                    });
            } else {
                console.error("O dia selecionado está vazio ou é de outro mês");
            }
        },
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
