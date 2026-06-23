-- ============================================================
-- Data_Population.sql
-- Restaurant Chain Management System
-- Introduction to Database Systems - BSSE, IIUI-ISB
-- Submitted To: Shakeel Ahmad
-- *** Converted for Oracle 10g ***
-- ============================================================
-- NOTE: Run Schema_Design.sql before this file.
-- Insertion order respects foreign key constraints.
--
-- Oracle-specific changes:
--   - Date literals use TO_DATE('YYYY-MM-DD','YYYY-MM-DD')
--   - TIME columns are VARCHAR2(5) stored as 'HH:MI'
--   - Each INSERT ends with a semicolon (no DELIMITER needed)
--   - A COMMIT is issued at the end to save all rows
-- ============================================================

-- ============================================================
-- 1. Customers
-- ============================================================
INSERT INTO Customers VALUES (1,  'Ahmed',   'Raza',     '0300-1234567', 'ahmed.raza@gmail.com',    120, TO_DATE('2023-01-15','YYYY-MM-DD'));
INSERT INTO Customers VALUES (2,  'Sara',    'Khan',     '0301-2345678', 'sara.khan@gmail.com',      85, TO_DATE('2023-02-20','YYYY-MM-DD'));
INSERT INTO Customers VALUES (3,  'Bilal',   'Hussain',  '0302-3456789', 'bilal.h@yahoo.com',       200, TO_DATE('2022-11-05','YYYY-MM-DD'));
INSERT INTO Customers VALUES (4,  'Fatima',  'Sheikh',   '0303-4567890', 'fatima.s@hotmail.com',     50, TO_DATE('2023-05-10','YYYY-MM-DD'));
INSERT INTO Customers VALUES (5,  'Omar',    'Farooq',   '0304-5678901', 'omar.f@gmail.com',          0, TO_DATE('2024-01-08','YYYY-MM-DD'));
INSERT INTO Customers VALUES (6,  'Ayesha',  'Malik',    '0305-6789012', 'ayesha.m@gmail.com',      310, TO_DATE('2022-08-22','YYYY-MM-DD'));
INSERT INTO Customers VALUES (7,  'Hassan',  'Ali',      '0306-7890123', 'hassan.ali@gmail.com',     75, TO_DATE('2023-07-14','YYYY-MM-DD'));
INSERT INTO Customers VALUES (8,  'Zainab',  'Qureshi',  '0307-8901234', 'zainab.q@yahoo.com',      140, TO_DATE('2023-03-30','YYYY-MM-DD'));
INSERT INTO Customers VALUES (9,  'Kamran',  'Iqbal',    '0308-9012345', 'kamran.i@gmail.com',       20, TO_DATE('2024-02-18','YYYY-MM-DD'));
INSERT INTO Customers VALUES (10, 'Nadia',   'Butt',     '0309-0123456', 'nadia.b@hotmail.com',      95, TO_DATE('2023-09-01','YYYY-MM-DD'));
INSERT INTO Customers VALUES (11, 'Tariq',   'Mehmood',  '0310-1234568', 'tariq.m@gmail.com',        60, TO_DATE('2024-03-05','YYYY-MM-DD'));
INSERT INTO Customers VALUES (12, 'Hina',    'Nawaz',    '0311-2345679', 'hina.n@gmail.com',        180, TO_DATE('2022-12-12','YYYY-MM-DD'));

-- ============================================================
-- 2. Suppliers
-- ============================================================
INSERT INTO Suppliers VALUES (1, 'Fresh Farms Co.',     'Usman Tariq',    '0321-1111111', 'freshfarms@email.com',   'Rawalpindi, Punjab');
INSERT INTO Suppliers VALUES (2, 'Pak Meat Suppliers',  'Khalid Anwar',   '0322-2222222', 'pakmeat@email.com',      'Islamabad, ICT');
INSERT INTO Suppliers VALUES (3, 'Spice World',         'Rehana Bibi',    '0323-3333333', 'spiceworld@email.com',   'Lahore, Punjab');
INSERT INTO Suppliers VALUES (4, 'Green Veggies Ltd.',  'Imran Shah',     '0324-4444444', 'greenveggies@email.com', 'Faisalabad, Punjab');
INSERT INTO Suppliers VALUES (5, 'Dairy Delight',       'Samina Hussain', '0325-5555555', 'dairydelight@email.com', 'Karachi, Sindh');
INSERT INTO Suppliers VALUES (6, 'Al-Bakeri Supplies',  'Nadeem Akhtar',  '0326-6666666', 'albakeri@email.com',     'Multan, Punjab');
INSERT INTO Suppliers VALUES (7, 'Beverage Hub',        'Rizwan Mirza',   '0327-7777777', 'beveragehub@email.com',  'Peshawar, KPK');

