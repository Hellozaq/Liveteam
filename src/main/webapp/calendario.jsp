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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-TX8t27EcRE3e/ihU7zmQCTmo/sBieD/cH7i7fa/WPvB9E2W5/qOGeTAfF0lC5HEt" crossorigin="anonymous">
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

        <!-- Se um dia for selecionado, exibe esta seção -->
        <div v-if="selectedDay" class="day-info mt-4">
            <h3>Informações para o dia {{ selectedDay.date }}/{{ currentMonth + 1 }}/{{ currentYear }}</h3>
            <table v-if="dailyInfo && dailyInfo.length > 0" class="table table-striped">
                <thead>
                    <tr>
                        <th>Tipo</th>
                        <th>Horário</th>
                        <th>Descrição</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(info, index) in dailyInfo" :key="index">
                        <td>{{ info.tipo }}</td>
                        <td>{{ info.hora }}</td>
                        <td>{{ info.descricao }}</td>
                    </tr>
                </tbody>
            </table>
            <p v-else>Não há atualizações para o dia selecionado.</p>
        </div>
    </div>

    <script type="text/javascript">
        const app = Vue.createApp({
            data() {
                return {
                    currentMonth: new Date().getMonth(),
                    currentYear: new Date().getFullYear(),
                    selectedDay: null, // Armazena o dia selecionado
                    dailyInfo: null,   // Informação diária vinda do banco
                    calendarDays: []   // Dias do calendário (a serem preenchidos)
                };
            },
            methods: {
                selectDay(day) {
                    if (!day.isOtherMonth) {
                        this.selectedDay = day;
                        this.dailyInfo = null; // Limpa informações anteriores

                        // Busca informações do dia selecionado
                        fetch(`obterDadosDiarios.jsp?day=${day.date}&month=${this.currentMonth + 1}&year=${this.currentYear}`)
                            .then(response => response.json())
                            .then(data => {
                                // Verifica se há dados para o dia
                                if (data.length > 0) {
                                    this.dailyInfo = data;
                                } else {
                                    this.dailyInfo = null;
                                }
                            })
                            .catch(error => {
                                console.error("Erro ao buscar dados do dia:", error);
                                this.dailyInfo = null;
                            });
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
                    return day.date === today.getDate() && this.currentMonth === today.getMonth() && this.currentYear === today.getFullYear();
                },
                generateCalendar() {
                    const firstDayOfMonth = new Date(this.currentYear, this.currentMonth, 1);
                    const lastDayOfMonth = new Date(this.currentYear, this.currentMonth + 1, 0);
                    const startDayOfWeek = firstDayOfMonth.getDay();
                    const daysInMonth = lastDayOfMonth.getDate();

                    const weeks = [];
                    let currentWeek = [];

                    // Preencher dias do mês anterior (vazios)
                    for (let i = 0; i < startDayOfWeek; i++) {
                        currentWeek.push({ date: '', isOtherMonth: true });
                    }

                    // Preencher dias do mês atual
                    for (let day = 1; day <= daysInMonth; day++) {
                        currentWeek.push({ date: day, isOtherMonth: false });

                        if (currentWeek.length === 7) {
                            weeks.push(currentWeek);
                            currentWeek = [];
                        }
                    }

                    // Preencher dias do próximo mês (vazios)
                    while (currentWeek.length < 7) {
                        currentWeek.push({ date: '', isOtherMonth: true });
                    }

                    weeks.push(currentWeek);
                    this.calendarDays = weeks;
                }
            },
            computed: {
                currentMonthName() {
                    return new Date(this.currentYear, this.currentMonth).toLocaleString('default', { month: 'long' });
                }
            },
            mounted() {
                this.generateCalendar();
            }
        });

        app.mount('#app');
    </script>

    <%@ include file="WEB-INF/jspf/footer.jspf" %>
</body>
</html>
