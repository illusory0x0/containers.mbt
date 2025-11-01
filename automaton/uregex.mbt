///|
pub fn URegex::concat(lhs : URegex, rhs : URegex) -> URegex {
  URegex::Concat(lhs, rhs)
}

///|
pub fn URegex::choice(lhs : URegex, rhs : URegex) -> URegex {
  URegex::Choice(lhs, rhs)
}

///|
pub fn URegex::repeat(expr : URegex) -> URegex {
  URegex::Repeat(expr)
}

///|
pub fn URegex::range(min : Char, max : Char) -> URegex {
  let start = min.to_int()
  let end = max.to_int() + 1
  guard start < end && start > 0 else {
    abort("Invalid range: start must be less than end")
  }
  URegex::Range(start~, end~)
}

///|
pub fn URegex::epsilon() -> URegex {
  URegex::Range(start=0x10FFFF, end=0x110000)
}

///|
pub fn URegex::single(ch : Char) -> URegex {
  URegex::range(ch, ch)
}

///|
pub fn URegex::interval_table(ur : URegex) -> FixedArray[Int] {
  let table = []
  fn dfs(ur : URegex) {
    match ur {
      Concat(left, right) => {
        dfs(left)
        dfs(right)
      }
      Choice(top, bot) => {
        dfs(top)
        dfs(bot)
      }
      Repeat(regex) => dfs(regex)
      Range(start=0x10ffff, end=0x110000) => ()
      Range(start~, end~) => {
        table.push(start)
        table.push(end)
      }
    }
  }

  dfs(ur)
  table.sort()
  table.dedup()
  FixedArray::makei(table.length(), idx => table[idx])
}

///|
fn URegex::split(start : Int, end : Int) -> Regex {
  let len = end - start
  if len == 1 {
    Symbol(Symbol(start))
  } else {
    let middle = len >> 1
    Choice(URegex::split(start, middle), URegex::split(middle, end))
  }
}

///|
pub fn URegex::to_regex(ur : URegex) -> (Regex, SymbolMap) {
  let table = ur.interval_table()
  fn dfa(ur : URegex) -> Regex {
    match ur {
      Concat(left, right) => Concat(dfa(left), dfa(right))
      Choice(top, bot) => Choice(dfa(top), dfa(bot))
      Repeat(regex) => Repeat(dfa(regex))
      Range(start=0x10FFFF, end=0x110000) => Symbol(Epsilon)
      Range(start~, end~) => {
        let start = table.binary_search(start).unwrap()
        let end = table.binary_search(end).unwrap()
        URegex::split(start, end)
      }
    }
  }

  (dfa(ur), table)
}

///|
pub fn URegex::to_dfad(ur : URegex) -> DFAD {
  let (regex, symbol_map) = ur.to_regex()
  let nfa = regex.thompson_construction(
    initial=0,
    alphabet_count=symbol_map.length(),
  )
  let rdfa = nfa.powerset_construction()
  let dfa = rdfa.to_dfa()
  let dfa = dfa.minimize()
  DFAD::{ dfa, symbol_map }
}
