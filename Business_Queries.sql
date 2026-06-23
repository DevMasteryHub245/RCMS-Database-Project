-- ============================================================
-- Business_Queries.sql
-- Restaurant Chain Management System
-- Introduction to Database Systems - BSSE, IIUI-ISB
-- Submitted To: Shakeel Ahmad
-- *** Converted for Oracle 10g ***
-- ============================================================
-- Contains: 10 Business Queries + 1 View + 2 Triggers
--           + 1 Stored Procedure
-- Run Schema_Design.sql and Data_Population.sql first.
--
-- Oracle-specific changes:
--   - DELIMITER $$ removed; PL/SQL blocks end with / on its own line
--   - CONCAT(a,b,c) -> a || ' ' || b  (Oracle CONCAT takes 2 args only)
--   - CREATE OR REPLACE VIEW/TRIGGER/PROCEDURE syntax is valid in Oracle
--   - LIMIT n -> WHERE ROWNUM <= n  (or use subquery for ORDER BY + LIMIT)
--   - FLOOR() -> FLOOR() (same in Oracle)
--   - An extra trigger trg_Order_Items_Subtotal is added to maintain
--     the subtotal column (computed columns not supported in Oracle 10g)
--   - Stored procedure uses SYS_REFCURSOR / DBMS_OUTPUT approach;
--     in SQL*Plus run: SET SERVEROUTPUT ON before calling the procedure.
-- ============================================================

-- ============================================================
-- PART A: ADVANCED DATABASE OBJECTS
-- ============================================================

-- -----------------------------------------------
-- TRIGGER: trg_Order_Items_Subtotal
-- Purpose: Replaces the GENERATED ALWAYS AS computed column
--   from MySQL. Automatically sets subtotal = quantity * unit_price
--   before every INSERT or UPDATE on Order_Items.
-- -----------------------------------------------
CREATE OR REPLACE TRIGGER trg_Order_Items_Subtotal
BEFORE INSERT OR UPDATE ON Order_Items
FOR EACH ROW
BEGIN
    :NEW.subtotal := :NEW.quantity * :NEW.unit_price;
END;
/

-- -----------------------------------------------
-- VIEW: vw_Order_Summary
-- Business Purpose: Provides a simplified, frequently
--   accessed summary combining Orders, Customers, Branches,
--   and Employees without needing repeated complex JOINs.
-- -----------------------------------------------
CREATE OR REPLACE VIEW vw_Order_Summary AS
SELECT
    o.order_id,
    o.order_date,
    o.order_type,
    o.status                                        AS order_status,
    o.total_amount,
    o.discount,
    (o.total_amount - o.discount)                   AS net_payable,
    c.first_name || ' ' || c.last_name              AS customer_name,
    c.phone                                         AS customer_phone,
    b.branch_name,
    b.city,
    e.first_name || ' ' || e.last_name              AS served_by
FROM Orders o
LEFT JOIN Customers  c ON o.customer_id  = c.customer_id
LEFT JOIN Branches   b ON o.branch_id    = b.branch_id
LEFT JOIN Employees  e ON o.employee_id  = e.employee_id;
/

-- -----------------------------------------------
-- TRIGGER: trg_Update_Loyalty_Points
-- Business Purpose: Automatically awards 1 loyalty point
--   per 100 PKR spent when an order status changes to
--   'Completed'.
-- -----------------------------------------------
CREATE OR REPLACE TRIGGER trg_Update_Loyalty_Points
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF :NEW.status = 'Completed' AND :OLD.status <> 'Completed' THEN
        IF :NEW.customer_id IS NOT NULL THEN
            UPDATE Customers
            SET loyalty_points = loyalty_points
                                 + FLOOR((:NEW.total_amount - :NEW.discount) / 100)
            WHERE customer_id = :NEW.customer_id;
        END IF;
    END IF;
END;
/

