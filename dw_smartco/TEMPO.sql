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
CREATE TABLE time_calendar_dim AS
WITH base_calendar AS
  (SELECT CurrDate          AS Day_ID,
    1                       AS Day_Time_Span,
    CurrDate                AS Day_End_Date,
    TO_CHAR(CurrDate,'Day') AS Week_Day_Full,
    TO_CHAR(CurrDate,'DY')  AS Week_Day_Short,
    TO_NUMBER(TRIM(leading '0'
  FROM TO_CHAR(CurrDate,'D'))) AS Day_Num_of_Week,
    TO_NUMBER(TRIM(leading '0'
  FROM TO_CHAR(CurrDate,'DD'))) AS Day_Num_of_Month,
    TO_NUMBER(TRIM(leading '0'
  FROM TO_CHAR(CurrDate,'DDD'))) AS Day_Num_of_Year,
    UPPER(TO_CHAR(CurrDate,'Mon')
    || '-'
    || TO_CHAR(CurrDate,'YYYY')) AS Month_ID,
    TO_CHAR(CurrDate,'Mon')
    || ' '
    || TO_CHAR(CurrDate,'YYYY') AS Month_Short_Desc,
    RTRIM(TO_CHAR(CurrDate,'Month'))
    || ' '
    || TO_CHAR(CurrDate,'YYYY') AS Month_Long_Desc,
    TO_CHAR(CurrDate,'Mon')     AS Month_Short,
    TO_CHAR(CurrDate,'Month')   AS Month_Long,
    TO_NUMBER(TRIM(leading '0'
  FROM TO_CHAR(CurrDate,'MM'))) AS Month_Num_of_Year,
    'Q'
    || UPPER(TO_CHAR(CurrDate,'Q')
    || '-'
    || TO_CHAR(CurrDate,'YYYY'))     AS Quarter_ID,
    TO_NUMBER(TO_CHAR(CurrDate,'Q')) AS Quarter_Num_of_Year,
    CASE
      WHEN TO_NUMBER(TO_CHAR(CurrDate,'Q')) <= 2
      THEN 1
      ELSE 2
    END AS half_num_of_year,
    CASE
      WHEN TO_NUMBER(TO_CHAR(CurrDate,'Q')) <= 2
      THEN 'H'
        || 1
        || '-'
        || TO_CHAR(CurrDate,'YYYY')
      ELSE 'H'
        || 2
        || '-'
        || TO_CHAR(CurrDate,'YYYY')
    END                      AS half_of_year_id,
    TO_CHAR(CurrDate,'YYYY') AS Year_ID
  FROM
    (SELECT level n,
      -- Calendar starts at the day after this date.
      TO_DATE('31/12/2010','DD/MM/YYYY') + NUMTODSINTERVAL(level,'DAY') CurrDate
    FROM dual
      -- Change for the number of days to be added to the table.
      CONNECT BY level <= 3650
    )
  )
SELECT day_id,
  day_time_span,
  day_end_date,
  week_day_full,
  week_day_short,
  day_num_of_week,
  day_num_of_month,
  day_num_of_year,
  month_id,
  COUNT(*) OVER (PARTITION BY month_id)    AS Month_Time_Span,
  MAX(day_id) OVER (PARTITION BY month_id) AS Month_End_Date,
  month_short_desc,
  month_long_desc,
  month_short,
  month_long,
  month_num_of_year,
  quarter_id,
  COUNT(*) OVER (PARTITION BY quarter_id)    AS Quarter_Time_Span,
  MAX(day_id) OVER (PARTITION BY quarter_id) AS Quarter_End_Date,
  quarter_num_of_year,
  half_num_of_year,
  half_of_year_id,
  COUNT(*) OVER (PARTITION BY half_of_year_id)    AS Half_Year_Time_Span,
  MAX(day_id) OVER (PARTITION BY half_of_year_id) AS Half_Year_End_Date,
  year_id,
  COUNT(*) OVER (PARTITION BY year_id)    AS Year_Time_Span,
  MAX(day_id) OVER (PARTITION BY year_id) AS Year_End_Date
FROM base_calendar
ORDER BY day_id;
);
--
COMMIT;