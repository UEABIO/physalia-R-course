<script>
// Colour palette picker: a swatch button next to the dark-mode toggle.
// The choice is stored in this browser only (localStorage).
(function () {
  var KEY = "advancing-r-palette";
  var palettes = [
    { id: "classic",   name: "Classic teal", dot: "#1f6f6f" },
    { id: "adelie",    name: "Adelie",       dot: "#c87a8a" },
    { id: "chinstrap", name: "Chinstrap",    dot: "#6b9d59" },
    { id: "gentoo",    name: "Gentoo",       dot: "#5f96c2" },
    { id: "barbie",    name: "Barbie",       dot: "#d74ea2" }
  ];

  function current() {
    return document.documentElement.getAttribute("data-palette") || "classic";
  }

  function apply(id) {
    if (id === "classic") document.documentElement.removeAttribute("data-palette");
    else document.documentElement.setAttribute("data-palette", id);
    try { localStorage.setItem(KEY, id); } catch (e) {}
    document.querySelectorAll(".palette-option").forEach(function (o) {
      o.setAttribute("aria-checked", o.dataset.palette === id ? "true" : "false");
    });
  }

  function build(container, n) {
    var wrap = document.createElement("div");
    wrap.className = "palette-picker";

    var btn = document.createElement("button");
    btn.type = "button";
    btn.className = "palette-toggle";
    btn.id = "palette-toggle-" + n;
    btn.title = "Change colour palette";
    btn.setAttribute("aria-label", "Change colour palette");
    btn.setAttribute("aria-haspopup", "true");
    btn.setAttribute("aria-expanded", "false");

    var menu = document.createElement("div");
    menu.className = "palette-menu";
    menu.id = "palette-menu-" + n;
    menu.setAttribute("role", "menu");
    menu.hidden = true;
    menu.innerHTML = '<div class="palette-title">Colour palette</div>';

    palettes.forEach(function (p) {
      var o = document.createElement("button");
      o.type = "button";
      o.className = "palette-option";
      o.setAttribute("role", "menuitemradio");
      o.dataset.palette = p.id;
      o.setAttribute("aria-checked", current() === p.id ? "true" : "false");
      o.innerHTML = '<span class="dot" style="background:' + p.dot + '"></span><span>' + p.name + '</span><span class="tick">✓</span>';
      o.addEventListener("click", function () { apply(p.id); close(); btn.focus(); });
      menu.appendChild(o);
    });

    function place() {
      var r = btn.getBoundingClientRect();
      var left = Math.min(r.left - 8, window.innerWidth - menu.offsetWidth - 8);
      menu.style.left = Math.max(8, left) + "px";
      menu.style.top = (r.bottom + 8) + "px";
    }
    function open() {
      menu.hidden = false;
      place();
      btn.setAttribute("aria-expanded", "true");
      var sel = menu.querySelector('[aria-checked="true"]') || menu.querySelector(".palette-option");
      if (sel) sel.focus();
    }
    function close() {
      menu.hidden = true;
      btn.setAttribute("aria-expanded", "false");
    }

    btn.addEventListener("click", function (e) {
      e.stopPropagation();
      if (menu.hidden) open(); else close();
    });
    menu.addEventListener("keydown", function (e) {
      var items = Array.prototype.slice.call(menu.querySelectorAll(".palette-option"));
      var i = items.indexOf(document.activeElement);
      if (e.key === "Escape") { close(); btn.focus(); }
      if (e.key === "ArrowDown") { e.preventDefault(); items[(i + 1) % items.length].focus(); }
      if (e.key === "ArrowUp") { e.preventDefault(); items[(i - 1 + items.length) % items.length].focus(); }
    });
    document.addEventListener("click", function (e) {
      if (!wrap.contains(e.target)) close();
    });
    window.addEventListener("resize", function () { if (!menu.hidden) place(); });
    window.addEventListener("scroll", function () { if (!menu.hidden) place(); }, true);

    wrap.appendChild(btn);
    wrap.appendChild(menu);
    var toggle = container.querySelector(".quarto-color-scheme-toggle");
    if (toggle) container.insertBefore(wrap, toggle); else container.appendChild(wrap);
  }

  document.querySelectorAll(".sidebar-tools-main, .quarto-navbar-tools").forEach(function (c, n) {
    if (!c.querySelector(".palette-picker")) build(c, n);
  });
})();
</script>
