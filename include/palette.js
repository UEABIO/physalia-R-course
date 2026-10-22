<script>
// Display settings in the header bar: colour palette, night mode,
// colour-blind friendly mode and text size. Choices are stored in this
// browser only.
(function () {
  var KEY = "advancing-r-palette";
  var CVD_KEY = "advancing-r-cvd";
  var TEXT_KEY = "advancing-r-text";
  var TEXT_MIN = 85, TEXT_MAX = 140, TEXT_STEP = 5;
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
  function textSize() {
    var v = parseFloat(root.style.getPropertyValue("--text-scale"));
    return isNaN(v) ? 100 : Math.round(v * 100);
  }
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
  function setText(pct) {
    pct = Math.min(TEXT_MAX, Math.max(TEXT_MIN, pct));
    if (pct === 100) root.style.removeProperty("--text-scale");
    else root.style.setProperty("--text-scale", pct / 100);
    store(TEXT_KEY, String(pct));
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
    var t = textSize();
    document.querySelectorAll(".site-tool-text .tool-state, .text-size-value").forEach(function (el) {
      el.textContent = t + "%";
    });
    document.querySelectorAll(".text-size-row input").forEach(function (r) {
      r.value = t;
      r.setAttribute("aria-valuetext", t + "%");
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

  // A button that opens a panel below it
  var menus = [];
  function attachMenu(btn, menu, focusSel) {
    menu.className = "tool-menu " + (menu.className || "");
    menu.hidden = true;
    document.body.appendChild(menu);
    menus.push({ btn: btn, menu: menu });

    function place() {
      var r = btn.getBoundingClientRect();
      var left = Math.min(r.right - menu.offsetWidth, window.innerWidth - menu.offsetWidth - 8);
      menu.style.left = Math.max(8, left) + "px";
      menu.style.top = (r.bottom + 8) + "px";
    }
    function open() {
      closeAll();
      menu.hidden = false; place();
      btn.setAttribute("aria-expanded", "true");
      var f = menu.querySelector(focusSel);
      if (f) f.focus();
    }
    btn.addEventListener("click", function (e) {
      e.stopPropagation();
      if (menu.hidden) open(); else closeAll();
    });
    menu.addEventListener("click", function (e) { e.stopPropagation(); });
    menu.addEventListener("keydown", function (e) {
      if (e.key === "Escape") { closeAll(); btn.focus(); }
    });
    window.addEventListener("resize", function () { if (!menu.hidden) place(); });
    window.addEventListener("scroll", function () { if (!menu.hidden) place(); }, true);
  }
  function closeAll() {
    menus.forEach(function (m) { m.menu.hidden = true; m.btn.setAttribute("aria-expanded", "false"); });
  }
  document.addEventListener("click", closeAll);

  function buildToolbar(container) {
    var bar = document.createElement("div");
    bar.className = "site-tools";
    bar.setAttribute("role", "toolbar");
    bar.setAttribute("aria-label", "Display settings");

    // 1. Palette
    var pal = button("site-tool-palette", "bi-palette", "Palette",
      { "aria-haspopup": "true", "aria-expanded": "false", id: "site-tool-palette",
        title: "Change the colour palette" });
    var pmenu = document.createElement("div");
    pmenu.setAttribute("role", "menu");
    pmenu.setAttribute("aria-labelledby", pal.id);
    pmenu.innerHTML = '<div class="menu-title">Colour palette</div>';
    palettes.forEach(function (p) {
      var o = document.createElement("button");
      o.type = "button";
      o.className = "palette-option";
      o.setAttribute("role", "menuitemradio");
      o.dataset.palette = p.id;
      o.innerHTML = '<span class="dot' + (p.id === "emperor" ? " emperor" : "") +
        '" style="background:' + p.dot + '"></span><span>' + p.name +
        '</span><span class="tick">✓</span>';
      o.addEventListener("click", function () { applyPalette(p.id); closeAll(); pal.focus(); });
      pmenu.appendChild(o);
    });
    pmenu.addEventListener("keydown", function (e) {
      var items = Array.prototype.slice.call(pmenu.querySelectorAll(".palette-option"));
      var i = items.indexOf(document.activeElement);
      if (e.key === "ArrowDown") { e.preventDefault(); items[(i + 1) % items.length].focus(); }
      if (e.key === "ArrowUp") { e.preventDefault(); items[(i - 1 + items.length) % items.length].focus(); }
    });
    attachMenu(pal, pmenu, '[aria-checked="true"], .palette-option');

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

    // 4. Text size (far right)
    var txt = button("site-tool-text", "bi-fonts", "Text size",
      { "aria-haspopup": "true", "aria-expanded": "false", id: "site-tool-text",
        title: "Make the text bigger or smaller" });
    var tmenu = document.createElement("div");
    tmenu.setAttribute("role", "dialog");
    tmenu.setAttribute("aria-label", "Text size");
    tmenu.innerHTML =
      '<div class="menu-title">Text size</div>' +
      '<div class="text-size-row"><span class="small-a" aria-hidden="true">A</span>' +
      '<input type="range" min="' + TEXT_MIN + '" max="' + TEXT_MAX + '" step="' + TEXT_STEP +
      '" aria-label="Text size">' +
      '<span class="big-a" aria-hidden="true">A</span></div>' +
      '<div class="text-size-foot"><span class="text-size-value"></span>' +
      '<button type="button" class="text-size-reset">Reset</button></div>';
    tmenu.querySelector("input").addEventListener("input", function (e) {
      setText(parseInt(e.target.value, 10));
    });
    tmenu.querySelector(".text-size-reset").addEventListener("click", function () { setText(100); });
    attachMenu(txt, tmenu, "input");

    bar.appendChild(pal);
    bar.appendChild(night);
    bar.appendChild(cvd);
    bar.appendChild(txt);
    container.appendChild(bar);
  }

  var container = document.querySelector("#quarto-header .navbar-container");
  if (container) {
    buildToolbar(container);
    root.classList.add("has-site-tools");
  }

  // Course logo: hide it rather than show a broken image if it is missing
  document.querySelectorAll("#quarto-header img.navbar-logo").forEach(function (img) {
    function drop() { img.remove(); }
    if (img.complete && img.naturalWidth === 0) drop();
    else img.addEventListener("error", drop);
  });

  // Stay in sync if dark mode is changed any other way
  new MutationObserver(sync).observe(document.body, { attributes: true, attributeFilter: ["class"] });
  sync();
})();
</script>
