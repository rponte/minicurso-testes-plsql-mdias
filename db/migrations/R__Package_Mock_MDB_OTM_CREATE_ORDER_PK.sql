create or replace Package Mdb_Otm_Create_Order_Pk Authid Current_User Is

	Function Get_Cube_Quantity_Mdb_f
	  (
	    P_Org_Id                 Number
	   ,P_Inventory_Item_Id      Number
	   ,P_Requested_Quantity     Number
	   ,P_Requested_Quantity_Uom Varchar2
	   ,P_Unit_Weight            Number
	  ) Return Number;

end Mdb_Otm_Create_Order_Pk;
/

create or replace Package body Mdb_Otm_Create_Order_Pk Is

	Function Get_Cube_Quantity_Mdb_f
	  (
	    P_Org_Id                 Number
	   ,P_Inventory_Item_Id      Number
	   ,P_Requested_Quantity     Number
	   ,P_Requested_Quantity_Uom Varchar2
	   ,P_Unit_Weight            Number
	  ) Return Number is
	begin
		return -1;
	end;

end Mdb_Otm_Create_Order_Pk;
/