/**
 * SPEC
 */
create or replace PACKAGE ROADNET AS 

  function is_dia_util(data_base date, uf_origem varchar2) return varchar2;

  function calcula_frete(uf_destino varchar2) return number;

END ROADNET;
/

/**
 * BODY
 */
create or replace PACKAGE body ROADNET AS 

  function calcula_frete(uf_destino varchar2) return number is
  begin
  
    if uf_destino is null then
      raise_application_error(-20999, 'UF de destino não informada!');
    end if;
  
    if uf_destino = 'SP' then
      return 30.10;
    end if;
    if uf_destino = 'RJ' then
      return 30.05;
    end if;
    if uf_destino = 'RN' then
      return 20.45;
    end if;  
  
    return 20.20;
  end;
   
  function is_dia_util(data_base date, uf_origem varchar2) return varchar2 is
  begin
  
    -- regra #2, fluxo alternativo
    if uf_origem = 'CE' then
      return 'Y';
    end if;
  
    -- regra #1
    if to_char(data_base, 'DY') = 'SAB' or to_char(data_base, 'DY') = 'DOM' then
      return 'F';
    end if;
    
    return 'Y';
  end;

END ROADNET;
/