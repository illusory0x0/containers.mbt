///|
pub impl Hash for NFAS with hash_combine(self, hasher) {
  for state in self.0 {
    hasher.combine(state)
  }
}

///|
pub fn NFAS::is_empty(set : NFAS) -> Bool {
  set.0.is_empty()
}

///|
pub fn NFAS::iter(set : NFAS) -> Iter[Int] {
  set.0.iter()
}

///|
pub fn NFAS::copy(set : NFAS) -> NFAS {
  NFAS(set.0.copy())
}

///|
pub fn NFAS::add(set : NFAS, val : Int) -> Unit {
  set.0.add(val)
}

///|
pub fn NFAS::contains(set : NFAS, val : Int) -> Bool {
  set.0.contains(val)
}

///|
pub fn NFAS::empty() -> NFAS {
  NFAS(Set::new())
}

///|
pub impl Sub for DFAS with sub(x, y) {
  x.0 - y.0
}

///|
pub impl BitAnd for DFAS with land(x, y) {
  x.0 & y.0
}

///|
pub impl Hash for DFAS with hash_combine(self, hasher) {
  for state in self.0 {
    hasher.combine(state)
  }
}

///|
pub fn DFAS::is_empty(set : DFAS) -> Bool {
  set.0.is_empty()
}

///|
pub fn DFAS::length(set : DFAS) -> Int {
  set.0.length()
}

///|
pub fn DFAS::iter(set : DFAS) -> Iter[Int] {
  set.0.iter()
}

///|
pub fn DFAS::contains(set : DFAS, val : Int) -> Bool {
  set.0.contains(val)
}

///|
pub fn RDFAT::iter2(self : RDFAT) -> Iter2[NFAS, Map[Int, NFAS]] {
  self.0.iter2()
}

///|
pub fn RDFAT::keys(self : RDFAT) -> Iter[NFAS] {
  self.0.keys()
}

///|
pub fn RDFAT::length(self : RDFAT) -> Int {
  self.0.length()
}

///|
pub fn RDFAT::contains(self : RDFAT, val : NFAS) -> Bool {
  self.0.contains(val)
}

///|
pub fn RDFAT::update(
  self : RDFAT,
  key : NFAS,
  f : (Map[Int, NFAS]?) -> Map[Int, NFAS]?,
) -> Unit {
  self.0.update(key, f)
}

///|
pub fn RDFAT::op_set(self : RDFAT, key : NFAS, val : Map[Int, NFAS]) -> Unit {
  self.0[key] = val
}

///|
pub fn RDFAT::op_get(self : RDFAT, key : NFAS) -> Map[Int, NFAS] {
  self.0[key]
}

///|
pub fn NFAT::length(self : NFAT) -> Int {
  self.0.length()
}

///|
pub fn NFAT::op_get(self : NFAT, index : Int) -> Map[Int, Set[Int]] {
  self.0[index]
}

///|
pub fn NFAT::op_set(self : NFAT, index : Int, val : Map[Int, Set[Int]]) -> Unit {
  self.0[index] = val
}

///|
pub fn NFAT::iter(self : NFAT) -> Iter[Map[Int, Set[Int]]] {
  self.0.iter()
}

///|
pub fn NFAT::iter2(self : NFAT) -> Iter2[Int, Map[Int, Set[Int]]] {
  self.0.iter2()
}

///|
pub fn NFAT::get(self : NFAT, from : Int) -> Map[Int, Set[Int]]? {
  self.0.get(from)
}
