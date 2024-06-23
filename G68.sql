/*
COURSE CODE: UCCD2303
PROGRAMME: CS
GROUP NUMBER： G068
GROUP LEADER NAME & EMAIL: LEE CHORNG HUAH leech02@1utar.my chornghuah02@gmail.com(Personal)
MEMBER 2 NAME: NG TUCK SENG
MEMBER 3 NAME: NG WEI HONG
MEMBER 4 NAME: NG WEI YU
Submission date and time (DD-MON-YY): 16-April-24
*/

-- Dropping existing tables to start fresh
DROP TABLE JobHistory CASCADE CONSTRAINTS;
DROP TABLE Job CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Payment CASCADE CONSTRAINTS;
DROP TABLE OrderDetails CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;
DROP TABLE Snack CASCADE CONSTRAINTS;
DROP TABLE Beverage CASCADE CONSTRAINTS;
DROP TABLE Dessert CASCADE CONSTRAINTS;
DROP TABLE MainDish CASCADE CONSTRAINTS;
DROP TABLE Food CASCADE CONSTRAINTS;
DROP TABLE PaymentMethod CASCADE CONSTRAINTS;
DROP TABLE Restaurant CASCADE CONSTRAINTS;
DROP TABLE Customer CASCADE CONSTRAINTS;

-- Creating tables for the database schema

-- Table for storing customer information
CREATE TABLE Customer (
    Customer_ID CHAR(7) NOT NULL,
    Customer_FName VARCHAR2(20) NOT NULL,
    Customer_LName VARCHAR2(20) NOT NULL,
    Customer_Email VARCHAR2(40) NOT NULL,
    Phone_Num VARCHAR2(15) NOT NULL,
    Customer_DOB DATE,
    CONSTRAINT Customer_Customer_ID_pk PRIMARY KEY (Customer_ID),
    CONSTRAINT Customer_Customer_Email_uk UNIQUE (Customer_Email)
);

-- Table for storing restaurant information
CREATE TABLE Restaurant (
    Rest_ID CHAR(3)NOT NULL,
    Rest_Name VARCHAR2(30) NOT NULL,
    Rest_Address VARCHAR2(50) NOT NULL,
    Rest_OpenTime CHAR(10) NOT NULL,
    Rest_CloseTime CHAR(10) NOT NULL,
    CONSTRAINT Restaurant_Rest_ID_pk PRIMARY KEY (Rest_ID)
);

-- Table for storing payment method information
CREATE TABLE PaymentMethod (
    PMethod_ID CHAR(4) NOT NULL,
    PMethod_Name VARCHAR2(20) CONSTRAINT PaymentMethod_PMethod_ID NOT NULL,
    CONSTRAINT PaymentMethod_PMethod_ID_pk PRIMARY KEY (PMethod_ID)
);

-- Table for storing general food information
CREATE TABLE Food (
    Food_ID CHAR(5)NOT NULL,
    Rest_ID CHAR(3) NOT NULL,
    UnitPrice DECIMAL(6,2) NOT NULL,
    Food_Name VARCHAR2(30) NOT NULL,
    Food_Type VARCHAR2(2) NOT NULL,
    CONSTRAINT Food_Food_ID_pk PRIMARY KEY (Food_ID),
    CONSTRAINT Food_Rest_ID_fk FOREIGN KEY (Rest_ID) REFERENCES Restaurant(Rest_ID),
    CONSTRAINT Food_Food_Type_cc CHECK ((Food_Type = 'M') OR (Food_Type = 'D') OR (Food_Type = 'B') OR (Food_Type = 'S'))
);

-- Table for storing main dish specific information
CREATE TABLE MainDish (
    Food_ID CHAR(5),
    Dish_ServingSize INTEGER,
    Dish_Desc VARCHAR2(50),
    Cooking_Method VARCHAR2(20),
    CONSTRAINT MainDish_Food_ID_fk FOREIGN KEY (Food_ID) REFERENCES Food(Food_ID)
);

-- Table for storing dessert specific information
CREATE TABLE Dessert (
    Food_ID CHAR(5),
    Dessert_Flavour VARCHAR2(20),
    Dessert_ServingSize INTEGER,
    CONSTRAINT Dessert_Food_ID_fk FOREIGN KEY (Food_ID) REFERENCES Food(Food_ID)
);

