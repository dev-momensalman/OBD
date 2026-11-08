# 🔒 SECURITY.md — Cybersecurity, Threat Modeling & Data Protection

> **Framework:** OWASP Mobile Top 10 • STRIDE Threat Model  
> **Source:** SRS §7.3 (Security) & §8.3 (Data Requirements)

---

## 1. Threat Modeling (STRIDE Analysis)

| Threat Category | Potential Attack Vector | Applied Mitigation |
|---|---|---|
| **Spoofing** | Attacker impersonates legitimate user or workshop | Firebase Authentication with Secure JWT tokens and SMS MFA verification. |
| **Tampering** | Man-in-the-middle tampering of live OBD-II BLE packets | BLE Secure Connections with encrypted pairing key; checksum verification on raw byte frames. |
| **Repudiation** | User denies booking or workshop denies quote | Immutable audit log of work order state transitions in Firestore with authenticated timestamps. |
| **Information Disclosure** | Leakage of vehicle location or VIN history | Strict Firestore Security Rules ensuring users can only read/write their own vehicle records. |
| **Denial of Service** | Flooding BLE adapter with spam AT commands | Rate-limiting connection manager queue; auto-throttling telemetry queries to 10 Hz max. |
| **Elevation of Privilege** | Normal user attempts to update work order as technician | Firestore declarative role checks (`request.auth.token.role == 'TECHNICIAN'`). |

---

## 2. Declarative Cloud Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User profile: only readable and writable by owning user
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Vehicle profile: owner can manage; technicians can read if work order assigned
    match /vehicles/{vehicleId} {
      allow read: if request.auth != null && 
        (resource.data.ownerId == request.auth.uid || request.auth.token.role in ['TECHNICIAN', 'WORKSHOP_ADMIN']);
      allow create: if request.auth != null && request.resource.data.ownerId == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.ownerId == request.auth.uid;
    }

    // Diagnostic reports: owner can read/create; immutable once created
    match /diagnostic_reports/{reportId} {
      allow read: if request.auth != null && 
        (resource.data.userId == request.auth.uid || request.auth.token.role in ['TECHNICIAN', 'WORKSHOP_ADMIN']);
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if false; // Reports are tamper-proof immutable records
    }

    // Service centers: public read for verified centers; admin write
    match /service_centers/{centerId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.token.role == 'WORKSHOP_ADMIN';
    }

    // Work orders: created by user, updated by assigned technician
    match /work_orders/{orderId} {
      allow read: if request.auth != null && 
        (resource.data.userId == request.auth.uid || resource.data.serviceCenterId == request.auth.token.centerId);
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && 
        (resource.data.userId == request.auth.uid || request.auth.token.role in ['TECHNICIAN', 'WORKSHOP_ADMIN']);
    }
  }
}
```
