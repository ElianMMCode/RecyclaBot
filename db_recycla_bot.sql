/*ver usuarios
SELECT User, Host FROM mysql.user;

crear usuario

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'SENA2025';

GRANT ALL PRIVILEGES ON db_recycla_bot TO 'admin'@'localhost';

cambiar contraseña usuario

ALTER USER 'root'@'localhost' IDENTIFIED BY 'SENA2025';*/

#crear base de datos

CREATE DATABASE db_recycla_bot;

USE db_recycla_bot;

CREATE TABLE tb_users (
user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100),
agent_name VARCHAR (200),
last_name VARCHAR(100) NOT NULL,
fk_document_type_id INT NOT NULL,
number_documet INT UNIQUE NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
password VARCHAR(255) NOT NULL,
fk_city_id INT NOT NULL,
fk_town_id INT NOT NULL,
latitude INT,
longitude INT,
adress VARCHAR(150),
profile_imag VARCHAR (255),
description TEXT,
Estado ENUM('activo', 'suspendido', 'inactivo')NOT NULL
);

CREATE TABLE tb_document_type(
document_type_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(20),
description TEXT
);

CREATE TABLE tb_citizens (
citizen_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
fk_user_id INT NOT NULL
);

CREATE TABLE tb_ECA_points (
ECA_point_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
fk_user_id INT UNIQUE NOT NULL,
schedule TEXT NOT NULL,
fk_inventory_id INT UNIQUE NOT NULL
);

CREATE TABLE tb_ECA_point_inventory (
inventory_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
fk_ECA_point_id INT UNIQUE NOT NULL,
fk_material_id INT NOT NULL,
price DECIMAL NOT NULL,
unit ENUM('Kg', 'unidad', 'lb') NOT NULL,
weight DECIMAL NOT NULL,
max_capacity DECIMAL NOT NULL,
current_capacity DECIMAL NOT NULL,
last_update DATETIME NOT NULL,
storage_condition ENUM('full', 'empty', 'low') NOT NULL
);

CREATE TABLE tb_update_inventory(
update_in_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
fk_inventory_id INT UNIQUE NOT NULL,
fk_user_id INT UNIQUE NOT NULL,
update_date DATETIME NOT NULL,
received_quantity DECIMAL NOT NULL,
unit ENUM('Kg', 'unidad', 'lb') NOT NULL,
storage_condition ENUM('full', 'empty', 'low')
);

CREATE TABLE tb_materials (
material_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(60) NOT NULL,
description TEXT
);

CREATE TABLE tb_admin (
admin_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
fk_user_id INT NOT NULL
);

CREATE TABLE tb_cities(
city_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) DEFAULT('Bogotá')
);

CREATE TABLE tb_towns(
town_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
fk_city_id INT NOT NULL
);

CREATE TABLE tb_publications (
publication_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
title VARCHAR (130) NOT NULL,
content TEXT NOT NULL,
publication_date DATETIME NOT NULL,
link VARCHAR (255),
fk_publication_type_id INT NOT NULL
);

CREATE TABLE tb_publication_type (
publication_type_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
description TEXT
);

CREATE TABLE tb_comments(
comment_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
fk_citizen_id INT UNIQUE NOT NULL,
comment TEXT NOT NULL,
comment_date DATETIME NOT NULL,
fk_source_id INT NOT NULL
);

CREATE TABLE tb_favorites (
favorite_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
fk_citizen_id INT NOT NULL,
fk_source_id INT NOT NULL
);

CREATE TABLE tb_notification (
notification_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
fk_citizen_id INT NOT NULL,
message TEXT NOT NULL,
send_date DATETIME NOT NULL,
fk_module_id INT NOT NULL,
link VARCHAR(255),
fk_publication_id INT NOT NULL
);

CREATE TABLE tb_source (
source_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
source_type VARCHAR(50) NOT NULL,
fk_publication_id INT UNIQUE,
fk_ECA_point_id INT UNIQUE
);

CREATE TABLE tb_chatbot (
QA_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
question TEXT NOT NULL,
fk_answer_id INT NOT NULL,
link VARCHAR(255),
fk_source_id INT UNIQUE NOT NULL
);

