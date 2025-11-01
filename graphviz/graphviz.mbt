///|
pub(all) struct Edge {
  from : Int
  to : Int
  label : String?
}

///|
pub(all) struct Node {
  id : Int
  label : String?
}

///|
pub(all) enum Direction {
  LeftToRight
  TopToBottom
  RightToLeft
  BottomToTop
}

///|
pub(all) struct Digraph {
  nodes : Array[Node]
  edges : Array[Edge]
  rankdir : Direction
}

///|
pub impl Show for Digraph with output(self, logger) {
  logger.write_string("\ndigraph {\n")
  match self.rankdir {
    LeftToRight => logger.write_string("rankdir=LR;\n")
    TopToBottom => logger.write_string("rankdir=TB;\n")
    RightToLeft => logger.write_string("rankdir=RL;\n")
    BottomToTop => logger.write_string("rankdir=BT;\n")
  }
  logger.write_string("node [shape = circle; style = filled;];\n")
  for edge in self.edges {
    logger.write_object(edge.from)
    logger.write_string("->")
    logger.write_object(edge.to)
    match edge.label {
      None => ()
      Some(label) => logger.write_string("[label=\{label.escape()}]")
    }
    logger.write_string(";\n")
  }
  for node in self.nodes {
    let id = node.id
    match node.label {
      None =>
        logger.write_string("\{id} [label=\"\"; height=0.1; width=0.1;]\n")
      Some(label) => logger.write_string("\{id} [label=\{label.escape()};]\n")
    }
  }
  logger.write_string("}\n")
}

///|
pub(all) enum LeafPayloadTree {
  Leaf(String)
  Children(Array[LeafPayloadTree])
}

///|
pub(all) struct NodePayloadTree {
  label : String
  children : Array[NodePayloadTree]
}

///|
pub(all) struct Sequence {
  contents : Array[String]
  rankdir : Direction
}

///|
pub fn Sequence::to_digraph(self : Sequence) -> Digraph {
  let edges = []
  let nodes = []
  for i = 0; i < self.contents.length(); i = i + 1 {
    nodes.push(Node::{ id: i + 1, label: Some(self.contents[i]) })
    if i > 0 {
      edges.push(Edge::{ from: i, to: i + 1, label: None })
    }
  }
  Digraph::{ edges, nodes, rankdir: self.rankdir }
}

///|
pub fn LeafPayloadTree::to_digraph(self : LeafPayloadTree) -> Digraph {
  let edges = []
  let nodes = []
  let mut cnt = 0
  fn dfs(self : LeafPayloadTree) -> Int {
    cnt += 1
    match self {
      Leaf(label) => {
        nodes.push(Node::{ id: cnt, label: Some(label) })
        cnt
      }
      Children(children) => {
        let from = cnt
        for child in children {
          let to = dfs(child)
          edges.push(Edge::{ from, to, label: None })
        }
        nodes.push(Node::{ id: from, label: None })
        from
      }
    }
  }

  dfs(self) |> ignore
  Digraph::{ edges, nodes, rankdir: TopToBottom }
}

///|
pub fn NodePayloadTree::to_digraph(self : NodePayloadTree) -> Digraph {
  let edges = []
  let nodes = []
  let mut cnt = 0
  fn dfs(self : NodePayloadTree) -> Int {
    cnt += 1
    let from = cnt
    nodes.push(Node::{ id: from, label: Some(self.label) })
    for child in self.children {
      let to = dfs(child)
      edges.push(Edge::{ from, to, label: None })
    }
    from
  }

  dfs(self) |> ignore
  Digraph::{ edges, nodes, rankdir: TopToBottom }
}
