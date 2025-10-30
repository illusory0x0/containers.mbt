///|
pub impl Hash for NFASS with hash_combine(self, hasher) {
  for state in self.0 {
    hasher.combine(state)
  }
}

///|
pub fn NFASS::singleton(val : NFAS) -> NFASS {
  let set = NFASS::empty()
  set.update_with_add(val)
}

///|
pub fn NFASS::is_empty(set : NFASS) -> Bool {
  set.0.is_empty()
}

///|
pub fn NFASS::to_array(set : NFASS) -> Array[NFAS] {
  set.0.to_array()
}

///|
pub fn NFASS::iter(set : NFASS) -> Iter[NFAS] {
  set.0.iter()
}

///|
pub fn NFASS::copy(set : NFASS) -> NFASS {
  NFASS(set.0.copy())
}

///|
pub fn NFASS::add(set : NFASS, val : NFAS) -> Unit {
  set.0.add(val.0)
}

///|
pub fn NFASS::update_with_add(set : NFASS, val : NFAS) -> NFASS {
  set.0.add(val.0)
  set
}

///|
pub fn NFASS::contains(set : NFASS, val : NFAS) -> Bool {
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
pub fn DFASS::singleton(val : DFAS) -> DFASS {
  let set = Set::new()
  set.add(val)
  set
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
pub fn DFASS::iter(set : DFASS) -> Iter[DFAS] {
  set.0.iter()
}

///|
pub fn DFASS::contains(set : DFASS, val : DFAS) -> Bool {
  set.0.contains(val.0)
}

///|
pub fn RDFAT::iter2(self : RDFAT) -> Iter2[NFASS, Map[Symbol, NFASS]] {
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
  f : (Map[Symbol, NFASS]?) -> Map[Symbol, NFASS]?,
) -> Unit {
  self.0.update(key, f)
}

///|
pub fn RDFAT::op_set(
  self : RDFAT,
  key : NFASS,
  val : Map[Symbol, NFASS],
) -> Unit {
  self.0[key] = val
}

///|
pub fn RDFAT::op_get(self : RDFAT, key : NFASS) -> Map[Symbol, NFASS] {
  self.0[key]
}

///|
pub fn NFAT::length(self : NFAT) -> Int {
  self.0.length()
}

///|
pub fn NFAT::op_get(self : NFAT, from : NFAS) -> Map[Symbol, NFASS] {
  self.0[from.to_int()]
}

///|
pub fn NFAT::op_set(
  self : NFAT,
  from : NFAS,
  trans : Map[Symbol, NFASS],
) -> Unit {
  self.0[from.to_int()] = trans
}

///|
pub fn NFAT::iter(self : NFAT) -> Iter[Map[Symbol, NFASS]] {
  self.0.iter()
}

///|
pub fn NFAT::iter2(self : NFAT) -> Iter2[NFAS, Map[Symbol, NFASS]] {
  Iter2::new(fn(k) {
    for i, v in self.0.iter2() {
      guard k(NFAS::from(i), v) is IterContinue else { break IterEnd }
    } else {
      IterContinue
    }
  })
}

///|
pub fn NFAT::get(self : NFAT, from : NFAS) -> Map[Symbol, NFASS]? {
  self.0.get(from.to_int())
}

///|
pub fn DFASS::empty() -> DFASS {
  DFASS(Set::new())
}

///|
pub fn DFASS::add(set : DFASS, val : DFAS) -> Unit {
  set.0.add(val)
}

///|
pub fn DFAT::iter2(self : DFAT) -> Iter2[DFAS, FixedArray[DFAS]] {
  Iter2::new(fn(k) {
    for i, v in self.0.iter2() {
      guard k(DFAS::from(i), v) is IterContinue else { break IterEnd }
    } else {
      IterContinue
    }
  })
}

///|
pub fn DFAT::trans(self : DFAT, from : DFAS, sym : Symbol) -> DFAS {
  self.0[from.to_int()][sym.to_int()]
}

///|
pub fn DFAT::set_trans(
  self : DFAT,
  from : DFAS,
  sym : Symbol,
  to : DFAS,
) -> Unit {
  self.0[from.to_int()][sym.to_int()] = to
}

///|
pub fn DFAT::length(self : DFAT) -> Int = "%fixedarray.length"

///|
pub fn NFAS::from(val : Int) -> NFAS = "%identity"

///|
pub fn DFAS::from(val : Int) -> DFAS = "%identity"

///|
pub fn NFAS::to_int(self : NFAS) -> Int = "%identity"

///|
pub fn DFAS::to_int(self : DFAS) -> Int = "%identity"
