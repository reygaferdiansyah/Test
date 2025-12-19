-- Knowladge Base
-- No 1. Buat Tabel 1
-- Create tabel
CREATE TABLE IF NOT EXISTS tabel1 (
    id SERIAL PRIMARY KEY,
    fullname VARCHAR(100),
    email VARCHAR(50)
);

-- Isi data contoh ke tabel1 
INSERT INTO tabel1 (fullname, email) VALUES
('Reyga Suhendra', 'reyga@gmail.com'),
('Andi Pratama', 'andi@yahoo.com'),
('Budi Santoso', 'budi@gmail.com'),
('Sarah Wijaya', 'sarah@hotmail.com'),
('Lisa Maharani', 'lisa@gmail.com')
ON CONFLICT (id) DO NOTHING;  
SELECT * FROM tabel1;


-- No 3. Perbedaan output Inner Join dan Left join
-- Buat tabel1_No_3: Daftar customer
CREATE TABLE tabel1_No_3 (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50)
);

-- Buat tabel2: Daftar order
CREATE TABLE tabel2 (
    id INTEGER PRIMARY KEY,
    order_total DECIMAL(12,2)
);

-- Insert data customer 
INSERT INTO tabel1_No_3 (id, name) VALUES
(1, 'Reyga'),
(2, 'Andi'),
(3, 'Budi'),
(4, 'Sarah'),
(5, 'Lisa');

-- Insert data order 
INSERT INTO tabel2 (id, order_total) VALUES
(1, 25750000.00),  
(2, 6500000.00),   
(4, 1500000.00);   

SELECT * FROM tabel1_No_3;
SELECT * FROM tabel2;

-- Query 1: INNER JOIN
SELECT *
FROM tabel1_No_3
INNER JOIN tabel2 ON tabel1_No_3.id = tabel2.id;



-- Query 2: LEFT JOIN
SELECT *
FROM tabel1_No_3
LEFT JOIN tabel2 ON tabel1_No_3.id = tabel2.id;



-- No 4. Sub Query gmail
-- Sub Query gmail
SELECT email
FROM tabel1
WHERE email IN (
    SELECT email
    FROM tabel1
    WHERE email ILIKE '%@gmail.com'
);


-- No 5. Perbedaan output dari procedure dan function di Postgres
-- FUNCTION: Mengembalikan nilai total pembelian customer
CREATE OR REPLACE FUNCTION hitung_total_customer(p_customer_id INTEGER)
RETURNS DECIMAL(12,2) AS $$
DECLARE
    v_total DECIMAL(12,2) := 0;
BEGIN
    SELECT COALESCE(SUM(o.total_amount), 0)
    INTO v_total
    FROM orders o
    WHERE o.customer_id = p_customer_id;

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- Cara pakai Function 
SELECT 
    c.name,
    hitung_total_customer(c.customer_id) AS total_pembelian
FROM customers c
ORDER BY total_pembelian DESC;


-- PROCEDURE: Melakukan proses (tampilkan total + pesan), tapi tidak return nilai
CREATE OR REPLACE PROCEDURE proses_total_customer(p_customer_id INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
    v_nama VARCHAR(100);
    v_total DECIMAL(12,2) := 0;
BEGIN
    -- Ambil nama customer
    SELECT name INTO v_nama
    FROM customers
    WHERE customer_id = p_customer_id;

    -- Hitung total
    SELECT COALESCE(SUM(total_amount), 0) INTO v_total
    FROM orders
    WHERE customer_id = p_customer_id;

    -- Tampilkan hasil pakai RAISE NOTICE (mirip print)
    RAISE NOTICE 'Customer: %', v_nama;
    RAISE NOTICE 'Total pembelian: Rp %,00', v_total;
    RAISE NOTICE '-------------------';
END;
$$;

-- Cara pakai Procedure
CALL proses_total_customer(1); 
CALL proses_total_customer(3);  
CALL proses_total_customer(5);  






-- Test Case
-- Tabel aplikasi pembelian
-- Customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address TEXT
);

