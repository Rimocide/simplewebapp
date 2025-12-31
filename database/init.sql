-- Initialize database schema

CREATE TABLE IF NOT EXISTS posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO posts (title, content) VALUES 
    ('Welcome', 'This is the first post from the database.');


INSERT INTO posts (title, content) VALUES 
    ('Welcome', 'This is the second post from the database.');

INSERT INTO posts (title, content) VALUES 
    ('Welcome', 'This is the third post from the database.');
