CREATE TABLE PACKAGE
(
    PACKAGE_ID           INTEGER NOT NULL PRIMARY KEY,
    PACKAGE_NAME         TEXT UNIQUE,
    PACKAGE_DESC         TEXT UNIQUE,
    TIME_SPECIFIC_FLAG   CHAR(1) NOT NULL,
    ENABLE_FLAG          CHAR(1) NOT NULL,
    EFFECTIVE_DATE       CHAR(19) NOT NULL,
    EXPIRE_DATE          CHAR(19) NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL
);

CREATE SEQUENCE PACKAGE_SEQ START 1;

CREATE TABLE PACKAGE_PERIOD
(
    PACKAGE_PERIOD_ID    INTEGER NOT NULL PRIMARY KEY,
    PACKAGE_ID           INTEGER NOT NULL,
    DAY_OF_WEEK          INTEGER NOT NULL, /* 0=SUNDAY, 1=Monday ... */
    PERIOD_TYPE          INTEGER,
    FROM_HOUR1           CHAR(2),
    FROM_MINUTE1         CHAR(2),
    TO_HOUR1             CHAR(2),
    TO_MINUTE1           CHAR(2),
    FROM_HOUR2           CHAR(2),
    FROM_MINUTE2         CHAR(2),
    TO_HOUR2             CHAR(2),
    TO_MINUTE2           CHAR(2),

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(PACKAGE_ID) REFERENCES PACKAGE(PACKAGE_ID)

);

CREATE SEQUENCE PACKAGE_PERIOD_SEQ START 1;

/* Keep both price for item and service */

CREATE TABLE PACKAGE_PRICE
(
    PACKAGE_ITM_PRICE_ID INTEGER NOT NULL PRIMARY KEY,
    PACKAGE_ID           INTEGER NOT NULL,
    SERVICE_ID           INTEGER,
    ITEM_ID              INTEGER,
    CATEGORY_ID          INTEGER,
    PRODUCT_TYPE         INTEGER NOT NULL, /* 1=Service, 2=Item, 3=Item Category */
    ITEM_TYPE            INTEGER NOT NULL, /* not use */
    PRICING_DEFINITION   TEXT NOT NULL,
    PRICING_TYPE         INTEGER NOT NULL, /* not use */
    SEQUENCE_NO          INTEGER,
    LINEAR_UNIT_PRICE    NUMERIC(10, 2),

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(PACKAGE_ID) REFERENCES PACKAGE(PACKAGE_ID),
    FOREIGN KEY(SERVICE_ID) REFERENCES SERVICE(SERVICE_ID),
    FOREIGN KEY(ITEM_ID) REFERENCES ITEM(ITEM_ID),
    FOREIGN KEY(CATEGORY_ID) REFERENCES ITEM_CATEGORY(ITEM_CATEGORY_ID)
);

CREATE SEQUENCE PACKAGE_PRICE_SEQ START 1;

CREATE SEQUENCE SERVICE_SEQ START 1;

ALTER TABLE PACKAGE DROP COLUMN PACKAGE_NAME;
ALTER TABLE PACKAGE DROP COLUMN PACKAGE_DESC;

ALTER TABLE PACKAGE ADD COLUMN PACKAGE_CODE TEXT NOT NULL UNIQUE;
ALTER TABLE PACKAGE ADD COLUMN PACKAGE_NAME TEXT;

ALTER TABLE PACKAGE_PERIOD ADD COLUMN ENABLE_FLAG CHAR(1);

CREATE TABLE CUSTOMER_PACKAGE
(
    CUSTOMER_PACKAGE_ID  INTEGER NOT NULL PRIMARY KEY,
    ENTITY_ID            INTEGER NOT NULL,
    PACKAGE_ID           INTEGER NOT NULL,
    SEQUENCE_NO          INTEGER NOT NULL,
    ENABLE_FLAG          CHAR(1) NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(ENTITY_ID) REFERENCES ENTITY(ENTITY_ID),
    FOREIGN KEY(PACKAGE_ID) REFERENCES PACKAGE(PACKAGE_ID)
);

CREATE SEQUENCE COMPANY_PROFILE_SEQ START 1;

CREATE SEQUENCE DEBUG1_SEQ START 1;

ALTER TABLE PACKAGE ADD COLUMN PACKAGE_TYPE INTEGER;

UPDATE PACKAGE SET PACKAGE_TYPE = 1;

ALTER TABLE ITEM ADD COLUMN META_PRICING_DESC TEXT;
ALTER TABLE ITEM ADD COLUMN META_SALE_PRICE TEXT;
ALTER TABLE ITEM ADD COLUMN META_CURRENT_QTY TEXT;
ALTER TABLE ITEM ADD COLUMN META_LAST_BUY_PRICE TEXT;

