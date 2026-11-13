-- ============================================================================
-- BS CS Database Systems Semester Project 17: Property Rental Listings
-- Developed for / Author: Zulqarnain Bhatti
-- Target DBMS: MySQL 8.0+ / MariaDB 10.5+
-- ============================================================================

DROP DATABASE IF EXISTS luxehaven_rental_db;
CREATE DATABASE luxehaven_rental_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE luxehaven_rental_db;

-- ============================================================================
-- 1. TABLE CREATION WITH CONSTRAINTS & BUSINESS RULES
-- ============================================================================

-- Table 1: Areas
-- Constraint: UNIQUE(city, area_name)
CREATE TABLE Areas (
    area_id INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(80) NOT NULL,
    area_name VARCHAR(120) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_city_area UNIQUE (city, area_name)
) ENGINE=InnoDB;

-- Table 2: Owners
CREATE TABLE Owners (
    owner_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    phone VARCHAR(30) NOT NULL UNIQUE,
    email VARCHAR(120) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Table 3: Properties
-- Constraints: 
-- - type IN ('House', 'Flat', 'Portion')
-- - status IN ('Available', 'Rented')
CREATE TABLE Properties (
    property_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    area_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    type ENUM('House', 'Flat', 'Portion') NOT NULL,
    bedrooms INT NOT NULL CHECK (bedrooms > 0),
    bathrooms INT NOT NULL DEFAULT 1 CHECK (bathrooms >= 1),
    size_sqft INT NOT NULL CHECK (size_sqft > 0),
    monthly_rent DECIMAL(12, 2) NOT NULL CHECK (monthly_rent > 0),
    status ENUM('Available', 'Rented') NOT NULL DEFAULT 'Available',
    description TEXT NULL,
    created_at DATE NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_properties_owner FOREIGN KEY (owner_id) REFERENCES Owners(owner_id) ON DELETE CASCADE,
    CONSTRAINT fk_properties_area FOREIGN KEY (area_id) REFERENCES Areas(area_id) ON DELETE CASCADE,
    CONSTRAINT chk_property_type CHECK (type IN ('House', 'Flat', 'Portion')),
    CONSTRAINT chk_property_status CHECK (status IN ('Available', 'Rented'))
) ENGINE=InnoDB;

-- Table 4: Tenants
CREATE TABLE Tenants (
    tenant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    phone VARCHAR(30) NOT NULL UNIQUE,
    email VARCHAR(120) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Table 5: Visit_Requests
-- Constraints:
-- - status IN ('Pending', 'Accepted', 'Declined')
-- - Anti-duplicate: Tenant cannot request same property twice on the same date: UNIQUE(property_id, tenant_id, visit_date)
CREATE TABLE Visit_Requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT NOT NULL,
    tenant_id INT NOT NULL,
    visit_date DATE NOT NULL,
    time_slot VARCHAR(20) NOT NULL DEFAULT '11:00 AM',
    status ENUM('Pending', 'Accepted', 'Declined') NOT NULL DEFAULT 'Pending',
    notes TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_visit_property FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    CONSTRAINT fk_visit_tenant FOREIGN KEY (tenant_id) REFERENCES Tenants(tenant_id) ON DELETE CASCADE,
    CONSTRAINT chk_visit_status CHECK (status IN ('Pending', 'Accepted', 'Declined')),
    CONSTRAINT uq_tenant_prop_date UNIQUE (property_id, tenant_id, visit_date)
) ENGINE=InnoDB;

-- ============================================================================
-- 2. ADVANCED TASK: COMPOSITE INDEX SPECIFICATION
-- "A composite index on (area_id, status, monthly_rent) and a before/after timing test on the search query."
-- ============================================================================

CREATE INDEX idx_properties_area_status_rent ON Properties(area_id, status, monthly_rent);

-- ============================================================================
-- 3. SEED SAMPLE DATA
-- ============================================================================

-- Areas (Islamabad, Lahore, Karachi, Rawalpindi)
INSERT INTO Areas (area_id, city, area_name) VALUES
(1, 'Islamabad', 'Sector F-7/2'),
(2, 'Islamabad', 'Sector E-11/3'),
(3, 'Islamabad', 'DHA Phase 2'),
(4, 'Lahore', 'DHA Phase 5'),
(5, 'Lahore', 'Gulberg III'),
(6, 'Lahore', 'Model Town Block C'),
(7, 'Karachi', 'Clifton Block 2'),
(8, 'Karachi', 'DHA Phase 6'),
(9, 'Rawalpindi', 'Bahria Town Phase 7');

-- Owners
INSERT INTO Owners (owner_id, name, phone, email) VALUES
(1, 'Malik Zulqarnain Bhatti', '+92 300 8472910', 'zulqarnain.bhatti@estates.pk'),
(2, 'Chaudhry Tariq Mehmood', '+92 321 4589201', 'tariq.mehmood@realtors.pk'),
(3, 'Dr. Sarah Mansoor', '+92 333 5192847', 'sarah.mansoor@primeproperties.pk'),
(4, 'Engr. Imran Rasheed', '+92 345 9012384', 'imran.rasheed@apexestate.pk');

-- Tenants
INSERT INTO Tenants (tenant_id, name, phone, email) VALUES
(1, 'Hamza Abbasi', '+92 312 9845123', 'hamza.abbasi@gmail.com'),
(2, 'Zainab Fatima', '+92 301 7654321', 'zainab.fatima@techcorp.com'),
(3, 'Bilal Ahmed Khan', '+92 334 1122334', 'bilal.ahmed@investors.pk'),
(4, 'Ayesha Tariq', '+92 322 8899001', 'ayesha.tariq@designstudio.pk');

-- Properties
INSERT INTO Properties (property_id, owner_id, area_id, title, type, bedrooms, bathrooms, size_sqft, monthly_rent, status, created_at, description) VALUES
(1, 1, 1, 'Modern Designer 1-Kanal Luxury Villa with Garden', 'House', 5, 6, 4500, 280000.00, 'Available', '2026-11-01', 'Architect-designed 1-Kanal villa in Sector F-7/2 Islamabad.'),
(2, 1, 4, 'Ultra-Modern 3-Bedroom Executive Flat in Goldcrest', 'Flat', 3, 3, 2200, 140000.00, 'Available', '2026-11-03', 'High-floor luxury corner apartment in DHA Phase 5 Lahore.'),
(3, 1, 2, 'Independent Upper Portion with Scenic Margalla Views', 'Portion', 3, 3, 2000, 75000.00, 'Available', '2026-11-05', 'Spacious independent upper portion in Sector E-11/3 with private rooftop terrace.'),
(4, 2, 5, 'Chic Penthouse with Private Terrace & Jacuzzi', 'Flat', 4, 4, 3200, 220000.00, 'Available', '2026-11-02', 'Luxury duplex penthouse in Gulberg III Lahore near MM Alam Road.'),
(5, 2, 4, 'Spanish Style 10-Marla Double Story Bungalow', 'House', 4, 5, 2750, 165000.00, 'Rented', '2026-10-15', 'Spanish-style house in DHA Phase 5 Lahore. (Hidden from search).'),
(6, 3, 7, 'Sea-Facing 3-Bed Luxury Residence in Ocean Towers', 'Flat', 3, 3, 2400, 195000.00, 'Available', '2026-11-06', 'Direct Arabian Sea views in Clifton Block 2 Karachi.'),
(7, 3, 8, 'Ground Floor Independent Portion with Covered Porch', 'Portion', 2, 2, 1600, 90000.00, 'Available', '2026-11-07', 'Ground floor portion in DHA Phase 6 Karachi with 2-car covered porch.'),
(8, 4, 3, 'Magnificent 500 Sq Yds Corner Mansion', 'House', 6, 7, 5200, 320000.00, 'Available', '2026-11-08', 'Corner mansion in DHA Phase 2 Islamabad with indoor heated pool.'),
(9, 4, 9, 'Modern 2-Bed Luxury Apartment near River View', 'Flat', 2, 2, 1350, 55000.00, 'Available', '2026-11-09', 'Affordable luxury flat in Bahria Town Phase 7 Rawalpindi.'),
(10, 2, 6, 'Cosy 2-Bed Lower Portion in Model Town', 'Portion', 2, 2, 1400, 50000.00, 'Rented', '2026-10-20', 'Lower portion in Model Town Lahore. (Marked Rented).');

-- Visit Requests
INSERT INTO Visit_Requests (request_id, property_id, tenant_id, visit_date, time_slot, status, notes) VALUES
(1, 1, 1, '2026-11-20', '11:00 AM', 'Accepted', 'Tenant verified; owner agreed for Sunday morning tour.'),
(2, 1, 2, '2026-11-22', '03:00 PM', 'Pending', 'Awaiting owner schedule confirmation.'),
(3, 2, 1, '2026-11-18', '02:00 PM', 'Accepted', 'Gate pass issued to DHA Phase 5 reception.'),
(4, 4, 3, '2026-11-19', '05:00 PM', 'Accepted', 'Tenant looking for 2-year lease agreement.'),
(5, 4, 4, '2026-11-21', '04:30 PM', 'Declined', 'Owner travelling out of station during this slot.'),
(6, 6, 2, '2026-11-25', '12:00 PM', 'Pending', 'Tenant requesting weekend afternoon viewing.'),
(7, 8, 3, '2026-11-23', '01:00 PM', 'Accepted', 'Corporate executive viewing.'),
(8, 3, 4, '2026-11-17', '10:30 AM', 'Pending', 'Interested in separate electrical meter verification.');

-- ============================================================================
-- 4. ALL 8 REQUIRED SQL QUERIES (AS SPECIFIED IN PROJECT 17)
-- ============================================================================

-- Query 1: Available properties in a city within a rent range.
SELECT 
    p.property_id, 
    p.title, 
    a.city, 
    a.area_name, 
    p.type, 
    p.bedrooms, 
    p.monthly_rent
FROM Properties p
JOIN Areas a ON p.area_id = a.area_id
WHERE p.status = 'Available' 
  AND a.city = 'Islamabad' 
  AND p.monthly_rent BETWEEN 50000.00 AND 300000.00;

-- Query 2: Average rent per area and bedrooms.
SELECT 
    a.city, 
    a.area_name, 
    p.bedrooms, 
    ROUND(AVG(p.monthly_rent), 2) AS avg_rent,
    COUNT(p.property_id) AS total_properties
FROM Properties p
JOIN Areas a ON p.area_id = a.area_id
GROUP BY a.city, a.area_name, p.bedrooms;

-- Query 3: Most requested properties.
SELECT 
    p.property_id, 
    p.title, 
    a.area_name, 
    a.city, 
    p.monthly_rent,
    COUNT(vr.request_id) AS total_requests
FROM Properties p
JOIN Areas a ON p.area_id = a.area_id
JOIN Visit_Requests vr ON p.property_id = vr.property_id
GROUP BY p.property_id, p.title, a.area_name, a.city, p.monthly_rent
ORDER BY total_requests DESC;

-- Query 4: Owners with more than 2 listings.
SELECT 
    o.owner_id, 
    o.name, 
    o.phone, 
    o.email,
    COUNT(p.property_id) AS total_listings
FROM Owners o
JOIN Properties p ON o.owner_id = p.owner_id
GROUP BY o.owner_id, o.name, o.phone, o.email
HAVING COUNT(p.property_id) > 2;

-- Query 5: Properties with no visit requests.
SELECT 
    p.property_id, 
    p.title, 
    a.city, 
    a.area_name, 
    p.type, 
    p.monthly_rent, 
    p.status
FROM Properties p
JOIN Areas a ON p.area_id = a.area_id
LEFT JOIN Visit_Requests vr ON p.property_id = vr.property_id
WHERE vr.request_id IS NULL;

-- Query 6: Acceptance rate per owner.
SELECT 
    o.owner_id, 
    o.name,
    COUNT(vr.request_id) AS total_requests_received,
    SUM(CASE WHEN vr.status = 'Accepted' THEN 1 ELSE 0 END) AS accepted_requests,
    ROUND((SUM(CASE WHEN vr.status = 'Accepted' THEN 1 ELSE 0 END) * 100.0) / NULLIF(COUNT(vr.request_id), 0), 1) AS acceptance_rate_percent
FROM Owners o
JOIN Properties p ON o.owner_id = p.owner_id
JOIN Visit_Requests vr ON p.property_id = vr.property_id
GROUP BY o.owner_id, o.name;

-- Query 7: Cheapest property per area (correlated subquery).
SELECT 
    p.property_id, 
    a.city, 
    a.area_name, 
    p.title, 
    p.type, 
    p.bedrooms, 
    p.monthly_rent
FROM Properties p
JOIN Areas a ON p.area_id = a.area_id
WHERE p.monthly_rent = (
    SELECT MIN(p2.monthly_rent)
    FROM Properties p2
    WHERE p2.area_id = p.area_id
);

-- Query 8: Listings added this month.
SELECT 
    p.property_id, 
    p.title, 
    a.city, 
    a.area_name, 
    p.type, 
    p.monthly_rent, 
    p.created_at
FROM Properties p
JOIN Areas a ON p.area_id = a.area_id
WHERE MONTH(p.created_at) = MONTH(CURRENT_DATE())
  AND YEAR(p.created_at) = YEAR(CURRENT_DATE());
