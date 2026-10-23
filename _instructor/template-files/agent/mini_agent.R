# agent/mini_agent.R ----
# A small coding agent: Claude, four tools, and the loop ellmer runs for you.
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

# the agent's own permission rules: it may read inside the project, except raw
# data and credentials files, and it may write only under scripts/ ----
root <- here::here()
inside_project <- function(path, write = FALSE) {
  full <- fs::path_norm(fs::path_abs(path, start = root))
  allowed <- (full == root || fs::path_has_parent(full, root)) &&
    !fs::path_has_parent(full, fs::path(root, "data", "raw")) &&
    !fs::path_file(full) %in% c(".Renviron", ".env")
  if (write) {
    allowed <- allowed && fs::path_has_parent(full, fs::path(root, "scripts"))
  }
  if (!allowed) {
    stop("Refused: ", path, if (write) {
      " (the agent may write only under scripts/)"
    } else {
      " is outside the project, under data/raw/, or a credentials file"
    })
  }
  full
}

# read tools: they observe the project and change nothing ----
list_files <- tool(
  # one folder at a time, at most 100 names: a recursive listing would include
  # every package installed in renv/, and all of it would be sent to the model
  function(path = ".") utils::head(list.files(inside_project(path)), 100),
  name = "list_files",
  description = "List the files and folders in one folder of the project.",
  arguments = list(path = type_string("A folder, relative to the project root.")),
  annotations = tool_annotations(read_only_hint = TRUE)
)
read_file <- tool(
  function(path) {
    lines <- readLines(inside_project(path), warn = FALSE)
    paste(utils::head(lines, 300), collapse = "\n") # keep long files short
  },
  name = "read_file",
  description = "Read a text file in the project.",
  arguments = list(path = type_string("A file, relative to the project root.")),
  annotations = tool_annotations(read_only_hint = TRUE)
)

# write tools: they change the project, so they need your approval ----
write_file <- tool(
  function(path, content) {
    writeLines(content, inside_project(path, write = TRUE))
    paste("Wrote", path)
  },
  name = "write_file",
  description = "Replace the whole contents of a text file under scripts/.",
  arguments = list(
    path = type_string("A file under scripts/, relative to the project root."),
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

# Manual mode: show every write or run request, and ask before it happens ----
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
  model = model,
  credentials = agent_key,
  system_prompt = paste(
    "You are a careful R assistant working in this project.",
    "Read files before you change them, and check your work by running it.",
    "Write files only under scripts/; never edit tests/ or data/raw/.",
    "Code you write must work in a fresh R session, so load packages with",
    "library() or call them with pkg::. Say what you changed, and stop when",
    "the task is done."
  )
)
chat$register_tools(list(list_files, read_file, write_file, run_r))
chat$on_tool_request(ask_first)

# how many requests the agent has sent to the model: one per assistant turn ----
count_requests <- function() {
  sum(vapply(chat$get_turns(), function(turn) turn@role == "assistant", logical(1)))
}
