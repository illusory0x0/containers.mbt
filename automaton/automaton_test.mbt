///|
test {
  let digit = URegex::range('0', '9')
  let regex = URegex::repeat(digit)
  let dfad = regex.to_dfad()
  inspect(dfad.full_match("1"), content="true")
  inspect(dfad.full_match("1234"), content="true")
  inspect(dfad.full_match("923"), content="true")
  inspect(dfad.full_match("923"), content="true")
  inspect(dfad.full_match("&"), content="false")
  inspect(dfad.full_match("*"), content="false")
  inspect(dfad.full_match("a"), content="false")
}

///|
test {
  let digit = URegex::range('0', '9')
  let lower_letter = URegex::range('a', 'z')
  let upper_letter = URegex::range('A', 'Z')
  let underscore = URegex::single('_')
  let letter = URegex::choice(lower_letter, upper_letter)
  let letter_underscore = URegex::choice(letter, underscore)
  let identifier = URegex::concat(
    letter_underscore,
    URegex::repeat(URegex::choice(letter_underscore, digit)),
  )
  let dfad = identifier.to_dfad()
  // identifier
  inspect(dfad.full_match("a"), content="true")
  inspect(dfad.full_match("Z"), content="true")
  inspect(dfad.full_match("a1b2C3"), content="true")
  inspect(dfad.full_match("_abc"), content="true")
  inspect(dfad.full_match("guest0x0"), content="true")
  inspect(dfad.full_match("Laurus"), content="true")
  inspect(dfad.full_match("Logos"), content="true")
  inspect(dfad.full_match("Ocaml"), content="true")
  inspect(dfad.full_match("Haskell"), content="true")
  inspect(dfad.full_match("finger_tree"), content="true")
  inspect(dfad.full_match("NTR"), content="true")
  inspect(dfad.full_match("ntr"), content="true")
  inspect(dfad.full_match("ntrlang"), content="true")
  // not identifier

  inspect(dfad.full_match("hello world"), content="false")
  inspect(dfad.full_match("_abc🐬"), content="false")
  inspect(dfad.full_match("_abc🐫"), content="false")
  inspect(dfad.full_match("1abc"), content="false")
  inspect(dfad.full_match("0721"), content="false")
}
