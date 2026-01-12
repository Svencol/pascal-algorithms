{
  Queue.pas
  
  Queue Implementation in Free Pascal (Array and Linked List based)
  
  Description:
    A Queue is a FIFO (First In, First Out) data structure.
    Elements are added at the rear and removed from the front.
  
  Operations and Complexity:
    - Enqueue:  O(1)
    - Dequeue:  O(1)
    - Peek:     O(1)
    - IsEmpty:  O(1)
  
  Real-world Applications:
    - CPU scheduling
    - Print queue
    - BFS traversal
    - Buffer for data streams
    - Message queues
  
  Visual Representation:
    
    Dequeue <- [Front] [   ] [   ] [   ] [Rear] <- Enqueue
    
    Example: Queue with elements 1, 2, 3
    
              Front                  Rear
                |                      |
                v                      v
             [  1  ] -> [  2  ] -> [  3  ]
  
  Author: Your Name
  Date: 2024
}

unit Queue;

{$mode objfpc}{$H+}

interface

const
  MAX_SIZE = 100;

type
  { Array-based Circular Queue }
  TArrayQueue = class
  private
    FData: array[0..MAX_SIZE - 1] of Integer;
    FFront: Integer;
    FRear: Integer;
    FSize: Integer;
  public
    constructor Create;
    
    procedure Enqueue(Value: Integer);
    function Dequeue: Integer;
    function Peek: Integer;
    function IsEmpty: Boolean;
    function IsFull: Boolean;
    function Size: Integer;
    procedure Display;
  end;
  
  { Node for linked list queue }
  PQueueNode = ^TQueueNode;
  TQueueNode = record
    Data: Integer;
    Next: PQueueNode;
  end;
  
  { Linked List-based Queue }
  TLinkedQueue = class
  private
    FFront: PQueueNode;
    FRear: PQueueNode;
    FSize: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Enqueue(Value: Integer);
    function Dequeue: Integer;
    function Peek: Integer;
    function IsEmpty: Boolean;
    function Size: Integer;
    procedure Display;
    procedure Clear;
  end;

{ Demonstration procedures }
procedure DemoArrayQueue;
procedure DemoLinkedQueue;

implementation

{ ===== Array-based Circular Queue Implementation ===== }

{
  Circular Queue Design:
  
  Uses modular arithmetic to wrap around the array.
  This allows efficient use of space without shifting elements.
  
  Visual:
    Array: [0][1][2][3][4]  (MAX_SIZE = 5)
    
    After Enqueue(1), Enqueue(2), Enqueue(3):
    [1][2][3][ ][ ]
     ^     ^
   Front  Rear
    
    After Dequeue():
    [ ][2][3][ ][ ]
        ^  ^
      Front Rear
    
    After Enqueue(4), Enqueue(5), Enqueue(6):
    [6][2][3][4][5]  <- 6 wraps around to index 0
     ^     ^
   Rear  Front
}

constructor TArrayQueue.Create;
begin
  FFront := 0;
  FRear := -1;
  FSize := 0;
end;

{
  Enqueue - Add element to rear of queue
  Time: O(1)
}
procedure TArrayQueue.Enqueue(Value: Integer);
begin
  if IsFull then
  begin
    WriteLn('Error: Queue overflow');
    Exit;
  end;
  
  FRear := (FRear + 1) mod MAX_SIZE;  // Circular increment
  FData[FRear] := Value;
  Inc(FSize);
end;

{
  Dequeue - Remove and return front element
  Time: O(1)
}
function TArrayQueue.Dequeue: Integer;
begin
  if IsEmpty then
  begin
    WriteLn('Error: Queue underflow');
    Result := -1;
    Exit;
  end;
  
  Result := FData[FFront];
  FFront := (FFront + 1) mod MAX_SIZE;  // Circular increment
  Dec(FSize);
end;

{
  Peek - Return front element without removing
  Time: O(1)
}
function TArrayQueue.Peek: Integer;
begin
  if IsEmpty then
  begin
    WriteLn('Error: Queue is empty');
    Result := -1;
    Exit;
  end;
  
  Result := FData[FFront];
end;

function TArrayQueue.IsEmpty: Boolean;
begin
  Result := FSize = 0;
end;

function TArrayQueue.IsFull: Boolean;
begin
  Result := FSize = MAX_SIZE;
end;

function TArrayQueue.Size: Integer;
begin
  Result := FSize;
end;

procedure TArrayQueue.Display;
var
  i, idx: Integer;
