create or replace PACKAGE FND_PROFILE AUTHID DEFINER AS

	function  VALUE(NAME in varchar2) return varchar2;

END FND_PROFILE;
/

create or replace PACKAGE BODY FND_PROFILE AS

	function  VALUE(NAME in varchar2) return varchar2 is
	begin
		return null;
	end;

END FND_PROFILE;
/
