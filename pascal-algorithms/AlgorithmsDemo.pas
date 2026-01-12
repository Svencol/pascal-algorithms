{
  AlgorithmsDemo.pas
  
  Main Demonstration Program
  
  This program demonstrates all implemented algorithms and data structures.
  Compile and run to see examples of each implementation.
  
  Compilation:
    fpc AlgorithmsDemo.pas
    ./AlgorithmsDemo
  
  Author: Your Name
  Date: 2024
}

program AlgorithmsDemo;

{$mode objfpc}{$H+}

uses
  SysUtils,
  QuickSort,
  MergeSort,
  HeapSort,
  BubbleSort,
  InsertionSort,
  BinarySearch,
  LinkedList,
  Stack,
  BinaryTree,
  GraphAdjList,
  DynamicProgramming;

procedure PrintSeparator;
begin
  WriteLn;
  WriteLn('================================================');
  WriteLn;
end;

begin
  WriteLn('**************************************************');
  WriteLn('*   ALGORITHMS AND DATA STRUCTURES IN PASCAL    *');
  WriteLn('*          Comprehensive Demonstration          *');
  WriteLn('**************************************************');
  
  PrintSeparator;
  WriteLn('            SORTING ALGORITHMS');
  PrintSeparator;
  
  DemoQuickSort;
  DemoMergeSort;
  DemoHeapSort;
  DemoBubbleSort;
  DemoInsertionSort;
  
  PrintSeparator;
  WriteLn('           SEARCHING ALGORITHMS');
  PrintSeparator;
  
  DemoBinarySearch;
  
  PrintSeparator;
  WriteLn('             DATA STRUCTURES');
  PrintSeparator;
  
  DemoLinkedList;
  DemoArrayStack;
  DemoLinkedStack;
  DemoBalancedParentheses;
  DemoBinaryTree;
  
  PrintSeparator;
  WriteLn('            GRAPH ALGORITHMS');
  PrintSeparator;
  
  DemoGraph;
  
  PrintSeparator;
  WriteLn('          DYNAMIC PROGRAMMING');
  PrintSeparator;
  
  DemoFibonacci;
  DemoKnapsack;
  DemoLCS;
  
  PrintSeparator;
  WriteLn('            END OF DEMONSTRATION');
  WriteLn;
  WriteLn('Press Enter to exit...');
  ReadLn;
end.
