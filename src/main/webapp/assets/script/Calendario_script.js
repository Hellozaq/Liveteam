const { createApp } = Vue;

createApp({
    data() {
        return {
            today: new Date(),
            currentMonth: new Date().getMonth(),
            currentYear: new Date().getFullYear(),
            months: ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
        };
    },
    computed: {
        currentMonthName() {
            return this.months[this.currentMonth];
        },
        calendarDays() {
            const firstDay = new Date(this.currentYear, this.currentMonth, 1).getDay();
            const daysInMonth = 32 - new Date(this.currentYear, this.currentMonth, 32).getDate();
            let days = [];
            let date = 1;
            let nextMonthDate = 1;
            let previousMonthDate = new Date(this.currentYear, this.currentMonth, 0).getDate() - firstDay + 1;

            for (let i = 0; i < 6; i++) {
                let week = [];
                for (let j = 0; j < 7; j++) {
                    if (i === 0 && j < firstDay) {
                        week.push({ date: previousMonthDate++, isOtherMonth: true });
                    } else if (date > daysInMonth) {
                        week.push({ date: nextMonthDate++, isOtherMonth: true });
                    } else {
                        week.push({ date, isOtherMonth: false });
                        date++;
                    }
                }
                days.push(week);
            }
            return days;
        }
    },
    methods: {
        prevMonth() {
            if (this.currentMonth === 0) {
                this.currentMonth = 11;
                this.currentYear--;
            } else {
                this.currentMonth--;
            }
        },
        nextMonth() {
            if (this.currentMonth === 11) {
                this.currentMonth = 0;
                this.currentYear++;
            } else {
                this.currentMonth++;
            }
        },
        isToday(day) {
            return !day.isOtherMonth &&
                day.date === this.today.getDate() &&
                this.currentMonth === this.today.getMonth() &&
                this.currentYear === this.today.getFullYear();
        }
    }
}).mount('#app');