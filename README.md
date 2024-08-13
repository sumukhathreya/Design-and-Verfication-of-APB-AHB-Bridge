# Design-and-Verfication-of-APB-AHB-Bridge

This repository contains the RTL design and verification of an APB (Advanced Peripheral Bus) to AHB (Advanced High-performance Bus) bridge. The APB to AHB bridge is a critical component in ARM-based System-on-Chip (SoC) architectures, enabling seamless communication between low-speed peripheral devices and high-speed system components.

Key Features:
RTL Design: The bridge is designed to convert transactions between the APB, typically used for connecting peripheral devices, and the AHB, which supports higher-speed data transfers and is commonly used for connecting high-performance system components.

Protocol Conversion: The APB to AHB bridge efficiently handles protocol conversion, ensuring data integrity and minimal latency during transactions between the two bus systems.

Verification Using SystemVerilog and UVM: A comprehensive verification environment was developed using SystemVerilog and UVM (Universal Verification Methodology). This includes creating testbenches, sequences, and coverage models to ensure the bridge's functionality and performance under various scenarios.

Functional Coverage and Constrained Random Verification: The verification process included functional coverage to ensure all aspects of the bridge's operation were tested, as well as constrained random verification to identify and resolve potential edge cases and bugs.

This project demonstrates the complete design and verification flow for an APB to AHB bridge, making it a valuable reference for engineers working on similar SoC integration tasks.
