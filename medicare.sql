-- Medicare Database using SQL*Plus

CREATE USER medicare IDENTIFIED BY 1234;

GRANT CONNECT, RESOURCE TO medicare;

ALTER USER medicare QUOTA UNLIMITED ON USERS;

-- PATIENT TABLE
CREATE TABLE patients (
    patient_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    password VARCHAR2(255) NOT NULL,
    phone VARCHAR2(20),
    dob DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DOCTOR TABLE
CREATE TABLE doctors (
    doctor_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    specialization VARCHAR2(100),
    email VARCHAR2(100) UNIQUE,
    phone VARCHAR2(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- APPOINTMENTS
CREATE TABLE appointments (
    appointment_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id NUMBER NOT NULL,
    doctor_id NUMBER NOT NULL,
    appointment_date TIMESTAMP NOT NULL,
    status VARCHAR2(20) DEFAULT 'scheduled',

    CONSTRAINT fk_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE CASCADE,

    CONSTRAINT chk_status
        CHECK (status IN ('scheduled','completed','cancelled'))
);

-- PRESCRIPTIONS
CREATE TABLE prescriptions (
    prescription_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    appointment_id NUMBER NOT NULL,
    medicines CLOB,
    notes CLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
        ON DELETE CASCADE
);

-- HEALTH RECORDS
CREATE TABLE health_records (
    record_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id NUMBER NOT NULL,
    diagnosis CLOB,
    treatment CLOB,
    report_date DATE,

    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE CASCADE
);

-- Samples

INSERT INTO patients (name,email,password,phone)
VALUES ('Ram Sharma','ram@test.com','123','9800000000');

INSERT INTO patients (name,email,password,phone)
VALUES ('Sita Rai','sita@test.com','123','9811111111');

INSERT INTO doctors (name,specialization,email)
VALUES ('Dr. Sita Karki','Cardiology','sita@test.com');

INSERT INTO doctors (name,specialization,email)
VALUES ('Dr. Ram Adhikari','Dermatology','ramdoc@test.com');

INSERT INTO appointments (patient_id,doctor_id,appointment_date)
VALUES (1,1,TIMESTAMP '2026-03-10 10:00:00');



-- GET ALL DOCTORS
SELECT * FROM doctors;

-- SEARCH DOCTOR BY SPECIALIZATION
SELECT * FROM doctors
WHERE specialization LIKE '%Cardio%';

-- VIEW APPOINTMENTS
SELECT p.name AS patient, d.name AS doctor, a.appointment_date, a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;




