--
-- Create time dimension table for a standard calendar year (day, month,
-- quarter, half year and year).
--
-- Drop table.
--
--DROP TABLE time_calendar_dim;
--
-- Create time dimension table for calendar year.
--
-- First day if the next day after TO_DATE('31/12/2010','DD/MM/YYYY').
-- Number of days is set in CONNECT BY level <= 365.
--
-- Values for end date and time span attributes are place holders. They need
-- to be filled in correctly later in this script.
--
DROP TABLE MIS_TD002_TEMPO;

CREATE TABLE MIS_TD002_TEMPO AS
WITH BASE_CALENDAR AS
  (SELECT CURRDATE          AS DAY_ID,
    1                       AS DAY_TIME_SPAN,
    CURRDATE                AS DAY_END_DATE,
    TO_CHAR(CURRDATE,'Day') AS WEEK_DAY_FULL,
    TO_CHAR(CURRDATE,'DY')  AS WEEK_DAY_SHORT,
    TO_NUMBER(TRIM(LEADING '0'
  FROM TO_CHAR(CURRDATE,'D'))) AS DAY_NUM_OF_WEEK,
    TO_NUMBER(TRIM(LEADING '0'
  FROM TO_CHAR(CURRDATE,'DD'))) AS DAY_NUM_OF_MONTH,
    TO_NUMBER(TRIM(LEADING '0'
  FROM TO_CHAR(CURRDATE,'DDD'))) AS DAY_NUM_OF_YEAR,
    UPPER(TO_CHAR(CURRDATE,'Mon')
    || '-'
    || TO_CHAR(CURRDATE,'YYYY')) AS MONTH_ID,
    TO_CHAR(CURRDATE,'Mon')
    || ' '
    || TO_CHAR(CURRDATE,'YYYY') AS MONTH_SHORT_DESC,
    RTRIM(TO_CHAR(CURRDATE,'Month'))
    || ' '
    || TO_CHAR(CURRDATE,'YYYY') AS MONTH_LONG_DESC,
    TO_CHAR(CURRDATE,'Mon')     AS MONTH_SHORT,
    TO_CHAR(CURRDATE,'Month')   AS MONTH_LONG,
    TO_NUMBER(TRIM(LEADING '0'
  FROM TO_CHAR(CURRDATE,'MM'))) AS MONTH_NUM_OF_YEAR,
    'Q'
    || UPPER(TO_CHAR(CURRDATE,'Q')
    || '-'
    || TO_CHAR(CURRDATE,'YYYY'))     AS QUARTER_ID,
    TO_NUMBER(TO_CHAR(CURRDATE,'Q')) AS QUARTER_NUM_OF_YEAR,
    CASE
      WHEN TO_NUMBER(TO_CHAR(CURRDATE,'Q')) <= 2
      THEN 1
      ELSE 2
    END AS HALF_NUM_OF_YEAR,
    CASE
      WHEN TO_NUMBER(TO_CHAR(CURRDATE,'Q')) <= 2
      THEN 'H'
        || 1
        || '-'
        || TO_CHAR(CURRDATE,'YYYY')
      ELSE 'H'
        || 2
        || '-'
        || TO_CHAR(CURRDATE,'YYYY')
    END                      AS HALF_OF_YEAR_ID,
    TO_CHAR(CURRDATE,'YYYY') AS YEAR_ID
  FROM
    (SELECT LEVEL N,
      -- Calendar starts at the day after this date.
      TO_DATE('31/12/2010','DD/MM/YYYY') + NUMTODSINTERVAL(LEVEL,'DAY') CURRDATE
    FROM DUAL
      -- Change for the number of days to be added to the table.
      CONNECT BY LEVEL <= 3650
    )
  )
SELECT DAY_ID,
  DAY_TIME_SPAN,
  DAY_END_DATE,
  WEEK_DAY_FULL,
  WEEK_DAY_SHORT,
  DAY_NUM_OF_WEEK,
  DAY_NUM_OF_MONTH,
  DAY_NUM_OF_YEAR,
  MONTH_ID,
  COUNT(*) OVER (PARTITION BY MONTH_ID)    AS MONTH_TIME_SPAN,
  MAX(DAY_ID) OVER (PARTITION BY MONTH_ID) AS MONTH_END_DATE,
  MONTH_SHORT_DESC,
  MONTH_LONG_DESC,
  MONTH_SHORT,
  MONTH_LONG,
  MONTH_NUM_OF_YEAR,
  QUARTER_ID,
  COUNT(*) OVER (PARTITION BY QUARTER_ID)    AS QUARTER_TIME_SPAN,
  MAX(DAY_ID) OVER (PARTITION BY QUARTER_ID) AS QUARTER_END_DATE,
  QUARTER_NUM_OF_YEAR,
  HALF_NUM_OF_YEAR,
  HALF_OF_YEAR_ID,
  COUNT(*) OVER (PARTITION BY HALF_OF_YEAR_ID)    AS HALF_YEAR_TIME_SPAN,
  MAX(DAY_ID) OVER (PARTITION BY HALF_OF_YEAR_ID) AS HALF_YEAR_END_DATE,
  YEAR_ID,
  COUNT(*) OVER (PARTITION BY YEAR_ID)    AS YEAR_TIME_SPAN,
  MAX(DAY_ID) OVER (PARTITION BY YEAR_ID) AS YEAR_END_DATE
FROM BASE_CALENDAR
ORDER BY DAY_ID;);
COMMIT;
