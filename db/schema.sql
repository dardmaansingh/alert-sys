-- ============================================================================
-- Wireless Network Traffic Monitoring and Rule-Based Alerting System
-- Engine 4: Log & Alert Management Database Schema (Sprint 1 §4.15 & §4.18)
-- 3NF Normalized Relational Schema with B+ Tree Indexes & Referential Integrity
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: USER (Dashboard Users - Network Admin & Security Team)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'SECURITY')),
    is_active BOOLEAN NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- Table: RULE (Detection Rules for Engine 3)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS rules (
    rule_id VARCHAR(50) PRIMARY KEY,
    rule_name VARCHAR(150) NOT NULL,
    rule_type VARCHAR(50) NOT NULL,
    threshold_value DOUBLE NOT NULL,
    window_seconds INTEGER NOT NULL,
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    is_active BOOLEAN NOT NULL DEFAULT 1,
    cooldown_seconds INTEGER DEFAULT 60,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- Table: NETWORK_LOG (Stores Processed Syslog & Wireless Telemetry Events)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS network_logs (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_time TIMESTAMP NOT NULL,
    source_ip VARCHAR(45) NOT NULL,
    destination_ip VARCHAR(45) NOT NULL,
    source_port INTEGER NOT NULL,
    destination_port INTEGER NOT NULL,
    protocol VARCHAR(20) NOT NULL,
    packet_size INTEGER NOT NULL,
    message TEXT NOT NULL,

    -- Extended Wireless & Campus Telemetry Fields
    bytes_transferred BIGINT DEFAULT 0,
    packet_count INTEGER DEFAULT 1,
    dns_query VARCHAR(255) DEFAULT NULL,
    log_type VARCHAR(50) DEFAULT NULL,
    ssid VARCHAR(100) DEFAULT NULL,
    bssid VARCHAR(50) DEFAULT NULL,
    client_mac VARCHAR(50) DEFAULT NULL,
    access_point_id VARCHAR(50) DEFAULT NULL,
    ap_location VARCHAR(100) DEFAULT NULL,
    rssi_dbm INTEGER DEFAULT NULL,
    wifi_band VARCHAR(20) DEFAULT NULL,
    wifi_channel INTEGER DEFAULT NULL,
    frame_type VARCHAR(50) DEFAULT NULL,
    frame_subtype VARCHAR(50) DEFAULT NULL,
    source_mac VARCHAR(50) DEFAULT NULL,
    destination_mac VARCHAR(50) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- Table: ALERT (Alert Records Raised by Rule Engine E3)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS alerts (
    alert_id INTEGER PRIMARY KEY AUTOINCREMENT,
    rule_id VARCHAR(50) NOT NULL,
    log_id INTEGER DEFAULT NULL,
    viewed_by INTEGER DEFAULT NULL,
    alert_time TIMESTAMP NOT NULL,
    alert_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    source_ip VARCHAR(45) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'GENERATED' CHECK (status IN ('GENERATED', 'STORED', 'VIEWED', 'CLOSED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (rule_id) REFERENCES rules(rule_id) ON DELETE RESTRICT,
    FOREIGN KEY (log_id) REFERENCES network_logs(log_id) ON DELETE SET NULL,
    FOREIGN KEY (viewed_by) REFERENCES users(user_id) ON DELETE SET NULL
);

-- ----------------------------------------------------------------------------
-- Table: REPORT (Generated Reports from Dashboard)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reports (
    report_id INTEGER PRIMARY KEY AUTOINCREMENT,
    generated_by INTEGER NOT NULL,
    report_type VARCHAR(100) NOT NULL,
    period_start TIMESTAMP NOT NULL,
    period_end TIMESTAMP NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (generated_by) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================================
-- B+ Tree Performance Indexes (Sprint 1 §4.18)
-- Fast searching, filtering, and sliding window time-range queries
-- ============================================================================
CREATE INDEX IF NOT EXISTS idx_logs_event_time ON network_logs(event_time);
CREATE INDEX IF NOT EXISTS idx_logs_source_ip ON network_logs(source_ip);
CREATE INDEX IF NOT EXISTS idx_logs_destination_ip ON network_logs(destination_ip);
CREATE INDEX IF NOT EXISTS idx_logs_dest_port ON network_logs(destination_port);

CREATE INDEX IF NOT EXISTS idx_alerts_alert_time ON alerts(alert_time);
CREATE INDEX IF NOT EXISTS idx_alerts_source_ip ON alerts(source_ip);
CREATE INDEX IF NOT EXISTS idx_alerts_severity ON alerts(severity);
CREATE INDEX IF NOT EXISTS idx_alerts_status ON alerts(status);
CREATE INDEX IF NOT EXISTS idx_alerts_rule_id ON alerts(rule_id);

-- ============================================================================
-- Seed Initial Baseline Rules (Sprint 1 §4.10, §4.18)
-- ============================================================================
INSERT OR IGNORE INTO rules (rule_id, rule_name, rule_type, threshold_value, window_seconds, severity, is_active, cooldown_seconds)
VALUES 
    ('R1', 'High Traffic Burst Detection', 'HIGH_TRAFFIC', 100.0, 60, 'HIGH', 1, 120),
    ('R2', 'High DNS Activity Anomaly', 'HIGH_DNS_ACTIVITY', 50.0, 60, 'MEDIUM', 1, 120),
    ('R3', 'Rapid Port Scan Detection', 'PORT_SCAN', 10.0, 30, 'CRITICAL', 1, 300);

-- Seed Default Administrative and Security Team Accounts
-- Password hashes use standard secure format placeholders (e.g., bcrypt hashes)
INSERT OR IGNORE INTO users (user_id, username, password_hash, role, is_active)
VALUES
    (1, 'admin', '$2b$12$e8wE4z48nN27L0mB9/l1CeBvN1nU1ZzXpA9rY8eE2k6l9hF1yXv6a', 'ADMIN', 1),
    (2, 'security_analyst', '$2b$12$K1jE7m98zO23B0mC1/l2CeCvO2nU2ZzYqB0sZ9fF3l7m0iG2zYw7b', 'SECURITY', 1);

