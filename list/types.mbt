///|
pub(all) enum List[A] {
  Nil
  Cons(A, List[A])
}

///|
pub fn[A, B] List::fold_left(self : List[A], acc : B, f : (B, A) -> B) -> B {
  loop (acc, self) {
    (acc, Nil) => acc
    (acc, Cons(hd, tl)) => continue (f(acc, hd), tl)
  }
}

///|
pub fn[A, B] List::fold_right(self : List[A], acc : B, f : (B, A) -> B) -> B {
  match self {
    Nil => acc
    Cons(h, t) => f(t.fold_right(acc, f), h)
  }
}

///|
pub fn[A : Show] List::to_sequence(self : List[A]) -> @graphviz.Sequence {
  let contents = []
  loop self {
    Nil => break
    Cons(hd, tl) => {
      contents.push(hd.to_string())
      continue tl
    }
  }
  @graphviz.Sequence::{ contents, rankdir: @graphviz.LeftToRight }
  // ...
}
