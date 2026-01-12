{
  BinaryTree.pas
  
  Binary Search Tree Implementation in Free Pascal
  
  Description:
    A Binary Search Tree (BST) is a node-based binary tree where:
    - Left subtree contains only nodes with keys less than parent
    - Right subtree contains only nodes with keys greater than parent
    - Both subtrees are also BSTs
  
  Operations and Complexity (average / worst):
    - Insert:   O(log n) / O(n)
    - Delete:   O(log n) / O(n)
    - Search:   O(log n) / O(n)
    - Traverse: O(n)
  
  Note: Worst case occurs when tree becomes a linked list (unbalanced)
  
  Tree Structure:
            50
           /  \
         30    70
        /  \   /  \
       20  40 60  80
  
  Author: Your Name
  Date: 2024
}

unit BinaryTree;

{$mode objfpc}{$H+}

interface

type
  { Tree node structure }
  PTreeNode = ^TTreeNode;
  TTreeNode = record
    Data: Integer;
    Left: PTreeNode;
    Right: PTreeNode;
  end;
  
  { Binary Search Tree class }
  TBinarySearchTree = class
  private
    FRoot: PTreeNode;
    FSize: Integer;
    
    function InsertRec(Node: PTreeNode; Value: Integer): PTreeNode;
    function SearchRec(Node: PTreeNode; Value: Integer): PTreeNode;
    function DeleteRec(Node: PTreeNode; Value: Integer): PTreeNode;
    function FindMin(Node: PTreeNode): PTreeNode;
    procedure InorderRec(Node: PTreeNode);
    procedure PreorderRec(Node: PTreeNode);
    procedure PostorderRec(Node: PTreeNode);
    function HeightRec(Node: PTreeNode): Integer;
    procedure DestroyTree(Node: PTreeNode);
  public
    constructor Create;
    destructor Destroy; override;
    
    { Basic operations }
    procedure Insert(Value: Integer);
    function Search(Value: Integer): Boolean;
    procedure Delete(Value: Integer);
    
    { Traversals }
    procedure InorderTraversal;
    procedure PreorderTraversal;
    procedure PostorderTraversal;
    procedure LevelOrderTraversal;
    
    { Utility }
    function Height: Integer;
    function IsEmpty: Boolean;
    function Size: Integer;
    function FindMinimum: Integer;
    function FindMaximum: Integer;
  end;

{ Demonstration procedure }
procedure DemoBinaryTree;

implementation

constructor TBinarySearchTree.Create;
begin
  FRoot := nil;
  FSize := 0;
end;

destructor TBinarySearchTree.Destroy;
begin
  DestroyTree(FRoot);
  inherited Destroy;
end;

procedure TBinarySearchTree.DestroyTree(Node: PTreeNode);
begin
  if Node <> nil then
  begin
    DestroyTree(Node^.Left);
    DestroyTree(Node^.Right);
    Dispose(Node);
  end;
end;

{
  Insert - Add a new value to the BST
  
  Algorithm:
  1. Start at root
  2. If value < current node, go left
  3. If value > current node, go right
  4. When reaching nil, insert new node
  
  Example: Insert 25
            50                    50
           /  \                  /  \
         30    70     =>       30    70
        /  \                  /  \
       20  40                20  40
                             \
                             25
}
function TBinarySearchTree.InsertRec(Node: PTreeNode; Value: Integer): PTreeNode;
begin
  if Node = nil then
  begin
    New(Node);
    Node^.Data := Value;
    Node^.Left := nil;
    Node^.Right := nil;
    Inc(FSize);
    Result := Node;
    Exit;
  end;
  
  if Value < Node^.Data then
    Node^.Left := InsertRec(Node^.Left, Value)
  else if Value > Node^.Data then
    Node^.Right := InsertRec(Node^.Right, Value);
  // Duplicate values are ignored
  
  Result := Node;
end;

procedure TBinarySearchTree.Insert(Value: Integer);
begin
  FRoot := InsertRec(FRoot, Value);
end;

