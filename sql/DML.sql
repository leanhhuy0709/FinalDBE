-- Show Employee List

DROP PROCEDURE IF EXISTS ShowEmployee;

DELIMITER // 
CREATE PROCEDURE ShowEmployee()
BEGIN
SELECT * FROM EmployeeView;
END //

DELIMITER ;

-- Show Project List
DROP PROCEDURE IF EXISTS ShowProject;
DELIMITER //
CREATE PROCEDURE ShowProject()
BEGIN
SELECT * FROM ProjectView;
END //

DELIMITER ;

-- Show Product List
DROP PROCEDURE IF EXISTS ShowProduct;
DELIMITER //
CREATE PROCEDURE ShowProduct()
BEGIN
SELECT * FROM ProductView;
END //

DELIMITER ;

-- Show Activity List
DROP PROCEDURE IF EXISTS ShowActivity;
DELIMITER //
CREATE PROCEDURE ShowActivity()
BEGIN
SELECT * FROM ActivityView;
END //

DELIMITER ;

-- Show Model List
DROP PROCEDURE IF EXISTS ShowModel;
DELIMITER //
CREATE PROCEDURE ShowModel()
BEGIN
SELECT * FROM ModelView;
END //

DELIMITER ;

-- Show Info of Employee with input: ID
DROP PROCEDURE IF EXISTS ViewInfo;
DELIMITER //
CREATE PROCEDURE ViewInfo(IN id_ int)
BEGIN
DROP TABLE IF EXISTS temp_info;
CREATE TABLE temp_info
SELECT * FROM EmployeeView WHERE ID = id_;
SELECT * FROM temp_info;
END //

DELIMITER ;

-- login --
-- username and password entered by the user -- 
-- DROP PROCEDURE IF EXISTS Login;
-- DELIMITER //
-- CREATE PROCEDURE Login (
-- 	IN username_ VARCHAR(20),
--     IN password_ VARCHAR(100)
-- )
-- Log: BEGIN
-- 	SELECT COUNT(*) FROM Account
--     WHERE Username = username_ AND Password = password_;
--     LEAVE Log;
-- END //
-- DELIMITER ;

-- Remove
DROP PROCEDURE IF EXISTS RemoveEmployee;
DELIMITER //
CREATE PROCEDURE RemoveEmployee (IN id_ int)
remove_employee: BEGIN
    DELETE FROM Employee
    WHERE ID = id_;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS RemoveProject;
DELIMITER //
CREATE PROCEDURE RemoveProject (IN pid_ int)
remove_project: BEGIN
    DELETE FROM Project
    WHERE PID = pid_;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS RemoveProduct;
DELIMITER //
CREATE PROCEDURE RemoveProduct (IN pid_ int)
remove_product: BEGIN
    DELETE FROM Product
    WHERE PID = pid_;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS RemoveActivity;
DELIMITER //
CREATE PROCEDURE RemoveActivity (IN aid_ int)
remove_activity: BEGIN
    DELETE FROM Activity
    WHERE AID = aid_;
END //
DELIMITER ;

-- update info 
DROP PROCEDURE IF EXISTS update_info;
DELIMITER \\
CREATE PROCEDURE update_info(IN id_ int, IN ssn_ VARCHAR(10), IN fname_ VARCHAR(50),
							 IN mname_ VARCHAR(50),  IN lname_ VARCHAR(50), IN bdate_ DATE,
							 IN addr_ VARCHAR(200), IN salary_ FLOAT, IN type_ int)
	BEGIN
			UPDATE Employee
            SET SSN = IF(ssn_ IS NOT NULL, ssn_, SSN),
				FName = IF(fname_ IS NOT NULL, fname_, FName),
                MName = IF(mname_ IS NOT NULL, mname_, MName),
                LName = IF(lname_ IS NOT NULL, lname_, LName),
				BDate = IF(bdate_ IS NOT NULL, bdate_, BDate),
				Address = IF(addr_ IS NOT NULL, addr_, Address),
				Salary = IF(salary_ IS NOT NULL, salary_, Salary),
				EmployeeType = IF(type_ IS NOT NULL, type_, EmployeeType)
            WHERE ID = id_; 
    END \\
