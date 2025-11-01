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
  let letter = URegex::choice(lower_letter, upper_letter)
  let identifier = URegex::concat(
    letter,
    URegex::repeat(URegex::choice(letter, digit)),
  )
  let dfad = identifier.to_dfad()
  inspect(dfad.full_match("a"), content="true")
  inspect(dfad.full_match("Z"), content="true")
  inspect(dfad.full_match("a1b2C3"), content="true")
  inspect(dfad.full_match("1abc"), content="false")
  inspect(dfad.full_match("_abc"), content="false")
}
