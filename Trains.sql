CREATE TABLE 'Train'(
	'ID' TEXT,
	'S_No' INTEGER,
	'Station' TEXT,
	'A_Time' TEXT,
	'D_Time' TEXT,
	'R_Date' TEXT,
	'Distance' INTEGER,
	'P1' TEXT,
	'P2' TEXT,
	'P3' TEXT,
	'P4' TEXT,
	'Type' TEXT
);

CREATE TABLE 'TrainList'(
	'ID' TEXT,
	'Type' TEXT,
	'startStation' TEXT,
	'endStation' TEXT,
	'R_Date' TEXT,
	'Distance' INTEGER
);