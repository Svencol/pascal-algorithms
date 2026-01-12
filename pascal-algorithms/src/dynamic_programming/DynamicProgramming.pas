{
  DynamicProgramming.pas
  
  Dynamic Programming Examples in Free Pascal
  
  Description:
    Dynamic Programming (DP) is an optimization technique that solves
    complex problems by breaking them into simpler subproblems.
  
  Key Concepts:
    1. Optimal Substructure: Optimal solution contains optimal solutions
       to its subproblems
    2. Overlapping Subproblems: Same subproblems are solved multiple times
  
  Approaches:
    - Top-Down (Memoization): Start from main problem, cache results
    - Bottom-Up (Tabulation): Build solution from smallest subproblems
  
  Author: Your Name
  Date: 2024
}

unit DynamicProgramming;

{$mode objfpc}{$H+}

interface

const
  MAX_SIZE = 1000;

type
  TIntArray = array of Integer;

{ Fibonacci Sequence }
function FibRecursive(N: Integer): Int64;
function FibMemoized(N: Integer): Int64;
function FibTabulated(N: Integer): Int64;
function FibOptimized(N: Integer): Int64;

{ 0/1 Knapsack Problem }
function KnapsackRecursive(Weights, Values: TIntArray; N, Capacity: Integer): Integer;
function KnapsackDP(Weights, Values: TIntArray; N, Capacity: Integer): Integer;

{ Longest Common Subsequence }
function LCSRecursive(const S1, S2: string; M, N: Integer): Integer;
function LCSDP(const S1, S2: string): Integer;

{ Demonstration procedures }
procedure DemoFibonacci;
procedure DemoKnapsack;
procedure DemoLCS;

implementation

{ ===== FIBONACCI SEQUENCE ===== }

{
  Fibonacci - Recursive (Naive)
  
  F(n) = F(n-1) + F(n-2), F(0) = 0, F(1) = 1
  
  Time: O(2^n) - exponential, very slow!
  Space: O(n) - recursion stack
  
  Problem: Recalculates same values multiple times
  
  Call tree for F(5):
                    F(5)
                   /    \
                F(4)    F(3)
               /   \    /   \
            F(3)  F(2) F(2) F(1)
           /   \
        F(2)  F(1)
}
function FibRecursive(N: Integer): Int64;
begin
  if N <= 1 then
    Result := N
  else
    Result := FibRecursive(N - 1) + FibRecursive(N - 2);
end;

{
  Fibonacci - Memoized (Top-Down DP)
  
  Cache results to avoid recalculation.
  
  Time: O(n)
  Space: O(n)
}
var
  FibMemo: array[0..MAX_SIZE] of Int64;
  FibMemoInit: Boolean = False;

function FibMemoizedHelper(N: Integer): Int64;
begin
  if N <= 1 then
  begin
    Result := N;
    Exit;
  end;
  
  if FibMemo[N] <> -1 then
  begin
    Result := FibMemo[N];
    Exit;
  end;
  
  FibMemo[N] := FibMemoizedHelper(N - 1) + FibMemoizedHelper(N - 2);
  Result := FibMemo[N];
end;

function FibMemoized(N: Integer): Int64;
var
  i: Integer;
begin
  if not FibMemoInit then
  begin
    for i := 0 to MAX_SIZE do
      FibMemo[i] := -1;
    FibMemoInit := True;
  end;
  Result := FibMemoizedHelper(N);
end;

{
  Fibonacci - Tabulated (Bottom-Up DP)
  
  Build solution iteratively from base cases.
  
  Time: O(n)
  Space: O(n)
  
  Table:
  i:      0  1  2  3  4  5  6  7  8  9  10
  F(i):   0  1  1  2  3  5  8  13 21 34 55
}
function FibTabulated(N: Integer): Int64;
var
  Table: array of Int64;
  i: Integer;
begin
  if N <= 1 then
  begin
    Result := N;
    Exit;
  end;
  
  SetLength(Table, N + 1);
  Table[0] := 0;
  Table[1] := 1;
  
  for i := 2 to N do
    Table[i] := Table[i - 1] + Table[i - 2];
  
  Result := Table[N];
end;

{
  Fibonacci - Space Optimized
  
  Only need last two values!
  
  Time: O(n)
  Space: O(1)
}
function FibOptimized(N: Integer): Int64;
var
  Prev2, Prev1, Current: Int64;
  i: Integer;
