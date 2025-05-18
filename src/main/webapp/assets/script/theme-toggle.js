// Simple dark mode toggle using CSS variables
const toggle = document.getElementById('theme-toggle');
if (toggle) {
  toggle.addEventListener('click', () => {
    if (document.documentElement.hasAttribute('data-theme-dark')) {
      document.documentElement.removeAttribute('data-theme-dark');
      localStorage.setItem('theme', 'light');
    } else {
      document.documentElement.setAttribute('data-theme-dark', 'true');
      localStorage.setItem('theme', 'dark');
    }
  });
  // On load, set from localStorage
  if (localStorage.getItem('theme') === 'dark') {
    document.documentElement.setAttribute('data-theme-dark', 'true');
  }
}

function updateIcon() {
  if (!toggle) return;
  if (document.documentElement.hasAttribute('data-theme-dark')) {
    toggle.textContent = '☀️';
  } else {
    toggle.textContent = '🌙';
  }
}
if (toggle) {
  toggle.addEventListener('click', updateIcon);
  // Set icon on load
  updateIcon();
}