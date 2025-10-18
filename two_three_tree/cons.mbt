///|
fn[A] TwoThreeTree::cons_aux(
  x : A,
  xs : TwoThreeTree[A],
) -> Result[TwoThreeTree[A], Four[A]] {
  match xs {
    Two(Empty, y, Empty) => Ok(Three(Empty, x, Empty, y, Empty))
    Three(Empty, y, Empty, z, Empty) =>
      Err((Empty, x, Empty, y, Empty, z, Empty))
    Two(Two(_) | Three(_) as left, z, right) =>
      match TwoThreeTree::cons_aux(x, left) {
        Err((left, w, m1, x, m2, y, m3)) =>
          // number is the payload
          //
          // Two(Four(_),_)    ->    Three(Two(_),Two(_),_)
          //            |                        |
          //            |                       / \
          //            |                      /   \  
          //            1                     1     1
          //           / \                   / \   / \   
          //          /   \                 /   \ /   \
          //         /|\   _               |     |     _
          //        / | \                  |     |
          //       1  1  1                 1     1
          //
          Ok(Three(Two(left, w, m1), x, Two(m2, y, m3), z, right))
        Ok(left) => Ok(Two(left, z, right))
      }
    Three(Two(_) | Three(_) as left, y, middle, z, right) =>
      match TwoThreeTree::cons_aux(x, left) {
        Err((left, v, m1, w, m2, x, m3)) =>
          // number is the payload
          //
          //   Three(Four(_),_,_)    ->    Four(Two(_),Two(_),_,_)
          //                 |                          |
          //                / \                        /|\
          //               /   \                      / | \
          //              1     1                    1  1  1
          //             /                          /   /
          //            /                          /   /   
          //           /|\                        |    |            
          //          / | \                       |    |          
          //         1  1  1                      1    1        
          Err((Two(left, v, m1), w, Two(m2, x, m3), y, middle, z, right))
        Ok(left) => Ok(Three(left, y, middle, z, right))
      }
    Empty => Ok(Two(Empty, x, Empty))
    _ => panic()
  }
}

///|
pub fn[A] TwoThreeTree::cons(x : A, xs : TwoThreeTree[A]) -> TwoThreeTree[A] {
  match TwoThreeTree::cons_aux(x, xs) {
    Err((left, x, m1, y, m2, z, right)) =>
      Two(Two(left, x, m1), y, Two(m2, z, right))
    Ok(tree) => tree
  }
}
