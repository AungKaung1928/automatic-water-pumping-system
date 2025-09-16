# Automatic Water Pumping System

**ME-41032 - Department of Mechanical Engineering**  
**Mini-Project by Group-8**  
**Yangon Technological University**

## Project Overview

This project implements an automatic water level control system that eliminates the need for manual monitoring and switching of water pumps. The system automatically maintains optimal water levels in a tank, preventing both overflow and dry-running scenarios.

## Team Members (Group-8)
- Member 1 - Hardware Design & Assembly
- Member 2 - Arduino Programming & Control Logic
- Member 3 - MATLAB Simulation & Analysis
- Member 4 - Circuit Design & Testing
- Member 5 - Documentation & Integration

**Supervisors:** Dr. Thein Min Htike and Daw Own Mar Kyi

## System Specifications

- **Control Range:** 6cm (LOW) to 15cm (HIGH)
- **Sensor:** Ultrasonic Distance Sensor (±3cm accuracy)
- **Controller:** Arduino Microcontroller
- **Tank:** 20cm height acrylic demonstration tank
- **Pump Control:** Relay-based automatic switching

## Working Principle

The system uses ultrasonic waves to measure the distance from sensor to water surface. Using the formula:

```
Actual Water Level = Tank Height - Measured Distance
```

**Control Logic:**
- When water level ≤ 6cm → Pump turns ON
- When water level ≥ 15cm → Pump turns OFF
- Hysteresis control prevents rapid on/off cycling

## Hardware Components

- Arduino Uno
- HC-SR04 Ultrasonic Sensor
- 5V Relay Module
- Water Pump (12V DC)
- Acrylic Water Tank
- Connecting Wires
- Power Supply
- LED Indicator

## Software Tools

- **Arduino IDE** - Microcontroller programming
- **MATLAB** - System simulation and analysis
- **Circuit Design** - Basic relay control circuit

## Repository Structure

```
automatic-water-pumping/
├── arduino/
│   └── water_pump_control.ino
├── matlab/
│   └── system_simulation.m
├── documentation/
│   ├── project_presentation.pdf
│   └── circuit_diagram.png
├── images/
│   ├── system_overview.jpg
│   └── demo_setup.jpg
└── README.md
```

## Installation & Usage

### Arduino Setup
1. Install Arduino IDE
2. Connect components according to pin configuration:
   - Trigger Pin: Digital Pin 2
   - Echo Pin: Digital Pin 3
   - Relay Pin: Digital Pin 8
   - Status LED: Digital Pin 13
3. Upload `water_pump_control.ino` to Arduino
4. Open Serial Monitor to view system status

### MATLAB Simulation
1. Open `system_simulation.m` in MATLAB
2. Run the script to see system performance analysis
3. Review generated plots for water level control behavior

## Project Features

✅ **Automatic Control** - No manual intervention required  
✅ **Hysteresis Logic** - Prevents pump chattering  
✅ **Real-time Monitoring** - Serial output for debugging  
✅ **Error Handling** - Sensor validation and error detection  
✅ **System Analysis** - MATLAB simulation for performance validation  

## Technical Challenges & Solutions

### Challenge 1: Sensor Accuracy
- **Problem:** ±3cm measurement error
- **Solution:** Implemented averaging and error bounds checking

### Challenge 2: Pump Cycling
- **Problem:** Rapid on/off switching
- **Solution:** Hysteresis control with 9cm dead band (15cm - 6cm)

### Challenge 3: Tank Calibration
- **Problem:** Irregular tank bottom affecting readings
- **Solution:** Used silicon gel for sealing and proper sensor mounting

## Results

- Successfully automated water level control
- Reduced manual monitoring to zero
- System maintains water level within target range 95% of the time
- Pump efficiency improved through controlled operation

## Future Enhancements

- Remote monitoring via Wi-Fi module
- Mobile app integration
- Multiple tank support
- Advanced flow rate control
- Data logging capabilities

## Project Timeline

- **Week 1-2:** Problem definition and literature review
- **Week 3-4:** Hardware selection and procurement
- **Week 5-6:** Circuit design and Arduino programming
- **Week 7-8:** MATLAB simulation and system testing
- **Week 9-10:** Integration, documentation, and presentation

## Acknowledgments

We thank our supervisors Dr. Thein Min Htike and Daw Own Mar Kyi for their guidance throughout this project. Special thanks to the Mechanical Engineering Department for providing laboratory facilities and components.

## License

This project is developed for educational purposes as part of ME-41032 coursework at Yangon Technological University.

---

**Note:** This project was completed approximately 6 years ago. Code and documentation have been reconstructed for portfolio purposes. Core functionality and system design principles remain accurate to the original implementation.
