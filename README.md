<!-- 2. **UART (Universal Asynchronous Receiver-Transmitter)** [UART Verilog(1) - EDA Playground](https://www.edaplayground.com/x/cj7A) [UART in VHDL and Verilog for an FPGA](https://nandland.com/uart-serial-port-module/) [GitHub - hell03end/verilog-uart: Simple 8-bit UART realization on Verilog HDL.](https://github.com/hell03end/verilog-uart) [GitHub - ben-marshall/uart: A simple implementation of a UART modem in Verilog.](https://github.com/ben-marshall/uart)
   - A fundamental communication protocol used in embedded systems.
3. **SPI (Serial Peripheral Interface)**
   - Another common communication protocol for interfacing with sensors and peripherals.
4. **I2C (Inter-Integrated Circuit)**
   - A widely used communication protocol for connecting low-speed peripherals.
5. **Ethernet MAC (Media Access Control)**
   - Implementing the MAC layer of Ethernet for network communications.
6. **VGA Controller**
   - For displaying graphics on a VGA monitor.
7. **DDR Memory Controller**
   - Interface with DDR memory modules, crucial for high-speed data storage.
8. **PCIe Interface**
   - For high-speed data transfer between the FPGA and other hardware.
9. **PWM (Pulse Width Modulation) Controller**
   - Used in motor control and power regulation applications.
10. **AES Encryption/Decryption Engine**
   - Implementing hardware-based encryption for secure communications.
11. **ADC/DAC Interface**
    - Interfacing with Analog-to-Digital and Digital-to-Analog converters.
12. **Digital Signal Processor (DSP)**
    - For real-time signal processing applications.
13. **JPEG Encoder/Decoder**
    - Image compression and decompression in hardware.
14. **FFT (Fast Fourier Transform) Processor**
    - For frequency domain analysis and signal processing.
15. **HDMI Transmitter/Receiver**
    - For high-definition multimedia interface applications.
16. **RISC-V Processor Core**
    - Implementing a RISC-V CPU core, a popular open-source architecture.
17. **CAN (Controller Area Network) Controller**
    - Used in automotive and industrial control systems.
18. **USB 2.0/3.0 Controller**
    - For universal serial bus communication.
19. **CPLD-based Logic Analyzer**
    - For capturing and analyzing digital signals.
20. **Smart Home Controller**
    - For controlling various smart home devices.
21. **Wireless Communication Module (e.g., Zigbee, Bluetooth)**
    - For implementing wireless communication protocols. -->

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
- [ ] SPI Master Transmitter and Receiver
    A SPI Master Transmitter and Receiver module that can be used to send and receive data between different devices.
- [ ] I2C Master Transmitter and Receiver
    A I2C Master Transmitter and Receiver module that can be used to send and receive data between different devices.
- [ ] Ethernet MAC
    A Ethernet MAC module that can be used to send and receive data between different devices.
- [ ] VGA Controller
    A VGA Controller module that can be used to display graphics on a VGA monitor.
- [ ] DDR Memory Controller
    A DDR Memory Controller module that can be used to interface with DDR memory modules.
- [ ] PCIe Interface
    A PCIe Interface module that can be used to interface with PCIe devices.
- [ ] PWM Controller
    A PWM Controller module that can be used to generate PWM signals.
- [ ] AES Encryption/Decryption Engine
    A AES Encryption/Decryption Engine module that can be used to encrypt and decrypt data.
- [ ] ADC/DAC Interface
    A ADC/DAC Interface module that can be used to interface with ADC and DAC devices.
- [ ] Digital Signal Processor (DSP)
    A Digital Signal Processor (DSP) module that can be used to perform DSP operations.
- [ ] JPEG Encoder/Decoder
    A JPEG Encoder/Decoder module that can be used to encode and decode JPEG images.
- [ ] FFT Processor
    A FFT Processor module that can be used to perform FFT operations.
- [ ] HDMI Transmitter/Receiver
    A HDMI Transmitter/Receiver module that can be used to send and receive HDMI signals.
- [ ] RISC-V Processor Core
    A RISC-V Processor Core module that can be used to implement a RISC-V CPU core.
- [ ] CAN Controller
    A CAN Controller module that can be used to implement a CAN controller.
- [ ] USB 2.0/3.0 Controller
    A USB 2.0/3.0 Controller module that can be used to implement a USB controller.
- [ ] CPLD-based Logic Analyzer
    A CPLD-based Logic Analyzer module that can be used to capture and analyze digital signals.
- [ ] Smart Home Controller
    A Smart Home Controller module that can be used to control various smart home devices.
- [ ] Wireless Communication Module (e.g., Zigbee, Bluetooth)
    A Wireless Communication Module module that can be used to implement wireless communication protocols.

## Larger Projects

- [ ] RISC-V Processor Core
    A RISC-V Processor Core module that can be used to implement a RISC-V CPU core.
- [ ] A Neural Network
    I haven't decided what kind of architecture I want to implement. I think I will start with a simple 2 layer NN and then move towards a more complex 3 or 4 layer NN.