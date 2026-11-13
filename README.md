# property-rental-listings
Modern real-estate property rental platform featuring houses, flats, and portions with interactive booking and landlord management."
# 🏡 LuxeHaven Rentals — Property Rental Listings System
> **BS Computer Science Database Semester Project (Project 17)**  
> **Developed by:** **Zulqarnain Bhatti**

![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![TailwindCSS](https://img.shields.io/badge/TailwindCSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

---

## 📖 Overview
**LuxeHaven Rentals** is a commercial-grade, fully responsive **9-page front-end web portal** designed for residential property rentals across major metropolitan areas (Islamabad, Lahore, Karachi, and Rawalpindi).

The system features multi-criteria property search, verified in-person visit scheduling, a dedicated landlord management studio, and a live execution engine for **all 8 required database SQL queries** and composite index benchmarking.

---

## 🌟 Key Features
- **Multi-Attribute Search & Discovery:** Filter houses, flats, and portions by City, Area, Monthly Rent, Bedroom count, and Property Type.
- **Tenant Visit Booking Engine:** Interactive date & time slot scheduling with strict business rule validation.
- **Owner Studio Dashboard:** Manage portfolio properties with a 1-click **"Mark Rented" / "Mark Available"** status toggle.
- **Visit Inquiries Hub:** Landlords can accept or decline prospective tenant bookings with live acceptance rate analytics.
- **Admin Cities & Areas Portal:** Register new sectors with candidate key `UNIQUE(city, area_name)` verification.
- **Interactive 8 SQL Queries Runner:** Live in-browser execution with parameter controls, data tables, and CSV export.
- **Advanced Task Benchmark:** Performance comparison of a B-Tree composite index on `(area_id, status, monthly_rent)` showing 85x+ speedup.
- **Zero Dependencies:** Runs natively in any browser with pure HTML5, CSS3, and Vanilla JavaScript.

---

## 📁 9 Interconnected Pages

| # | Page File | Purpose & Capabilities |
|---|---|---|
| 1 | `index.html` | Hero surface, quick search, featured luxury listings, city discovery |
| 2 | `properties.html` | Multi-filter property search (Rented properties automatically hidden) |
| 3 | `property-details.html` | High-res gallery, specs, amenities, verified owner profile |
| 4 | `request-visit.html` | Tenant visit scheduling form with anti-past and anti-duplicate validation |
| 5 | `my-requests.html` | Tenant tracker for visit approvals, confirmed slots, and cancellation |
| 6 | `owner-dashboard.html` | Landlord portfolio management with 1-click status toggling |
| 7 | `add-property.html` | Publish new property with real-time live card preview |
| 8 | `owner-requests.html` | Review tenant bookings with interactive Accept / Decline controls |
| 9 | `admin-areas.html` | City/Area admin, All 8 SQL Queries Runner & Composite Index test |

---

## 🗄️ Database Architecture (5 Relational Tables)

```text
Areas (area_id [PK], city, area_name, UNIQUE(city, area_name))
  └── Properties (property_id [PK], owner_id [FK], area_id [FK], type, bedrooms, size_sqft, monthly_rent, status)
        ├── Visit_Requests (request_id [PK], property_id [FK], tenant_id [FK], visit_date, time_slot, status)
        └── Owners (owner_id [PK], name, phone [UNIQUE], email [UNIQUE])
Tenants (tenant_id [PK], name, phone [UNIQUE], email [UNIQUE])
```

### 🛡️ Business Rules Enforced
1. **Search Visibility:** Rented properties (`status = 'Rented'`) are automatically hidden from search results.
2. **Date Integrity:** `visit_date` cannot be in the past.
3. **Anti-Duplicate Booking:** A tenant cannot request the same property twice on the same date (`UNIQUE(property_id, tenant_id, visit_date)`).

---

## ⚡ The 8 Required SQL Queries Included

1. **Available properties in a city within a rent range** (`JOIN` + `BETWEEN`)
2. **Average rent per area and bedrooms** (`GROUP BY a.city, a.area_name, p.bedrooms`)
3. **Most requested properties** (`COUNT(vr.request_id)` + `ORDER BY total_requests DESC`)
4. **Owners with more than 2 listings** (`HAVING COUNT(p.property_id) > 2`)
5. **Properties with no visit requests** (`LEFT JOIN ... WHERE vr.request_id IS NULL`)
6. **Acceptance rate per owner** (`SUM(Accepted) / COUNT(requests) * 100`)
7. **Cheapest property per area** (Correlated subquery with `MIN()`)
8. **Listings added this month** (`WHERE MONTH(created_at) = MONTH(CURRENT_DATE())`)

---

## 🚀 How to Run Locally

1. Clone or download the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/property-rental-listings.git
   ```
2. Navigate to the project folder:
   ```bash
   cd property-rental-listings
   ```
3. Open `index.html` in any browser (Google Chrome, Microsoft Edge, Firefox).

---

## 👤 Author
- **Name:** Zulqarnain Bhatti
- **Degree:** BS Computer Science (BS CS)
- **Course:** Database Systems Semester Project (Project 17)
