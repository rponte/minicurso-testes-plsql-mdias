create or replace PACKAGE JL_BR_WORKDAY_CALENDAR AUTHID DEFINER AS

	PROCEDURE JL_BR_CHECK_DATE (
		p_date		IN 	varchar2,
		p_calendar  IN	varchar2,
		p_city		IN	varchar2,
		p_action	IN	varchar2,
		p_new_date	IN  OUT NOCOPY	varchar2,
		p_status	IN  OUT NOCOPY	number,
	    p_state     IN  varchar2);

END JL_BR_WORKDAY_CALENDAR;
/

create or replace PACKAGE BODY JL_BR_WORKDAY_CALENDAR AS

	PROCEDURE JL_BR_CHECK_DATE (
		p_date		IN 	varchar2,
		p_calendar  IN	varchar2,
		p_city		IN	varchar2,
		p_action	IN	varchar2,
		p_new_date	IN  OUT NOCOPY	varchar2,
		p_status	IN  OUT NOCOPY	number,
	    p_state     IN  varchar2) is
	begin
		null;
	end;

END JL_BR_WORKDAY_CALENDAR;
/