create or replace package FND_GLOBAL AUTHID CURRENT_USER as
  FUNCTION Conc_Request_Id RETURN NUMBER;
  
  function user_id return NUMBER;
  
  function login_id return NUMBER;
end FND_GLOBAL;
/

create or replace package body fnd_global AS
  FUNCTION Conc_Request_Id RETURN NUMBER AS
  BEGIN
    RETURN 223165842;
  END;
  
  function user_id return number is
  begin
    return 5097;
  end user_id;
  
  function login_id return number is
  begin
    return 456789;
  end login_id;
end fnd_global;
/