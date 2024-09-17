# Odd-Even Transposition Sorter

This project implements an Odd-Even Transposition Sorter in Verilog. The sorting engine is designed to handle arrays of varying sizes and bit-widths. This project also includes an extensive testbench that verifies the functionality of the sorting engine across different test cases.

## Project Structure

```bash
.
├── Makefile               # Makefile for build automation, running simulations, and generating VCDs
├── build/                 # Directory for storing build output files
├── config/                # Directory for storing GTKWave configuration
├── dump/                  # Directory for storing simulation output, including VCD files
└── src/                   # Source files for the sorting engine and testbench
    ├── se.v               # Sorting engine module
    └── top_module.v       # Testbench for sorting engine
```

### `se.v` (Sorting Engine Module)
This Verilog file defines the core **Sorting Engine** (`SE`) module that performs sorting using the Odd-Even Transposition Sorting algorithm. The module is parameterized by:
- **DATAWIDTH**: Bit-width of each element in the array.
- **ARRAYLENGTH**: The number of elements in the array.

Key features:
- **Conditional Assignment (`CAS`)** macro used to swap values if needed.
- Sorting happens in `n/2 + 1` cycles, where `n` is the number of elements in the array.
- Uses generate blocks for flexible implementation based on the array length.

### `top_module.v` (Testbench)
This file contains a testbench for verifying the Sorting Engine across multiple test cases. The testbench checks sorting for arrays with varying bit-widths and lengths and validates the output against expected results.

Test cases included:
1. 8-bit, 8-element array.
2. 2-bit, 3-element array.
3. 16-bit, 4-element array.
4. 4-bit, 10-element array.
5. 32-bit, 5-element array.
6. ...and more (22 test cases in total).

Each test case logs the input, expected, and actual results, while maintaining a score for passed tests.

## Makefile Commands

The `Makefile` simplifies the process of compiling and running simulations. It also automates VCD generation for viewing the waveform in **GTKWave**.

### Available Targets:

- **`make`** / **`make all`**: Runs the entire simulation, generates VCD, and opens **GTKWave**.
- **`make run`**: Compiles and simulates the testbench.
- **`make gtkwave`**: Opens the waveform (`.vcd` file) in **GTKWave**.
- **`make clean`**: Cleans up the build and dump directories.

### How It Works:

1. The Makefile injects `$dumpfile` and `$dumpvars` statements into the testbench (`top_module.v`) to generate a VCD file for waveform analysis.
2. The simulation is compiled using **Icarus Verilog** (`iverilog`) and run using `vvp`.
3. After the simulation, you can view the results in **GTKWave**.

## Running the Project

1. **Run the Simulation**:
   ```bash
   make
   ```
   This will run the testbench, simulate the sorting engine, and open **GTKWave** to view the waveform.

2. **Cleaning Up**:
   To clean the build output and logs:
   ```bash
   make clean
   ```

## Results

The testbench validates the functionality of the sorting engine using 22 different test cases. The results for each test case are displayed in the terminal, showing the inputs, expected outputs, and actual outputs. The testbench calculates the total score based on the number of passed test cases.

## Dependencies

- **Icarus Verilog** for simulation: [Icarus Verilog](https://iverilog.fandom.com/wiki/Main_Page)
- **GTKWave** for waveform analysis: [GTKWave](http://gtkwave.sourceforge.net/)