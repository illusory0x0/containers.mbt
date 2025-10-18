///|
priv enum UnconsResult[A] {
  Keep(A, TwoThreeTree[A])
  Underflow(A, TwoThreeTree[A])
}

///|
fn[A] TwoThreeTree::uncons_aux(xs : TwoThreeTree[A]) -> UnconsResult[A] {
  match xs {
    Two(Empty, a, Empty) => Underflow(a, Empty)
    Three(Empty, a, Empty, y, Empty) => Keep(a, Two(Empty, y, Empty))
    Two(left, x, right) =>
      match TwoThreeTree::uncons_aux(left) {
        Keep(a, left) => Keep(a, Two(left, x, right))
        Underflow(a, left) =>
          match right {
            Two(m1, y, right) => Underflow(a, Three(left, x, m1, y, right))
            Three(m1, y, m2, z, right) =>
              Keep(a, Two(Two(left, x, m1), y, Two(m2, z, right)))
            Empty => panic()
          }
      }
    Three(left, u, middle, x, right) =>
      match TwoThreeTree::uncons_aux(left) {
        Keep(a, left) => Keep(a, Three(left, u, middle, x, right))
        Underflow(a, left) =>
          match (middle, right) {
            (Two(m1, v, m2), Two(_) as right) =>
              Keep(a, Two(Three(left, u, m1, v, m2), x, right))
            (Three(m1, v, m2, w, m3), _ as right) =>
              Keep(a, Three(Two(left, u, m1), v, Two(m2, w, m3), x, right))
            (_ as m1, Three(m2, y, m3, z, right)) =>
              Keep(a, Three(Two(left, u, m1), x, m2, y, Two(m3, z, right)))
            (Empty, _) | (_, Empty) => panic()
          }
      }
    Empty => panic()
  }
}

///|
pub fn[A] TwoThreeTree::uncons(xs : TwoThreeTree[A]) -> (A, TwoThreeTree[A])? {
  match xs {
    Empty => None
    _ as xs =>
      match TwoThreeTree::uncons_aux(xs) {
        Keep(x, xs) => Some((x, xs))
        Underflow(x, xs) => Some((x, xs))
      }
  }
}
