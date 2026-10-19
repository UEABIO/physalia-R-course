# ==============================================================================
# Project theme and palette construction for ggplot2.
#
# Colour policy (authoritative; see pub-figures SKILL.md):
#   * No brand set         -> use colorspace palettes directly.
#   * Brand set            -> set_brand("darkblue") sets the base colour (used by
#                             single-colour and highlight geoms) and reseeds the
#                             sequential ramp and the diverging HIGH arm. The
#                             low arm becomes the brand's complementary hue
#                             unless set_brand() is given div_low. Sequential
#                             and diverging are
#                             generated via colorspace HCL generators
#                             (CVD-robust, monotonic luminance).
#   * Categorical colour is NEVER brand-seeded: scale_*_brand_qual() delegate to
#                             colorspace "Dark 2", which sizes itself to the data.
#                             A single seed cannot make a coherent multi-hue set.
#   * Single-group / highlight geoms default to brand_base(), teal until reset.
#
# Manual hex palettes are NOT used as data scales. Only the base colour is used
# directly, and only for single-colour or highlight geoms.
#
# theme_project() here is the full version of the simple theme_project() taught
# in the ggplot chapter (Block 3: Themes and scales). It keeps the same name and
# base_size argument, and adds a font, furniture colours and axis_type.
#
# Dependencies: ggplot2 (>= 3.5), colorspace, scales; showtext + sysfonts for
#   fonts (optional: without them the device's default font is used);
#   colorBlindness for the accessibility check.
# ==============================================================================

library(ggplot2)
library(colorspace)

# ---- Brand state and setter --------------------------------------------------
# A single mutable brand state lets one call rebrand everything downstream.
# `set_brand("darkblue")` sets the base colour, which seeds the sequential ramp
# and the diverging high arm. Accepts any R colour name or hex string.

.brand_state <- new.env(parent = emptyenv())
.brand_state$base    <- "#09baba"  # teal default
.brand_state$div_low <- "#2c4977"  # navy default for the diverging low arm

#' Normalise a colour name or hex to a hex string
#' @keywords internal
.as_hex <- function(col) {
  rgb <- grDevices::col2rgb(col)  # accepts R colour names and hex
  grDevices::rgb(rgb[1], rgb[2], rgb[3], maxColorValue = 255)
}

#' Set the project brand colour
#'
#' Sets the base colour used by single-colour and highlight geoms, the
#' sequential ramp and the diverging high arm. Call once at the top of a
#' script: `set_brand("darkblue")`. Accepts any R colour name or hex string.
#'
#' @param base Brand colour (name or hex).
#' @param div_low Optional colour for the diverging low arm. If `NULL` (the
#'   default), the low arm uses the hue opposite the brand colour on the HCL
#'   colour wheel, so the two arms always contrast.
#' @return Invisibly, the resolved brand state as a list.
#' @export
set_brand <- function(base, div_low = NULL) {
  .brand_state$base <- .as_hex(base)
  .brand_state$div_low <- if (is.null(div_low)) {
    .complement_of(.brand_state$base)
  } else {
    .as_hex(div_low)
  }
  invisible(as.list(.brand_state))
}

#' Colour with the opposite HCL hue, for the diverging low arm
#' @keywords internal
.complement_of <- function(col) {
  hue <- (.hue_of(col) + 180) %% 360
  colorspace::hex(colorspace::polarLUV(L = 40, C = 60, H = hue), fixup = TRUE)
}

#' Reset the brand to the teal/navy default
#' @return Invisibly, the resolved brand state as a list.
#' @export
reset_brand <- function() {
  .brand_state$base    <- "#09baba"
  .brand_state$div_low <- "#2c4977"
  invisible(as.list(.brand_state))
}

#' Current brand base colour
#'
#' Returns the current brand base as a hex string. It is a function, not a value,
#' so it reflects the most recent `set_brand()` call. Use as `brand_base()`.
#' @return A hex colour string.
#' @export
brand_base <- function() .brand_state$base

# ---- Internal: font registration ---------------------------------------------

# Returns TRUE if `family` is available to showtext, FALSE otherwise, so the
# theme can fall back to the device's default font rather than warn on every
# text element.
.register_project_font <- function(family = "Open Sans") {
  if (!requireNamespace("showtext", quietly = TRUE)) {
    return(FALSE)
  }
  showtext::showtext_auto(enable = TRUE)
  if (!(family %in% sysfonts::font_families())) {
    try(sysfonts::font_add_google(family, family), silent = TRUE)
  }
  family %in% sysfonts::font_families()
}

# ---- theme_project() ---------------------------------------------------------

