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
    
    <!-- Inclusão do Bootstrap para estilização -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Estilos personalizados para a página -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/pages/calendario-page.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">  
    
    <!-- Inclusão do cabeçalho comum da página -->
    <%@ include file="WEB-INF/jspf/html-head.jspf" %>
</head>

<!-- Estilos personalizados da página -->
<style>
    /* Estilos para o contêiner do calendário */
    .calendario-container {
        max-width: 800px;
        margin: auto;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        background-color: #f9f9f9;
    }

    /* Estilos para o cabeçalho do calendário */
    .calendario-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
    }

    /* Botões de navegação */
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

    /* Hover para o botão de navegação */
    .nav-btn:hover {
        background-color: #0056b3;
    }

    /* Título do calendário */
    .calendario-title {
        font-size: 2rem;
        font-weight: 600;
        color: #333;
        text-align: center;
    }

    /* Estilos para a tabela do calendário */
    .calendario-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }

    /* Estilos para os dias da semana no cabeçalho da tabela */
    .calendario-thead th {
        font-weight: 600;
        color: #555;
        padding: 12px;
        text-align: center;
    }

    /* Estilos para cada célula do dia no calendário */
    .calendario-day {
        text-align: center;
        vertical-align: middle;
        font-size: 2rem;
        font-weight: 500;
        padding: 20px;
        transition: background-color 0.3s;
        position: relative;
    }

    /* Estilos para o link do dia */
    .calendario-day a {
        display: block;
        width: 100%;
        height: 100%;
        color: inherit;
        text-decoration: none;
        font-size: 2rem;
        text-align: center;
        line-height: 60px;
    }

    /* Estilos para o dia atual */
    .current-day {
        background-color: #e0f7fa;
        color: #007bff;
        font-weight: bold;
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto;
        position: relative;
        border-radius: 0;
    }

    /* Hover para os dias do calendário */
    .calendario-day:hover {
        background-color: #f0f8ff;
    }

    /* Estilos para os dias do outro mês */
    .inactive {
        color: #bbb;
        opacity: 0.5;
        pointer-events: none; /* Evita cliques nos dias de outro mês */
    }

    /* Estilo para a descrição da página */
    .page-description {
        text-align: center;
        margin-bottom: 20px;
        font-size: 1.2rem;
        color: #555;
    }

    /* Estilo para as semanas do calendário */
    .calendario-week {
        border-bottom: 2px solid #e0e0e0;
    }
</style>

<body>
    <!-- Inclusão do cabeçalho comum da página -->
    <%@ include file="WEB-INF/jspf/header.jspf" %>
    
    <!-- Aplicação Vue.js -->
    <div id="app" class="app-container">
        <!-- Descrição da página -->
        <div class="page-description">
            <p>Use este calendário para navegar pelos dias e acessar dados que registrou em cada data.</p>
        </div>
        
        <!-- Contêiner do calendário -->
        <div class="calendario-container">
            <!-- Cabeçalho do calendário (com botões de navegação e título) -->
            <div class="calendario-header">
                <button @click="prevMonth" class="nav-btn">❮</button>
                <h2 class="calendario-title">{{ currentMonthName }} {{ currentYear }}</h2>
                <button @click="nextMonth" class="nav-btn">❯</button>
            </div>

            <!-- Tabela com os dias do mês -->
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

    <!-- Inclusão do rodapé comum da página -->
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
