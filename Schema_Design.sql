-- ============================================================
-- Schema_Design.sql
-- Restaurant Chain Management System
-- Introduction to Database Systems - BSSE, IIUI-ISB
-- Submitted To: Shakeel Ahmad
-- *** Converted for Oracle 10g ***
-- ============================================================

-- ============================================================
-- SECTION 1: DROP TABLES (in reverse dependency order)
--   Oracle does not support DROP TABLE IF EXISTS.
--   We use a PL/SQL block to silently ignore ORA-00942
--   (table does not exist) errors.
-- ============================================================

BEGIN EXECUTE IMMEDIATE 'DROP TABLE Order_Items';   EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Orders';         EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Reservations';   EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Inventory';      EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Menu_Items';     EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Menu_Categories';EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Employees';      EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Tables_Dining';  EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Branches';       EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Suppliers';      EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Customers';      EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- NOTE: TABLE was renamed from "Tables" to "Tables_Dining" because
--       TABLES is a reserved word in Oracle.

-- ============================================================
-- SECTION 2: TABLE CREATION
--   Oracle-specific changes:
--     - VARCHAR  -> VARCHAR2
--     - INT / DECIMAL -> NUMBER
--     - No GENERATED ALWAYS AS (computed column) support in
--       Oracle 10g. The subtotal column is a plain NUMBER and
--       is maintained by trigger trg_Order_Items_Subtotal
--       (defined in Business_Queries.sql).
-- ============================================================

-- Table: Customers
CREATE TABLE Customers (
    customer_id     NUMBER(10)      PRIMARY KEY,
    first_name      VARCHAR2(50)    NOT NULL,
    last_name       VARCHAR2(50)    NOT NULL,
    phone           VARCHAR2(15)    UNIQUE NOT NULL,
    email           VARCHAR2(100)   UNIQUE,
    loyalty_points  NUMBER(10)      DEFAULT 0 CHECK (loyalty_points >= 0),
    join_date       DATE            NOT NULL
);

-- Table: Suppliers
CREATE TABLE Suppliers (
    supplier_id     NUMBER(10)      PRIMARY KEY,
    supplier_name   VARCHAR2(100)   NOT NULL,
    contact_person  VARCHAR2(100),
    phone           VARCHAR2(15)    UNIQUE NOT NULL,
    email           VARCHAR2(100),
    address         VARCHAR2(200)
);

-- Table: Branches
CREATE TABLE Branches (
    branch_id       NUMBER(10)      PRIMARY KEY,
    branch_name     VARCHAR2(100)   NOT NULL,
    city            VARCHAR2(50)    NOT NULL,
    address         VARCHAR2(200)   NOT NULL,
    phone           VARCHAR2(15)    UNIQUE NOT NULL,
    opening_date    DATE            NOT NULL,
    manager_name    VARCHAR2(100)
);

-- Table: Tables_Dining (dining tables per branch)
--   Renamed from "Tables" to avoid conflict with Oracle reserved word.
CREATE TABLE Tables_Dining (
    table_id         NUMBER(10)     PRIMARY KEY,
    branch_id        NUMBER(10)     NOT NULL,
    table_number     NUMBER(5)      NOT NULL,
    seating_capacity NUMBER(5)      NOT NULL CHECK (seating_capacity > 0),
    is_available     CHAR(1)        DEFAULT 'Y' CHECK (is_available IN ('Y','N')),
    CONSTRAINT fk_td_branch  FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
        ON DELETE CASCADE,
    CONSTRAINT uq_td_branch_tbl UNIQUE (branch_id, table_number)
);
-- Note: Oracle 10g does not support ON UPDATE CASCADE on FK constraints.

-- Table: Employees
CREATE TABLE Employees (
    employee_id     NUMBER(10)      PRIMARY KEY,
    branch_id       NUMBER(10)      NOT NULL,
    first_name      VARCHAR2(50)    NOT NULL,
    last_name       VARCHAR2(50)    NOT NULL,
    role            VARCHAR2(50)    NOT NULL
                    CHECK (role IN ('Manager','Chef','Waiter','Cashier','Cleaner')),
    salary          NUMBER(10,2)    NOT NULL CHECK (salary > 0),
    hire_date       DATE            NOT NULL,
    phone           VARCHAR2(15)    UNIQUE,
    CONSTRAINT fk_emp_branch FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
        ON DELETE CASCADE
);

-- Table: Menu_Categories
CREATE TABLE Menu_Categories (
    category_id     NUMBER(10)      PRIMARY KEY,
    category_name   VARCHAR2(50)    NOT NULL UNIQUE,
    description     VARCHAR2(200)
);

