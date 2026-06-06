
CREATE DATABASE hospital_db;
USE hospital_db;

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT,
    gender VARCHAR(10)
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    specialization VARCHAR(50)
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Treatments (
    treatment_id INT PRIMARY KEY,
    appointment_id INT,
    patient_id INT,
    diagnosis VARCHAR(100),
    cost DECIMAL(10,2),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- =========================
-- INSERT DATA
-- =========================

INSERT INTO Patients VALUES
(1, 'Ravi', 25, 'Male'),
(2, 'Anita', 30, 'Female'),
(3, 'Kiran', 40, 'Male'),
(4, 'Sneha', 28, 'Female'),
(5, 'Arjun', 35, 'Male');

INSERT INTO Doctors VALUES
(1, 'Dr. Sharma', 'Cardiology'),
(2, 'Dr. Reddy', 'Orthopedic'),
(3, 'Dr. Mehta', 'General'),
(4, 'Dr. Priya', 'Dermatology');

INSERT INTO Appointments VALUES
(1, 1, 1, '2025-04-01'),
(2, 2, 2, '2025-04-02'),
(3, 1, 1, '2025-04-10'),
(4, 3, 3, '2025-04-11'),
(5, 4, 4, '2025-05-01'),
(6, 5, 2, '2025-05-03'),
(7, 2, 2, '2025-05-05'),
(8, 1, 3, '2025-06-01');

INSERT INTO Treatments VALUES
(1, 1, 1, 'Fever', 500),
(2, 2, 2, 'Fracture', 3000),
(3, 3, 1, 'Cold', 300),
(4, 4, 3, 'Diabetes', 2000),
(5, 5, 4, 'Skin Allergy', 800),
(6, 6, 5, 'Fracture', 1500),
(7, 7, 2, 'Fracture', 1200),
(8, 8, 1, 'Fever', 600);

-- =========================
-- ANALYSIS QUERIES
-- =========================

-- 1. MOST CONSULTED DOCTORS
SELECT D.doctor_id, D.name, COUNT(A.appointment_id) AS total_visits
FROM Doctors D
JOIN Appointments A ON D.doctor_id = A.doctor_id
GROUP BY D.doctor_id, D.name
ORDER BY total_visits DESC;

-- 2. TOTAL REVENUE PER MONTH
SELECT MONTH(A.date) AS month, SUM(T.cost) AS total_revenue
FROM Appointments A
JOIN Treatments T ON A.appointment_id = T.appointment_id
GROUP BY MONTH(A.date)
ORDER BY month;

-- 3. MOST COMMON DISEASES
SELECT diagnosis, COUNT(*) AS frequency
FROM Treatments
GROUP BY diagnosis
ORDER BY frequency DESC;

-- 4. PATIENT VISIT FREQUENCY
SELECT P.patient_id, P.name, COUNT(A.appointment_id) AS visit_count
FROM Patients P
JOIN Appointments A ON P.patient_id = A.patient_id
GROUP BY P.patient_id, P.name
ORDER BY visit_count DESC;

-- 5. DOCTOR PERFORMANCE (UNIQUE PATIENTS HANDLED)
SELECT D.doctor_id, D.name, COUNT(DISTINCT A.patient_id) AS patients_handled
FROM Doctors D
JOIN Appointments A ON D.doctor_id = A.doctor_id
GROUP BY D.doctor_id, D.name
ORDER BY patients_handled DESC;