<script>
// Display settings toolbar in the sidebar: colour palette, night mode and
// colour-blind friendly mode. Choices are stored in this browser only.
(function () {
  var KEY = "advancing-r-palette";
  var CVD_KEY = "advancing-r-cvd";
  var palettes = [
    { id: "classic",    name: "Classic teal", dot: "#1f6f6f" },
    { id: "adelie",     name: "Adelie",       dot: "#c87a8a" },
    { id: "chinstrap",  name: "Chinstrap",    dot: "#6b9d59" },
    { id: "gentoo",     name: "Gentoo",       dot: "#5f96c2" },
    { id: "rockhopper", name: "Rockhopper",   dot: "#d74ea2" },
    { id: "king",       name: "King",         dot: "#d95f02" },
    { id: "emperor",    name: "Emperor",      dot: "#46337e" }
  ];
  var root = document.documentElement;

  function store(k, v) { try { localStorage.setItem(k, v); } catch (e) {} }
  function currentPalette() { return root.getAttribute("data-palette") || "classic"; }
  function cvdOn() { return root.getAttribute("data-cvd") === "on"; }
  function isDark() { return document.body.classList.contains("quarto-dark"); }
  function paletteInfo(id) {
    for (var i = 0; i < palettes.length; i++) if (palettes[i].id === id) return palettes[i];
    return palettes[0];
  }

  function applyPalette(id) {
    if (id === "classic") root.removeAttribute("data-palette");
    else root.setAttribute("data-palette", id);
    store(KEY, id);
    sync();
  }
  function setCvd(on) {
    if (on) root.setAttribute("data-cvd", "on"); else root.removeAttribute("data-cvd");
    store(CVD_KEY, on ? "on" : "off");
    sync();
  }

  // Keep every control's label and state in line with the page
  function sync() {
    var p = paletteInfo(currentPalette());
    document.querySelectorAll(".site-tool-palette .tool-state").forEach(function (el) {
      el.textContent = p.name;
    });
    document.querySelectorAll(".palette-option").forEach(function (o) {
      o.setAttribute("aria-checked", o.dataset.palette === p.id ? "true" : "false");
    });
    document.querySelectorAll(".site-tool-night").forEach(function (b) {
      b.setAttribute("aria-checked", isDark() ? "true" : "false");
      b.querySelector(".bi").className = "bi " + (isDark() ? "bi-moon-stars-fill" : "bi-moon-stars");
      b.querySelector(".tool-state").textContent = isDark() ? "On" : "Off";
    });
    document.querySelectorAll(".site-tool-cvd").forEach(function (b) {
      b.setAttribute("aria-checked", cvdOn() ? "true" : "false");
      b.querySelector(".bi").className = "bi " + (cvdOn() ? "bi-eye-fill" : "bi-eye");
      b.querySelector(".tool-state").textContent = cvdOn() ? "On" : "Off";
    });
  }

  function button(cls, icon, label, extra) {
    var b = document.createElement("button");
    b.type = "button";
    b.className = "site-tool " + cls;
    for (var k in extra) b.setAttribute(k, extra[k]);
    b.innerHTML = '<i class="bi ' + icon + '" aria-hidden="true"></i>' +
      '<span class="tool-label">' + label + '</span>' +
      '<span class="tool-state"></span>';
    return b;
  }

  function buildToolbar(anchor, n) {
    var bar = document.createElement("div");
    bar.className = "site-tools";
    bar.setAttribute("role", "toolbar");
    bar.setAttribute("aria-label", "Display settings");

    // 1. Palette (opens a menu)
    var pal = button("site-tool-palette", "bi-palette", "Palette",
      { "aria-haspopup": "true", "aria-expanded": "false", id: "site-tool-palette-" + n,
        title: "Change the colour palette" });
    var menu = document.createElement("div");
    menu.className = "palette-menu";
    menu.setAttribute("role", "menu");
    menu.setAttribute("aria-labelledby", pal.id);
    menu.hidden = true;
    menu.innerHTML = '<div class="palette-title">Colour palette</div>';
    palettes.forEach(function (p) {
      var o = document.createElement("button");
      o.type = "button";
      o.className = "palette-option";
      o.setAttribute("role", "menuitemradio");
      o.dataset.palette = p.id;
      o.innerHTML = '<span class="dot' + (p.id === "emperor" ? " emperor" : "") +
        '" style="background:' + p.dot + '"></span><span>' + p.name +
        '</span><span class="tick">✓</span>';
      o.addEventListener("click", function () { applyPalette(p.id); close(); pal.focus(); });
      menu.appendChild(o);
    });

    function place() {
      var r = pal.getBoundingClientRect();
      var left = Math.min(r.left, window.innerWidth - menu.offsetWidth - 8);
      menu.style.left = Math.max(8, left) + "px";
      menu.style.top = (r.bottom + 6) + "px";
    }
    function open() {
      menu.hidden = false; place();
      pal.setAttribute("aria-expanded", "true");
      var sel = menu.querySelector('[aria-checked="true"]') || menu.querySelector(".palette-option");
      if (sel) sel.focus();
    }
    function close() { menu.hidden = true; pal.setAttribute("aria-expanded", "false"); }

    pal.addEventListener("click", function (e) {
      e.stopPropagation();
      if (menu.hidden) open(); else close();
    });
    menu.addEventListener("keydown", function (e) {
      var items = Array.prototype.slice.call(menu.querySelectorAll(".palette-option"));
      var i = items.indexOf(document.activeElement);
      if (e.key === "Escape") { close(); pal.focus(); }
      if (e.key === "ArrowDown") { e.preventDefault(); items[(i + 1) % items.length].focus(); }
      if (e.key === "ArrowUp") { e.preventDefault(); items[(i - 1 + items.length) % items.length].focus(); }
    });
    document.addEventListener("click", function (e) {
      if (!menu.contains(e.target) && e.target !== pal) close();
    });
    window.addEventListener("resize", function () { if (!menu.hidden) place(); });
    window.addEventListener("scroll", function () { if (!menu.hidden) place(); }, true);

    // 2. Night mode (uses Quarto's own dark theme)
    var night = button("site-tool-night", "bi-moon-stars", "Night mode",
      { role: "switch", title: "Switch night mode on or off" });
    night.addEventListener("click", function () {
      if (window.quartoToggleColorScheme) window.quartoToggleColorScheme();
      setTimeout(sync, 50);
    });

    // 3. Colour-blind friendly mode
    var cvd = button("site-tool-cvd", "bi-eye", "Colour-blind",
      { role: "switch",
        title: "Colour-blind friendly: blue/orange quiz feedback and underlined links" });
    cvd.addEventListener("click", function () { setCvd(!cvdOn()); });

    bar.appendChild(pal);
    bar.appendChild(night);
    bar.appendChild(cvd);
    anchor.insertAdjacentElement("afterend", bar);
    document.body.appendChild(menu);
  }

  var anchors = document.querySelectorAll("#quarto-sidebar .sidebar-header");
  anchors.forEach(function (a, n) { buildToolbar(a, n); });
  if (anchors.length) root.classList.add("has-site-tools");

  // Stay in sync if dark mode is changed any other way
  new MutationObserver(sync).observe(document.body, { attributes: true, attributeFilter: ["class"] });
  sync();
})();
</script>
