-- CSC6302 Database Principles
-- Week 1 Programming Assignment
-- Paranormal Expedition Sample Data

USE ParanormalExpedition;

-- =========================================================
-- RESET DATA FOR REPEATABLE TESTING
-- Child tables must be cleared before parent tables.
-- =========================================================

DELETE FROM Evidence WHERE evidence_id > 0;
DELETE FROM ExpeditionEquipment WHERE expedition_id > 0;
DELETE FROM ExpeditionInvestigator WHERE expedition_id > 0;
DELETE FROM Expedition WHERE expedition_id > 0;
DELETE FROM Equipment WHERE equipment_id > 0;
DELETE FROM Investigator WHERE investigator_id > 0;
DELETE FROM Location WHERE location_id > 0;

ALTER TABLE Evidence AUTO_INCREMENT = 1;
ALTER TABLE Expedition AUTO_INCREMENT = 1;
ALTER TABLE Equipment AUTO_INCREMENT = 1;
ALTER TABLE Investigator AUTO_INCREMENT = 1;
ALTER TABLE Location AUTO_INCREMENT = 1;


-- =========================================================
-- LOCATION
-- 20 tuples
-- =========================================================

INSERT INTO Location
(location_name, address, city, state, location_type, risk_level, notes)
VALUES
('Blackwood Manor', '14 Hollow Lane', 'Albany', 'NY', 'Historic Residence', 'High', 'Large nineteenth-century residence with repeated reports of unexplained activity'),
('Hollow Creek Hospital', '88 Mercy Road', 'Troy', 'NY', 'Abandoned Hospital', 'Extreme', 'Former medical facility with restricted interior areas'),
('Ravenswood Theater', '21 Grand Avenue', 'Schenectady', 'NY', 'Theater', 'Moderate', 'Historic theater containing backstage and basement investigation areas'),
('Pine Barrens Lodge', '310 Forest Route', 'Lake George', 'NY', 'Lodge', 'High', 'Remote lodge surrounded by dense woodland'),
('Wraith Hill Cemetery', '7 Old Church Road', 'Saratoga Springs', 'NY', 'Cemetery', 'Extreme', 'Historic cemetery with limited nighttime visibility'),
('Ashcroft Mill', '62 River Street', 'Cohoes', 'NY', 'Industrial Ruin', 'High', 'Former mill containing machinery foundations and enclosed corridors'),
('Moonfall Inn', '155 Main Street', 'Hudson', 'NY', 'Historic Inn', 'Moderate', 'Operating historic inn with several reported activity areas'),
('Red Lantern School', '43 Academy Road', 'Kingston', 'NY', 'Abandoned School', 'High', 'Former school building containing classrooms and utility spaces'),
('Northgate Prison Annex', '900 State Road', 'Dannemora', 'NY', 'Former Prison', 'Extreme', 'Decommissioned correctional annex with controlled access'),
('Whispering Pines Cabin', '12 Ridge Trail', 'Catskill', 'NY', 'Cabin', 'Moderate', 'Remote cabin used for overnight observation'),
('Greyhaven Station', '5 Depot Street', 'Amsterdam', 'NY', 'Rail Station', 'Moderate', 'Historic passenger station no longer in regular service'),
('Starlight Sanitarium', '77 Summit Avenue', 'Glens Falls', 'NY', 'Former Sanitarium', 'Extreme', 'Large institutional building with several inaccessible sections'),
('Coldwater Farmhouse', '104 County Route 6', 'Cobleskill', 'NY', 'Farmhouse', 'High', 'Rural farmhouse with barn and cellar structures'),
('Bellweather Hotel', '201 Market Square', 'Poughkeepsie', 'NY', 'Historic Hotel', 'High', 'Multi-floor hotel with documented reports from staff and guests'),
('Shadow Lake Boathouse', '19 Lakeside Drive', 'Cooperstown', 'NY', 'Boathouse', 'Moderate', 'Isolated lakeside structure used primarily during warmer months'),
('Briar Chapel', '8 Chapel Hill Road', 'Ballston Spa', 'NY', 'Chapel', 'High', 'Small historic chapel with attached burial grounds'),
('Ironwood Mine', '430 Quarry Road', 'Plattsburgh', 'NY', 'Abandoned Mine', 'Extreme', 'Restricted underground site requiring additional safety precautions'),
('Lantern House Museum', '33 Heritage Lane', 'Bennington', 'VT', 'Museum', 'Moderate', 'Historic museum containing preserved residential rooms'),
('Frost Hollow Library', '17 College Street', 'Burlington', 'VT', 'Library', 'Low', 'Public historic library with reported after-hours sounds'),
('Cedar Ridge Observatory', '200 Ridge View Road', 'Pittsfield', 'MA', 'Observatory', 'Moderate', 'Remote observatory with limited nighttime staffing');


