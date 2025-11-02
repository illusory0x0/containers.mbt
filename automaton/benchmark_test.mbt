///|
test (b : @bench.T) {
  let digit = URegex::range('0', '9')
  let lower_letter = URegex::range('a', 'z')
  let upper_letter = URegex::range('A', 'Z')
  let underscore = URegex::single('_')
  let letter : URegex = Choice(lower_letter, upper_letter)
  let letter_underscore : URegex = Choice(letter, underscore)
  let identifier : URegex = Concat(
    letter_underscore,
    Repeat(Choice(letter_underscore, digit)),
  )
  let dfad = identifier.to_dfad()
  fn dfad_match(s : String) -> Bool {
    return dfad.full_match(s)
  }

  fn lex_match(s : String) -> Bool {
    lexmatch s with longest {
      "[a-zA-Z_][a-zA-Z0-9_]*" => true
      _ => false
    }
  }

  inspect(dfad_match("1"), content="false")
  inspect(lex_match("1"), content="false")
  inspect(dfad_match("a1b2C3"), content="true")
  inspect(lex_match("a1b2C3"), content="true")
  let input = "guest0x0232389".repeat(1000)
  inspect(dfad_match(input), content="true")
  inspect(lex_match(input), content="true")
  b.bench(name="dfad_match", () => b.keep(dfad_match(input)))
  b.bench(name="lex_match", () => b.keep(lex_match(input)))
}
