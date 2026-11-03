-- CSC6302 Database Principles
-- Week 1 Programming Assignment
-- Paranormal Expedition Table Creation

USE ParanormalExpedition;

-- =========================================================
-- Location
-- =========================================================

CREATE TABLE IF NOT EXISTS Location (
    location_id INT AUTO_INCREMENT,
    location_name VARCHAR(100) NOT NULL,
    address VARCHAR(150),
    city VARCHAR(75) NOT NULL,
    state CHAR(2) NOT NULL,
    location_type VARCHAR(50) NOT NULL,
    risk_level VARCHAR(20) NOT NULL DEFAULT 'Moderate',
    notes TEXT,

    CONSTRAINT pk_location
        PRIMARY KEY (location_id),

    CONSTRAINT chk_location_risk
        CHECK (risk_level IN ('Low', 'Moderate', 'High', 'Extreme'))
);


-- =========================================================
-- Investigator
-- =========================================================

CREATE TABLE IF NOT EXISTS Investigator (
    investigator_id INT AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL,
    specialty VARCHAR(75) NOT NULL,
    experience_years INT NOT NULL DEFAULT 0,
    active_status BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT pk_investigator
        PRIMARY KEY (investigator_id),

    CONSTRAINT uq_investigator_email
        UNIQUE (email),

    CONSTRAINT chk_investigator_experience
        CHECK (experience_years >= 0)
);


-- =========================================================
-- Equipment
-- =========================================================

CREATE TABLE IF NOT EXISTS Equipment (
    equipment_id INT AUTO_INCREMENT,
    equipment_name VARCHAR(100) NOT NULL,
    equipment_type VARCHAR(75) NOT NULL,
    manufacturer VARCHAR(100),
    serial_number VARCHAR(100),
    operational_status VARCHAR(20) NOT NULL DEFAULT 'Available',
    legacy_code VARCHAR(30),

    CONSTRAINT pk_equipment
        PRIMARY KEY (equipment_id),

    CONSTRAINT uq_equipment_serial
        UNIQUE (serial_number),

    CONSTRAINT chk_equipment_status
        CHECK (
            operational_status IN (
                'Available',
                'Assigned',
                'Maintenance',
                'Retired'
            )
        )
);


-- =========================================================
-- Expedition
-- =========================================================

CREATE TABLE IF NOT EXISTS Expedition (
    expedition_id INT AUTO_INCREMENT,
    expedition_name VARCHAR(120) NOT NULL,
    location_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Planned',
    objective VARCHAR(255) NOT NULL,

    CONSTRAINT pk_expedition
        PRIMARY KEY (expedition_id),

    CONSTRAINT fk_expedition_location
        FOREIGN KEY (location_id)
        REFERENCES Location(location_id),

    CONSTRAINT chk_expedition_status
        CHECK (
            status IN (
                'Planned',
                'Active',
                'Completed',
                'Cancelled'
            )
        ),

    CONSTRAINT chk_expedition_dates
        CHECK (
            end_date IS NULL
            OR end_date >= start_date
        )
);


-- =========================================================
-- ExpeditionInvestigator
-- =========================================================

CREATE TABLE IF NOT EXISTS ExpeditionInvestigator (
    expedition_id INT NOT NULL,
    investigator_id INT NOT NULL,
    team_role VARCHAR(75) NOT NULL,
    hours_assigned DECIMAL(5,2) NOT NULL DEFAULT 0,

    CONSTRAINT pk_expedition_investigator
        PRIMARY KEY (expedition_id, investigator_id),

    CONSTRAINT fk_ei_expedition
        FOREIGN KEY (expedition_id)
        REFERENCES Expedition(expedition_id),

    CONSTRAINT fk_ei_investigator
        FOREIGN KEY (investigator_id)
        REFERENCES Investigator(investigator_id),

    CONSTRAINT chk_ei_hours
        CHECK (hours_assigned >= 0)
);


-- =========================================================
-- ExpeditionEquipment
-- =========================================================

CREATE TABLE IF NOT EXISTS ExpeditionEquipment (
    expedition_id INT NOT NULL,
    equipment_id INT NOT NULL,
    checkout_time DATETIME NOT NULL,
    return_time DATETIME,
    condition_out VARCHAR(50) NOT NULL DEFAULT 'Good',
    condition_in VARCHAR(50),

    CONSTRAINT pk_expedition_equipment
        PRIMARY KEY (expedition_id, equipment_id),

    CONSTRAINT fk_ee_expedition
        FOREIGN KEY (expedition_id)
        REFERENCES Expedition(expedition_id),

    CONSTRAINT fk_ee_equipment
        FOREIGN KEY (equipment_id)
        REFERENCES Equipment(equipment_id),

    CONSTRAINT chk_equipment_return
        CHECK (
            return_time IS NULL
            OR return_time >= checkout_time
        )
);


-- =========================================================
-- Evidence
-- =========================================================

CREATE TABLE IF NOT EXISTS Evidence (
    evidence_id INT AUTO_INCREMENT,
    expedition_id INT NOT NULL,
    investigator_id INT NOT NULL,
    equipment_id INT,
    evidence_type VARCHAR(50) NOT NULL,
    captured_at DATETIME NOT NULL,
    file_reference VARCHAR(255),
    credibility_score TINYINT NOT NULL DEFAULT 5,
    notes TEXT,

    CONSTRAINT pk_evidence
        PRIMARY KEY (evidence_id),

    CONSTRAINT fk_evidence_expedition
        FOREIGN KEY (expedition_id)
        REFERENCES Expedition(expedition_id),

    CONSTRAINT fk_evidence_investigator
        FOREIGN KEY (investigator_id)
        REFERENCES Investigator(investigator_id),

    CONSTRAINT fk_evidence_equipment
        FOREIGN KEY (equipment_id)
        REFERENCES Equipment(equipment_id),

    CONSTRAINT chk_evidence_credibility
        CHECK (
            credibility_score BETWEEN 1 AND 10
        )
);
