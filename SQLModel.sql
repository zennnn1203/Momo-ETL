
-- User
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'users';
GO

ALTER TABLE users
ALTER COLUMN User_id INT NOT NULL;
GO

EXEC sp_rename 'users.User_id', 'user_id', 'COLUMN';
EXEC sp_rename 'users.First_tran_date', 'first_tran_date', 'COLUMN';
EXEC sp_rename 'users.Location', 'location', 'COLUMN';
EXEC sp_rename 'users.Age', 'age', 'COLUMN';
EXEC sp_rename 'users.Gender', 'gender', 'COLUMN';
GO

-- TRANSACTIONS

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'transactions';
GO

ALTER TABLE transactions
ALTER COLUMN order_id BIGINT NOT NULL;

ALTER TABLE transactions
ALTER COLUMN user_id INT;

ALTER TABLE transactions
ALTER COLUMN Amount INT;

ALTER TABLE transactions
ALTER COLUMN Merchant_id SMALLINT;
GO

EXEC sp_rename 'transactions.Amount', 'amount', 'COLUMN';
EXEC sp_rename 'transactions.Merchant_id', 'merchant_id', 'COLUMN';
EXEC sp_rename 'transactions.Purchase_status', 'purchase_status', 'COLUMN';
GO

-- COMMISSION_CASHBACK

SELECT COLUMN_NAME, IS_NULLABLE, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'commission_cashback';

ALTER TABLE commission_cashback
ALTER COLUMN merchant_id INT NOT NULL;

-- Primary Key
ALTER TABLE commission_cashback
ADD CONSTRAINT PK_commission_cashback
PRIMARY KEY (merchant_id);
GO

ALTER TABLE commission_cashback
DROP CONSTRAINT C_commission_rate;

-- ===== commission_rate =====
IF EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'C_commission_rate'
      AND parent_object_id = OBJECT_ID('commission_cashback')
)
BEGIN
    ALTER TABLE commission_cashback
    DROP CONSTRAINT C_commission_rate;
END;
GO

ALTER TABLE commission_cashback
ADD CONSTRAINT C_commission_rate
CHECK (commission_rate BETWEEN 0 AND 1);
GO

-- ===== cashback_rate =====
IF EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'C_cashback_rate'
      AND parent_object_id = OBJECT_ID('commission_cashback')
)
BEGIN
    ALTER TABLE commission_cashback
    DROP CONSTRAINT C_cashback_rate;
END;
GO

ALTER TABLE commission_cashback
ADD CONSTRAINT C_cashback_rate
CHECK (
    cashback_current BETWEEN 0 AND 1
    AND cashback_proposal BETWEEN 0 AND 1
);
GO


-- DATA MODEL

-- PK users
ALTER TABLE users
ADD CONSTRAINT PK_users PRIMARY KEY (user_id);

-- Check constraint users
ALTER TABLE users
ADD CONSTRAINT C_users_gender
CHECK (gender IN ('Male', 'Female'));

ALTER TABLE users
ADD CONSTRAINT C_users_location
CHECK (location IN ('HCMC', 'HN', 'Other'));
GO

-- PK transactions
ALTER TABLE transactions
ADD CONSTRAINT PK_transactions PRIMARY KEY (order_id);
GO

-- FK transactions ? users
ALTER TABLE transactions
ADD CONSTRAINT FK_transactions_users
FOREIGN KEY (user_id)
REFERENCES users (user_id);
GO

-- FK transactions ? commission_cashback
ALTER TABLE transactions
ADD CONSTRAINT FK_transactions_commission_cashback
FOREIGN KEY (merchant_id)
REFERENCES commission_cashback (merchant_id);
GO

-- Check purchase_status
ALTER TABLE transactions
ADD CONSTRAINT C_transactions_status
CHECK (purchase_status IN (0, 1));
GO

-- 5. STORED PROCEDURE – NEW CUSTOMER PER MONTH

CREATE PROCEDURE usp_new_cus
    @month INT,
    @year INT
AS
BEGIN
    SELECT
        FORMAT(DATETRUNC(MONTH, first_tran_date), 'yyyy-MM') AS month_year,
        COUNT(*) AS new_customer
    FROM users
    WHERE
        MONTH(first_tran_date) = @month
        AND YEAR(first_tran_date) = @year
    GROUP BY FORMAT(DATETRUNC(MONTH, first_tran_date), 'yyyy-MM');
END;
GO

CREATE TABLE dbo.rfm (
    user_id        INT,
    monetary       FLOAT,
    recency        INT,
    frequency      INT,
    cluster        INT,
    cluster_name   NVARCHAR(50)
);
GO


--Import RFM result from k-means clustering in python into MSSQL SERVER
BULK INSERT dbo.rfm
FROM 'C:\Users\nguye\OneDrive\Máy tính\New folder (2)\Momo\rfm.csv'
WITH
(
        FORMAT='CSV',
        FIRSTROW=2
)
GO
--Create cluster_name column
IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'users'
      AND COLUMN_NAME = 'cluster_name'
)
BEGIN
    ALTER TABLE users
    ADD cluster_name NVARCHAR(50);
END;
GO

--Update the cluster_name column
UPDATE users
SET cluster_name = rfm.cluster_name
FROM rfm
WHERE users.user_id = rfm.user_id;
select * from users


