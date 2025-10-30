# Asynchronous-FIFO-Verilog-Project
Verilog Code for Asynchronous FIFO 



This project implements an **Asynchronous FIFO (First-In First-Out)** memory buffer in **Verilog HDL**, designed for data transfer between two **independent clock domains** — typically used in high-speed digital systems to prevent metastability and data loss.

The FIFO uses **Gray code pointers** and **double-flop synchronization** to safely pass write and read pointers across different clock domains.



##  Module Description

### `asyn_fifo.v`

The main module implementing the asynchronous FIFO.

#### **Ports**

| Signal     | Direction | Width      | Description              |
| ---------- | --------- | ---------- | ------------------------ |
| `DATA_IN`  | Input     | DATA_WIDTH | Input data to be written |
| `DATA_OUT` | Output    | DATA_WIDTH | Data read from FIFO      |
| `W_EN`     | Input     | 1          | Write enable signal      |
| `R_EN`     | Input     | 1          | Read enable signal       |
| `W_CLK`    | Input     | 1          | Write clock              |
| `R_CLK`    | Input     | 1          | Read clock               |
| `RST`      | Input     | 1          | Active-high reset        |
| `FULL`     | Output    | 1          | Indicates FIFO is full   |
| `EMPTY`    | Output    | 1          | Indicates FIFO is empty  |

#### **Parameters**

| Parameter    | Default | Description                        |
| ------------ | ------- | ---------------------------------- |
| `DATA_WIDTH` | 4       | Width of data (bits)               |
| `FIFO_DEPTH` | 8       | Total number of memory locations   |
| `ADDR_SIZE`  | 4       | Address width (log₂ of FIFO depth) |

---

##  Internal Working

1. **Write Path**

   * Data is written into memory on the rising edge of `W_CLK` when `W_EN` is high and FIFO is not full.
   * Write pointer (`Wb_PTR`) increments and is converted to **Gray code (`Wg_PTR`)**.

2. **Read Path**

   * Data is read on the rising edge of `R_CLK` when `R_EN` is high and FIFO is not empty.
   * Read pointer (`Rb_PTR`) increments and is converted to **Gray code (`Rg_PTR`)**.

3. **Pointer Synchronization**

   * `Rg_PTR` is synchronized into the write domain (for FULL detection).
   * `Wg_PTR` is synchronized into the read domain (for EMPTY detection).

4. **Flag Logic**

   * **EMPTY** = Both pointers are equal.
   * **FULL** = Write pointer equals the inverted upper bits of the read pointer (classic async FIFO logic).

---

## Testbench: `asyn_fifo_tb.v`

The testbench verifies FIFO behavior under asynchronous conditions.

###  Key Features:

* Independent **write** (100 MHz) and **read** (~71 MHz) clocks.
* Automatic **reset, write, and read sequences**.
* Displays FIFO activity (`FULL`, `EMPTY`, `DATA_IN`, `DATA_OUT`) at runtime.
* Tests overflow and underflow prevention.



## How to Run

### In Vivado 

1. Create a new Verilog project.
2. Add files:

   * `asyn_fifo.v`
   * `asyn_fifo_tb.v`
3. Set `asyn_fifo_tb` as the **top module**.
4. Run **behavioral simulation**.
5. Observe waveforms:

   * `DATA_IN`, `DATA_OUT`
   * `W_CLK`, `R_CLK`
   * `FULL`, `EMPTY`
   * Pointer transitions (`Wb_PTR`, `Rb_PTR`)

---

## 📊 Recommended Waveform Signals

To verify proper asynchronous operation:

* `W_CLK`, `R_CLK`
* `W_EN`, `R_EN`
* `DATA_IN`, `DATA_OUT`
* `FULL`, `EMPTY`
* `Wb_PTR`, `Rb_PTR`
* `Wg_PTR_S2`, `Rg_PTR_S2`

---

## 🧠 Learning Outcome

By studying and simulating this project, you will understand:

* How **asynchronous FIFOs** safely transfer data between different clock domains.
* How **Gray code** minimizes metastability.
* How **synchronization flip-flops** ensure reliable communication.
* Proper **FULL/EMPTY** detection logic in hardware design.

---

## 📁 File Structure

```
📦 Asynchronous_FIFO_Project
 ┣ 📜 asyn_fifo.v           # Main FIFO design
 ┣ 📜 asyn_fifo_tb.v        # Testbench
 ┗ 📘 README.md             # Project documentation
```

---
This **Asynchronous FIFO** design provides a robust, parameterized, and educational example of clock-domain crossing and synchronization in digital systems.
It can be directly integrated into larger systems such as:

* UARTs
* DSP pipelines
* Network buffers
* SoC interconnects

