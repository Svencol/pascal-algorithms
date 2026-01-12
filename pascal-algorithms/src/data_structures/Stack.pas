{
  Stack.pas
  
  Stack Implementation in Free Pascal (Array-based and Linked List-based)
  
  Description:
    A Stack is a LIFO (Last In, First Out) data structure.
    Elements are added and removed from the same end (top).
  
  Operations and Complexity:
    - Push:    O(1)
    - Pop:     O(1)
    - Peek:    O(1)
    - IsEmpty: O(1)
  
  Real-world Applications:
    - Function call stack
    - Undo operations
    - Expression evaluation
    - Syntax parsing
    - Browser back button
  
  Visual Representation:
       _____
      |  3  | <- Top
      |  2  |
      |  1  |
      |_____|
      
  Push(4):     Pop():
       _____        _____
      |  4  |      |  3  |
      |  3  |      |  2  |
      |  2  |      |  1  |
      |  1  |      |_____|
      |_____|
  
  Author: Your Name
  Date: 2024
}

unit Stack;

{$mode objfpc}{$H+}

interface

const
  MAX_SIZE = 100;

type
  { Array-based Stack }
  TArrayStack = class
  private
    FData: array[0..MAX_SIZE - 1] of Integer;
    FTop: Integer;
  public
    constructor Create;
    
    procedure Push(Value: Integer);
    function Pop: Integer;
    function Peek: Integer;
    function IsEmpty: Boolean;
    function IsFull: Boolean;
    function Size: Integer;
    procedure Display;
  end;
  
  { Node for linked list stack }
  PStackNode = ^TStackNode;
  TStackNode = record
    Data: Integer;
    Next: PStackNode;
  end;
  
  { Linked List-based Stack }
  TLinkedStack = class
  private
    FTop: PStackNode;
    FSize: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Push(Value: Integer);
    function Pop: Integer;
    function Peek: Integer;
    function IsEmpty: Boolean;
    function Size: Integer;
    procedure Display;
    procedure Clear;
  end;

{ Demonstration procedures }
procedure DemoArrayStack;
procedure DemoLinkedStack;
procedure DemoBalancedParentheses;

implementation

{ ===== Array-based Stack Implementation ===== }

constructor TArrayStack.Create;
begin
  FTop := -1;  // Empty stack
end;

{
  Push - Add element to top of stack
  Time: O(1)
}
procedure TArrayStack.Push(Value: Integer);
begin
  if IsFull then
  begin
    WriteLn('Error: Stack overflow');
    Exit;
  end;
  
  Inc(FTop);
  FData[FTop] := Value;
end;

{
  Pop - Remove and return top element
  Time: O(1)
}
function TArrayStack.Pop: Integer;
begin
  if IsEmpty then
  begin
    WriteLn('Error: Stack underflow');
    Result := -1;
    Exit;
  end;
  
  Result := FData[FTop];
  Dec(FTop);
end;

{
  Peek - Return top element without removing
  Time: O(1)
}
function TArrayStack.Peek: Integer;
begin
  if IsEmpty then
  begin
    WriteLn('Error: Stack is empty');
    Result := -1;
    Exit;
  end;
  
  Result := FData[FTop];
end;

function TArrayStack.IsEmpty: Boolean;
begin
  Result := FTop = -1;
end;

function TArrayStack.IsFull: Boolean;
begin
  Result := FTop = MAX_SIZE - 1;
end;

function TArrayStack.Size: Integer;
begin
  Result := FTop + 1;
end;

procedure TArrayStack.Display;
var
  i: Integer;
begin
  if IsEmpty then
  begin
    WriteLn('Stack is empty');
    Exit;
  end;
  
  WriteLn('Stack (top to bottom):');
  for i := FTop downto 0 do
    WriteLn('  ', FData[i]);
end;

{ ===== Linked List-based Stack Implementation ===== }

constructor TLinkedStack.Create;
begin
  FTop := nil;
  FSize := 0;
end;

destructor TLinkedStack.Destroy;
begin
  Clear;
  inherited Destroy;
end;

{
  Push - Add element to top of stack
  
  Creates new node and makes it the new top.
  
  Before:   Top -> [20] -> [10] -> nil
  Push(30)
  After:    Top -> [30] -> [20] -> [10] -> nil
  
  Time: O(1)
}
procedure TLinkedStack.Push(Value: Integer);
var
  NewNode: PStackNode;
begin
  New(NewNode);
  NewNode^.Data := Value;
  NewNode^.Next := FTop;
  FTop := NewNode;
  Inc(FSize);
end;

{
  Pop - Remove and return top element
  Time: O(1)
}
function TLinkedStack.Pop: Integer;
var
  Temp: PStackNode;
