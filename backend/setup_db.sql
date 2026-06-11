-- =============================================================================
-- Jubi Ticket Management System — Database Setup Script
-- Database: jubi_ticketdb
-- Run this script as the postgres superuser:
--   psql -U postgres -f setup_db.sql
-- =============================================================================

-- 1. Create the database (run disconnected from any specific DB)
CREATE DATABASE jubi_ticketdb;

-- 2. Connect to the new database before creating tables
\connect jubi_ticketdb


-- =============================================================================
-- TABLE: tickets
-- Core support ticket records
-- =============================================================================
CREATE TABLE IF NOT EXISTS tickets (
    id                          SERIAL PRIMARY KEY,
    ticket_id                   VARCHAR(16) UNIQUE NOT NULL,
    created_at                  TIMESTAMPTZ DEFAULT NOW(),
    full_name                   TEXT NOT NULL,
    emp_code                    TEXT,
    mobile                      TEXT,
    email                       TEXT,
    category                    TEXT,
    sub_category                TEXT,
    mode                        TEXT,
    subject                     TEXT,
    description                 TEXT,
    branch                      TEXT,
    department                  TEXT,
    support_type                TEXT,
    attachment                  BYTEA,
    attachment_name             TEXT,
    bill_attachment             BYTEA,
    bill_attachment_name        TEXT,
    expense_amount              NUMERIC(15,2),
    assignee                    TEXT,
    status                      TEXT DEFAULT 'Not Started',
    admin_description           TEXT,
    pending_time                TIMESTAMPTZ,
    pending_comments            TEXT,
    in_progress_time            TIMESTAMPTZ,
    completed_time              TIMESTAMPTZ,
    resolution_comments         TEXT,
    user_confirmation           TEXT DEFAULT 'Pending',
    admin_comments              JSONB DEFAULT '[]'::JSONB,
    is_delete                   BOOLEAN DEFAULT FALSE
);