DELIMITER ;

DROP PROCEDURE IF EXISTS update_pass;
DELIMITER \\
CREATE PROCEDURE update_pass(IN username_ VARCHAR(20),
                             IN password_ VARCHAR(100))
	BEGIN 
			UPDATE Account
            SET
                Password = IF(password_ IS NOT NULL, password_, Password)
            WHERE Username = username_;
    END \\
DELIMITER ;


-- Insert
DROP PROCEDURE IF EXISTS insert_employee;
DELIMITER \\
CREATE PROCEDURE insert_employee(IN ssn_ VARCHAR(10), IN fname_ VARCHAR(50),
							 IN mname_ VARCHAR(50),  IN lname_ VARCHAR(50), IN bdate_ DATE,
							 IN addr_ VARCHAR(200), IN salary_ FLOAT, IN type_ int)
	BEGIN
		DECLARE id_ int;
		SET id_ = (SELECT IFNULL(MAX(ID)+1, 1) FROM Employee ORDER BY ID ASC);
		INSERT INTO Employee
		VALUES (id_, ssn_, fname_, mname_, lname_, bdate_, addr_, salary_, type_);
    END \\
DELIMITER ;

DROP PROCEDURE IF EXISTS insert_project;
DELIMITER \\
CREATE PROCEDURE insert_project(IN id int,IN name_ VARCHAR(200), IN description_ VARCHAR(500), IN cost_efficiency_ VARCHAR(100), IN cost_ FLOAT)
	BEGIN
		DECLARE pid_ int;
		SET pid_ = (SELECT IFNULL(MAX(PID)+1, 1) FROM Project ORDER BY PID ASC);
		INSERT INTO Project(PID,Name,Description,CostEfficiency,Cost,ID,StartDate,Period) 
        VALUES (pid_,name_,description_,cost_efficiency_,cost_,id,NOW(),'Fifth');
    END \\
DELIMITER ;



DROP PROCEDURE IF EXISTS insert_product;
DELIMITER \\
CREATE PROCEDURE insert_product(IN name_ VARCHAR(200), IN description_ VARCHAR(500), IN cost_efficiency_ VARCHAR(100), IN cost_ FLOAT)
	BEGIN
		DECLARE pid_ int;
		SET pid_ = (SELECT IFNULL(MAX(PID)+1, 1) FROM Project ORDER BY PID ASC);
		INSERT INTO Project
		VALUES (pid_, name_, description_, cost_efficiency_, cost_);
    END \\ 
DELIMITER ;

DROP PROCEDURE IF EXISTS notifications_of_equipment;
DELIMITER \\
DROP PROCEDURE IF EXISTS insert_activity;
CREATE PROCEDURE insert_activity(IN name_ VARCHAR(200), IN description_ VARCHAR(500), IN cost_efficiency_ VARCHAR(100), IN cost_ FLOAT)
	BEGIN
		select PID, ASession
		from Works_on, wSession
		where Works_on.ID=WorkerID and wSession.ID=Works_on.ID and wSession.PID=Works_on.PID;
    END \\
DELIMITER ;

-- CREATE TABLE Works_on (
-- 	ID INTEGER,
-- 	PID INTEGER,
-- 	PRIMARY KEY (ID, PID),
-- 	FOREIGN KEY (ID) REFERENCES Worker(ID) ON DELETE CASCADE ON UPDATE CASCADE,
-- 	FOREIGN KEY (PID) REFERENCES Equipment(PID) ON DELETE CASCADE ON UPDATE CASCADE
-- );

-- CREATE TABLE wSession (
-- 	ID INTEGER,
-- 	PID INTEGER,
-- 	ASession VARCHAR(20),
-- 	PRIMARY KEY (ID, PID, ASession),
-- 	FOREIGN KEY (ID, PID) REFERENCES works_on(ID, PID) ON DELETE CASCADE ON UPDATE CASCADE
-- );