-- Table for storing beverage specific information
CREATE TABLE Beverage (
    Food_ID CHAR(5),
    Beverage_Size CHAR(1),
    Temperature CHAR(1),
    CONSTRAINT Beverage_Food_ID_fk FOREIGN KEY (Food_ID) REFERENCES Food(Food_ID),
    CONSTRAINT Beverage_Beverage_Size_cc CHECK ((Beverage_Size = 'S') OR (Beverage_Size = 'M') OR (Beverage_Size = 'L')),
    CONSTRAINT Beverage_Temperature_cc CHECK ((Temperature = 'H') OR (Temperature = 'C'))
); 

-- Table for storing snack specific information
CREATE TABLE Snack (
    Food_ID CHAR(5),
    Snack_Size CHAR(1),
    Snack_Desc VARCHAR2(50),
    CONSTRAINT Snack_Food_ID_fk FOREIGN KEY (Food_ID) REFERENCES Food(Food_ID),
    CONSTRAINT Snack_Snack_Size_cc CHECK ((Snack_Size = 'S') OR (Snack_Size = 'M') OR (Snack_Size = 'L'))
);

-- Table for storing order information
CREATE TABLE Orders (
    Order_ID CHAR(8),
    Customer_ID CHAR(7) NOT NULL,
    Rest_ID CHAR(3) NOT NULL,
    Order_Date DATE,
    TotalAmount DECIMAL(10,2) NOT NULL,
    CONSTRAINT Orders_Order_ID_pk PRIMARY KEY (Order_ID),
    CONSTRAINT Orders_Customer_ID_fk FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    CONSTRAINT Orders_Rest_ID_fk FOREIGN KEY (Rest_ID) REFERENCES Restaurant(Rest_ID)
);

-- Table for storing order details information
CREATE TABLE OrderDetails (
    Order_ID CHAR(8) NOT NULL,
    Food_ID CHAR(5) NOT NULL,
    Quantity INTEGER NOT NULL,
    SubTotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT OrderDetails_Order_ID_fk FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    CONSTRAINT OrderDetails_Food_ID_fk FOREIGN KEY (Food_ID) REFERENCES Food(Food_ID),
    CONSTRAINT OrderDetails_pk PRIMARY KEY (Order_ID,Food_ID)
);

-- Table for storing payment information
CREATE TABLE Payment (
    Payment_ID CHAR(8),
    Order_ID CHAR(8) NOT NULL,
    PMethod_ID CHAR(4) NOT NULL,
    Payment_Date DATE,
    TotalPayment DECIMAL(10,2) NOT NULL,
    CONSTRAINT Payment_Payment_ID_pk PRIMARY KEY (Payment_ID),
    CONSTRAINT Payment_Order_ID_fk FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    CONSTRAINT Payment_PMethod_ID_fk FOREIGN KEY (PMethod_ID) REFERENCES PaymentMethod(PMethod_ID)
);

-- Table for storing employee information
CREATE TABLE Employee (
    Emp_ID CHAR(5),
    Emp_FName VARCHAR2(20) NOT NULL,
    Emp_LName VARCHAR2(20) NOT NULL,
    Phone_Num VARCHAR2(11) NOT NULL,
    Emp_DOB DATE,
    Salary NUMBER(6) NOT NULL,
    Rest_ID CHAR(3) NOT NULL,
    Manager_ID CHAR(5) NULL,
    CONSTRAINT Employee_Emp_ID_pk PRIMARY KEY (Emp_ID),
    CONSTRAINT Employee_Rest_ID_fk FOREIGN KEY (Rest_ID) REFERENCES Restaurant(Rest_ID),
    CONSTRAINT Employee_Manager_ID_fk FOREIGN KEY (Manager_ID) REFERENCES Employee(Emp_ID)
);

-- Table for storing job information
CREATE TABLE Job (
    Job_ID CHAR(5),
    Job_Title VARCHAR2(20) NOT NULL,
    Min_Salary NUMBER(6) NOT NULL,
    Max_Salary NUMBER(6) NOT NULL,
    CONSTRAINT Job_Job_ID_pk PRIMARY KEY (Job_ID)
);

