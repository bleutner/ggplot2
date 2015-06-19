Geom <- proto(TopLevel, expr={
  class <- function(.) "geom"

  parameters <- function(.) {
    params <- formals(get("draw", .))
    params <- params[setdiff(names(params), c(".","data","scales", "coordinates", "..."))]

    required <- rep(NA, length(.$required_aes))
    names(required) <- .$required_aes
    aesthetics <- c(.$default_aes(), required)

    c(params, aesthetics[setdiff(names(aesthetics), names(params))])
  }

  required_aes <- c()
  default_aes <- function(.) {}
  default_pos <- function(.) PositionIdentity

  guide_geom <- function(.) "point"

  draw <- function(...) {}
  draw_groups <- function(., data, scales, coordinates, ...) {
    if (empty(data)) return(zeroGrob())

    groups <- split(data, factor(data$group))
    grobs <- lapply(groups, function(group) .$draw(group, scales, coordinates, ...))

    ggname(paste(.$objname, "s", sep=""), gTree(
      children = do.call("gList", grobs)
    ))
  }

  new <- function(., mapping=NULL, data=NULL, stat=NULL, position=NULL, ...){
    do.call("layer", list(mapping=mapping, data=data, stat=stat, geom=., position=position, ...))
  }

  pprint <- function(., newline=TRUE) {
    cat("geom_", .$objname, ": ", sep="") #  , clist(.$parameters())
    if (newline) cat("\n")
  }

  reparameterise <- function(., data, params) data

  # Html documentation ----------------------------------



})


GeomR6 <- R6::R6Class("GeomR6", inherit = TopLevelR6,
  public = list(
    class = function() "geom",

    parameters = function() {
      params <- formals(self$draw)
      params <- params[setdiff(names(params), c("data","scales", "coordinates", "..."))]

      required <- rep(NA, length(self$required_aes))
      names(required) <- self$required_aes
      aesthetics <- c(self$default_aes(), required)

      c(params, aesthetics[setdiff(names(aesthetics), names(params))])
    },

    required_aes = c(),
    default_aes = function() {},
    default_pos = function() PositionIdentity,

    guide_geom = function() "point",

    draw = function(...) {},
    draw_groups = function(data, scales, coordinates, ...) {
      if (empty(data)) return(zeroGrob())

      groups <- split(data, factor(data$group))
      grobs <- lapply(groups, function(group) self$draw(group, scales, coordinates, ...))

      ggname(paste(self$objname, "s", sep=""), gTree(
        children = do.call("gList", grobs)
      ))
    },

    pprint = function(newline=TRUE) {
      cat("geom_", self$objname, ": ", sep="") #  , clist(self$parameters())
      if (newline) cat("\n")
    },

    reparameterise = function(data, params) data

    # Html documentation ----------------------------------
  )
)