-- lấy group thuộc về project
DROP PROCEDURE IF EXISTS get_group_of_project;
DELIMITER \\
CREATE PROCEDURE get_group_of_project(IN pid_ int)
	BEGIN
		select GNumber, Name, Location
		from `Group`
		where `Group`.PID = pid_;
    END \\
DELIMITER ;


-- lấy leader của project
DROP PROCEDURE IF EXISTS get_leader_of_project;
DELIMITER \\
CREATE PROCEDURE get_leader_of_project(IN pid_ int)
	BEGIN
		select Employee.ID, FName, MName, LName, StartDate, Period, EmployeeType 
		from Employee join Project on Employee.ID = Project.ID
		where Project.PID = pid_;
    END \\
DELIMITER ;


-- lấy model của project
DROP PROCEDURE IF EXISTS get_model_of_project;
DELIMITER \\
CREATE PROCEDURE get_model_of_project(IN pid_ int)
	BEGIN
		select Model.MNumber as Mnumber, DateCreated, Project.PID as ProjectID, Model.ID  as DesignerID
		from Model, ModelInProject, Project
		where Model.MNumber = ModelInProject.MNumber and ModelInProject.ProjectID = Project.PID;
    END \\
DELIMITER ;


-- lấy supplier của project
DROP PROCEDURE IF EXISTS get_supplier_of_project;
DELIMITER \\
CREATE PROCEDURE get_supplier_of_project(IN pid_ int)
	BEGIN
		select SID, Location, Date, Quantity, Price 
		from Supplies, Supplier
		where Supplies.SupplierID = Supplier.SID and Supplies.ProjectID = pid_;
    END \\
DELIMITER ;


-- Show Employee List
DROP PROCEDURE IF EXISTS ShowEmployee;
DELIMITER // 
CREATE PROCEDURE ShowEmployee()
BEGIN
SELECT * FROM EmployeeView;
END //

DELIMITER ;

-- Show Project List
DROP PROCEDURE IF EXISTS ShowProject;
DELIMITER //
CREATE PROCEDURE ShowProject()
BEGIN
SELECT * FROM ProjectView;
END //

DELIMITER ;

-- Show Product List
DROP PROCEDURE IF EXISTS ShowProduct;
DELIMITER //
CREATE PROCEDURE ShowProduct()
BEGIN
SELECT * FROM ProductView;
END //

DELIMITER ;

-- Show Activity List
DROP PROCEDURE IF EXISTS ShowActivity;
DELIMITER //
CREATE PROCEDURE ShowActivity()
BEGIN
SELECT * FROM ActivityView;
END //

DELIMITER ;

-- Show Model List
DROP PROCEDURE IF EXISTS ShowModel;
DELIMITER //
CREATE PROCEDURE ShowModel()
BEGIN
SELECT * FROM ModelView;
END //

DELIMITER ;

-- Show Info of Employee with input: ID
DROP PROCEDURE IF EXISTS ViewInfo;
DELIMITER //
CREATE PROCEDURE ViewInfo(IN id_ int)
BEGIN
DROP TABLE IF EXISTS temp_info;
CREATE TABLE temp_info
SELECT * FROM EmployeeView WHERE ID = id_;
SELECT * FROM temp_info;
END //

DELIMITER ;

-- login --
-- username and password entered by the user -- 
DROP PROCEDURE IF EXISTS Login;
DELIMITER //
CREATE PROCEDURE Login (
	IN username_ VARCHAR(20),
    IN password_ VARCHAR(100)
)
Log: BEGIN
	SELECT COUNT(*) FROM Account
    WHERE Username = username_ AND Password = password_;
    LEAVE Log;
END //
DELIMITER ;

-- Remove
DROP PROCEDURE IF EXISTS RemoveEmployee;
DELIMITER //
CREATE PROCEDURE RemoveEmployee (IN id_ int)
remove_employee: BEGIN
    DELETE FROM Employee
    WHERE ID = id_;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS RemoveProject;
DELIMITER //
CREATE PROCEDURE RemoveProject (IN pid_ int)
remove_project: BEGIN
    DELETE FROM Project
    WHERE PID = pid_;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS RemoveProduct;