begin
  if IsEmpty then
  begin
    WriteLn('Queue is empty');
    Exit;
  end;
  
  Write('Queue (front to rear): ');
  idx := FFront;
  for i := 0 to FSize - 1 do
  begin
    Write(FData[idx], ' ');
    idx := (idx + 1) mod MAX_SIZE;
  end;
  WriteLn;
end;

{ ===== Linked List-based Queue Implementation ===== }

constructor TLinkedQueue.Create;
begin
  FFront := nil;
  FRear := nil;
  FSize := 0;
end;

destructor TLinkedQueue.Destroy;
begin
  Clear;
  inherited Destroy;
end;

{
  Enqueue - Add element to rear of queue
  
  Creates new node and adds to rear.
  
  Before:   Front -> [10] -> [20] -> nil <- Rear
  Enqueue(30)
  After:    Front -> [10] -> [20] -> [30] -> nil <- Rear
  
  Time: O(1)
}
procedure TLinkedQueue.Enqueue(Value: Integer);
var
  NewNode: PQueueNode;
begin
  New(NewNode);
  NewNode^.Data := Value;
  NewNode^.Next := nil;
  
  if IsEmpty then
  begin
    FFront := NewNode;
    FRear := NewNode;
  end
  else
  begin
    FRear^.Next := NewNode;
    FRear := NewNode;
  end;
  
  Inc(FSize);
end;

{
  Dequeue - Remove and return front element
  Time: O(1)
}
function TLinkedQueue.Dequeue: Integer;
var
  Temp: PQueueNode;
begin
  if IsEmpty then
  begin
    WriteLn('Error: Queue underflow');
    Result := -1;
    Exit;
  end;
  
  Result := FFront^.Data;
  Temp := FFront;
  FFront := FFront^.Next;
  Dispose(Temp);
  Dec(FSize);
  
  // If queue becomes empty, reset rear
  if FFront = nil then
    FRear := nil;
end;

{
  Peek - Return front element without removing
  Time: O(1)
}
function TLinkedQueue.Peek: Integer;
begin
  if IsEmpty then
  begin
    WriteLn('Error: Queue is empty');
    Result := -1;
    Exit;
  end;
  
  Result := FFront^.Data;
end;

function TLinkedQueue.IsEmpty: Boolean;
begin
  Result := FFront = nil;
end;

function TLinkedQueue.Size: Integer;
begin
  Result := FSize;
end;

procedure TLinkedQueue.Display;
var
  Current: PQueueNode;
begin
  if IsEmpty then
  begin
    WriteLn('Queue is empty');
    Exit;
  end;
  
  Write('Queue (front to rear): ');
  Current := FFront;
  while Current <> nil do
  begin
    Write(Current^.Data, ' ');
    Current := Current^.Next;
  end;
  WriteLn;
end;

procedure TLinkedQueue.Clear;
var
  Temp: PQueueNode;
begin
  while FFront <> nil do
  begin
    Temp := FFront;
    FFront := FFront^.Next;
    Dispose(Temp);
  end;
  FRear := nil;
  FSize := 0;
end;

{ ===== Demonstration Procedures ===== }

procedure DemoArrayQueue;
var
  Q: TArrayQueue;
begin
  WriteLn('=== Array-based (Circular) Queue Demo ===');
  WriteLn;
  
  Q := TArrayQueue.Create;
  try
    WriteLn('Enqueueing 10, 20, 30...');
    Q.Enqueue(10);
    Q.Enqueue(20);
    Q.Enqueue(30);
    Q.Display;
    
    WriteLn;
    WriteLn('Peek: ', Q.Peek);
    WriteLn('Size: ', Q.Size);
    
    WriteLn;
    WriteLn('Dequeueing: ', Q.Dequeue);
    WriteLn('After dequeue:');
    Q.Display;
    
    WriteLn;
  finally
    Q.Free;
  end;
end;

procedure DemoLinkedQueue;
var
  Q: TLinkedQueue;
begin
  WriteLn('=== Linked List Queue Demo ===');
  WriteLn;
  
  Q := TLinkedQueue.Create;
  try
    WriteLn('Enqueueing 10, 20, 30...');
    Q.Enqueue(10);
    Q.Enqueue(20);
    Q.Enqueue(30);
    Q.Display;
    
    WriteLn;
    WriteLn('Peek: ', Q.Peek);
    WriteLn('Size: ', Q.Size);
    
    WriteLn;
    WriteLn('Dequeueing: ', Q.Dequeue);
    WriteLn('After dequeue:');
    Q.Display;
    
    WriteLn;
  finally
    Q.Free;
  end;
end;

end.