#' Project theme
#'
#' A composable ggplot2 theme controlling non-data aesthetics only. It sets no
#' data-encoding colours; pair it with a scale constructor (see below). Furniture
#' colours (title, axis labels, gridlines) are decorative and need not be
#' CVD-safe; the strip background is deliberately neutral grey so it is not
#' mistaken for a data signal when a fill palette is present. Furniture colours do
#' not track the brand by design; rebrand them by editing the literals below.
#'
#' @param base_size Base font size in points. Default 12 (journal/lab-report
#'   floor; raise to 14-20 for poster, talk, or public-engagement).
#' @param base_family Base font family. Default "Open Sans".
#' @param base_line_size Base line size. Default 0.5.
#' @param base_rect_size Base rectangle size. Default 0.5.
#' @param axis_type "categorical" or "continuous"; controls gridlines.
#' @return A ggplot2 theme object.
#' @export
theme_project <- function(base_size = 12,
                          base_family = "Open Sans",
                          base_line_size = 0.5,
                          base_rect_size = 0.5,
                          axis_type = c("categorical", "continuous")) {

  axis_type <- match.arg(axis_type)
  if (!.register_project_font(base_family)) {
    base_family <- ""  # device default font
  }

  title_col <- "#2c4977"  # decorative furniture only
  label_col <- "#41566f"
  muted_col <- "#5d6b7d"

  base <- ggplot2::theme(
    line = ggplot2::element_line(colour = "#000000", linewidth = base_line_size),
    rect = ggplot2::element_rect(fill = "#FFFFFF", colour = "#000000",
                                 linewidth = base_rect_size),
    text = ggplot2::element_text(family = base_family, colour = "#000000",
                                 size = base_size),
    plot.title = ggplot2::element_text(face = "bold", hjust = 0,
                                       size = ggplot2::rel(1.4),
                                       margin = ggplot2::margin(8, 0, 6, 0),
                                       colour = title_col),
    plot.subtitle = ggplot2::element_text(hjust = 0, size = ggplot2::rel(1.1),
                                          margin = ggplot2::margin(2, 0, 0, 0),
                                          colour = label_col),
    plot.caption = ggplot2::element_text(hjust = 1, size = ggplot2::rel(0.8),
                                         margin = ggplot2::margin(6, 0, 0, 0),
                                         colour = muted_col),
    axis.text.y = ggplot2::element_text(colour = muted_col, size = ggplot2::rel(0.9)),
    axis.title.y = ggplot2::element_text(colour = label_col,
                                         margin = ggplot2::margin(0, 4, 0, 0)),
    axis.text.x = ggplot2::element_text(colour = muted_col, size = ggplot2::rel(0.9)),
    axis.title.x = ggplot2::element_text(colour = label_col,
                                         margin = ggplot2::margin(4, 0, 0, 0)),
    panel.background = ggplot2::element_rect(fill = "white", colour = NA),
    strip.background = ggplot2::element_rect(fill = "#e9e9e9", colour = NA),
    strip.text = ggplot2::element_text(face = "bold", colour = "#2c4977",
                                       size = ggplot2::rel(1.0)),
    panel.border = ggplot2::element_blank(),
    axis.line = ggplot2::element_line(linewidth = base_line_size, colour = "black"),
    legend.position = "right"
  )

  grid_col <- "#dedddd"
  if (axis_type == "continuous") {
    grid_theme <- ggplot2::theme(
      panel.grid.major.y = ggplot2::element_line(colour = grid_col),
      panel.grid.major.x = ggplot2::element_line(colour = grid_col)
    )
  } else {
    grid_theme <- ggplot2::theme(
      panel.grid.major.y = ggplot2::element_line(colour = grid_col),
      panel.grid.major.x = ggplot2::element_blank()
    )
  }

  base + grid_theme
}

# ---- Brand-seeded palette constructors ---------------------------------------
# These wrap colorspace HCL generators, seeded on the current brand colour, so
# the ramp is perceptually based with monotonic luminance. With no set_brand()
# call the seed is teal; callers may also pass `base`/`low`/`high` explicitly,
# which always overrides the brand state. If no brand is intended at all, use
# colorspace::scale_*_{qualitative,sequential,diverging} directly.

#' Hue (HCL) of a colour, for seeding colorspace generators
#' @keywords internal
.hue_of <- function(col) {
  hcl <- colorspace::coords(as(colorspace::hex2RGB(.as_hex(col)), "polarLUV"))
  unname(hcl[, "H"])
}

#' Brand-seeded sequential scale (colour)
#'
#' Single-hue sequential ramp seeded on `base`, generated in HCL so luminance is
#' monotonic. Light-to-dark by default.
#'
#' @param base Seed colour. Defaults to the current `brand_base()`.
#' @param n Number of interpolation stops. Default 7.
#' @param ... Passed to `ggplot2::scale_colour_gradientn()`.
#' @return A ggplot2 scale.
#' @export
scale_colour_brand_seq <- function(base = brand_base(), n = 7, ...) {
  cols <- colorspace::sequential_hcl(
    n = n, h = .hue_of(base), c = c(70, 10), l = c(25, 95), power = 1.2,
    rev = TRUE
  )
  ggplot2::scale_colour_gradientn(colours = cols, ...)
}

