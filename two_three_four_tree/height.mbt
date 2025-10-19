///|
pub(all) suberror Imbalance

///|
pub fn[A] TwoThreeFourTree::height(
  self : TwoThreeFourTree[A],
) -> Int raise Imbalance {
  match self {
    Three(left, _, middle, _, right) => {
      let lh = left.height()
      let mh = middle.height()
      let rh = right.height()
      if lh == mh && mh == rh {
        lh + 1
      } else {
        raise Imbalance
      }
    }
    Two(left, _, right) => {
      let lh = left.height()
      let rh = right.height()
      if lh == rh {
        lh + 1
      } else {
        raise Imbalance
      }
    }
    Empty => 0
    Four(left, _, left_middle, _, right_middle, _, right) => {
      let lth = left.height()
      let lmh = left_middle.height()
      let rmh = right_middle.height()
      let rth = right.height()
      if lth == lmh && lmh == rmh && rmh == rth {
        lth + 1
      } else {
        raise Imbalance
      }
    }
  }
}
