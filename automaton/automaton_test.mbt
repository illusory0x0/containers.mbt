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
