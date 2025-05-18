// Reveal on scroll
document.querySelectorAll('.reveal-on-scroll').forEach((el) => {
  el.style.visibility = 'hidden';
});
const revealOnScroll = document.querySelectorAll('.reveal-on-scroll');
if ('IntersectionObserver' in window) {
  const io = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        entry.target.style.visibility = 'visible';
        io.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12 });
  revealOnScroll.forEach(el => io.observe(el));
} else {
  revealOnScroll.forEach(el => {
    el.classList.add('visible');
    el.style.visibility = 'visible';
  });
}

// Card tilt
document.querySelectorAll('.card-tilt').forEach(card => {
  card.addEventListener('mousemove', (e) => {
    const rect = card.getBoundingClientRect();
    const x = (e.clientX - rect.left) / rect.width - 0.5;
    const y = (e.clientY - rect.top) / rect.height - 0.5;
    card.style.transform = `rotateY(${x * 10}deg) rotateX(${-y * 10}deg) scale(1.018)`;
    card.classList.add('tilted');
  });
  card.addEventListener('mouseleave', () => {
    card.style.transform = '';
    card.classList.remove('tilted');
  });
});