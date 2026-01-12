{
  LinkedList.pas
  
  Singly Linked List Implementation in Free Pascal
  
  Description:
    A linked list is a linear data structure where elements are stored
    in nodes. Each node contains data and a pointer to the next node.
    Unlike arrays, linked lists don't require contiguous memory.
  
  Operations and Complexity:
    - Insert at head:     O(1)
    - Insert at tail:     O(n) or O(1) with tail pointer
    - Insert at position: O(n)
    - Delete:             O(n)
    - Search:             O(n)
    - Access by index:    O(n)
  
  Advantages:
    - Dynamic size
    - Easy insertion/deletion at beginning
    - No memory waste (allocate as needed)
  
  Disadvantages:
    - No random access
    - Extra memory for pointers
    - Not cache-friendly
  
  Visual Representation:
    Head -> [Data|Next] -> [Data|Next] -> [Data|Next] -> nil
  
  Author: Your Name
  Date: 2024
}

unit LinkedList;

{$mode objfpc}{$H+}

interface

type
  { Node structure for linked list }
  PNode = ^TNode;
  TNode = record
    Data: Integer;
    Next: PNode;
  end;
  
  { Linked List class }
  TLinkedList = class
  private
    FHead: PNode;
    FSize: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    
    { Insert operations }
    procedure InsertAtHead(Value: Integer);
    procedure InsertAtTail(Value: Integer);
    procedure InsertAtPosition(Value: Integer; Position: Integer);
    
    { Delete operations }
    procedure DeleteAtHead;
    procedure DeleteAtTail;
    procedure DeleteValue(Value: Integer);
    procedure DeleteAtPosition(Position: Integer);
    
    { Search and access }
    function Search(Value: Integer): PNode;
    function GetAtPosition(Position: Integer): Integer;
    
    { Utility }
    procedure Display;
    procedure Reverse;
    function IsEmpty: Boolean;
    function Size: Integer;
    procedure Clear;
  end;

{ Demonstration procedure }
procedure DemoLinkedList;

implementation

constructor TLinkedList.Create;
begin
  FHead := nil;
  FSize := 0;
end;

destructor TLinkedList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

{
  Insert at Head
  
  Creates new node and makes it the new head.
  
  Before: Head -> [A] -> [B] -> nil
  InsertAtHead(X)
  After:  Head -> [X] -> [A] -> [B] -> nil
  
  Time: O(1)
}
procedure TLinkedList.InsertAtHead(Value: Integer);
var
  NewNode: PNode;
begin
  New(NewNode);
  NewNode^.Data := Value;
  NewNode^.Next := FHead;
  FHead := NewNode;
  Inc(FSize);
end;

{
  Insert at Tail
  
  Traverses to end and appends new node.
  
  Before: Head -> [A] -> [B] -> nil
  InsertAtTail(X)
  After:  Head -> [A] -> [B] -> [X] -> nil
  
  Time: O(n)
}
procedure TLinkedList.InsertAtTail(Value: Integer);
var
  NewNode, Current: PNode;
begin
  New(NewNode);
  NewNode^.Data := Value;
  NewNode^.Next := nil;
  
  if FHead = nil then
    FHead := NewNode
  else
  begin
    Current := FHead;
    while Current^.Next <> nil do
      Current := Current^.Next;
    Current^.Next := NewNode;
  end;
  
  Inc(FSize);
end;

{
  Insert at Position
  
  Inserts node at specified position (0-indexed).
  
  Time: O(n)
}
procedure TLinkedList.InsertAtPosition(Value: Integer; Position: Integer);
var
  NewNode, Current: PNode;
  i: Integer;
begin
  if (Position < 0) or (Position > FSize) then
  begin
    WriteLn('Error: Invalid position');
    Exit;
  end;
  
  if Position = 0 then
  begin
    InsertAtHead(Value);
    Exit;
  end;
  
  New(NewNode);
  NewNode^.Data := Value;
  
  Current := FHead;
  for i := 1 to Position - 1 do
    Current := Current^.Next;
  
  NewNode^.Next := Current^.Next;
  Current^.Next := NewNode;
  Inc(FSize);
end;

{
  Delete at Head
  
  Removes the first node.
  
  Time: O(1)
}
procedure TLinkedList.DeleteAtHead;
var
  Temp: PNode;
begin
  if FHead = nil then
  begin
    WriteLn('Error: List is empty');
    Exit;
  end;
  
  Temp := FHead;
  FHead := FHead^.Next;
  Dispose(Temp);
  Dec(FSize);
end;

{
  Delete at Tail
  
  Removes the last node.
  
  Time: O(n)
}
procedure TLinkedList.DeleteAtTail;
var
  Current, Prev: PNode;
begin
  if FHead = nil then
  begin
    WriteLn('Error: List is empty');
    Exit;
  end;
  
  if FHead^.Next = nil then
  begin
    Dispose(FHead);
    FHead := nil;
    Dec(FSize);
    Exit;
  end;
  
  Current := FHead;
  while Current^.Next <> nil do
  begin
    Prev := Current;
    Current := Current^.Next;
  end;
  
  Prev^.Next := nil;
  Dispose(Current);
  Dec(FSize);
end;

