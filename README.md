# Tablet-Bottle-Filler-Plant-Control-System
This repository contains the design, implementation, and behavioral analysis of an automated digital control system for pharmaceutical tablet bottling.

# 🚀 System Overview
The controller operates without a microcontroller, relying instead on a dual-register configuration and a modular sequential logic architecture. It synchronizes asynchronous physical sensor feedback with synchronous digital storage to continuously monitor the real-time count against a user-defined limit, governing the mechanical output of a dispensing valve.

# ⚙️ Core Architecture

# Tablet Bottle Filler Plant Control System

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains the design, implementation, and behavioral analysis of an automated digital control system for pharmaceutical tablet bottling. Developed for the EE-221 Digital Logic Design course, this project demonstrates how to achieve high-precision, zero-margin error dispensing using discrete TTL and CMOS logic components.

## 🚀 System Overview

The controller operates without a microcontroller, relying instead on a dual-register configuration and a modular sequential logic architecture. It synchronizes asynchronous physical sensor feedback with synchronous digital storage to continuously monitor the real-time count against a user-defined limit, governing the mechanical output of a dispensing valve.

## ⚙️ Core Architecture

The system logic is divided into three primary functional stages:

* **Target Acquisition:** Users input a target tablet count (0-99) via a 4x3 keypad. An MM74C922 encoder translates the input into a 4-bit BCD signal, which is latched into Register A (74LS273) and mathematically converted to an 8-bit binary value for internal processing.
* **Active Control & Accumulation:** An optical or capacitive sensor detects falling tablets, sending clean pulses to a 74HC393 counter that tracks the current bottle's fill level in real-time.
* **Comparator Logic:** A 74LS85 multi-bit digital comparator continuously evaluates the target value against the current sensor count. Once the counts match (A=B), the system instantly de-energizes the dispensing valve to stop the flow.
* **Production Tracking:** A continuous adder loop utilizing 74LS283 full adders increments a secondary 74LS273 register, maintaining a running grand total of all tablets processed throughout the operational period.

## 🧰 Hardware & Component Stack

The design focuses on reliable switching thresholds and stable operation using 74-series Integrated Circuits:
* **Encoders & Displays:** MM74C922 (Keypad Encoder), 74LS47 (BCD-to-7-Segment Decoder).
* **Registers:** 74LS273 (8-bit registers for target and total accumulation storage).
* **Arithmetic Logic:** 74LS283 (High-speed 4-bit Full Adders), 74HC393 (Binary Counters).
* **Decision Logic:** 74LS85 (Magnitude Comparators).

## ⏱️ Performance Dynamics

The system's bottling flow and throughput are completely user-adjustable. The duration for which the dispensing valve remains open ($T_{open}$) is governed by the linear equation: 

$$T_{open} = \frac{N}{f_s}$$

Where:
* **$N$:** Target count stored in Register A.
* **$f_s$:** Frequency of the tablets passing the sensor.

To guarantee an error-free cycle where the valve closes before an extra tablet falls, the total propagation delay of the combinational logic is engineered to remain strictly less than the inverse of the sensor frequency ($1 / f_s$).

## 📋 Bill of Materials (BOM)

The following table lists the primary hardware components required to physically replicate the logic control circuit. 

| Component | Description | Reference / Usage | Est. Qty |
| :--- | :--- | :--- | :---: |
| **MM74C922** | 16-Key Encoder | [cite_start]Translates keypad inputs into 4-bit BCD signals[cite: 99, 100]. | 1 |
| **74LS273** | Octal D-Type Flip-Flop (Register) | [cite_start]Latches and stores the target tablet count (Register A) [cite: 101, 102] [cite_start]and stores the updated Grand Total (Register B)[cite: 164, 167]. | 2 |
| **74HC393** | Dual 4-Bit Binary Counter | [cite_start]Increments with each sensor pulse to track the real-time tablet count in the current bottle[cite: 141, 142]. | 1 |
| **74LS85** | 4-Bit Magnitude Comparator | [cite_start]Compares the "Current Count" with the "Target Number" to trigger the valve stop signal[cite: 143, 144]. Cascaded for 8-bit comparison. | 2 |
| **74LS283** | 4-Bit Binary Full Adder | [cite_start]Used for BCD-to-binary conversion [cite: 119] [cite_start]and to continuously sum the current count with the previous total for the grand total accumulation[cite: 158, 159]. | 4 |
| **74LS47** | BCD to 7-Segment Decoder | [cite_start]Drives the visual 7-segment displays for user target confirmation[cite: 118]. | 2 |
| **4x3 Matrix Keypad** | Input Device | [cite_start]Allows operators to enter the desired tablet count (0-99)[cite: 26, 98]. | 1 |
| **7-Segment Display** | Output Device (Visual) | [cite_start]Provides real-time visual monitoring of the target value[cite: 54]. | 2 |
| **Discrete LEDs** | Output Device (Visual) | [cite_start]Provides a clear, binary visual representation of the accumulated grand total[cite: 155]. | 8 |
| **Optical / IR Sensor** | Input Device (Physical) | [cite_start]Detects passing tablets and generates pulses for the accumulator stage[cite: 31, 140]. | 1 |
| **Dispensing Valve** | Actuator | [cite_start]Mechanical valve controlled by the logic circuit to dispense tablets[cite: 38]. | 1 |

---

## 📁 Repository Structure

* `src/` - Contains the Verilog source code and behavioral models.
* `sim/` - Testbenches and simulation waveforms.
* `docs/` - Project reports, circuit schematics, and block diagrams.



