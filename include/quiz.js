<script>
// Quiz cards (.quiz-q): show the explanation (.quiz-explain) once the
// question has been answered, with a "Correct" or "Not quite" verdict.
// Runs after include/webex.js, which marks answers webex-correct/-incorrect.
(function () {
  document.documentElement.classList.add("quiz-js");

  document.querySelectorAll(".quiz-q").forEach(function (card) {
    var explain = card.querySelector(".quiz-explain");
    if (!explain) return;

    var verdict = document.createElement("p");
    verdict.className = "quiz-verdict";
    explain.insertBefore(verdict, explain.firstChild);

    var select = card.querySelector("select.webex-select");
    var radios = card.querySelector(".webex-radiogroup");
    var text = card.querySelector("input.webex-solveme");

    function isCorrect() {
      if (select) return select.classList.contains("webex-correct");
      if (radios) return !!radios.querySelector("label.webex-correct input:checked");
      if (text) return text.classList.contains("webex-correct");
      return false;
    }
    function reveal() {
      var ok = isCorrect();
      card.classList.toggle("quiz-right", ok);
      card.classList.toggle("quiz-wrong", !ok);
      verdict.textContent = ok ? "Correct" : "Not quite";
      explain.classList.add("shown");
    }
    function hide() {
      card.classList.remove("quiz-right", "quiz-wrong");
      explain.classList.remove("shown");
    }
    // webex updates its classes in its own listeners; read them afterwards
    function later(fn) { return function () { setTimeout(fn, 0); }; }

    if (select) {
      select.addEventListener("change", later(function () {
        if (select.value === "blank") hide(); else reveal();
      }));
    }
    if (radios) radios.addEventListener("change", later(reveal));
    if (text) {
      // a right answer shows at once; a wrong one waits until Enter or leaving the box
      text.addEventListener("input", later(function () {
        if (text.value.trim() === "") hide();
        else if (isCorrect()) reveal();
      }));
      text.addEventListener("change", later(function () {
        if (text.value.trim() !== "") reveal();
      }));
    }
  });
})();
</script>