CREATE TABLE PACKAGE_CUSTOMER
(
    PACKAGE_CUSTOMER_ID  INTEGER NOT NULL PRIMARY KEY,
    PACKAGE_ID           INTEGER NOT NULL,
    ENTITY_ID            INTEGER,
    CUSTOMER_TYPE        INTEGER,
    CUSTOMER_GROUP       INTEGER,
    ENABLE_FLAG          CHAR(1) NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(PACKAGE_ID) REFERENCES PACKAGE(PACKAGE_ID),
    FOREIGN KEY(ENTITY_ID) REFERENCES ENTITY(ENTITY_ID),
    FOREIGN KEY(CUSTOMER_TYPE) REFERENCES MASTER_REF(MASTER_ID),
    FOREIGN KEY(CUSTOMER_GROUP) REFERENCES MASTER_REF(MASTER_ID)
);

ALTER TABLE PACKAGE ADD COLUMN CUSTOMER_SPECIFIC_FLAG CHAR(1);
UPDATE PACKAGE SET CUSTOMER_SPECIFIC_FLAG = 'Y';

CREATE TABLE COMPANY_PACKAGE
(
    COMPANY_PACKAGE_ID   INTEGER NOT NULL PRIMARY KEY,
    COMPANY_ID           INTEGER, /* Always set to 1 */
    PACKAGE_ID           INTEGER NOT NULL,
    SEQUENCE_NO          INTEGER NOT NULL,
    ENABLE_FLAG          CHAR(1) NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(PACKAGE_ID) REFERENCES PACKAGE(PACKAGE_ID)
);

CREATE SEQUENCE PACKAGE_CUSTOMER_SEQ START 1;
CREATE SEQUENCE COMPANY_PACKAGE_SEQ START 1;
CREATE SEQUENCE CUSTOMER_PACKAGE_SEQ START 1;

CREATE TABLE PACKAGE_DISCOUNT
(
    PACKAGE_DISCOUNT_ID  INTEGER NOT NULL PRIMARY KEY,
    PACKAGE_ID           INTEGER NOT NULL,
    SERVICE_ID           INTEGER,
    ITEM_ID              INTEGER,
    ITEM_CATEGORY        INTEGER,
    ENABLE_FLAG          CHAR(1) NOT NULL,
    DISCOUNT_VALUE       NUMERIC(10, 2),
    DISCOUNT_TYPE        INTEGER, /* 1=Percent, 2=Amount */

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(PACKAGE_ID) REFERENCES PACKAGE(PACKAGE_ID),
    FOREIGN KEY(SERVICE_ID) REFERENCES SERVICE(SERVICE_ID),
    FOREIGN KEY(ITEM_ID) REFERENCES ITEM(ITEM_ID),
    FOREIGN KEY(ITEM_CATEGORY) REFERENCES ITEM_CATEGORY(ITEM_CATEGORY_ID)
);

CREATE SEQUENCE PACKAGE_DISCOUNT_SEQ START 1;

/* 1=Type, 2=Group, 3=Customer */
ALTER TABLE PACKAGE_CUSTOMER ADD COLUMN SELECTION_TYPE INTEGER NOT NULL;

/* 1=service, 2=item, 3=item group */
ALTER TABLE PACKAGE_DISCOUNT ADD COLUMN SELECTION_TYPE INTEGER NOT NULL;

CREATE TABLE PACKAGE_BONUS
(
    PACKAGE_BONUS_ID     INTEGER NOT NULL PRIMARY KEY,
    PACKAGE_ID           INTEGER NOT NULL,
    SERVICE_ID           INTEGER,
    ITEM_ID              INTEGER,
    ITEM_CATEGORY        INTEGER,
    ENABLE_FLAG          CHAR(1) NOT NULL,
    QUANTITY             INTEGER NOT NULL,
    SELECTION_TYPE       INTEGER NOT NULL, /* 1=service, 2=item, 3=item group */
    QUANTITY_TYPE        INTEGER, /* 1=Buy, 2=Free/Get */

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(PACKAGE_ID) REFERENCES PACKAGE(PACKAGE_ID),
    FOREIGN KEY(SERVICE_ID) REFERENCES SERVICE(SERVICE_ID),
    FOREIGN KEY(ITEM_ID) REFERENCES ITEM(ITEM_ID),
    FOREIGN KEY(ITEM_CATEGORY) REFERENCES ITEM_CATEGORY(ITEM_CATEGORY_ID)
);

CREATE SEQUENCE PACKAGE_BONUS_SEQ START 1;