-- ============================================================
-- 3. Branches
-- ============================================================
INSERT INTO Branches VALUES (1, 'RCMS Blue Area',    'Islamabad',  'Plot 5, Blue Area, Islamabad',       '051-1111111', TO_DATE('2020-03-01','YYYY-MM-DD'), 'Asad Mehmood');
INSERT INTO Branches VALUES (2, 'RCMS F-10 Markaz',  'Islamabad',  'Shop 12, F-10 Markaz, Islamabad',    '051-2222222', TO_DATE('2021-06-15','YYYY-MM-DD'), 'Sana Zaidi');
INSERT INTO Branches VALUES (3, 'RCMS Saddar',       'Rawalpindi', 'Main Saddar Road, Rawalpindi',        '051-3333333', TO_DATE('2019-09-10','YYYY-MM-DD'), 'Faisal Chaudhry');
INSERT INTO Branches VALUES (4, 'RCMS Gulberg',      'Lahore',     'Main Boulevard, Gulberg III, Lahore', '042-4444444', TO_DATE('2022-01-20','YYYY-MM-DD'), 'Maryam Riaz');
INSERT INTO Branches VALUES (5, 'RCMS Clifton',      'Karachi',    'Block 5, Clifton, Karachi',           '021-5555555', TO_DATE('2022-07-01','YYYY-MM-DD'), 'Junaid Siddiqui');

-- ============================================================
-- 4. Tables_Dining  (renamed from Tables; Tables is reserved in Oracle)
-- ============================================================
INSERT INTO Tables_Dining VALUES (1,  1, 1, 4, 'Y');
INSERT INTO Tables_Dining VALUES (2,  1, 2, 4, 'N');
INSERT INTO Tables_Dining VALUES (3,  1, 3, 6, 'Y');
INSERT INTO Tables_Dining VALUES (4,  2, 1, 2, 'Y');
INSERT INTO Tables_Dining VALUES (5,  2, 2, 4, 'Y');
INSERT INTO Tables_Dining VALUES (6,  2, 3, 6, 'N');
INSERT INTO Tables_Dining VALUES (7,  3, 1, 4, 'Y');
INSERT INTO Tables_Dining VALUES (8,  3, 2, 4, 'Y');
INSERT INTO Tables_Dining VALUES (9,  3, 3, 8, 'Y');
INSERT INTO Tables_Dining VALUES (10, 4, 1, 4, 'Y');
INSERT INTO Tables_Dining VALUES (11, 4, 2, 6, 'N');
INSERT INTO Tables_Dining VALUES (12, 5, 1, 4, 'Y');
INSERT INTO Tables_Dining VALUES (13, 5, 2, 4, 'Y');

