///|
fn[A] TwoThreeTree::snoc_aux(
  xs : TwoThreeTree[A],
  x : A,
) -> Result[TwoThreeTree[A], Four[A]] {
  match xs {
    Two(Empty, y, Empty) => Ok(Three(Empty, y, Empty, x, Empty))
    Three(Empty, y, Empty, z, Empty) =>
      Err((Empty, y, Empty, z, Empty, x, Empty))
    Two(left, z, Two(_) | Three(_) as right) =>
      match TwoThreeTree::snoc_aux(right, x) {
        Err((m1, w, m2, x, m3, y, right)) =>
          // number is the payload
          //
          // Two(_,Four(_))    ->    Three(_,Two(_),Two(_))
          //        |                        |
          //        |                       / \
          //        |                      /   \  
          //        1                     1     1
          //       / \                   / \   / \   
          //      /   \                 /   \ /   \
          //     _   /|\               _     |     |
          //        / | \                    |     |
          //       1  1  1                   1     1
          //
          Ok(Three(left, z, Two(m1, w, m2), x, Two(m3, y, right)))
        Ok(right) => Ok(Two(left, z, right))
      }
    Three(left, y, middle, z, Two(_) | Three(_) as right) =>
      match TwoThreeTree::snoc_aux(right, x) {
        Err((m1, v, m2, w, m3, x, right)) =>
          // number is the payload
          //
          //   Three(_,_,Four(_))    ->    Four(_,_,Two(_),Two(_))
          //                 |                          |
          //                / \                        /|\
          //               /   \                      / | \
          //              1     1                    1  1  1
          //                     \                        \   \
          //                      \                        \   \   
          //                      /|\                       |    |            
          //                     / | \                      |    |          
          //                    1  1  1                     1    1        
          Err((left, y, middle, z, Two(m1, v, m2), w, Two(m3, x, right)))
        Ok(right) => Ok(Three(left, y, middle, z, right))
      }
    Empty => Ok(Two(Empty, x, Empty))
    _ => panic()
  }
}

///|
pub fn[A] TwoThreeTree::snoc(xs : TwoThreeTree[A], x : A) -> TwoThreeTree[A] {
  match TwoThreeTree::snoc_aux(xs, x) {
    Err((left, x, m1, y, m2, z, right)) =>
      Two(Two(left, x, m1), y, Two(m2, z, right))
    Ok(tree) => tree
  }
}
