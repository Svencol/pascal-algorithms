{
  BinarySearch.pas
  
  Binary Search Implementation in Free Pascal
  
  Description:
    Binary Search is an efficient algorithm for finding an item in a sorted array.
    It works by repeatedly dividing the search interval in half.
  
  Time Complexity:
    - Best Case:    O(1) - element found at middle
    - Average Case: O(log n)
    - Worst Case:   O(log n)
  
  Space Complexity:
    - Iterative: O(1)
    - Recursive: O(log n) - for recursion stack
  
  Prerequisite: Array must be sorted!
  
  Key Insight:
    Each comparison eliminates half of the remaining elements,
    leading to logarithmic time complexity.
  
  Author: Your Name
  Date: 2024
}

unit BinarySearch;

{$mode objfpc}{$H+}

interface

type
  TIntArray = array of Integer;

{ Iterative Binary Search - returns index or -1 if not found }
function BinarySearchIterative(var Arr: TIntArray; Target: Integer): Integer;

{ Recursive Binary Search }
function BinarySearchRecursive(var Arr: TIntArray; Target, Low, High: Integer): Integer;

{ Find first occurrence of target (for duplicates) }
function BinarySearchFirst(var Arr: TIntArray; Target, N: Integer): Integer;

{ Find last occurrence of target (for duplicates) }
function BinarySearchLast(var Arr: TIntArray; Target, N: Integer): Integer;

{ Demonstration procedure }
procedure DemoBinarySearch;

implementation

{
  Iterative Binary Search
  
  Algorithm:
  1. Set Low = 0, High = N-1
  2. While Low <= High:
     a. Calculate Mid = (Low + High) / 2
     b. If Arr[Mid] = Target, return Mid
     c. If Arr[Mid] < Target, search right half (Low = Mid + 1)
     d. If Arr[Mid] > Target, search left half (High = Mid - 1)
  3. If not found, return -1
  
  Example: Find 25 in [11, 12, 22, 25, 34, 64, 90]
  
  Step 1: Low=0, High=6, Mid=3
          Arr[3]=25 = Target, found at index 3
  
  Example: Find 33 in [11, 12, 22, 25, 34, 64, 90]
  
  Step 1: Low=0, High=6, Mid=3
          Arr[3]=25 < 33, search right: Low=4
  
  Step 2: Low=4, High=6, Mid=5
          Arr[5]=64 > 33, search left: High=4
  
  Step 3: Low=4, High=4, Mid=4
          Arr[4]=34 > 33, search left: High=3
  
  Step 4: Low=4, High=3, Low > High, not found
}
function BinarySearchIterative(var Arr: TIntArray; Target: Integer): Integer;
var
  Lo, Hi, Mid: Integer;
begin
  Lo := 0;
  Hi := Length(Arr) - 1;
  
  while Lo <= Hi do
  begin
    // Avoid overflow: Mid = Lo + (Hi - Lo) / 2
    Mid := Lo + (Hi - Lo) div 2;
    
    if Arr[Mid] = Target then
    begin
      Result := Mid;  // Found!
      Exit;
    end
    else if Arr[Mid] < Target then
      Lo := Mid + 1  // Target in right half
    else
      Hi := Mid - 1;  // Target in left half
  end;
  
  Result := -1;  // Not found
end;

{
  Recursive Binary Search
  
  Same algorithm but using recursion.
  Base case: Low > High (not found) or Arr[Mid] = Target (found)
  Recursive case: Search appropriate half
}
function BinarySearchRecursive(var Arr: TIntArray; Target, Low, High: Integer): Integer;
var
  Mid: Integer;
begin
  // Base case: element not found
  if Low > High then
  begin
    Result := -1;
    Exit;
  end;
  
  Mid := Low + (High - Low) div 2;
  
  // Found target
  if Arr[Mid] = Target then
    Result := Mid
  // Search right half
  else if Arr[Mid] < Target then
    Result := BinarySearchRecursive(Arr, Target, Mid + 1, High)
  // Search left half
  else
    Result := BinarySearchRecursive(Arr, Target, Low, Mid - 1);
