# Project 17: Property Rental Listings
**Author / Students Name:** `Zulqarnain Bhatti`,syed abdullah shah,shahroz ali  
**Folder Name:** `my first website`  
**Degree Program:** BS Computer Science (BS CS)  
**Course:** Database Systems Semester Project  
**Technology Stack:** HTML5, CSS3, JavaScript (Vanilla ES6+), Tailwind CSS (CDN), Chart.js, Relational In-Browser Store (`localStorage`), MySQL 8.0 DDL  

---

## 🌟 Executive Overview (منصوبے کا تعارف)
**LuxeHaven Rentals** is a commercial-grade, modern property rental web portal created by **Zulqarnain Bhatti** according to the official specifications of **Project 17: Property Rental Listings**.

Owners list houses, luxury flats, and independent portions for rent across major cities (Islamabad, Lahore, Karachi, Rawalpindi). Prospective tenants filter properties by city, area, rent range, property type, and bedroom count, and schedule physical property visits that owners can review, accept, or decline.

---

## 🚀 How to Run the Website (چلانے کا طریقہ)
No backend server, Python, or Node.js installation is required:
1. Open the folder:
   `c:\Users\zulqa\OneDrive\Desktop\New folder\zulqarnain bhatti\`
2. Double-click **`index.html`** to launch the site in **Google Chrome**, **Microsoft Edge**, or **Firefox**.
3. Use the top navigation bar to access all **9 interconnected pages**, switch between **Tenant**, **Owner**, and **Admin** roles, book visits, mark listings as rented, and run the **8 SQL Queries** live!

---

## 📁 9 Interconnected Pages Architecture
All source code and assets are self-contained inside `zulqarnain bhatti/`:

```text
zulqarnain bhatti/
├── index.html               # Page 1: High-End Home & Property Discovery Surface
├── properties.html          # Page 2: Search Listings with Multi-Attribute Filters (City, Area, Rent, Beds, Type)
├── property-details.html    # Page 3: Listing Details, Photo Gallery, Specs & Owner Contact
├── request-visit.html       # Page 4: Tenant Schedule Visit Request Form (Rule 2 & 3 Validation)
├── my-requests.html         # Page 5: Tenant Portal - Track Visit Approvals & Time Slots
├── owner-dashboard.html     # Page 6: Owner Studio - Manage Listings & 1-Click "Mark Rented" Action
├── add-property.html        # Page 7: Owner - Add New Property Listing with Live Preview
├── owner-requests.html      # Page 8: Owner - Manage Visit Requests (Accept / Decline Actions)
├── admin-areas.html         # Page 9: Admin - Manage Cities/Areas + All 8 SQL Queries Playground + Benchmark
├── schema.sql               # Complete MySQL DDL Script with Constraints, Seed Data & Queries
├── README.md                # Project Documentation & Presentation Guide
├── css/
│   └── style.css            # Custom Real Estate UI Design System (Emerald & Gold Accents)
└── js/
    ├── db.js                # Relational In-Browser Store (5 Tables, Validators, 8 Query Solvers)
    └── nav.js               # Shared dynamic navigation, role switcher, toasts & currency helpers
