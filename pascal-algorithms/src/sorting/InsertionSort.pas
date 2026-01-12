{
  InsertionSort.pas
  
  Insertion Sort Implementation in Free Pascal
  
  Description:
    Insertion Sort builds the final sorted array one item at a time.
    It iterates through the input elements and grows a sorted output list.
    At each iteration, it removes one element and finds its correct position
    in the sorted portion.
  
  Time Complexity:
    - Best Case:    O(n) - when array is already sorted
    - Average Case: O(n²)
    - Worst Case:   O(n²) - when array is reverse sorted
  
  Space Complexity: O(1) - in-place sorting
  
  Advantages:
    - Simple implementation
    - Efficient for small datasets
    - Efficient for nearly sorted arrays
    - Stable sort
    - In-place (O(1) extra space)
    - Online (can sort as it receives input)
  
  Use Cases:
    - Small arrays
    - Nearly sorted arrays
    - When simplicity is preferred
    - Part of hybrid sorting algorithms (e.g., Timsort, Introsort)
  
  Author: Your Name
  Date: 2024
}

unit InsertionSort;

{$mode objfpc}{$H+}

interface

type
  TIntArray = array of Integer;

{ Standard Insertion Sort }
procedure InsertionSortArray(var Arr: TIntArray; N: Integer);

{ Binary Insertion Sort - uses binary search to find insertion position }
procedure BinaryInsertionSort(var Arr: TIntArray; N: Integer);

{ Binary search helper for insertion position }
function BinarySearchPosition(var Arr: TIntArray; Item, Low, High: Integer): Integer;

{ Demonstration procedure }
procedure DemoInsertionSort;

implementation

{
  Insertion Sort
  
  Algorithm (similar to sorting playing cards):
  1. Start from second element (first element is "sorted")
  2. Pick current element (key)
  3. Compare with elements in sorted portion (right to left)
  4. Shift elements greater than key one position right
  5. Insert key in correct position
  6. Repeat for all elements
  
  Visual Example:
  
  Array: [64, 34, 25, 12, 22]
  
  Step 1: key = 34
    Compare with 64: 64 > 34, shift 64 right
    Insert 34 at position 0
    Result: [34, 64, 25, 12, 22]
  
  Step 2: key = 25
    Compare with 64: 64 > 25, shift
    Compare with 34: 34 > 25, shift
    Insert 25 at position 0
    Result: [25, 34, 64, 12, 22]
  
  Step 3: key = 12
    All elements > 12, shift all
    Insert 12 at position 0
    Result: [12, 25, 34, 64, 22]
  
  Step 4: key = 22
    64 > 22, shift; 34 > 22, shift; 25 > 22, shift; 12 < 22, stop
    Insert 22 at position 1
    Result: [12, 22, 25, 34, 64]
}
procedure InsertionSortArray(var Arr: TIntArray; N: Integer);
var
  i, j: Integer;
  Key: Integer;
begin
  for i := 1 to N - 1 do
  begin
    Key := Arr[i];
    j := i - 1;
    
    // Move elements greater than key one position ahead
    while (j >= 0) and (Arr[j] > Key) do
    begin
      Arr[j + 1] := Arr[j];
      Dec(j);
    end;
    
    // Insert key at correct position
    Arr[j + 1] := Key;
  end;
end;

{
  Binary Search Position
  
  Finds the position where Item should be inserted to maintain sorted order.
  Returns index where Item should be placed.
}
function BinarySearchPosition(var Arr: TIntArray; Item, Low, High: Integer): Integer;
var
  Mid: Integer;
begin
  while Low <= High do
  begin
    Mid := Low + (High - Low) div 2;
    
    if Item = Arr[Mid] then
    begin
      Result := Mid + 1;
      Exit;
    end
    else if Item > Arr[Mid] then
      Low := Mid + 1
    else
      High := Mid - 1;
  end;
  
  Result := Low;
end;

{
  Binary Insertion Sort
  
  Optimization: Uses binary search to find insertion position.
  This reduces comparisons from O(n) to O(log n) per element.
  
  Note: Total time complexity remains O(n²) due to shifting,
  but it performs fewer comparisons, which can be beneficial
  when comparison is expensive.
}
procedure BinaryInsertionSort(var Arr: TIntArray; N: Integer);
var
  i, j, Pos: Integer;
  Key: Integer;
begin
  for i := 1 to N - 1 do
  begin
    Key := Arr[i];
    
    // Find position using binary search
    Pos := BinarySearchPosition(Arr, Key, 0, i - 1);
    
    // Shift all elements from Pos to i-1 one position right
    for j := i - 1 downto Pos do
      Arr[j + 1] := Arr[j];
    
    // Insert key at correct position
    Arr[Pos] := Key;
  end;
end;

procedure DemoInsertionSort;
var
  Arr1, Arr2: TIntArray;
  i: Integer;
begin
  WriteLn('=== Insertion Sort Demonstration ===');
  WriteLn;
  
  // Initialize arrays
  SetLength(Arr1, 10);
  SetLength(Arr2, 10);
  Arr1[0] := 64; Arr1[1] := 34; Arr1[2] := 25; Arr1[3] := 12; Arr1[4] := 22;
  Arr1[5] := 11; Arr1[6] := 90; Arr1[7] := 87; Arr1[8] := 45; Arr1[9] := 33;
  
  // Copy for second demo
  for i := 0 to High(Arr1) do
    Arr2[i] := Arr1[i];
  
  Write('Original array:      ');
  for i := 0 to High(Arr1) do
    Write(Arr1[i]:4);
  WriteLn;
  
  // Standard insertion sort
  InsertionSortArray(Arr1, Length(Arr1));
  Write('Standard insertion:  ');
  for i := 0 to High(Arr1) do
    Write(Arr1[i]:4);
  WriteLn;
  
  // Binary insertion sort
  BinaryInsertionSort(Arr2, Length(Arr2));
  Write('Binary insertion:    ');
  for i := 0 to High(Arr2) do
    Write(Arr2[i]:4);
  WriteLn;
  WriteLn;
end;

end.