#' @rdname scale_colour_brand_seq
#' @export
scale_fill_brand_seq <- function(base = brand_base(), n = 7, ...) {
  cols <- colorspace::sequential_hcl(
    n = n, h = .hue_of(base), c = c(70, 10), l = c(25, 95), power = 1.2,
    rev = TRUE
  )
  ggplot2::scale_fill_gradientn(colours = cols, ...)
}

#' Brand-seeded diverging scale (colour)
#'
#' Two-hue diverging ramp seeded on `low` and `high`, generated in HCL with a
#' balanced neutral midpoint. Supply `midpoint` to centre on a meaningful value.
#'
#' @param low Seed colour for the low arm. Defaults to navy or, after
#'   `set_brand()`, to the brand's complementary hue (or its `div_low`).
#' @param high Seed colour for the high arm. Defaults to the current `brand_base()`.
#' @param midpoint Data value mapped to the neutral midpoint. Default 0.
#' @param n Number of interpolation stops (odd recommended). Default 11.
#' @param ... Passed to `ggplot2::scale_colour_gradientn()`.
#' @return A ggplot2 scale.
#' @export
scale_colour_brand_div <- function(low = .brand_state$div_low,
                                    high = brand_base(),
                                    midpoint = 0, n = 11, ...) {
  cols <- colorspace::diverging_hcl(
    n = n, h = c(.hue_of(low), .hue_of(high)),
    c = 80, l = c(35, 95), power = 1.0
  )
  ggplot2::scale_colour_gradientn(
    colours = cols, rescaler = ~ scales::rescale_mid(.x, mid = midpoint), ...
  )
}

#' @rdname scale_colour_brand_div
#' @export
scale_fill_brand_div <- function(low = .brand_state$div_low,
                                  high = brand_base(),
                                  midpoint = 0, n = 11, ...) {
  cols <- colorspace::diverging_hcl(
    n = n, h = c(.hue_of(low), .hue_of(high)),
    c = 80, l = c(35, 95), power = 1.0
  )
  ggplot2::scale_fill_gradientn(
    colours = cols, rescaler = ~ scales::rescale_mid(.x, mid = midpoint), ...
  )
}

#' Qualitative scale (colour) for categorical groups
#'
#' Categorical palettes are NOT brand-seeded. A single brand colour cannot
#' generate a coherent, CVD-safe multi-hue set: spreading hues from one anchor
#' discards the seed's own chroma and luminance and walks through arbitrary
#' intermediate hues. This constructor therefore delegates to `colorspace`'s
#' `Dark 2` qualitative palette, which is built for mutual distinctness and is
#' CVD-tested, and which sizes itself to the number of groups (so it cannot raise
#' "Insufficient values in manual scale"). Reserve the brand colour for the
#' sequential ramp, the diverging high arm, and single-colour or highlight geoms,
#' where one seed genuinely works. Always pair with a redundant aesthetic (shape
#' or linetype).
#'
#' @param ... Passed to `colorspace::scale_colour_discrete_qualitative()`.
#' @return A ggplot2 scale.
#' @export
scale_colour_brand_qual <- function(...) {
  colorspace::scale_colour_discrete_qualitative(palette = "Dark 2", ...)
}

#' @rdname scale_colour_brand_qual
#' @param ... Passed to `colorspace::scale_fill_discrete_qualitative()`.
#' @export
scale_fill_brand_qual <- function(...) {
  colorspace::scale_fill_discrete_qualitative(palette = "Dark 2", ...)
}

# ---- Example usage -----------------------------------------------------------
# Set a brand once, then everything downstream follows:
#   set_brand("darkblue")
#   ... + scale_fill_brand_seq()          # darkblue-seeded sequential
#   ... + geom_point(colour = brand_base())# darkblue single-colour geom
#   ... + scale_fill_brand_div(midpoint = 0) # complementary low arm, darkblue high
#
# No brand (default path): colorspace directly.
#   ggplot(d, aes(x, y, colour = g, shape = g)) + geom_point() +
#     colorspace::scale_colour_discrete_qualitative(palette = "Dark 2") +
#     theme_project(axis_type = "continuous")
#
# Per-call override (ignores brand state):
#   ... + scale_fill_brand_seq(base = "#2c4977")
#
# Accessibility check is mandatory; a brand-seeded palette that fails it falls
# back to its colorspace default (Viridis for sequential, Blue-Red for diverging):
#   colorBlindness::cvdPlot(fig1)