-- =============================================================================
-- TABLE: admin_users
-- Admin/staff user accounts for the dashboard
-- =============================================================================
CREATE TABLE IF NOT EXISTS admin_users (
    id                  SERIAL PRIMARY KEY,
    name                TEXT NOT NULL,
    emp_code            TEXT,
    email               TEXT UNIQUE NOT NULL,
    password            TEXT NOT NULL,
    access              TEXT DEFAULT 'View',
    support_type        TEXT DEFAULT 'IT Support,Admin Support',
    branch              TEXT,
    receiver_position   TEXT,
    can_receive_mail    BOOLEAN DEFAULT FALSE,
    can_send_mail       BOOLEAN DEFAULT FALSE,
    is_first_login      BOOLEAN DEFAULT TRUE,
    security_question   TEXT,
    security_answer     TEXT,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- Seed the default super-admin account
INSERT INTO admin_users (name, email, password, access, support_type, branch)
VALUES ('Admin User', 'admin@support.com', 'Admin@123', 'View,Edit,Export', 'IT Support,Admin Support', 'All')
ON CONFLICT (email) DO NOTHING;


-- =============================================================================
-- TABLE: assignees
-- Technicians / staff who can be assigned to tickets
-- =============================================================================
CREATE TABLE IF NOT EXISTS assignees (
    id           SERIAL PRIMARY KEY,
    name         TEXT NOT NULL,
    support_type TEXT NOT NULL DEFAULT 'IT Support,Admin Support',
    is_delete    BOOLEAN DEFAULT FALSE,
    created_at   TIMESTAMPTZ DEFAULT NOW()
);


-- =============================================================================
-- TABLE: departments
-- Organisation departments used for ticket categorisation
-- =============================================================================
CREATE TABLE IF NOT EXISTS departments (
    id           SERIAL PRIMARY KEY,
    name         TEXT NOT NULL,
    support_type TEXT NOT NULL,
    is_delete    BOOLEAN DEFAULT FALSE,
    created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- Seed default departments
INSERT INTO departments (name, support_type) VALUES
    ('Marketing/Business development', 'Admin Support'),
    ('Product Development',            'Admin Support'),
    ('Designing',                      'Admin Support'),
    ('Visual Merchandising',           'Admin Support'),
    ('BIU',                            'Admin Support'),
    ('Merchandising',                  'Admin Support'),
    ('HR',                             'Admin Support'),
    ('Admin & IT',                     'IT Support,Admin Support'),
    ('Accounts',                       'Admin Support'),
    ('Documentation',                  'Admin Support'),
    ('Operations',                     'Admin Support')
ON CONFLICT DO NOTHING;


-- =============================================================================
-- TABLE: categories
-- Ticket categories (linked to support type)
-- =============================================================================
CREATE TABLE IF NOT EXISTS categories (
    id           SERIAL PRIMARY KEY,
    name         TEXT NOT NULL,
    support_type TEXT NOT NULL,
    is_delete    BOOLEAN DEFAULT FALSE,
    created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- Seed default categories
INSERT INTO categories (name, support_type) VALUES
    ('Asset Request',             'Admin Support'),
    ('New Purchase Request',      'Admin Support'),
    ('Stock Shortage',            'Admin Support'),
    ('Stationery Request',        'Admin Support'),
    ('New SIM Request',           'Admin Support'),
    ('ID Card Request',           'Admin Support'),
    ('Electrical Issue',          'Admin Support'),
    ('Water Supply Issue',        'Admin Support'),
    ('AC / HVAC',                 'Admin Support'),
    ('Plumbing Issue',            'Admin Support'),
    ('Pest Control',              'Admin Support'),
    ('Civil Work / Maintenance',  'Admin Support'),
    ('Housekeeping / Cleaning',   'Admin Support'),
    ('Drinking Water',            'Admin Support'),
    ('Parking Issue',             'Admin Support'),
    ('Office Shifting / Setup',   'Admin Support'),
    ('Vendor Issue',              'Admin Support'),
    ('Furniture / Fixtures',      'Admin Support'),
    ('Others',                    'IT Support,Admin Support'),
    ('System issue',              'IT Support'),
    ('Network issue',             'IT Support'),
    ('Software issue',            'IT Support'),
    ('Printer issues',            'IT Support'),
    ('Material request',          'IT Support'),
    ('Tonner issues',             'IT Support'),
    ('Server issue',              'IT Support'),
    ('Keyboard & mouse issue',    'IT Support'),
    ('Outlook issue',             'IT Support'),
    ('Mail storage issue',        'IT Support')
ON CONFLICT DO NOTHING;


-- =============================================================================
-- TABLE: asset_types
-- Hardware/asset category types
-- =============================================================================
CREATE TABLE IF NOT EXISTS asset_types (
    id         SERIAL PRIMARY KEY,
    name       TEXT NOT NULL,
    is_delete  BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seed default asset types
INSERT INTO asset_types (name) VALUES
    ('CPU'),
    ('Laptop'),
    ('Access point'),
    ('Monitor'),
    ('NAS'),
    ('Printer'),
    ('Server'),
    ('Switch'),
    ('UPS'),
    ('Mobile'),
    ('Firewall')
ON CONFLICT DO NOTHING;


-- =============================================================================
-- TABLE: assets
-- Physical IT/Admin assets tracked in the system
-- =============================================================================
CREATE TABLE IF NOT EXISTS assets (
    id            SERIAL PRIMARY KEY,
    asset_id      TEXT UNIQUE NOT NULL,
    category      TEXT,
    brand         TEXT,
    model         TEXT,
    configuration TEXT,
    serial        TEXT,
    assignee      TEXT DEFAULT 'Unassigned',
    emp_code      TEXT,
    cug           TEXT,
    email         TEXT,
    department    TEXT,
    branch        TEXT,
    purchase_date DATE,
    warranty      TEXT,
    warranty_date DATE,
    warranty_label TEXT,
    condition     TEXT DEFAULT 'Excellent',
    remarks       TEXT,
    images        TEXT,
    qr_code       TEXT,
    "group"       TEXT DEFAULT 'IT',
    created_at    TIMESTAMPTZ DEFAULT NOW(),
    updated_at    TIMESTAMPTZ DEFAULT NOW()
);


-- =============================================================================
-- Done
-- =============================================================================
\echo 'jubi_ticketdb setup complete. All tables created and seeded.'
