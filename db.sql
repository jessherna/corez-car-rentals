/*
+---------------------------+
| COREZ CAR RENTAL DATABASE |
+---------------------------+
*/

/*
IMPORTANT NOTE: 
Please note that if you Run Script,this code will will delete all tables, views,
packages, procedures, functions, and triggers in the current user's schema, 
and their associated constraints and dependencies. 

You should take a backup of your database before running this.
*/


/*
+-------------------+
| REMOVE ALL TABLES |
+-------------------+
*/

BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                   FROM user_objects
                   WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'TRIGGER'))
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE' OR cur_rec.object_type = 'VIEW' THEN
            EXECUTE IMMEDIATE('DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" CASCADE CONSTRAINTS');
         ELSE
            EXECUTE IMMEDIATE('DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"');
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END LOOP;
END;
/


/*
+---------------+
| CREATE TABLES |
+---------------+
*/

CREATE TABLE address (
  address_id INT PRIMARY KEY,
  address_houseno VARCHAR(30),
  address_postalcode VARCHAR(6) NOT NULL,
  address_city VARCHAR(30)
);

CREATE TABLE employee (
  employee_id INT PRIMARY KEY,
  employee_fname VARCHAR(30) NOT NULL,
  employee_lname VARCHAR(30) NOT NULL,
  employee_salary NUMBER(8,2) NOT NULL,
  employee_contact NUMBER(11),
  employee_joindate DATE NOT NULL,
  employee_role VARCHAR(20),
  address_id INT,
  CONSTRAINT fk_address
    FOREIGN KEY (address_id)
    REFERENCES address(address_id)
);


CREATE TABLE customer (
  customer_id INT PRIMARY KEY,
  customer_fname VARCHAR(30) NOT NULL,
  customer_lname VARCHAR(30) NOT NULL,
  customer_contact NUMBER(11) NOT NULL,
  customer_license VARCHAR(30) NOT NULL,
  address_id INT,
  CONSTRAINT fk_cus_address
    FOREIGN KEY (address_id)
    REFERENCES address(address_id)
);

CREATE TABLE car (
  car_id INTEGER PRIMARY KEY,
  car_make VARCHAR(20) NOT NULL,
  car_type VARCHAR(20) NOT NULL,
  car_model VARCHAR(20) NOT NULL,
  car_dailyrent NUMBER(6,2) NOT NULL,
  car_plateno VARCHAR(20) NOT NULL,
  car_mileage INTEGER,
  car_passengers INTEGER,
  car_color VARCHAR(20),
  car_doors INTEGER,
  car_transmission VARCHAR(10),
  car_fueltype VARCHAR(6),
  car_gps VARCHAR(3),
  car_bluetooth VARCHAR(3),
  car_aircon VARCHAR(3),
  car_maintenance DATE,
  car_condition VARCHAR(4) NOT NULL,
  
  -- CONSTRAINTS
  CHECK (car_transmission IN ('Automatic', 'Manual')),
  CHECK (car_fueltype IN ('Diesel', 'Gas','NA')),
  CHECK (car_gps IN ('Yes', 'No')),
  CHECK (car_bluetooth IN ('Yes', 'No')),
  CHECK (car_aircon IN ('Yes', 'No')),
  CHECK (car_condition IN ('New', 'Used'))
);


CREATE TABLE inventory (
    inventory_id int PRIMARY KEY,
    inventory_status varchar(9) NOT NULL,
    car_id int,
    FOREIGN KEY (car_id) REFERENCES car(car_id)
);

CREATE TABLE reservation (
    reservation_id INT PRIMARY KEY,
    reservation_date DATE NOT NULL,
    reservation_pickup DATE NOT NULL,
    reservation_return DATE NOT NULL,
    reservation_location VARCHAR(30) NOT NULL,
    reservation_duration INT NOT NULL,
    reservation_status VARCHAR(11) NOT NULL,
    inventory_id INT,
    customer_id INT,
    employee_id INT,
    FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id),
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
    FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
);