-- Products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(12, 2) NOT NULL CHECK (price > 0),
    stock INTEGER DEFAULT 0
);

-- Orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12, 2) NOT NULL CHECK (total_amount >= 0)
);

-- Order Items (junction table)
CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(product_id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL(12, 2) NOT NULL CHECK (subtotal >= 0),
    UNIQUE (order_id, product_id)  
);

-- Index untuk performance
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);

INSERT INTO customers (name, email, address) VALUES
('Reyga', 'reyga@gmail.com', 'Jakarta Selatan'),
('Andi', 'andi@yahoo.com', 'Bandung'),
('Budi', 'budi@gmail.com', 'Surabaya'),
('Sarah', 'sarah@hotmail.com', 'Yogyakarta'),
('Lisa', 'lisa@gmail.com', 'Bali');
SELECT 'Customers' AS tabel, customer_id, name, email, address FROM customers ORDER BY customer_id;


INSERT INTO products (name, price, stock) VALUES
('Laptop Gaming ASUS ROG', 25000000.00, 15),
('Mouse Wireless Logitech', 750000.00, 50),
('Keyboard Mechanical Keychron', 1500000.00, 30),
('Monitor 27" Samsung', 4500000.00, 20),
('Headset Razer', 2000000.00, 25);
SELECT 'Products' AS tabel, product_id, name, price, stock FROM products ORDER BY product_id;

-- Orders 
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-12-15', 25750000.00), (1, '2025-12-18', 1500000.00),
(2, '2025-12-16', 6500000.00),
(3, '2025-12-17', 2750000.00),
(4, '2025-12-19', 1500000.00),
(5, '2025-12-20', 25000000.00);
SELECT 'Orders' AS tabel, order_id, customer_id, order_date, total_amount FROM orders ORDER BY order_date DESC;

-- Orders_items
INSERT INTO order_items (order_id, product_id, quantity, subtotal) VALUES
(1,1,1,25000000.00),(1,2,1,750000.00),
(2,3,1,1500000.00),
(3,4,1,4500000.00),(3,5,1,2000000.00),
(4,2,1,750000.00),(4,5,1,2000000.00),
(5,3,1,1500000.00),
(6,1,1,25000000.00);
SELECT 'Order Items' AS tabel, item_id, order_id, product_id, quantity, subtotal FROM order_items ORDER BY order_id, item_id;




-- Daftar seluruh pembelian/order (lengkap detail)
SELECT 
    o.order_id,
    c.name AS customer_name,
    o.order_date AS waktu_pembelian,
    o.total_amount AS total_nilai,
    COUNT(oi.item_id) AS jumlah_product,
    STRING_AGG(p.name, ', ' ORDER BY p.name) AS produk_dibeli
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.order_id, c.name, o.order_date, o.total_amount
ORDER BY o.order_date DESC;



-- Total nilai pembelian per customer per bulan
SELECT 
    c.name AS customer_name,
    DATE_TRUNC('month', o.order_date)::DATE AS bulan,
    SUM(o.total_amount) AS total_pembelian
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name, DATE_TRUNC('month', o.order_date)
ORDER BY bulan DESC, total_pembelian DESC;



-- 3 produk dengan penjualan terbesar per bulan
WITH monthly_sales AS (
    SELECT 
        p.name AS product_name,
        DATE_TRUNC('month', o.order_date)::DATE AS bulan,
        SUM(oi.subtotal) AS total_penjualan
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.name, DATE_TRUNC('month', o.order_date)
)
SELECT 
    bulan,
    product_name,
    total_penjualan
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY bulan ORDER BY total_penjualan DESC) AS rank
    FROM monthly_sales
) ranked
WHERE rank <= 3
ORDER BY bulan DESC, rank;