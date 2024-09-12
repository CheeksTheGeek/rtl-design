# Verilogging : Logging my regular Verilog projects

Verilogging is a small endeavour to practice creating meaningful real-world projects in Verilog, to make sure I don't lose the fun of it and to keep my skills sharp. 
I will be creating a few projects in Verilog and will be documenting them here. I will be using Icarus Verilog for simulation and GTKWave for waveform viewing.

## Planned Projects

- [x] Odd Even Transposition Sorting Network/Engine (Scalable) 
    This sorting engine aims to structurally parallelize a bubble sort-like algorithm to sort a list of numbers. The engine's external size parameters, like ARRAYLENGTH and DATAWIDTH are parameterized and the internal sizing gets calculated based on these parameters. The engine will be scalable and will be able to sort any list of numbers with any length and width less than 255.
    The project's black-box idea was designed (as a deliverable for UWaterloo's ECE327: Digital Hardware Engineering Course) by William D. Bishop.
- [x] Memory System Tester
    Given a registered memory system of 256 Bytes, it tests every single bit of the system by reading and writing 1s and 0s in a pipelined fashion.
    The project's black-box idea was designed (as a deliverable for UWaterloo's ECE327: Digital Hardware Engineering Course) by William D. Bishop.
- [x] Pattern Detector
- [x] Hamming Code Encoder and Decoder
- [ ] UART Transmitter and Receiver
    A UART Transmitter and Receiver module that can be used to send and receive data between different devices.    
- [ ] 
