create or replace PACKAGE OE_CODE_CONTROL AUTHID CURRENT_USER as

   CODE_RELEASE_LEVEL       varchar2(10) := '110510';

   Function Get_Code_Release_Level return varchar2;

End OE_CODE_CONTROL;
/

create or replace PACKAGE BODY OE_CODE_CONTROL as

   Function Get_Code_Release_Level
   return varchar2
   is
   Begin
      return OE_CODE_CONTROL.CODE_RELEASE_LEVEL;
   End Get_Code_Release_Level;

End OE_CODE_CONTROL;
/

