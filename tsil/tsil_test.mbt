///|
test (t : @test.T) {
  let mut lst = @tsil.Lin
  for x in 1..<10 {
    lst = @tsil.Snoc(lst, x)
  }
  t.writeln(lst.to_sequence().to_digraph())
  t.snapshot(filename="tsil_snoc.dot")
}