-- -----------------------------------------------
-- STORED PROCEDURE: sp_Branch_Sales_Report
-- Business Purpose: Generates a summarized sales report
--   for a given branch showing total orders, total revenue,
--   average order value, and top-3 selling menu items.
--
-- Usage (in SQL*Plus):
--   SET SERVEROUTPUT ON
--   EXEC sp_Branch_Sales_Report(1);
--
-- The procedure uses DBMS_OUTPUT to print results because
-- Oracle 10g stored procedures cannot return result sets
-- directly like MySQL. For a GUI tool (SQL Developer etc.)
-- you can also query the tables directly after calling.
-- -----------------------------------------------
CREATE OR REPLACE PROCEDURE sp_Branch_Sales_Report(p_branch_id IN NUMBER)
AS
    v_branch_name   VARCHAR2(100);
    v_city          VARCHAR2(50);
    v_total_orders  NUMBER;
    v_total_revenue NUMBER(12,2);
    v_avg_value     NUMBER(10,2);
    v_dine_in       NUMBER;
    v_takeaway      NUMBER;
    v_delivery      NUMBER;

    -- Cursor for top 3 selling items
    CURSOR c_top_items IS
        SELECT mi.item_name,
               SUM(oi.quantity)  AS units_sold,
               SUM(oi.subtotal)  AS revenue_generated
        FROM   Order_Items oi
        JOIN   Orders o      ON oi.order_id = o.order_id
        JOIN   Menu_Items mi ON oi.item_id  = mi.item_id
        WHERE  o.branch_id = p_branch_id
          AND  o.status    = 'Completed'
        GROUP BY mi.item_name
        ORDER BY units_sold DESC;

    v_rank   NUMBER := 0;
BEGIN
    -- ---- Basic sales summary ----
    SELECT b.branch_name,
           b.city,
           COUNT(o.order_id),
           NVL(SUM(o.total_amount - o.discount), 0),
           NVL(ROUND(AVG(o.total_amount - o.discount), 2), 0),
           SUM(CASE WHEN o.order_type = 'Dine-In'  THEN 1 ELSE 0 END),
           SUM(CASE WHEN o.order_type = 'Takeaway' THEN 1 ELSE 0 END),
           SUM(CASE WHEN o.order_type = 'Delivery' THEN 1 ELSE 0 END)
    INTO   v_branch_name, v_city,
           v_total_orders, v_total_revenue, v_avg_value,
           v_dine_in, v_takeaway, v_delivery
    FROM   Orders o
    JOIN   Branches b ON o.branch_id = b.branch_id
    WHERE  o.branch_id = p_branch_id
      AND  o.status    = 'Completed';

    DBMS_OUTPUT.PUT_LINE('=== Branch Sales Report ===');
    DBMS_OUTPUT.PUT_LINE('Branch   : ' || v_branch_name || ' (' || v_city || ')');
    DBMS_OUTPUT.PUT_LINE('Orders   : ' || v_total_orders);
    DBMS_OUTPUT.PUT_LINE('Revenue  : PKR ' || v_total_revenue);
    DBMS_OUTPUT.PUT_LINE('Avg Val  : PKR ' || v_avg_value);
    DBMS_OUTPUT.PUT_LINE('Dine-In  : ' || v_dine_in);
    DBMS_OUTPUT.PUT_LINE('Takeaway : ' || v_takeaway);
    DBMS_OUTPUT.PUT_LINE('Delivery : ' || v_delivery);
    DBMS_OUTPUT.PUT_LINE('--- Top 3 Selling Items ---');

    -- ---- Top 3 items via cursor ----
    FOR rec IN c_top_items LOOP
        v_rank := v_rank + 1;
        EXIT WHEN v_rank > 3;
        DBMS_OUTPUT.PUT_LINE(
            v_rank || '. ' || rec.item_name ||
            '  | Qty: ' || rec.units_sold ||
            '  | Revenue: PKR ' || rec.revenue_generated
        );
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No completed orders found for branch_id = ' || p_branch_id);
END sp_Branch_Sales_Report;
/


