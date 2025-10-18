///|
priv enum UnsnocResult[A] {
  Keep(TwoThreeTree[A], A)
  Underflow(TwoThreeTree[A], A)
}

///|
fn[A] TwoThreeTree::unsnoc_aux(xs : TwoThreeTree[A]) -> UnsnocResult[A] {
  match xs {
    Two(Empty, a, Empty) => Underflow(Empty, a)
    Three(Empty, a, Empty, y, Empty) => Keep(Two(Empty, a, Empty), y)
    Two(left, x, right) =>
      match TwoThreeTree::unsnoc_aux(right) {
        Keep(right, a) => Keep(Two(left, x, right), a)
        Underflow(right, a) =>
          match left {
            Two(left, y, m1) => Underflow(Three(left, y, m1, x, right), a)
            Three(left, y, m1, z, m2) =>
              Keep(Two(Two(left, y, m1), z, Two(m2, x, right)), a)
            Empty => panic()
          }
      }
    Three(left, u, middle, x, right) =>
      match TwoThreeTree::unsnoc_aux(right) {
        Keep(right, a) => Keep(Three(left, u, middle, x, right), a)
        Underflow(right, a) =>
          match (left, middle) {
            (Two(_) as left, Two(m1, v, m2)) =>
              Keep(Two(left, u, Three(m1, v, m2, x, right)), a)
            (_ as left, Three(m1, v, m2, w, m3)) =>
              Keep(Three(left, u, Two(m1, v, m2), w, Two(m3, x, right)), a)
            (Three(left, y, m1, z, m2), _ as m3) =>
              Keep(Three(Two(left, y, m1), z, Two(m2, u, m3), x, right), a)
            (Empty, _) | (_, Empty) => panic()
          }
      }
    Empty => panic()
  }
}

///|
pub fn[A] TwoThreeTree::unsnoc(xs : TwoThreeTree[A]) -> ViewRight[A] {
  match xs {
    Empty => Lin
    _ as xs =>
      match TwoThreeTree::unsnoc_aux(xs) {
        Keep(xs, x) => Snoc(xs, x)
        Underflow(xs, x) => Snoc(xs, x)
      }
  }
}
