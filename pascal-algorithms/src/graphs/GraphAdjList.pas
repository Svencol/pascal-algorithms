{
  GraphAdjList.pas
  
  Graph Implementation using Adjacency List in Free Pascal
  Including BFS, DFS, and Dijkstra's Algorithm
  
  Author: Your Name
  Date: 2024
}

unit GraphAdjList;

{$mode objfpc}{$H+}

interface

const
  MAX_VERTICES = 100;
  INF = MaxInt;

type
  PAdjNode = ^TAdjNode;
  TAdjNode = record
    Vertex: Integer;
    Weight: Integer;
    Next: PAdjNode;
  end;
  
  TGraph = class
  private
    FAdjList: array[0..MAX_VERTICES - 1] of PAdjNode;
    FVertices: Integer;
    FDirected: Boolean;
  public
    constructor Create(NumVertices: Integer; Directed: Boolean = False);
    destructor Destroy; override;
    
    procedure AddEdge(Src, Dest: Integer; Weight: Integer = 1);
    function HasEdge(Src, Dest: Integer): Boolean;
    procedure BFS(StartVertex: Integer);
    procedure DFS(StartVertex: Integer);
    procedure DFSRecursive(Vertex: Integer; var Visited: array of Boolean);
    procedure Dijkstra(Source: Integer);
    procedure Display;
    function GetVertexCount: Integer;
  end;

procedure DemoGraph;

implementation

constructor TGraph.Create(NumVertices: Integer; Directed: Boolean = False);
var
  i: Integer;
begin
  FVertices := NumVertices;
  FDirected := Directed;
  for i := 0 to FVertices - 1 do
    FAdjList[i] := nil;
end;

destructor TGraph.Destroy;
var
  i: Integer;
  Current, Temp: PAdjNode;
begin
  for i := 0 to FVertices - 1 do
  begin
    Current := FAdjList[i];
    while Current <> nil do
    begin
      Temp := Current;
      Current := Current^.Next;
      Dispose(Temp);
    end;
  end;
  inherited Destroy;
end;

procedure TGraph.AddEdge(Src, Dest: Integer; Weight: Integer = 1);
var
  NewNode: PAdjNode;
begin
  New(NewNode);
  NewNode^.Vertex := Dest;
  NewNode^.Weight := Weight;
  NewNode^.Next := FAdjList[Src];
  FAdjList[Src] := NewNode;
  
  if not FDirected then
  begin
    New(NewNode);
    NewNode^.Vertex := Src;
    NewNode^.Weight := Weight;
    NewNode^.Next := FAdjList[Dest];
    FAdjList[Dest] := NewNode;
  end;
end;

function TGraph.HasEdge(Src, Dest: Integer): Boolean;
var
  Current: PAdjNode;
begin
  Current := FAdjList[Src];
  while Current <> nil do
  begin
    if Current^.Vertex = Dest then
    begin
      Result := True;
      Exit;
    end;
    Current := Current^.Next;
  end;
  Result := False;
end;

{
  BFS - Breadth-First Search
  
  Explores all vertices at current depth before moving to next level.
  Uses a queue data structure.
  
  Time: O(V + E)
  Space: O(V)
  
  Applications:
  - Shortest path in unweighted graph
  - Level order traversal
  - Finding connected components
}
procedure TGraph.BFS(StartVertex: Integer);
var
  Visited: array[0..MAX_VERTICES - 1] of Boolean;
  Queue: array[0..MAX_VERTICES - 1] of Integer;
  Front, Rear: Integer;
  Current: Integer;
  Neighbor: PAdjNode;
  i: Integer;
begin
  WriteLn('BFS starting from vertex ', StartVertex, ':');
  
  for i := 0 to FVertices - 1 do
    Visited[i] := False;
  
  Front := 0;
  Rear := 0;
  
  Visited[StartVertex] := True;
  Queue[Rear] := StartVertex;
  Inc(Rear);
  
  while Front < Rear do
  begin
    Current := Queue[Front];
    Inc(Front);
    Write(Current, ' ');
    
    Neighbor := FAdjList[Current];
    while Neighbor <> nil do
    begin
      if not Visited[Neighbor^.Vertex] then
      begin
        Visited[Neighbor^.Vertex] := True;
        Queue[Rear] := Neighbor^.Vertex;
        Inc(Rear);
      end;
      Neighbor := Neighbor^.Next;
    end;
  end;
  
  WriteLn;
end;

{
  DFS - Depth-First Search (Recursive)
  
  Explores as far as possible along each branch before backtracking.
  Uses recursion (implicit stack).
  
  Time: O(V + E)
  Space: O(V)
}
procedure TGraph.DFSRecursive(Vertex: Integer; var Visited: array of Boolean);
var
  Neighbor: PAdjNode;