-- Table for storing employee job history
CREATE TABLE JobHistory (
    Emp_ID CHAR(5) NOT NULL,
    Job_ID CHAR(5) NOT NULL,
    starting_date DATE,
    ending_date DATE,
    CONSTRAINT JobHistory_Emp_ID_fk FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID),
    CONSTRAINT JobHistory_Job_ID_fk FOREIGN KEY (Job_ID) REFERENCES Job(Job_ID),
    CONSTRAINT JobHistory_pk PRIMARY KEY (Emp_ID,Job_ID)
);

-- Inserting records into Customer
INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000001', 'Chorng Huah', 'Lee', 'chlee@gmail.com', '018-8889998', TO_DATE('19/06/2002', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000002', 'Wei Yu', 'Ng', 'wyng@gmail.com', '016-6969669', TO_DATE('17/08/2002', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000003', 'Tuck Seng', 'Ng', 'tsng@gmail.com', '017-8787878', TO_DATE('06/10/2002', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000004', 'Wei Hong', 'Ng', 'whng@gmail.com', '019-9999999', TO_DATE('06/11/2003', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000005', 'Ying Ying', 'Ng', 'yyng@gmail.com', '012-3456778', TO_DATE('12/12/1999', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000006', 'May Ling', 'Lim', 'mllim@yahoo.com', '013-2345781', TO_DATE('10/02/1975', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000007', 'Chin Ping', 'Ng', 'cpng@outlook.com', '018-9876341', TO_DATE('03/07/1973', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000008', 'Wei Jiang', 'Ong', 'wjong@gmail.coc', '016-7890102', TO_DATE('01/01/2004', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000009', 'Qi Le', 'Tan', 'qltan@gmail.com', '017-6000923', TO_DATE('24/07/2003', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000010', 'Zhi Xin', 'Lim', 'zxlim@gmail.com', '015-2323233', TO_DATE('23/11/2003', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000011', 'Chee Hong', 'Leong', 'chleong@outlool.com', '018-3576676', TO_DATE('21/09/2001', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000012', 'Hui Zi', 'Cheah', 'hzcheah@gmail.com', '014-3477595', TO_DATE('16/01/2000', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000013', 'Xin Yee', 'Ng', 'seraphic@gmail.com', '018-4557878', TO_DATE('24/01/1999', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000014', 'Jian Ming', 'Ang', 'diga@gmail.com', '017-5555433', TO_DATE('11/03/1989', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000015', 'Jun Bin', 'Heah', 'jbheah@outlook.com', '015-6666777', TO_DATE('15/11/1993', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000016', 'Jing Hong', 'Ng', 'bryanng@gmail.com', '012-2345667', TO_DATE('28/02/1995', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000017', 'Jia Le', 'Lee', 'jllee@gmail.com', '018-7965342', TO_DATE('11/11/2003', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000018', 'Chen Shu', 'Aw', 'csaw@gmail.com', '019-8787887', TO_DATE('14/02/1998', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000019', 'Yen Jin', 'Ng', 'yjng@yahoo.com', '018-2653376', TO_DATE('05/05/1997', 'DD/MM/YYYY'));

INSERT INTO Customer (Customer_ID, Customer_FName, Customer_LName, Customer_Email, Phone_Num, Customer_DOB) VALUES ('C000020', 'Enrou', 'Teh', 'teher@gmail.com', '012-6789901', TO_DATE('18/03/2005', 'DD/MM/YYYY'));


--Inserting values into Restaurant
INSERT INTO Restaurant VALUES ('R01', 'WestFood', 'Lot A, 123 Dipper Street', '1100', '2100');

INSERT INTO Restaurant VALUES ('R02', 'McKentucky', 'Lot B, 123 Dipper Street', '1200', '2100');

INSERT INTO Restaurant VALUES ('R03', 'Mi Ice', 'Lot D, 123 Dipper Street', '1200', '2200');

INSERT INTO Restaurant VALUES ('R04', 'Sushi Itai', 'Lot C, 123 Dipper Street', '1100', '2100');

INSERT INTO Restaurant VALUES ('R05', 'DaSeo', 'Lot E, 123 Dipper Street', '1100', '2230');


--Inserting values into PaymentMethod
INSERT INTO PaymentMethod VALUES ('PM01', 'Cash');

INSERT INTO PaymentMethod VALUES ('PM02', 'Online Banking');

INSERT INTO PaymentMethod VALUES ('PM03', 'E-Wallet');

INSERT INTO PaymentMethod VALUES ('PM04', 'Credit/Debit Card');


--Inserting values into Food
INSERT INTO Food VALUES ('F0001', 'R01', 20, 'Chicken Chop', 'M');

INSERT INTO Food VALUES ('F0002', 'R01', 20, 'Chicken Maryland', 'M');

INSERT INTO Food VALUES ('F0003', 'R01', 30, 'BBQ Grilled Beef', 'M');

INSERT INTO Food VALUES ('F0004', 'R01', 5, 'Ice Lemon Tea', 'B');

INSERT INTO Food VALUES ('F0005', 'R01', 5, 'Honey Lemon', 'B');

INSERT INTO Food VALUES ('F0006', 'R02', 20, 'Normal Fried Chicken', 'S');

INSERT INTO Food VALUES ('F0007', 'R02', 20, 'Spicy Chicken', 'S');

INSERT INTO Food VALUES ('F0008', 'R02', 10, 'French Fries', 'S');

INSERT INTO Food VALUES ('F0009', 'R02', 12, 'Fried Onion Ring', 'S');

INSERT INTO Food VALUES ('F0010', 'R02', 3, 'Coca Cola', 'B');

INSERT INTO Food VALUES ('F0011', 'R03', 3, 'Lemonade', 'B');

INSERT INTO Food VALUES ('F0012', 'R03', 4, 'Ice Cream Tea', 'B');

INSERT INTO Food VALUES ('F0013', 'R03', 2, 'Green Tea Ice Cream', 'D');

INSERT INTO Food VALUES ('F0014', 'R03', 8, 'Waffle', 'D');

INSERT INTO Food VALUES ('F0015', 'R03', 10, 'Boba Milk Tea', 'B');

INSERT INTO Food VALUES ('F0016', 'R04', 25, 'Mochi', 'S');

INSERT INTO Food VALUES ('F0017', 'R04', 20, 'Vegetarian Delight', 'M');

INSERT INTO Food VALUES ('F0018', 'R04', 20, 'Spicy Tuna Hand Roll', 'S');

INSERT INTO Food VALUES ('F0019', 'R04', 2, 'Green Tea', 'B');

INSERT INTO Food VALUES ('F0020', 'R04', 30, 'Sushi Seafood Delight', 'M');

INSERT INTO Food VALUES ('F0021', 'R05', 50, 'Korean Hotpot', 'M');

INSERT INTO Food VALUES ('F0022', 'R05', 15, 'Mango Bingsu Ice', 'D');

INSERT INTO Food VALUES ('F0023', 'R05', 15, 'Honey Pancake', 'D');

INSERT INTO Food VALUES ('F0024', 'R05', 15, 'Cheesecake', 'D');

INSERT INTO Food VALUES ('F0025', 'R05', 55, 'BBQ Family', 'M');


--Inserting values into MainDish
INSERT INTO MainDish VALUES ('F0001', 1, 'Chicken and Vegetables', 'Fried');

INSERT INTO MainDish VALUES ('F0002', 1, 'Chicken and Vegetables', 'Fried');

INSERT INTO MainDish VALUES ('F0003', 1, 'Beef and Vegetables', 'Grilled');

INSERT INTO MainDish VALUES ('F0017', 2, 'Vegetables', 'Steaming');

INSERT INTO MainDish VALUES ('F0020', 3, 'Seafood and Vegetables', 'Raw and steaming');

INSERT INTO MainDish VALUES ('F0021', 4, 'Chicken, Beef and Vegetables', 'Boiling');

INSERT INTO MainDish VALUES ('F0025', 4, 'Chicken, Beef and Vegetables', 'Grilled');


--Inserting values into Dessert
INSERT INTO Dessert VALUES ('F0013', 'Green Tea', 1);

INSERT INTO Dessert VALUES ('F0014', 'Chocolate', 2);

INSERT INTO Dessert VALUES ('F0022', 'Mango', 2);

INSERT INTO Dessert VALUES ('F0023', 'Honey', 2);

INSERT INTO Dessert VALUES ('F0024', 'Cheese and Butter', 1);


--Inserting values into Beverage
INSERT INTO Beverage VALUES ('F0004', 'M', 'C');

INSERT INTO Beverage VALUES ('F0005', 'M', 'H');

INSERT INTO Beverage VALUES ('F0010', 'S', 'C');

INSERT INTO Beverage VALUES ('F0011', 'L', 'C');

INSERT INTO Beverage VALUES ('F0012', 'M', 'C');

INSERT INTO Beverage VALUES ('F0015', 'L', 'C');

INSERT INTO Beverage VALUES ('F0019', 'S', 'H');


--Inserting values into Snack
INSERT INTO Snack VALUES ('F0006', 'L', 'Chicken');

INSERT INTO Snack VALUES ('F0007', 'L', 'Chicken with Hot Sauce');

INSERT INTO Snack VALUES ('F0008', 'S', 'Potatoes');

INSERT INTO Snack VALUES ('F0009', 'S', 'Onions');

INSERT INTO Snack VALUES ('F0016', 'M', 'Seaweed and Tuna');

INSERT INTO Snack VALUES ('F0018', 'M', 'Redbean');


--Inserting values into Orders
INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000001', 'C000001', 'R01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 50.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000002', 'C000002', 'R01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 60.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000003', 'C000003', 'R01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 105.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000004', 'C000004', 'R01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 20.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000005', 'C000005', 'R01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 20.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000006', 'C000006', 'R01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 80.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000007', 'C000007', 'R01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 60.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000008', 'C000008', 'R01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 60.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000009', 'C000009', 'R02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 33.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000010', 'C000010', 'R02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 40.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000011', 'C000011', 'R02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 20.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000012', 'C000012', 'R02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 24.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000013', 'C000013', 'R02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 30.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000014', 'C000014', 'R02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 12.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000015', 'C000015', 'R02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 46.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000016', 'C000016', 'R02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 23.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000017', 'C000017', 'R03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 15.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000018', 'C000018', 'R03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 8.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000019', 'C000019', 'R03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 30.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000020', 'C000020', 'R03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 6.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000021', 'C000001', 'R03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 8.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000022', 'C000002', 'R03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 120.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000023', 'C000003', 'R03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 32.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000024', 'C000004', 'R03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 8.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000025', 'C000005', 'R04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 68.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000026', 'C000006', 'R04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 34.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000027', 'C000007', 'R04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 22.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000028', 'C000008', 'R04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 22.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000029', 'C000009', 'R04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 30.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000030', 'C000010', 'R04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 40.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000031', 'C000011', 'R04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 42.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000032', 'C000012', 'R04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 30.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000033', 'C000013', 'R05', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 65.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000034', 'C000014', 'R05', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 15.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000035', 'C000015', 'R05', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 70.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000036', 'C000016', 'R05', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 120.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000037', 'C000017', 'R05', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 95.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000038', 'C000018', 'R05', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 130.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000039', 'C000019', 'R05', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 85.00);

INSERT INTO Orders (Order_ID, Customer_ID, Rest_ID, Order_Date, TotalAmount) VALUES ('O0000040', 'C000020', 'R05', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 195.00);


--Inserting values into OrderDetails
INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000001', 'F0001', 2, 40.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000001', 'F0005', 2, 10.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000002', 'F0002', 1, 20.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000002', 'F0003', 1, 30.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000002', 'F0004', 2, 10.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000003', 'F0002', 3, 60.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000003', 'F0005', 3, 15.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000003', 'F0003', 1, 30.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000004', 'F0002', 1, 20.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000005', 'F0001', 1, 20.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000006', 'F0001', 4, 80.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000007', 'F0002', 3, 60.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000008', 'F0003', 2, 60.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000009', 'F0006', 1, 20.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000009', 'F0008', 1, 10.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000009', 'F0010', 1, 3.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000010', 'F0006', 2, 40.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000011', 'F0007', 1, 20.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000012', 'F0009', 2, 24.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000013', 'F0008', 3, 30.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000014', 'F0009', 1, 12.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000015', 'F0007', 2, 40.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000015', 'F0010', 2, 6.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000016', 'F0006', 1, 20.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000016', 'F0010', 1, 3.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000017', 'F0011', 5, 15.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000018', 'F0012', 2, 8.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000019', 'F0015', 3, 30.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000020', 'F0011', 2, 6.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000021', 'F0014', 1, 8.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000022', 'F0013', 10, 20.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000022', 'F0015', 10, 100.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000023', 'F0011', 6, 18.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000023', 'F0013', 7, 14.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000024', 'F0014', 1, 8.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000025', 'F0016', 2, 30.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000025', 'F0020', 1, 30.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000025', 'F0019', 4, 8.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000026', 'F0020', 1, 30.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000026', 'F0019', 2, 4.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000027', 'F0017', 1, 20.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000027', 'F0019', 1, 2.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000028', 'F0018', 1, 20.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000028', 'F0019', 1, 2.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000029', 'F0016', 2, 30.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000030', 'F0017', 2, 40.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000031', 'F0018', 2, 40.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000031', 'F0019', 1, 2.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000032', 'F0020', 1, 30.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000033', 'F0021', 1, 50.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000033', 'F0022', 1, 15.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000034', 'F0023', 1, 15.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000035', 'F0025', 1, 55.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000035', 'F0024', 1, 15.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000036', 'F0021', 1, 50.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000036', 'F0025', 1, 55.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000036', 'F0022', 1, 15.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000037', 'F0021', 1, 50.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000037', 'F0024', 3, 45.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000038', 'F0025', 1, 55.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000038', 'F0022', 2, 30.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000038', 'F0023', 1, 15.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000038', 'F0024', 2, 30.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000039', 'F0025', 1, 55.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000039', 'F0022', 1, 15.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000039', 'F0024', 1, 15.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000040', 'F0025', 1, 55.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000040', 'F0021', 1, 50.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000040', 'F0022', 2, 30.00);

INSERT INTO OrderDetails (Order_ID, Food_ID, Quantity, SubTotal) VALUES ('O0000040', 'F0024', 4, 60.00);


--Inserting values into Payment
INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000001', 'O0000001', 'PM01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 50.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000002', 'O0000002', 'PM01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 60.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000003', 'O0000003', 'PM01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 105.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000004', 'O0000004', 'PM01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 20.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000005', 'O0000005', 'PM01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 20.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000006', 'O0000006', 'PM01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 80.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000007', 'O0000007', 'PM01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 60.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000008', 'O0000008', 'PM01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 60.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000009', 'O0000009', 'PM01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 33.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000010', 'O0000010', 'PM01', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 40.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000011', 'O0000011', 'PM02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 20.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000012', 'O0000012', 'PM02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 24.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000013', 'O0000013', 'PM02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 30.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000014', 'O0000014', 'PM02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 12.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000015', 'O0000015', 'PM02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 46.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000016', 'O0000016', 'PM02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 23.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000017', 'O0000017', 'PM02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 15.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000018', 'O0000018', 'PM02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 8.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000019', 'O0000019', 'PM02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 30.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000020', 'O0000020', 'PM02', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 6.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000021', 'O0000021', 'PM03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 8.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000022', 'O0000022', 'PM03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 120.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000023', 'O0000023', 'PM03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 32.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000024', 'O0000024', 'PM03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 8.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000025', 'O0000025', 'PM03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 68.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000026', 'O0000026', 'PM03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 34.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000027', 'O0000027', 'PM03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 22.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000028', 'O0000028', 'PM03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 22.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000029', 'O0000029', 'PM03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 30.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000030', 'O0000030', 'PM03', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 40.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000031', 'O0000031', 'PM04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 42.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000032', 'O0000032', 'PM04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 30.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000033', 'O0000033', 'PM04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 65.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000034', 'O0000034', 'PM04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 15.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000035', 'O0000035', 'PM04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 70.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000036', 'O0000036', 'PM04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 120.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000037', 'O0000037', 'PM04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 95.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000038', 'O0000038', 'PM04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 130.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000039', 'O0000039', 'PM04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 85.00);

INSERT INTO Payment (Payment_ID, Order_ID, PMethod_ID, Payment_Date, TotalPayment) VALUES ('P0000040', 'O0000040', 'PM04', TO_DATE('14/03/2024', 'DD/MM/YYYY'), 195.00);


--Inserting values into Employee
INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0001', 'Siti', 'Rosli', '123-4567890', TO_DATE('16/08/2000', 'DD/MM/YYYY'), 3000.00, 'R01', NULL);

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0002', 'Erika', 'Chuah', '234-5678901', TO_DATE('03/11/1987', 'DD/MM/YYYY'), 8000.00, 'R02', NULL);

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0013', 'Jackson', 'Khoo', '333-4445555', TO_DATE('10/11/2002', 'DD/MM/YYYY'), 7500.00, 'R03', NULL);

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0025', 'Xiao Mei', 'Wong', '543-2109876', TO_DATE('31/08/1988', 'DD/MM/YYYY'), 2000.00, 'R04', NULL);

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0018', 'Adrain', 'Tan', '888-9990000', TO_DATE('20/04/1997', 'DD/MM/YYYY'), 7500.00, 'R05', NULL);

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0003', 'Yuyu', 'Chu', '345-6789012', TO_DATE('22/05/2005', 'DD/MM/YYYY'), 2000.00, 'R03', 'E0013');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0004', 'Hai Ling', 'Soh', '456-7890123', TO_DATE('07/02/1975', 'DD/MM/YYYY'), 4500.00, 'R04', 'E0025');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0005', 'Su Qi', 'Peter', '567-8901234', TO_DATE('11/09/1983', 'DD/MM/YYYY'), 5000.00, 'R05', 'E0018');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0006', 'Lily', 'Hall', '678-9012345', TO_DATE('28/04/1996', 'DD/MM/YYYY'), 3000.00, 'R05', 'E0018');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0007', 'Samuel', 'Allen', '789-0123456', TO_DATE('19/10/1978', 'DD/MM/YYYY'), 3500.00, 'R03', 'E0013');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0008', 'Hafiz', 'Jamaluddin', '890-1234567', TO_DATE('25/12/1990', 'DD/MM/YYYY'), 2500.00, 'R01', 'E0001');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0009', 'Adam', 'Liew', '901-2345678', TO_DATE('30/06/1985', 'DD/MM/YYYY'), 1800.00, 'R04', 'E0025');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0010', 'Limau', 'Lee', '012-3456789', TO_DATE('14/03/2000', 'DD/MM/YYYY'), 1800.00, 'R02', 'E0002');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0011', 'Ava', 'Max', '111-2223333', TO_DATE('08/07/1998', 'DD/MM/YYYY'), 1800.00, 'R05', 'E0018');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0012', 'Naomi', 'Teoh', '222-3334444', TO_DATE('02/01/1989', 'DD/MM/YYYY'), 1700.00, 'R04', 'E0025');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0014', 'Kah Teng', 'Neoh', '444-5556666', TO_DATE('06/09/1971', 'DD/MM/YYYY'), 5000.00, 'R02', 'E0002');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0015', 'Aisyah', 'Wong', '555-6667777', TO_DATE('23/05/1986', 'DD/MM/YYYY'), 5000.00, 'R01', 'E0001');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0016', 'Iskandar', 'Tan', '666-7778888', TO_DATE('17/12/1994', 'DD/MM/YYYY'), 4000.00, 'R03', 'E0013');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0017', 'Pin Yang', 'Ooi', '777-8889999', TO_DATE('01/08/1979', 'DD/MM/YYYY'), 7500.00, 'R04', 'E0025');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0019', 'Yu Hang', 'Teh', '999-0001111', TO_DATE('05/10/2003', 'DD/MM/YYYY'), 2000.00, 'R02', 'E0002');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0020', 'Siew Poh', 'Toh', '000-1112222', TO_DATE('09/03/1991', 'DD/MM/YYYY'), 2000.00, 'R01', 'E0001');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0021', 'Desmond', 'Ho', '987-6543210', TO_DATE('04/06/1976', 'DD/MM/YYYY'), 2000.00, 'R01', 'E0001');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0022', 'Yi Sheng', 'Ong', '876-5432109', TO_DATE('18/01/1984', 'DD/MM/YYYY'), 2000.00, 'R03', 'E0013');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0023', 'Bubu', 'Chin', '765-4321098', TO_DATE('12/11/1999', 'DD/MM/YYYY'), 2000.00, 'R02', 'E0002');

