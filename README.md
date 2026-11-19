# EECS447_Library_System

**Course:** EECS447: Database Systems — Fall 2026

**Instructor:** Professor Hossein Saiedian

**Team Name:** DataBASED

## Table of Contents

* [1. Vision Statement](#1-project-overview)
* [2. Team Organization](#2-team-organization)
* [3. Project Status](#3-project-status)
* [4. Repository Structure](#4-repository-structure)

## How to run

1. Connect to MySQL as the root user:

   ```bash
   mysql -u root < library_schema.sql
   mysql -u root < library_data.sql
   mysql -u root
   ```

2. When prompted for a password, press `Enter`.

## 1. Project Overview

The Library database system is a database project designed to manage the operations of a library. The system stores, tracks, and generates reports of books, magazines, digital media,
client memberships, current loans, and more. The intended users for this system are Library staff and Clients. They will be able to manage item availability, client accounts,
borrowing and returning transactions, reservations, and late fees. It will even restrict the certain actions for Client users depending on their membership and loan status.
The project will follow the process and contain all artifacts/designs of the database from Domain modeling, Conceptual design, Logical design, to Physical Design and Data Population.

## 2. Team Organization

* **Team Administrator:** Kegan Firey

|Team Member|Contact Info|Role(s)|Availability|Computing platform experience|Programming language knowledge|
|---|---|---|---|---|---|
|Connor Eaton|connoreaton1o9@ku.edu|Developer|MWF 12pm-2pm, 3pm-5pm; TR 2pm-5pm|Windows, Linux|Python|
|Kegan Firey|keganf01@ku.edu|Team Administrator; Developer|MWF 9am-11am; WF 1pm-5pm; TR 4pm-5pm|Windows|Python, C++|
|Lydia Peng|lydia64peng@ku.edu|Developer|MWF 9am-1pm, 3pm-5pm; R 4pm-5pm|Windows, macOS|Python, C#, C++, HTML, JavaScript, SQL|
|Joseph Ubanda-Ruiz|jubanda@ku.edu|Developer|MWF 1pm-2pm, 3pm-4pm; T 12:15pm-4:00pm; R 12:15pm-2pm|Windows and macOS|Python, HTML, JavaScript, C, C++|

## 3. Project Status

* [x] Part 1: Vision Statement and Project Plan
* [x] Part 2: Domain Modeling and Requirements Engineering
* [x] Part 3: Conceptual Design (ER Diagram)
* [x] Part 4: Logical Design
* [x] Part 5: Physical Design and Data Population
* [ ] Part 6: Project Demonstration

## 4. Repository Structure

* `docs/` — design documents and deliverables (vision statement, ER diagrams, logical design)
* `src/` - SQL files and Physical Database design