#' @include pairing.R

event <- S7::new_class(
  name = "event",
  properties = list(
    home = S7::new_property(
      S7::class_list,
      default = replicate(4, routine())
    ),
    guest = S7::new_property(
      S7::class_list,
      default = replicate(4, routine())
    ),
    pairings = S7::new_property(
      getter = function(self) {
        mapply(pairing, home = self@home, guest = self@guest)
      }
    ),
    score = S7::new_property(
      getter = function(self) {
        self@pairings |> lapply(\(x) x@score) |> Reduce(f = `+`)
      }
    )
  )
)
