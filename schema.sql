DROP DATABASE IF EXISTS tata1mg_db;
CREATE DATABASE tata1mg_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tata1mg_db;

CREATE TABLE cities (
    city_id       INT          NOT NULL,
    city_name     VARCHAR(50)  NOT NULL,
    state         VARCHAR(50)  NOT NULL,
    region        VARCHAR(10)  NOT NULL,
    has_express   TINYINT(1)   NOT NULL DEFAULT 0,
    CONSTRAINT pk_cities PRIMARY KEY (city_id),
    CONSTRAINT uq_cities_name UNIQUE (city_name),
    CONSTRAINT chk_cities_region CHECK (region IN ('North','South','East','West','Central'))
) ENGINE=InnoDB;

CREATE TABLE customers (
    customer_id          INT           NOT NULL,
    customer_name        VARCHAR(100)  NOT NULL,
    gender               VARCHAR(10)   NOT NULL,
    age_group            VARCHAR(10)   NOT NULL,
    city_id              INT           NOT NULL,
    signup_date          DATE          NOT NULL,
    acquisition_channel  VARCHAR(20)   NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id),
    CONSTRAINT fk_customers_city FOREIGN KEY (city_id) REFERENCES cities (city_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE products (
    product_id     INT            NOT NULL,
    product_name   VARCHAR(100)   NOT NULL,
    category       VARCHAR(30)    NOT NULL,
    brand_type     VARCHAR(20)    NOT NULL,
    composition    VARCHAR(100)   NULL,
    mrp            DECIMAL(10,2)  NOT NULL,
    selling_price  DECIMAL(10,2)  NOT NULL,
    requires_rx    TINYINT(1)     NOT NULL DEFAULT 0,
    CONSTRAINT pk_products PRIMARY KEY (product_id),
    CONSTRAINT chk_products_brand CHECK (brand_type IN ('Branded','Generic','1mg Own Brand')),
    CONSTRAINT chk_products_price CHECK (selling_price <= mrp)
) ENGINE=InnoDB;

CREATE TABLE orders (
    order_id            INT            NOT NULL,
    customer_id         INT            NOT NULL,
    order_datetime      DATETIME       NOT NULL,
    delivery_type       VARCHAR(10)    NOT NULL,
    delivered_datetime  DATETIME       NULL,
    order_status        VARCHAR(15)    NOT NULL,
    payment_mode        VARCHAR(15)    NOT NULL,
    order_value         DECIMAL(10,2)  NOT NULL DEFAULT 0,
    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_orders_type CHECK (delivery_type IN ('Express','Standard')),
    CONSTRAINT chk_orders_status CHECK (order_status IN ('Delivered','Cancelled','Returned')),
    INDEX idx_orders_datetime (order_datetime)
) ENGINE=InnoDB;

CREATE TABLE order_items (
    order_item_id                INT            NOT NULL,
    order_id                     INT            NOT NULL,
    product_id                   INT            NOT NULL,
    quantity                     INT            NOT NULL,
    unit_price                   DECIMAL(10,2)  NOT NULL,
    item_status                  VARCHAR(15)    NOT NULL,
    substituted_from_product_id  INT            NULL,
    CONSTRAINT pk_order_items PRIMARY KEY (order_item_id),
    CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders (order_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products (product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_items_substituted_from FOREIGN KEY (substituted_from_product_id) REFERENCES products (product_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_items_qty CHECK (quantity > 0),
    CONSTRAINT chk_items_status CHECK (item_status IN ('Fulfilled','Out of Stock'))
) ENGINE=InnoDB;

CREATE TABLE lab_tests (
    test_id        INT            NOT NULL,
    test_name      VARCHAR(60)    NOT NULL,
    test_category  VARCHAR(30)    NOT NULL,
    price          DECIMAL(10,2)  NOT NULL,
    CONSTRAINT pk_lab_tests PRIMARY KEY (test_id),
    CONSTRAINT uq_lab_tests_name UNIQUE (test_name)
) ENGINE=InnoDB;

CREATE TABLE phlebotomists (
    phlebotomist_id    INT           NOT NULL,
    phlebotomist_name  VARCHAR(100)  NOT NULL,
    city_id            INT           NOT NULL,
    joining_date       DATE          NOT NULL,
    CONSTRAINT pk_phlebotomists PRIMARY KEY (phlebotomist_id),
    CONSTRAINT fk_phlebotomists_city FOREIGN KEY (city_id) REFERENCES cities (city_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE lab_bookings (
    booking_id         INT            NOT NULL,
    customer_id        INT            NOT NULL,
    test_id            INT            NOT NULL,
    phlebotomist_id    INT            NOT NULL,
    booking_datetime   DATETIME       NOT NULL,
    collection_status  VARCHAR(15)    NOT NULL,
    booking_amount     DECIMAL(10,2)  NOT NULL,
    CONSTRAINT pk_lab_bookings PRIMARY KEY (booking_id),
    CONSTRAINT fk_bookings_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_bookings_test FOREIGN KEY (test_id) REFERENCES lab_tests (test_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_bookings_phlebotomist FOREIGN KEY (phlebotomist_id) REFERENCES phlebotomists (phlebotomist_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_bookings_status CHECK (collection_status IN ('Collected','Missed','Rescheduled')),
    INDEX idx_bookings_datetime (booking_datetime)
) ENGINE=InnoDB;

CREATE TABLE consultations (
    consult_id        INT            NOT NULL,
    customer_id       INT            NOT NULL,
    specialty         VARCHAR(30)    NOT NULL,
    consult_datetime  DATETIME       NOT NULL,
    consult_mode      VARCHAR(10)    NOT NULL,
    fee               DECIMAL(10,2)  NOT NULL,
    consult_status    VARCHAR(15)    NOT NULL,
    CONSTRAINT pk_consultations PRIMARY KEY (consult_id),
    CONSTRAINT fk_consultations_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_consult_mode CHECK (consult_mode IN ('Audio','Video','Chat')),
    CONSTRAINT chk_consult_status CHECK (consult_status IN ('Completed','Cancelled')),
    INDEX idx_consult_datetime (consult_datetime)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;
START TRANSACTION;