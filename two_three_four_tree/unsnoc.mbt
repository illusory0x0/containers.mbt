///|
pub enum ViewRight[A] {
  Nil
  Snoc(TwoThreeFourTree[A], A)
}

///|
fn[A] TwoThreeFourTree::unsnoc_aux(
  xs : TwoThreeFourTree[A],
) -> (TwoThreeFourTree[A], A) {
  match xs {
    Empty | Two(Empty, _, Empty) => panic()
    Three(Empty, x, Empty, a, Empty) => (Two(Empty, x, Empty), a)
    Four(Empty, x, Empty, y, Empty, a, Empty) =>
      (Three(Empty, x, Empty, y, Empty), a)
    Two(left, x, Three(_) | Four(_) as right) => {
      let (right, a) = TwoThreeFourTree::unsnoc_aux(right)
      (Two(left, x, right), a)
    }
    Three(left, x, middle, y, Three(_) | Four(_) as right) => {
      let (right, a) = TwoThreeFourTree::unsnoc_aux(right)
      (Three(left, x, middle, y, right), a)
    }
    Four(left, x, m1, y, m2, z, Three(_) | Four(_) as right) => {
      let (right, a) = TwoThreeFourTree::unsnoc_aux(right)
      (Four(left, x, m1, y, m2, z, right), a)
    }
    // cases 1: height decreases
    Two(Two(left, x, m1), y, Two(m2, z, right)) =>
      TwoThreeFourTree::unsnoc_aux(Four(left, x, m1, y, m2, z, right))
    // cases 2: fusion for the adjacent double 2-node
    Three(left, x, Two(m1, y, m2), z, Two(m3, w, right)) => {
      let (right, a) = TwoThreeFourTree::unsnoc_aux(
        Four(m1, y, m2, z, m3, w, right),
      )
      (Two(left, x, right), a)
    }
    Four(left, x, m1, y, Two(m2, u, m3), v, Two(m4, s, right)) => {
      let (right, a) = TwoThreeFourTree::unsnoc_aux(
        Four(m2, u, m3, v, m4, s, right),
      )
      (Three(left, x, m1, y, right), a)
    }
    // cases 3: swap from the adjacent left sibling
    Two(Three(left, x, m1, y, m2), z, Two(m3, w, right)) => {
      let (right, a) = TwoThreeFourTree::unsnoc_aux(Three(m2, z, m3, w, right))
      (Two(Two(left, x, m1), y, right), a)
    }
    Three(left, x, Three(m1, y, m2, z, m3), w, Two(m4, v, right)) => {
      let (right, a) = TwoThreeFourTree::unsnoc_aux(Three(m3, w, m4, v, right))
      (Three(left, x, Two(m1, y, m2), z, right), a)
    }
    Four(left, x, m1, y, Three(m2, w, m3, v, m4), u, Two(m5, t, right)) => {
      let (right, a) = TwoThreeFourTree::unsnoc_aux(Three(m4, u, m5, t, right))
      (Four(left, x, m1, y, Two(m2, w, m3), v, right), a)
    }
    Four(left, x, m1, y, Four(m2, u, m3, v, m4, w, m5), t, Two(m6, s, right)) => {
      let (right, a) = TwoThreeFourTree::unsnoc_aux(
        Four(m4, w, m5, t, m6, s, right),
      )
      (Four(left, x, m1, y, Three(m2, u, m3, v, m4), w, right), a)
    }

    // cases 4 borrow from the adjacent left sibling
    Two(Four(left, x, m1, y, m2, z, m3), w, Two(m4, v, right)) => {
      let (right, a) = TwoThreeFourTree::unsnoc_aux(Three(m3, w, m4, v, right))
      (Two(Three(left, x, m1, y, m2), z, right), a)
    }
    Three(left, x, Four(m1, y, m2, z, m3, w, m4), v, Two(m5, u, right)) => {
      let (right, a) = TwoThreeFourTree::unsnoc_aux(Three(m4, v, m5, u, right))
      (Three(left, x, Three(m1, y, m2, z, m3), w, right), a)
    }
    Two(_, _, Empty)
    | Two(Empty, _, Two(_))
    | Three(_, _, Empty, _, Two(_, _, _))
    | Three(_, _, _, _, Empty)
    | Four(_, _, _, _, _, _, Empty)
    | Four(_, _, _, _, Empty, _, Two(_)) => panic()
  }
}

///|
pub fn[A] TwoThreeFourTree::unsnoc(xs : TwoThreeFourTree[A]) -> ViewRight[A] {
  match xs {
    Empty => Nil
    Two(Empty, x, Empty) => Snoc(Empty, x)
    Two(_) | Three(_) | Four(_) as tree => {
      let (rest, a) = TwoThreeFourTree::unsnoc_aux(tree)
      Snoc(rest, a)
    }
  }
}
