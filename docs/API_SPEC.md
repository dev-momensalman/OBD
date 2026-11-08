# 🔌 API_SPEC.md — External Interface & Microservices API Contract

> **Transport:** REST HTTPS / JSON Payload & BLE GATT Characteristics  
> **Source:** SRS §4 (External Interface Requirements) & §5.9 (Integration Layer)

---

## 1. Bluetooth Low Energy (BLE) GATT Profile Specification

| Entity | UUID | Properties | Description |
|---|---|---|---|
| **Service** | `0000FFF0-0000-1000-8000-00805F9B34FB` | Primary | OBD-II Gateway Service |
| **TX Characteristic** | `0000FFF1-0000-1000-8000-00805F9B34FB` | Write Without Response / Write | App transmits AT / OBD command strings (e.g. `010C\r`) |
| **RX Characteristic** | `0000FFF2-0000-1000-8000-00805F9B34FB` | Notify / Read | Dongle streams hex byte responses terminated by `>` |

---

## 2. AI Diagnostic Microservice REST API

### `POST /api/v1/diagnose`
Accepts raw diagnostic scan payload and executes the 4-tier hybrid AI pipeline.

#### Request Headers
```http
Content-Type: application/json
Authorization: Bearer <Firebase_ID_Token>
```

#### Request Body
```json
{
  "vehicle": {
    "vin": "JTDBR32E220194821",
    "make": "Toyota",
    "model": "Corolla",
    "year": 2021,
    "odometerKm": 48500
  },
  "activeDtcs": ["P0301"],
  "freezeFrame": {
    "rpm": 2150.0,
    "speedKmH": 68.0,
    "coolantTempC": 94.0,
    "engineLoadPercent": 58.5,
    "shortTermFuelTrim": 7.8,
    "longTermFuelTrim": 14.2
  },
  "liveTelemetrySnapshot": {
    "batteryVoltage": 14.1,
    "intakeAirTempC": 32.0,
    "mafRateGs": 18.4
  }
}
```

#### Response Body (`200 OK`)
```json
{
  "status": "success",
  "reportId": "rpt_99381029",
  "severity": "WARNING",
  "overallHealthScore": 76,
  "explanation": "Cylinder 1 misfire detected under cruising load with slightly elevated positive fuel trim.",
  "rankedCauses": [
    {"cause": "Degraded Ignition Coil #1", "probabilityPercent": 65},
    {"cause": "Worn Iridium Spark Plug", "probabilityPercent": 25},
    {"cause": "Partially restricted fuel injector", "probabilityPercent": 10}
  ],
  "recommendedNextAction": "Perform resistance test on Coil #1 or swap with Cylinder #2.",
  "confidenceScore": 0.88,
  "isUncertain": false,
  "retrievedKnowledgeSources": [
    "Toyota Service Manual 2021 2ZR-FAE Section 04: Ignition System",
    "SAE J2012 Diagnostic Standard: P0300 Series Guidelines"
  ],
  "costEstimation": {
    "minUsd": 75.0,
    "maxUsd": 160.0,
    "currency": "USD"
  }
}
```

---

## 3. Service Center & Booking API

### `GET /api/v1/service-centers/nearby`
Queries nearby workshops filtered by vehicle make compatibility and GPS distance.

#### Query Parameters
- `lat` (float): Latitude (e.g. `30.0583`)
- `lng` (float): Longitude (e.g. `31.4922`)
- `radiusKm` (int, default `25`): Search radius in kilometers
- `make` (string): Vehicle brand (e.g. `Toyota`)

#### Response Body (`200 OK`)
```json
{
  "centers": [
    {
      "id": "center_cairo_elrehab_01",
      "name": "Apex Precision Automotive",
      "distanceKm": 3.4,
      "rating": 4.8,
      "reviewCount": 142,
      "address": "Rehab City Mall 2, Workshop Zone, Cairo",
      "estimatedCostForReport": {"minUsd": 80.0, "maxUsd": 150.0}
    }
  ]
}
```
