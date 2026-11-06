# Wireless Network Traffic Monitoring and Rule-Based Alerting System

**Department of Computer Science and Engineering**  
**Team 6 — Hybrid SDLC Sprint 1 Implementation**  
- **E1**: Network Traffic Collection Engine (syslog)
- **E2**: Multi-Threaded Log Processing Engine
- **E3**: Rule-Based Analysis & Alerting Engine
- **E4**: Log & Alert Management Engine

---

## 1. Directory Structure

```text
alert-sys/
├── logs/                                    # Dedicated storage for campus & simulated log files
│   ├── high_traffic_logs.csv                # High traffic burst test dataset with 802.11 headers
│   ├── dns_activity_logs.csv                # High volume DNS query anomaly logs
│   ├── port_scan_simulation_logs.csv        # Multi-port scanning simulation logs
│   └── README_data_provenance.txt           # Data origin & synthetic wireless header details
├── models/                                  # MongoDB / Mongoose JavaScript models
│   ├── NetworkLog.js                        # NetworkLog schema
│   ├── Rule.js                              # Rule schema
│   ├── Alert.js                             # Alert schema
│   ├── User.js                              # User schema
│   ├── Report.js                            # Report schema
│   ├── db.js                                # Database connection helper
│   └── index.js                             # Export all models
├── db/
│   └── schema.sql                           # Relational SQL schema reference (Sprint 1 §4.15 & §4.18)
├── package.json
└── Readme.md
```

---

## 2. MongoDB / Mongoose Schemas ([`models/`](file:///d:/alert-sys/models))

1. **`NetworkLog.js`**: Stores captured traffic and syslog records (`event_time`, `source_ip`, `destination_ip`, `source_port`, `destination_port`, `protocol`, `packet_size`, `message`, plus wireless metadata).
2. **`Rule.js`**: Stores alert detection rules (`rule_id`, `rule_name`, `rule_type`, `threshold_value`, `window_seconds`, `severity`, `is_active`, `cooldown_seconds`).
3. **`Alert.js`**: Stores generated alerts (`rule_id`, `log_id`, `viewed_by`, `alert_time`, `alert_type`, `severity`, `source_ip`, `description`, `status`).
4. **`User.js`**: Stores web dashboard user accounts with RBAC (`username`, `password_hash`, `role: ADMIN | SECURITY`, `is_active`).
5. **`Report.js`**: Records generated dashboard reports (`generated_by`, `report_type`, `period_start`, `period_end`, `generated_at`).

---

## 3. Dedicated Log Files Storage ([`logs/`](file:///d:/alert-sys/logs))

- [`high_traffic_logs.csv`](file:///d:/alert-sys/logs/high_traffic_logs.csv)
- [`dns_activity_logs.csv`](file:///d:/alert-sys/logs/dns_activity_logs.csv)
- [`port_scan_simulation_logs.csv`](file:///d:/alert-sys/logs/port_scan_simulation_logs.csv)
- [`README_data_provenance.txt`](file:///d:/alert-sys/logs/README_data_provenance.txt)