DELIMITER //
CREATE PROCEDURE RemoveProduct (IN pid_ int)
remove_product: BEGIN
    DELETE FROM Product
    WHERE PID = pid_;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS RemoveActivity;
DELIMITER //
CREATE PROCEDURE RemoveActivity (IN aid_ int)
remove_activity: BEGIN
    DELETE FROM Activity
    WHERE AID = aid_;
END //
DELIMITER ;

-- update info 
DROP PROCEDURE IF EXISTS update_info;
DELIMITER \\
CREATE PROCEDURE update_info(IN id_ int, IN ssn_ VARCHAR(10), IN fname_ VARCHAR(50),
							 IN mname_ VARCHAR(50),  IN lname_ VARCHAR(50), IN bdate_ DATE,
							 IN addr_ VARCHAR(200), IN salary_ FLOAT, IN type_ int)
	BEGIN
			UPDATE Employee
            SET SSN = IF(ssn_ IS NOT NULL, ssn_, SSN),
				FName = IF(fname_ IS NOT NULL, fname_, FName),
                MName = IF(mname_ IS NOT NULL, mname_, MName),
                LName = IF(lname_ IS NOT NULL, lname_, LName),
				BDate = IF(bdate_ IS NOT NULL, bdate_, BDate),
				Address = IF(addr_ IS NOT NULL, addr_, Address),
				Salary = IF(salary_ IS NOT NULL, salary_, Salary),
				EmployeeType = IF(type_ IS NOT NULL, type_, EmployeeType)
            WHERE ID = id_; 
    END \\
DELIMITER ;

DROP PROCEDURE IF EXISTS update_pass;
DELIMITER \\
CREATE PROCEDURE update_pass(IN username_ VARCHAR(20),
                             IN password_ VARCHAR(100))
	BEGIN 
			UPDATE Account
            SET
                Password = IF(password_ IS NOT NULL, password_, Password)
            WHERE Username = username_;
    END \\
DELIMITER ;


-- Insert
DROP PROCEDURE IF EXISTS insert_employee;
DELIMITER \\
CREATE PROCEDURE insert_employee(IN ssn_ VARCHAR(10), IN fname_ VARCHAR(50),
							 IN mname_ VARCHAR(50),  IN lname_ VARCHAR(50), IN bdate_ DATE,
							 IN addr_ VARCHAR(200), IN salary_ FLOAT, IN type_ int)
	BEGIN
		DECLARE id_ int;
		SET id_ = (SELECT IFNULL(MAX(ID)+1, 1) FROM Employee ORDER BY ID ASC);
		INSERT INTO Employee
		VALUES (id_, ssn_, fname_, mname_, lname_, bdate_, addr_, salary_, type_);
    END \\
DELIMITER ;

DROP PROCEDURE IF EXISTS insert_project;
DELIMITER \\
CREATE PROCEDURE insert_project(IN id int,IN name_ VARCHAR(200), IN description_ VARCHAR(500), IN cost_efficiency_ VARCHAR(100), IN cost_ FLOAT)
	BEGIN
		DECLARE pid_ int;
		SET pid_ = (SELECT IFNULL(MAX(PID)+1, 1) FROM Project ORDER BY PID ASC);
		INSERT INTO Project(PID, ID, Name, Description, CostEfficiency, Cost, StartDate, Period)
		VALUES (pid_, id ,name_, description_, cost_efficiency_, cost_, NOW(), 'fisrt');
    END \\
DELIMITER ;

DROP PROCEDURE IF EXISTS insert_product;
DELIMITER \\
CREATE PROCEDURE insert_product(IN name_ VARCHAR(200), IN description_ VARCHAR(500), IN cost_efficiency_ VARCHAR(100), IN cost_ FLOAT)
	BEGIN
		DECLARE pid_ int;
		SET pid_ = (SELECT IFNULL(MAX(PID)+1, 1) FROM Project ORDER BY PID ASC);
		INSERT INTO Project
		VALUES (pid_, name_, description_, cost_efficiency_, cost_);
    END \\ 