-- =========================================================
-- INVESTIGATOR
-- 20 tuples
-- =========================================================

INSERT INTO Investigator
(first_name, last_name, email, specialty, experience_years, active_status)
VALUES
('Maya', 'Bennett', 'maya.bennett@expedition.test', 'Lead Investigator', 11, TRUE),
('Ethan', 'Cole', 'ethan.cole@expedition.test', 'Environmental Monitoring', 7, TRUE),
('Nora', 'Hayes', 'nora.hayes@expedition.test', 'Audio Analysis', 8, TRUE),
('Julian', 'Price', 'julian.price@expedition.test', 'Video Analysis', 5, TRUE),
('Sofia', 'Reed', 'sofia.reed@expedition.test', 'Historical Research', 9, TRUE),
('Marcus', 'Stone', 'marcus.stone@expedition.test', 'Technical Specialist', 12, TRUE),
('Elena', 'Brooks', 'elena.brooks@expedition.test', 'Photography', 6, TRUE),
('Caleb', 'Ward', 'caleb.ward@expedition.test', 'Environmental Monitoring', 4, TRUE),
('Avery', 'Morgan', 'avery.morgan@expedition.test', 'Audio Analysis', 10, TRUE),
('Liam', 'Foster', 'liam.foster@expedition.test', 'Safety Coordinator', 13, TRUE),
('Grace', 'Ellis', 'grace.ellis@expedition.test', 'Historical Research', 7, TRUE),
('Noah', 'Turner', 'noah.turner@expedition.test', 'Video Analysis', 3, TRUE),
('Chloe', 'Parker', 'chloe.parker@expedition.test', 'Data Analysis', 6, TRUE),
('Isaac', 'Rivera', 'isaac.rivera@expedition.test', 'Technical Specialist', 8, TRUE),
('Mila', 'Ross', 'mila.ross@expedition.test', 'Photography', 5, TRUE),
('Owen', 'Bailey', 'owen.bailey@expedition.test', 'Lead Investigator', 14, TRUE),
('Layla', 'Cooper', 'layla.cooper@expedition.test', 'Environmental Monitoring', 6, TRUE),
('Henry', 'Diaz', 'henry.diaz@expedition.test', 'Audio Analysis', 9, TRUE),
('Zoe', 'Peterson', 'zoe.peterson@expedition.test', 'Historical Research', 4, TRUE),
('Miles', 'Grant', 'miles.grant@expedition.test', 'Technical Specialist', 7, TRUE);


-- =========================================================
-- EQUIPMENT
-- 20 tuples
-- =========================================================

