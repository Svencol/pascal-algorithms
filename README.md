# Pascal Algorithms & Data Structures

A comprehensive collection of fundamental algorithms and data structures implemented in Free Pascal. This repository demonstrates clean code organization, efficient implementations, and proper documentation practices.

## 📁 Project Structure

```
pascal-algorithms/
├── src/
│   ├── sorting/           # Sorting algorithms
│   │   ├── BubbleSort.pas
│   │   ├── QuickSort.pas
│   │   ├── MergeSort.pas
│   │   ├── HeapSort.pas
│   │   └── InsertionSort.pas
│   ├── searching/         # Searching algorithms
│   │   ├── BinarySearch.pas
│   │   ├── LinearSearch.pas
│   │   └── InterpolationSearch.pas
│   ├── data_structures/   # Data structures
│   │   ├── LinkedList.pas
│   │   ├── Stack.pas
│   │   ├── Queue.pas
│   │   ├── BinaryTree.pas
│   │   ├── HashTable.pas
│   │   └── Heap.pas
│   ├── graphs/            # Graph algorithms
│   │   ├── GraphAdjList.pas
│   │   ├── BFS.pas
│   │   ├── DFS.pas
│   │   └── Dijkstra.pas
│   └── dynamic_programming/
│       ├── Fibonacci.pas
│       ├── Knapsack.pas
│       └── LCS.pas
├── tests/                 # Unit tests
├── examples/              # Usage examples
└── README.md
```

## 🚀 Features

### Sorting Algorithms
| Algorithm | Time Complexity (Best) | Time Complexity (Avg) | Time Complexity (Worst) | Space |
|-----------|----------------------|----------------------|------------------------|-------|
| Bubble Sort | O(n) | O(n²) | O(n²) | O(1) |
| Insertion Sort | O(n) | O(n²) | O(n²) | O(1) |
| Quick Sort | O(n log n) | O(n log n) | O(n²) | O(log n) |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) |
| Heap Sort | O(n log n) | O(n log n) | O(n log n) | O(1) |

### Searching Algorithms
| Algorithm | Time Complexity (Avg) | Time Complexity (Worst) | Requirement |
|-----------|----------------------|------------------------|-------------|
| Linear Search | O(n) | O(n) | None |
| Binary Search | O(log n) | O(log n) | Sorted array |
| Interpolation Search | O(log log n) | O(n) | Sorted, uniform distribution |

### Data Structures
- **Linked List**: Singly linked list with insert, delete, search operations
- **Stack**: LIFO structure with push, pop, peek
- **Queue**: FIFO structure with enqueue, dequeue
- **Binary Search Tree**: Insert, delete, search, traversals (inorder, preorder, postorder)
- **Hash Table**: Separate chaining collision resolution
- **Min/Max Heap**: Priority queue operations

### Graph Algorithms
- **BFS**: Breadth-First Search traversal
- **DFS**: Depth-First Search traversal
- **Dijkstra**: Shortest path algorithm

### Dynamic Programming
- **Fibonacci**: Memoized and tabulated solutions
- **0/1 Knapsack**: Classic optimization problem
- **LCS**: Longest Common Subsequence

## 🔧 Requirements

- Free Pascal Compiler (FPC) 3.0.0 or higher
- Any platform supported by FPC (Windows, Linux, macOS)

## 📦 Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/pascal-algorithms.git
cd pascal-algorithms

# Compile an example
fpc src/sorting/QuickSort.pas -o quicksort

# Run
./quicksort
```

## 💻 Usage Example

```pascal
program SortingDemo;

uses QuickSort;

var
  arr: array[0..9] of Integer = (64, 34, 25, 12, 22, 11, 90, 87, 45, 33);
  i: Integer;

begin
  WriteLn('Original array:');
  for i := 0 to 9 do
    Write(arr[i], ' ');
  WriteLn;
  
  QuickSortArray(arr, 0, 9);
  
  WriteLn('Sorted array:');
  for i := 0 to 9 do
    Write(arr[i], ' ');
  WriteLn;
end.
```

## 🧪 Running Tests

```bash
cd tests
fpc TestRunner.pas
./TestRunner
```

## 📊 Algorithm Visualizations

Each algorithm includes detailed comments explaining the step-by-step process. For visual learners, here's a brief overview of key algorithms:

### Quick Sort Partitioning
```
[64, 34, 25, 12, 22, 11, 90] pivot=64
         ↓
[34, 25, 12, 22, 11] [64] [90]
```

### Binary Search Tree
```
        50
       /  \
      30    70
     /  \   /  \
    20  40 60  80
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📚 References

- Introduction to Algorithms (CLRS)
- The Art of Computer Programming (Donald Knuth)
- Free Pascal Documentation

## 👤 Author

Sven Collins - [GitHub Profile](https://github.com/Svencol/)

---

