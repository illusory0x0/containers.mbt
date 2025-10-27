///|
pub impl Hash for NFASS with hash_combine(self, hasher) {
  for state in self.0 {
    hasher.combine(state)
  }
}

///|
pub fn NFASS::is_empty(set : NFASS) -> Bool {
  set.0.is_empty()
}

///|
pub fn NFASS::to_array(set : NFASS) -> Array[Int] {
  set.0.to_array()
}

///|
pub fn NFASS::iter(set : NFASS) -> Iter[Int] {
  set.0.iter()
}

///|
pub fn NFASS::copy(set : NFASS) -> NFASS {
  NFASS(set.0.copy())
}

///|
pub fn NFASS::add(set : NFASS, val : Int) -> Unit {
  set.0.add(val)
}

///|
pub fn NFASS::contains(set : NFASS, val : Int) -> Bool {
  set.0.contains(val)
}

///|
pub fn NFASS::empty() -> NFASS {
  NFASS(Set::new())
}

///|
pub impl Sub for DFASS with sub(x, y) {
  x.0 - y.0
}

///|
pub impl BitAnd for DFASS with land(x, y) {
  x.0 & y.0
}

///|
pub impl Hash for DFASS with hash_combine(self, hasher) {
  for state in self.0 {
    hasher.combine(state)
  }
}

///|
pub fn DFASS::is_empty(set : DFASS) -> Bool {
  set.0.is_empty()
}

///|
pub fn DFASS::length(set : DFASS) -> Int {
  set.0.length()
}

///|
pub fn DFASS::iter(set : DFASS) -> Iter[Int] {
  set.0.iter()
}

///|
pub fn DFASS::contains(set : DFASS, val : Int) -> Bool {
  set.0.contains(val)
}

///|
pub fn RDFAT::iter2(self : RDFAT) -> Iter2[NFASS, Map[Int, NFASS]] {
  self.0.iter2()
}

///|
pub fn RDFAT::keys(self : RDFAT) -> Iter[NFASS] {
  self.0.keys()
}

///|
pub fn RDFAT::length(self : RDFAT) -> Int {
  self.0.length()
}

///|
pub fn RDFAT::contains(self : RDFAT, val : NFASS) -> Bool {
  self.0.contains(val)
}

///|
pub fn RDFAT::update(
  self : RDFAT,
  key : NFASS,
  f : (Map[Int, NFASS]?) -> Map[Int, NFASS]?,
) -> Unit {
  self.0.update(key, f)
}

///|
pub fn RDFAT::op_set(self : RDFAT, key : NFASS, val : Map[Int, NFASS]) -> Unit {
  self.0[key] = val
}

///|
pub fn RDFAT::op_get(self : RDFAT, key : NFASS) -> Map[Int, NFASS] {
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
