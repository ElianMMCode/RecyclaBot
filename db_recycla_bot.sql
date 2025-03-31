/*ver usuarios
SELECT User, Host FROM mysql.user;

crear usuario

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'SENA2025';

GRANT ALL PRIVILEGES ON db_recycla_bot TO 'admin'@'localhost';

cambiar contraseña usuario

ALTER USER 'root'@'localhost' IDENTIFIED BY 'SENA2025';

*/crear base de datos

CREATE DATABASE db_recycla_bot;

USE db_recycla_bot;

CREATE TABLE tb_people (
user_id INT PRIMARY KEY AUTO_INCREMENTE,
name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
password VARCHAR(256) NOT NULL,
city VARCHAR(50) DEFAULT('Bogotá'),
town VARCHAR(50),
profile_imag VARCHAR (256),
description TEXT
);

CREATE TABLE tb_favorites (
favorite_id INT PRIMARY KEY AUTO_INCREMENTE,
fk_user_id INT NOT NULL,
fk_module_id INT NOT NULL
);

CREATE TABLE tb_modules (
module_id INT PRIMARY KEY AUTO_INCREMENTE,
module_name VARCHAR(100) NOT NULL,
description TEXT NOT NULL
fk_notice_id INT
fk_recycling_points_id INT
);

CREATE TABLE tb_admin (
admin_id INT PRIMARY KEY AUTO_INCREMENTE,
fk_user_id INT NOT NULL
);

CREATE TABLE tb_recyclers (
recycler_id INT PRIMARY KEY AUTO_INCREMENTE,
fk_user_id INT NOT NULL
);

CREATE TABLE tb_notification (
notification_id INT PRIMARY KEY AUTO_INCREMENTE,
fk_user_id INT NOT NULL,
message TEXT, NOT NULL,
fk_module_id INT NOT NULL,
link VARCHAR(256)
);

CREATE TABLE tb_chatbot (
qa_id INT PRIMARY KEY AUTO_INCREMENTE,
question TEXT NOT NULL,
fk_answer_id INT NOT NULL,
link VARCHAR(256)
);

CREATE TABLE tb_answers(
answer_id INT PRIMARY KEY AUTO_INCREMENTE,
fk_user_id INT NOT NULL,
status VARCHAR(20) NOT NULL,
comment TEXT
);

CREATE TABLE tb_comments(
comment_id INT PRIMARY KEY AUTO_INCREMENTE,
comment TEXT NOT NULL,
comment_date DATETIME NOT NULL,
fk_user_id INT NOT NULL,
fk_module_id INT NOT NULL
);

CREATE TABLE tb_news (
news_id INT PRIMARY KEY AUTO_INCREMENTE,
title VARCHAR (130) NOT NULL,
content TEXT NOT NULL,
publication_date DATETIME NOT NULL
);

CREATE TABLE tb_recycling_points (
point_id INT PRIMARY KEY AUTO_INCREMENTE,
name VARCHAR(100) NOT NULL,
schedule TEXT NOT NULL,
fk_recycler_id INT NOT NULL,
city VARCHAR(50) DEFAULT('Bogotá'),
town VARCHAR(50) NOT NULL,
latitude INT,
longitude INT,
adress VARCHAR (200) NOT NULL,
fk_price_table_id INT NOT NULL
);

CREATE TABLE tb_price_tables (
price_table_id INT PRIMARY KEY AUTO_INCREMENTE,
fk_material_id INT NOT NULL,
price DECIMAL NOT NULL
);

CREATE TABLE tb_materials (
material_id INT PRIMARY KEY AUTO_INCREMENTE,
name VARCHAR(60) NOT NULL
);

ALTER TABLE tb_admin ADD FOREIGN KEY (fk_user_id) REFERENCES tb_people (user_id);
ALTER TABLE tb_recyclers ADD FOREIGN KEY (fk_user_id) REFERENCES tb_people (user_id);
ALTER TABLE tb_favorites ADD FOREIGN KEY (fk_user_id) REFERENCES tb_people (user_id);
ALTER TABLE tb_favorites ADD FOREIGN KEY (fk_module_id) REFERENCES tb_modules (module_id);
ALTER TABLE tb_notification ADD FOREIGN KEY (fk_user_id) REFERENCES tb_people (user_id);
ALTER TABLE tb_notification ADD FOREIGN KEY (fk_module_id) REFERENCES tb_modules (module_id);
ALTER TABLE tb_chatbot ADD FOREIGN KEY (fk_answer_id) REFERENCES tb_answers (answer_id);
ALTER TABLE tb_answers ADD FOREIGN KEY (fk_user_id) REFERENCES tb_people (user_id);
ALTER TABLE tb_comments ADD FOREIGN KEY (fk_user_id) REFERENCES tb_people (user_id);
ALTER TABLE tb_comments ADD FOREIGN KEY (fk_module_id) REFERENCES tb_modules (module_id);
ALTER TABLE tb_recycling_points ADD FOREIGN KEY (fk_recycler_id) REFERENCES tb_recyclers (recycler_id);
ALTER TABLE tb_recycling_points ADD FOREIGN KEY (fk_price_table_id) REFERENCES tb_price_tables (price_table_id);
ALTER TABLE tb_price_tables ADD FOREIGN KEY (fk_material_id) REFERENCES tb_materials (material_id);
ALTER TABLE tb_modules ADD FOREIGN KEY (fk_notice_id) REFERENCES tb_news (news_id);
ALTER TABLE tb_modules ADD FOREIGN KEY (fk_recycling_points_id) REFERENCES tb_recycling_points (point_id);



