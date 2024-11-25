MERGE INTO users (username, password, enabled) KEY (username) VALUES ('admin', 'admin', true);
MERGE INTO authorities (username, authority) KEY (username, authority) VALUES ('admin', 'ROLE_USER');