CREATE TABLE VOUCHER_TEMPLATE
(
    VOUCHER_TEMPLATE_ID   INTEGER NOT NULL PRIMARY KEY,
    VC_TEMPLATE_NO        TEXT UNIQUE NOT NULL,
    VC_TEMPLATE_NNAME     TEXT NOT NULL,
    ENABLE_FLAG           CHAR(1) NOT NULL,
    AMOUNT                NUMERIC(10, 2) NOT NULL,
    QUANTITY              INTEGER NOT NULL,
    EFFECTIVE_DATE        CHAR(19) NOT NULL,
    EXPIRE_DATE           CHAR(19) NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL
);

CREATE SEQUENCE VOUCHER_TEMPLATE_SEQ START 1;

CREATE TABLE CASH_ACCOUNT
(
    CASH_ACCOUNT_ID       INTEGER NOT NULL PRIMARY KEY,
    ACCOUNT_NO            TEXT UNIQUE NOT NULL,
    ACCOUNT_NNAME         TEXT NOT NULL,
    BANK_ID               INTEGER,
    BANK_BRANCH_NAME      TEXT,
    NOTE                  TEXT,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(BANK_ID) REFERENCES MASTER_REF(MASTER_ID)
);

CREATE SEQUENCE CASH_ACCOUNT_SEQ START 1;

ALTER TABLE CASH_ACCOUNT ADD COLUMN TOTAL_AMOUNT NUMERIC(10, 2) NOT NULL;


/* Similar to PACKAGE_BONUS */

CREATE TABLE PACKAGE_VOUCHER
(
    PACKAGE_VOUCHER_ID   INTEGER NOT NULL PRIMARY KEY,
    PACKAGE_ID           INTEGER NOT NULL,
    SERVICE_ID           INTEGER,
    ITEM_ID              INTEGER,
    ITEM_CATEGORY        INTEGER,
    ENABLE_FLAG          CHAR(1) NOT NULL,
    QUANTITY             INTEGER NOT NULL,
    SELECTION_TYPE       INTEGER NOT NULL, /* 1=service, 2=item, 3=voucher, 4=free text */
    QUANTITY_TYPE        INTEGER, /* 1=Buy, 2=Voucher-Get */
    VOUCHER_TEMPLATE_ID  INTEGER,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(PACKAGE_ID) REFERENCES PACKAGE(PACKAGE_ID),
    FOREIGN KEY(SERVICE_ID) REFERENCES SERVICE(SERVICE_ID),
    FOREIGN KEY(ITEM_ID) REFERENCES ITEM(ITEM_ID),
    FOREIGN KEY(ITEM_CATEGORY) REFERENCES ITEM_CATEGORY(ITEM_CATEGORY_ID),
    FOREIGN KEY(VOUCHER_TEMPLATE_ID) REFERENCES VOUCHER_TEMPLATE(VOUCHER_TEMPLATE_ID)
);

CREATE SEQUENCE PACKAGE_VOUCHER_SEQ START 1;


CREATE TABLE CASH_DOC
(
    CASH_DOC_ID          INTEGER NOT NULL PRIMARY KEY,
    DOCUMENT_NO          INTEGER NOT NULL,
    DOCUMENT_DATE        INTEGER NOT NULL,
    DOCUMENT_TYPE        INTEGER NOT NULL, /* 1=Cash In, 2=Cash OUt, 3=Cash XFer */
    DOCUMENT_STATUS      INTEGER NOT NULL, /* 1=Pending, 2=Approved */
    APPROVED_DATE        CHAR(19),
    APPROVED_SEQ         INTEGER,
    CASH_ACCOUNT_ID1     INTEGER, /* From */
    CASH_ACCOUNT_ID2     INTEGER, /* To */
    NOTE                 TEXT,
    TOTAL_AMOUNT         NUMERIC(10, 2) NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(CASH_ACCOUNT_ID1) REFERENCES CASH_ACCOUNT(CASH_ACCOUNT_ID),
    FOREIGN KEY(CASH_ACCOUNT_ID2) REFERENCES CASH_ACCOUNT(CASH_ACCOUNT_ID)
);

CREATE SEQUENCE CASH_DOC_SEQ START 1;
CREATE SEQUENCE CASH_DOC_APPROVED_SEQ START 1;


CREATE TABLE CASH_TX
(
    CASH_TX_ID           INTEGER NOT NULL PRIMARY KEY,
    CASH_DOC_ID          INTEGER NOT NULL,
    CASH_ACCOUNT_ID      INTEGER NOT NULL,
    TX_TYPE              CHAR(1) NOT NULL, /* I,E */
    TX_AMOUNT            NUMERIC(10, 2) NOT NULL,
    BEGIN_AMOUNT         NUMERIC(10, 2),
    END_AMOUNT           NUMERIC(10, 2),

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(CASH_DOC_ID) REFERENCES CASH_DOC(CASH_DOC_ID),
    FOREIGN KEY(CASH_ACCOUNT_ID) REFERENCES CASH_ACCOUNT(CASH_ACCOUNT_ID)
);

