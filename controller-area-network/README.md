# Controller Area Network Implementation
![[attachments/CAN.png]](attachments/CAN.png)
### CAN Bus Overview:

CAN (Controller Area Network) is widely used in automotive systems, especially in electric vehicles (EVs) for communication between Electronic Control Units (ECUs). CAN is considered a physical layer protocol (L2) and is very reliable and fault tolerant. It was initially developed by Robert Bosch GmbH and is now standardized as ISO 11898.

CAN can have up to **70 nodes**; a lot of them have to talk to the ECU.

### Analog Networks: Architecturally Complex & Costly
### 1989: Controllers Area Network: Communicate via multiplexed wires

**CAN (i): Low Cost:**
- Each node can connect to a single bus.
- Easier wiring/upscaling.

**(ii) Efficient:**
- Protocol is message-based.
- Energy nodes can send and receive messages.
- Node can distinguish between different types of messages (so latency is low).

**Note:**
- Only one message can be sent at a time (round-robin access method).
- Arbitration for writing CAN frames can unlock access quickly.
- Higher priority messages can take precedence.
- Lower-priority messages wait in line but clear up after.

**(iii) Reliable:**
- Fair error detection methods.

**(iv) Robust:**
- Its high-speed data lines are resistant to electrical distortion.
- Some CAN controllers (in nodes) come with extended temperature ranges to operate further without worrying about adverse environmental effects.

**(v) Flexible:**
- As it is a message-based protocol, nodes have no knowledge beforehand of required data (despite hardware). So new functionalities can be added/removed without hardware/software modification.

**Currently, it’s the de-facto communication interface:**
- A word that will show up in every big description in EV engineering.
- Originally invented by Robert Bosch GmBH, now it is ISO 11898.
- Can be considered a physical layer OSI 2 or Data Link Layer protocol.

- It is very reliable and fault tolerant.
- Used between ECUs; ECU is an electronic control unit, a device attached to all major components (ECU with brakes, windows, wipers).

### CAN Bus:
- A no-single-master or multi-master device.

- The bus is actually a differential pair of wires (not like recovered Ethernet ones; they’re twisted to prevent crosstalk).

- All nodes in CAN bus connect in parallel due to the twisting of the wires.
  - They’re “really near” each other, and since the CAN signal is a differential signal between two wires, it means that if there’s an electronic device or an electronic component near the twisted wires, it will not have the same electrical interference with the wires, which will have no effect on the signal as the differential value still remains the same.

### CAN Message Arbitration:

1. **Arbitration**: Each CAN node has a unique arbitration ID. If two nodes attempt to send a message at the same time, the bus allows only the message with the higher-priority (lower arbitration ID) to proceed.
   - The node with a higher priority will complete transmission, and the node with a lower priority must wait to transmit. This avoids collisions on the bus.
   
2. **Node IDs**: Each node has its own unique ID, which is prioritized based on binary arbitration:
   - **Example Node Setup**:
     - Node 1 ID: `01100011`
     - Node 2 ID: `01100010`
     - CAN Data: `01100100`

   - The arbitration process ensures that the node with the higher ID (Node 1 in this case) transmits successfully.

### CAN Bus Nodes and Architecture:

1. **Flexibility**: Nodes do not need preconfigured information regarding other devices on the bus. New nodes can be added, removed, or updated without any special hardware or software modification.
   - Nodes operate in real-time, processing incoming and outgoing messages efficiently.
   
2. **Networking**: CAN connects ECUs and other components across the vehicle. It governs all communication among critical and non-critical systems, such as engine controls, brakes, power windows, etc.

3. **Fault Tolerance**: CAN is designed to handle failures robustly. If a node fails, the bus is still operable. The bus detects errors and isolates faulty nodes to prevent the entire system from crashing.

4. **ECU (Electronic Control Unit) Integration**: The CAN bus connects to various ECUs in the vehicle. Each ECU controls a different subsystem, such as the engine, transmission, or power windows. The CAN bus allows all these ECUs to communicate with each other efficiently.

### CAN Bus Layers:

1. **Physical Layer**: This layer handles electrical signal transmission. It is based on twisted-pair cables with a differential signaling system.
   
2. **Data Link Layer**: CAN operates on the data link layer, ensuring error-free transmission and reliable data transfer between ECUs.
   
### Electrical Considerations:

1. **High-Speed and Robustness**: CAN operates at high speeds and is resilient to electrical disturbances. Electrical interference is reduced due to the differential signaling system, which cancels out common noise.
   
2. **Electromagnetic Compatibility (EMC)**: As a noise-tolerant network, CAN ensures that interference from other electronic components, such as radios and GPS systems, does not disrupt communication.


#### All CAN Nodes Have IDs:
1. Node 1
2. Node 2 (as example)
3. CAN Bus

**Each ID Bit:**
- Each ID has a short bit field:
  
  Node 1: `0 0 0 1 1 1 1`  
  Node 2: `0 0 1 1 1 0 0 0 1`  
  CAN Data: `0 0 0 1 1 0 0 1`

- Two nodes are trying to talk. First, they look at ID bit (1 at 6th bit):
  - The node which has a "0" keeps talking, while the node with "1" stops.
  - Similarly, it checks the next bit, and since Node 1 has `0`, it keeps transmitting on CAN bus.

#### Reference Diagram:

1. Nodes N1 and N2 transmit data:
   - Node 1 transmits: `1`
   - Node 2 transmits: `0`
   - Check Node 2 at arbitration priority.

### Differential Signaling:

- Represented by a signal comparison between CAN High (3.5V) and CAN Low (1.5V):
  - Dominant state difference (yellow region) - `+2V`
  - Recessive state difference (red region) - `0V`

- The dominant signal is transmitted when there's a higher voltage difference between CAN High and CAN Low, ensuring the message is sent.
- Recessive signals will not override dominant signals during arbitration.

### CAN Bus Diagram Explanation:

1. **Differential Signaling**: The graph included in the notes shows the voltage levels of the CAN bus. It compares CAN High and CAN Low voltages in both dominant (1) and recessive (0) states. The difference in voltages is the key to its noise immunity:
   - Dominant (1): CAN_H is at 3.4V, CAN_L at 1.6V.
   - Recessive (0): CAN_H is at 2.5V, CAN_L is also at 2.5V.

2. **Example Nodes (N1, N2, etc.)**: The illustration shows how bits are arbitrated between nodes with different IDs. Node 1 is represented with the highest-priority ID, while Node 2 and other nodes are represented with lower-priority IDs.

### General Notes:
1. **Connection & Termination**:
   - Termination resistors (120 ohms) are required at the end of the CAN bus to prevent signal reflection and ensure reliable communication.
   - The bus can detect missing or faulty nodes and adjust to maintain the rest of the system operational.
2. **Do not confuse differential encoding with differential signaling.**
3. The wires end with **120 ohm resistors** at each end (termination resistors).
4. At each CAN node, the cables do not terminate.
