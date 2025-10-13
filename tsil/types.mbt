///|
pub(all) enum Tsil[A] {
  Lin
  Snoc(Tsil[A], A)
}

///|
pub fn[A, B] Tsil::fold_left(self : Tsil[A], acc : B, f : (B, A) -> B) -> B {
  match self {
    Lin => acc
    Snoc(init, last) => f(Tsil::fold_left(init, acc, f), last)
  }
}

///|
pub fn[A, B] Tsil::fold_right(self : Tsil[A], acc : B, f : (B, A) -> B) -> B {
  loop (acc, self) {
    (acc, Lin) => acc
    (acc, Snoc(init, last)) => continue (f(acc, last), init)
  }
}

///|
pub fn[A : Show] Tsil::to_sequence(self : Tsil[A]) -> @graphviz.Sequence {
  let contents = []
  loop self {
    Lin => break
    Snoc(init, last) => {
      contents.push(last.to_string())
      continue init
    }
  }
  @graphviz.Sequence::{ contents, rankdir: @graphviz.RightToLeft }
}