-- ============================================================
-- PART B: BUSINESS QUERIES
-- ============================================================

-- -----------------------------------------------
-- Query 1 (JOIN): List all completed orders with
--   customer names, branch names, and net amounts paid.
-- -----------------------------------------------
SELECT
    o.order_id,
    o.order_date,
    c.first_name || ' ' || c.last_name             AS customer_name,
    b.branch_name,
    b.city,
    o.order_type,
    o.total_amount,
    o.discount,
    (o.total_amount - o.discount)                  AS net_payable
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN Branches  b ON o.branch_id   = b.branch_id
WHERE o.status = 'Completed'
ORDER BY o.order_date DESC;


-- -----------------------------------------------
-- Query 2 (JOIN): Show all menu items ordered in each
--   order with item details, quantity, and subtotals.
-- -----------------------------------------------
SELECT
    o.order_id,
    o.order_date,
    mc.category_name,
    mi.item_name,
    oi.quantity,
    oi.unit_price,
    oi.subtotal,
    b.branch_name
FROM Order_Items oi
INNER JOIN Orders          o  ON oi.order_id    = o.order_id
INNER JOIN Menu_Items     mi  ON oi.item_id     = mi.item_id
INNER JOIN Menu_Categories mc ON mi.category_id = mc.category_id
INNER JOIN Branches        b  ON o.branch_id    = b.branch_id
ORDER BY o.order_id, mc.category_name;


-- -----------------------------------------------
-- Query 3 (LEFT JOIN): Show all customers and their
--   reservation status (include customers with no reservations).
-- -----------------------------------------------
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name             AS customer_name,
    c.phone,
    c.loyalty_points,
    r.reservation_date,
    r.status                                        AS reservation_status,
    b.branch_name
FROM Customers c
LEFT JOIN Reservations r ON c.customer_id = r.customer_id
LEFT JOIN Branches     b ON r.branch_id   = b.branch_id
ORDER BY c.customer_id;


-- -----------------------------------------------
-- Query 4 (AGGREGATION): Total revenue per branch
--   from completed orders.
-- -----------------------------------------------
SELECT
    b.branch_name,
    b.city,
    COUNT(o.order_id)                               AS total_orders,
    SUM(o.total_amount)                             AS gross_revenue,
    SUM(o.discount)                                 AS total_discounts,
    SUM(o.total_amount - o.discount)                AS net_revenue,
    ROUND(AVG(o.total_amount - o.discount), 2)      AS avg_order_value
FROM Orders o
INNER JOIN Branches b ON o.branch_id = b.branch_id
WHERE o.status = 'Completed'
GROUP BY b.branch_id, b.branch_name, b.city
HAVING SUM(o.total_amount - o.discount) > 0
ORDER BY net_revenue DESC;


-- -----------------------------------------------
-- Query 5 (AGGREGATION): Top 5 best-selling menu items
--   by quantity sold across all branches.
--   Oracle 10g: use ROWNUM in a subquery for LIMIT.
-- -----------------------------------------------
SELECT *
FROM (
    SELECT
        mc.category_name,
        mi.item_name,
        mi.price                        AS unit_price,
        SUM(oi.quantity)                AS total_quantity_sold,
        SUM(oi.subtotal)                AS total_revenue_generated,
        COUNT(DISTINCT o.order_id)      AS appeared_in_orders
    FROM Order_Items oi
    INNER JOIN Menu_Items     mi ON oi.item_id    = mi.item_id
    INNER JOIN Menu_Categories mc ON mi.category_id = mc.category_id
    INNER JOIN Orders          o ON oi.order_id   = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY mc.category_name, mi.item_name, mi.price
    HAVING SUM(oi.quantity) > 0
    ORDER BY total_quantity_sold DESC
)
WHERE ROWNUM <= 5;