begin
  Visited[Vertex] := True;
  Write(Vertex, ' ');
  
  Neighbor := FAdjList[Vertex];
  while Neighbor <> nil do
  begin
    if not Visited[Neighbor^.Vertex] then
      DFSRecursive(Neighbor^.Vertex, Visited);
    Neighbor := Neighbor^.Next;
  end;
end;

procedure TGraph.DFS(StartVertex: Integer);
var
  Visited: array[0..MAX_VERTICES - 1] of Boolean;
  i: Integer;
begin
  WriteLn('DFS starting from vertex ', StartVertex, ':');
  
  for i := 0 to FVertices - 1 do
    Visited[i] := False;
  
  DFSRecursive(StartVertex, Visited);
  WriteLn;
end;

{
  Dijkstra's Algorithm - Shortest Path
  
  Finds shortest path from source to all other vertices.
  Works with non-negative edge weights.
  
  Time: O(V²) with array, O((V+E)log V) with heap
  Space: O(V)
  
  Algorithm:
  1. Initialize distances: source=0, others=infinity
  2. Pick unvisited vertex with minimum distance
  3. Update distances of adjacent vertices
  4. Repeat until all vertices visited
}
procedure TGraph.Dijkstra(Source: Integer);
var
  Dist: array[0..MAX_VERTICES - 1] of Integer;
  Visited: array[0..MAX_VERTICES - 1] of Boolean;
  i, j, u, MinDist: Integer;
  Neighbor: PAdjNode;
begin
  WriteLn('Dijkstra''s Shortest Path from vertex ', Source, ':');
  WriteLn;
  
  // Initialize
  for i := 0 to FVertices - 1 do
  begin
    Dist[i] := INF;
    Visited[i] := False;
  end;
  Dist[Source] := 0;
  
  for i := 0 to FVertices - 2 do
  begin
    // Find minimum distance vertex
    MinDist := INF;
    u := -1;
    for j := 0 to FVertices - 1 do
    begin
      if (not Visited[j]) and (Dist[j] < MinDist) then
      begin
        MinDist := Dist[j];
        u := j;
      end;
    end;
    
    if u = -1 then
      Break;
    
    Visited[u] := True;
    
    // Update distances of adjacent vertices
    Neighbor := FAdjList[u];
    while Neighbor <> nil do
    begin
      if (not Visited[Neighbor^.Vertex]) and
         (Dist[u] <> INF) and
         (Dist[u] + Neighbor^.Weight < Dist[Neighbor^.Vertex]) then
      begin
        Dist[Neighbor^.Vertex] := Dist[u] + Neighbor^.Weight;
      end;
      Neighbor := Neighbor^.Next;
    end;
  end;
  
  // Print distances
  WriteLn('Vertex   Distance from Source');
  for i := 0 to FVertices - 1 do
  begin
    Write('  ', i, '            ');
    if Dist[i] = INF then
      WriteLn('INF')
    else
      WriteLn(Dist[i]);
  end;
end;

procedure TGraph.Display;
var
  i: Integer;
  Current: PAdjNode;
begin
  WriteLn('Adjacency List:');
  for i := 0 to FVertices - 1 do
  begin
    Write(i, ': ');
    Current := FAdjList[i];
    while Current <> nil do
    begin
      Write(Current^.Vertex, '(', Current^.Weight, ') ');
      Current := Current^.Next;
    end;
    WriteLn;
  end;
end;

function TGraph.GetVertexCount: Integer;
begin
  Result := FVertices;
end;

procedure DemoGraph;
var
  G: TGraph;
begin
  WriteLn('=== Graph Demonstration ===');
  WriteLn;
  
  // Create undirected graph
  G := TGraph.Create(5, False);
  try
    WriteLn('Creating undirected graph:');
    WriteLn('    0');
    WriteLn('   /|\');
    WriteLn('  1-+-2');
    WriteLn('   \|/');
    WriteLn('    3---4');
    WriteLn;
    
    G.AddEdge(0, 1, 1);
    G.AddEdge(0, 2, 1);
    G.AddEdge(1, 2, 1);
    G.AddEdge(1, 3, 1);
    G.AddEdge(2, 3, 1);
    G.AddEdge(3, 4, 1);
    
    G.Display;
    WriteLn;
    
    G.BFS(0);
    WriteLn;
    G.DFS(0);
    WriteLn;
  finally
    G.Free;
  end;
  
  // Create weighted directed graph for Dijkstra
  WriteLn;
  WriteLn('=== Weighted Graph for Dijkstra ===');
  G := TGraph.Create(5, True);
  try
    G.AddEdge(0, 1, 4);
    G.AddEdge(0, 2, 1);
    G.AddEdge(2, 1, 2);
    G.AddEdge(1, 3, 1);
    G.AddEdge(2, 3, 5);
    G.AddEdge(3, 4, 3);
    
    G.Display;
    WriteLn;
    G.Dijkstra(0);
  finally
    G.Free;
  end;
  
  WriteLn;
end;

end.
