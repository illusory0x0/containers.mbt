///|
fn NFAT::new(count : Int) -> NFAT {
  NFAT(FixedArray::makei(count, _ => Map::new()))
}

///|
fn NFAT::add_transition(
  self : NFAT,
  from : NFAS,
  sym : Symbol,
  to : NFAS,
) -> Unit {
  let edge = self[from.to_int()]
  edge.update(sym.0, fn(set) {
    match set {
      None => Some(NFASS::singleton(to))
      Some(set) => Some(set.update_with_add(to))
    }
  })
}

///|
fn NFAT::trans(self : NFAT, from : NFAS, sym : Symbol) -> NFASS {
  let edges = self[from]
  match self.get(from) {
    Some(_) =>
      match edges.get(sym) {
        Some(to) => to
        None => NFASS::empty()
      }
    None => NFASS::empty()
  }
}

///|
fn NFAT::epsilon_closure(nfat : NFAT, initials : NFASS) -> NFASS {
  let result = initials.copy()
  let pending = initials.to_array()
  while pending.pop() is Some(initial) {
    for final_ in nfat.trans(initial, EpsilonSymbol) {
      if !result.contains(final_) {
        result.add(final_)
        pending.push(final_)
      }
    }
  }
  result
}

///|
fn NFAT::move_(nfat : NFAT, initials : NFASS, sym : Symbol) -> NFASS {
  let result = NFASS::empty()
  for initial in initials {
    for final_ in nfat.trans(initial, sym) {
      result.add(final_)
    }
  }
  result
}