-- ============================================================
-- 5. Employees
-- ============================================================
INSERT INTO Employees VALUES (1,  1, 'Asad',    'Mehmood',  'Manager',  80000.00, TO_DATE('2020-03-01','YYYY-MM-DD'), '0331-1111111');
INSERT INTO Employees VALUES (2,  1, 'Raza',    'Ahmed',    'Chef',     55000.00, TO_DATE('2020-03-05','YYYY-MM-DD'), '0332-2222222');
INSERT INTO Employees VALUES (3,  1, 'Imtiaz',  'Baig',     'Waiter',   30000.00, TO_DATE('2021-01-10','YYYY-MM-DD'), '0333-3333333');
INSERT INTO Employees VALUES (4,  1, 'Naveed',  'Rana',     'Cashier',  35000.00, TO_DATE('2021-04-15','YYYY-MM-DD'), '0334-4444444');
INSERT INTO Employees VALUES (5,  2, 'Sana',    'Zaidi',    'Manager',  80000.00, TO_DATE('2021-06-15','YYYY-MM-DD'), '0335-5555555');
INSERT INTO Employees VALUES (6,  2, 'Khalid',  'Javed',    'Chef',     58000.00, TO_DATE('2021-07-01','YYYY-MM-DD'), '0336-6666666');
INSERT INTO Employees VALUES (7,  2, 'Amna',    'Siddiq',   'Waiter',   30000.00, TO_DATE('2022-02-20','YYYY-MM-DD'), '0337-7777777');
INSERT INTO Employees VALUES (8,  3, 'Faisal',  'Chaudhry', 'Manager',  75000.00, TO_DATE('2019-09-10','YYYY-MM-DD'), '0338-8888888');
INSERT INTO Employees VALUES (9,  3, 'Zubair',  'Hussain',  'Chef',     52000.00, TO_DATE('2019-10-01','YYYY-MM-DD'), '0339-9999999');
INSERT INTO Employees VALUES (10, 3, 'Usman',   'Ali',      'Waiter',   28000.00, TO_DATE('2020-05-20','YYYY-MM-DD'), '0340-1010101');
INSERT INTO Employees VALUES (11, 4, 'Maryam',  'Riaz',     'Manager',  82000.00, TO_DATE('2022-01-20','YYYY-MM-DD'), '0341-1111112');
INSERT INTO Employees VALUES (12, 4, 'Shan',    'Mirza',    'Chef',     60000.00, TO_DATE('2022-02-01','YYYY-MM-DD'), '0342-2222223');
INSERT INTO Employees VALUES (13, 5, 'Junaid',  'Siddiqui', 'Manager',  85000.00, TO_DATE('2022-07-01','YYYY-MM-DD'), '0343-3333334');
INSERT INTO Employees VALUES (14, 5, 'Lubna',   'Dar',      'Chef',     56000.00, TO_DATE('2022-08-01','YYYY-MM-DD'), '0344-4444445');

-- ============================================================
-- 6. Menu_Categories
-- ============================================================
INSERT INTO Menu_Categories VALUES (1, 'Starters',    'Appetizers and small bites to begin the meal');
INSERT INTO Menu_Categories VALUES (2, 'Main Course', 'Hearty primary dishes');
INSERT INTO Menu_Categories VALUES (3, 'Desserts',    'Sweet treats to end the meal');
INSERT INTO Menu_Categories VALUES (4, 'Beverages',   'Hot and cold drinks');
INSERT INTO Menu_Categories VALUES (5, 'Grills',      'BBQ and grilled specialities');

-- ============================================================
-- 7. Menu_Items
-- ============================================================
INSERT INTO Menu_Items VALUES (1,  1, 'Chicken Wings',        'Crispy spiced wings',              350.00, 'Y');
INSERT INTO Menu_Items VALUES (2,  1, 'Garlic Bread',         'Toasted bread with garlic butter',  200.00, 'Y');
INSERT INTO Menu_Items VALUES (3,  1, 'Soup of the Day',      'Chef selection soup',               250.00, 'Y');
INSERT INTO Menu_Items VALUES (4,  2, 'Chicken Biryani',      'Aromatic basmati rice with chicken',650.00, 'Y');
INSERT INTO Menu_Items VALUES (5,  2, 'Mutton Karahi',        'Slow-cooked mutton in spicy gravy', 950.00, 'Y');
INSERT INTO Menu_Items VALUES (6,  2, 'Pasta Alfredo',        'Creamy white sauce pasta',          700.00, 'Y');
INSERT INTO Menu_Items VALUES (7,  2, 'Chicken Burger',       'Crispy chicken with veggies',       550.00, 'Y');
INSERT INTO Menu_Items VALUES (8,  3, 'Gulab Jamun',          'Soft milk dumplings in syrup',      200.00, 'Y');
INSERT INTO Menu_Items VALUES (9,  3, 'Chocolate Lava Cake',  'Warm cake with melting chocolate',  350.00, 'Y');
INSERT INTO Menu_Items VALUES (10, 3, 'Ice Cream (2 Scoops)', 'Assorted flavors',                  250.00, 'Y');
INSERT INTO Menu_Items VALUES (11, 4, 'Mango Lassi',          'Chilled mango yogurt drink',        200.00, 'Y');
INSERT INTO Menu_Items VALUES (12, 4, 'Mint Lemonade',        'Fresh mint and lemon juice',        180.00, 'Y');
INSERT INTO Menu_Items VALUES (13, 4, 'Coffee (Hot)',         'Freshly brewed arabica coffee',     250.00, 'Y');
INSERT INTO Menu_Items VALUES (14, 5, 'BBQ Chicken Platter',  'Full chicken grilled BBQ platter', 1200.00, 'Y');
INSERT INTO Menu_Items VALUES (15, 5, 'Seekh Kabab (6 pcs)',  'Minced beef kababs on skewer',      600.00, 'Y');

