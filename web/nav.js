document.addEventListener('click', function (e) {
  if (e.target.closest('.navbar-mobile-link,.navbar-mobile-cta')) {
    var t = document.getElementById('nav-mobile-toggle');
    if (t) t.checked = false;
  }
});
