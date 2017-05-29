-- Create table
create table TB_FRETE_VALOR
(
  ID              INTEGER      NOT NULL,
  UF_ORIGEM       VARCHAR2(2)  NOT NULL,
  UF_DESTINO      VARCHAR2(2)  NOT NULL,
  VALOR           NUMBER(14,2) NOT NULL
);

alter table TB_FRETE_VALOR
  add constraint TB_FRETE_VALOR_PK primary key (ID);
);