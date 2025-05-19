<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<% 
    // Verificação de sessão para garantir que o usuário esteja logado
    if (request.getSession(false) == null || request.getSession(false).getAttribute("usuarioLogado") == null) {
        response.sendRedirect("login.jsp"); // Redireciona para a página de login se o usuário não estiver logado
        return;  
    }
%>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Calendário Interativo</title>
    
    <!-- Inclusão da biblioteca Vue.js -->
    <script src="https://cdn.jsdelivr.net/npm/vue@3"></script>
    
    <!-- Phosphor Icons -->
    <link rel="stylesheet" href="https://unpkg.com/@phosphor-icons/web@2.0.3/src/regular/style.css" />
    
    <!-- Estilos personalizados para a página -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/pages/calendario-page.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">  
    
    <!-- Inclusão do cabeçalho comum da página -->
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
</head>

<style>
body {
    /* Garante fundo escuro padrão */
    background: #181c1f;
}
.calendario-page-spacer {
    height: 35px;
}
.calendario-container {
    max-width: 800px;
    margin: auto;
    padding: 24px;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(160, 214, 131, 0.13);
    background-color: #23272b;
    color: #f7f7f7;
}

.calendario-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 14px;
}

.calendario-title {
    font-size: 2rem;
    font-weight: 600;
    color: #A0D683;
    text-align: center;
    letter-spacing: 0.01em;
    display: flex;
    align-items: center;
    gap: 0.5em;
}

.calendario-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
}

.calendario-thead th,
.calendario-th {
    font-weight: 700;
    color: #C5FFB1;
    background: #181c1f;
    padding: 12px;
    text-align: center;
    border-bottom: 2px solid #A0D683;
}

.calendario-day {
    text-align: center;
    vertical-align: middle;
    font-size: 1.25rem;
    font-weight: 500;
    padding: 20px;
    color: #f7f7f7;
    transition: background-color 0.3s;
    position: relative;
    background: #23272b;
}
.calendario-day a {
    display: block;
    width: 100%;
    height: 100%;
    color: #C5FFB1;
    text-decoration: none;
    font-size: 1.3rem;
    text-align: center;
    line-height: 60px;
}
.calendario-day:hover {
    background-color: #32363a;
}
.current-day {
    background-color: #A0D683;
    color: #23272b;
    font-weight: bold;
}
.inactive {
    color: #7a7a7a;
    opacity: 0.5;
    pointer-events: none;
}
.page-description {
    text-align: center;
    margin-bottom: 20px;
    font-size: 1.2rem;
    color: #C5FFB1;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5em;
}

/* Green navigation buttons */
.nav-btn {
    background-color: #A0D683;
    color: #23272b;
    border: none;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    font-size: 22px;
    font-weight: bold;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0 2px 8px 0 rgba(160, 214, 131, 0.12);
    transition: background 0.2s, color 0.2s, box-shadow 0.2s;
}
.nav-btn:hover {
    background-color: #7DD23B;
    color: #181c1f;
    box-shadow: 0 4px 16px #A0D68333;
}
</style>

<body>
    <%@ include file="WEB-INF/jspf/header.jspf" %>
    <div class="calendario-page-spacer"></div>
    
    <!-- Aplicação Vue.js -->
    <div id="app" class="app-container">
        <!-- Descrição da página -->
        <div class="page-description">
            <i class="ph ph-calendar-check"></i>
            <span>Use este calendário para navegar pelos dias e acessar dados que registrou em cada data.</span>
        </div>
        
        <!-- Contêiner do calendário -->
        <div class="calendario-container">
            <!-- Cabeçalho do calendário (com botões de navegação e título) -->
            <div class="calendario-header">
                <button @click="prevMonth" class="nav-btn" title="Mês anterior" aria-label="Mês anterior">
                    <i class="ph ph-caret-left"></i>
                </button>
                <h2 class="calendario-title">
                    <i class="ph ph-calendar-blank"></i>
                    {{ currentMonthName }} {{ currentYear }}
                </h2>
                <button @click="nextMonth" class="nav-btn" title="Próximo mês" aria-label="Próximo mês">
                    <i class="ph ph-caret-right"></i>
                </button>
            </div>

            <!-- Tabela com os dias do mês -->
            <table class="calendario-table">
                <thead class="calendario-thead">
                    <tr class="calendario-tr">
                        <th class="calendario-th" title="Domingo">DOM</th>
                        <th class="calendario-th" title="Segunda-feira">SEG</th>
                        <th class="calendario-th" title="Terça-feira">TER</th>
                        <th class="calendario-th" title="Quarta-feira">QUA</th>
                        <th class="calendario-th" title="Quinta-feira">QUI</th>
                        <th class="calendario-th" title="Sexta-feira">SEX</th>
                        <th class="calendario-th" title="Sábado">SAB</th>
                    </tr>
                </thead>
                <tbody class="calendario-tbody">
                    <!-- Loop para exibir as semanas -->
                    <tr v-for="(week, index) in calendarDays" :key="index" class="calendario-week">
                        <!-- Loop para exibir os dias da semana -->
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

    <!-- Script Vue.js para a funcionalidade do calendário -->
    <script type="text/javascript">
    const app = Vue.createApp({
        data() {
            return {
                currentMonth: new Date().getMonth(),
                currentYear: new Date().getFullYear(),
                calendarDays: [] // Array para armazenar os dias do calendário
            };
        },
        computed: {
            // Computed property para o nome do mês atual
            currentMonthName() {
                const months = [
                    "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
                    "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
                ];
                return months[this.currentMonth];
            },
            // Computed property para verificar se o mês atual é o mês corrente
            isCurrentMonth() {
                const today = new Date();
                return today.getMonth() === this.currentMonth && today.getFullYear() === this.currentYear;
            }
        },
        methods: {
            // Método para ir para o mês anterior
            prevMonth() {
                this.currentMonth--;
                if (this.currentMonth < 0) {
                    this.currentMonth = 11;
                    this.currentYear--;
                }
                this.generateCalendar();
            },
            // Método para ir para o próximo mês
            nextMonth() {
                this.currentMonth++;
                if (this.currentMonth > 11) {
                    this.currentMonth = 0;
                    this.currentYear++;
                }
                this.generateCalendar();
            },
            // Método para verificar se o dia é o atual
            isToday(day) {
                const today = new Date();
                return (
                    day.date &&
                    day.date === today.getDate() &&
                    this.currentMonth === today.getMonth() &&
                    this.currentYear === today.getFullYear()
                );
            },
            // Método para gerar o calendário
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

                // Preencher dias do mês anterior
                for (let i = firstWeekday - 1; i >= 0; i--) {
                    week.push({ date: lastDayOfPreviousMonth - i, isOtherMonth: true });
                }

                // Preencher os dias do mês atual
                for (let day = 1; day <= totalDaysInMonth; day++) {
                    week.push({ date: day, isOtherMonth: false });
                    if (week.length === 7) {
                        calendar.push(week);
                        week = [];
                    }
                }

                // Preencher dias do próximo mês
                const daysNeededFromNextMonth = 6 - lastWeekday;
                for (let i = 1; i <= daysNeededFromNextMonth; i++) {
                    week.push({ date: i, isOtherMonth: true });
                }

                if (week.length > 0) calendar.push(week);

                this.calendarDays = calendar;
            }
        },
        mounted() {
            this.generateCalendar(); // Gerar o calendário ao carregar a página
        }
    });
    app.mount("#app");
    </script>

</body>
</html>