begin
  if N <= 1 then
  begin
    Result := N;
    Exit;
  end;
  
  Prev2 := 0;  // F(0)
  Prev1 := 1;  // F(1)
  
  for i := 2 to N do
  begin
    Current := Prev1 + Prev2;
    Prev2 := Prev1;
    Prev1 := Current;
  end;
  
  Result := Prev1;
end;

{ ===== 0/1 KNAPSACK PROBLEM ===== }

{
  0/1 Knapsack - Recursive
  
  Given weights and values of N items, find maximum value
  that can be put in a knapsack of capacity W.
  Each item can be included or excluded (0/1).
  
  Time: O(2^n)
  Space: O(n)
}
function KnapsackRecursive(Weights, Values: TIntArray; N, Capacity: Integer): Integer;
var
  Include, Exclude: Integer;
begin
  // Base case: no items or no capacity
  if (N = 0) or (Capacity = 0) then
  begin
    Result := 0;
    Exit;
  end;
  
  // If weight of item exceeds capacity, skip it
  if Weights[N - 1] > Capacity then
  begin
    Result := KnapsackRecursive(Weights, Values, N - 1, Capacity);
    Exit;
  end;
  
  // Return max of including or excluding current item
  Include := Values[N - 1] + KnapsackRecursive(Weights, Values, N - 1, Capacity - Weights[N - 1]);
  Exclude := KnapsackRecursive(Weights, Values, N - 1, Capacity);
  
  if Include > Exclude then
    Result := Include
  else
    Result := Exclude;
end;