DELIMITER ;



-- lấy group thuộc về project
DROP PROCEDURE IF EXISTS get_group_of_project;
DELIMITER \\
CREATE PROCEDURE get_group_of_project(IN pid_ int)
	BEGIN
		select GNumber, Name, Location
		from `Group`
		where `Group`.PID = pid_;
    END \\
DELIMITER ;


-- lấy leader của project
DROP PROCEDURE IF EXISTS get_leader_of_project;
DELIMITER \\
CREATE PROCEDURE get_leader_of_project(IN pid_ int)
	BEGIN
		select Employee.ID, FName, MName, LName, StartDate, Period, EmployeeType 
		from Employee join Project on Employee.ID = Project.ID
		where Project.PID = pid_;
    END \\
DELIMITER ;


-- lấy model của project
DROP PROCEDURE IF EXISTS get_model_of_project;
DELIMITER \\
CREATE PROCEDURE get_model_of_project(IN pid_ int)
	BEGIN
		select Model.MNumber as Mnumber, DateCreated, Project.PID as ProjectID, Model.ID  as DesignerID
		from Model, ModelInProject, Project
		where Model.MNumber = ModelInProject.MNumber and ModelInProject.ProjectID = Project.PID;
    END \\
DELIMITER ;


-- lấy supplier của project
DROP PROCEDURE IF EXISTS get_supplier_of_project;
DELIMITER \\
CREATE PROCEDURE get_supplier_of_project(IN pid_ int)
	BEGIN
		select SID, Location, Date, Quantity, Price 
		from Supplies, Supplier
		where Supplies.SupplierID = Supplier.SID and Supplies.ProjectID = pid_;
    END \\
DELIMITER ;

DROP PROCEDURE IF EXISTS add_employee_to_group;
DELIMITER \\
CREATE PROCEDURE add_employee_to_group(in id_ int, in gnumber_ int, in pid_ int)
	BEGIN
		insert into Joins 
		values (id_,gnumber_,pid_);
    END \\
DELIMITER ;

-- lấy danh sách employee có trong group
DROP PROCEDURE IF EXISTS get_employee_of_group;
DELIMITER \\
CREATE PROCEDURE get_employee_of_group(in gnumber_ int, in pid_ int)
	BEGIN
		select Employee.ID as ID, SSN, FName, MName, LName, BDate, Address, Salary, EmployeeType
		from Employee e, Joins j
		where e.ID = j.ID and j.GNumber = gnumber_ and j.PID = pid_;
    END \\
DELIMITER ;

--
DROP PROCEDURE IF EXISTS insert_model;
DELIMITER \\
CREATE PROCEDURE insert_model(In Mnumber int, in PID int, in ID int, in DateCreated date)
	BEGIN
		insert into Model
		values(MNumber,PID,ID,DateCreated);
    END \\
DELIMITER ;


DROP PROCEDURE IF EXISTS delete_model;
DELIMITER \\
CREATE PROCEDURE delete_model(In Mnumber_ int, in PID_ int, in ID_ int)
	BEGIN
		delete from Model
		where Mnumber = Mnumber_ and PID=PID_ and ID=ID_;
    END \\
DELIMITER ;

-- Thêm model vào project
-- (MNumber, PID, ID) của model và ProjectID của project
DROP PROCEDURE IF EXISTS add_model_to_project;
DELIMITER \\
CREATE PROCEDURE add_model_to_project(In Mnumber_ int, in PID_ int, in ID_ int, in ProjectID_ int)
	BEGIN
		insert into ModelInProject 
		values (Mnumber_,PID_,ID_,ProjectID_);
    END \\
DELIMITER ;

DROP PROCEDURE IF EXISTS notifications_of_equipment;
DELIMITER \\
CREATE PROCEDURE notifications_of_equipment()
	BEGIN
		select Equipment.PID as EquipmentID, AComment as Comment
		from Equipment, Notification, Comments
		where Equipment.PID = Notification.PID and Notification.NID = Comments.NID;
    END \\
DELIMITER ;