INSERT INTO Equipment
(equipment_name, equipment_type, manufacturer, serial_number, operational_status, legacy_code)
VALUES
('EMF Meter Alpha', 'EMF Meter', 'SpecterTech', 'ST-EMF-001', 'Available', 'LEG-001'),
('EMF Meter Bravo', 'EMF Meter', 'SpecterTech', 'ST-EMF-002', 'Available', 'LEG-002'),
('Thermal Camera One', 'Thermal Camera', 'ThermaSight', 'TS-TH-101', 'Available', 'LEG-003'),
('Thermal Camera Two', 'Thermal Camera', 'ThermaSight', 'TS-TH-102', 'Maintenance', 'LEG-004'),
('Digital Recorder A', 'Audio Recorder', 'EchoField', 'EF-AU-201', 'Available', 'LEG-005'),
('Digital Recorder B', 'Audio Recorder', 'EchoField', 'EF-AU-202', 'Available', 'LEG-006'),
('Infrared Camera A', 'Infrared Camera', 'NightWatch', 'NW-IR-301', 'Available', 'LEG-007'),
('Infrared Camera B', 'Infrared Camera', 'NightWatch', 'NW-IR-302', 'Available', 'LEG-008'),
('REM Sensor One', 'Proximity Sensor', 'SpecterTech', 'ST-REM-401', 'Available', 'LEG-009'),
('REM Sensor Two', 'Proximity Sensor', 'SpecterTech', 'ST-REM-402', 'Available', 'LEG-010'),
('Motion Grid A', 'Motion Sensor', 'NightWatch', 'NW-MG-501', 'Available', 'LEG-011'),
('Motion Grid B', 'Motion Sensor', 'NightWatch', 'NW-MG-502', 'Available', 'LEG-012'),
('Temperature Logger A', 'Temperature Logger', 'EnviroTrack', 'ET-TL-601', 'Available', 'LEG-013'),
('Temperature Logger B', 'Temperature Logger', 'EnviroTrack', 'ET-TL-602', 'Available', 'LEG-014'),
('Geiger Counter A', 'Radiation Meter', 'RadSafe', 'RS-GC-701', 'Available', 'LEG-015'),
('Static Camera One', 'Video Camera', 'NightWatch', 'NW-SC-801', 'Available', 'LEG-016'),
('Static Camera Two', 'Video Camera', 'NightWatch', 'NW-SC-802', 'Assigned', 'LEG-017'),
('Barometric Sensor', 'Environmental Sensor', 'EnviroTrack', 'ET-BS-901', 'Available', 'LEG-018'),
('Laser Grid Projector', 'Optical Sensor', 'SpecterTech', 'ST-LG-1001', 'Available', 'LEG-019'),
('Full Spectrum Camera', 'Full Spectrum Camera', 'NightWatch', 'NW-FS-1101', 'Available', 'LEG-020');


-- =========================================================
-- EXPEDITION
-- 20 tuples
-- =========================================================

INSERT INTO Expedition
(expedition_name, location_id, start_date, end_date, status, objective)
VALUES
('Blackwood Night Survey', 1, '2026-01-10', '2026-01-11', 'Completed', 'Document reported nighttime movement and electromagnetic changes'),
('Hollow Creek Baseline', 2, '2026-01-24', '2026-01-25', 'Completed', 'Establish environmental and audio baselines throughout the former hospital'),
('Ravenswood Stage Watch', 3, '2026-02-07', '2026-02-08', 'Completed', 'Monitor stage and backstage areas during closed hours'),
('Pine Barrens Overnight', 4, '2026-02-21', '2026-02-22', 'Completed', 'Conduct overnight environmental monitoring throughout the lodge'),
('Wraith Hill Observation', 5, '2026-03-07', '2026-03-08', 'Completed', 'Compare visual observations with recorded environmental measurements'),
('Ashcroft Mill Survey', 6, '2026-03-21', '2026-03-22', 'Completed', 'Investigate recurring sound reports within the former mill'),
('Moonfall Guest Wing Study', 7, '2026-04-04', '2026-04-05', 'Completed', 'Monitor reported activity in the historic guest wing'),
('Red Lantern Classroom Study', 8, '2026-04-18', '2026-04-19', 'Completed', 'Record audio and temperature changes in selected classrooms'),
('Northgate Corridor Watch', 9, '2026-05-02', '2026-05-03', 'Completed', 'Document activity reports from the former cell corridor'),
('Whispering Pines Overnight', 10, '2026-05-16', '2026-05-17', 'Completed', 'Perform controlled overnight observation in the remote cabin'),
('Greyhaven Platform Survey', 11, '2026-05-30', '2026-05-31', 'Completed', 'Investigate recurring sound reports near the historic platform'),
('Starlight Ward Study', 12, '2026-06-13', '2026-06-14', 'Completed', 'Evaluate environmental changes in accessible former patient wards'),
('Coldwater Farm Investigation', 13, '2026-06-27', '2026-06-28', 'Completed', 'Compare farmhouse and barn activity reports using synchronized equipment'),
('Bellweather Floor Four Study', 14, '2026-07-11', '2026-07-12', 'Completed', 'Document reported activity on the fourth floor'),
('Shadow Lake Night Watch', 15, '2026-07-25', '2026-07-26', 'Completed', 'Monitor the boathouse during low-traffic overnight hours'),
('Briar Chapel Survey', 16, '2026-08-08', '2026-08-09', 'Completed', 'Record environmental and audio conditions inside the chapel'),
('Ironwood Entry Study', 17, '2026-08-22', '2026-08-23', 'Completed', 'Survey safe accessible sections near the mine entrance'),
('Lantern House Museum Watch', 18, '2026-09-12', NULL, 'Active', 'Conduct extended monitoring in preserved residential rooms'),
('Frost Hollow After-Hours Study', 19, '2026-11-14', NULL, 'Planned', 'Establish baseline measurements during after-hours access'),
('Cedar Ridge Sky Watch', 20, '2026-11-28', NULL, 'Planned', 'Monitor environmental anomalies reported near the observatory');


