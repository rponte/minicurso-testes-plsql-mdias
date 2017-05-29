/**
 * SPEC
 */
create or replace PACKAGE ROADNET AS 

  function is_dia_util(data_base date, uf_origem varchar2) return varchar2;

  function calcula_frete(uf_origem varchar2, uf_destino varchar2) return number;

END ROADNET;
/

/**
 * BODY
 */
create or replace PACKAGE body ROADNET AS 

  function calcula_frete(uf_origem varchar2, uf_destino varchar2) return number is
  begin
  
    if uf_origem = 'CE' and uf_destino = 'SP' then
      return 30.10;
    end if;
    if uf_origem = 'CE' and uf_destino = 'RJ' then
      return 30.05;
    end if;
    if uf_origem = 'CE' and uf_destino = 'RN' then
      return 20.45;
    end if;  
  
    return 20.20;
  end;
   
  function is_dia_util(data_base date, uf_origem varchar2) return varchar2 is
  begin
  
    -- regra #2, fluxo alternativo
    if uf_origem = 'CE' then
      return 'TRUE';
    end if;
  
    -- regra #1
    if to_char(data_base, 'DY') in ('SÁB', 'DOM') then
      return 'FALSE';
    end if;
    
    return 'TRUE';
  end;

END ROADNET;
/