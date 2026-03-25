CREATE DATABASE food_db;
USE food_db;

-- Users хүснэгт
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Restaurants хүснэгт
CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    phone VARCHAR(20) UNIQUE
);

-- Orders хүснэгт
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

-- Deliveries хүснэгт
CREATE TABLE deliveries (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    delivery_address VARCHAR(255) NOT NULL,
    delivery_status VARCHAR(50) NOT NULL,
    
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


-- =========================
-- 2-р хэсэг: SAMPLE DATA
-- =========================

-- Users
INSERT INTO users (name, email, phone) VALUES
('Bat', 'bat@gmail.com', '99110083'),
('Sara', 'sara@gmail.com', '99115588'),
('Bold', 'bold@gmail.com', '99117894'),
('Anu', 'anu@gmail.com', '99114561'),
('Temuulen', 'temuulen@gmail.com', '99225588');

-- Restaurants
INSERT INTO restaurants (name, location, phone) VALUES
('Pizza Hut', 'Darkhan', '1111111'),
('Burger King', 'Darkhan', '22222222'),
('KFC Mongolia', 'Darkhan', '33333333'),
('Mcdonalds', 'Darkhan', '44444444'),
('Subway', 'Darkhan', '75757575');

-- Orders
INSERT INTO orders (user_id, restaurant_id, total_amount) VALUES
(1, 1, 25000),
(2, 2, 18000),
(3, 3, 32000),
(4, 1, 15000),
(5, 5, 27000),
(1, 2, 22000),  
(1, 3, 30000),  
(2, 1, 19000);  

-- Deliveries
INSERT INTO deliveries (order_id, delivery_address, delivery_status) VALUES
(1, 'Shine xoroolol', 'Delivered'),
(2, 'Xuuchin xoroolol', 'Pending'),
(3, 'Heetei', 'Delivered'),
(4, 'Mikr', 'On the way'),
(5, 'Ungut', 'Pending');


-- =========================
-- 3-р хэсэг: SQL QUERY + ТАЙЛБАР
-- =========================

-- 1. User + Restaurant + Order JOIN
SELECT 
    u.name AS user_name,
    r.name AS restaurant_name,
    o.order_id,
    o.total_amount,
    o.order_date
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id;


-- 2. Restaurant бүрийн захиалгын тоо
SELECT 
    r.name AS restaurant_name,
    COUNT(o.order_id) AS total_orders
FROM restaurants r
LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name;


-- 3. Хамгийн их захиалга авсан ресторан
SELECT 
    r.name AS restaurant_name,
    COUNT(o.order_id) AS total_orders
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name
ORDER BY total_orders DESC
LIMIT 1;


-- 4. 2 ба түүнээс дээш захиалга хийсэн хэрэглэгчид
SELECT 
    u.name,
    COUNT(o.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
HAVING COUNT(o.order_id) >= 2;

-- =========================
-- 5-р хэсэг: USER & PERMISSION
-- =========================

-- admin_user 
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON food_db.* TO 'admin_user'@'localhost';

-- report_user (зөвхөн унших)
CREATE USER 'report_user'@'localhost' IDENTIFIED BY '1234';
GRANT SELECT ON food_db.* TO 'report_user'@'localhost';

FLUSH PRIVILEGES;

-- шалгах
SHOW GRANTS FOR 'admin_user'@'localhost';
SHOW GRANTS FOR 'report_user'@'localhost';


-- =========================
-- 6-р хэсэг: BACKUP & RESTORE
-- =========================

-- Backup (terminal дээр ажиллана)
-- mysqldump -u root -p food_db > food_db_backup.sql

-- Restore (terminal дээр ажиллана)
-- mysql -u root -p food_db < food_db_backup.sql