CREATE SEQUENCE CASH_TX_SEQ START 1;

ALTER TABLE CASH_ACCOUNT DROP COLUMN TOTAL_AMOUNT;
ALTER TABLE CASH_ACCOUNT ADD COLUMN TOTAL_AMOUNT NUMERIC(10, 2);

ALTER TABLE CASH_DOC DROP COLUMN DOCUMENT_DATE;
ALTER TABLE CASH_DOC ADD COLUMN DOCUMENT_DATE CHAR(19) NOT NULL;

ALTER TABLE CASH_DOC DROP COLUMN DOCUMENT_NO;
ALTER TABLE CASH_DOC ADD COLUMN DOCUMENT_NO TEXT NOT NULL UNIQUE;

CREATE TABLE COMPANY_PACKAGE_SELECTED
(
    COMPANY_PKGSEL_ID    INTEGER NOT NULL PRIMARY KEY,
    COMPANY_ID           INTEGER NOT NULL,  /* Always set to 1 */
    PACKAGE_TYPE         INTEGER NOT NULL,
    ENABLE_FLAG          CHAR(1) NOT NULL,
    SEQUENCE_NO          INTEGER NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL
);

INSERT INTO COMPANY_PACKAGE_SELECTED (COMPANY_PKGSEL_ID, COMPANY_ID, PACKAGE_TYPE, ENABLE_FLAG, SEQUENCE_NO, CREATE_DATE, MODIFY_DATE)
VALUES (1, 1, 1, 'Y', 1, '2017/07/07 02:02:34', '2017/07/07 02:02:34');

INSERT INTO COMPANY_PACKAGE_SELECTED (COMPANY_PKGSEL_ID, COMPANY_ID, PACKAGE_TYPE, ENABLE_FLAG, SEQUENCE_NO, CREATE_DATE, MODIFY_DATE)
VALUES (2, 1, 2, 'Y', 2, '2017/07/07 02:02:34', '2017/07/07 02:02:34');

INSERT INTO COMPANY_PACKAGE_SELECTED (COMPANY_PKGSEL_ID, COMPANY_ID, PACKAGE_TYPE, ENABLE_FLAG, SEQUENCE_NO, CREATE_DATE, MODIFY_DATE)
VALUES (3, 1, 3, 'Y', 3, '2017/07/07 02:02:34', '2017/07/07 02:02:34');

INSERT INTO COMPANY_PACKAGE_SELECTED (COMPANY_PKGSEL_ID, COMPANY_ID, PACKAGE_TYPE, ENABLE_FLAG, SEQUENCE_NO, CREATE_DATE, MODIFY_DATE)
VALUES (4, 1, 4, 'Y', 4, '2017/07/07 02:02:34', '2017/07/07 02:02:34');

CREATE TABLE CASH_BALANCE
(
    CASH_BALANCE_ID      INTEGER NOT NULL PRIMARY KEY,
    BALANCE_LEVEL        INTEGER NOT NULL,  /* 1=Golbally, 2=Daily */
    BALANCE_DATE         CHAR(19) NOT NULL,
    CASH_ACCOUNT_ID      INTEGER NOT NULL,
    BEGIN_AMOUNT         NUMERIC(10, 2) NOT NULL,
    IN_AMOUNT            NUMERIC(10, 2) NOT NULL,
    OUT_AMOUNT           NUMERIC(10, 2) NOT NULL,
    END_AMOUNT           NUMERIC(10, 2) NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(CASH_ACCOUNT_ID) REFERENCES CASH_ACCOUNT(CASH_ACCOUNT_ID)
);

CREATE SEQUENCE CASH_BALANCE_SEQ START 1;

CREATE SEQUENCE USER_GROUP_SEQ START 100;


CREATE TABLE BILL_SIMULATE
(
    BILL_SIMULATE_ID     INTEGER NOT NULL PRIMARY KEY,
    DOCUMENT_NO          TEXT NOT NULL UNIQUE,
    DOCUMENT_DATE        CHAR(19) NOT NULL,
    DOCUMENT_TYPE        INTEGER, /* hard code to 1 */
    DOCUMENT_STATUS      INTEGER NOT NULL, /* hard code to 1 */
    CUSTOMER_ID          INTEGER NOT NULL,
    SIMULATE_TIME        CHAR(19) NOT NULL, /* HH:MM:SS */
    NOTE                 TEXT,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(CUSTOMER_ID) REFERENCES ENTITY(ENTITY_ID)
);

CREATE SEQUENCE BILL_SIMULATE_SEQ START 1;