DROP PROCEDURE IF EXISTS get_tasks_of_group;
DELIMITER \\
CREATE PROCEDURE get_tasks_of_group(in GNumber int, in PID int)
	BEGIN
		select TNumber, Name
		from Task
		where Task.GNumber = GNumber and Task.PID = PID;
    END \\
DELIMITER ;

-- lấy danh sách group mà employee tham gia
DROP PROCEDURE IF EXISTS get_group_of_employee;
DELIMITER \\
CREATE PROCEDURE get_group_of_employee(in EmployeeID int)
	BEGIN
		select `Group`.GNumber, `Group`.PID, Name, Location
		from `Group`, Joins
		where `Group`.GNumber =Joins.GNumber and `Group`.PID =Joins.PID and Joins.ID=EmployeeID;
    END \\
DELIMITER ;


-- lấy danh sách project mà employee tham gia
DROP PROCEDURE IF EXISTS get_project_of_employee;
DELIMITER \\
CREATE PROCEDURE get_project_of_employee(in EmployeeID int)
	BEGIN
		select Project.PID, Project.Name, Project.Description, Project.CostEfficiency, 
				Project.Cost, Project.ID, Project.StartDate, Project.Period
		from Project,Joins,`Group`
		where `Group`.GNumber=Joins.GNumber and `Group`.PID=Joins.PID 
				and Joins.ID=EmployeeID and Project.PID=`Group`.PID;
    END \\
DELIMITER ;


-- lấy danh sách model của designer
DROP PROCEDURE IF EXISTS get_model_of_designer;
DELIMITER \\
CREATE PROCEDURE get_model_of_designer(in DesignerID int)
	BEGIN
		select MNumber,PID,ID,DateCreated
		from Model
		where Model.ID=DesignerID;
    END \\
DELIMITER ;


-- lấy danh sách product của designer
DROP PROCEDURE IF EXISTS get_product_of_designer;
DELIMITER \\
CREATE PROCEDURE get_product_of_designer(in DesignerID int)
	BEGIN
		select Model.PID as ProductID
		from Model
		where Model.ID=DesignerID;
    END \\
DELIMITER ;


-- lấy danh sách product mà worker làm việc
DROP PROCEDURE IF EXISTS get_product_of_worker;
DELIMITER \\
CREATE PROCEDURE get_product_of_worker(in WorkerID int)
	BEGIN
		select Produces.ProductID as ProductID 
			from Works_on, Produces
			where Works_on.ID=WorkerID and Works_on.PID=Produces.EquipmentID;
    END \\
DELIMITER ;


-- lấy danh sách equipment của worker
DROP PROCEDURE IF EXISTS get_equipment_of_worker;
DELIMITER \\
CREATE PROCEDURE get_equipment_of_worker(in WorkerID int)
	BEGIN
		select A.PID, B.ASession
		from Works_on A, wSession B
		where A.ID=WorkerID and B.ID=A.ID and B.PID=A.PID;
    END \\
DELIMITER ;

-- thêm model
DROP PROCEDURE IF EXISTS insert_model;
DELIMITER \\
CREATE PROCEDURE insert_model(in PID int, in ID int)
	BEGIN
		DECLARE MNumber int;
		SET MNumber = (SELECT IFNULL(MAX(Model.MNumber)+1, 1)
						FROM Model 
						where Model.PID=PID and Model.ID=ID);
		insert into Model
		values(MNumber,PID,ID,current_date());
    END \\
DEL

-- thêm comment vào equipment
DROP PROCEDURE IF EXISTS insert_comment;
DELIMITER \\
CREATE PROCEDURE insert_comment(in EquipmentID int, in NID int, in comment varchar(200))
	BEGIN
		If (NID is null) Then
			Begin
				DECLARE NID_ int;
				set NID_ = (SELECT IFNULL(MAX(Notification.NID)+1, 1)
						FROM Notification);
				insert into Notification(NID,PID) values(NID_,EquipmentID);
				insert into Comments values(NID_,comment);
            end;
		ELSE
            insert into Comments values(NID,comment);
		END if;
    END \\
DELIMITER ;


