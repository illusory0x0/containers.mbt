///|
test (t : @test.T) {
  let mut lst = @list.Nil
  for x in 1..<10 {
    lst = @list.Cons(x, lst)
  }
  t.writeln(lst.to_sequence().to_digraph())
  t.snapshot(filename="list_cons.dot")
}