{
  0/1 Knapsack - Dynamic Programming
  
  Build 2D table where DP[i][w] = max value using first i items
  with capacity w.
  
  Time: O(N * W)
  Space: O(N * W)
  
  Recurrence:
    If weights[i-1] > w:
      DP[i][w] = DP[i-1][w]  (can't include item)
    Else:
      DP[i][w] = max(DP[i-1][w], values[i-1] + DP[i-1][w-weights[i-1]])
  
  Example: weights=[1,2,3], values=[6,10,12], capacity=5
  
        0   1   2   3   4   5  (capacity)
    0 [ 0   0   0   0   0   0 ]
    1 [ 0   6   6   6   6   6 ]
    2 [ 0   6  10  16  16  16 ]
    3 [ 0   6  10  16  18  22 ]
    
  Answer: 22 (items with weights 2 and 3)
}
function KnapsackDP(Weights, Values: TIntArray; N, Capacity: Integer): Integer;
var
  DP: array of array of Integer;
  i, w: Integer;
  Include, Exclude: Integer;
begin
  // Create DP table
  SetLength(DP, N + 1, Capacity + 1);
  
  // Initialize first row and column to 0
  for i := 0 to N do
    DP[i][0] := 0;
  for w := 0 to Capacity do
    DP[0][w] := 0;
  
  // Fill the table
  for i := 1 to N do
  begin
    for w := 1 to Capacity do
    begin
      if Weights[i - 1] > w then
        DP[i][w] := DP[i - 1][w]  // Can't include
      else
      begin
        Exclude := DP[i - 1][w];
        Include := Values[i - 1] + DP[i - 1][w - Weights[i - 1]];
        
        if Include > Exclude then
          DP[i][w] := Include
        else
          DP[i][w] := Exclude;
      end;
    end;
  end;
  
  Result := DP[N][Capacity];
end;

{ ===== LONGEST COMMON SUBSEQUENCE ===== }

{
  LCS - Recursive
  
  Find length of longest subsequence present in both strings.
  A subsequence is a sequence that appears in the same relative order
  but not necessarily contiguous.
  
  Example: LCS("ABCDGH", "AEDFHR") = "ADH" (length 3)
  
  Time: O(2^(m+n))
  Space: O(m+n)
}
function LCSRecursive(const S1, S2: string; M, N: Integer): Integer;
var
  Case1, Case2: Integer;
begin
  // Base case: empty string
  if (M = 0) or (N = 0) then
  begin
    Result := 0;
    Exit;
  end;
  
  // If last characters match, include in LCS
  if S1[M] = S2[N] then
  begin
    Result := 1 + LCSRecursive(S1, S2, M - 1, N - 1);
    Exit;
  end;
  
  // If not, find max by excluding one character at a time
  Case1 := LCSRecursive(S1, S2, M - 1, N);
  Case2 := LCSRecursive(S1, S2, M, N - 1);
  
  if Case1 > Case2 then
    Result := Case1
  else
    Result := Case2;
end;

{
  LCS - Dynamic Programming
  
  Build table where DP[i][j] = LCS of S1[1..i] and S2[1..j]
  
  Time: O(m * n)
  Space: O(m * n)
  
  Recurrence:
    If S1[i] = S2[j]:
      DP[i][j] = 1 + DP[i-1][j-1]
    Else:
      DP[i][j] = max(DP[i-1][j], DP[i][j-1])
  
  Example: S1="ABCDE", S2="ACE"
  
        ""  A  C  E
    "" [ 0  0  0  0 ]
    A  [ 0  1  1  1 ]
    B  [ 0  1  1  1 ]
    C  [ 0  1  2  2 ]
    D  [ 0  1  2  2 ]
    E  [ 0  1  2  3 ]
    
  LCS = "ACE" (length 3)
}
function LCSDP(const S1, S2: string): Integer;
var
  M, N: Integer;
  DP: array of array of Integer;
  i, j: Integer;
begin
  M := Length(S1);
  N := Length(S2);
  
  SetLength(DP, M + 1, N + 1);
  
  // Initialize first row and column
  for i := 0 to M do
    DP[i][0] := 0;
  for j := 0 to N do
    DP[0][j] := 0;
  
  // Fill the table
  for i := 1 to M do
  begin
    for j := 1 to N do
    begin
      if S1[i] = S2[j] then
        DP[i][j] := 1 + DP[i - 1][j - 1]
      else
      begin
        if DP[i - 1][j] > DP[i][j - 1] then
          DP[i][j] := DP[i - 1][j]
        else
          DP[i][j] := DP[i][j - 1];
      end;
    end;
  end;
  
  Result := DP[M][N];
end;

{ ===== DEMONSTRATION PROCEDURES ===== }

procedure DemoFibonacci;
var
  N: Integer;
begin
  WriteLn('=== Fibonacci Sequence ===');
  WriteLn;
  
  N := 10;
  WriteLn('Computing Fibonacci(', N, '):');
  WriteLn('  Recursive:      ', FibRecursive(N));
  WriteLn('  Memoized:       ', FibMemoized(N));
  WriteLn('  Tabulated:      ', FibTabulated(N));
  WriteLn('  Space Optimized:', FibOptimized(N));
  
  WriteLn;
  WriteLn('Fibonacci sequence (0-15):');
  Write('  ');
  for N := 0 to 15 do
    Write(FibOptimized(N), ' ');
  WriteLn;
  WriteLn;
end;

procedure DemoKnapsack;
var
  Weights, Values: TIntArray;
  Capacity: Integer;
begin
  WriteLn('=== 0/1 Knapsack Problem ===');
  WriteLn;
  
  SetLength(Weights, 4);
  SetLength(Values, 4);
  
  Weights[0] := 2; Values[0] := 12;
  Weights[1] := 1; Values[1] := 10;
  Weights[2] := 3; Values[2] := 20;
  Weights[3] := 2; Values[3] := 15;
  
  Capacity := 5;
  
  WriteLn('Items:');
  WriteLn('  Item 1: weight=2, value=12');
  WriteLn('  Item 2: weight=1, value=10');
  WriteLn('  Item 3: weight=3, value=20');
  WriteLn('  Item 4: weight=2, value=15');
  WriteLn('Knapsack capacity: ', Capacity);
  WriteLn;
  
  WriteLn('Maximum value (DP): ', KnapsackDP(Weights, Values, 4, Capacity));
  WriteLn;
end;

procedure DemoLCS;
var
  S1, S2: string;
begin
  WriteLn('=== Longest Common Subsequence ===');
  WriteLn;
  
  S1 := 'AGGTAB';
  S2 := 'GXTXAYB';
  
  WriteLn('String 1: ', S1);
  WriteLn('String 2: ', S2);
  WriteLn;
  WriteLn('LCS Length (DP): ', LCSDP(S1, S2));
  WriteLn('(LCS is "GTAB")');
  
  WriteLn;
  
  S1 := 'ABCDGH';
  S2 := 'AEDFHR';
  
  WriteLn('String 1: ', S1);
  WriteLn('String 2: ', S2);
  WriteLn('LCS Length (DP): ', LCSDP(S1, S2));
  WriteLn('(LCS is "ADH")');
  
  WriteLn;
end;

end.
