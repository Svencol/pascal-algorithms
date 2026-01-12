{
  HashTable.pas
  
  Hash Table Implementation in Free Pascal (Separate Chaining)
  
  Description:
    A Hash Table is a data structure that maps keys to values using
    a hash function. This implementation uses separate chaining for
    collision resolution.
  
  Operations and Complexity (average / worst):
    - Insert:   O(1) / O(n)
    - Delete:   O(1) / O(n)
    - Search:   O(1) / O(n)
  
  Collision Resolution Methods:
    - Separate Chaining (used here): Each bucket is a linked list
    - Open Addressing: Find another slot in the table
      - Linear Probing
      - Quadratic Probing
      - Double Hashing
  
  Load Factor = n/m (items/buckets)
  Rehash when load factor > 0.7 (typically)
  
  Author: Your Name
  Date: 2024
}

unit HashTable;

{$mode objfpc}{$H+}

interface

const
  TABLE_SIZE = 10;  // Number of buckets

type
  { Node for chaining }
  PHashNode = ^THashNode;
  THashNode = record
    Key: string;
    Value: Integer;
    Next: PHashNode;
  end;
  
  { Hash Table class }
  THashTable = class
  private
    FBuckets: array[0..TABLE_SIZE - 1] of PHashNode;
    FSize: Integer;
    
    function Hash(const Key: string): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Insert(const Key: string; Value: Integer);
    function Search(const Key: string): Integer;
    procedure Delete(const Key: string);
    function Contains(const Key: string): Boolean;
    
    procedure Display;
    function Size: Integer;
    function IsEmpty: Boolean;
  end;

{ Demonstration procedure }
procedure DemoHashTable;

implementation

constructor THashTable.Create;
var
  i: Integer;
begin
  for i := 0 to TABLE_SIZE - 1 do
    FBuckets[i] := nil;
  FSize := 0;
end;

destructor THashTable.Destroy;
var
  i: Integer;
  Current, Temp: PHashNode;
begin
  for i := 0 to TABLE_SIZE - 1 do
  begin
    Current := FBuckets[i];
    while Current <> nil do
    begin
      Temp := Current;
      Current := Current^.Next;
      Dispose(Temp);
    end;
  end;
  inherited Destroy;
end;

{
  Hash Function
  
  Converts a string key to an index in the table.
  Uses a simple polynomial rolling hash.
  
  hash(s) = (s[0]*31^(n-1) + s[1]*31^(n-2) + ... + s[n-1]) mod TABLE_SIZE
}
function THashTable.Hash(const Key: string): Integer;
var
  HashValue: Cardinal;
  i: Integer;
begin
  HashValue := 0;
  
  for i := 1 to Length(Key) do
    HashValue := HashValue * 31 + Ord(Key[i]);
  
  Result := HashValue mod TABLE_SIZE;
end;

{
  Insert - Add key-value pair
  
  If key exists, update value.
  Otherwise, add to front of chain.
  
  Time: O(1) average
}
procedure THashTable.Insert(const Key: string; Value: Integer);
var
  Index: Integer;
  Current, NewNode: PHashNode;
begin
  Index := Hash(Key);
  Current := FBuckets[Index];
  
  // Check if key already exists
  while Current <> nil do
  begin
    if Current^.Key = Key then
    begin
      Current^.Value := Value;  // Update value
      Exit;
    end;
    Current := Current^.Next;
  end;
  
  // Key doesn't exist, create new node
  New(NewNode);
  NewNode^.Key := Key;
  NewNode^.Value := Value;
  NewNode^.Next := FBuckets[Index];
  FBuckets[Index] := NewNode;
  Inc(FSize);
end;

{
  Search - Get value by key
  
  Returns value if found, -1 otherwise.
  
  Time: O(1) average
}
function THashTable.Search(const Key: string): Integer;
var
  Index: Integer;
  Current: PHashNode;
begin
  Index := Hash(Key);
  Current := FBuckets[Index];
  
  while Current <> nil do
  begin
    if Current^.Key = Key then
    begin
      Result := Current^.Value;
      Exit;
    end;
    Current := Current^.Next;
  end;
  
  Result := -1;  // Not found
end;

{
  Delete - Remove key-value pair
  
  Time: O(1) average
}
procedure THashTable.Delete(const Key: string);
var
  Index: Integer;
  Current, Prev: PHashNode;
begin
  Index := Hash(Key);
  Current := FBuckets[Index];
  Prev := nil;
  
  while Current <> nil do
  begin
    if Current^.Key = Key then
    begin
      if Prev = nil then
        FBuckets[Index] := Current^.Next
      else
        Prev^.Next := Current^.Next;
      
      Dispose(Current);
      Dec(FSize);
      Exit;
    end;
    Prev := Current;
    Current := Current^.Next;
  end;
end;

function THashTable.Contains(const Key: string): Boolean;
var
  Index: Integer;
  Current: PHashNode;
begin
  Index := Hash(Key);
  Current := FBuckets[Index];
  
  while Current <> nil do
  begin
    if Current^.Key = Key then
    begin
      Result := True;
      Exit;
    end;
    Current := Current^.Next;
  end;
  
  Result := False;
end;

procedure THashTable.Display;
var
  i: Integer;
  Current: PHashNode;
begin
  WriteLn('Hash Table Contents:');
  for i := 0 to TABLE_SIZE - 1 do
  begin
    Write('Bucket ', i, ': ');
    Current := FBuckets[i];
    
    if Current = nil then
      Write('empty')
    else
    begin
      while Current <> nil do
      begin
        Write('[', Current^.Key, ':', Current^.Value, '] ');
        Current := Current^.Next;
      end;
    end;
    WriteLn;
  end;
end;

function THashTable.Size: Integer;
begin
  Result := FSize;
end;

function THashTable.IsEmpty: Boolean;
begin
  Result := FSize = 0;
end;

procedure DemoHashTable;
var
  HT: THashTable;
begin
  WriteLn('=== Hash Table Demonstration ===');
  WriteLn;
  
  HT := THashTable.Create;
  try
    WriteLn('Inserting key-value pairs...');
    HT.Insert('apple', 5);
    HT.Insert('banana', 7);
    HT.Insert('orange', 3);
    HT.Insert('grape', 12);
    HT.Insert('mango', 8);
    HT.Insert('kiwi', 4);
    
    WriteLn;
    HT.Display;
    
    WriteLn;
    WriteLn('Size: ', HT.Size);
    
    WriteLn;
    WriteLn('Searching:');
    WriteLn('  apple -> ', HT.Search('apple'));
    WriteLn('  grape -> ', HT.Search('grape'));
    WriteLn('  pear  -> ', HT.Search('pear'), ' (not found)');
    
    WriteLn;
    WriteLn('Contains "banana"? ', HT.Contains('banana'));
    WriteLn('Contains "pear"? ', HT.Contains('pear'));
    
    WriteLn;
    WriteLn('Deleting "banana"...');
    HT.Delete('banana');
    WriteLn('Contains "banana"? ', HT.Contains('banana'));
    WriteLn('Size: ', HT.Size);
    
    WriteLn;
  finally
    HT.Free;
  end;
end;

end.
