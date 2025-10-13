///|
pub(all) enum List[A] {
  Nil
  Cons(A, List[A])
}

///|
pub fn[A, B] List::fold_left(self : List[A], acc : B, f : (B, A) -> B) -> B {
  loop (acc, self) {
    (acc, Nil) => acc
    (acc, Cons(head, tail)) => continue (f(acc, head), tail)
  }
}

///|
pub fn[A, B] List::fold_right(self : List[A], acc : B, f : (B, A) -> B) -> B {
  match self {
    Nil => acc
    Cons(head, tail) => f(List::fold_right(tail, acc, f), head)
  }
}

///|
pub fn[A : Show] List::to_sequence(self : List[A]) -> @graphviz.Sequence {
  let contents = []
  loop self {
    Nil => break
    Cons(head, tail) => {
      contents.push(head.to_string())
      continue tail
    }
  }
  @graphviz.Sequence::{ contents, rankdir: @graphviz.LeftToRight }
  // ...
}
