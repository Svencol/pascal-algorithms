{
  MergeSort.pas
  
  Merge Sort Implementation in Free Pascal
  
  Description:
    Merge Sort is a stable, divide-and-conquer sorting algorithm.
    It divides the array into two halves, recursively sorts them,
    and then merges the sorted halves.
  
  Time Complexity:
    - Best Case:    O(n log n)
    - Average Case: O(n log n)
    - Worst Case:   O(n log n)
  
  Space Complexity: O(n) - for temporary arrays during merge
  
  Key Features:
    - Stable sort (preserves relative order of equal elements)
    - Predictable performance (always O(n log n))
    - Well-suited for linked lists
    - Good for external sorting (large datasets)
  
  Author: Your Name
  Date: 2024
}

unit MergeSort;

{$mode objfpc}{$H+}

interface

type
  TIntArray = array of Integer;

{ Main MergeSort procedure }
procedure MergeSortArray(var Arr: TIntArray; Left, Right: Integer);

{ Merge two sorted subarrays }
procedure Merge(var Arr: TIntArray; Left, Mid, Right: Integer);

{ Demonstration procedure }
procedure DemoMergeSort;

implementation

{
  Merge Procedure
  
  Merges two sorted subarrays:
  - Left subarray:  Arr[Left..Mid]
  - Right subarray: Arr[Mid+1..Right]
  
  Algorithm:
  1. Create temporary arrays for both halves
  2. Copy data to temporary arrays
  3. Merge back by comparing elements from both arrays
  4. Copy remaining elements (if any)
  
  Example:
    Left:  [25, 34, 64]
    Right: [12, 22, 90]
    Merged: [12, 22, 25, 34, 64, 90]
}
procedure Merge(var Arr: TIntArray; Left, Mid, Right: Integer);
var
  LeftArr, RightArr: TIntArray;
  n1, n2: Integer;
  i, j, k: Integer;
begin
  // Calculate sizes of subarrays
  n1 := Mid - Left + 1;
  n2 := Right - Mid;
  
  // Create temporary arrays
  SetLength(LeftArr, n1);
  SetLength(RightArr, n2);
  
  // Copy data to temporary arrays
  for i := 0 to n1 - 1 do
    LeftArr[i] := Arr[Left + i];
  for j := 0 to n2 - 1 do
    RightArr[j] := Arr[Mid + 1 + j];
  
  // Merge the temporary arrays back into Arr[Left..Right]
  i := 0;  // Initial index of left subarray
  j := 0;  // Initial index of right subarray
  k := Left;  // Initial index of merged subarray
  
  while (i < n1) and (j < n2) do
  begin
    if LeftArr[i] <= RightArr[j] then
    begin
      Arr[k] := LeftArr[i];
      Inc(i);
    end
    else
    begin
      Arr[k] := RightArr[j];
      Inc(j);
    end;
    Inc(k);
  end;
  
  // Copy remaining elements of LeftArr (if any)
  while i < n1 do
  begin
    Arr[k] := LeftArr[i];
    Inc(i);
    Inc(k);
  end;
  
  // Copy remaining elements of RightArr (if any)
  while j < n2 do
  begin
    Arr[k] := RightArr[j];
    Inc(j);
    Inc(k);
  end;
end;

{
  MergeSort Procedure
  
  Algorithm:
  1. Find the middle point to divide the array
  2. Recursively sort first half
  3. Recursively sort second half
  4. Merge the two sorted halves
  
  Visual representation:
                [64, 34, 25, 12, 22, 90]
                         /          \
              [64, 34, 25]          [12, 22, 90]
               /        \            /         \
          [64, 34]     [25]      [12, 22]     [90]
           /    \                 /    \
         [64]  [34]            [12]   [22]
           \    /                \     /
          [34, 64]              [12, 22]
               \                  /
              [25, 34, 64]    [12, 22, 90]
                       \        /
               [12, 22, 25, 34, 64, 90]
}
procedure MergeSortArray(var Arr: TIntArray; Left, Right: Integer);
var
  Mid: Integer;
begin
  if Left < Right then
  begin
    // Find middle point
    Mid := Left + (Right - Left) div 2;
    
    // Sort first and second halves
    MergeSortArray(Arr, Left, Mid);
    MergeSortArray(Arr, Mid + 1, Right);
    
    // Merge the sorted halves
    Merge(Arr, Left, Mid, Right);
  end;
end;

procedure DemoMergeSort;
var
  Arr: TIntArray;
  i: Integer;
begin
  WriteLn('=== Merge Sort Demonstration ===');
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
  MergeSortArray(Arr, 0, High(Arr));
  
  Write('Sorted array:   ');
  for i := 0 to High(Arr) do
    Write(Arr[i]:4);
  WriteLn;
  WriteLn;
end;

end.
