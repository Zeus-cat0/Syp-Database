-- Medicare Database

DROP DATABASE IF EXISTS medicare;

CREATE DATABASE medicare;
USE medicare;

-- PATIENT TABLE
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    dob DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- DOCTOR TABLE
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- APPOINTMENT TABLE
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('scheduled','completed','cancelled') DEFAULT 'scheduled',

    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE CASCADE,

    FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE CASCADE
);

-- PRESCRIPTIONS TABLE
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    medicines TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
        ON DELETE CASCADE
);

-- HEALTH RECORDS TABLE
CREATE TABLE health_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    diagnosis TEXT,
    treatment TEXT,
    report_date DATE,

    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE CASCADE
);



-- SAMPLE PATIENT
INSERT INTO patients (name,email,password,phone)
VALUES ('Ram Sharma','ram@test.com','123','9800000000');


INSERT INTO patients (name,email,password,phone)
VALUES ('Sita Rai','sita@test.com','123','9811111111');


-- SAMPLE DOCTOR
INSERT INTO doctors (name,specialization,email)
VALUES ('Dr. Sita Karki','Cardiology','sita@test.com');

INSERT INTO doctors (name,specialization,email)
VALUES ('Dr. Ram Adhikari','Dermatology','ramdoc@test.com');

-- SAMPLE APPOINTMENT
INSERT INTO appointments (patient_id,doctor_id,appointment_date)
VALUES (1,1,'2026-03-10 10:00:00');


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

-- PRESCRIPTIONS LIST
SELECT p.name, pr.medicines
FROM prescriptions pr
JOIN appointments a ON pr.appointment_id = a.appointment_id
JOIN patients p ON a.patient_id = p.patient_id;



