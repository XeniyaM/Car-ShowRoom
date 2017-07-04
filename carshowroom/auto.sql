DROP DATABASE IF EXISTS `autoservices`;

CREATE DATABASE IF NOT EXISTS `autoservices` CHARACTER SET `utf8`;

USE `autoservices`;

-- Таблица содержащая список пользователей в системе , связана ключами с Таблицами Cars(автомобили), Discount_Card(Дисконтная карта), UserGroup(Группа пользователя)
CREATE TABLE `Users` (
	`UsersID` bigint NOT NULL AUTO_INCREMENT,
	`Name` varchar(255) NOT NULL,
	`SurName` varchar(255) NOT NULL,
	`GroupId` bigint NOT NULL,
	`CarID` bigint NOT NULL,
	`Discount_Card_Id` bigint NOT NULL,
	`Password` varchar(255) NOT NULL,
	PRIMARY KEY (`UsersID`)
);
-- Таблиуа с описанием группы пользователя нужна для хранения системной информации о доступе к функциям
CREATE TABLE `UserGroup` (
	`GroupId` bigint NOT NULL AUTO_INCREMENT,
	`GroupName` varchar(255) NOT NULL,
	`GroupAcess` varchar(255) NOT NULL,
	PRIMARY KEY (`GroupId`)
);
-- Таблица с описанием машин пользователя(в случае необходимости можно/нужно разделить)
CREATE TABLE `Cars` (
	`CarID` bigint NOT NULL AUTO_INCREMENT,
	`BodyType` varchar(255) NOT NULL,
	`Mark` varchar(255) NOT NULL,
	`Model` varchar(255) NOT NULL,
	`Vin_Number` varchar(255) NOT NULL,
	`Year_Man` DATETIME NOT NULL,
	`Reg_Num` varchar(255) NOT NULL,
	`Code_Audio` varchar(255) NOT NULL,
	PRIMARY KEY (`CarID`)
);
-- Наименование скидки и процент по ней(если надо можно добавить дату действия)
CREATE TABLE `Discount_Name` (
	`Name_Id` bigint NOT NULL AUTO_INCREMENT,
	`Name` bigint NOT NULL ,
	`Persent` bigint NOT NULL,
	PRIMARY KEY (`Name_Id`)
);
-- Таблица содержащая в себе Группу скидки(Напр. акция, распродажа и т.д.)
CREATE TABLE `Discount_Group` (
	`Group_ID` bigint NOT NULL AUTO_INCREMENT,
	`Group_Name` bigint NOT NULL,
	PRIMARY KEY (`Group_ID`)
);
-- Буфферная таблица для связи всех необходимых данных
CREATE TABLE `Discount_Card` (
	`Card_ID` bigint NOT NULL,
	`Name_ID` bigint NOT NULL,
	`Group_ID` bigint NOT NULL,
	PRIMARY KEY (`Card_ID`)
);
-- Таблица Заказ может содержать в себе несколько позиций содержит ID на пользователя, скидку , машину
CREATE TABLE `Orders` (
	`Order_ID` bigint NOT NULL,
	`Order_Date` DATETIME NOT NULL,
	`Kind_Type_ID` bigint NOT NULL,
	`User_ID` bigint NOT NULL,
	`Order_sum` bigint NOT NULL,
	PRIMARY KEY (`Order_ID`)
);
-- Позиции заказа 
CREATE TABLE `Order_Line` (
	`Line_ID` bigint NOT NULL,
	`Order_ID` bigint NOT NULL,
	`Line_Sum` bigint NOT NULL,
	`Max_Disc` bigint NOT NULL,
	`Services_ID` bigint NOT NULL,
	`Master_ID` bigint NOT NULL,
	PRIMARY KEY (`Line_ID`)
);

-- Список услуг компании с прмерным временем выполнения и ценой
CREATE TABLE `Servises` (
	`Servises_ID` bigint NOT NULL AUTO_INCREMENT,
	`Servises_Name` bigint NOT NULL,
	`Time_Frame` bigint NOT NULL,
	`Servises_Cost` bigint NOT NULL,
	PRIMARY KEY (`Servises_ID`)
);
-- Тип заказа (срочный/несрочный, vip и т.д.)
CREATE TABLE `Kind_Type` (
	`Type_ID` bigint NOT NULL AUTO_INCREMENT,
	`Type_Name` varchar(255) NOT NULL,
	`Type_Code` varchar(255) NOT NULL,
	PRIMARY KEY (`Type_ID`)
);

-- Таблица с сообщениями системы (очень удобно вести версионность программы)
CREATE TABLE `Message_Table` (
	`Msg_ID` bigint NOT NULL,
	`Msg_Title` varchar(255) NOT NULL,
	`Msg_text` varchar(255) NOT NULL,
	PRIMARY KEY (`Msg_ID`)
);

