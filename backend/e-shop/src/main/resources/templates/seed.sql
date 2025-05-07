INSERT INTO roles (role_name) VALUES
('root_admin'),
('admin'),
('store_manager'),
('support_staff'),
('customer');

INSERT INTO permissions (permission_name) VALUES
('manage_users'),
('manage_roles'),
('manage_permissions'),
('manage_categories'),
('manage_products'),
('manage_inventory'),
('manage_orders'),
('view_reports'),
('manage_supports'),
('manage_settings');

INSERT INTO role_permissions (role_id, permission_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(2, 4),
(2, 5),
(2, 8),
(3, 6),
(3, 7),
(3, 8),
(4, 9);

INSERT INTO categories (category_name, slug, description, parent_id) VALUES
('Electronics', 'electronics', 'Devices and gadgets', NULL),
('Computers', 'computers', 'Desktops, laptops, and accessories', 1),
('Smartphones', 'smartphones', 'Mobile phones and accessories', 1),
('Tablets', 'tablets', 'Portable touchscreen devices', 1),
('Laptops', 'laptops', 'Portable computers', 2),
('Desktops', 'desktops', 'Personal computers for home or office use', 2),
('CPUs', 'cpus', 'Central Processing Units', 2),
('GPUs', 'gpus', 'Graphics Processing Units', 2),
('RAMs', 'rams', 'Random Access Memory', 2),
('Storage', 'storage', 'Hard drives and SSDs', 2);

INSERT INTO brands (brand_name, slug, description) VALUES
('Intel', 'intel', null),
('AMD', 'amd', null),
('Apple', 'apple', null),
('NVIDIA', 'nvidia', null)
('Samsung', 'samsung', null),
('Dell', 'dell', null),
('HP', 'hp', null),
('Lenovo', 'lenovo', null),
('Asus', 'asus', null),
('Acer', 'acer', null);

INSERT INTO brand_categories (brand_id, category_id) VALUES
(1, 7), (2, 7), (2, 8), (3, 3), (3, 4), (3, 5), (4, 8), (5, 3), (5, 4), (6, 5), (7, 5), (8, 5), (9, 5), (10, 5);

INSERT INTO attribute_definitions (attribute_name, attribute_type, description) VALUES
-- General
('Color', 'text', 'Red, Green, Blue, ...'),
('Size', 'text', 'Small, Medium, Large, ...'),
('Weight', 'number', '1kg, 2kg, ...'),
('Material', 'text', 'Plastic, Metal, ...'),
('Battery Life', 'number', '2000mAh, 4000mAh, ...'),
('Battery Type', 'text', 'Lithium-ion, Lithium-polymer, ...'),
('Screen Size', 'number', '12-inch, 15-inch, ...'),
('Screen Resolution', 'text', '1920x1080, 2560x1440, ...'),
('Screen Type', 'text', 'LCD, OLED, ...'),
('Operating System', 'text', 'Windows, macOS, Linux, ...'),
-- Laptops
('Touchscreen', 'boolean', 'Yes, No'),
-- CPUs
('Processor Brand', 'text', '(Only built-in products) Intel, AMD, ...'),
('Processor Generation', 'text', 'Intel 14th, AMD Ryzen 5, ...'),
('Processor Model', 'text', '(Only built-in products) i5-14400, Ryzen 5 3600, ...'),
('Processor Architecture', 'text', 'x86, x64, ARM, ...'),
('Processor Socket', 'text', '(Only dedicated products) LGA1151, AM4, ...'),
('Processor Lithography', 'number', '14nm, 7nm, ...'),
('Processor Cores', 'number', '2, 4, 6, ...'),
('Processor Threads', 'number', '4, 8, 12, ...'),
('Processor Cache', 'number', '2MB, 4MB, ...'),
('Processor Speed', 'number', '2.5GHz, 3.0GHz, ...'),
('Processor TDP', 'number', '35W, 65W, ...'),
-- GPUs
('Graphics Card Brand', 'text', '(Only built-in products) NVIDIA, AMD, ...'),
('Graphics Card Generation', 'text', 'GTX 10 series, RX 500 series, ...'),
('Graphics Card Model', 'text', '(Only built-in products) GTX 1050, RX 580, ...'),
('Graphics Card Type', 'text', 'Integrated, Dedicated, ...'),
('Graphics Card Cores', 'number', '512, 1024, ...'),
('Graphics Card Memory', 'number', '2GB, 4GB, ...'),
('Graphics Card Speed', 'number', '1.5GHz, 2.0GHz, ...'),
('Graphics Card Memory Type', 'text', 'GDDR5, GDDR6, ...'),
('Graphics Card Memory Speed', 'number', '8Gbps, 12Gbps, ...'),
('Graphics Card TDP', 'number', '75W, 150W, ...'),
('Graphics Card Ports', 'text', '(Only dedicated products) HDMI, DisplayPort, ...'),
('Graphics Card Features', 'text', 'Ray Tracing, DLSS, ...'),
-- RAMs
('RAM Type', 'text', 'DDR4, DDR5, ...'),
('RAM Speed', 'number', '2400MHz, 3200MHz, ...'),
('RAM Size', 'number', '4GB, 8GB, 16GB, ...'),
('RAM Channels', 'number', '(Only built-in products) Single, Dual, Quad, ...'),
('RAM Voltage', 'number', '1.2V, 1.35V, ...'),
('RAM ECC', 'boolean', 'Yes, No'),
('RAM Speed Profile', 'text', 'XMP, DOCP, ...'),
('RAM Form Factor', 'text', 'DIMM, SO-DIMM, ...'),
('RAM Timing', 'text', 'CL16, CL18, ...'),
('RAM Features', 'text', '(Only dedicated products) RGB, Heat Spreader, ...'),
-- Storage
('Storage Type', 'text', 'HDD, SSD, ...'),
('Storage Number', 'number', '(Only built-in products) 1, 2, ...'),
('Storage Size', 'number', '256GB, 512GB, 1TB, ...'),
('Storage Speed', 'number', '5400RPM, 7200RPM, ...'),
('Storage Interface', 'text', 'SATA, NVMe, ...'),
('Storage Form Factor', 'text', '2.5-inch, M.2, ...'),
('Storage Cache', 'number', '8MB, 16MB, ...'),
('Storage Endurance', 'number', '100TBW, 200TBW, ...'),
('Storage Read Speed', 'number', '500MB/s, 1000MB/s, ...'),
('Storage Write Speed', 'number', '400MB/s, 800MB/s, ...'),
('Storage Features', 'text', '(Only dedicated products) Encryption, Shock Resistant, ...');

INSERT INTO category_attributes (category_id, attribute_id) VALUES
-- Smartphones
(3, 1), (3, 4), (3, 5), (3, 6), (3, 7), (3, 8), (3, 9), (3, 11), (3, 12), (3, 13), (3, 14), (3, 18), (3, 37), (3, 47),
-- Tablets
(4, 1), (4, 4), (4, 5), (4, 6), (4, 7), (4, 8), (4, 9), (4, 11), (4, 12), (4, 13), (4, 14), (4, 18), (4, 37), (4, 47),
-- Laptops
(5, 1), (5, 3), (5, 4), (5, 5), (5, 6), (5, 7), (5, 8), (5, 9), (5, 10), (5, 11), (5, 12), (5, 13), (5, 14), (5, 15), (5, 18), (5, 19), (5, 20), (5, 21), (5, 23), (5, 24), (5, 25), (5, 26), (5, 27), (5, 28), (5, 30), (5, 34), (5, 35), (5, 36), (5, 37), (5, 38), (5, 42), (5, 45), (5, 47), (5, 49), (5, 53), (5,54), 
-- CPUs
(7, 13), (7, 15), (7, 16), (7, 17), (7, 18), (7, 19), (7, 20), (7, 21), (7, 22),
-- GPUs
(8, 24), (8, 26), (8, 27), (8, 28), (8, 29), (8, 30), (8, 31), (8, 32), (8, 33), (8, 34);