CREATE TABLE BILL_SIM_ITEM
(
    BILL_SIM_ITEM_ID     INTEGER NOT NULL PRIMARY KEY,
    BILL_SIMULATE_ID     INTEGER NOT NULL,
    SERVICE_ID           INTEGER,
    ITEM_ID              INTEGER,
    QUANTITY             NUMERIC(10, 2) NOT NULL,
    SELECTION_TYPE       INTEGER NOT NULL, /* 1=service, 2=item */

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(BILL_SIMULATE_ID) REFERENCES BILL_SIMULATE(BILL_SIMULATE_ID),
    FOREIGN KEY(SERVICE_ID) REFERENCES SERVICE(SERVICE_ID),
    FOREIGN KEY(ITEM_ID) REFERENCES ITEM(ITEM_ID)
);

CREATE SEQUENCE BILL_SIM_ITEM_SEQ START 1;


DROP TABLE COMPANY_PACKAGE_SELECTED;

CREATE TABLE PACKAGE_TYPE_MAP
(
    PACKAGE_TYPE         INTEGER NOT NULL UNIQUE,
    PACKAGE_GROUP        INTEGER NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL
);

/* Pricing : Pricing */
INSERT INTO PACKAGE_TYPE_MAP (PACKAGE_TYPE, PACKAGE_GROUP, CREATE_DATE, MODIFY_DATE)
VALUES (1, 2, '2017/07/07 02:02:34', '2017/07/07 02:02:34');

/* Bonus : Grouping */
INSERT INTO PACKAGE_TYPE_MAP (PACKAGE_TYPE, PACKAGE_GROUP, CREATE_DATE, MODIFY_DATE)
VALUES (2, 1, '2017/07/07 02:02:34', '2017/07/07 02:02:34');

/* Discount : Discount */
INSERT INTO PACKAGE_TYPE_MAP (PACKAGE_TYPE, PACKAGE_GROUP, CREATE_DATE, MODIFY_DATE)
VALUES (3, 3, '2017/07/07 02:02:34', '2017/07/07 02:02:34');

/* Voucher : Grouping */
INSERT INTO PACKAGE_TYPE_MAP (PACKAGE_TYPE, PACKAGE_GROUP, CREATE_DATE, MODIFY_DATE)
VALUES (4, 1, '2017/07/07 02:02:34', '2017/07/07 02:02:34');

ALTER TABLE PACKAGE_PRICE ADD COLUMN ENABLE_FLAG CHAR(1);

ALTER TABLE PACKAGE_DISCOUNT ADD COLUMN PRICING_DEFINITION TEXT;

ALTER TABLE PACKAGE ADD COLUMN DISCOUNT_MAP_TYPE INTEGER;

ALTER TABLE PACKAGE_VOUCHER ADD COLUMN FREE_TEXT TEXT;

CREATE TABLE PACKAGE_BUNDLE
(
    PACKAGE_BUNDLE_ID    INTEGER NOT NULL PRIMARY KEY,
    PACKAGE_ID           INTEGER NOT NULL,
    SERVICE_ID           INTEGER,
    ITEM_ID              INTEGER,
    ITEM_CATEGORY        INTEGER, /* Not used */
    ENABLE_FLAG          CHAR(1) NOT NULL,
    QUANTITY             INTEGER NOT NULL,
    SELECTION_TYPE       INTEGER NOT NULL, /* 1=service, 2=item, 3=item group */

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(PACKAGE_ID) REFERENCES PACKAGE(PACKAGE_ID),
    FOREIGN KEY(SERVICE_ID) REFERENCES SERVICE(SERVICE_ID),
    FOREIGN KEY(ITEM_ID) REFERENCES ITEM(ITEM_ID),
    FOREIGN KEY(ITEM_CATEGORY) REFERENCES ITEM_CATEGORY(ITEM_CATEGORY_ID)
);

CREATE SEQUENCE PACKAGE_BUNDLE_SEQ START 1;

ALTER TABLE PACKAGE ADD COLUMN BUNDLE_AMOUNT NUMERIC(10, 2);

/* Bundle : Grouping */
INSERT INTO PACKAGE_TYPE_MAP (PACKAGE_TYPE, PACKAGE_GROUP, CREATE_DATE, MODIFY_DATE)
VALUES (5, 1, '2017/07/26 02:02:34', '2017/07/26 02:02:34');

ALTER TABLE BILL_SIM_ITEM ADD COLUMN ENABLE_FLAG CHAR(1);

ALTER TABLE ITEM ADD COLUMN PRICING_DEFINITION TEXT;
ALTER TABLE ITEM ADD COLUMN DEFAULT_SELL_PRICE NUMERIC(10, 2);

ALTER TABLE PACKAGE ADD COLUMN DISCOUNT_BASKET_TYPE INTEGER;

ALTER TABLE PACKAGE ADD COLUMN PRODUCT_SPECIFIC_FLAG CHAR(1);

