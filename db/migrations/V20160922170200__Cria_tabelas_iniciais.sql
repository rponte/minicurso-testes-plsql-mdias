-- Create table
create table MDB_LOG_ENVIO_GKO
(
  ID               NUMBER(15)   NOT NULL,
  CD_ROMANEIO      VARCHAR2(30) NOT NULL,
  STATUS           VARCHAR2(60) NOT NULL,
  CREATION_DATE    DATE         NOT NULL,
  CREATED_BY       NUMBER       NOT NULL,
  LAST_UPDATED_BY  NUMBER       NOT NULL,
  LAST_UPDATE_DATE DATE         NOT NULL  
);

alter table MDB_LOG_ENVIO_GKO
  add constraint MDB_LOG_ENVIO_GKO_PK primary key (ID);
);