-- ============================================================
-- 8. Inventory
-- ============================================================
INSERT INTO Inventory VALUES (1,  1, 2, 'Chicken (kg)',       50.00, 'kg',  10.00, TO_DATE('2024-05-01','YYYY-MM-DD'));
INSERT INTO Inventory VALUES (2,  1, 4, 'Tomatoes (kg)',      20.00, 'kg',   5.00, TO_DATE('2024-05-01','YYYY-MM-DD'));
INSERT INTO Inventory VALUES (3,  1, 3, 'Spice Mix (kg)',     15.00, 'kg',   3.00, TO_DATE('2024-05-01','YYYY-MM-DD'));
INSERT INTO Inventory VALUES (4,  2, 2, 'Mutton (kg)',        30.00, 'kg',   8.00, TO_DATE('2024-05-02','YYYY-MM-DD'));
INSERT INTO Inventory VALUES (5,  2, 4, 'Onions (kg)',        25.00, 'kg',   5.00, TO_DATE('2024-05-02','YYYY-MM-DD'));
INSERT INTO Inventory VALUES (6,  2, 6, 'Flour (kg)',         40.00, 'kg',  10.00, TO_DATE('2024-05-02','YYYY-MM-DD'));
INSERT INTO Inventory VALUES (7,  3, 2, 'Chicken (kg)',       60.00, 'kg',  10.00, TO_DATE('2024-05-03','YYYY-MM-DD'));
INSERT INTO Inventory VALUES (8,  3, 5, 'Milk (litre)',       30.00, 'L',    8.00, TO_DATE('2024-05-03','YYYY-MM-DD'));
INSERT INTO Inventory VALUES (9,  3, 4, 'Rice (kg)',          45.00, 'kg',  10.00, TO_DATE('2024-05-03','YYYY-MM-DD'));
INSERT INTO Inventory VALUES (10, 4, 2, 'Beef (kg)',          35.00, 'kg',   8.00, TO_DATE('2024-05-04','YYYY-MM-DD'));
INSERT INTO Inventory VALUES (11, 4, 5, 'Cream (litre)',      15.00, 'L',    4.00, TO_DATE('2024-05-04','YYYY-MM-DD'));
INSERT INTO Inventory VALUES (12, 5, 7, 'Soft Drinks (cans)', 100.00,'pcs', 20.00, TO_DATE('2024-05-05','YYYY-MM-DD'));
INSERT INTO Inventory VALUES (13, 5, 4, 'Potatoes (kg)',      40.00, 'kg',  10.00, TO_DATE('2024-05-05','YYYY-MM-DD'));

