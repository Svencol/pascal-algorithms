{
  QuickSort.pas
  
  Quick Sort Implementation in Free Pascal
  
  Description:
    Quick Sort is a highly efficient, divide-and-conquer sorting algorithm.
    It works by selecting a 'pivot' element and partitioning the array around it,
    putting smaller elements before and larger elements after the pivot.
  
  Time Complexity:
    - Best Case:    O(n log n)
    - Average Case: O(n log n)
    - Worst Case:   O(n²) - when array is already sorted and pivot is first/last
  
  Space Complexity: O(log n) - for recursion stack
  
  Author: Your Name
  Date: 2024
}

unit QuickSort;

{$mode objfpc}{$H+}

interface

type
  TIntArray = array of Integer;

{ Main QuickSort procedure - sorts array in place }
procedure QuickSortArray(var Arr: TIntArray; Low, High: Integer);

{ Partition function - returns pivot index after partitioning }
function Partition(var Arr: TIntArray; Low, High: Integer): Integer;

{ Utility procedure to swap two elements }
procedure Swap(var A, B: Integer);

{ Demonstration procedure }
procedure DemoQuickSort;

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
  Partition using Lomuto partition scheme
  
  Algorithm:
  1. Choose the last element as pivot
  2. Maintain index i of smaller elements
  3. Traverse array, moving smaller elements to left side
  4. Place pivot in its correct position
  
  Example: [64, 34, 25, 12, 90] pivot=90
    - 64 < 90: swap with itself, i=1
    - 34 < 90: swap with itself, i=2
    - 25 < 90: swap with itself, i=3
    - 12 < 90: swap with itself, i=4
    - Place pivot at i=4 (already there)
}
function Partition(var Arr: TIntArray; Low, High: Integer): Integer;
var
  Pivot: Integer;
  i, j: Integer;
begin
  Pivot := Arr[High];  // Choose last element as pivot
  i := Low - 1;        // Index of smaller element
  
  for j := Low to High - 1 do
  begin
    // If current element is smaller than or equal to pivot
    if Arr[j] <= Pivot then
    begin
      Inc(i);
      Swap(Arr[i], Arr[j]);
    end;
  end;
  
  // Place pivot in correct position
  Swap(Arr[i + 1], Arr[High]);
  Result := i + 1;
end;

{
  Main QuickSort procedure
  
  Algorithm:
  1. If Low < High (more than one element)
  2. Partition the array and get pivot index
  3. Recursively sort left subarray (elements < pivot)
  4. Recursively sort right subarray (elements > pivot)
}
procedure QuickSortArray(var Arr: TIntArray; Low, High: Integer);
var
  PivotIndex: Integer;
begin
  if Low < High then
  begin
    // Partition array and get pivot position
    PivotIndex := Partition(Arr, Low, High);
    
    // Recursively sort elements before and after partition
    QuickSortArray(Arr, Low, PivotIndex - 1);
    QuickSortArray(Arr, PivotIndex + 1, High);
  end;
end;

procedure DemoQuickSort;
var
  Arr: TIntArray;
  i: Integer;
begin
  WriteLn('=== Quick Sort Demonstration ===');
  WriteLn;
  
  // Initialize array
  SetLength(Arr, 10);
  Arr[0] := 64; Arr[1] := 34; Arr[2] := 25; Arr[3] := 12; Arr[4] := 22;
  Arr[5] := 11; Arr[6] := 90; Arr[7] := 87; Arr[8] := 45; Arr[9] := 33;
  
  Write('Original array: ');
  for i := 0 to High(Arr) do
    Write(Arr[i]:4);
  WriteLn;
  
  // Sort the array
  QuickSortArray(Arr, 0, High(Arr));
  
  Write('Sorted array:   ');
  for i := 0 to High(Arr) do
    Write(Arr[i]:4);
  WriteLn;
  WriteLn;
end;

end.