{
  Delete Value
  
  Deletes first occurrence of value.
  
  Time: O(n)
}
procedure TLinkedList.DeleteValue(Value: Integer);
var
  Current, Prev: PNode;
begin
  if FHead = nil then
  begin
    WriteLn('Error: List is empty');
    Exit;
  end;
  
  // Check if head needs to be deleted
  if FHead^.Data = Value then
  begin
    DeleteAtHead;
    Exit;
  end;
  
  Prev := FHead;
  Current := FHead^.Next;
  
  while (Current <> nil) and (Current^.Data <> Value) do
  begin
    Prev := Current;
    Current := Current^.Next;
  end;
  
  if Current = nil then
  begin
    WriteLn('Error: Value not found');
    Exit;
  end;
  
  Prev^.Next := Current^.Next;
  Dispose(Current);
  Dec(FSize);
end;

{
  Delete at Position
  
  Deletes node at specified position.
  
  Time: O(n)
}
procedure TLinkedList.DeleteAtPosition(Position: Integer);
var
  Current, Temp: PNode;
  i: Integer;
begin
  if (Position < 0) or (Position >= FSize) then
  begin
    WriteLn('Error: Invalid position');
    Exit;
  end;
  
  if Position = 0 then
  begin
    DeleteAtHead;
    Exit;
  end;
  
  Current := FHead;
  for i := 1 to Position - 1 do
    Current := Current^.Next;
  
  Temp := Current^.Next;
  Current^.Next := Temp^.Next;
  Dispose(Temp);
  Dec(FSize);
end;

{
  Search
  
  Returns pointer to node containing value, or nil if not found.
  
  Time: O(n)
}
function TLinkedList.Search(Value: Integer): PNode;
var
  Current: PNode;
begin
  Current := FHead;
  
  while Current <> nil do
  begin
    if Current^.Data = Value then
    begin
      Result := Current;
      Exit;
    end;
    Current := Current^.Next;
  end;
  
  Result := nil;
end;

{
  Get at Position
  
  Returns value at specified position.
  
  Time: O(n)
}
function TLinkedList.GetAtPosition(Position: Integer): Integer;
var
  Current: PNode;
  i: Integer;
begin
  if (Position < 0) or (Position >= FSize) then
  begin
    WriteLn('Error: Invalid position');
    Result := -1;
    Exit;
  end;
  
  Current := FHead;
  for i := 1 to Position do
    Current := Current^.Next;
  
  Result := Current^.Data;
end;

{
  Display
  
  Prints all elements in the list.
}
procedure TLinkedList.Display;
var
  Current: PNode;
begin
  Current := FHead;
  Write('List: ');
  
  while Current <> nil do
  begin
    Write(Current^.Data);
    if Current^.Next <> nil then
      Write(' -> ');
    Current := Current^.Next;
  end;
  
  WriteLn(' -> nil');
end;

{
  Reverse
  
  Reverses the linked list in place.
  
  Before: Head -> [A] -> [B] -> [C] -> nil
  After:  Head -> [C] -> [B] -> [A] -> nil
  
  Time: O(n), Space: O(1)
}
procedure TLinkedList.Reverse;
var
  Prev, Current, Next: PNode;
begin
  Prev := nil;
  Current := FHead;
  
  while Current <> nil do
  begin
    Next := Current^.Next;  // Store next
    Current^.Next := Prev;  // Reverse pointer
    Prev := Current;        // Move prev forward
    Current := Next;        // Move current forward
  end;
  
  FHead := Prev;
end;

function TLinkedList.IsEmpty: Boolean;
begin
  Result := FHead = nil;
end;

function TLinkedList.Size: Integer;
begin
  Result := FSize;
end;

procedure TLinkedList.Clear;
var
  Current, Temp: PNode;
begin
  Current := FHead;
  while Current <> nil do
  begin
    Temp := Current;
    Current := Current^.Next;
    Dispose(Temp);
  end;
  FHead := nil;
  FSize := 0;
end;

procedure DemoLinkedList;
var
  List: TLinkedList;
begin
  WriteLn('=== Linked List Demonstration ===');
  WriteLn;
  
  List := TLinkedList.Create;
  try
    // Insert operations
    WriteLn('Inserting 10, 20, 30 at head...');
    List.InsertAtHead(10);
    List.InsertAtHead(20);
    List.InsertAtHead(30);
    List.Display;
    
    WriteLn('Inserting 5 at tail...');
    List.InsertAtTail(5);
    List.Display;
    
    WriteLn('Inserting 25 at position 2...');
    List.InsertAtPosition(25, 2);
    List.Display;
    
    WriteLn;
    WriteLn('Size: ', List.Size);
    
    // Search
    WriteLn;
    if List.Search(20) <> nil then
      WriteLn('Found 20 in list')
    else
      WriteLn('20 not found');
    
    // Delete operations
    WriteLn;
    WriteLn('Deleting head...');
    List.DeleteAtHead;
    List.Display;
    
    WriteLn('Deleting value 25...');
    List.DeleteValue(25);
    List.Display;
    
    // Reverse
    WriteLn;
    WriteLn('Reversing list...');
    List.Reverse;
    List.Display;
    
    WriteLn;
  finally
    List.Free;
  end;
end;

end.
