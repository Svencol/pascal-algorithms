{
  BubbleSort.pas
  
  Bubble Sort Implementation in Free Pascal
  
  Description:
    Bubble Sort repeatedly steps through the list, compares adjacent
    elements and swaps them if they are in the wrong order. The pass
    through the list is repeated until the list is sorted.
  
  Time Complexity:
    - Best Case:    O(n) - when array is already sorted (with optimization)
    - Average Case: O(n²)
    - Worst Case:   O(n²) - when array is reverse sorted
  
  Space Complexity: O(1) - in-place sorting
  
  Note:
    While not efficient for large datasets, Bubble Sort is simple to
    understand and implement, making it good for educational purposes.
  
  Author: Your Name
  Date: 2024
}

unit BubbleSort;

{$mode objfpc}{$H+}

interface

type
  TIntArray = array of Integer;

{ Basic Bubble Sort }
procedure BubbleSortBasic(var Arr: TIntArray; N: Integer);

{ Optimized Bubble Sort - stops if no swaps occur }
procedure BubbleSortOptimized(var Arr: TIntArray; N: Integer);

{ Utility procedure to swap two elements }
procedure Swap(var A, B: Integer);

{ Demonstration procedure }
procedure DemoBubbleSort;

implementation

procedure Swap(var A, B: Integer);
var
  Temp: Integer;
begin
  Temp := A;
  A := B;
  B := Temp;
end;

{
  Basic Bubble Sort
  
  Algorithm:
  1. Compare adjacent elements
  2. Swap if first > second
  3. Repeat for all elements
  4. After each pass, largest unsorted element "bubbles up" to its position
  
  Example pass through [64, 34, 25, 12, 22]:
    Compare 64 & 34: 64 > 34, swap -> [34, 64, 25, 12, 22]
    Compare 64 & 25: 64 > 25, swap -> [34, 25, 64, 12, 22]
    Compare 64 & 12: 64 > 12, swap -> [34, 25, 12, 64, 22]
    Compare 64 & 22: 64 > 22, swap -> [34, 25, 12, 22, 64]
    
  After first pass: 64 is in its final position
}
procedure BubbleSortBasic(var Arr: TIntArray; N: Integer);
var
  i, j: Integer;
begin
  for i := 0 to N - 2 do
  begin
    // Last i elements are already in place
    for j := 0 to N - 2 - i do
    begin
      if Arr[j] > Arr[j + 1] then
        Swap(Arr[j], Arr[j + 1]);
    end;
  end;
end;

{
  Optimized Bubble Sort
  
  Improvement: If no swaps occur during a pass, array is sorted.
  This allows early termination for nearly sorted arrays.
  
  Best case becomes O(n) when array is already sorted.
}
procedure BubbleSortOptimized(var Arr: TIntArray; N: Integer);
var
  i, j: Integer;
  Swapped: Boolean;
begin
  for i := 0 to N - 2 do
  begin
    Swapped := False;
    
    for j := 0 to N - 2 - i do
    begin
      if Arr[j] > Arr[j + 1] then
      begin
        Swap(Arr[j], Arr[j + 1]);
        Swapped := True;
      end;
    end;
    
    // If no swaps occurred, array is sorted
    if not Swapped then
      Break;
  end;
end;

procedure DemoBubbleSort;
var
  Arr1, Arr2: TIntArray;
  i: Integer;
begin
  WriteLn('=== Bubble Sort Demonstration ===');
  WriteLn;
  
  // Initialize arrays
  SetLength(Arr1, 10);
  SetLength(Arr2, 10);
  Arr1[0] := 64; Arr1[1] := 34; Arr1[2] := 25; Arr1[3] := 12; Arr1[4] := 22;
  Arr1[5] := 11; Arr1[6] := 90; Arr1[7] := 87; Arr1[8] := 45; Arr1[9] := 33;
  
  // Copy for second demo
  for i := 0 to High(Arr1) do
    Arr2[i] := Arr1[i];
  
  Write('Original array: ');
  for i := 0 to High(Arr1) do
    Write(Arr1[i]:4);
  WriteLn;
  
  // Basic sort
  BubbleSortBasic(Arr1, Length(Arr1));
  Write('Basic sort:     ');
  for i := 0 to High(Arr1) do
    Write(Arr1[i]:4);
  WriteLn;
  
  // Optimized sort
  BubbleSortOptimized(Arr2, Length(Arr2));
  Write('Optimized sort: ');
  for i := 0 to High(Arr2) do
    Write(Arr2[i]:4);
  WriteLn;
  WriteLn;
end;

end.