CREATE TABLE payment (
  payment_id INT PRIMARY KEY,
  payment_amount NUMERIC(6,2) NOT NULL,
  payment_date DATE NOT NULL,
  payment_refund NUMERIC(6,2),
  payment_damage NUMERIC(6,2),
  reservation_id INT NOT NULL,
  customer_id INT NOT NULL,
  FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id),
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

/*
+------------------+
| SHOW CONSTRAINTS |
+------------------+
*/

SELECT
  table_name,
  constraint_name,
  constraint_type
FROM
  user_constraints
WHERE
  table_name IN (
  'ADDRESS', 
  'EMPLOYEE', 
  'CUSTOMER', 
  'CAR', 
  'INVENTORY', 
  'RESERVATION', 
  'PAYMENT'
);

/*
+-------------------------+
| INSERT DATA INTO TABLES |
+-------------------------+
*/

/* address table */
INSERT ALL
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (1, '123 Main St', 'V6G1A1', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (2, '456 First Ave', 'V6K2H2', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (3, '789 Fourth St', 'V6M3J3', 'Richmond')
    INTO address (address_id, address_postalcode, address_city) VALUES (4, 'V6Z1L4', 'Vancouver')
    INTO address (address_id, address_postalcode, address_city) VALUES (5, 'V6T1Z1', 'Burnaby')
    INTO address (address_id, address_postalcode, address_city) VALUES (6, 'V6J5G4', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (7, '1011 Fifth St', 'V6L1K5', 'Richmond')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (8, '1212 Pine St', 'V6P3J2', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (9, '1313 Maple Rd', 'V6S0C2', 'Burnaby')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (10, '1414 Birch Ave', 'V6H1R9', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (11, '1515 Cedar St', 'V6N1J5', 'Richmond')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (12, '1616 Fir Rd', 'V6T2N1', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (13, '1717 Spruce St', 'V6K1B4', 'Burnaby')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (14, '1818 Hemlock Ave', 'V6J4J6', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (15, '1919 Holly Rd', 'V6M4J7', 'Richmond')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (16, '2020 Oak St', 'V6P4E4', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (17, '2121 Pine Ave', 'V6S1Y2', 'Burnaby')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (18, '2222 Cedar Rd', 'V6H3B8', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (19, '2323 Fir St', 'V6N3H9', 'Richmond')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (20, '2424 Spruce Ave', 'V6T1W5', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (21, '2525 Elm Rd', 'V6K2G9', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (22, '2626 Oak St', 'V6M2W8', 'Richmond')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (23, '2727 Cedar Ave', 'V6Z2S7', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (24, '2828 Birch St', 'V6T1Y7', 'Burnaby')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (25, '2929 Holly Rd', 'V6P3P4', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (26, '3030 Pine Ave', 'V6S2K1', 'Richmond')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (27, '3131 Fir Rd', 'V6N2E3', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (28, '3232 Spruce St', 'V6H1L1', 'Burnaby')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (29, '3333 Hemlock Ave', 'V6J3J6', 'Vancouver')
    INTO address (address_id, address_houseno, address_postalcode, address_city) VALUES (30, '3434 Maple Rd', 'V6K1P3', 'Richmond')
SELECT 1 FROM DUAL;


/* employee table */

INSERT ALL
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (1, 'John', 'Doe', 80000, '6042844899', '25-Jun-21', 'Manager', 1)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (2, 'Jane', 'Smith', 64000, '7788028824', '14-Jul-21', 'Staff', 6)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (3, 'Alex', 'Johnson', 55000, '7782488524', '19-Jul-21', 'Customer Service', 7)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (4, 'Emily', 'Lee', 64000, '6041328090', '1-Aug-21', 'Staff', 2)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (5, 'Chris', 'Kim', 55000, '6045465049', '6-Aug-21', 'Customer Service', 11)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (6, 'Avery', 'Park', 55000, '7788900630', '17-Aug-21', 'Customer Service', 12)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (7, 'Cameron', 'Choi', 55000, NULL, '9-Sep-21', NULL, 3)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (8, 'Ashley', 'Kim', 55000, NULL, '29-Sep-21', NULL, 10)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (9, 'Tyler', 'Song', 55000, '7781320112', '5-Oct-21', 'Customer Service', 8)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (10, 'Aiden', 'Chen', 80000, '6041447135', '25-Oct-21', 'Manager', 9)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (11, 'Mia', 'Liu', 64000, '7781470212', '31-Oct-21', 'Staff', 4)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (12, 'Ethan', 'Wang', 64000, '6046249712', '4-Nov-21', 'Staff', 5)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (13, 'Aria', 'Zhao', 64000, '7785124935', '21-Nov-21', 'Staff', 14)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (14, 'Luke', 'Zhang', 64000, '7784903516', '16-Dec-21', 'Staff', 15)
    INTO employee (employee_id, employee_fname, employee_lname, employee_salary, employee_contact, employee_joindate, employee_role, address_id)
    VALUES (15, 'Lila', 'Xu', 64000, '7783711370', '14-Jan-22', 'Staff', 13)
SELECT 1 FROM dual;

/* customer table */

INSERT ALL
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (1, 'Alice', 'Smith', 7781234567, 'BC123456789012', 16)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (2, 'Bob', 'Johnson', 6049876543, 'AB987654321098', 17)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (3, 'Charlie', 'Brown', 7785551234, 'ON654321098765', 18)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (4, 'David', 'Lee', 6041112222, 'QC234567890123', 19)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (5, 'Emma', 'Davis', 7787778888, 'MB345678901234', 20)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (6, 'Frank', 'Taylor', 6043334444, 'SK456789012345', 21)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (7, 'Grace', 'Adams', 7789990000, 'NS567890123456', 22)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (8, 'Henry', 'Martin', 6045557777, 'NB678901234567', 23)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (9, 'Isabelle', 'Brown', 7782223333, 'PE789012345678', 24)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (10, 'Jack', 'Miller', 6047778888, 'NL890123456789', 25)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (11, 'Kelly', 'Green', 7784445555, 'YT901234567890', 26)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (12, 'Luke', 'Clark', 6048889999, 'NT012345678901', 27)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (13, 'Mary', 'Baker', 7786667777, 'NU123456789012', 28)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (14, 'Nathan', 'Wright', 6042223333, 'AB234567890123', 29)
    INTO customer (customer_id, customer_fname, customer_lname, customer_contact, customer_license, address_id)
    VALUES (15, 'Olivia', 'Scott', 7788889999, 'BC345678901234', 30)
SELECT 1 FROM DUAL;

/* car table */

INSERT ALL
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (1, 'Toyota', 'Sedan', 'Camry', 40.00, 'ABC123', 200000, 5, 'Red', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes', TO_DATE('25-Jun-21','DD-MON-YY'), 'Used')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (2, 'Honda', 'SUV', 'CR-V', 50.00, 'DEF456', 185000, 7, 'Silver', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes', TO_DATE('5-Jul-21','DD-MON-YY'), 'Used')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (3, 'Ford', 'Pickup', 'F-150', 75.00, 'GHI789', 170000, 5, 'Blue', 4, 'Automatic', 'Diesel', 'Yes', 'Yes', 'Yes', TO_DATE('15-Jul-21','DD-MON-YY'), 'Used')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (4, 'Chevrolet', 'Sedan', 'Malibu', 40.00, 'JKL012', 155000, 5, 'Green', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes', TO_DATE('25-Jul-21','DD-MON-YY'), 'Used')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (5, 'Nissan', 'SUV', 'Rogue', 50.00, 'MNO345', 140000, 7, 'Brown', 4, 'Automatic', 'NA', 'Yes', 'Yes', 'Yes', TO_DATE('4-Aug-21','DD-Mon-YY'), 'Used')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (6, 'Hyundai', 'Sedan', 'Sonata', 40.00, 'PQR678', 125000, 5, 'Black', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes', TO_DATE('14-Aug-21','DD-Mon-YY'), 'Used')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (7, 'Kia', 'SUV', 'Sorento', 50.00, 'STU901', 110000, 7, 'White', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes', TO_DATE('24-Aug-21','DD-Mon-YY'), 'Used')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (8, 'Jeep', 'Pickup', 'Gladiator', 75.00, 'VWX234', 95000, 5, 'Orange', 4, 'Automatic', 'Diesel', 'Yes', 'Yes', 'Yes', TO_DATE('3-Sep-21','DD-Mon-YY'), 'Used')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (9, 'Mazda', 'Sedan', 'Mazda6', 40.00, 'YZA567', 80000, 5, 'Purple', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes', TO_DATE('13-Sep-21','DD-Mon-YY'), 'Used')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (10, 'BMW', 'SUV', 'X5', 50.00, 'ZAB890', 65000, 7, 'Gold', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes', TO_DATE('23-Sep-21','DD-Mon-YY'), 'Used')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (11, 'Mercedes-Benz', 'Sedan', 'E-Class', 40.00, 'CDE123', 50000, 5, 'Silver', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes',TO_DATE('3-Oct-21','DD-Mon-YY'), 'Used')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (12, 'Audi', 'SUV', 'Q7', 50.00, 'EFG456', 5000, 7, 'Black', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes',TO_DATE('13-Oct-21','DD-Mon-YY'), 'Used')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (13, 'Lexus', 'Pickup', 'LX570', 75.00, 'GHI789', 5000, 5, 'White', 4, 'Automatic', 'Diesel', 'Yes', 'Yes', 'Yes',TO_DATE('21-Jan-23','DD-Mon-YY'), 'New')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (14, 'Volkswagen', 'Sedan', 'Jetta', 40.00, 'JKL012', 5000, 5, 'Red', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes', TO_DATE('31-01-2023', 'DD-MM-YYYY'), 'New')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_mileage, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_maintenance, car_condition)
    VALUES (15, 'Dodge', 'SUV', 'Durango', 50.00, 'MNO345', 5000, 7, 'Blue', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes', TO_DATE('10-02-2023', 'DD-MM-YYYY'), 'New')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_condition) 
    VALUES (16, 'Ram', 'Pickup', 'Ram1500', 75.00, 'PQR678', 5, 'Green', 4, 'Automatic', 'Diesel', 'Yes', 'Yes', 'Yes', 'New')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_condition) 
    VALUES (17, 'Mitsubishi', 'Sedan', 'Lancer', 40.00, 'STU901', 5, 'Black', 4, 'Manual', 'Gas', 'Yes', 'Yes', 'Yes', 'New')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_condition) 
    VALUES (18, 'Land Rover', 'SUV','Defender 130', 75.00, 'VWX234', 7, 'White', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes', 'New')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_condition) 
    VALUES (19, 'Jaguar', 'Sedan', 'XF', 40.00, 'YZA567', 5, 'Silver', 4, 'Automatic', 'Gas', 'Yes', 'Yes', 'Yes', 'New')
    INTO car (car_id, car_make, car_type, car_model, car_dailyrent, car_plateno, car_passengers, car_color, car_doors, car_transmission, car_fueltype, car_gps, car_bluetooth, car_aircon, car_condition) 
    VALUES (20, 'Tesla', 'SUV', 'Model', 50.00, 'ZAB890', 7, 'Black', 4, 'Automatic', 'NA', 'Yes', 'Yes', 'Yes', 'New')
SELECT * FROM dual;

/* inventory table */
INSERT ALL 
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (1, 'Rented', 1)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (2, 'Rented', 2)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (3, 'Rented', 3)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (4, 'Rented', 4)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (5, 'Rented', 5)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (6, 'Rented', 6)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (7, 'Rented', 7)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (8, 'Rented', 8)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (9, 'Rented', 9)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (10, 'Rented', 10)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (11, 'Available', 11)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (12, 'Available', 12)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (13, 'Available', 13)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (14, 'Available', 14)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (15, 'Available', 15)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (16, 'Available', 16)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (17, 'Available', 17)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (18, 'Available', 18)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (19, 'Available', 19)
    INTO inventory(inventory_id, inventory_status, car_id) VALUES (20, 'Available', 20)
SELECT * FROM dual;

/* reservation table */

INSERT ALL 
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id)
    VALUES (1, TO_DATE('2023-02-01', 'YYYY-MM-DD'), TO_DATE('2023-02-11', 'YYYY-MM-DD'), TO_DATE('2023-02-13', 'YYYY-MM-DD'), 'Vancouver', 2, 'Approved', 1, 1, 2)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id)
    VALUES (2, TO_DATE('2023-02-12', 'YYYY-MM-DD'), TO_DATE('2023-02-15', 'YYYY-MM-DD'), TO_DATE('2023-02-17', 'YYYY-MM-DD'), 'Richmond', 2, 'Approved', 2, 2, 3)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id)
    VALUES (3, TO_DATE('2023-02-24', 'YYYY-MM-DD'), TO_DATE('2023-02-26', 'YYYY-MM-DD'), TO_DATE('2023-03-01', 'YYYY-MM-DD'), 'Burnaby', 3, 'Approved', 3, 3, 4)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id)
    VALUES (4, TO_DATE('2023-03-04', 'YYYY-MM-DD'), TO_DATE('2023-03-06', 'YYYY-MM-DD'), TO_DATE('2023-03-14', 'YYYY-MM-DD'), 'Vancouver', 8, 'Approved', 4, 4, 5)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id)
    VALUES (5, TO_DATE('2023-03-17', 'YYYY-MM-DD'), TO_DATE('2023-03-18', 'YYYY-MM-DD'), TO_DATE('2023-03-22', 'YYYY-MM-DD'), 'Richmond', 4, 'Approved', 5, 5, 6)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id)
    VALUES (6, TO_DATE('2023-02-15', 'YYYY-MM-DD'), TO_DATE('2023-05-20', 'YYYY-MM-DD'), TO_DATE('2023-05-28', 'YYYY-MM-DD'), 'Vancouver', 8, 'Approved', 1, 6, 2)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id) 
    VALUES (7, TO_DATE('23-Feb-23', 'YYYY-MM-DD'), TO_DATE('22-May-23', 'YYYY-MM-DD'), TO_DATE('31-May-23', 'YYYY-MM-DD'), 'Richmond', 9, 'Approved', 2, 7, 3)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id) 
    VALUES (8, TO_DATE('28-Feb-23', 'YYYY-MM-DD'), TO_DATE('25-May-23', 'YYYY-MM-DD'), TO_DATE('29-May-23', 'YYYY-MM-DD'), 'Burnaby', 4, 'Approved', 3, 8, 4)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id) 
    VALUES (9, TO_DATE('14-Mar-23', 'YYYY-MM-DD'), TO_DATE('25-May-23', 'YYYY-MM-DD'), TO_DATE('1-Jun-23', 'YYYY-MM-DD'), 'Vancouver', 7, 'Approved', 4, 9, 5)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id) 
    VALUES (10, TO_DATE('17-Mar-23', 'YYYY-MM-DD'), TO_DATE('28-May-23', 'YYYY-MM-DD'), TO_DATE('6-Jun-23', 'YYYY-MM-DD'), 'Richmond', 9, 'Approved', 5, 10, 6)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id) 
    VALUES (11, TO_DATE('24-Feb-23', 'YYYY-MM-DD'), TO_DATE('30-May-23', 'YYYY-MM-DD'), TO_DATE('8-Jun-23', 'YYYY-MM-DD'), 'Burnaby', 9, 'Disapproved', 6, 11, 7)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id) 
    VALUES (12, TO_DATE('2-Mar-23', 'YYYY-MM-DD'), TO_DATE('1-Jun-23', 'YYYY-MM-DD'), TO_DATE('10-Jun-23', 'YYYY-MM-DD'), 'Vancouver', 9, 'Approved', 7, 12, 8)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id) 
    VALUES (13, TO_DATE('2-Mar-23', 'YYYY-MM-DD'), TO_DATE('2-Jun-23', 'YYYY-MM-DD'), TO_DATE('11-Jun-23', 'YYYY-MM-DD'), 'Richmond', 9, 'Disapproved', 8, 13, 9)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id) 
    VALUES (14, TO_DATE('25-Mar-23', 'YYYY-MM-DD'), TO_DATE('3-Jun-23', 'YYYY-MM-DD'), TO_DATE('6-Jun-23', 'YYYY-MM-DD'), 'Burnaby', 3, 'Pending', 9, 14, 11)
    INTO reservation(reservation_id, reservation_date, reservation_pickup, reservation_return, reservation_location, reservation_duration, reservation_status, inventory_id, customer_id, employee_id) 
    VALUES (15, TO_DATE('27-Mar-23', 'YYYY-MM-DD'), TO_DATE('5-Jun-23', 'YYYY-MM-DD'), TO_DATE('10-Jun-23', 'YYYY-MM-DD'), 'Vancouver', 5, 'Pending', 10, 15, 12)
