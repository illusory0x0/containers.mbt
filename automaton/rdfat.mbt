///|
fn RDFAT::add_transition(
  dfat : RDFAT,
  from : NFASS,
  sym : Symbol,
  to : NFASS,
) -> Unit {
  fn connect(edge : Map[Symbol, NFASS]) -> Map[Symbol, NFASS]? {
    edge.update(sym, fn(dfa_state) {
      match dfa_state {
        None => Some(to)
        Some(dead) if dead.is_empty() => Some(dead)
        Some(to_) if to_ == to => Some(to)
        Some(_) => abort("impossible")
      }
    })
    Some(edge)
  }

  dfat.update(from, fn(edge) {
    match edge {
      Some(edge) => connect(edge)
      None => connect({})
    }
  })
}

///|
fn RDFAT::new() -> RDFAT {
  Map::new()
}