INSERT INTO Employee (Emp_ID, Emp_FName, Emp_LName, Phone_Num, Emp_DOB, Salary, Rest_ID, Manager_ID) VALUES ('E0024', 'Yiwen', 'Lee', '654-3210987', TO_DATE('26/07/2001', 'DD/MM/YYYY'), 3000.00, 'R05', 'E0018');


--Inserting values into Job
INSERT INTO Job VALUES ('J0001', 'Chef', 3000.00, 7500.00);

INSERT INTO Job VALUES ('J0002', 'Kitchen Helper', 1500.00, 3000.00);

INSERT INTO Job VALUES ('J0003', 'Waiter', 1200.00, 2200.00);

INSERT INTO Job VALUES ('J0004', 'Cashier', 1200.00, 2200.00);

INSERT INTO Job VALUES ('J0005', 'Restaurant Manager', 3500.00, 8000.00);

INSERT INTO Job VALUES ('J0006', 'Barista', 1800.00, 4500.00);


--Inserting values into JobHistory
INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0001', 'J0002', TO_DATE('11/06/2023', 'DD/MM/YYYY'), TO_DATE('11/01/2024', 'DD/MM/YYYY'));

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0001', 'J0005', TO_DATE('11/01/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0002', 'J0004', TO_DATE('01/04/2023', 'DD/MM/YYYY'), TO_DATE('01/12/2023', 'DD/MM/YYYY'));

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0002', 'J0005', TO_DATE('01/12/2023', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0003', 'J0004', TO_DATE('12/01/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0004', 'J0001', TO_DATE('12/12/2023', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0005', 'J0001', TO_DATE('11/11/2023', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0006', 'J0003', TO_DATE('01/10/2023', 'DD/MM/YYYY'), TO_DATE('10/12/2023', 'DD/MM/YYYY'));

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0006', 'J0002', TO_DATE('10/12/2023', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0007', 'J0003', TO_DATE('10/12/2023', 'DD/MM/YYYY'), TO_DATE('14/02/2024', 'DD/MM/YYYY'));

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0007', 'J0006', TO_DATE('14/02/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0008', 'J0002', TO_DATE('01/03/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0009', 'J0003', TO_DATE('02/02/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0010', 'J0003', TO_DATE('10/02/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0011', 'J0004', TO_DATE('11/03/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0012', 'J0003', TO_DATE('12/12/2023', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0013', 'J0004', TO_DATE('02/10/2023', 'DD/MM/YYYY'), TO_DATE('02/01/2024', 'DD/MM/YYYY'));

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0013', 'J0005', TO_DATE('02/01/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0014', 'J0002', TO_DATE('11/07/2023', 'DD/MM/YYYY'), TO_DATE('11/12/2023', 'DD/MM/YYYY'));

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0014', 'J0001', TO_DATE('11/12/2023', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0015', 'J0001', TO_DATE('14/01/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0016', 'J0006', TO_DATE('12/12/2023', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0017', 'J0005', TO_DATE('12/11/2023', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0018', 'J0004', TO_DATE('12/07/2023', 'DD/MM/YYYY'), TO_DATE('11/03/2024', 'DD/MM/YYYY'));

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0018', 'J0005', TO_DATE('11/03/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0019', 'J0003', TO_DATE('12/03/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0020', 'J0004', TO_DATE('12/02/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0021', 'J0003', TO_DATE('11/02/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0022', 'J0003', TO_DATE('11/02/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0023', 'J0004', TO_DATE('10/10/2023', 'DD/MM/YYYY'), TO_DATE('11/02/2024', 'DD/MM/YYYY'));

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0023', 'J0002', TO_DATE('14/09/2023', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0024', 'J0002', TO_DATE('15/02/2024', 'DD/MM/YYYY'), NULL);

INSERT INTO JobHistory (Emp_ID, Job_ID, starting_date, ending_date) VALUES ('E0025', 'J0004', TO_DATE('12/01/2024', 'DD/MM/YYYY'), NULL);


COMMIT;