{
  Search - Find a value in the BST
  
  Time: O(h) where h is height of tree
}
function TBinarySearchTree.SearchRec(Node: PTreeNode; Value: Integer): PTreeNode;
begin
  if (Node = nil) or (Node^.Data = Value) then
  begin
    Result := Node;
    Exit;
  end;
  
  if Value < Node^.Data then
    Result := SearchRec(Node^.Left, Value)
  else
    Result := SearchRec(Node^.Right, Value);
end;

function TBinarySearchTree.Search(Value: Integer): Boolean;
begin
  Result := SearchRec(FRoot, Value) <> nil;
end;

{
  Find Minimum - Returns node with minimum value (leftmost node)
}
function TBinarySearchTree.FindMin(Node: PTreeNode): PTreeNode;
begin
  if Node^.Left = nil then
    Result := Node
  else
    Result := FindMin(Node^.Left);
end;

{
  Delete - Remove a value from the BST
  
  Three cases:
  1. Node is a leaf: Simply remove
  2. Node has one child: Replace with child
  3. Node has two children: Replace with inorder successor
  
  Inorder successor is the minimum value in right subtree
}
function TBinarySearchTree.DeleteRec(Node: PTreeNode; Value: Integer): PTreeNode;
var
  Temp: PTreeNode;
begin
  if Node = nil then
  begin
    Result := nil;
    Exit;
  end;
  
  if Value < Node^.Data then
    Node^.Left := DeleteRec(Node^.Left, Value)
  else if Value > Node^.Data then
    Node^.Right := DeleteRec(Node^.Right, Value)
  else
  begin
    // Node found - handle three cases
    
    // Case 1 & 2: Node has 0 or 1 child
    if Node^.Left = nil then
    begin
      Temp := Node^.Right;
      Dispose(Node);
      Dec(FSize);
      Result := Temp;
      Exit;
    end
    else if Node^.Right = nil then
    begin
      Temp := Node^.Left;
      Dispose(Node);
      Dec(FSize);
      Result := Temp;
      Exit;
    end;
    
    // Case 3: Node has two children
    // Get inorder successor (smallest in right subtree)
    Temp := FindMin(Node^.Right);
    Node^.Data := Temp^.Data;
    Node^.Right := DeleteRec(Node^.Right, Temp^.Data);
  end;
  
  Result := Node;
end;

procedure TBinarySearchTree.Delete(Value: Integer);
begin
  FRoot := DeleteRec(FRoot, Value);
end;

{
  Inorder Traversal: Left -> Root -> Right
  
  For BST, this produces sorted order!
  
  Example:      50
               /  \
             30    70
            /  \
           20  40
  
  Inorder: 20 30 40 50 70
}
procedure TBinarySearchTree.InorderRec(Node: PTreeNode);
begin
  if Node <> nil then
  begin
    InorderRec(Node^.Left);
    Write(Node^.Data, ' ');
    InorderRec(Node^.Right);
  end;
end;

procedure TBinarySearchTree.InorderTraversal;
begin
  Write('Inorder:   ');
  InorderRec(FRoot);
  WriteLn;
end;

{
  Preorder Traversal: Root -> Left -> Right
  
  Useful for creating a copy of the tree
  
  Preorder: 50 30 20 40 70
}
procedure TBinarySearchTree.PreorderRec(Node: PTreeNode);
begin
  if Node <> nil then
  begin
    Write(Node^.Data, ' ');
    PreorderRec(Node^.Left);
    PreorderRec(Node^.Right);
  end;
end;

procedure TBinarySearchTree.PreorderTraversal;
begin
  Write('Preorder:  ');
  PreorderRec(FRoot);
  WriteLn;
end;

{
  Postorder Traversal: Left -> Right -> Root
  
  Useful for deleting tree (delete children before parent)
  
  Postorder: 20 40 30 70 50
}
procedure TBinarySearchTree.PostorderRec(Node: PTreeNode);
begin
  if Node <> nil then
  begin
    PostorderRec(Node^.Left);
    PostorderRec(Node^.Right);
    Write(Node^.Data, ' ');
  end;
end;

procedure TBinarySearchTree.PostorderTraversal;
begin
  Write('Postorder: ');
  PostorderRec(FRoot);
  WriteLn;
end;