ALTER TABLE PACKAGE ADD COLUMN DISCOUNT_DEFINITION TEXT;

/* Final Discount : Final Discount */
INSERT INTO PACKAGE_TYPE_MAP (PACKAGE_TYPE, PACKAGE_GROUP, CREATE_DATE, MODIFY_DATE)
VALUES (6, 4, '2017/07/30 02:02:34', '2017/07/30 02:02:34');

CREATE TABLE PACKAGE_FINAL_DISCOUNT
(
    PACKAGE_FNLDISC_ID   INTEGER NOT NULL PRIMARY KEY,
    PACKAGE_ID           INTEGER NOT NULL,
    SERVICE_ID           INTEGER,
    ITEM_ID              INTEGER,
    ITEM_CATEGORY        INTEGER, /* Not used */
    ENABLE_FLAG          CHAR(1) NOT NULL,
    QUANTITY             INTEGER NOT NULL,
    SELECTION_TYPE       INTEGER NOT NULL, /* 1=service, 2=item, 3=item group */

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(PACKAGE_ID) REFERENCES PACKAGE(PACKAGE_ID),
    FOREIGN KEY(SERVICE_ID) REFERENCES SERVICE(SERVICE_ID),
    FOREIGN KEY(ITEM_ID) REFERENCES ITEM(ITEM_ID),
    FOREIGN KEY(ITEM_CATEGORY) REFERENCES ITEM_CATEGORY(ITEM_CATEGORY_ID)
);

CREATE SEQUENCE PACKAGE_FINAL_DISCOUNT_SEQ START 1;

ALTER TABLE SERVICE ADD COLUMN WH_TAX_FLAG CHAR(1);
ALTER TABLE SERVICE ADD COLUMN WH_TAX_PCT NUMERIC(10, 2);
ALTER TABLE SERVICE ADD COLUMN PRICING_DEFINITION TEXT;




CREATE TABLE ACCOUNT_DOC
(
    ACCOUNT_DOC_ID       INTEGER NOT NULL PRIMARY KEY,
    DOCUMENT_DATE        CHAR(19) NOT NULL,
    DOCUMENT_NO          TEXT NOT NULL UNIQUE,
    DOCUMENT_DESC        TEXT,
    ENTITY_ID            INTEGER NOT NULL,
    LOCATION_ID          INTEGER NOT NULL,
    BRANCH_ID            INTEGER,
    ACCOUNT_SIDE         INTEGER NOT NULL, /* 1=AR, 2=AP */
    DOCUMENT_TYPE        INTEGER NOT NULL, /* 1=Sell by cash, 2=Sell by debt */
    DOCUMENT_STATUS      INTEGER NOT NULL, /* 1=Pending, 2=Approved */
    FINAL_DISCOUNT_AMT   NUMERIC(10, 2),
    ITEM_DISCOUNT_AMT    NUMERIC(10, 2), /* Summation of item discounts */
    VAT_PCT              NUMERIC(10, 2),
    VAT_AMT              NUMERIC(10, 2),
    WH_TAX_AMT           NUMERIC(10, 2),
    PAYMENT_TYPE         INTEGER, /* 1=Cash, 2=Cash Xfer, 3=Credit Card */
    INVENTORY_DOC_ID     INTEGER,
    CASH_DOC_ID          INTEGER,
    AR_TX_TYPE           CHAR(1), /* I and E */
    AR_TX_AMOUNT         NUMERIC(10, 2),
    AR_BEGIN_AMOUNT      NUMERIC(10, 2),
    AR_END_AMOUNT        NUMERIC(10, 2),
    CASH_ACCOUNT_ID      INTEGER,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(ENTITY_ID) REFERENCES ENTITY(ENTITY_ID),
    FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION(LOCATION_ID),
    FOREIGN KEY(BRANCH_ID) REFERENCES MASTER_REF(MASTER_ID),
    FOREIGN KEY(INVENTORY_DOC_ID) REFERENCES INVENTORY_DOC(DOC_ID),
    FOREIGN KEY(CASH_DOC_ID) REFERENCES CASH_DOC(CASH_DOC_ID),
    FOREIGN KEY(CASH_ACCOUNT_ID) REFERENCES CASH_ACCOUNT(CASH_ACCOUNT_ID)
);

CREATE SEQUENCE ACCOUNT_DOC_SEQ START 1;

