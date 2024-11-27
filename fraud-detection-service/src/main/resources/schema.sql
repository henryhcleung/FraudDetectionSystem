-- Create the transactions table if it does not exist
CREATE TABLE IF NOT EXISTS TRANSACTIONS (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    details VARCHAR(255)
);

-- Create the users table if it does not exist 
CREATE TABLE IF NOT EXISTS users (
    username VARCHAR(50) NOT NULL PRIMARY KEY,
    password VARCHAR(255) NOT NULL UNIQUE,
    enabled BOOLEAN NOT NULL
);

-- Create the authorities table if it does not exist
CREATE TABLE IF NOT EXISTS authorities (
    username VARCHAR(50) NOT NULL,
    authority VARCHAR(50) NOT NULL,
    FOREIGN KEY (username) REFERENCES users(username)
);