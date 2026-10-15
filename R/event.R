#' @include pairing.R

event <- S7::new_class(
  name = "event",
  properties = list(
    home = S7::new_property(
      S7::class_list
    ),
    guest = S7::new_property(
      S7::class_list
    ),
    pairings = S7::new_property(
      getter = function(self) {
        mapply(pairing, home = self@home, guest = self@guest)
      },
      setter = function(self, value) {
        self@home <- lapply(value, S7::prop, name = "home")
        self@guest <- lapply(value, S7::prop, name = "guest")
        self
      },
      default = quote(replicate(4, pairing()))
    ),
    score = S7::new_property(
      getter = function(self) {
        self@pairings |> lapply(\(x) x@score) |> Reduce(f = `+`)
      }
    )
  )
)