{
  Level Order Traversal (BFS)
  
  Uses a queue to process nodes level by level
  
  Level Order: 50 30 70 20 40
}
procedure TBinarySearchTree.LevelOrderTraversal;
var
  Queue: array[0..99] of PTreeNode;
  Front, Rear: Integer;
  Current: PTreeNode;
begin
  if FRoot = nil then
  begin
    WriteLn('Tree is empty');
    Exit;
  end;
  
  Write('Level Order: ');
  
  Front := 0;
  Rear := 0;
  Queue[Rear] := FRoot;
  Inc(Rear);
  
  while Front < Rear do
  begin
    Current := Queue[Front];
    Inc(Front);
    
    Write(Current^.Data, ' ');
    
    if Current^.Left <> nil then
    begin
      Queue[Rear] := Current^.Left;
      Inc(Rear);
    end;
    
    if Current^.Right <> nil then
    begin
      Queue[Rear] := Current^.Right;
      Inc(Rear);
    end;
  end;
  
  WriteLn;
end;

{
  Height - Returns height of the tree
  
  Height is the number of edges on longest path from root to leaf
}
function TBinarySearchTree.HeightRec(Node: PTreeNode): Integer;
var
  LeftHeight, RightHeight: Integer;
begin
  if Node = nil then
  begin
    Result := -1;  // Height of empty tree is -1
    Exit;
  end;
  
  LeftHeight := HeightRec(Node^.Left);
  RightHeight := HeightRec(Node^.Right);
  
  if LeftHeight > RightHeight then
    Result := LeftHeight + 1
  else
    Result := RightHeight + 1;
end;

function TBinarySearchTree.Height: Integer;
begin
  Result := HeightRec(FRoot);
end;

function TBinarySearchTree.IsEmpty: Boolean;
begin
  Result := FRoot = nil;
end;

function TBinarySearchTree.Size: Integer;
begin
  Result := FSize;
end;

function TBinarySearchTree.FindMinimum: Integer;
var
  Node: PTreeNode;
begin
  if FRoot = nil then
  begin
    WriteLn('Error: Tree is empty');
    Result := -1;
    Exit;
  end;
  
  Node := FRoot;
  while Node^.Left <> nil do
    Node := Node^.Left;
  
  Result := Node^.Data;
end;

function TBinarySearchTree.FindMaximum: Integer;
var
  Node: PTreeNode;
begin
  if FRoot = nil then
  begin
    WriteLn('Error: Tree is empty');
    Result := -1;
    Exit;
  end;
  
  Node := FRoot;
  while Node^.Right <> nil do
    Node := Node^.Right;
  
  Result := Node^.Data;
end;

procedure DemoBinaryTree;
var
  BST: TBinarySearchTree;
begin
  WriteLn('=== Binary Search Tree Demonstration ===');
  WriteLn;
  
  BST := TBinarySearchTree.Create;
  try
    WriteLn('Inserting: 50, 30, 70, 20, 40, 60, 80');
    BST.Insert(50);
    BST.Insert(30);
    BST.Insert(70);
    BST.Insert(20);
    BST.Insert(40);
    BST.Insert(60);
    BST.Insert(80);
    
    WriteLn;
    WriteLn('Tree structure:');
    WriteLn('        50');
    WriteLn('       /  \');
    WriteLn('     30    70');
    WriteLn('    /  \   /  \');
    WriteLn('   20  40 60  80');
    WriteLn;
    
    WriteLn('Traversals:');
    BST.InorderTraversal;
    BST.PreorderTraversal;
    BST.PostorderTraversal;
    BST.LevelOrderTraversal;
    
    WriteLn;
    WriteLn('Size: ', BST.Size);
    WriteLn('Height: ', BST.Height);
    WriteLn('Minimum: ', BST.FindMinimum);
    WriteLn('Maximum: ', BST.FindMaximum);
    
    WriteLn;
    WriteLn('Search for 40: ', BST.Search(40));
    WriteLn('Search for 100: ', BST.Search(100));
    
    WriteLn;
    WriteLn('Deleting 30 (node with two children)...');
    BST.Delete(30);
    WriteLn('Inorder after deletion:');
    BST.InorderTraversal;
    
    WriteLn;
  finally
    BST.Free;
  end;
end;

end.
