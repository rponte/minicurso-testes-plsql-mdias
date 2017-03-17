create or replace PACKAGE INV_CONVERT AUTHID DEFINER AS

	FUNCTION inv_um_convert(
      item_id           number,
      precision		number,
      from_quantity     number,
      from_unit         varchar2,
      to_unit           varchar2,
      from_name		varchar2,
      to_name		varchar2) RETURN number;

END INV_CONVERT;
/

create or replace PACKAGE BODY INV_CONVERT AS

	FUNCTION inv_um_convert(
      item_id           number,
      precision		number,
      from_quantity     number,
      from_unit         varchar2,
      to_unit           varchar2,
      from_name		varchar2,
      to_name		varchar2) RETURN number IS
    BEGIN
	    return null;
	END;

END INV_CONVERT;
/