CREATE TABLE ACCOUNT_DOC_ITEM
(
    ACCOUNT_DOC_ITEM_ID  INTEGER NOT NULL PRIMARY KEY,
    ACCOUNT_DOC_ID       INTEGER NOT NULL,
    SELECTION_TYPE       INTEGER, /* 1=Service, 2=Item */
    SERVICE_ID           INTEGER,
    ITEM_ID              INTEGER,
    QUANTITY             NUMERIC(10, 2),
    UNIT_PRICE           NUMERIC(10, 2),
    AMOUNT               NUMERIC(10, 2),
    DISCOUNT_AMT         NUMERIC(10, 2),
    WH_TAX_FLAG          CHAR(1),
    WH_TAX_PCT           NUMERIC(10, 2),
    WH_TAX_AMT           NUMERIC(10, 2),
    TOTAL_AMT            NUMERIC(10, 2), /* Amount - Discount */

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(ACCOUNT_DOC_ID) REFERENCES ACCOUNT_DOC(ACCOUNT_DOC_ID),
    FOREIGN KEY(ITEM_ID) REFERENCES ITEM(ITEM_ID),
    FOREIGN KEY(SERVICE_ID) REFERENCES SERVICE(SERVICE_ID)
);

CREATE SEQUENCE ACCOUNT_DOC_ITEM_SEQ START 1;

ALTER TABLE PACKAGE ADD COLUMN BRANCH_SPECIFIC_FLAG CHAR(1);

CREATE TABLE PACKAGE_BRANCH
(
    PACKAGE_BRANCH_ID    INTEGER NOT NULL PRIMARY KEY,
    PACKAGE_ID           INTEGER NOT NULL,
    BRANCH_ID            INTEGER NOT NULL,
    ENABLE_FLAG          CHAR(1) NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(PACKAGE_ID) REFERENCES PACKAGE(PACKAGE_ID)
);

CREATE SEQUENCE PACKAGE_BRANCH_SEQ START 1;

ALTER TABLE BILL_SIMULATE ADD COLUMN BRANCH_ID INTEGER;

ALTER TABLE PACKAGE ADD COLUMN DISCOUNT_BASKET_TYPE_CONFIG TEXT;

/* Post Gift : Post Gift */
INSERT INTO PACKAGE_TYPE_MAP (PACKAGE_TYPE, PACKAGE_GROUP, CREATE_DATE, MODIFY_DATE)
VALUES (7, 5, '2017/08/07 02:02:34', '2017/08/07 02:02:34');

ALTER TABLE DOCUMENT_NUMBER ADD COLUMN PARENT_ID INTEGER;
ALTER TABLE DOCUMENT_NUMBER ADD COLUMN GROUP_ID INTEGER;

UPDATE DOCUMENT_NUMBER SET PARENT_ID=1, GROUP_ID=1;

INSERT INTO DOCUMENT_NUMBER
(DOCUMENT_NUMBER_ID, DOC_TYPE, LAST_RUN_YEAR, LAST_RUN_MONTH, FORMULA, RESET_CRITERIA, CURRENT_SEQ, START_SEQ, SEQ_LENGTH, YEAR_OFFSET, CREATE_DATE, MODIFY_DATE, PARENT_ID, GROUP_ID)
VALUES
(9, 'ACCOUNT_DOC_CASH_TEMP', 2017, 8, '*ADC-${yyyy}-${seq}', 2, 0, 1, 5, 0, '2017/08/09 00:00:00', '2017/08/09 00:00:00', 1, 1);

INSERT INTO DOCUMENT_NUMBER
(DOCUMENT_NUMBER_ID, DOC_TYPE, LAST_RUN_YEAR, LAST_RUN_MONTH, FORMULA, RESET_CRITERIA, CURRENT_SEQ, START_SEQ, SEQ_LENGTH, YEAR_OFFSET, CREATE_DATE, MODIFY_DATE, PARENT_ID, GROUP_ID)
VALUES
(10, 'ACCOUNT_DOC_CASH_APPROVED', 2017, 8, 'ADC-${yyyy}-${seq}', 2, 0, 1, 5, 0, '2017/08/09 00:00:00', '2017/08/09 00:00:00', 1, 1);

INSERT INTO DOCUMENT_NUMBER
(DOCUMENT_NUMBER_ID, DOC_TYPE, LAST_RUN_YEAR, LAST_RUN_MONTH, FORMULA, RESET_CRITERIA, CURRENT_SEQ, START_SEQ, SEQ_LENGTH, YEAR_OFFSET, CREATE_DATE, MODIFY_DATE, PARENT_ID, GROUP_ID)
VALUES
(11, 'ACCOUNT_DOC_DEPT_TEMP', 2017, 8, '*ADD-${yyyy}-${seq}', 2, 0, 1, 5, 0, '2017/08/09 00:00:00', '2017/08/09 00:00:00', 1, 1);

