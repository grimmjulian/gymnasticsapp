routine <- S7::new_class(
  name = "routine",
  properties = list(
    gymnast = S7::class_character,
    d_value = S7::new_property(S7::class_numeric, default = 0),
    end_value = S7::new_property(S7::class_numeric, default = 0)
  )
)
