create or replace Package Mdb_Om_Ship_Lines_Temp_Pk Authid Current_User Is

	Procedure Get_Item_Weights_p --
	  (
	    P_Inventory_Item_Id     In Number -- 
	   ,P_Organization_Id       In Number -- 
	   ,P_Requested_Quantity    In Number -- 
	   ,P_Requested_Uom_Code    In Varchar2 Default Null --   
	   ,P_Unit_Weight_Item      In Out Number -- Peso Unitatio do Item
	   ,P_Unit_Weight_Container In Out Number -- Peso Unitario do conteiner
	   ,P_Net_Weight            In Out Number -- Peso Liquido
	   ,P_Gross_Weight          In Out Number -- Peso Bruto
	  );

end Mdb_Om_Ship_Lines_Temp_Pk;
/

create or replace Package body Mdb_Om_Ship_Lines_Temp_Pk Is

	Procedure Get_Item_Weights_p --
	  (
	    P_Inventory_Item_Id     In Number -- 
	   ,P_Organization_Id       In Number -- 
	   ,P_Requested_Quantity    In Number -- 
	   ,P_Requested_Uom_Code    In Varchar2 Default Null --   
	   ,P_Unit_Weight_Item      In Out Number -- Peso Unitatio do Item
	   ,P_Unit_Weight_Container In Out Number -- Peso Unitario do conteiner
	   ,P_Net_Weight            In Out Number -- Peso Liquido
	   ,P_Gross_Weight          In Out Number -- Peso Bruto
	  ) is
	begin
		null;
	end;

end Mdb_Om_Ship_Lines_Temp_Pk;
/