-- =========================================================
-- EXPEDITION INVESTIGATOR
-- 25 tuples
-- =========================================================

INSERT INTO ExpeditionInvestigator
(expedition_id, investigator_id, team_role, hours_assigned)
VALUES
(1, 1, 'Lead Investigator', 12.00),
(1, 2, 'Environmental Specialist', 10.00),
(2, 2, 'Environmental Specialist', 12.00),
(2, 3, 'Audio Specialist', 11.00),
(3, 4, 'Video Specialist', 9.00),
(4, 5, 'Research Coordinator', 10.00),
(5, 6, 'Technical Specialist', 11.00),
(5, 7, 'Photographer', 8.00),
(6, 8, 'Environmental Specialist', 9.00),
(7, 9, 'Audio Specialist', 10.00),
(8, 10, 'Safety Coordinator', 10.00),
(9, 11, 'Research Coordinator', 9.00),
(10, 12, 'Video Specialist', 11.00),
(11, 13, 'Data Analyst', 8.00),
(12, 14, 'Technical Specialist', 12.00),
(13, 15, 'Photographer', 10.00),
(14, 16, 'Lead Investigator', 12.00),
(15, 17, 'Environmental Specialist', 9.00),
(16, 18, 'Audio Specialist', 10.00),
(17, 19, 'Research Coordinator', 9.00),
(18, 20, 'Technical Specialist', 12.00),
(18, 1, 'Lead Investigator', 12.00),
(19, 2, 'Environmental Specialist', 10.00),
(20, 3, 'Audio Specialist', 10.00),
(20, 4, 'Video Specialist', 10.00);


-- =========================================================
-- EXPEDITION EQUIPMENT
-- 25 tuples
-- =========================================================

