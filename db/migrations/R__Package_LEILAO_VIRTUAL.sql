/**
 * SPEC
 */
CREATE OR REPLACE PACKAGE LEILAO_VIRTUAL AS 

  procedure dar_lance(p_leilao_id integer, p_usuario_nome varchar2, p_valor number);

END LEILAO_VIRTUAL;
/

/**
 * BODY
 */
create or replace PACKAGE BODY LEILAO_VIRTUAL AS

  procedure dar_lance(p_leilao_id integer, p_usuario_nome varchar2, p_valor number) is
    l_rLance  TB_LANCES%rowtype;
  begin
  
	  -- valida valor do lance
    if p_valor <= 0 then
      raise_application_error(-20301, 'Valor do lance deve ser maior que zero');
    end if;
    
    -- grava lance 
    l_rLance.ID           := SEQ_TB_LANCES.nextval;
    l_rLance.LEILAO_ID    := p_leilao_id;
    l_rLance.USUARIO_NOME := p_usuario_nome;
    l_rLance.VALOR        := p_valor;
    l_rLance.CRIADO_EM    := sysdate;

    insert into TB_LANCES values l_rLance;
  end;

END LEILAO_VIRTUAL;
/