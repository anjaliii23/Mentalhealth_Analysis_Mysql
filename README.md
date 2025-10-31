# 🎓 Mental Health Analysis of College Students (MySQL Project)

## 📘 Project Overview

This project explores the intricate relationship between **students’ lifestyle habits, academic performance, and mental health indicators** such as anxiety, stress, and resilience.
Using **MySQL** as the database engine, the project demonstrates how data-driven insights can support **college wellness programs** and **academic success initiatives**.

---

## 🎯 Objectives

* Design a **normalized relational database** to store multi-dimensional student data.
* Use **SQL queries** to identify patterns and correlations between lifestyle, academic performance, and mental health.
* Generate **actionable insights** that guide institutional interventions for student well-being.
* Strengthen **portfolio-level SQL and database design skills**.

---

## 🛠️ Tech Stack

| Component        | Description                                                |
| ---------------- | ---------------------------------------------------------- |
| **Database**     | MySQL 8.0+                                                 |
| **Interface**    | MySQL Workbench                                            |
| **Language**     | SQL                                                        |
| **Dataset Type** | Structured (Relational Tables)                             |
| **Source**       | Synthetic yet realistic dataset of Indian college students |

---

## 🧱 Database Design

The project consists of **five interconnected tables** linked via the `student_id` key.

| Table Name              | Description                                                 |
| ----------------------- | ----------------------------------------------------------- |
| **Students**            | Contains student demographics such as gender and department |
| **Lifestyle**           | Records daily habits — sleep, exercise, screen time         |
| **AcademicPerformance** | Tracks CGPA and academic stress levels                      |
| **MentalHealth**        | Measures anxiety and resilience scores                      |
| **SupportSystem**       | Captures family and mentor support perception               |

### 🔗 Schema Overview

All tables are connected through a **one-to-one relationship** using the `student_id` primary key.
*(Refer to the schema diagram in the project report for visual structure.)*

---

## ⚙️ Setup Instructions

1. **Download** the repository or `Students_MentalHealth_SQL_Kit.zip`.
2. **Open MySQL Workbench** and connect to your local MySQL server.
3. **Run the schema script** to create tables:

   ```sql
   SOURCE schema_mysql.sql;
   ```
4. **Import the datasets** into each table:

   ```sql
   LOAD DATA INFILE 'path_to/Students.csv'
   INTO TABLE students
   FIELDS TERMINATED BY ',' ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 ROWS;
   ```

   *(Repeat for all CSV files: Lifestyle, AcademicPerformance, MentalHealth, SupportSystem.)*
5. Once data is loaded, start executing analysis queries.

---

## 🧮 Key SQL Queries

### 🔹 1. Identify At-Risk Students

```sql
CREATE OR REPLACE VIEW at_risk_students AS
SELECT a.student_id, a.cgpa, a.academic_stress, l.sleep_hours, l.exercise_hours,
CASE
    WHEN a.cgpa < 6.5 OR a.academic_stress='High' OR l.sleep_hours < 6 OR l.exercise_hours < 1
    THEN 'At Risk' ELSE 'Normal' END AS risk_status
FROM academicperformance a
JOIN lifestyle l ON a.student_id = l.student_id;

-- Query the view
SELECT * FROM at_risk_students WHERE risk_status = 'At Risk';
```

---

### 🔹 2. Lifestyle vs. Mental Health Correlation

```sql
SELECT CASE
        WHEN l.exercise_hours >= 5 THEN 'High Exercise'
        WHEN l.exercise_hours BETWEEN 2 AND 4.9 THEN 'Moderate Exercise'
        ELSE 'Low Exercise'
       END AS exercise_level,
       AVG(m.anxiety_score) AS avg_anxiety,
       COUNT(*) AS student_count
FROM mentalhealth m
JOIN lifestyle l ON m.student_id = l.student_id
GROUP BY exercise_level;
```

---

### 🔹 3. Mentor Support vs. Academic Success

```sql
SELECT s.mentor_support, AVG(a.cgpa) AS avg_cgpa, COUNT(*) AS student_count
FROM academicperformance a
JOIN supportsystem s ON a.student_id = s.student_id
GROUP BY s.mentor_support;
```

---

## 💡 Insights & Findings

| Insight             | Finding                                                       | Recommendation                                                  |
| ------------------- | ------------------------------------------------------------- | --------------------------------------------------------------- |
| **Sleep & Stress**  | Students sleeping <6 hours had higher stress and lower CGPA.  | Conduct sleep hygiene workshops and stress management programs. |
| **Exercise Impact** | Higher exercise correlated with lower anxiety levels.         | Introduce regular campus fitness and wellness sessions.         |
| **Screen Time**     | Excessive screen time linked to reduced study hours.          | Promote digital well-being and focus strategies.                |
| **Mentor Support**  | Mentor guidance correlated with higher CGPA and lower stress. | Expand mentor-mentee engagement initiatives.                    |

---

## 📊 Deliverables

* `Students_MentalHealth_SQL_Kit.zip` — Dataset + Schema + Query Files
* `Students_MentalHealth_SQL_Report.pdf` — Project Report
* `.sql` — Schema and analysis queries
* `README.md` — Project documentation (this file)

---

## 🧠 Skills Demonstrated

* Database Design (Normalization, Keys, Relationships)
* Advanced SQL (JOINs, Aggregations, Views, CASE WHEN)
* Data Cleaning & Management
* Insight Generation from Structured Data
* Problem Solving & Analytical Thinking

---

## 🏁 Conclusion

This project demonstrates how **MySQL-based data analysis** can uncover insights about college students’ well-being by linking lifestyle, academic, and psychological variables.
It showcases **data analytics, database design, and critical thinking** skills suitable for academic or professional portfolios.

---

## 📬 Author

**Anjali Pandey**
📧 anjalipandey.23-4@gmail.com
💻 MCA Student | Aspiring Data Analyst | Passionate about using data for social impact