INSERT INTO ExpeditionEquipment
(expedition_id, equipment_id, checkout_time, return_time, condition_out, condition_in)
VALUES
(1, 1, '2026-01-10 18:00:00', '2026-01-11 06:00:00', 'Good', 'Good'),
(1, 2, '2026-01-10 18:05:00', '2026-01-11 06:05:00', 'Good', 'Good'),
(2, 3, '2026-01-24 18:00:00', '2026-01-25 06:30:00', 'Good', 'Good'),
(2, 4, '2026-01-24 18:10:00', '2026-01-25 06:20:00', 'Good', 'Needs Inspection'),
(3, 5, '2026-02-07 19:00:00', '2026-02-08 05:30:00', 'Good', 'Good'),
(4, 6, '2026-02-21 17:45:00', '2026-02-22 07:00:00', 'Good', 'Good'),
(5, 7, '2026-03-07 18:15:00', '2026-03-08 05:45:00', 'Good', 'Good'),
(5, 8, '2026-03-07 18:20:00', '2026-03-08 05:50:00', 'Good', 'Good'),
(6, 9, '2026-03-21 18:30:00', '2026-03-22 06:10:00', 'Good', 'Good'),
(7, 10, '2026-04-04 19:00:00', '2026-04-05 05:40:00', 'Good', 'Good'),
(8, 11, '2026-04-18 18:00:00', '2026-04-19 06:00:00', 'Good', 'Good'),
(9, 12, '2026-05-02 18:30:00', '2026-05-03 05:30:00', 'Good', 'Good'),
(10, 13, '2026-05-16 17:30:00', '2026-05-17 07:10:00', 'Good', 'Good'),
(11, 14, '2026-05-30 18:15:00', '2026-05-31 05:45:00', 'Good', 'Good'),
(12, 15, '2026-06-13 17:45:00', '2026-06-14 06:15:00', 'Good', 'Good'),
(13, 16, '2026-06-27 18:00:00', '2026-06-28 06:30:00', 'Good', 'Good'),
(14, 17, '2026-07-11 18:10:00', '2026-07-12 06:10:00', 'Good', 'Good'),
(15, 18, '2026-07-25 18:30:00', '2026-07-26 06:30:00', 'Good', 'Good'),
(16, 19, '2026-08-08 17:50:00', '2026-08-09 06:00:00', 'Good', 'Good'),
(17, 20, '2026-08-22 16:30:00', '2026-08-23 05:30:00', 'Good', 'Good'),
(18, 1, '2026-09-12 17:30:00', NULL, 'Good', NULL),
(18, 3, '2026-09-12 17:35:00', NULL, 'Good', NULL),
(19, 4, '2026-11-14 17:00:00', NULL, 'Good', NULL),
(20, 5, '2026-11-28 16:30:00', NULL, 'Good', NULL),
(20, 6, '2026-11-28 16:35:00', NULL, 'Good', NULL);


-- =========================================================
-- EVIDENCE
-- 25 tuples
-- =========================================================

