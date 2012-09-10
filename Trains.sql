CREATE TABLE 'Train'(
	'ID' TEXT,
	'S_No' INTEGER,
	'Station' TEXT,
	'Day' INTEGER,
	'A_Time' TEXT,
	'D_Time' TEXT,
	'R_Date' INTEGER,
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
	'R_Date' INTEGER,
	'Distance' INTEGER
);

CREATE TABLE 'Pinyin'(
	'ID' INTEGER,
	'Station' TEXT,
	'Shortcode' TEXT,
	'FullCode' TEXT,
	'Province' TEXT,
	'ProPinyin' TEXT,
	'Call' INTEGER
);

CREATE VIEW ProvinceList AS
SELECT DISTINCT Province,ProPinyin
FROM Pinyin
ORDER BY ProPinyin;

CREATE VIEW NoStopRouteList AS
SELECT
	a.ID,
	a.Station startStation,
	b.Station endStation,
	b.R_Date-a.R_Date R_Date,
	b.Distance-a.Distance Distance
FROM
	Train a,
	Train b
WHERE
	a.ID=b.ID
	AND a.S_No<b.S_No;
	
CREATE INDEX TrainIndex on Train (ID, Station, S_No);
CREATE INDEX TrainListIndex on TrainList (ID);
CREATE INDEX PinyinIndex on Pinyin (Shortcode, FullCode);