begin
  if IsEmpty then
  begin
    WriteLn('Error: Stack underflow');
    Result := -1;
    Exit;
  end;
  
  Result := FTop^.Data;
  Temp := FTop;
  FTop := FTop^.Next;
  Dispose(Temp);
  Dec(FSize);
end;

{
  Peek - Return top element without removing
  Time: O(1)
}
function TLinkedStack.Peek: Integer;
begin
  if IsEmpty then
  begin
    WriteLn('Error: Stack is empty');
    Result := -1;
    Exit;
  end;
  
  Result := FTop^.Data;
end;

function TLinkedStack.IsEmpty: Boolean;
begin
  Result := FTop = nil;
end;

function TLinkedStack.Size: Integer;
begin
  Result := FSize;
end;

procedure TLinkedStack.Display;
var
  Current: PStackNode;
begin
  if IsEmpty then
  begin
    WriteLn('Stack is empty');
    Exit;
  end;
  
  WriteLn('Stack (top to bottom):');
  Current := FTop;
  while Current <> nil do
  begin
    WriteLn('  ', Current^.Data);
    Current := Current^.Next;
  end;
end;

procedure TLinkedStack.Clear;
var
  Temp: PStackNode;
begin
  while FTop <> nil do
  begin
    Temp := FTop;
    FTop := FTop^.Next;
    Dispose(Temp);
  end;
  FSize := 0;
end;

{ ===== Demonstration Procedures ===== }

procedure DemoArrayStack;
var
  Stack: TArrayStack;
begin
  WriteLn('=== Array-based Stack Demonstration ===');
  WriteLn;
  
  Stack := TArrayStack.Create;
  try
    WriteLn('Pushing 10, 20, 30...');
    Stack.Push(10);
    Stack.Push(20);
    Stack.Push(30);
    Stack.Display;
    
    WriteLn;
    WriteLn('Peek: ', Stack.Peek);
    WriteLn('Size: ', Stack.Size);
    
    WriteLn;
    WriteLn('Popping: ', Stack.Pop);
    WriteLn('After pop:');
    Stack.Display;
    
    WriteLn;
  finally
    Stack.Free;
  end;
end;

procedure DemoLinkedStack;
var
  Stack: TLinkedStack;
begin
  WriteLn('=== Linked List Stack Demonstration ===');
  WriteLn;
  
  Stack := TLinkedStack.Create;
  try
    WriteLn('Pushing 10, 20, 30...');
    Stack.Push(10);
    Stack.Push(20);
    Stack.Push(30);
    Stack.Display;
    
    WriteLn;
    WriteLn('Peek: ', Stack.Peek);
    WriteLn('Size: ', Stack.Size);
    
    WriteLn;
    WriteLn('Popping: ', Stack.Pop);
    WriteLn('After pop:');
    Stack.Display;
    
    WriteLn;
  finally
    Stack.Free;
  end;
end;

{
  Classic Stack Application: Balanced Parentheses Checker
  
  Checks if parentheses, brackets, and braces are balanced.
  
  Algorithm:
  1. Scan string left to right
  2. Push opening brackets onto stack
  3. For closing brackets, check if matches top of stack
  4. If match, pop; otherwise unbalanced
  5. At end, stack should be empty
}
procedure DemoBalancedParentheses;

  function IsBalanced(const Expr: string): Boolean;
  var
    Stack: TArrayStack;
    i: Integer;
    C: Char;
    Top: Char;
  begin
    Stack := TArrayStack.Create;
    try
      for i := 1 to Length(Expr) do
      begin
        C := Expr[i];
        
        // Push opening brackets
        if (C = '(') or (C = '[') or (C = '{') then
          Stack.Push(Ord(C))
        // Check closing brackets
        else if (C = ')') or (C = ']') or (C = '}') then
        begin
          if Stack.IsEmpty then
          begin
            Result := False;
            Exit;
          end;
          
          Top := Chr(Stack.Pop);
          
          if ((C = ')') and (Top <> '(')) or
             ((C = ']') and (Top <> '[')) or
             ((C = '}') and (Top <> '{')) then
          begin
            Result := False;
            Exit;
          end;
        end;
      end;
      
      Result := Stack.IsEmpty;
    finally
      Stack.Free;
    end;
  end;

var
  Expressions: array[0..3] of string = (
    '((a+b)*(c-d))',
    '{[()]}',
    '([)]',
    '((())'
  );
  i: Integer;
begin
  WriteLn('=== Balanced Parentheses Demo ===');
  WriteLn;
  
  for i := 0 to High(Expressions) do
  begin
    Write(Expressions[i]:20);
    if IsBalanced(Expressions[i]) then
      WriteLn(' -> Balanced')
    else
      WriteLn(' -> NOT Balanced');
  end;
  
  WriteLn;
end;

end.
