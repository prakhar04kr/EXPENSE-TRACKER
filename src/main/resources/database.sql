-- ================================
-- Database Name: prakhar
-- Tables created:
--   - users(id, username, email, password)
--   - expenses(id, user_id, title, amount, date)
--
-- Default login credentials (for testing):
--   Username: admin
--   Password: admin123
-- ================================

CREATE DATABASE IF NOT EXISTS prakhar
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE prakhar;

-- ================================
-- users
-- ================================
CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT,
  username VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_users_username (username),
  UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB;

-- ================================
-- expenses
-- ================================
CREATE TABLE IF NOT EXISTS expenses (
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  amount DOUBLE NOT NULL,
  date DATE NOT NULL,
  PRIMARY KEY (id),
  KEY idx_expenses_user_id (user_id),
  CONSTRAINT fk_expenses_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- ================================
-- Seed data
-- ================================

-- 1) Admin user
INSERT INTO users (username, email, password)
VALUES ('admin', 'admin@example.com', 'admin123')
ON DUPLICATE KEY UPDATE
  email = VALUES(email),
  password = VALUES(password);

-- 2) 5 sample expenses for the admin user
INSERT INTO expenses (user_id, title, amount, date)
VALUES
  ((SELECT id FROM users WHERE username='admin'), 'Groceries', 250.50, '2026-06-01'),
  ((SELECT id FROM users WHERE username='admin'), 'Transport', 120.00, '2026-06-02'),
  ((SELECT id FROM users WHERE username='admin'), 'Dining', 89.99,  '2026-06-03'),
  ((SELECT id FROM users WHERE username='admin'), 'Utilities', 210.75, '2026-06-04'),
  ((SELECT id FROM users WHERE username='admin'), 'Shopping', 499.20, '2026-06-05');

-- ================================
-- Query compatibility notes (from project code)
-- ================================
-- UserDao uses:
--   users(username,email,password), id
--   SELECT * FROM users WHERE username=? AND password=?
--   SELECT * FROM users WHERE username=? AND email=?
--   UPDATE users SET username=?, email=?, password=? WHERE id=?
--   DELETE FROM users WHERE id=?
-- ExpenseDAO uses:
--   expenses(user_id,title,amount,date), id,user_id
--   INSERT INTO expenses(user_id,title,amount,date)
--   SELECT * FROM expenses WHERE user_id=?
--   DELETE FROM expenses WHERE id=? AND user_id=?

