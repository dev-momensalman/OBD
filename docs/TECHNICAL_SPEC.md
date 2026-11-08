# ⚙️ TECHNICAL_SPEC.md — OBD-II Protocols, PIDs, & Mathematical Specifications

> **Standard:** SAE J1979 (Diagnostic Test Modes) & SAE J2012 (DTC Definitions)  
> **Hardware Interface:** ELM327 Command Protocol over Bluetooth Serial/GATT

---

## 1. ELM327 AT Initialization Sequence

Before querying diagnostic data, the mobile application must issue a strict initialization sequence to prepare the microcontroller:

```
[Connect to BLE Peripheral]
    ↓
TX: "ATZ\r"          → RX: "ELM327 v1.5\r\r>"       (Warm Reset)
TX: "ATE0\r"         → RX: "OK\r\r>"               (Echo OFF)
TX: "ATL0\r"         → RX: "OK\r\r>"               (Linefeeds OFF)
TX: "ATS0\r"         → RX: "OK\r\r>"               (Spaces OFF)
TX: "ATSP0\r"        → RX: "OK\r\r>"               (Set Protocol to Automatic Search)
TX: "0100\r"         → RX: "4100BE1FA813\r\r>"     (Check Supported PIDs 01-20)
```

---

## 2. Standard OBD-II Parameter IDs (Mode 01) & Mathematical Formulas

| PID (Hex) | Parameter Description | Bytes | Raw Formula | Range | Units |
|---|---|:---:|---|---|:---:|
| `0104` | Calculated Engine Load | 1 | `A * 100 / 255` | 0 - 100 | `%` |
| `0105` | Engine Coolant Temperature | 1 | `A - 40` | -40 to 215 | `°C` |
| `0106` | Short Term Fuel Trim (Bank 1) | 1 | `(A - 128) * 100 / 128` | -100 to +99.2 | `%` |
| `0107` | Long Term Fuel Trim (Bank 1) | 1 | `(A - 128) * 100 / 128` | -100 to +99.2 | `%` |
| `010B` | Intake Manifold Absolute Pressure (MAP)| 1 | `A` | 0 to 255 | `kPa` |
| `010C` | Engine RPM | 2 | `((A * 256) + B) / 4` | 0 to 16,383.75 | `RPM` |
| `010D` | Vehicle Speed | 1 | `A` | 0 to 255 | `km/h` |
| `010E` | Timing Advance | 1 | `(A - 128) / 2` | -64 to +63.5 | `°` |
| `010F` | Intake Air Temperature (IAT) | 1 | `A - 40` | -40 to 215 | `°C` |
| `0110` | Mass Air Flow (MAF) Rate | 2 | `((A * 256) + B) / 100` | 0 to 655.35 | `g/s` |
| `0111` | Absolute Throttle Position | 1 | `A * 100 / 255` | 0 to 100 | `%` |
| `011F` | Run Time Since Engine Start | 2 | `(A * 256) + B` | 0 to 65,535 | `seconds` |
| `0142` | Control Module Voltage (Battery) | 2 | `((A * 256) + B) / 1000` | 0 to 65.535 | `V` |

---

## 3. Diagnostic Trouble Code (DTC) Parsing Algorithm

### Diagnostic Test Modes
- **Mode 03 (`03\r`):** Request Confirmed Stored Diagnostic Trouble Codes.
- **Mode 07 (`07\r`):** Request Pending Trouble Codes (detected during current or last driving cycle).
- **Mode 04 (`04\r`):** Clear Trouble Codes & Reset Stored Diagnostic Information (requires user confirmation).
- **Mode 02 (`02 <PID> <FRAME>\r`):** Request Freeze-Frame telemetry recorded when DTC was stored.

### Binary Decoding of 2-Byte DTC Packet
A returned DTC is encoded in 2 bytes: `Byte A` and `Byte B`.

```
Byte A Bits:
[7..6] → Code Category:
         00 = 'P' (Powertrain: Engine, Transmission)
         01 = 'C' (Chassis: ABS, Suspension, Steering)
         10 = 'B' (Body: Airbags, Climate, Lighting)
         11 = 'U' (Network: CAN Bus, ECU Communication)

[5..4] → Code Type:
         00 = '0' (Standard SAE Defined)
         01 = '1' (Manufacturer Specific)
         10 = '2' (Manufacturer Specific)
         11 = '3' (Reserved / Mixed)

[3..0] → Hex Digit 2 of DTC (Subsystem)

Byte B Bits:
[7..4] → Hex Digit 3 of DTC
[3..0] → Hex Digit 4 of DTC
```

*Example:* `03 43 01 01 71 00 00`  
`43` = Response to Mode 03.  
Bytes `01 01`: `00` ➔ `P`, `00` ➔ `0`, `0001` ➔ `1`, `0000 0001` ➔ `01` ➔ **`P0101`** (MAF Sensor Circuit Range/Performance).  
Bytes `71 00` ➔ **`P0171`** (System Too Lean Bank 1).
