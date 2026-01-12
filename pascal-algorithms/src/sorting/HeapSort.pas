{
  HeapSort.pas
  
  Heap Sort Implementation in Free Pascal
  
  Description:
    Heap Sort is a comparison-based sorting algorithm that uses a
    binary heap data structure. It's an in-place algorithm with
    guaranteed O(n log n) time complexity.
  
  Time Complexity:
    - Best Case:    O(n log n)
    - Average Case: O(n log n)
    - Worst Case:   O(n log n)
  
  Space Complexity: O(1) - in-place sorting
  
  Key Concepts:
    - Max Heap: Parent node is always >= children
    - Complete Binary Tree: All levels filled except possibly last
    - Heapify: Process to maintain heap property
  
  Array Representation of Heap:
    For element at index i:
    - Parent: (i - 1) / 2
    - Left child: 2*i + 1
    - Right child: 2*i + 2
  
  Author: Your Name
  Date: 2024
}

unit HeapSort;

{$mode objfpc}{$H+}

interface

type
  TIntArray = array of Integer;

{ Main HeapSort procedure }
procedure HeapSortArray(var Arr: TIntArray; N: Integer);

{ Heapify a subtree rooted at index i }
procedure Heapify(var Arr: TIntArray; N, i: Integer);

{ Utility procedure to swap two elements }
procedure Swap(var A, B: Integer);

{ Demonstration procedure }
procedure DemoHeapSort;

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
  Heapify Procedure
  
  Maintains the max heap property for a subtree rooted at index i.
  Assumes that subtrees rooted at left and right children are already heaps.
  
  Algorithm:
  1. Find the largest among root, left child, and right child
  2. If largest is not root, swap with root and heapify the affected subtree
  
  Example (heapify at index 0):
        4                    9
       / \       =>         / \
      9   5                4   5
  
  Visualization:
    Array: [4, 9, 5, ...]
    Tree:        4(0)
                / \
             9(1)  5(2)
    
    After heapify(0):
    Array: [9, 4, 5, ...]
    Tree:        9(0)
                / \
             4(1)  5(2)
}
procedure Heapify(var Arr: TIntArray; N, i: Integer);
var
  Largest: Integer;
  Left, Right: Integer;
begin
  Largest := i;        // Initialize largest as root
  Left := 2 * i + 1;   // Left child index
  Right := 2 * i + 2;  // Right child index
  
  // Check if left child exists and is greater than root
  if (Left < N) and (Arr[Left] > Arr[Largest]) then
    Largest := Left;
  
  // Check if right child exists and is greater than current largest
  if (Right < N) and (Arr[Right] > Arr[Largest]) then
    Largest := Right;
  
  // If largest is not root
  if Largest <> i then
  begin
    Swap(Arr[i], Arr[Largest]);
    
    // Recursively heapify the affected subtree
    Heapify(Arr, N, Largest);
  end;
end;

{
  HeapSort Procedure
  
  Algorithm:
  1. Build a max heap from the input array (bottom-up)
  2. Extract elements one by one from the heap:
     a. Swap root (max element) with last element
     b. Reduce heap size by 1
     c. Heapify the root to maintain heap property
  
  Visual Example:
  
  Initial: [4, 10, 3, 5, 1]
  
  Build Max Heap:
         4              10              10
        / \            / \             / \
      10   3    =>   5    3    =>    5    3
     /  \           / \             / \
    5    1        4    1           4    1
  
  Extract Max (swap with last, heapify):
  
  Step 1: Swap 10 & 1, heapify     [1,5,3,4 | 10]
          Result: [5,4,3,1 | 10]
  
  Step 2: Swap 5 & 1, heapify      [1,4,3 | 5,10]
          Result: [4,1,3 | 5,10]
  
  Continue until sorted...
  
  Final: [1, 3, 4, 5, 10]
}
procedure HeapSortArray(var Arr: TIntArray; N: Integer);
var
  i: Integer;
begin
  // Build max heap (rearrange array)
  // Start from last non-leaf node and heapify all nodes in reverse
  // Last non-leaf node is at index (N/2 - 1)
  for i := N div 2 - 1 downto 0 do
    Heapify(Arr, N, i);
  
  // One by one extract elements from heap
  for i := N - 1 downto 1 do
  begin
    // Move current root (maximum) to end
    Swap(Arr[0], Arr[i]);
    
    // Heapify the reduced heap
    Heapify(Arr, i, 0);
  end;
end;

procedure DemoHeapSort;
var
  Arr: TIntArray;
  i: Integer;
begin
  WriteLn('=== Heap Sort Demonstration ===');
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
  HeapSortArray(Arr, Length(Arr));
  
  Write('Sorted array:   ');
  for i := 0 to High(Arr) do
    Write(Arr[i]:4);
  WriteLn;
  WriteLn;
end;

end.
