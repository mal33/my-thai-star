CREATE TABLE DateInfo(
  "DATE" DATE,
  TEMPERATURE DOUBLE,
  DESIGNATION VARCHAR(255)
);

CREATE VIEW DailyOrderedDishes AS SELECT
  "ORDERLINE".idDish AS "IDDISH",
  "BOOKING".bookingDate AS "BOOKINGDATE",
  CAST(SUM("ORDERLINE".amount) AS INTEGER) AS "AMOUNT"
FROM OrderLine AS "ORDERLINE"
JOIN Orders AS "ORDERS" ON "ORDERLINE".idOrder = "ORDERS".id
JOIN Booking AS "BOOKING" ON "BOOKING".id = "ORDERS".idBooking
GROUP BY "BOOKINGDATE", "IDDISH"
ORDER BY "BOOKINGDATE";

CREATE VIEW MonthlyOrderedDishes AS SELECT
  "ORDERLINE".idDish AS "IDDISH",
  TO_DATE(TO_CHAR("BOOKING".bookingDate, 'YYYY-MM'), 'YYYY-MM') AS "BOOKINGDATE",
  ROUND(AVG("DATEINFO".TEMPERATURE),1) AS "TEMPERATURE",
  CAST(SUM("ORDERLINE".amount) AS INTEGER) AS "AMOUNT"
FROM OrderLine AS "ORDERLINE"
JOIN Orders AS "ORDERS" ON "ORDERLINE".idOrder = "ORDERS".id
JOIN Booking AS "BOOKING" ON "BOOKING".id = "ORDERS".idBooking
JOIN DateInfo AS "DATEINFO" ON TO_CHAR("DATEINFO"."DATE", 'YYYY-MM') = TO_CHAR("BOOKING".bookingDate, 'YYYY-MM')
GROUP BY TO_DATE(TO_CHAR("BOOKING".bookingDate, 'YYYY-MM'), 'YYYY-MM'), "IDDISH"
ORDER BY "BOOKINGDATE";

CREATE VIEW OrderedDishesPerDay AS SELECT
  CAST(TO_CHAR("DAILYORDEREDDISHES".bookingDate, 'YYYYMMDD') || "DAILYORDEREDDISHES".idDish AS BIGINT) AS "ID",
  "DISH".modificationCounter,
  "DATEINFO".TEMPERATURE,
  "DATEINFO".DESIGNATION,
  "DAILYORDEREDDISHES".*
FROM DailyOrderedDishes AS "DAILYORDEREDDISHES"
JOIN Dish AS "DISH" ON "DAILYORDEREDDISHES".idDish = "DISH".id
JOIN DateInfo AS "DATEINFO" ON TO_CHAR("DATEINFO"."DATE", 'YYYY-MM-DD') = TO_CHAR("DAILYORDEREDDISHES".bookingDate, 'YYYY-MM-DD');

CREATE VIEW OrderedDishesPerMonth AS SELECT
  CAST(TO_CHAR("MONTHLYORDEREDDISHES".bookingDate, 'YYYYMMDD') || "MONTHLYORDEREDDISHES".idDish AS BIGINT) AS "ID",
  "DISH".modificationCounter,
  "MONTHLYORDEREDDISHES".*
FROM MonthlyOrderedDishes AS "MONTHLYORDEREDDISHES"
JOIN Dish AS "DISH" ON "MONTHLYORDEREDDISHES".idDish = "DISH".id;

CREATE TABLE PREDICTION_ALL_FORECAST (
  id BIGINT NOT NULL AUTO_INCREMENT,
  modificationCounter INTEGER NOT NULL,
  idDish BIGINT NOT NULL,
  dishName VARCHAR(255),
  timestamp INTEGER,
  forecast DOUBLE,
  CONSTRAINT PK_PREDICTION_ALL_FORECAST PRIMARY KEY(id),
);

CREATE TABLE PREDICTION_ALL_MODELS (
  idDish BIGINT NOT NULL,
  "KEY" VARCHAR(100),
  "VALUE" VARCHAR(5000),
  CONSTRAINT PK_PREDICTION_ALL_MODELS PRIMARY KEY(idDish, "KEY")
);

CREATE TABLE PREDICTION_FORECAST_DATA (
  "TIMESTAMP" INTEGER,
  "TEMPERATURE" DOUBLE,
  "HOLIDAY" INTEGER,
  CONSTRAINT PK_PREDICTION_FORECAST_DATA PRIMARY KEY("TIMESTAMP")
);

