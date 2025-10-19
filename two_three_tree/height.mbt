///|
pub suberror Imbalance

///|
pub fn[A] TwoThreeTree::height(self : TwoThreeTree[A]) -> Int raise Imbalance {
  match self {
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
  }
}
