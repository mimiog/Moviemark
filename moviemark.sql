USE MOVIEMARK;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS FOOD_DISTRIBUTOR(
	ID varchar(10) NOT NULL,
	PHONE_NUM varchar(13),
	DISTRIBUTOR_NAME varchar(50),
	ADDRESS varchar(50),
    SUPPLY_BARCODE int,
    Primary key(ID),
	foreign key (SUPPLY_BARCODE) REFERENCES CONCESSIONS(BARCODE_NUMBER)
);

CREATE TABLE IF NOT EXISTS CONCESSIONS(
	BARCODE_NUMBER int NOT NULL,
    FOOD_ITEM varchar(50),
    CALORIES int,
    AMOUNT_IN_OZ decimal(4,1),
    DIST_ID VARCHAR(10),
    CUSTOMER_USERNAME VARCHAR(20),
    REWARD_CODE VARCHAR(10),
    Primary key(BARCODE_NUMBER),
    FOREIGN KEY(DIST_ID) REFERENCES FOOD_DISTRIBUTOR(ID),
    FOREIGN KEY(CUSTOMER_USERNAME) REFERENCES CUSTOMER(USERNAME),
    FOREIGN KEY(REWARD_CODE) REFERENCES REWARDS(OFFER_CODE)
);

CREATE TABLE IF NOT EXISTS REWARDS(
	OFFER_CODE varchar(10) NOT NULL,
    OFFER_DESCRIPTION varchar(250),
    POINTS_NEEDED int,
    CUSTOMER_USERNAME VARCHAR(20),
    Primary Key(OFFER_CODE),
    FOREIGN KEY(CUSTOMER_USERNAME) REFERENCES CUSTOMER (USERNAME)
);

CREATE TABLE IF NOT EXISTS CUSTOMER
(   USERNAME varchar(20) NOT NULL,
	PASSWORD varchar(30) not null,
	FNAME varchar(50) not null,
    LNAME varchar(50) not null,
    EMAIL varchar(50) not null,
    REWARD_CODE varchar(10),
    BARCODE_NUMBER int,
    TICKET_CODE INT,
    Primary Key(username),
    foreign key(REWARD_CODE) REFERENCES REWARDS(OFFER_CODE),
    foreign key(BARCODE_NUMBER) REFERENCES CONCESSIONS(BARCODE_NUMBER),
    FOREIGN KEY(TICKET_CODE) REFERENCES TICKET(TICKET_CODE)
);

#TIME, DATE, AND THEATER NUMBER HAS BEEN TAKEN OUT: CAN BE ACCESSED VIA T_SCHEDULE
CREATE TABLE IF NOT EXISTS TICKET(
	TICKET_CODE int not null,
    SEAT_NUM int not null,
    PRICE decimal(3,2),
    CUSTOMER_USERNAME varchar(20) not null,
    MOVIE_CODE int not null,
    SCHEDULE_KEY INT,
	primary key(ticket_code),
    foreign key(MOVIE_CODE) references MOVIE(MOVIE_CODE),
    foreign key(CUSTOMER_USERNAME) references CUSTOMER(USERNAME),
    FOREIGN KEY(SCHEDULE_KEY) REFERENCES T_SCHEDULE(SCHEDULE_KEY)
);

CREATE TABLE IF NOT EXISTS IS_PART_OF(
	SEATS_AVAILABLE int,
	TICKET_CODE INT,
    SCHEDULE_KEY INT,
    FOREIGN KEY(TICKET_CODE) REFERENCES TICKET(TICKET_CODE),
    FOREIGN KEY(SCHEDULE_KEY) REFERENCES T_SCHEDULE(SCHEDULE_KEY)
);

#T_SCHEDULE ISN'T ACTUALLY NECESSARY HERE TO BE RELATED TO
CREATE TABLE IF NOT EXISTS MOVIE(
	MOVIE_CODE int not null,
    TITLE varchar(50),
    DURATION varchar(20),
    RATING decimal(5,1),
    TICKET_CODE int not null,
    primary key(movie_code, ticket_code),
    foreign key(ticket_code) references TICKET(ticket_code)
);