-- (Системные логи программы для оперативного доступа и исправления ошибок в системе)
CREATE TABLE `Log_Table` (
	`Log_ID` bigint NOT NULL AUTO_INCREMENT,
	`Log_descriprion` varchar(255) NOT NULL,
	`Log_Text` varchar(255) NOT NULL,
	`Log_date` DATETIME NOT NULL,
	PRIMARY KEY (`Log_ID`)
);
-- Буфферная таблица для связи позиции заказа и мастера обслуживающего этот заказ
CREATE TABLE `Master_Table` (
	`Master_ID` bigint NOT NULL AUTO_INCREMENT,
	`Worker_ID` bigint NOT NULL,
	PRIMARY KEY (`Master_ID`)
);
-- Таблица описания мастеров и их специализации
CREATE TABLE `Worker_Table` (
	`Worker_ID` bigint NOT NULL AUTO_INCREMENT,
	`Worker_Name` bigint NOT NULL,
	`Worker_SurName` varchar(255) NOT NULL,
	`Worker_Specialization` varchar(255) NOT NULL,
	PRIMARY KEY (`Worker_ID`)
);

ALTER TABLE `Users` ADD CONSTRAINT `Users_fk0` FOREIGN KEY (`GroupId`) REFERENCES `UserGroup`(`GroupId`);

ALTER TABLE `Users` ADD CONSTRAINT `Users_fk1` FOREIGN KEY (`CarID`) REFERENCES `Cars`(`CarID`);

ALTER TABLE `Users` ADD CONSTRAINT `Users_fk2` FOREIGN KEY (`Discount_Card_Id`) REFERENCES `Discount_Card`(`Card_ID`);

ALTER TABLE `Discount_Card` ADD CONSTRAINT `Discount_Card_fk0` FOREIGN KEY (`Name_ID`) REFERENCES `Discount_Name`(`Name_Id`);

ALTER TABLE `Discount_Card` ADD CONSTRAINT `Discount_Card_fk1` FOREIGN KEY (`Group_ID`) REFERENCES `Discount_Group`(`Group_ID`);

ALTER TABLE `Orders` ADD CONSTRAINT `Order_fk0` FOREIGN KEY (`Kind_Type_ID`) REFERENCES `Kind_Type`(`Type_ID`);

ALTER TABLE `Orders` ADD CONSTRAINT `Order_fk1` FOREIGN KEY (`User_ID`) REFERENCES `Users`(`UsersID`);

ALTER TABLE `Order_Line` ADD CONSTRAINT `Order_Line_fk0` FOREIGN KEY (`Order_ID`) REFERENCES `Orders`(`Order_ID`);

ALTER TABLE `Order_Line` ADD CONSTRAINT `Order_Line_fk1` FOREIGN KEY (`Services_ID`) REFERENCES `Servises`(`Servises_ID`);

ALTER TABLE `Order_Line` ADD CONSTRAINT `Order_Line_fk2` FOREIGN KEY (`Master_ID`) REFERENCES `Master_Table`(`Master_ID`);

ALTER TABLE `Master_Table` ADD CONSTRAINT `Master_Table_fk0` FOREIGN KEY (`Worker_ID`) REFERENCES `Worker_Table`(`Worker_ID`);

-- Представление для получения списка пользователей с группой
CREATE VIEW `Get_User_and_Group` AS 
	select u.Name, u.SurName, ug.GroupName, ug.GroupAcess 
	from Users as u 
	left join UserGroup as ug on u.GroupId = ug.GroupId;

-- Получение данных о скидке для клиентов
CREATE VIEW `v_Get_User_Discount` AS 
	Select * from Users u
	left join(
		select disc.Card_ID, disc_gr.Group_Name, disc_name.Name as disc_name, disc_name.Persent 
		from Discount_Card as disc 
        left join Discount_Group as disc_gr on disc.Group_ID = disc_gr.Group_ID
		left join Discount_Name as disc_name on disc.Name_ID = disc_name.Name_ID ) disc_c
	on u.Discount_Card_Id = disc_c.Card_Id;

-- Выбрать все машины пользователя(очень удобно при отображении данных в формате мастер/деталь)
Create View `v_Get_User_Cars` AS
select u.Name, u.SurName, Cars.* from Users as u left join 
Cars on u.CarID = Cars.CarID;

-- Выбрать все заказы пользователя
CREATE VIEW `v_Get_User_Orders` AS     
Select o.* from Users as u left join 
Orders as o on u.UsersID = o.User_ID;

-- Получить список заказов с занятыми специлистами на них
CREATE VIEW `v_Get_ListMasters_On_OrderLine` AS     
select orders_l.*, masters_s.Worker_Name, masters_s.Worker_SurName, masters_s.Worker_Specialization from Order_Line as orders_l left join
(select works.*, masters.Master_ID from Master_Table as masters left join
	Worker_Table as works on masters.Worker_ID = works.Worker_ID) masters_s on masters_s.Master_ID = orders_l.Master_ID;



