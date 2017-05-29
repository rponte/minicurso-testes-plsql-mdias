/**
 * SPEC
 */
create or replace PACKAGE ROADNET AS 

  function is_dia_util(data_base date, uf_origem varchar2) return varchar2;

  function calcula_frete(p_uf_origem varchar2, p_uf_destino varchar2) return number;

END ROADNET;
/

/**
 * BODY
 */
create or replace PACKAGE body ROADNET AS 

  function aplica_desconto_especial(p_uf varchar2, p_valor_frete number) return number is
    DESCONTO_10_PORCENTO  constant number := 0.9;
    DESCONTO_5_PORCENTO   constant number := 0.95;
  begin
    if p_uf = 'CE' then
      return p_valor_frete * DESCONTO_10_PORCENTO;
    end if;
    
    return p_valor_frete * DESCONTO_5_PORCENTO;
  end;

  function calcula_frete(p_uf_origem varchar2, p_uf_destino varchar2) return number is
    valor_frete  number;
  begin
  
    select fv.VALOR
      into valor_frete
      from tb_frete_valor fv
      where fv.UF_ORIGEM  = p_uf_origem
        and fv.UF_DESTINO = p_uf_destino
      ;
  
    if p_uf_origem = p_uf_destino then
      valor_frete := aplica_desconto_especial(p_uf_origem, valor_frete);
    end if;
  
    return valor_frete;
  exception
    when no_data_found then
      raise_application_error(-20001, 'Valor do frete nao encontrado');
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