CREATE TABLE tb_chatbot_unanswered (
unanswered_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
question TEXT NOT NULL,
submission_date DATETIME NOT NULL,
fk_citizen_id INT NOT NULL,
review_coments TEXT,
converted_QA_id INT UNIQUE
);

CREATE TABLE tb_answers(
answer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
status VARCHAR(20) NOT NULL,
comment TEXT
);

#tb_users
ALTER TABLE tb_users ADD FOREIGN KEY (fk_city_id) REFERENCES tb_cities (city_id);
ALTER TABLE tb_users ADD FOREIGN KEY (fk_town_id) REFERENCES tb_towns (town_id);
ALTER TABLE tb_users ADD FOREIGN KEY (fk_document_type_id) REFERENCES tb_document_type (document_type_id);

#tb_citizens
ALTER TABLE tb_citizens ADD FOREIGN KEY (fk_user_id) REFERENCES tb_users (user_id);

#tb_admin
ALTER TABLE tb_admin ADD FOREIGN KEY (fk_user_id) REFERENCES tb_users (user_id);

#tb_ECA_points
ALTER TABLE tb_ECA_points ADD FOREIGN KEY (fk_user_id) REFERENCES tb_users (user_id);
ALTER TABLE tb_ECA_points ADD FOREIGN KEY (fk_inventory_id) REFERENCES tb_ECA_point_inventory(inventory_id);

#tb_ECA_point_inventory
ALTER TABLE tb_ECA_point_inventory ADD FOREIGN KEY (fk_ECA_point_id) REFERENCES tb_ECA_points (ECA_point_id);
ALTER TABLE tb_ECA_point_inventory ADD FOREIGN KEY (fk_material_id) REFERENCES tb_materials (material_id);

#tb_update_inventory
ALTER TABLE tb_update_inventory ADD FOREIGN KEY (fk_inventory_id) REFERENCES tb_ECA_point_inventory (inventory_id);
ALTER TABLE tb_update_inventory ADD FOREIGN KEY (fk_user_id) REFERENCES tb_users (user_id);

#tb_publications
ALTER TABLE tb_publications ADD FOREIGN KEY (fk_publication_type_id) REFERENCES tb_publication_type (publication_type_id);

#tb_comments
ALTER TABLE tb_comments ADD FOREIGN KEY (fk_citizen_id) REFERENCES tb_citizens (citizen_id);
ALTER TABLE tb_comments ADD FOREIGN KEY (fk_source_id) REFERENCES tb_source (source_id);

#tb_favorites
ALTER TABLE tb_favorites ADD FOREIGN KEY (fk_citizen_id) REFERENCES tb_citizens (citizen_id);
ALTER TABLE tb_favorites ADD FOREIGN KEY (fk_source_id) REFERENCES tb_source (source_id);

#tb_notification
ALTER TABLE tb_notification ADD FOREIGN KEY (fk_citizen_id) REFERENCES tb_citizens (citizen_id);
ALTER TABLE tb_notification ADD FOREIGN KEY (fk_publication_id) REFERENCES tb_publications (publication_id);

#tb_source
ALTER TABLE tb_source ADD FOREIGN KEY (fk_publication_id) REFERENCES tb_publications (publication_id);
ALTER TABLE tb_source ADD FOREIGN KEY (fk_ECA_point_id) REFERENCES tb_ECA_points (ECA_point_id);

#tb_chatbot
ALTER TABLE tb_chatbot ADD FOREIGN KEY (fk_answer_id) REFERENCES tb_answers (answer_id);
ALTER TABLE tb_chatbot ADD FOREIGN KEY (fk_source_id) REFERENCES tb_source (source_id);

#tb_chatbot_unanswered
ALTER TABLE tb_chatbot_unanswered ADD FOREIGN KEY (fk_citizen_id) REFERENCES tb_citizens (citizen_id);
ALTER TABLE tb_chatbot_unanswered ADD FOREIGN KEY (converted_QA_id) REFERENCES tb_chatbot (QA_id);

