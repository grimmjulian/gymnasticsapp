#' @include routine.R
#' @include score.R

pairing <- S7::new_class(
  name = "pairing",
  properties = list(
    home = routine,
    guest = routine,
    score = S7::new_property(
      getter = function(self) {
        x <- self@home@end_value - self@guest@end_value
        calculate_score(x)
      }
    )
  )
)
