BAM Currency Converter & Predictor v2.0

Professional MIPS Assembly Financial Suite

🔹 Description

BAM Currency Converter & Predictor v2.0 is a robust, feature-rich financial simulation system developed entirely in MIPS Assembly for the MARS 4.5 simulator.
The project demonstrates advanced low-level programming concepts such as floating-point arithmetic, structured memory usage, modular subroutines, and interactive terminal-based user interfaces.

Designed as an educational Computer Architecture project, the system simulates real-world currency exchange and trend prediction logic while operating within the constraints of assembly-level programming.

💎 Key Features
⚡ Real-Time Currency Conversion

Supports conversion between 8 major currencies:
BAM, USD, EUR, CHF, AUD, GBP, TRY, BTC

Uses high-precision floating-point calculations (up to 7 decimal places) to ensure accurate results, including cryptocurrency values.

📈 Trend Prediction Engine

Implements a custom prediction algorithm that simulates currency fluctuations across:

1 week

1 month

3 months

Predictions are based on predefined historical trend data stored in memory.

🔄 Live Rate Updates

Allows users to modify exchange rates dynamically during runtime, simulating a live exchange rate feed within the MARS environment.

🎨 Immersive Terminal UI

Features a cinematic system initialization loading animation with progress bars.

Simulates a modern terminal experience entirely through assembly-level UI routines.

🛡️ Robust Error Handling

Input validation for:

Invalid currency codes

Negative or zero amounts

Invalid menu selections

Prevents undefined behavior and improves user interaction stability.

🛠️ Technical Implementation
Mathematical Logic

The system uses BAM (Bosnian Mark) as the pivot currency.
Conversions between two non-base currencies follow this formula:

Result = (Amount × Target_Rate) / Source_Rate

Data Structures

Floating-Point Arrays
Store exchange rates and prediction values with high precision.

Pointer Arrays
Dynamically manage currency labels for UI rendering.

Modular Subroutines
Extensive use of jal (Jump and Link) for reusable logic such as animations, menu handling, and calculations.

🚀 How to Run

Download and install MARS 4.5 MIPS Simulator

Open the .asm file in MARS

Assemble the program (F3 or Wrench & Hammer icon)

Run the program (F5 or Play icon)

Interact using the Run I/O console at the bottom

📊 Supported Currencies (Sample Rates)
Code	Currency	Base Rate (1 BAM)
BAM	Bosnian Mark	1.0
USD	US Dollar	0.563
EUR	Euro	0.518
BTC	Bitcoin	0.0000089
📝 Project Architecture
├── .data
│   ├── rates              # Floating-point exchange rates
│   ├── currencies         # Pointer array for currency labels
│   └── ui_strings         # UI text and messages
└── .text
    ├── main_loop           # System entry point
    ├── loading_animation   # UI animation subroutine
    ├── convert_currency   # Conversion logic
    └── predict_currency   # Trend prediction algorithm

⚖️ Disclaimer

This project is an educational simulation developed for Computer Architecture studies.
All exchange rates and predictions are hardcoded examples and must not be used for real-world financial decisions.
