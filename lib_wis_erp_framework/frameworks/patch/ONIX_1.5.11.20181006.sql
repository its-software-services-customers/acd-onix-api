ALTER TABLE INVENTORY_TX ADD REASON_TYPE INTEGER;

ALTER TABLE CASH_ACCOUNT ADD OWNER_FLAG CHAR(1);
UPDATE CASH_ACCOUNT SET OWNER_FLAG = 'N';

ALTER TABLE CASH_DOC ADD INTERNAL_FLAG CHAR(1);
UPDATE CASH_DOC SET INTERNAL_FLAG = 'N';
UPDATE CASH_DOC SET INTERNAL_FLAG = 'Y';

ALTER TABLE ACCOUNT_DOC_PAYMENT ADD REFUND_STATUS INTEGER; /* 1=Pending Refund, 2=Refunded */
UPDATE ACCOUNT_DOC_PAYMENT SET REFUND_STATUS = 1;

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(23, 'OWNER_PAYMENT_TYPE_SET', 2, 1, '1,5', 'Payment type to represent for company owner separate by comman', '2018/10/15 00:00:00', '2018/10/15 00:00:00');

ALTER TABLE CASH_DOC ADD CHEQUE_ID INTEGER;
ALTER TABLE CASH_DOC ADD FOREIGN KEY(CHEQUE_ID) REFERENCES CHEQUE(CHEQUE_ID);

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(24, 'CHEQUE_APPROVE_IMMEDIATE_FLAG', 2, 1, 'Y', 'Y=Approve checque immediately when approving the document', '2018/10/23 00:00:00', '2018/10/23 00:00:00');

ALTER TABLE CASH_DOC ADD ACCOUNT_DOC_ID INTEGER;
ALTER TABLE CASH_DOC ADD FOREIGN KEY(ACCOUNT_DOC_ID) REFERENCES ACCOUNT_DOC(ACCOUNT_DOC_ID);

ALTER TABLE CASH_DOC ADD CASH_XFER_TYPE INTEGER;
UPDATE CASH_DOC SET CASH_XFER_TYPE = 1;

CREATE TABLE CASH_XFER_DETAIL
(
    CASH_XFER_DTL_ID                INTEGER NOT NULL PRIMARY KEY,
    CASH_DOC_ID                     INTEGER NOT NULL,
    ACT_DOC_PAYMENT_ID              INTEGER NOT NULL UNIQUE,

    CREATE_DATE CHAR(19)            NOT NULL,
    MODIFY_DATE CHAR(19)            NOT NULL,

    FOREIGN KEY(CASH_DOC_ID) REFERENCES CASH_DOC(CASH_DOC_ID)
);

CREATE SEQUENCE CASH_XFER_DETAIL_SEQ START 1;

ALTER TABLE CASH_XFER_DETAIL ADD FOREIGN KEY(ACT_DOC_PAYMENT_ID) REFERENCES ACCOUNT_DOC_PAYMENT(ACT_DOC_PAYMENT_ID);

ALTER TABLE ACCOUNT_DOC_PAYMENT DROP COLUMN REFUND_STATUS;

CREATE TABLE COMPANY_IMAGE
(
    COMPANY_IMAGE_ID                INTEGER NOT NULL PRIMARY KEY,
    COMPANY_ID                      INTEGER NOT NULL,
    IMAGE_TYPE                      INTEGER NOT NULL, /* 1=Logo, 2=Signature */
    IMAGE_NAME                      TEXT NOT NULL,

    CREATE_DATE CHAR(19)            NOT NULL,
    MODIFY_DATE CHAR(19)            NOT NULL,

    FOREIGN KEY(COMPANY_ID) REFERENCES COMPANY_PROFILE(COMPANY_ID)
);

CREATE SEQUENCE COMPANY_IMAGE_SEQ START 1;

ALTER TABLE EMPLOYEE ALTER COLUMN ADDRESS DROP NOT NULL;
ALTER TABLE EMPLOYEE ALTER COLUMN EMPLOYEE_TYPE DROP NOT NULL;
ALTER TABLE EMPLOYEE ALTER COLUMN EMPLOYEE_GROUP DROP NOT NULL;
ALTER TABLE EMPLOYEE ALTER COLUMN CATEGORY DROP NOT NULL;

ALTER TABLE EMPLOYEE ADD COLUMN EMPLOYEE_LASTNAME TEXT;
ALTER TABLE EMPLOYEE ADD COLUMN FINGERPRINT_CODE TEXT;
ALTER TABLE EMPLOYEE ADD COLUMN NAME_PREFIX INTEGER;
ALTER TABLE EMPLOYEE ADD COLUMN GENDER INTEGER;
ALTER TABLE EMPLOYEE ADD COLUMN EMPLOYEE_LASTNAME_ENG TEXT;
ALTER TABLE EMPLOYEE ADD COLUMN LINE_ID TEXT;
ALTER TABLE EMPLOYEE ADD COLUMN EMPLOYEE_POSITION INTEGER;
ALTER TABLE EMPLOYEE ADD COLUMN EMPLOYEE_DEPARTMENT INTEGER;

ALTER TABLE EMPLOYEE DROP CONSTRAINT EMPLOYEE_EMPLOYEE_TYPE_FKEY;

ALTER TABLE EMPLOYEE ADD COLUMN EMPLOYEE_PROFILE_IMAGE TEXT;
