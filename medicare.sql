-- Medicare Database using SQL*Plus
CREATE USER medicare IDENTIFIED BY 1234;
CONNECT medicare/1234

    
-- PATIENT TABLE
CREATE TABLE patients (
    patient_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    password VARCHAR2(255) NOT NULL,
    phone VARCHAR2(20),
    dob DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DOCTOR TABLE
CREATE TABLE doctors (
    doctor_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    specialization VARCHAR2(100),
    email VARCHAR2(100) UNIQUE,
    phone VARCHAR2(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- APPOINTMENTS
CREATE TABLE appointments (
    appointment_id NUMBER PRIMARY KEY,
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
    prescription_id NUMBER PRIMARY KEY,
    appointment_id NUMBER NOT NULL,
    medicines CLOB,
    notes CLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prescription_appt
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
        ON DELETE CASCADE
);

-- HEALTH RECORDS
CREATE TABLE health_records (
    record_id NUMBER PRIMARY KEY,
    patient_id NUMBER NOT NULL,
    diagnosis CLOB,
    treatment CLOB,
    report_date DATE,
    CONSTRAINT fk_health_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE CASCADE
);

-- Samples
-- SAMPLE PATIENTS
INSERT INTO patients VALUES (1,'Ram Sharma','ram@test.com','123','9800000000',DATE '2000-05-10',CURRENT_TIMESTAMP);
INSERT INTO patients VALUES (2,'Sita Rai','sita@test.com','123','9811111111',DATE '1999-08-21',CURRENT_TIMESTAMP);


-- SAMPLE DOCTORS
INSERT INTO doctors VALUES (1,'Dr. Sita Karki','Cardiology','sita@hospital.com','9802222222',CURRENT_TIMESTAMP);
INSERT INTO doctors VALUES (2,'Dr. Ram Adhikari','Dermatology','ram@hospital.com','9803333333',CURRENT_TIMESTAMP);


-- SAMPLE APPOINTMENTS
INSERT INTO appointments VALUES (1,1,1,TIMESTAMP '2026-03-10 10:00:00','scheduled');
INSERT INTO appointments VALUES (2,2,2,TIMESTAMP '2026-03-11 12:00:00','completed');


-- SAMPLE PRESCRIPTIONS
INSERT INTO prescriptions VALUES (1,1,'Paracetamol','Take twice a day',CURRENT_TIMESTAMP);
INSERT INTO prescriptions VALUES (2,2,'Skin cream','Apply daily',CURRENT_TIMESTAMP);


-- SAMPLE HEALTH RECORDS
INSERT INTO health_records VALUES (1,1,'Fever','Rest and medication',DATE '2026-02-10');
INSERT INTO health_records VALUES (2,2,'Skin allergy','Antihistamine',DATE '2026-02-12');

-- Show tables
SELECT table_name FROM user_tables;

-- Show data
SELECT * FROM patients;
SELECT * FROM doctors;
SELECT * FROM appointments;
SELECT * FROM prescriptions;
SELECT * FROM health_records;

-- VIEW APPOINTMENTS
SELECT 
p.name AS patient,
d.name AS doctor,
a.appointment_date,
a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;


-- VIEW PRESCRIPTIONS
SELECT 
p.name,
pr.medicines,
pr.notes
FROM prescriptions pr
JOIN appointments a ON pr.appointment_id = a.appointment_id
JOIN patients p ON a.patient_id = p.patient_id;

COMMIT;


