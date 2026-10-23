# agent/mini_agent.R ----
# A small coding agent: Claude, three tools, and the loop ellmer runs for you.
# Load it from your workshop repository with
#   source(here::here("agent", "mini_agent.R"))
# then talk to `chat`.
library(ellmer)

# the model: "claude-opus-5-5" is a larger model, at a higher price per token
model <- "claude-sonnet-5-5"

# your API key, from the AGENT_ANTHROPIC_KEY line in your user-level .Renviron;
# it has its own name so that Claude Code never offers to use it
agent_key <- function() Sys.getenv("AGENT_ANTHROPIC_KEY")
if (agent_key() == "") {
  stop("No AGENT_ANTHROPIC_KEY found: add it with usethis::edit_r_environ(), ",
       "then restart R.")
}

# the agent's deny rule: a path must sit inside `folder`, and never be a
# credentials file ----
root <- here::here()
allowed <- function(path, folder = root) {
  full <- fs::path_norm(fs::path_abs(path, start = root))
  if (!fs::path_has_parent(full, folder) || fs::path_file(full) %in% c(".Renviron", ".env")) {
    stop("Refused: ", path)
  }
  full
}

# the tools ----
read_file <- tool(
  function(path) paste(readLines(allowed(path), warn = FALSE), collapse = "\n"),
  name = "read_file",
  description = "Read a text file in the project.",
  arguments = list(path = type_string("A file, relative to the project root."))
)
write_file <- tool(
  function(path, content) {
    writeLines(content, allowed(path, folder = fs::path(root, "scripts")))
    paste("Wrote", path)
  },
  name = "write_file",
  description = "Replace the whole contents of a text file under scripts/.",
  arguments = list(
    path = type_string("A file under scripts/, relative to the project root."),
    content = type_string("The complete new contents of the file.")
  )
)
run_test <- tool(
  function() {
    # the one thing it can run: the translation test, in a fresh R session
    out <- callr::r(function() utils::capture.output(
      testthat::test_file("tests/test_translation.R", reporter = "summary")
    ))
    paste(utils::tail(out, 40), collapse = "\n")
  },
  name = "run_test",
  description = "Run tests/test_translation.R in a fresh R session and return its output."
)

# Manual mode: show every write or test run, and ask before it happens ----
ask_first <- function(request) {
  if (request@name %in% c("write_file", "run_test")) {
    cat("\nThe agent wants to call", request@name, "with:\n")
    for (arg in names(request@arguments)) {
      cat("--", arg, "--\n", request@arguments[[arg]], "\n")
    }
    if (utils::menu(c("Yes", "No"), title = "Allow it?") != 1) tool_reject()
  }
}

chat <- chat_anthropic(
  model = model,
  credentials = agent_key,
  system_prompt = paste(
    "You are a careful R assistant working in this project.",
    "Read files before you change them. Write files only under scripts/;",
    "never edit tests/. Code you write must work in a fresh R session, so load",
    "packages with library() or call them with pkg::. Say what you changed,",
    "and stop when the task is done."
  )
)
chat$register_tools(list(read_file, write_file, run_test))
chat$on_tool_request(ask_first)