#RELATIONSHIP
CREATE TABLE IF NOT EXISTS DISTRIBUTED_BY(
	LEASE_START date,
    LEASE_END date,
    LEASE_STATUS varchar(10),
    MOVIE_CODE INT,
    DIST_ID VARCHAR(20),
    FOREIGN KEY(MOVIE_CODE) REFERENCES MOVIE(MOVIE_CODE),
    FOREIGN KEY(DIST_ID) REFERENCES DISTRIBUTOR(ID)
);

CREATE TABLE IF NOT EXISTS DISTRIBUTOR(
	ID varchar(20) NOT NULL,
    DISTRIBUTOR_NAME varchar(50),
    PHONE_NUM varchar(13),
    EMAIL varchar (40),
    MOVIE_CODE INT,
    ADMIN_CODE INT,
    Primary key(ID),
    FOREIGN KEY(MOVIE_CODE) REFERENCES MOVIE(MOVIE_CODE),
    FOREIGN KEY(ADMIN_CODE) REFERENCES T_ADMIN(ADMIN_CODE)
);

#IT'S T_SCHEDULE AND NOT SCHEDULE BC IT LIGHTS UP BLUE
CREATE TABLE IF NOT EXISTS T_SCHEDULE(
	SCHEDULE_KEY int NOT NULL,
    THEATRE_NUMBER int,
    MOVIE_TIME time,
    MOVIE_DATE date,
    MOVIE_CODE INT,
    TICKET_CODE INT,
    PRIMARY KEY(SCHEDULE_KEY),
    FOREIGN KEY(MOVIE_CODE) REFERENCES MOVIE(MOVIE_CODE),
    FOREIGN KEY(TICKET_CODE) REFERENCES TICKET(TICKET_CODE)
);

CREATE TABLE IF NOT EXISTS EMPLOYEE(
	SSN int not null,
    ID int not null,
    FNAME varchar(20),
    LNAME varchar(20),
    EMAIL varchar(40),
    PHONE_NUMBER varchar(13),
    ADDRESS varchar(50),
    Primary key(SSN, ID),
    FOREIGN KEY(SSN) REFERENCES TIMESHEET(EMPLOYEE_SSN)
);

CREATE TABLE IF NOT EXISTS WORKER(
	SSN int not null,
    ID int not null,
    CUSTOMER_USERNAME VARCHAR(20),
    FOREIGN KEY (SSN, ID) REFERENCES EMPLOYEE(SSN, ID)
);


CREATE TABLE IF NOT EXISTS MANAGER(
	SSN int not null,
    ID int not null,
    MANAGER_CODE int not null,
    Primary key(SSN, ID, MANAGER_CODE),
    FOREIGN KEY(SSN, ID) REFERENCES EMPLOYEE(SSN, ID)
);

CREATE TABLE IF NOT EXISTS T_ADMIN(
	SSN int NOT NULL,
    ID int not null,
    ADMIN_CODE int not null,
    BILL_TYPE VARCHAR(15) NOT NULL,
    SCHEDULE_KEY INT,
    DIST_ID VARCHAR(20),
    PRIMARY KEY(ADMIN_CODE),
    FOREIGN KEY(SSN, ID) REFERENCES EMPLOYEE(SSN, ID),
    FOREIGN KEY(BILL_TYPE) REFERENCES BILLS(BILL_TYPE),
    FOREIGN KEY(SCHEDULE_KEY) REFERENCES T_SCHEDULE(SCHEDULE_KEY),
    FOREIGN KEY(DIST_ID) REFERENCES DISTRIBUTOR(ID)
);

CREATE TABLE IF NOT EXISTS TIMESHEET(
	EMPLOYEE_SSN int not null,
    W_DATE date,
    DAY_OF_WEEK varchar(9),
    HOURS int,
    FOREIGN key(EMPLOYEE_SSN) REFERENCES EMPLOYEE(SSN)
);

CREATE TABLE IF NOT EXISTS BILLS(
	BILL_TYPE varchar(15) not null,
    AMOUNT_DUE decimal(6, 2),
    DUE_DATE date,
    PAYMENT_STATUS varchar(10),
    ADMIN_CODE int not null,
    PRIMARY KEY(BILL_TYPE),
    FOREIGN KEY(ADMIN_CODE) REFERENCES T_ADMIN(ADMIN_CODE)
);
SET FOERIGN_KEY_CHECKS = 1;

alter table movie
add TIME varchar(20);

SELECT * FROM employee;