-- ============================================================
-- 9. Reservations
--   reservation_time stored as VARCHAR2(5) in 'HH:MI' format
-- ============================================================
INSERT INTO Reservations VALUES (1,  1,  1, 1, TO_DATE('2024-05-10','YYYY-MM-DD'), '19:00', 3, 'Confirmed',  NULL);
INSERT INTO Reservations VALUES (2,  2,  4, 2, TO_DATE('2024-05-10','YYYY-MM-DD'), '20:00', 2, 'Confirmed',  'Window seat please');
INSERT INTO Reservations VALUES (3,  3,  7, 3, TO_DATE('2024-05-11','YYYY-MM-DD'), '13:00', 4, 'Completed',  NULL);
INSERT INTO Reservations VALUES (4,  4,  9, 3, TO_DATE('2024-05-11','YYYY-MM-DD'), '19:30', 6, 'Completed',  'Birthday celebration');
INSERT INTO Reservations VALUES (5,  5, 10, 4, TO_DATE('2024-05-12','YYYY-MM-DD'), '12:30', 2, 'Confirmed',  NULL);
INSERT INTO Reservations VALUES (6,  6, 12, 5, TO_DATE('2024-05-12','YYYY-MM-DD'), '20:00', 4, 'Confirmed',  'Vegetarian options needed');
INSERT INTO Reservations VALUES (7,  7,  3, 1, TO_DATE('2024-05-13','YYYY-MM-DD'), '19:00', 5, 'Cancelled',  NULL);
INSERT INTO Reservations VALUES (8,  8,  5, 2, TO_DATE('2024-05-13','YYYY-MM-DD'), '18:00', 4, 'Completed',  NULL);
INSERT INTO Reservations VALUES (9,  9,  8, 3, TO_DATE('2024-05-14','YYYY-MM-DD'), '21:00', 3, 'Confirmed',  NULL);
INSERT INTO Reservations VALUES (10,10, 13, 5, TO_DATE('2024-05-14','YYYY-MM-DD'), '20:30', 2, 'No-Show',    NULL);
INSERT INTO Reservations VALUES (11, 1,  2, 1, TO_DATE('2024-05-15','YYYY-MM-DD'), '13:00', 3, 'Confirmed',  NULL);
INSERT INTO Reservations VALUES (12,11, 11, 4, TO_DATE('2024-05-15','YYYY-MM-DD'), '19:00', 5, 'Confirmed',  'Anniversary dinner');

-- ============================================================
-- 10. Orders
--   order_time stored as VARCHAR2(5) in 'HH:MI' format
-- ============================================================
INSERT INTO Orders VALUES (1,  1,  1,  3,  1,  TO_DATE('2024-05-10','YYYY-MM-DD'), '19:15', 'Dine-In',  'Completed', 1550.00, 0.00);
INSERT INTO Orders VALUES (2,  2,  2,  7,  4,  TO_DATE('2024-05-10','YYYY-MM-DD'), '20:10', 'Dine-In',  'Completed',  930.00, 0.00);
INSERT INTO Orders VALUES (3,  3,  3,  9,  7,  TO_DATE('2024-05-11','YYYY-MM-DD'), '13:15', 'Dine-In',  'Completed', 1850.00, 50.00);
INSERT INTO Orders VALUES (4,  4,  3, 10,  9,  TO_DATE('2024-05-11','YYYY-MM-DD'), '19:45', 'Dine-In',  'Completed', 2800.00,100.00);
INSERT INTO Orders VALUES (5,  5,  4, NULL,NULL,TO_DATE('2024-05-12','YYYY-MM-DD'), '12:00', 'Takeaway', 'Completed', 1200.00, 0.00);
INSERT INTO Orders VALUES (6,  6,  5, NULL,NULL,TO_DATE('2024-05-12','YYYY-MM-DD'), '11:30', 'Delivery', 'Completed', 1750.00, 0.00);
INSERT INTO Orders VALUES (7,  7,  1,  3,  3,  TO_DATE('2024-05-13','YYYY-MM-DD'), '19:10', 'Dine-In',  'Cancelled',    0.00, 0.00);
INSERT INTO Orders VALUES (8,  8,  2,  7,  5,  TO_DATE('2024-05-13','YYYY-MM-DD'), '18:20', 'Dine-In',  'Completed', 1100.00, 0.00);
INSERT INTO Orders VALUES (9,  9,  3, 10,  8,  TO_DATE('2024-05-14','YYYY-MM-DD'), '21:10', 'Dine-In',  'Completed', 2400.00, 0.00);
INSERT INTO Orders VALUES (10,10,  5, NULL,NULL,TO_DATE('2024-05-14','YYYY-MM-DD'), '20:00', 'Delivery', 'Completed',  800.00, 0.00);
INSERT INTO Orders VALUES (11, 1,  1,  4,  2,  TO_DATE('2024-05-15','YYYY-MM-DD'), '13:15', 'Dine-In',  'Completed', 1900.00, 0.00);
INSERT INTO Orders VALUES (12,11,  4, 12, 10,  TO_DATE('2024-05-15','YYYY-MM-DD'), '19:20', 'Dine-In',  'Completed', 2200.00,150.00);
INSERT INTO Orders VALUES (13,12,  5, 14, 12,  TO_DATE('2024-05-16','YYYY-MM-DD'), '20:00', 'Dine-In',  'Completed', 3400.00, 0.00);

