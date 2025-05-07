-- Database schema for e-commerce application
-- Note: This schema is designed for MySQL and uses InnoDB engine for foreign key support.
-- Ensure that the database is created with utf8 character set
-- and utf8_general_ci collation for proper handling of Unicode characters.

-- Using 'LAST_INSERT_ID()' to get the latest ID for 'AUTO_INCREMENT' ID immediately after 'INSERT' per connection if there are many concurrent connections.

-- Tables without dependencies
-- Roles
CREATE TABLE roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL UNIQUE -- e.g., 'admin', 'store_manager', 'customer', 'support_staff'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Permissions
CREATE TABLE permissions (
    permission_id INT PRIMARY KEY AUTO_INCREMENT,
    permission_name VARCHAR(255) NOT NULL UNIQUE, -- e.g., 'manage_users', 'add_products'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NULL,
    image_url VARCHAR(255) NULL,
    parent_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (parent_id) REFERENCES categories(category_id) ON DELETE SET NULL -- Self-referencing for subcategories
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Brands
CREATE TABLE brands (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Brands-Categories Mapping
CREATE TABLE brand_categories (
    brand_category_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE,
    UNIQUE KEY (brand_id, category_id) -- Ensure no duplicate brand-category pairs
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Attribute Definitions
CREATE TABLE attribute_definitions (
    attribute_id INT PRIMARY KEY AUTO_INCREMENT,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_type ENUM('text', 'number', 'boolean', 'date') NOT NULL,
    description TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Discount Types
CREATE TABLE discount_types (
    discount_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL UNIQUE, -- e.g., 'percentage', 'fixed_amount', 'buy_x_get_y'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Tables with dependencies
-- Role-Permissions Mapping
CREATE TABLE role_permissions (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(permission_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Authentication
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status ENUM('active', 'inactive', 'locked') NOT NULL DEFAULT 'active', 
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    INDEX idx_email (email), -- Index for searching by email for sign in
    INDEX idx_email_status (email, status) -- Index for searching by email and status for sign up
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Stores
CREATE TABLE stores (
    store_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    store_name VARCHAR(255) UNIQUE NOT NULL,
    store_address VARCHAR(255) UNIQUE NOT NULL,
    store_phone_number VARCHAR(15) UNIQUE NOT NULL,
    latitude DECIMAL(10, 6),
    longitude DECIMAL(10, 6),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Customers
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    birthdate DATE NULL,
    phone_number VARCHAR(15) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Customer Addresses
CREATE TABLE customer_addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    address_detail VARCHAR(255) NOT NULL,
    address_type ENUM('home', 'work', 'other') NOT NULL,
    latitude DECIMAL(10, 6),
    longitude DECIMAL(10, 6),
    is_default_address BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Category-Level Attributes
CREATE TABLE category_attributes (
    category_attribute_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    attribute_id INT NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_id) REFERENCES attribute_definitions(attribute_id) ON DELETE CASCADE,
    UNIQUE KEY (category_id, attribute_id) -- Ensure no duplicate attributes per category
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Category-Level Attribute Options
CREATE TABLE category_attribute_options (
    category_attribute_options_id INT PRIMARY KEY AUTO_INCREMENT,
    category_attribute_id INT NOT NULL,
    option_value VARCHAR(255) NOT NULL,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (category_attribute_id) REFERENCES category_attributes(category_attribute_id) ON DELETE CASCADE,
    UNIQUE KEY (category_attribute_id, option_value) -- Ensure no duplicate options for the same attribute
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Products
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    brand VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    tax_rate DECIMAL(5, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    UNIQUE KEY (category_id, slug) -- Ensure slugs are unique per category
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Conversations
CREATE TABLE conversations (
    conversation_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    agent_id INT NULL, -- Can be NULL if no agent is assigned yet
    product_id INT NULL, -- Can be NULL if not related to a specific product
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Conversation Messages
CREATE TABLE conversation_messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    conversation_id INT NOT NULL,
    sender_id INT NOT NULL, -- Can be customer or agent
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Product reviews
CREATE TABLE product_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    UNIQUE KEY (product_id, customer_id) -- Ensure a customer can only review a product once
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Product Variants
CREATE TABLE product_variants (
    variant_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    sku VARCHAR(100) NOT NULL UNIQUE,
    is_default_variant BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    cost DECIMAL(10, 2) NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    tax_rate DECIMAL(5, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    INDEX idx_sku (sku)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Product Images
CREATE TABLE product_images (
    id INT PRIMARY KEY AUTO_INCREMENT,
    variant_id INT,
    image_url VARCHAR(255),
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id)
);

-- Product Attribute Values
CREATE TABLE product_attribute_values (
    product_attribute_value_id INT PRIMARY KEY AUTO_INCREMENT,
    variant_id INT NOT NULL, -- References the product_variant
    category_attribute_id INT NOT NULL, -- References the category-level attribute
    attribute_value VARCHAR(255) NOT NULL, -- The value of the attribute for the product
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id) ON DELETE CASCADE,
    FOREIGN KEY (category_attribute_id) REFERENCES category_attributes(category_attribute_id),
    FOREIGN KEY (category_attribute_id, attribute_value) REFERENCES category_attribute_options(category_attribute_id, option_value), -- Ensure the attribute value is valid from the category attribute options
    UNIQUE KEY (variant_id, category_attribute_id) -- Ensure no duplicate attribute values per product_variant
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Product Prices
CREATE TABLE product_prices (
    price_id INT PRIMARY KEY AUTO_INCREMENT,
    variant_id INT NOT NULL,
    price_type ENUM('regular', 'sale') NOT NULL DEFAULT 'regular',
    price DECIMAL(10, 2) NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id) ON DELETE CASCADE,
    INDEX idx_variant_dates (variant_id, start_date, end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    purchase_type ENUM('online', 'in_store') NOT NULL DEFAULT 'online',
    store_id INT NULL, -- Nullable for online orders
    order_number VARCHAR(50) NOT NULL UNIQUE, -- For tracking purposes
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
    subtotal DECIMAL(10, 2) NOT NULL,
    tax DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    shipping_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    grand_total DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    INDEX idx_order_date (order_date),
    INDEX idx_customer_date (customer_id, order_date),
    INDEX idx_status (order_status),
    INDEX idx_order_number (order_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Order Items
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    variant_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    sku VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    tax DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    grand_total DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Discounts
CREATE TABLE discounts (
    discount_id INT PRIMARY KEY AUTO_INCREMENT,
    discount_type_id INT NOT NULL,
    discount_name VARCHAR(255) NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL, -- percentage or fixed amount
    start_date DATETIME NOT NULL,
    end_date DATETIME NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (discount_type_id) REFERENCES discount_types(discount_type_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Discount Conditions (what items the discount applies to)
CREATE TABLE discount_conditions (
    condition_id INT PRIMARY KEY AUTO_INCREMENT,
    discount_id INT NOT NULL,
    condition_type ENUM('category', 'product', 'variant', 'store') NOT NULL,
    reference_id INT NOT NULL, -- references category_id, product_id, variant_id, or store_id
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (discount_id) REFERENCES discounts(discount_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Discount Usage (tracking how many times a discount has been used)
CREATE TABLE discount_usage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    discount_id INT NOT NULL,
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    amount_saved DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (discount_id) REFERENCES discounts(discount_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Spring Sessions
CREATE TABLE SPRING_SESSION (
    PRIMARY_ID CHAR(36) NOT NULL,
    SESSION_ID CHAR(36) NOT NULL,
    CREATION_TIME BIGINT NOT NULL,
    LAST_ACCESS_TIME BIGINT NOT NULL,
    MAX_INACTIVE_INTERVAL INT NOT NULL,
    EXPIRY_TIME BIGINT NOT NULL,
    PRINCIPAL_NAME VARCHAR(100),
    CONSTRAINT SPRING_SESSION_PK PRIMARY KEY (PRIMARY_ID),
    UNIQUE INDEX SPRING_SESSION_IX1 (SESSION_ID),
    INDEX SPRING_SESSION_IX2 (EXPIRY_TIME)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE SPRING_SESSION_ATTRIBUTES (
    SESSION_PRIMARY_ID CHAR(36) NOT NULL,
    ATTRIBUTE_NAME VARCHAR(200) NOT NULL,
    ATTRIBUTE_BYTES BLOB NOT NULL,
    CONSTRAINT SPRING_SESSION_ATTRIBUTES_PK PRIMARY KEY (SESSION_PRIMARY_ID, ATTRIBUTE_NAME),
    CONSTRAINT SPRING_SESSION_ATTRIBUTES_FK FOREIGN KEY (SESSION_PRIMARY_ID)
        REFERENCES SPRING_SESSION(PRIMARY_ID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Shopping Carts
CREATE TABLE shopping_carts (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT, -- For logged-in users (handled in Application layer)
    variant_id INT NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,    
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id) ON DELETE CASCADE,
    UNIQUE KEY uq_user_cart (customer_id, variant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Inventory
CREATE TABLE inventories (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    variant_id INT NOT NULL,
    store_id INT NOT NULL,
    quantity INT NOT NULL,
    reserved_quantity INT NOT NULL DEFAULT 0, -- Quantity reserved for pending orders
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id) ON DELETE CASCADE,
    FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE CASCADE,
    UNIQUE KEY (variant_id, store_id), -- Ensure no duplicate inventory records for the same variant in a store
    INDEX idx_store_id (store_id),
    INDEX idx_variant_id (variant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Transactions
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_type ENUM('payment', 'refund', 'chargeback') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('credit_card', 'paypal', 'bank_transfer', 'cash') NOT NULL, 
    transaction_status ENUM('pending', 'completed', 'failed') NOT NULL DEFAULT 'pending',
    processor_id VARCHAR(100) NULL COMMENT 'ID from payment processor',
    processor_response TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Fullfillment
CREATE TABLE fulfillments (
    fulfillment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    store_id INT NOT NULL,
    status ENUM('pending', 'shipped', 'delivered', 'returned') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Fulfillment Items
CREATE TABLE fulfillment_items (
    fulfillment_item_id INT PRIMARY KEY AUTO_INCREMENT,
    fulfillment_id INT NOT NULL,
    order_item_id INT NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (fulfillment_id) REFERENCES fulfillments(fulfillment_id) ON DELETE CASCADE,
    FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Shipping Methods
CREATE TABLE shipping (
    shipping_id INT AUTO_INCREMENT PRIMARY KEY,
    fulfillment_id INT NOT NULL,
    shipping_address_id INT NOT NULL,  
    shipping_method VARCHAR(255) NOT NULL,
    shipping_cost DECIMAL(10, 2) NOT NULL,  -- The cost of shipping for this order
    tracking_number VARCHAR(255) NULL,
    shipped_at TIMESTAMP NULL,
    estimated_delivery TIMESTAMP NULL,  
    status ENUM('pending', 'shipped', 'delivered', 'failed') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (fulfillment_id) REFERENCES fulfillments(fulfillment_id) ON DELETE CASCADE,
    FOREIGN KEY (shipping_address_id) REFERENCES customer_addresses(address_id)
);

-- Constraints
-- Ensure that the only 1 default variant for a product
DELIMITER $$

CREATE TRIGGER ensure_one_default_variant_insert
BEFORE INSERT ON product_variants
FOR EACH ROW
BEGIN
    IF NEW.is_default_variant = TRUE THEN
        -- Check if another default variant already exists for the same product_id
        IF (SELECT COUNT(*) FROM product_variants 
            WHERE product_id = NEW.product_id AND is_default_variant = TRUE) > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only one default variant is allowed per product.';
        END IF;
    END IF;
END$$

DELIMITER;

DELIMITER $$
CREATE TRIGGER ensure_one_default_variant_update
BEFORE UPDATE ON product_variants
FOR EACH ROW
BEGIN
    IF NEW.is_default_variant = TRUE THEN
        -- Check if another default variant already exists for the same product_id
        IF (SELECT COUNT(*) FROM product_variants 
            WHERE product_id = NEW.product_id AND is_default_variant = TRUE) > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only one default variant is allowed per product.';
        END IF;
    END IF;
END$$

DELIMITER;

-- Ensure that the only 1 default address for a customer
DELIMITER $$

CREATE TRIGGER ensure_one_default_address_insert
BEFORE INSERT ON customer_addresses
FOR EACH ROW
BEGIN
    IF NEW.is_default_address = TRUE THEN
        -- Check if another default address already exists for the same customer_id
        IF (SELECT COUNT(*) FROM customer_addresses 
            WHERE customer_id = NEW.customer_id AND is_default_address = TRUE) > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only one default address is allowed.';
        END IF;
    END IF;
END$$

DELIMITER;

DELIMITER $$

CREATE TRIGGER ensure_one_default_address_update
BEFORE INSERT ON customer_addresses
FOR EACH ROW
BEGIN
    IF NEW.is_default_address = TRUE THEN
        -- Check if another default address already exists for the same customer_id
        IF (SELECT COUNT(*) FROM customer_addresses 
            WHERE customer_id = NEW.customer_id AND is_default_address = TRUE) > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only one default address is allowed.';
        END IF;
    END IF;
END$$

DELIMITER;

-- Views
-- View for valid product prices
CREATE OR REPLACE VIEW valid_product_prices AS
SELECT
    pv.variant_id,
    pv.product_id,
    COALESCE(sp.price, rp.price, pv.base_price) AS current_price,
    CASE
        WHEN sp.price IS NOT NULL THEN 'sale'
        WHEN rp.price IS NOT NULL THEN 'regular'
        ELSE 'base'
    END AS price_type
FROM
    product_variants pv
LEFT JOIN (
    SELECT
        pp.variant_id,
        pp.price
    FROM
        product_prices pp
    WHERE
        pp.price_type = 'sale'
        AND pp.start_date <= CURRENT_TIMESTAMP
        AND (pp.end_date IS NULL OR pp.end_date >= CURRENT_TIMESTAMP)
    GROUP BY pp.variant_id
    HAVING MAX(pp.start_date)
) AS sp ON pv.variant_id = sp.variant_id
LEFT JOIN (
    SELECT
        pp.variant_id,
        pp.price
    FROM
        product_prices pp
    WHERE
        pp.price_type = 'regular'
        AND pp.start_date <= CURRENT_TIMESTAMP
        AND (pp.end_date IS NULL OR pp.end_date >= CURRENT_TIMESTAMP)
    GROUP BY pp.variant_id
    HAVING MAX(pp.start_date)
) AS rp ON pv.variant_id = rp.variant_id
WHERE
    pv.deleted_at IS NULL;