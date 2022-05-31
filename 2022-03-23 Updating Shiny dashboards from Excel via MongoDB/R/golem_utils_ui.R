#' Turn an R list into an HTML list
#'
#' @param list An R list
#' @param class A class for the list
#'
#' @return An HTML list
#'
#' @noRd
#'
#' @examples
#' list_to_li(c("a", "b"))
list_to_li <- function(list, class = NULL) {
  if (is.null(class)) {
    tagList(
      lapply(
        list,
        tags$li
      )
    )
  } else {
    res <- lapply(
      list,
      tags$li
    )
    res <- lapply(
      res,
      function(x) {
        tagAppendAttributes(
          x,
          class = class
        )
      }
    )
    tagList(res)
  }
}


#' Turn an R list into corresponding HTML paragraph tags
#'
#' @param list An R list
#' @param class A class for the paragraph tags
#'
#' @return An HTML tag
#'
#' @noRd
#'
#' @examples
#' list_to_p(c("This is the first paragraph", "this is the second paragraph"))
list_to_p <- function(list, class = NULL) {
  if (is.null(class)) {
    tagList(
      lapply(
        list,
        tags$p
      )
    )
  } else {
    res <- lapply(
      list,
      tags$p
    )
    res <- lapply(
      res,
      function(x) {
        tagAppendAttributes(
          x,
          class = class
        )
      }
    )
    tagList(res)
  }
}


#' Turn a named list into an HTML list
#'
#' @param list A named list
#' @param class A class for the list
#'
#' @return An HTML list
#'
#' @noRd
#'
#' @examples
#' list_to_li(c("a", "b"))
named_to_li <- function(list, class = NULL) {
  if (is.null(class)) {
    res <- mapply(
      function(x, y) {
        tags$li(
          HTML(
            sprintf("<b>%s:</b> %s", y, x)
          )
        )
      },
      list,
      names(list),
      SIMPLIFY = FALSE
    )
    tagList(res)
  } else {
    res <- mapply(
      function(x, y) {
        tags$li(
          HTML(
            sprintf("<b>%s:</b> %s", y, x)
          )
        )
      },
      list,
      names(list),
      SIMPLIFY = FALSE
    )
    res <- lapply(
      res,
      function(x) {
        tagAppendAttributes(
          x,
          class = class
        )
      }
    )
    tagList(res)
  }
}


#' Remove a tag attribute
#'
#' @param tag The tag
#' @param ... The attributes to remove
#'
#' @return A new tag
#'
#' @noRd
#'
#' @examples
#' a <- shiny::tags$p(src = "plop", "pouet")
#' tag_remove_attributes(a, "src")
tag_remove_attributes <- function(tag, ...) {
  attrs <- as.character(list(...))
  for (i in seq_along(attrs)) {
    tag$attribs[[attrs[i]]] <- NULL
  }
  tag
}


#' Hide or display a tag
#'
#' @param tag The tag
#'
#' @return A tag
#'
#' @noRd
#'
#'
#' @examples
#' ## Hide
#' a <- shiny::tags$p(src = "plop", "pouet")
#' undisplay(a)
#' ## Display
#' display(a)
undisplay <- function(tag) {
  # if not already hidden
  if (
    !is.null(tag$attribs$style) &&
      !grepl("display:\\s+none", tag$attribs$style)
  ) {
    tag$attribs$style <- paste(
      "display: none;",
      tag$attribs$style
    )
  } else {
    tag$attribs$style <- "display: none;"
  }
  tag
}

#' @noRd
#'
display <- function(tag) {
  if (
    !is.null(tag$attribs$style) &&
      grepl("display:\\s+none", tag$attribs$style)
  ) {
    tag$attribs$style <- gsub(
      "(\\s)*display:(\\s)*none(\\s)*(;)*(\\s)*",
      "",
      tag$attribs$style
    )
  }
  tag
}


#' Hide an elements by calling jquery hide on it
#'
#' @param id The id of the element to hide
#'
#' @noRd
#'
jq_hide <- function(id) {
  tags$script(sprintf("$('#%s').hide()", id))
}


#' Add a red star at the end of the text
#'
#' @description Adds a red star at the end of the text
#' (for example for indicating mandatory fields).
#'
#' @param text The HTML text to put before the red star
#'
#' @return An html element
#'
#' @noRd
#'
#' @examples
#' with_red_star("Enter your name here")
with_red_star <- function(text) {
  shiny::tags$span(
    HTML(
      paste0(
        text,
        shiny::tags$span(
          style = "color:red", "*"
        )
      )
    )
  )
}