-- ============================================================
-- 11. Order_Items
--   subtotal is computed manually (quantity * unit_price).
--   The trigger trg_Order_Items_Subtotal in Business_Queries.sql
--   will auto-populate this column on INSERT going forward.
--   For this seed data we supply the value directly.
-- ============================================================
INSERT INTO Order_Items VALUES (1,  1,  4,  1, 650.00,  650.00);
INSERT INTO Order_Items VALUES (2,  1, 11,  2, 200.00,  400.00);
INSERT INTO Order_Items VALUES (3,  1,  1,  1, 350.00,  350.00);
INSERT INTO Order_Items VALUES (4,  1,  9,  1, 350.00,  350.00);
INSERT INTO Order_Items VALUES (5,  2,  7,  1, 550.00,  550.00);
INSERT INTO Order_Items VALUES (6,  2, 12,  2, 180.00,  360.00);
INSERT INTO Order_Items VALUES (7,  3,  5,  1, 950.00,  950.00);
INSERT INTO Order_Items VALUES (8,  3,  4,  1, 650.00,  650.00);
INSERT INTO Order_Items VALUES (9,  3,  8,  2, 200.00,  400.00);
INSERT INTO Order_Items VALUES (10, 4, 14,  2,1200.00, 2400.00);
INSERT INTO Order_Items VALUES (11, 4, 15,  1, 600.00,  600.00);
INSERT INTO Order_Items VALUES (12, 5, 14,  1,1200.00, 1200.00);
INSERT INTO Order_Items VALUES (13, 6,  5,  1, 950.00,  950.00);
INSERT INTO Order_Items VALUES (14, 6,  4,  1, 650.00,  650.00);
INSERT INTO Order_Items VALUES (15, 6, 11,  1, 200.00,  200.00);
INSERT INTO Order_Items VALUES (16, 8,  6,  1, 700.00,  700.00);
INSERT INTO Order_Items VALUES (17, 8, 13,  1, 250.00,  250.00);
INSERT INTO Order_Items VALUES (18, 8, 10,  1, 250.00,  250.00);
INSERT INTO Order_Items VALUES (19, 9, 14,  1,1200.00, 1200.00);
INSERT INTO Order_Items VALUES (20, 9, 15,  2, 600.00, 1200.00);
INSERT INTO Order_Items VALUES (21,10,  7,  1, 550.00,  550.00);
INSERT INTO Order_Items VALUES (22,10, 12,  1, 180.00,  180.00);
INSERT INTO Order_Items VALUES (23,11,  5,  1, 950.00,  950.00);
INSERT INTO Order_Items VALUES (24,11,  4,  1, 650.00,  650.00);
INSERT INTO Order_Items VALUES (25,11,  9,  1, 350.00,  350.00);
INSERT INTO Order_Items VALUES (26,12, 14,  1,1200.00, 1200.00);
INSERT INTO Order_Items VALUES (27,12, 15,  1, 600.00,  600.00);
INSERT INTO Order_Items VALUES (28,12, 13,  1, 250.00,  250.00);
INSERT INTO Order_Items VALUES (29,13, 14,  2,1200.00, 2400.00);
INSERT INTO Order_Items VALUES (30,13,  5,  1, 950.00,  950.00);
INSERT INTO Order_Items VALUES (31,13,  9,  1, 350.00,  350.00);

COMMIT;

-- ============================================================
-- END OF DML SCRIPT
-- ============================================================