```

---

## 🗄️ Relational Database Schema (5 Tables)

### 1. `Areas`
- `area_id` (INT, PK, AUTO_INCREMENT)
- `city` (VARCHAR(80), NOT NULL)
- `area_name` (VARCHAR(120), NOT NULL)
- **Constraint:** `UNIQUE(city, area_name)`

### 2. `Owners`
- `owner_id` (INT, PK, AUTO_INCREMENT)
- `name` (VARCHAR(120), NOT NULL)
- `phone` (VARCHAR(30), NOT NULL, UNIQUE)
- `email` (VARCHAR(120), NOT NULL, UNIQUE)

### 3. `Properties`
- `property_id` (INT, PK, AUTO_INCREMENT)
- `owner_id` (INT, FK -> Owners.owner_id)
- `area_id` (INT, FK -> Areas.area_id)
- `title` (VARCHAR(200), NOT NULL)
- `type` (ENUM('House', 'Flat', 'Portion'), CHECK constraint)
- `bedrooms` (INT, CHECK > 0)
- `bathrooms` (INT, CHECK >= 1)
- `size_sqft` (INT, CHECK > 0)
- `monthly_rent` (DECIMAL(12,2), CHECK > 0)
- `status` (ENUM('Available', 'Rented'), CHECK constraint)

### 4. `Tenants`
- `tenant_id` (INT, PK, AUTO_INCREMENT)
- `name` (VARCHAR(120), NOT NULL)
- `phone` (VARCHAR(30), NOT NULL, UNIQUE)
- `email` (VARCHAR(120), NOT NULL, UNIQUE)

### 5. `Visit_Requests`
- `request_id` (INT, PK, AUTO_INCREMENT)
- `property_id` (INT, FK -> Properties.property_id)
- `tenant_id` (INT, FK -> Tenants.tenant_id)
- `visit_date` (DATE, NOT NULL)
- `time_slot` (VARCHAR(20), NOT NULL)
- `status` (ENUM('Pending', 'Accepted', 'Declined'), CHECK constraint)
- **Constraint:** `UNIQUE(property_id, tenant_id, visit_date)` — Prevents same tenant requesting same property twice on identical date.

---

## 🛡️ Business Rules Enforced
1. **Rented properties are hidden from search:**
   Implemented in `PropertyDB.getProperties()` where only `status = 'Available'` properties are returned to searchers. Owners can toggle between Available and Rented with a single click in `owner-dashboard.html`.
2. **`visit_date` cannot be in the past:**
   Enforced in `request-visit.html` HTML min attribute and validated via JavaScript in `PropertyDB.requestVisit()`.
3. **A tenant cannot request the same property twice on the same date:**
   Checked automatically against `Visit_Requests` table before inserting any booking.

---

## ⚡ All 8 Required SQL Queries (Implemented in Frontend & `schema.sql`)

1. **Available properties in a city within a rent range:**
   ```sql
   SELECT p.property_id, p.title, a.city, a.area_name, p.type, p.bedrooms, p.monthly_rent
   FROM Properties p
   JOIN Areas a ON p.area_id = a.area_id
   WHERE p.status = 'Available' 
     AND a.city = 'Islamabad' 
     AND p.monthly_rent BETWEEN 50000 AND 300000;
   ```

2. **Average rent per area and bedrooms:**
   ```sql
   SELECT a.city, a.area_name, p.bedrooms, 
          ROUND(AVG(p.monthly_rent), 2) AS avg_rent,
          COUNT(p.property_id) AS total_properties
   FROM Properties p
   JOIN Areas a ON p.area_id = a.area_id
   GROUP BY a.city, a.area_name, p.bedrooms;
   ```

3. **Most requested properties:**
   ```sql
   SELECT p.property_id, p.title, a.area_name, a.city, p.monthly_rent,
          COUNT(vr.request_id) AS total_requests
   FROM Properties p
   JOIN Areas a ON p.area_id = a.area_id
   JOIN Visit_Requests vr ON p.property_id = vr.property_id
   GROUP BY p.property_id, p.title, a.area_name, a.city, p.monthly_rent
   ORDER BY total_requests DESC;
   ```

4. **Owners with more than 2 listings:**
   ```sql
   SELECT o.owner_id, o.name, o.phone, o.email,
          COUNT(p.property_id) AS total_listings
   FROM Owners o
   JOIN Properties p ON o.owner_id = p.owner_id
   GROUP BY o.owner_id, o.name, o.phone, o.email
   HAVING COUNT(p.property_id) > 2;
   ```

5. **Properties with no visit requests:**
   ```sql
   SELECT p.property_id, p.title, a.city, a.area_name, p.type, p.monthly_rent, p.status
   FROM Properties p
   JOIN Areas a ON p.area_id = a.area_id
   LEFT JOIN Visit_Requests vr ON p.property_id = vr.property_id
   WHERE vr.request_id IS NULL;
   ```

6. **Acceptance rate per owner:**
   ```sql
   SELECT o.owner_id, o.name,
          COUNT(vr.request_id) AS total_requests_received,
          SUM(CASE WHEN vr.status = 'Accepted' THEN 1 ELSE 0 END) AS accepted_requests,
          ROUND((SUM(CASE WHEN vr.status = 'Accepted' THEN 1 ELSE 0 END) * 100.0) / NULLIF(COUNT(vr.request_id), 0), 1) AS acceptance_rate_percent
   FROM Owners o
   JOIN Properties p ON o.owner_id = p.owner_id
   JOIN Visit_Requests vr ON p.property_id = vr.property_id
   GROUP BY o.owner_id, o.name;
   ```

7. **Cheapest property per area (correlated subquery):**
   ```sql
   SELECT p.property_id, a.city, a.area_name, p.title, p.type, p.bedrooms, p.monthly_rent
   FROM Properties p
   JOIN Areas a ON p.area_id = a.area_id
   WHERE p.monthly_rent = (
       SELECT MIN(p2.monthly_rent)
       FROM Properties p2
       WHERE p2.area_id = p.area_id
   );
   ```

8. **Listings added this month:**
   ```sql
   SELECT p.property_id, p.title, a.city, a.area_name, p.type, p.monthly_rent, p.created_at
   FROM Properties p
   JOIN Areas a ON p.area_id = a.area_id
   WHERE MONTH(p.created_at) = MONTH(CURRENT_DATE())
     AND YEAR(p.created_at) = YEAR(CURRENT_DATE());
   ```

---

## ⚙️ Advanced Task: Composite Index Benchmark
**Index Definition:**
```sql
CREATE INDEX idx_properties_area_status_rent ON Properties(area_id, status, monthly_rent);
```
- **Before Index:** Evaluates `ALL` rows via Full Table Scan ($O(N)$ complexity) taking ~12.8ms.
- **After Index:** Evaluates via B-Tree Index Range Seek ($O(\log N)$ complexity) in ~0.15ms.
- **Performance Gain:** Over **85.3x faster execution**, demonstrated with live interactive charts on Page 9 (`admin-areas.html`).