#' Repeat tags$br
#'
#' @param times The number of br to return
#'
#' @return The number of br specified in times
#'
#' @noRd
#'
#' @examples
#' rep_br(5)
rep_br <- function(times = 1) {
  HTML(rep("<br/>", times = times))
}


#' Create an url
#'
#' @param url The URL
#' @param text The text to display
#'
#' @return An a tag
#' @noRd
#'
#' @examples
#' enurl("https://www.thinkr.fr", "ThinkR")
enurl <- function(url, text) {
  tags$a(href = url, text)
}


#' Columns wrappers
#'
#' These are convenient wrappers around
#' `column(12, ...)`, `column(6, ...)`, `column(4, ...)`...
#'
#' @noRd
#'
col_12 <- function(...) {
  column(12, ...)
}

#' @noRd
#'
col_10 <- function(...) {
  column(10, ...)
}

#' @noRd
#'
col_9 <- function(...) {
  column(9, ...)
}

#' @noRd
#'
col_8 <- function(...) {
  column(8, ...)
}

#' @noRd
#'
col_6 <- function(...) {
  column(6, ...)
}

#' @noRd
#'
col_4 <- function(...) {
  column(4, ...)
}

#' @noRd
#'
col_3 <- function(...) {
  column(3, ...)
}

#' @noRd
#'
col_2 <- function(...) {
  column(2, ...)
}

#' @noRd
#'
col_1 <- function(...) {
  column(1, ...)
}


#' Make the current tag behave like an action button
#'
#' @description Only works with compatible tags like button or links.
#'
#' @param tag Any compatible tag.
#' @param inputId Unique id. This will host the input value to be used
#' on the server side.
#'
#' @return The modified tag with an extra id and the action button class.
#'
#' @noRd
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   link <- a(href = "#", "My super link", style = "color: lightblue;")
#'
#'   ui <- fluidPage(
#'     make_action_button(link, inputId = "mylink")
#'   )
#'
#'   server <- function(input, output, session) {
#'     observeEvent(input$mylink, {
#'       showNotification("Pouic!")
#'     })
#'   }
#'
#'   shinyApp(ui, server)
#' }
#' # Begin Exclude Linting
make_action_button <- function(tag, inputId = NULL) {
  # End Exclude Linting
  # some obvious checks
  if (!inherits(tag, "shiny.tag")) stop("Must provide a shiny tag.")
  if (!is.null(tag$attribs$class)) {
    if (grep("action-button", tag$attribs$class)) {
      stop("tag is already an action button")
    }
  }
  if (is.null(inputId) && is.null(tag$attribs$id)) {
    stop("tag does not have any id. Please use inputId to be able to
           access it on the server side.")
  }

  # handle id
  if (!is.null(inputId)) {
    if (!is.null(tag$attribs$id)) {
      warning(
        paste(
          "tag already has an id. Please use input$",
          tag$attribs$id,
          "to access it from the server side. inputId will be ignored."
        )
      )
    } else {
      tag$attribs$id <- inputId
    }
  }

  # handle class
  if (is.null(tag$attribs$class)) {
    tag$attribs$class <- "action-button"
  } else {
    tag$attribs$class <- paste(tag$attribs$class, "action-button")
  }
  # return tag
  tag
}


#' usethis::use_package("markdown")
#' usethis::use_package("rmarkdown")
#'
#' To use this part of the UI
#'
#' #' Include Content From a File
#' #'
#' #' Load rendered RMarkdown from a file and turn into HTML.
#' #'
#' #' @rdname includeRMarkdown
#' #'
#' #' @noRd
#' #'
#' #' @importFrom rmarkdown render
#' #' @importFrom markdown markdownToHTML
#' #' @importFrom shiny HTML
#' includeRMarkdown <- function(path) {
#'
#'   md <- tempfile(fileext = '.md')
#'
#'   on.exit(unlink(md),add = TRUE)
#'
#'   rmarkdown::render(
#'     path,
#'     output_format = 'md_document',
#'     output_dir = tempdir(),
#'     output_file = md,quiet = TRUE
#'     )
#'
#'   html <- markdown::markdownToHTML(md, fragment.only = TRUE)
#'
#'   Encoding(html) <- "UTF-8"
#'
#'   return(HTML(html))
#' }