INSERT INTO Evidence
(expedition_id, investigator_id, equipment_id, evidence_type, captured_at, file_reference, credibility_score, notes)
VALUES
(1, 1, 1, 'EMF Spike', '2026-01-10 22:14:00', 'evidence/exp01/emf_001.csv', 6, 'Short electromagnetic increase recorded in the east hallway'),
(1, 2, NULL, 'Visual Observation', '2026-01-10 23:02:00', NULL, 4, 'Movement reported near the upper landing without corresponding sensor activity'),
(2, 2, 3, 'Thermal Anomaly', '2026-01-24 21:45:00', 'evidence/exp02/thermal_001.jpg', 7, 'Localized temperature difference detected near an unused doorway'),
(2, 3, 4, 'Thermal Anomaly', '2026-01-24 23:18:00', 'evidence/exp02/thermal_002.jpg', 5, 'Second thermal irregularity recorded near the former nurses station'),
(3, 4, 5, 'Audio Event', '2026-02-07 22:36:00', 'evidence/exp03/audio_001.wav', 6, 'Distinct sound captured after the theater had been cleared'),
(4, 5, 6, 'Audio Event', '2026-02-21 23:11:00', 'evidence/exp04/audio_001.wav', 5, 'Low-frequency sound recorded from the northern hallway'),
(5, 6, 7, 'Visual Anomaly', '2026-03-07 21:28:00', 'evidence/exp05/video_001.mp4', 7, 'Unidentified movement appeared briefly at the edge of the frame'),
(5, 7, NULL, 'Visual Observation', '2026-03-07 22:03:00', NULL, 4, 'Investigator reported a brief shadow near the western path'),
(6, 8, 9, 'Proximity Event', '2026-03-21 23:47:00', 'evidence/exp06/sensor_001.csv', 6, 'Proximity sensor activated with no team member inside the monitored zone'),
(7, 9, 10, 'Proximity Event', '2026-04-04 22:52:00', 'evidence/exp07/sensor_001.csv', 5, 'Two short activations occurred within approximately one minute'),
(8, 10, 11, 'Motion Event', '2026-04-18 21:34:00', 'evidence/exp08/motion_001.csv', 7, 'Motion grid registered movement after the classroom was secured'),
(9, 11, 12, 'Motion Event', '2026-05-02 23:16:00', 'evidence/exp09/motion_001.csv', 6, 'Brief movement registered in the former corridor'),
(10, 12, 13, 'Temperature Change', '2026-05-16 22:40:00', 'evidence/exp10/temp_001.csv', 8, 'Rapid localized temperature decline occurred without HVAC activity'),
(11, 13, 14, 'Temperature Change', '2026-05-30 21:55:00', 'evidence/exp11/temp_001.csv', 5, 'Temperature fluctuation recorded near the western platform entrance'),
(12, 14, 15, 'Radiation Reading', '2026-06-13 23:09:00', 'evidence/exp12/radiation_001.csv', 3, 'Minor reading increase remained within expected environmental variation'),
(13, 15, 16, 'Video Anomaly', '2026-06-27 22:17:00', 'evidence/exp13/video_001.mp4', 7, 'Unidentified light movement recorded near the barn entrance'),
(14, 16, 17, 'Video Anomaly', '2026-07-11 23:32:00', 'evidence/exp14/video_001.mp4', 8, 'Object movement captured in an unoccupied section of the corridor'),
(15, 17, 18, 'Pressure Change', '2026-07-25 22:44:00', 'evidence/exp15/barometric_001.csv', 4, 'Short pressure change recorded during otherwise stable conditions'),
(16, 18, 19, 'Optical Event', '2026-08-08 23:26:00', 'evidence/exp16/laser_001.mp4', 6, 'Laser grid briefly distorted without a visible person crossing the area'),
(17, 19, 20, 'Full Spectrum Image', '2026-08-22 21:38:00', 'evidence/exp17/fullspec_001.jpg', 5, 'Unusual reflection captured near the accessible mine entrance'),
(18, 20, 1, 'EMF Spike', '2026-09-12 22:08:00', 'evidence/exp18/emf_001.csv', 7, 'Repeated electromagnetic increase recorded in the preserved bedroom'),
(18, 1, 3, 'Thermal Anomaly', '2026-09-12 22:41:00', 'evidence/exp18/thermal_001.jpg', 8, 'Thermal difference remained visible across several consecutive frames'),
(3, 4, NULL, 'Visual Observation', '2026-02-07 23:04:00', NULL, 3, 'Investigator observed movement near the balcony but no equipment confirmed it'),
(6, 8, 9, 'Proximity Event', '2026-03-22 00:15:00', 'evidence/exp06/sensor_002.csv', 7, 'Second activation occurred after the monitored area had been cleared'),
(14, 16, 17, 'Video Anomaly', '2026-07-12 00:11:00', 'evidence/exp14/video_002.mp4', 6, 'Short unexplained movement recorded near the service stairwell');


-- =========================================================
-- VERIFY MINIMUM ROW COUNTS
-- =========================================================

SELECT 'Location' AS table_name, COUNT(*) AS row_count FROM Location
UNION ALL
SELECT 'Investigator', COUNT(*) FROM Investigator
UNION ALL
SELECT 'Equipment', COUNT(*) FROM Equipment
UNION ALL
SELECT 'Expedition', COUNT(*) FROM Expedition
UNION ALL
SELECT 'ExpeditionInvestigator', COUNT(*) FROM ExpeditionInvestigator
UNION ALL
SELECT 'ExpeditionEquipment', COUNT(*) FROM ExpeditionEquipment
UNION ALL
SELECT 'Evidence', COUNT(*) FROM Evidence;