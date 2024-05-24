USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE WAREHOUSE ML_HOL_WH; --by default, this creates an XS Standard Warehouse
CREATE OR REPLACE DATABASE ML_HOL_DB;
CREATE OR REPLACE SCHEMA ML_HOL_SCHEMA;
CREATE OR REPLACE STAGE ML_HOL_ASSETS; --to store model assets

-- create csv format
CREATE FILE FORMAT IF NOT EXISTS ML_HOL_DB.ML_HOL_SCHEMA.CSVFORMAT 
    SKIP_HEADER = 1 
    TYPE = 'CSV';

-- create external stage with the csv format to stage the diamonds dataset
CREATE STAGE IF NOT EXISTS ML_HOL_DB.ML_HOL_SCHEMA.DIAMONDS_ASSETS 
    FILE_FORMAT = ML_HOL_DB.ML_HOL_SCHEMA.CSVFORMAT 
    URL = 's3://sfquickstarts/intro-to-machine-learning-with-snowpark-ml-for-python/diamonds.csv';
    -- https://sfquickstarts.s3.us-west-1.amazonaws.com/intro-to-machine-learning-with-snowpark-ml-for-python/diamonds.csv

LS @DIAMONDS_ASSETS;

CREATE TABLE IF NOT EXISTS DIAMONDS (
    CARAT   NUMBER(10,3),
    CUT     VARCHAR,
    COLOR   VARCHAR,
    CLARITY VARCHAR,
    DEPTH   NUMBER(10,2),
    TABLE_PCT   NUMBER(10,2),
    PRICE   NUMBER(20),    
    X       NUMBER(10,2),
    Y       NUMBER(10,2),
    Z       NUMBER(10,2)
);

COPY INTO DIAMONDS
  FROM @DIAMONDS_ASSETS
  FILE_FORMAT = (FORMAT_NAME = 'CSVFORMAT')
  ON_ERROR = CONTINUE;  
    
SELECT * FROM DIAMONDS LIMIT 100; 