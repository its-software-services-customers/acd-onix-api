CREATE TABLE COMMISSION_PROFILE
(
    COMMISSION_PROF_ID        INTEGER NOT NULL PRIMARY KEY,
    PROFILE_CODE              TEXT NOT NULL UNIQUE,
    PROFILE_DESC              TEXT,    
    ENABLE_FLAG               CHAR(1) NOT NULL,
    EFFECTIVE_DATE            CHAR(19) NOT NULL,
    EXPIRE_DATE               CHAR(19) NOT NULL,    
    PROFILE_TYPE              INTEGER NOT NULL, /* 1=ByItem, 2=ByGroup */
    EMPLOYEE_SPECIFIC_FLAG    CHAR(1) NOT NULL,    
    COMMISSION_DEFINITION     TEXT,
    
    CREATE_DATE CHAR(19)      NOT NULL,
    MODIFY_DATE CHAR(19)      NOT NULL
);

CREATE SEQUENCE COMMISSION_PROFILE_SEQ START 1;

CREATE TABLE COMMISSION_PROF_DETAIL
(
    COMMISSION_PDETL_ID       INTEGER NOT NULL PRIMARY KEY,
    COMMISSION_PROF_ID        INTEGER NOT NULL,    
    SELECTION_TYPE            INTEGER NOT NULL, /* 1=Srvice, 2=ITem, 3=ItemCategory */
    ENABLE_FLAG               CHAR(1) NOT NULL,
    LOOKUP_TYPE               INTEGER NOT NULL, /* 1=BySaleUnitPrice, 2=ByQuantity */
    COMM_DEFINITION           TEXT,
         
    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL
);

CREATE SEQUENCE COMMISSION_PROF_DETAIL_SEQ START 1;

ALTER TABLE COMMISSION_PROF_DETAIL ADD FOREIGN KEY (COMMISSION_PROF_ID) REFERENCES COMMISSION_PROFILE(COMMISSION_PROF_ID);

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN IS_VOUCH_FLAG CHAR(1);
ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN IS_TRAY_FLAG CHAR(1);

CREATE TABLE COMPANY_COMM_PROFILE
(
    COMPANY_COMMPROF_ID  INTEGER NOT NULL PRIMARY KEY,
    COMPANY_ID           INTEGER, /* Always set to 1 */
    COMMISSION_PROF_ID   INTEGER NOT NULL,
    SEQUENCE_NO          INTEGER NOT NULL,
    ENABLE_FLAG          CHAR(1) NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(COMMISSION_PROF_ID) REFERENCES COMMISSION_PROFILE(COMMISSION_PROF_ID)
);

CREATE SEQUENCE COMPANY_COMM_PROFILE_SEQ START 1;

CREATE SEQUENCE USERS_SEQ START 500;