SELECT 1 FROM DUAL;

/* payment table */

INSERT ALL
    INTO payment(payment_id, payment_amount, payment_date, reservation_id, customer_id)
    VALUES (1, 80.00, TO_DATE('01-Feb-23', 'YYYY-MM-DD'), 1, 1)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id)
    VALUES (2, 100.00, TO_DATE('12-Feb-23', 'YYYY-MM-DD'), 2, 2)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id)
    VALUES (3, 225.00, TO_DATE('24-Feb-23', 'YYYY-MM-DD'), 3, 3)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id)
    VALUES (4, 320.00, TO_DATE('04-Mar-23', 'YYYY-MM-DD'), 4, 4)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id)
    VALUES (5, 200.00, TO_DATE('17-Mar-23', 'YYYY-MM-DD'), 5, 5)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id)
    VALUES (6, 320.00, TO_DATE('15-Feb-23', 'YYYY-MM-DD'), 6, 6)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id)
    VALUES (7, 450.00, TO_DATE('23-Feb-23', 'YYYY-MM-DD'), 7, 7)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id)
    VALUES (8, 300.00, TO_DATE('28-Feb-23', 'YYYY-MM-DD'), 8, 8)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id)
    VALUES (9, 280.00, TO_DATE('14-Mar-23', 'YYYY-MM-DD'), 9, 9)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id)
    VALUES (10, 450.00, TO_DATE('17-Mar-23', 'YYYY-MM-DD'), 10, 10)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id)
    VALUES (11, 360.00, TO_DATE('24-Feb-23', 'YYYY-MM-DD'), 11, 11)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id) 
    VALUES (12, 450.00, TO_DATE('02-Mar-23', 'YYYY-MM-DD'), 12, 12)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id) 
    VALUES (13, 675.00, TO_DATE('02-Mar-23', 'YYYY-MM-DD'), 13, 13)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id)
    VALUES (14, 120.00, TO_DATE('25-Mar-23', 'YYYY-MM-DD'), 14, 14)
    INTO payment(payment_id, payment_amount, payment_date,reservation_id, customer_id) 
    VALUES (15, 250.00, TO_DATE('27-Mar-23', 'YYYY-MM-DD'), 15, 15)
SELECT 1 FROM dual;

COMMIT;
