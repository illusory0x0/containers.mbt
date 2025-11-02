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
pub fn URegex::single(ch : Char) -> URegex {
  URegex::range(ch, ch)
}

///|
pub fn URegex::symbol_map(ur : URegex) -> SymbolMap {
  let char_to_idx = []
  // here we use `start` in to represent [start,end) code point range
  let start_table = []
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
      Epsilon => ()
      Range(start~, end~) => {
        char_to_idx.push(start)
        char_to_idx.push(end)
        // collect the actual in use code point range
        start_table.push(start)
      }
    }
  }

  dfs(ur)
  char_to_idx.sort()
  char_to_idx.dedup()
  start_table.sort()
  start_table.dedup()
  let char_to_idx = FixedArray::makei(char_to_idx.length(), idx => char_to_idx[idx])
  // shrink the symbol map exclude the unused code point ranges
  let idx_to_sym : FixedArray[_] = FixedArray::makei(start_table.length(), idx => char_to_idx
    .binary_search(start_table[idx])
    .unwrap())
  SymbolMap::{ char_to_idx, idx_to_sym }
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
  let symbol_map = ur.symbol_map()
  let { char_to_idx, idx_to_sym } = symbol_map
  fn dfa(ur : URegex) -> Regex {
    match ur {
      Concat(left, right) => Concat(dfa(left), dfa(right))
      Choice(top, bot) => Choice(dfa(top), dfa(bot))
      Repeat(regex) => Repeat(dfa(regex))
      Epsilon => Symbol(Epsilon)
      Range(start~, end~) => {
        let idx_start = char_to_idx.binary_search(start).unwrap()
        let idx_end = char_to_idx.binary_search(end).unwrap()
        let sym_start = idx_to_sym.binary_search(idx_start).unwrap()
        let sym_end = match idx_to_sym.binary_search(idx_end) {
          Ok(sym) => sym
          Err(sym) => sym
        }
        URegex::split(sym_start, sym_end)
      }
    }
  }

  (dfa(ur), symbol_map)
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
