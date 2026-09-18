# Core Banking System - SQL Backend Architecture

![MS SQL Server](https://img.shields.io/badge/MS_SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![T-SQL](https://img.shields.io/badge/T_SQL-005C84?style=for-the-badge)
![Python](https://img.shields.io/badge/Python_Data_Generation-3776AB?style=for-the-badge&logo=python&logoColor=white)

## The Problem and the Solution

In modern financial systems, relying entirely on the application backend to handle data integrity often leads to severe vulnerabilities. When multiple concurrent transactions occur, application-level checks can fail due to race conditions, leading to partial updates, negative balances, or inconsistent audit trails.

This project was built to solve that exact problem by shifting the ultimate responsibility for data consistency down to the database engine itself. The architecture guarantees that no matter what application connects to the database, the fundamental rules of banking are enforced at the lowest possible level. This is achieved through ACID-compliant transaction blocks, strict data validation constraints, and an immutable JSON audit log managed entirely by internal triggers.

## Core Features and Technical Highlights

* ACID-Compliant Transactions: The sp_make_transfer stored procedure operates as the heart of the system. It utilizes BEGIN TRAN, COMMIT, and ROLLBACK blocks wrapped in TRY...CATCH error handling to ensure multi-step account updates are perfectly atomic.
* JSON Audit Trail and Trigger Management: An immutable audit logging system captures the exact old and new states of modified records and serializes them into JSON. To prevent infinite loops and redundant logging during automated timestamp updates, the triggers implement TRIGGER_NESTLEVEL() and UPDATE() validations.
* Advanced Analytical Views: Reporting layers utilize SQL Window Functions (e.g., v_corporate_holding_balances) to calculate hierarchical account balances for corporate clients without unnecessary data duplication.
* Strict Data Integrity: The schema enforces business rules through CHECK constraints, strictly preventing negative transfers, validating allowed transaction types, and enforcing exact IBAN string requirements.

## Database Schema Overview

* customers: Stores client data with hierarchical structures for corporate entities (parent_company_id).
* accounts: Manages balances and account statuses. System timestamps (updated_at) are maintained by isolated database triggers.
* transactions: The financial ledger, highly controlled by constraints requiring valid IBANs and specific transaction states.
* audit_logs: A write-only table storing serialized JSON snapshots of updates applied to critical business tables.

## Technical Stack

* RDBMS: Microsoft SQL Server
* Language: Transact-SQL (T-SQL)
* Testing: Python (Faker library) used for generating realistic mock data to test performance and window functions.
* Version Control: Git / GitHub

## Setup Instructions

1. Execute the scripts in the sql_tables directory to initialize the base schema.
2. Run the scripts in sql_triggers_and_constraints to enforce business rules and auditing logic.
3. Deploy the objects from the sql_views and sql_functions directories.
4. Execute the Python seeder script to populate the database with mock entities for testing.