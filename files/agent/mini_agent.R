# mini_agent.R ----
# A small coding agent: Claude, four tools, and the loop ellmer runs for you.
# Source it from the root of your workshop repository, then talk to `chat`.
library(ellmer)

# the agent's own deny rule: stay inside the project, out of data/raw/,
# and away from credentials files
inside_project <- function(path) {
  root <- fs::path_abs(getwd())
  full <- fs::path_norm(fs::path_abs(path, start = root))
  inside <- full == root || fs::path_has_parent(full, root)
  if (!inside || fs::path_has_parent(full, fs::path(root, "data", "raw")) ||
      fs::path_file(full) %in% c(".Renviron", ".env")) {
    stop("Refused: ", path, " is outside the project, under data/raw/, ",
         "or a credentials file")
  }
  full
}

# read tools: they observe the project and change nothing
list_files <- tool(
  function(path = ".") list.files(inside_project(path), recursive = TRUE),
  name = "list_files",
  description = "List the files in a folder of the project.",
  arguments = list(path = type_string("A folder, relative to the project.")),
  annotations = tool_annotations(read_only_hint = TRUE)
)
read_file <- tool(
  function(path) {
    paste(readLines(inside_project(path), warn = FALSE), collapse = "\n")
  },
  name = "read_file",
  description = "Read a text file in the project.",
  arguments = list(path = type_string("A file, relative to the project root.")),
  annotations = tool_annotations(read_only_hint = TRUE)
)

# write tools: they change the project, so they need your approval
write_file <- tool(
  function(path, content) {
    writeLines(content, inside_project(path))
    paste("Wrote", path)
  },
  name = "write_file",
  description = "Replace the whole contents of a text file in the project.",
  arguments = list(
    path = type_string("A file, relative to the project root."),
    content = type_string("The complete new contents of the file.")
  )
)
run_r <- tool(
  function(code) {
    out <- callr::r(function(code) utils::capture.output(
      tryCatch(source(exprs = parse(text = code), print.eval = TRUE),
               error = function(e) cat("Error:", conditionMessage(e), "\n"))
    ), list(code = code))
    paste(utils::head(out, 60), collapse = "\n") # keep long output short
  },
  name = "run_r",
  description = "Run R code in a fresh R session; return its printed output.",
  arguments = list(code = type_string("The R code to run."))
)

# Manual mode: show every write or run request, and ask before it happens
ask_first <- function(request) {
  if (request@name %in% c("write_file", "run_r")) {
    cat("\nThe agent wants to call", request@name, "with:\n")
    for (arg in names(request@arguments)) {
      cat("--", arg, "--\n", request@arguments[[arg]], "\n")
    }
    # outside an interactive session there is no one to ask, so refuse
    if (!interactive() || utils::menu(c("Yes", "No"), title = "Allow it?") != 1) {
      tool_reject()
    }
  }
}

chat <- chat_anthropic(
  model = "claude-opus-5-5",
  system_prompt = paste(
    "You are a careful R assistant working in this project.",
    "Read files before you change them, and check your work by running it.",
    "Never touch data/raw/. Say what you changed,",
    "and stop when the task is done."
  )
)
chat$register_tools(list(list_files, read_file, write_file, run_r))
chat$on_tool_request(ask_first)
