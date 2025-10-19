///|
pub enum ViewLeft[A] {
  Nil
  Cons(A, TwoThreeFourTree[A])
}

///|
fn[A] TwoThreeFourTree::uncons_aux(
  xs : TwoThreeFourTree[A],
) -> (A, TwoThreeFourTree[A]) {
  match xs {
    Empty | Two(Empty, _, Empty) => panic()
    Three(Empty, a, Empty, y, Empty) => (a, Two(Empty, y, Empty))
    Four(Empty, a, Empty, x, Empty, y, Empty) =>
      (a, Three(Empty, x, Empty, y, Empty))
    Two(Three(_) | Four(_) as left, x, right) => {
      let (a, left) = TwoThreeFourTree::uncons_aux(left)
      (a, Two(left, x, right))
    }
    Three(Three(_) | Four(_) as left, x, middle, y, right) => {
      let (a, left) = TwoThreeFourTree::uncons_aux(left)
      (a, Three(left, x, middle, y, right))
    }
    Four(Three(_) | Four(_) as left, x, m1, y, m2, z, right) => {
      let (a, left) = TwoThreeFourTree::uncons_aux(left)
      (a, Four(left, x, m1, y, m2, z, right))
    }
    // cases 1: height decreases
    Two(Two(left, x, m1), y, Two(m2, z, right)) =>
      TwoThreeFourTree::uncons_aux(Four(left, x, m1, y, m2, z, right))
    // cases 2: fusion for the adjacent double 2-node
    Three(Two(left, w, m1), x, Two(m2, y, m3), z, right) => {
      let (a, left) = TwoThreeFourTree::uncons_aux(
        Four(left, w, m1, x, m2, y, m3),
      )
      (a, Two(left, z, right))
    }
    Four(Two(left, s, m1), t, Two(m2, u, m3), v, m4, z, right) => {
      let (a, left) = TwoThreeFourTree::uncons_aux(
        Four(left, s, m1, t, m2, u, m3),
      )
      (a, Three(left, v, m4, z, right))
    }
    // cases 3: swap from the adjacent right sibling
    Two(Two(left, w, m1), x, Three(m2, y, m3, z, right)) => {
      let (a, left) = TwoThreeFourTree::uncons_aux(Three(left, w, m1, x, m2))
      (a, Two(left, y, Two(m3, z, right)))
    }
    Three(Two(left, v, m1), w, Three(m2, x, m3, y, m4), z, right) => {
      let (a, left) = TwoThreeFourTree::uncons_aux(Three(left, v, m1, w, m2))
      (a, Three(left, x, Two(m3, y, m4), z, right))
    }
    Four(Two(left, u, m1), v, Three(m2, w, m3, x, m4), y, m5, z, right) => {
      let (a, left) = TwoThreeFourTree::uncons_aux(Three(left, u, m1, v, m2))
      (a, Four(left, w, Two(m3, x, m4), y, m5, z, right))
    }
    Four(Two(left, s, m1), t, Four(m2, u, m3, v, m4, w, m5), x, m6, y, right) => {
      let (a, left) = TwoThreeFourTree::uncons_aux(
        Four(left, s, m1, t, m2, u, m3),
      )
      (a, Four(left, v, Two(m4, w, m5), x, m6, y, right))
    }

    // cases 4 borrow from the adjacent right sibling
    Two(Two(left, v, m1), w, Four(m2, x, m3, y, m4, z, right)) => {
      let (a, left) = TwoThreeFourTree::uncons_aux(Three(left, v, m1, w, m2))
      (a, Two(left, x, Three(m3, y, m4, z, right)))
    }
    Three(Two(left, u, m1), v, Four(m2, w, m3, x, m4, y, m5), z, right) => {
      let (a, left) = TwoThreeFourTree::uncons_aux(Three(left, u, m1, v, m2))
      (a, Three(left, w, Three(m3, x, m4, y, m5), z, right))
    }
    Two(Empty, _, _)
    | Two(Two(_), _, Empty)
    | Three(Two(_, _, _), _, Empty, _, _)
    | Three(Empty, _, _, _, _)
    | Four(Empty, _, _, _, _, _, _)
    | Four(Two(_), _, Empty, _, _, _, _) => panic()
  }
}

///|
pub fn[A] TwoThreeFourTree::uncons(xs : TwoThreeFourTree[A]) -> ViewLeft[A] {
  match xs {
    Empty => Nil
    Two(Empty, x, Empty) => Cons(x, Empty)
    Two(_) | Three(_) | Four(_) as tree => {
      let (a, rest) = TwoThreeFourTree::uncons_aux(tree)
      Cons(a, rest)
    }
  }
}
