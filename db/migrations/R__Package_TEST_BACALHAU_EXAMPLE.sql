/**
 * Types
 */

--------------------------------------------------------
--  DDL for Type BLANCK_TYPE_RT
--------------------------------------------------------
CREATE OR REPLACE TYPE "BLANCK_TYPE_RT" AS OBJECT (
  id          VARCHAR2(60),
  nome        VARCHAR2(255),
  criado_em   TIMESTAMP,
  status      VARCHAR2(10)
);
/

/**
 * Package
 */


--------------------------------------------------------
--  DDL for Package TEST_BACALHAU
--------------------------------------------------------
create or replace PACKAGE TEST_BACALHAU AS

    FUNCTION retorna_type_exemplo(p_vCdRomaneio_i varchar2) RETURN BLANCK_TYPE_RT;

    PROCEDURE INSERE_TYPE_EXAMPLE(p_type_example BLANCK_TYPE_RT);
    
END TEST_BACALHAU;
/


--------------------------------------------------------
--  DDL for Package body TEST_BACALHAU
--------------------------------------------------------
create or replace PACKAGE BODY TEST_BACALHAU AS

   /* lança a exceção */	  
  procedure throw_exception(p_bErrorCode_i BINARY_INTEGER, p_vErrorMessage_i varchar2) is
	 begin
   	   raise_application_error(num => p_bErrorCode_i, 
                             	msg => p_vErrorMessage_i, 
                             	keepErrorStack => true);
  end;
  
  
  /** Function que retorna o type de exemplo */
  FUNCTION retorna_type_exemplo(p_vCdRomaneio_i varchar2) RETURN BLANCK_TYPE_RT IS
  	  l_blank_type BLANCK_TYPE_RT;  	
  BEGIN
	  SELECT new BLANCK_TYPE_RT(g.ID, g.CD_ROMANEIO, g.CREATION_DATE, g.STATUS)
	  INTO l_blank_type
	  FROM MDB_LOG_ENVIO_GKO g
	  WHERE CD_ROMANEIO = p_vCdRomaneio_i;
	  
	  return l_blank_type;
  END;
    
  
  /** Funcao para inserir usando o tipo */
  PROCEDURE INSERE_TYPE_EXAMPLE(p_type_example BLANCK_TYPE_RT) IS 
	
  	l_row_type MDB_LOG_ENVIO_GKO%ROWTYPE;
    
  BEGIN
	  l_row_type.ID 			  := p_type_example.id;
	  l_row_type.CD_ROMANEIO 	  := p_type_example.nome;
	  l_row_type.STATUS 		  := p_type_example.status;
	  l_row_type.CREATION_DATE 	  := p_type_example.criado_em;
	  l_row_type.CREATED_BY 	  := -1;
	  l_row_type.LAST_UPDATED_BY  := -1;
	  l_row_type.LAST_UPDATE_DATE := sysdate;
		  
	  INSERT INTO MDB_LOG_ENVIO_GKO VALUES l_row_type;
  EXCEPTION
  	WHEN OTHERS THEN 
  		throw_exception(-20101, 'Erro ao inserir novo envio.');
  END;
	    
   
  END TEST_BACALHAU;
/