-- -----------------------------------------------
-- Query 6 (SUBQUERY – IN): Find all customers who have
--   placed at least one Delivery order.
-- -----------------------------------------------
SELECT
    customer_id,
    first_name || ' ' || last_name                 AS customer_name,
    phone,
    email,
    loyalty_points
FROM Customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM Orders
    WHERE order_type  = 'Delivery'
      AND customer_id IS NOT NULL
)
ORDER BY loyalty_points DESC;


-- -----------------------------------------------
-- Query 7 (SUBQUERY – EXISTS): List branches that have
--   low-stock inventory items (below reorder level).
-- -----------------------------------------------
SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    b.phone                                         AS branch_phone,
    b.manager_name
FROM Branches b
WHERE EXISTS (
    SELECT 1
    FROM Inventory i
    WHERE i.branch_id   = b.branch_id
      AND i.quantity    < i.reorder_level
)
ORDER BY b.branch_name;


-- -----------------------------------------------
-- Query 8 (JOIN + Aggregation): Monthly salary bill
--   per branch.
-- -----------------------------------------------
SELECT
    b.branch_name,
    b.city,
    COUNT(e.employee_id)                            AS total_employees,
    SUM(e.salary)                                   AS monthly_payroll,
    MAX(e.salary)                                   AS highest_salary,
    MIN(e.salary)                                   AS lowest_salary,
    ROUND(AVG(e.salary), 2)                         AS average_salary
FROM Employees e
INNER JOIN Branches b ON e.branch_id = b.branch_id
GROUP BY b.branch_id, b.branch_name, b.city
ORDER BY monthly_payroll DESC;


-- -----------------------------------------------
-- Query 9 (VIEW USAGE): Use vw_Order_Summary to show
--   a full sales ledger of completed Dine-In orders.
-- -----------------------------------------------
SELECT
    order_id,
    order_date,
    customer_name,
    branch_name,
    city,
    served_by,
    total_amount,
    discount,
    net_payable
FROM vw_Order_Summary
WHERE order_status = 'Completed'
  AND order_type   = 'Dine-In'
ORDER BY order_date DESC, branch_name;


-- -----------------------------------------------
-- Query 10 (SCALAR SUBQUERY): List each menu item
--   with its price vs. category average.
-- -----------------------------------------------
SELECT
    mc.category_name,
    mi.item_name,
    mi.price                                        AS item_price,
    ROUND(
        (SELECT AVG(mi2.price)
         FROM Menu_Items mi2
         WHERE mi2.category_id = mi.category_id), 2
    )                                               AS category_avg_price,
    ROUND(
        mi.price - (SELECT AVG(mi2.price)
                    FROM Menu_Items mi2
                    WHERE mi2.category_id = mi.category_id), 2
    )                                               AS price_diff,
    CASE
        WHEN mi.price > (SELECT AVG(mi2.price)
                         FROM Menu_Items mi2
                         WHERE mi2.category_id = mi.category_id)
             THEN 'Above Average'
        WHEN mi.price < (SELECT AVG(mi2.price)
                         FROM Menu_Items mi2
                         WHERE mi2.category_id = mi.category_id)
             THEN 'Below Average'
        ELSE 'At Average'
    END                                             AS price_position
FROM Menu_Items mi
INNER JOIN Menu_Categories mc ON mi.category_id = mc.category_id
ORDER BY mc.category_name, mi.price DESC;


-- ============================================================
-- BONUS: Stored Procedure Execution Demo
-- Run in SQL*Plus:
--   SET SERVEROUTPUT ON
--   EXEC sp_Branch_Sales_Report(1);
-- ============================================================
SET SERVEROUTPUT ON;
EXEC sp_Branch_Sales_Report(1);

-- ============================================================
-- END OF BUSINESS QUERIES SCRIPT
-- ============================================================
