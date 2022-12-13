DROP SCHEMA IF EXISTS MANUFACTURING;
CREATE SCHEMA MANUFACTURING;
USE MANUFACTURING;
CREATE TABLE Employee (
	ID INTEGER PRIMARY KEY,
	SSN VARCHAR(10) UNIQUE NOT NULL,
	FName VARCHAR(50),
	MName VARCHAR(50),
	LName VARCHAR(50),
	BDate DATE,
	Address VARCHAR(200),
	Salary FLOAT CHECK (Salary>=0),
	EmployeeType enum('Employee','Analyst','Manager','Designer','Worker') default 'Employee'
);
-- Derived attribute: Age
CREATE TABLE Analyst (
	ID INTEGER PRIMARY KEY,
	FOREIGN KEY (ID) REFERENCES Employee (ID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Manager (
	ID INTEGER PRIMARY KEY,
	FOREIGN KEY (ID) REFERENCES Employee (ID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Worker (
	ID INTEGER PRIMARY KEY,
FOREIGN KEY (ID) REFERENCES Employee (ID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Designer (
	ID INTEGER PRIMARY KEY,
	FOREIGN KEY (ID) REFERENCES Employee (ID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Check the disjoint constraint between the subclasses
-- trigger for analyst disjoint
DELIMITER //
CREATE TRIGGER NoDisjointAnalyst
AFTER INSERT 
ON Analyst FOR EACH ROW
BEGIN
	IF exists (select * from Manager m where m.id = new.id) 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Analyst can be Manager';
	ELSEIF exists (select * from Worker w where w.id = new.id) 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Analyst can be Worker';
	ELSEIF exists (select * from Designer d where d.id = new.id)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Analyst can be Designer';
    END IF;
END //
DELIMITER ;

-- trigger for Manager disjoint
DELIMITER $$
CREATE TRIGGER NoDisjointManager
AFTER INSERT 
ON Manager FOR EACH ROW
BEGIN
	IF exists (select * from Analyst a where a.id = new.id) 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Manager can be Analyst';
	ELSEIF exists (select * from Worker w where w.id = new.id) 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Manager can be Worker';
	ELSEIF exists (select * from Designer d where d.id = new.id)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Manager can be Designer';
    END IF;
END$$
DELIMITER ;

-- trigger for Worker disjoint
DELIMITER $$
CREATE TRIGGER NoDisjointWorker
AFTER INSERT 
ON Worker FOR EACH ROW
BEGIN
	IF exists (select * from Analyst a where a.id = new.id) 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Worker can be Analyst';
	ELSEIF exists (select * from Manager m where m.id = new.id) 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Worker can be Manager';
	ELSEIF exists (select * from Designer d where d.id = new.id)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Worker can be Designer';
    END IF;
END$$
DELIMITER ;

-- trigger for Designer disjoint
DELIMITER $$
CREATE TRIGGER NoDisjointDesigner
AFTER INSERT 
ON Designer FOR EACH ROW
BEGIN
	IF exists (select * from Analyst a where a.id = new.id) 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Designer can be Analyst';
	ELSEIF exists (select * from Manager m where m.id = new.id) 
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Designer can be Manager';
	ELSEIF exists (select * from Worker w where w.id = new.id)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Designer can be Worker';
    END IF;
END$$
DELIMITER ;

-- --------------------------------------------------------------
CREATE TABLE Supplier (
	SID INTEGER PRIMARY KEY,
	Location VARCHAR (100)
);
CREATE TABLE `Member` (
	MID INTEGER PRIMARY KEY,
	MemberType INTEGER CHECK (MemberType IN (1, 2))
);
ALTER TABLE Employee ADD (MID INTEGER);
ALTER TABLE Employee ADD FOREIGN KEY (MID) REFERENCES `Member`(MID) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Supplier ADD (MID INTEGER);
ALTER TABLE Supplier ADD FOREIGN KEY (MID) REFERENCES `Member`(MID) ON DELETE SET NULL ON UPDATE CASCADE;
CREATE TABLE Account (
	Username VARCHAR(20) PRIMARY KEY,
	BioID VARCHAR(100) NOT NULL UNIQUE,
	Password VARCHAR(100) NOT NULL
);
CREATE TABLE Process (
	PID INTEGER PRIMARY KEY
);
CREATE TABLE Equipment (
	PID INTEGER PRIMARY KEY
);
CREATE TABLE Notification (
	NID INTEGER PRIMARY KEY
);
CREATE TABLE Product (
	PID INTEGER PRIMARY KEY
);
CREATE TABLE Project (
	PID INTEGER PRIMARY KEY,
	Name VARCHAR(200) UNIQUE NOT NULL,
	Description VARCHAR(500),
	CostEfficiency VARCHAR(100),
	Cost FLOAT CHECK (Cost >= 0)
);
CREATE TABLE Activity (
	AID INTEGER PRIMARY KEY
);
CREATE TABLE Part (
	PID INTEGER PRIMARY KEY
);
CREATE TABLE Model (
	MNumber INTEGER,
	PID INTEGER,
	ID INTEGER,
	DateCreated DATE,
	PRIMARY KEY (MNumber, PID, ID),
	FOREIGN KEY (PID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ID) REFERENCES Designer(ID) ON DELETE CASCADE ON UPDATE CASCADE
);
	CREATE TABLE `Group` (
	GNumber INTEGER,
	PID INTEGER,
	Name VARCHAR(100) NOT NULL,
	Location VARCHAR(200),
	PRIMARY KEY (GNumber, PID),
	UNIQUE (Name, PID),
	FOREIGN KEY (PID) REFERENCES Project (PID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Task (
	TNumber INTEGER,
	GNumber INTEGER,
	PID INTEGER,
	Name VARCHAR(200),
	PRIMARY KEY (TNumber, GNumber, PID),
	UNIQUE (Name, GNumber, PID),
	FOREIGN KEY (GNumber, PID) REFERENCES `Group` (GNumber, PID) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Account ADD (ID INTEGER NOT NULL UNIQUE);
ALTER TABLE Account ADD FOREIGN KEY (ID) REFERENCES Employee(ID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Notification ADD (PID INTEGER NOT NULL);
ALTER TABLE Notification ADD FOREIGN KEY (PID) REFERENCES Equipment (PID) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Project ADD (ID INTEGER NOT NULL, StartDate DATE NOT NULL, Period VARCHAR(20) NOT NULL);
ALTER TABLE Project ADD FOREIGN KEY (ID) REFERENCES Employee(ID) ON DELETE CASCADE ON UPDATE CASCADE;
CREATE TABLE ModelInProject (
	Mnumber INTEGER,
	PID INTEGER,
	ID INTEGER,
	ProjectID INTEGER NOT NULL,
	PRIMARY KEY (MNumber, PID, ID),
	FOREIGN KEY (MNumber, PID, ID) REFERENCES Model(MNumber, PID, ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ProjectID) REFERENCES Project(PID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE ManagerManagesEquipment (
	PID INTEGER PRIMARY KEY,
	ID INTEGER NOT NULL,
	FOREIGN KEY (PID) REFERENCES Equipment(PID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ID) REFERENCES Manager(ID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Works_on (
	ID INTEGER,
	PID INTEGER,
	PRIMARY KEY (ID, PID),
	FOREIGN KEY (ID) REFERENCES Worker(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (PID) REFERENCES Equipment(PID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE ProjectForProduct (
	ProjectID INTEGER,
	ProductID INTEGER,
	PRIMARY KEY (ProjectID, ProductID),
	FOREIGN KEY (ProjectID) REFERENCES Project(PID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ProductID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Check total participation of Project in ProjectForProduct
-- function to check participation of Project
DELIMITER //
CREATE FUNCTION check_Pro_ProjectForProduct()
returns boolean
READS SQL DATA
DETERMINISTIC
begin
	declare num int;
    
	select count(*) into num
    from Project p 
    where p.PID NOT IN (SELECT ProjectID FROM ProjectForProduct);
    
    return num<1;
end; //
DELIMITER ;


CREATE TABLE Joins (
	ID INTEGER,
	GNumber INTEGER,
	PID INTEGER,
	PRIMARY KEY (ID, GNumber, PID),
	FOREIGN KEY (ID) REFERENCES Employee(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (GNumber, PID) REFERENCES `Group` (GNumber, PID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Check total participation of Group in Joins
-- function to check participation of Group
DELIMITER //
CREATE FUNCTION check_Gr_Joins()
returns boolean
READS SQL DATA
DETERMINISTIC
begin
	declare num int;
    
	select count(*) into num
    from `Group` g
    where g.GNumber NOT IN (SELECT GNumber FROM Joins);
    
    return num<1;
end; //
DELIMITER ;

CREATE TABLE MemberInActivity (
	MID INTEGER,
	AID INTEGER,
	PRIMARY KEY (MID, AID),
	FOREIGN KEY (MID) REFERENCES `Member`(MID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (AID) REFERENCES Activity(AID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Check total participation of Member and Activity in MemberInActivity
DELIMITER //
CREATE FUNCTION check_Mem_Acti_MemberInActivity()
returns boolean
READS SQL DATA
DETERMINISTIC
begin
	declare num1 int;
    declare num2 int;
    
	select count(*) into num1
    from Member m
    where m.MID NOT IN (SELECT MID FROM MemberInActivity);
    
	select count(*) into num2
    from Activity a
    where a.AID NOT IN (SELECT AID FROM MemberInActivity);
    return num1+num2<1;
end; //
DELIMITER ;


CREATE TABLE `With` (
	AID INTEGER,
	GNumber INTEGER,
	PID INTEGER,
	Date DATE,
	Hour TIMESTAMP,
	PRIMARY KEY (AID, GNumber, PID),
	FOREIGN KEY (AID) REFERENCES Activity(AID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (GNumber, PID) REFERENCES `Group` (GNumber, PID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Check total participation of Group in With
-- function to check participation of Group
DELIMITER //
CREATE FUNCTION check_Gr_With()
returns boolean
READS SQL DATA
DETERMINISTIC
begin
	declare num int;
    
	select count(*) into num
    from `Group` g
    where g.GNumber NOT IN (SELECT GNumber FROM `With`);
    
    return num<1;
end; //
DELIMITER ;


CREATE TABLE Supplies (
	SupplierID INTEGER,
	PartID INTEGER,
	ProjectID INTEGER,
	Date DATE,
	Quantity INTEGER CHECK (Quantity > 0),
	Price FLOAT CHECK (Price >= 0),
	PRIMARY KEY (SupplierID, PartID, ProjectID),
	FOREIGN KEY (SupplierID) REFERENCES Supplier(SID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (PartID) REFERENCES Part(PID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ProjectID) REFERENCES Project(PID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Check total participation of Supplier in Supplies

-- function to check participation of Supplier in Supplies
DELIMITER //
CREATE FUNCTION check_Supp_Supplies()
returns boolean
READS SQL DATA
DETERMINISTIC
begin
	declare num int;
    
	select count(*) into num
    from Supplier s
    where s.SID NOT IN (SELECT SupplierID FROM Supplies);
    
    return num<1;
end; //
DELIMITER ;


CREATE TABLE Produces (
	ProductID INTEGER,
	EquipmentID INTEGER,
	ProcessID INTEGER NOT NULL,
	Status VARCHAR(20) CHECK (Status IN ('Success', 'Failure', 'Undefined')),
	Date DATE,
	Hour TIMESTAMP,
	PRIMARY KEY (ProductID, EquipmentID),
	UNIQUE (ProductID, ProcessID),
	FOREIGN KEY (ProductID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (EquipmentID) REFERENCES Equipment (PID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ProcessID) REFERENCES Process (PID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Comments (
	NID INTEGER,
	AComment VARCHAR(200),
	PRIMARY KEY (NID, AComment),
	FOREIGN KEY (NID) REFERENCES Notification(NID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Log (
	ProductID INTEGER,
	EquipmentID INTEGER,
	ALog VARCHAR(200),
	PRIMARY KEY (ProductID, EquipmentID, ALog),
	FOREIGN KEY (ProductID, EquipmentID) REFERENCES Produces(ProductID, EquipmentID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE mSession (
	PID INTEGER,
	ASession VARCHAR(20),
	PRIMARY KEY (PID, ASession),
	FOREIGN KEY (PID) REFERENCES ManagerManagesEquipment(PID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE wSession (
	ID INTEGER,
	PID INTEGER,
	ASession VARCHAR(20),
	PRIMARY KEY (ID, PID, ASession),
	FOREIGN KEY (ID, PID) REFERENCES works_on(ID, PID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Role (
	MID INTEGER,
	AID INTEGER,
	ARole VARCHAR(20),
	PRIMARY KEY (MID, AID, ARole),
	FOREIGN KEY (MID, AID) REFERENCES MemberInActivity(MID, AID) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE Period (
	ID INTEGER,
	GNumber INTEGER,
	PID INTEGER,
	APeriod VARCHAR(20),
	PRIMARY KEY (ID, GNumber, PID, APeriod),
	FOREIGN KEY (ID, GNumber, PID) REFERENCES Joins (ID, GNumber, PID) ON DELETE CASCADE ON UPDATE CASCADE
);
