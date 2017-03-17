create or replace package FND_MESSAGE AUTHID DEFINER as

    function GET_STRING(APPIN in varchar2,
	      NAMEIN in varchar2) return varchar2;

    function GET return varchar2;

end FND_MESSAGE;
/

create or replace package body FND_MESSAGE as

	function GET_STRING(APPIN in varchar2, NAMEIN in varchar2) return varchar2 is
	begin
		return APPIN || '.' || NAMEIN;
	end;
	
	function GET return varchar2 is
    begin
		return 'FND_MESSAGE.GET()';
    end;

end FND_MESSAGE;
/
