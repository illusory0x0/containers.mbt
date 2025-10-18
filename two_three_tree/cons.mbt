///|
fn[A] TwoThreeTree::cons_aux(x : A, xs : TwoThreeTree[A]) -> TwoThreeTree[A] {
  match xs {
    Two(Empty, y, Empty) => Three(Empty, x, Empty, y, Empty)
    Three(Empty, y, Empty, z, Empty) =>
      Four(Empty, x, Empty, y, Empty, z, Empty)
    Two(Two(_) | Three(_) as left, z, right) =>
      match TwoThreeTree::cons_aux(x, left) {
        Four(left, w, m1, x, m2, y, m3) => {
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
          let tree = Three(Two(left, w, m1), x, Two(m2, y, m3), z, right)
          tree
        }
        _ as left => Two(left, z, right)
      }
    Three(Two(_) | Three(_) as left, y, middle, z, right) =>
      match TwoThreeTree::cons_aux(x, left) {
        Four(left, v, m1, w, m2, x, m3) =>
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
          Four(Two(left, v, m1), w, Two(m2, x, m3), y, middle, z, right)
        _ as left => Three(left, y, middle, z, right)
      }
    Empty => Two(Empty, x, Empty)
    Two(Empty | Four(_), _, _) | Three(Empty | Four(_), _, _, _, _) | Four(_) =>
      panic()
  }
}

///|
pub fn[A] TwoThreeTree::cons(x : A, xs : TwoThreeTree[A]) -> TwoThreeTree[A] {
  match TwoThreeTree::cons_aux(x, xs) {
    Four(left, x, m1, y, m2, z, right) =>
      Two(Two(left, x, m1), y, Two(m2, z, right))
    _ as tree => tree
  }
}
