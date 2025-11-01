///|
fn[A : Eq + Hash] set_singleton(val : A) -> Set[A] {
  let s = Set::new()
  s.add(val)
  s
}
