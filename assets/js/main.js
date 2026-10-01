/* OmniOpenCon — small progressive enhancements. The site works without JavaScript. */
(function () {
  'use strict';

  // Sticky nav: add a border once the page is scrolled.
  var nav = document.querySelector('.site-nav');
  var toggle = document.getElementById('nav-toggle');
  if (nav) {
    var onScroll = function () { nav.classList.toggle('is-scrolled', window.scrollY > 8); };
    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
  }

  // Close the mobile menu after following an in-page link.
  if (toggle) {
    document.querySelectorAll('.nav-links a').forEach(function (a) {
      a.addEventListener('click', function () { toggle.checked = false; });
    });
  }

  // Close the "Editions" dropdown when clicking elsewhere.
  document.addEventListener('click', function (e) {
    document.querySelectorAll('details.dropdown[open]').forEach(function (d) {
      if (!d.contains(e.target)) d.removeAttribute('open');
    });
  });

  // Highlight the nav link of the section currently in view.
  var links = document.querySelectorAll('.nav-list a[data-section]');
  if (links.length && 'IntersectionObserver' in window) {
    var byId = {};
    links.forEach(function (a) { byId[a.dataset.section] = a; });
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        links.forEach(function (a) { a.classList.remove('is-active'); });
        var a = byId[entry.target.id];
        if (a) a.classList.add('is-active');
      });
    }, { rootMargin: '-40% 0px -55% 0px' });
    Object.keys(byId).forEach(function (id) {
      var el = document.getElementById(id);
      if (el) observer.observe(el);
    });
  }

  // Countdown to the event, shown under the hero buttons.
  var cd = document.querySelector('[data-countdown]');
  if (cd) {
    var start = new Date(cd.dataset.countdown);
    var render = function () {
      var ms = start - new Date();
      if (isNaN(ms)) return;
      if (ms <= 0) { cd.innerHTML = '<strong>Happening now.</strong> See you there!'; cd.hidden = false; return; }
      var days = Math.floor(ms / 864e5);
      var hours = Math.floor((ms % 864e5) / 36e5);
      cd.innerHTML = 'Starts in <strong>' + days + ' day' + (days === 1 ? '' : 's') + '</strong> and <strong>' + hours + ' hour' + (hours === 1 ? '' : 's') + '</strong>';
      cd.hidden = false;
    };
    render();
    setInterval(render, 60000);
  }

  // Lightbox for the photo gallery.
  var thumbs = document.querySelectorAll('a[data-lightbox]');
  if (thumbs.length && 'HTMLDialogElement' in window) {
    var dlg = document.createElement('dialog');
    dlg.className = 'lightbox';
    dlg.innerHTML = '<button class="lightbox__close" aria-label="Close">×</button><figure><img alt=""><figcaption></figcaption></figure>';
    document.body.appendChild(dlg);
    var img = dlg.querySelector('img');
    var cap = dlg.querySelector('figcaption');
    dlg.querySelector('button').addEventListener('click', function () { dlg.close(); });
    dlg.addEventListener('click', function (e) { if (e.target === dlg) dlg.close(); });
    thumbs.forEach(function (a) {
      a.addEventListener('click', function (e) {
        e.preventDefault();
        img.src = a.href;
        img.alt = a.dataset.caption || '';
        cap.textContent = a.dataset.caption || '';
        dlg.showModal();
      });
    });
  }
})();