end;

{
  Find First Occurrence
  
  Modified binary search to find the first occurrence of a target
  when duplicates exist.
  
  Key modification: When target is found, continue searching left
  to find an earlier occurrence.
  
  Example: Find first 5 in [2, 5, 5, 5, 6, 7]
    Mid=2, Arr[2]=5, found but continue left
    Mid=1, Arr[1]=5, found but continue left
    Mid=0, Arr[0]=2, not found, return stored position (1)
}
function BinarySearchFirst(var Arr: TIntArray; Target, N: Integer): Integer;
var
  Low, High, Mid: Integer;
begin
  Result := -1;
  Low := 0;
  High := N - 1;
  
  while Low <= High do
  begin
    Mid := Low + (High - Low) div 2;
    
    if Arr[Mid] = Target then
    begin
      Result := Mid;   // Store result
      High := Mid - 1; // Continue searching left
    end
    else if Arr[Mid] < Target then
      Low := Mid + 1
    else
      High := Mid - 1;
  end;
end;

{
  Find Last Occurrence
  
  Modified binary search to find the last occurrence of a target
  when duplicates exist.
  
  Key modification: When target is found, continue searching right
  to find a later occurrence.
}
function BinarySearchLast(var Arr: TIntArray; Target, N: Integer): Integer;
var
  Low, High, Mid: Integer;
begin
  Result := -1;
  Low := 0;
  High := N - 1;
  
  while Low <= High do
  begin
    Mid := Low + (High - Low) div 2;
    
    if Arr[Mid] = Target then
    begin
      Result := Mid;   // Store result
      Low := Mid + 1;  // Continue searching right
    end
    else if Arr[Mid] < Target then
      Low := Mid + 1
    else
      High := Mid - 1;
  end;
end;

procedure DemoBinarySearch;
var
  Arr: TIntArray;
  ArrDup: TIntArray;
  i, Target, Index: Integer;
begin
  WriteLn('=== Binary Search Demonstration ===');
  WriteLn;
  
  // Initialize sorted array
  SetLength(Arr, 10);
  Arr[0] := 11; Arr[1] := 12; Arr[2] := 22; Arr[3] := 25; Arr[4] := 34;
  Arr[5] := 45; Arr[6] := 64; Arr[7] := 87; Arr[8] := 90; Arr[9] := 95;
  
  Write('Sorted array: ');
  for i := 0 to High(Arr) do
    Write(Arr[i]:4);
  WriteLn;
  WriteLn;
  
  // Test iterative search
  Target := 45;
  Index := BinarySearchIterative(Arr, Target);
  WriteLn('Iterative search for ', Target, ': index = ', Index);
  
  // Test recursive search
  Target := 87;
  Index := BinarySearchRecursive(Arr, Target, 0, High(Arr));
  WriteLn('Recursive search for ', Target, ': index = ', Index);
  
  // Test not found
  Target := 50;
  Index := BinarySearchIterative(Arr, Target);
  WriteLn('Search for ', Target, ' (not in array): index = ', Index);
  
  WriteLn;
  
  // Test with duplicates
  SetLength(ArrDup, 8);
  ArrDup[0] := 2; ArrDup[1] := 5; ArrDup[2] := 5; ArrDup[3] := 5;
  ArrDup[4] := 6; ArrDup[5] := 7; ArrDup[6] := 8; ArrDup[7] := 9;
  
  Write('Array with duplicates: ');
  for i := 0 to High(ArrDup) do
    Write(ArrDup[i]:4);
  WriteLn;
  
  Target := 5;
  WriteLn('First occurrence of ', Target, ': index = ', BinarySearchFirst(ArrDup, Target, Length(ArrDup)));
  WriteLn('Last occurrence of ', Target, ':  index = ', BinarySearchLast(ArrDup, Target, Length(ArrDup)));
  WriteLn;
end;

end.