INSERT INTO DOCUMENT_NUMBER
(DOCUMENT_NUMBER_ID, DOC_TYPE, LAST_RUN_YEAR, LAST_RUN_MONTH, FORMULA, RESET_CRITERIA, CURRENT_SEQ, START_SEQ, SEQ_LENGTH, YEAR_OFFSET, CREATE_DATE, MODIFY_DATE, PARENT_ID, GROUP_ID)
VALUES
(12, 'ACCOUNT_DOC_DEPT_APPROVED', 2017, 8, 'ADD-${yyyy}-${seq}', 2, 0, 1, 5, 0, '2017/08/09 00:00:00', '2017/08/09 00:00:00', 1, 1);



CREATE TABLE PACKAGE_TRAY_PRICE
(
    PACKAGE_TRAY_PRICE_ID INTEGER NOT NULL PRIMARY KEY,
    PACKAGE_ID           INTEGER NOT NULL,
    SERVICE_ID           INTEGER,
    ITEM_ID              INTEGER,
    CATEGORY_ID          INTEGER,
    PRODUCT_TYPE         INTEGER NOT NULL, /* 1=Service, 2=Item, 3=Item Category */
    ITEM_TYPE            INTEGER NOT NULL, /* not use */
    PRICING_DEFINITION   TEXT NOT NULL,
    DISCOUNT_DEFINITION  TEXT NOT NULL,
    PRICING_TYPE         INTEGER NOT NULL, /* not use */
    SEQUENCE_NO          INTEGER,
    LINEAR_UNIT_PRICE    NUMERIC(10, 2),

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(PACKAGE_ID) REFERENCES PACKAGE(PACKAGE_ID),
    FOREIGN KEY(SERVICE_ID) REFERENCES SERVICE(SERVICE_ID),
    FOREIGN KEY(ITEM_ID) REFERENCES ITEM(ITEM_ID),
    FOREIGN KEY(CATEGORY_ID) REFERENCES ITEM_CATEGORY(ITEM_CATEGORY_ID)
);

CREATE SEQUENCE PACKAGE_TRAY_PRICE_SEQ START 1;

ALTER TABLE PACKAGE ADD COLUMN TRAY_NAME TEXT;

ALTER TABLE PACKAGE_TRAY_PRICE ADD COLUMN ENABLE_FLAG CHAR(1);

/* Tray Price-Discount : Tray Price */
INSERT INTO PACKAGE_TYPE_MAP (PACKAGE_TYPE, PACKAGE_GROUP, CREATE_DATE, MODIFY_DATE)
VALUES (8, 6, '2017/08/15 02:02:34', '2017/08/15 02:02:34');

ALTER TABLE PACKAGE_TRAY_PRICE ADD COLUMN STD_PRICE_FLAG CHAR(1);


ALTER TABLE BILL_SIM_ITEM ADD COLUMN TRAY_FLAG CHAR(1);
UPDATE BILL_SIM_ITEM SET TRAY_FLAG = 'N' WHERE TRAY_FLAG IS NULL;

CREATE TABLE EMPLOYEE
(
    EMPLOYEE_ID     INTEGER NOT NULL PRIMARY KEY,
    EMPLOYEE_CODE   TEXT NOT NULL UNIQUE,
    EMPLOYEE_NAME   TEXT NOT NULL,
    ADDRESS         TEXT NOT NULL,
    EMAIL           TEXT,
    WEBSITE         TEXT,
    PHONE           TEXT,
    FAX             TEXT,
    EMPLOYEE_TYPE   INTEGER NOT NULL, 
    EMPLOYEE_GROUP  INTEGER NOT NULL,
    CATEGORY        INTEGER NOT NULL, /* 1=NameGeneral, 2=Salesman */
    NOTE            TEXT,


    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(EMPLOYEE_TYPE) REFERENCES MASTER_REF(MASTER_ID), 
    FOREIGN KEY(EMPLOYEE_GROUP) REFERENCES MASTER_REF(MASTER_ID)
);

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN DISCOUNT TEXT;
ALTER TABLE ACCOUNT_DOC ADD COLUMN FINAL_DISCOUNT TEXT;

CREATE SEQUENCE EMPLOYEE_SEQ START 1;

/* Tray Bonus : Tray Group */
INSERT INTO PACKAGE_TYPE_MAP (PACKAGE_TYPE, PACKAGE_GROUP, CREATE_DATE, MODIFY_DATE)
VALUES (9, 7, '2017/08/17 02:02:34', '2017/08/17 02:02:34');

/* Tray Bundle : Tray Group */
INSERT INTO PACKAGE_TYPE_MAP (PACKAGE_TYPE, PACKAGE_GROUP, CREATE_DATE, MODIFY_DATE)
VALUES (10, 7, '2017/08/17 02:02:34', '2017/08/17 02:02:34');


ALTER TABLE ACCOUNT_DOC ADD COLUMN EMPLOYEE_ID INTEGER NOT NULL;
ALTER TABLE ACCOUNT_DOC ADD FOREIGN KEY(EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID);