-- Table: Menu_Items
CREATE TABLE Menu_Items (
    item_id         NUMBER(10)      PRIMARY KEY,
    category_id     NUMBER(10)      NOT NULL,
    item_name       VARCHAR2(100)   NOT NULL,
    description     VARCHAR2(300),
    price           NUMBER(8,2)     NOT NULL CHECK (price > 0),
    is_available    CHAR(1)         DEFAULT 'Y' CHECK (is_available IN ('Y','N')),
    CONSTRAINT fk_mi_category FOREIGN KEY (category_id)
        REFERENCES Menu_Categories(category_id)
);

-- Table: Inventory
CREATE TABLE Inventory (
    inventory_id    NUMBER(10)      PRIMARY KEY,
    branch_id       NUMBER(10)      NOT NULL,
    supplier_id     NUMBER(10),
    item_name       VARCHAR2(100)   NOT NULL,
    quantity        NUMBER(10,2)    NOT NULL CHECK (quantity >= 0),
    unit            VARCHAR2(20)    NOT NULL,
    reorder_level   NUMBER(10,2)    NOT NULL CHECK (reorder_level >= 0),
    last_updated    DATE            NOT NULL,
    CONSTRAINT fk_inv_branch   FOREIGN KEY (branch_id)   REFERENCES Branches(branch_id)   ON DELETE CASCADE,
    CONSTRAINT fk_inv_supplier FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE SET NULL
);

-- Table: Reservations
CREATE TABLE Reservations (
    reservation_id   NUMBER(10)     PRIMARY KEY,
    customer_id      NUMBER(10)     NOT NULL,
    table_id         NUMBER(10)     NOT NULL,
    branch_id        NUMBER(10)     NOT NULL,
    reservation_date DATE           NOT NULL,
    -- Oracle has no TIME type; store as VARCHAR2(5) in HH:MI format
    reservation_time VARCHAR2(5)    NOT NULL,
    party_size       NUMBER(5)      NOT NULL CHECK (party_size > 0),
    status           VARCHAR2(20)   DEFAULT 'Confirmed'
                     CHECK (status IN ('Confirmed','Cancelled','Completed','No-Show')),
    special_requests VARCHAR2(300),
    CONSTRAINT fk_res_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)    ON DELETE CASCADE,
    CONSTRAINT fk_res_table    FOREIGN KEY (table_id)    REFERENCES Tables_Dining(table_id),
    CONSTRAINT fk_res_branch   FOREIGN KEY (branch_id)   REFERENCES Branches(branch_id)       ON DELETE CASCADE
);

-- Table: Orders
CREATE TABLE Orders (
    order_id        NUMBER(10)      PRIMARY KEY,
    customer_id     NUMBER(10),
    branch_id       NUMBER(10)      NOT NULL,
    employee_id     NUMBER(10),
    table_id        NUMBER(10),
    order_date      DATE            NOT NULL,
    -- Oracle has no TIME type; stored as VARCHAR2(5) in HH:MI format
    order_time      VARCHAR2(5)     NOT NULL,
    order_type      VARCHAR2(20)    NOT NULL
                    CHECK (order_type IN ('Dine-In','Takeaway','Delivery')),
    status          VARCHAR2(20)    DEFAULT 'Pending'
                    CHECK (status IN ('Pending','Preparing','Served','Completed','Cancelled')),
    total_amount    NUMBER(10,2)    DEFAULT 0.00,
    discount        NUMBER(5,2)     DEFAULT 0.00 CHECK (discount >= 0),
    CONSTRAINT fk_ord_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)   ON DELETE SET NULL,
    CONSTRAINT fk_ord_branch   FOREIGN KEY (branch_id)   REFERENCES Branches(branch_id),
    CONSTRAINT fk_ord_employee FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)   ON DELETE SET NULL,
    CONSTRAINT fk_ord_table    FOREIGN KEY (table_id)    REFERENCES Tables_Dining(table_id)  ON DELETE SET NULL
);

-- Table: Order_Items
--   subtotal is NOT a computed column in Oracle 10g (not supported).
--   It is populated via trigger trg_Order_Items_Subtotal (in Business_Queries.sql).
CREATE TABLE Order_Items (
    order_item_id   NUMBER(10)      PRIMARY KEY,
    order_id        NUMBER(10)      NOT NULL,
    item_id         NUMBER(10)      NOT NULL,
    quantity        NUMBER(5)       NOT NULL CHECK (quantity > 0),
    unit_price      NUMBER(8,2)     NOT NULL CHECK (unit_price > 0),
    subtotal        NUMBER(10,2),
    CONSTRAINT fk_oi_order FOREIGN KEY (order_id) REFERENCES Orders(order_id)      ON DELETE CASCADE,
    CONSTRAINT fk_oi_item  FOREIGN KEY (item_id)  REFERENCES Menu_Items(item_id)
);

-- ============================================================
-- END OF DDL SCRIPT
-- ============================================================
