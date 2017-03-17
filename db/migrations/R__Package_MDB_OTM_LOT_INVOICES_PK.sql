CREATE OR REPLACE PACKAGE MDB_OTM_LOT_INVOICES_PK IS

  -- $Header: %f% %v% %d% %u% ship                                                             $
  -- +=================================================================+
  -- |          ALEJANDRO Informatica , Fortaleza, Brasil              |
  -- |                       All rights reserved.                      |
  -- +=================================================================+
  -- | FILENAME                                                        |
  -- |   MDB_OTM_LOT_INVOICES_PKS.pls                                  |
  -- | PURPOSE                                                         |
  -- |   OM007d - Processo de Lote de Conte de Faturamento             |
  -- |                                                                 |
  -- | DESCRIPTION                                                     |
  -- |   Procedure para apoio ao processo de conte de faturamento      |
  -- |                                                                 |
  -- | PARAMETERS                                                      |
  -- |                                                                 |
  -- | CREATED BY  Diego Alejandro / 21.jul.2016                       |
  -- | UPDATED BY  <Nome do Desenvolvedor> / data                      |
  -- | 29.out.2016 Diego Alejandro                                     |
  -- |           . Inclui a procedure Insert_Line_Deleted_p            |  
  -- | 24.nov.2016 Diego Alejandro                                     |
  -- |           . Inclui na Proc Schedule_Ship_Date_Update_p o        |
  -- |             parametro de subinventario e action                 |
  -- | 11.jan.2017 Allan Bruno                                         |
  -- |           . Inclui a funcao get_lot_plan_id_f                   |
  -- | 08.fev.2017 Allan Bruno                                         |
  -- |           . Inclusão do parametro P_MSG na                      | 
  -- |             PROCEDURE SCHEDULE_SHIP_DATE_UPDATE_P               |
  -- | 11.fev.2017 Allan Bruno                                         |
  -- |           . Inclusão do parametro P_QTT_ERROR na                | 
  -- |             PROCEDURE SCHEDULE_SHIP_DATE_UPDATE_P               |
  -- |           . Inclusão da Procedure UPDATE_STATUS_LINE_P          | 
  -- +=================================================================+
  ---------------------------------------------------------------
  -- Procedure para selecionar as linhas e incluir no Lote de Corte de Faturamento
  ---------------------------------------------------------------
  -- Concorrente : MDB - OTM - Corte de Faturamento - Seleção de Linhas
  -- Executavel  : MDB_OTM_LOT_SELEC_LINE
  PROCEDURE SELEC_LINE_P(ERRBUF           OUT VARCHAR2,
                         RETCODE          OUT NUMBER,
                         P_ORG_ID         IN NUMBER,
                         P_LOT_INVOICE_ID IN NUMBER);

  ----------------------------------------------------------
  -- Procedure para Recuperar as linhas e retirar do Lote --
  ----------------------------------------------------------
  PROCEDURE DELETE_LINE_P(P_LOT_INVOICE_ID               NUMBER DEFAULT NULL,
                          P_ROWID                        ROWID DEFAULT NULL,
                          P_LOT_LINE_ID                  NUMBER DEFAULT NULL,
                          P_DELIVERY_DETAIL_ID           NUMBER DEFAULT NULL,
                          P_RETURN_SHIP_DATE_FLAG        VARCHAR DEFAULT 'Y',
                          P_WDD_OTM_STATUS_LINE_CODE     VARCHAR2 DEFAULT NULL,
                          P_WDD_OTM_STATUS_LINE_COMMENTS VARCHAR2 DEFAULT NULL,
                          P_COMMENTS                     VARCHAR2 DEFAULT NULL);

  ---------------------------------------------
  -- Procedure para fazer o BACNOKRDER TOTAL --
  ---------------------------------------------
  -- Concorrente : MDB - OTM - Corte de Faturamento - Backorder Total 
  -- Executavel  : MDB_OTM_LOT_BACKORDER_TOTAL
  PROCEDURE BACKORDER_TOTAL_P(ERRBUF           OUT VARCHAR2,
                              RETCODE          OUT NUMBER,
                              P_ORG_ID         IN NUMBER,
                              P_LOT_INVOICE_ID IN NUMBER);

  --------------------------------------------------------
  -- Procedure para processar as fases do Lote de Corte --
  --------------------------------------------------------
  -- Concorrente : MDB - OTM - Corte de Faturamento 
  -- Executavel  : MDB_OTM_LOT_MAIN
  PROCEDURE LOT_MAIN_P(ERRBUF           OUT VARCHAR2,
                       RETCODE          OUT NUMBER,
                       P_ORG_ID         IN NUMBER,
                       P_LOT_INVOICE_ID IN NUMBER);

  -------------------------------------------
  -- Procedure para Validar as inf do Lote --
  -------------------------------------------
  PROCEDURE LOT_VALIDATION_P(P_MOLI MDB_OTM_LOT_INVOICES_ALL %ROWTYPE);

  -----------------------------------------------------
  -- Procedure para Recuperar as linhas para o SPLIT --
  -----------------------------------------------------
  PROCEDURE LOT_SPLIT_SELECT_P(P_MOLI MDB_OTM_LOT_INVOICES_ALL %ROWTYPE);

  ----------------------------------
  -- Procedure para Criar o SPLIt --
  ----------------------------------
  PROCEDURE LOT_SPLIT_CREATE_P(P_SPLIT_BY               IN NUMBER,
                               P_HEADER_ID              IN NUMBER,
                               P_LINE_ID_ACTUAL         IN NUMBER,
                               P_LINE_ID_NEW            IN OUT NUMBER,
                               P_INVENTORY_ITEM_ID      IN NUMBER,
                               P_ORDERED_QUANTITY_ALT   IN NUMBER,
                               P_ORDERED_QUANTITY_SPLIT IN NUMBER,
                               P_MSG                    IN OUT VARCHAR2);

  ----------------------------------------------------------------------------------
  -- Procedure para Recuperar as linhas para alterar a Data de Entrega Programada --
  ----------------------------------------------------------------------------------
  Procedure SCHEDULE_SHIP_DATE_SELECT_P(P_Moli Mdb_Otm_Lot_Invoices_All %ROWTYPE
                                       ,P_MSG                IN OUT VARCHAR2
                                       ,P_QTT_ERROR          IN OUT NUMBER);

  ------------------------------------------------------------------
  -- Procedure para Alterar a Data de Entrega Programada da Linha --
  ------------------------------------------------------------------
  PROCEDURE SCHEDULE_SHIP_DATE_UPDATE_P(P_ACTION             IN VARCHAR2 DEFAULT NULL,
                                        P_HEADER_ID          IN NUMBER,
                                        P_LINE_ID            IN NUMBER,
                                        P_SCHEDULE_SHIP_DATE IN DATE DEFAULT NULL,
                                        P_SHIP_SET_ID        IN NUMBER DEFAULT NULL,
                                        P_SUBINVENTORY       IN VARCHAR2 DEFAULT NULL,
                                        P_MSG                IN OUT VARCHAR2);

  -------------------------------------------------------------
  -- Procedure para validar a quantidade minima para entrega --
  -------------------------------------------------------------
  PROCEDURE MIN_DELIVERY_VALIDATION_P(P_MOLI MDB_OTM_LOT_INVOICES_ALL %ROWTYPE);

  ----------------------------------------------------------------
  -- Procedure para Recuperar as linhas para separar do Estoque --
  ----------------------------------------------------------------
  PROCEDURE PICKING_BATCH_SELECT_P(P_MOLI MDB_OTM_LOT_INVOICES_ALL %ROWTYPE);

  --------------------------------------------------------------
  -- Procedure para processar a linha para separar do Estoque --
  --------------------------------------------------------------
  PROCEDURE PICKING_BATCH_LINE_P(P_MOLI     MDB_OTM_LOT_INVOICES_ALL %ROWTYPE,
                                 P_MOLL     MDB_OTM_LOT_LINES_ALL %ROWTYPE,
                                 P_WPR      WSH_PICKING_RULES %ROWTYPE,
                                 P_BATCH_ID IN OUT NUMBER,
                                 P_MSG      IN OUT VARCHAR2);

  ---------------------------------------------------------------------
  -- Procedure para Recuperar as linhas para tratar a indivibilidade --
  ---------------------------------------------------------------------
  PROCEDURE INDIVISIBLE_SELECT_P(P_MOLI MDB_OTM_LOT_INVOICES_ALL %ROWTYPE);

  -----------------------------------------------
  -- Procedure para criar as linhas com fracao --
  -----------------------------------------------
  PROCEDURE INDIVISIBLE_QTY_SPLIT_P(P_DELIVERY_DETAIL_ID     IN OUT NUMBER,
                                    P_DELIVERY_DETAIL_ID_NEW IN OUT NUMBER,
                                    P_QTY_SPLIT              IN OUT NUMBER,
                                    P_MSG                    IN OUT VARCHAR2);

  -----------------------------------------------------------
  -- Procedure para atualizar as linhas prontas para o OTM --
  -----------------------------------------------------------
  PROCEDURE SEND_OTM_UPDATE_P(P_MOLI MDB_OTM_LOT_INVOICES_ALL %ROWTYPE);

  -------------------------------------------------------------
  -- Procedure para atualizar as linhas de um lote cancelado --
  -------------------------------------------------------------
  PROCEDURE CANCEL_SELECTED_P(P_MOLI MDB_OTM_LOT_INVOICES_ALL %ROWTYPE);

  -------------------------------------------------------
  -- Procedure para excluir as linhas com erro do lote -- 
  -------------------------------------------------------
  PROCEDURE DELETE_ERROR_P(P_MOLI MDB_OTM_LOT_INVOICES_ALL %ROWTYPE);

  ----------------------------------------------
  -- Funcao para verficar se existe retencoes --
  ----------------------------------------------
  FUNCTION HOLD_EXISTS_F(P_HEADER_ID NUMBER, P_LINE_ID NUMBER)
    RETURN VARCHAR2;

  --------------------------------
  -- Procedure para Incluir Log --
  --------------------------------
  PROCEDURE INSERT_LOG_P(P_MOLLS IN MDB_OTM_LOT_LOG_STATUS_ALL%ROWTYPE);

  -------------------------------------------------------
  -- Procedure para Incluir Log do Status OTM da linha --
  -------------------------------------------------------
  PROCEDURE INSERT_LOG_STATUS_OTM_LINE_P(P_MOLLS IN MDB_OTM_LINE_LOG_STATUS_ALL%ROWTYPE);

  ---------------------------------------------
  -- Funcao para retornar o proximo dia util --
  ---------------------------------------------
  FUNCTION GET_NEXT_DAY_UTL_F(P_ADDRESS_ID IN NUMBER, P_DAY IN DATE)
    RETURN DATE;

  ------------------------------------
  -- Funcao para convercao de itens --
  ------------------------------------
  FUNCTION INV_UM_CONVERT_F(P_ITEM_ID       NUMBER,
                            P_FROM_QUANTITY NUMBER,
                            P_FROM_UNIT     VARCHAR2,
                            P_TO_UNIT       VARCHAR2) RETURN NUMBER;

  -- Funcao para verificar se tem alguem usando o Lote 
  FUNCTION USE_LOT_VER_F(P_LOT_INVOICE_ID NUMBER, P_USER_ID NUMBER)
    RETURN VARCHAR2;

  -- Funcao para deletar o controle de acesso do lote 
  FUNCTION USE_LOT_DEL_F(P_LOT_INVOICE_ID NUMBER) RETURN VARCHAR2;

  -- Procedure para Incluir as Linhas deletadas --
  PROCEDURE INSERT_LINE_DELETED_P(P_R_MOLL  MDB_OTM_LOT_LINES_ALL %ROWTYPE,
                                  P_R_MOLLE MDB_OTM_LOT_LINE_EXCLUDEDS_ALL %ROWTYPE);

  PROCEDURE SECONDARY_VALIDATION_P(P_MOLI MDB_OTM_LOT_INVOICES_ALL %ROWTYPE);

  /**
  * Funcao para retornar o lote de planejamento da delivery
  */
  FUNCTION GET_LOT_PLAN_ID_F(P_NDELIVERY_DETAIL_ID MDB_OTM_LOT_LINES_ALL.DELIVERY_DETAIL_ID%TYPE)
    RETURN MDB_OM_LOT_PLAN_HEADERS_ALL.LOT_PLAN_ID%TYPE;
    
  -- Procedure para Atualizar status da linha do lote --
  PROCEDURE UPDATE_STATUS_LINE_P(P_N_LOTE_LINE_ID NUMBER,
                                 P_V_MSG          VARCHAR2,
                                 P_V_STATUS       VARCHAR2);

END MDB_OTM_LOT_INVOICES_PK;
/

CREATE OR REPLACE Package Body Mdb_Otm_Lot_Invoices_Pk Is

  -- $Header: %f% %v% %d% %u% ship                                                             $
  -- +=================================================================+
  -- |          ALEJANDRO Informatica , Fortaleza, Brasil              |
  -- |                       All rights reserved.                      |
  -- +=================================================================+
  -- | FILENAME                                                        |
  -- |   MDB_OTM_LOT_INVOICES_PKB.pls                                  |
  -- | PURPOSE                                                         |
  -- |   OM007d - Processo de Lote de Conte de Faturamento             |
  -- |                                                                 |
  -- | DESCRIPTION                                                     |
  -- |   Procedure para apoio ao processo de conte de faturamento      |
  -- |                                                                 |
  -- | PARAMETERS                                                      |
  -- |                                                                 |
  -- | CREATED BY  Diego Alejandro / 21.jul.2016                       |
  -- | UPDATED BY  <Nome do Desenvolvedor> / data                      |
  -- | 19.ago.2016 Diego Alejandro                                     |
  -- |           . Inclui chamada do concorrente do GAP OM008A         |
  -- |             MDB_OTM_LOT_CREATE_RELEASE                          |
  -- | 25.ago.2016 Diego Alejandro                                     |
  -- |           . Inclui o delete de linhas que precisam aprovacao do |
  -- |             Planejamento de Almoxarifado                        |
  -- | 29.ago.2016 Diego Alejandro                                     |
  -- |           . Inclui a validacao da OI para usar o OTM            |
  -- | 13.set.2016 Diego Alejandro                                     |
  -- |           . Trat. status do Lote                                |
  -- | 15.set.2016 Diego Alejandro                                     |
  -- |           . Inclui a chamada do OM012 - Aprov.Planejamento Emb. |
  -- | 23.set.2016 Diego Alejandro                                     |
  -- |           . ALT. procedure Picking_Batch_Select_p               |
  -- |             Ref. ordem da separacao para conter a linha do      |
  -- |             pedido e entrega                                    |
  -- | 04.out.2016 Diego Alejandro                                     |
  -- |           . Alt. Schedule_Ship_Date_Select_p                    |
  -- |             Ref. Lead Time de Coleta                            |
  -- | 07.out.2016 Diego Alejandro                                     |
  -- |           . Alt. Schedule_Ship_Date_Select_p quando deleta do   |
  -- |             Lote de Corte                                       |
  -- |           . Inclu as mensagens parametrizadas                   |
  -- | 11.out.2016 Diego Alejandro                                     |
  -- |           . Trat. dia util para data de entrega                 |
  -- | 12.out.2016 Diego Alejandro                                     |
  -- |           . Trat. dia util para data de entrega                 |
  -- | 14.out.2016 Diego Alejandro                                     |
  -- |           . Trat. no NVL da Get_Next_Day_Utl_f                  |
  -- | 20.out.2016 Diego Alejandro                                     |
  -- |          . Inclui commit na Use_Lot_Ver_f                       |
  -- | 22.out.2016 Diego Alejandro                                     |
  -- |          . Inclui o caluclo do cubo e os pessos do item         |
  -- | 24.out.2016 Diego Alejandro                                     |
  -- |           . Incluir a validacao da OI Destino Lot_Validation_p  |
  -- | 26.out.2016 Diego Alejandro                                     |
  -- |           . Trata. na procedure Picking_Batch_Select_p          |
  -- |             ref.Para resercar todos os flags precisam estar     |
  -- |             igual a N                                           |
  -- | 29.out.2016 Diego Alejandro                                     |
  -- |           . Inclui a procedure Insert_Line_Deleted_p            |
  -- | 09.nov.2016 Diego Alejandro                                     |
  -- |           . Inclui na Procedure Delete_Error_p o tratamento do  |
  -- |             erro do SPLIT                                       |
  -- | 24.nov.2016 Diego Alejandro                                     |
  -- |           . Inclui na Proc Schedule_Ship_Date_Update_p o        |
  -- |             parametro de subinventario e o seu tratamento       |
  -- | 28.nov.2016 Diego Alejandro                                     |
  -- |           . Retirei a opcao de enviar para o OTM sem reserva INV|
  -- | 09.dez.2016 Diego Alejandro                                     |
  -- |           . Inclui a Procedure Secondary_Validation_p           |
  -- | 11.jan.2017 Allan Bruno                                         |
  -- |           . Inclui a funcao get_lot_plan_id_f                   |
  -- |           . Preenchi as linhas do lote com o planejamento       |
  -- | 08.fev.2017 Allan Bruno                                         |
  -- |           . Inclusão do trunc na coluna Schedule_Ship_Date na   | 
  -- |             PROCEDURE Picking_Batch_Select_p                    |
  -- |           . Update no status da linha quando der erro na        | 
  -- |             PROCEDURE Schedule_Ship_Date_Select_p               |
  -- |           . Alteração da mensagem de erro visível para o usuário| 
  -- |             PROCEDURE Lot_Main_p                                |
  -- | 11.fev.2017 Allan Bruno                                         |
  -- |           . Inclusão do parametro P_QTT_ERROR na                | 
  -- |             PROCEDURE SCHEDULE_SHIP_DATE_UPDATE_P               |
  -- |           . Inclusão da Procedure UPDATE_STATUS_LINE_P          | 
  -- +=================================================================+
  ---------------------------------------------------------------
  -- Procedure para selecionar as linhas e incluir no Lote de Corte de Faturamento
  ---------------------------------------------------------------
  -- Concorrente : MDB - OTM - Corte de Faturamento - Seleção de Linhas
  -- Executavel  : MDB_OTM_LOT_SELEC_LINE
  Procedure Selec_Line_p
  (
    Errbuf           Out Varchar2
   ,Retcode          Out Number
   ,P_Org_Id         In Number
   ,P_Lot_Invoice_Id In Number
  ) Is
    ----------------------------------
    -- Cursor para de Lote de Corte --
    ----------------------------------
    Cursor C_Moli(Pc_Lot_Invoice_Id Number) Is
      Select Moli.*
        From Mdb_Otm_Lot_Invoices_All Moli
       Where Lot_Invoice_Id = Pc_Lot_Invoice_Id;
    ------------------------
    -- Regra de Separacao --
    ------------------------
    Cursor C_Wpv(Pc_Picking_Rule_Id Number) Is
      Select Wpr.*
        From Wsh_Picking_Rules Wpr
       Where Wpr.Picking_Rule_Id = Pc_Picking_Rule_Id;
    ----------------------------------
    -- Cursor das Linhas de Entrega --
    ----------------------------------
    Cursor C_Wdd
    (
      Pc_Moli Mdb_Otm_Lot_Invoices_All%Rowtype
     ,Pc_Wpr  Wsh_Picking_Rules%Rowtype
    ) Is
      Select Wdd.Delivery_Detail_Id
            ,Ool.Schedule_Ship_Date
            ,Ool.Header_Id
            ,Ool.Line_Id
            ,Ool.Inventory_Item_Id
            ,Wdd.Requested_Quantity_Uom
            ,Wdd.Requested_Quantity
            ,Wdd.Unit_Price--
            ,Rsu.Address_Id
            ,Wdd.Ship_Method_Code
            ,Wdd.Attribute1
            ,Wdd.Attribute2
            ,Ra.Global_Attribute3 || Ra.Global_Attribute4 ||
             Ra.Global_Attribute5 Document_Number
            ,Ool.Line_Number
            ,Ool.Shipment_Number
            ,Ooh.Order_Number
            ,Ool.Line_Type_Id--
            ,Wdd.Shipment_Priority_Code--
            ,Ra.Customer_Id
        From Wsh_Delivery_Details Wdd
            ,Oe_Order_Lines_All   Ool
            ,Oe_Order_Headers_All Ooh
            ,Ra_Site_Uses_All     Rsu
            ,Ra_Addresses_All     Ra
            ,Fnd_Lookup_Values    Flv_Otm_Line_Status
       Where Wdd.Source_Code = 'OE'
         And Wdd.Organization_Id = Pc_Wpr.Organization_Id
            -- Subinv
         And Wdd.Subinventory = Pc_Wpr.Pick_From_Subinventory
            -- Pedido
         And Wdd.Source_Header_Id =
             Nvl(Pc_Moli.Header_Id, Wdd.Source_Header_Id)
            -- Metodo de entrega 
         And Wdd.Ship_Method_Code =
             Nvl(Pc_Moli.Ship_Method_Code, Wdd.Ship_Method_Code)
            -- Site Use / Endereco
         And Rsu.Site_Use_Id = Wdd.Ship_To_Site_Use_Id
         And Rsu.Address_Id = Nvl(Pc_Moli.Address_Id, Rsu.Address_Id)
            -- Endereco
         And Ra.Address_Id = Rsu.Address_Id
            -- Status da Entrega 
         And Wdd.Released_Status In ('R' -- Pronto para Liberação
                                    ,'B' -- Com Backorder
                                    ,'Y' -- Preparação/Separação Confirmada
                                     )
            -- Linha do Pedido
         And Ool.Line_Id = Wdd.Source_Line_Id
         And Ool.Schedule_Ship_Date Between
             Trunc(Pc_Moli.Schedule_Ship_Start_Date) And
             Trunc(Pc_Moli.Schedule_Ship_End_Date) + .99999
         And Ool.Booked_Flag = 'Y'
         And Ool.Open_Flag = 'Y'
         And Ool.Cancelled_Flag = 'N'
         And Ooh.Header_Id = Ool.Header_Id
            -- Verificar se o tipo da transacao envia a linha para o OTM
         And Exists
       (Select Null
                From Mdb_Otm_Transaction_Types_All Mott
               Where Mott.Org_Id = Ool.Org_Id
                 And Mott.Transaction_Type_Id = Ool.Line_Type_Id
                 And Mott.Otm_Send_To_Flag = 'Y'
                 And Mott.Enabled_Flag = 'Y')
            -- Nao existir em um carga do OM205
         And Not Exists
       (Select Null
                From Mdb_Om_Shipment_Lines Mosl
                    ,Mdb_Om_Shipments      Mos
               Where Mos.Status_Code In (1 -- Selecionado
                                        ,2 -- Resumo de Carga
                                        ,4 -- Processando Conf. Entrega
                                        ,5 -- Problema Conf. Entrega
                                         )
                 And Mos.Shipment_Id = Mosl.Shipment_Id
                 And Mosl.Delivery_Detail_Id = Wdd.Delivery_Detail_Id)
            -- Nao existir em um lote de corte
         And Not Exists
       (Select Null
                From Mdb_Otm_Lot_Lines_All    Moll
                    ,Mdb_Otm_Lot_Invoices_All Moli
               Where Moll.Delivery_Detail_Id = Wdd.Delivery_Detail_Id
                 And Moli.Lot_Invoice_Id = Moll.Lot_Invoice_Id
                 And Moli.Lot_Status_Code Not In
                     ('CANCELED', 'COMPLETED COURT BILLING'))
            -- Selecionar linhas que nao tem retencao
         And Mdb_Otm_Lot_Invoices_Pk.Hold_Exists_f(Ool.Header_Id
                                                  ,Ool.Line_Id) = 'N'
            -- Verificar o status OTM da linha 
         And Flv_Otm_Line_Status.Lookup_Type = 'MDB_OTM_LINE_STATUS'
         And Flv_Otm_Line_Status.Lookup_Code =
             Nvl(Wdd.Attribute1, 'NO PROCESS')
         And Nvl(Flv_Otm_Line_Status.Attribute1, 'N') = 'Y'
         And Flv_Otm_Line_Status.Enabled_Flag = 'Y'
         And Flv_Otm_Line_Status.Language = Userenv('LANG')
         --planejamento de corte
         AND ( Pc_Moli.Lot_Plan_Id IS NULL OR EXISTS (Select molpla.delivery_detail_id
                                          From Mdb_Om_Lot_Plan_Lines_All Molpla
                                         Where Molpla.Lot_Plan_Id = Pc_Moli.Lot_Plan_Id
                                           AND Molpla.Delivery_Detail_Id = Wdd.Delivery_Detail_Id))
      --
      ;
    -- Variaveis 
    L_r_Moo             Mdb_Otm_Organizations_All %Rowtype;
    L_r_Moll            Mdb_Otm_Lot_Lines_All%Rowtype;
    L_r_Molls_Lot       Mdb_Otm_Lot_Log_Status_All%Rowtype;
    L_r_Molls_Line      Mdb_Otm_Line_Log_Status_All%Rowtype;
    L_n_Conc_Request_Id Number := Fnd_Global.Conc_Request_Id;
    L_n_Commit          Number := 0;
    L_n_Count_Line      Number := 0;
  Begin
    ----------------------------------
    -- Cursor para de Lote de Corte --
    ----------------------------------
    For R_Moli In C_Moli(Pc_Lot_Invoice_Id => P_Lot_Invoice_Id)
    Loop
      -- Recupera as conf.da OI --
      Begin
        Select *
          Into L_r_Moo
          From Mdb_Otm_Organizations_All Moo
         Where Moo.Org_Id = P_Org_Id
           And Moo.Organization_Id = R_Moli.Organization_Id;
      Exception
        When Others Then
          Null;
      End;
      -- 
      If Nvl(L_r_Moo.Otm_Activated_Flag, 'N') = 'N'
      Then
        -- MDB_OM_007C_001 - Organização de Inventario não esta configurada para utilizar o OTM
        L_r_Molls_Lot.Comments := Fnd_Message.Get_String('MDB'
                                                        ,'MDB_OM_007C_001');
      End If;
      ------------------------
      -- Regra de Separacao --
      ------------------------
      If L_r_Molls_Lot.Comments Is Null
      Then
        For R_Wpv In C_Wpv(Pc_Picking_Rule_Id => R_Moli.Picking_Rule_Id)
        Loop
          ----------------------------------
          -- Cursor das Linhas de Entrega --
          ----------------------------------
          For R_Wdd In C_Wdd(Pc_Moli => R_Moli, Pc_Wpr => R_Wpv)
          Loop
            -- Prepara a linha para inclusao
            Select Mdb_Otm_Lot_Lines_S.Nextval
              Into L_r_Moll.Lot_Line_Id
              From Dual;
            
            L_r_Moll.Lot_Invoice_Id               := P_Lot_Invoice_Id;
            L_r_Moll.Organization_Id              := R_Moli.Organization_Id;
            L_r_Moll.Org_Id                       := R_Moli.Org_Id;
            L_r_Moll.Schedule_Ship_Date           := R_Wdd.Schedule_Ship_Date;
            L_r_Moll.Header_Id                    := R_Wdd.Header_Id;
            L_r_Moll.Order_Number                 := R_Wdd.Order_Number;
            L_r_Moll.Line_Id                      := R_Wdd.Line_Id;
            L_r_Moll.Line_Number                  := R_Wdd.Line_Number;
            L_r_Moll.Shipment_Number              := R_Wdd.Shipment_Number;
            L_r_Moll.Line_Type_Id                 := R_Wdd.Line_Type_Id;
            L_r_Moll.Delivery_Detail_Id           := R_Wdd.Delivery_Detail_Id;
            L_r_Moll.Inventory_Item_Id            := R_Wdd.Inventory_Item_Id;
            L_r_Moll.Requested_Quantity_Uom       := R_Wdd.Requested_Quantity_Uom;
            L_r_Moll.Requested_Quantity           := R_Wdd.Requested_Quantity;
            L_r_Moll.Unit_Price                   := R_Wdd.Unit_Price;
            L_r_Moll.Shipment_Priority_Code       := R_Wdd.Shipment_Priority_Code;
            L_r_Moll.Selected_Flag                := 'Y';
            L_r_Moll.Address_Id                   := R_Wdd.Address_Id;
            L_r_Moll.Document_Number              := R_Wdd.Document_Number;
            L_r_Moll.Ship_Method_Code             := R_Wdd.Ship_Method_Code;
            L_r_Moll.Lot_Otm_Status_Line_Code     := 'SELECTED';
            L_r_Moll.Lot_Otm_Status_Line_Comments := Null;
            L_r_Moll.Creation_Date                := Sysdate;
            L_r_Moll.Created_By                   := Fnd_Global.User_Id;
            L_r_Moll.Last_Update_Date             := Sysdate;
            L_r_Moll.Last_Updated_By              := Fnd_Global.User_Id;
            L_r_Moll.Last_Update_Login            := Fnd_Global.Login_Id;
            L_r_Moll.Customer_Id                  := R_Wdd.Customer_Id;
            -- marca linha como pedido unico no OTM
            L_r_Moll.Lot_Plan_Id                  := get_lot_plan_id_f(R_Wdd.Delivery_Detail_Id);
            L_r_Moll.Lot_Unique_Order_Flag        := CASE WHEN L_r_Moll.Lot_Plan_Id <> -1 THEN 'Y' ELSE 'N' END;
            --
            --
            Begin
              -- Inclui a linha no Lote
              Insert Into Mdb_Otm_Lot_Lines_All
              Values L_r_Moll;
              -- Atualizar Status da WDD
              L_r_Molls_Line.Delivery_Detail_Id := R_Wdd.Delivery_Detail_Id;
              L_r_Molls_Line.Organization_Id    := R_Moli.Organization_Id;
              L_r_Molls_Line.Org_Id             := R_Moli.Org_Id;
              L_r_Molls_Line.Status_Code_From   := Nvl(R_Wdd.Attribute1
                                                      ,'NO PROCESS');
              L_r_Molls_Line.Status_Code_To     := L_r_Moll.Lot_Otm_Status_Line_Code;
              L_r_Molls_Line.Comments           := L_r_Moll.Lot_Otm_Status_Line_Comments;
              Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
              -- Controla o commit
              L_n_Commit     := L_n_Commit + 1;
              L_n_Count_Line := L_n_Count_Line + 1;
              If L_n_Commit >= 1000
              Then
                L_n_Commit := 0;
                Commit;
              End If;
            Exception
              When Others Then
                -- MDB_OM_007C_002 - Erro não esperado - Id da Linha de Entrega : 
                L_r_Molls_Lot.Comments := Fnd_Message.Get_String('MDB'
                                                                ,'MDB_OM_007C_002') ||
                                          R_Wdd.Delivery_Detail_Id || ' - ' ||
                                          Sqlerrm;
                Exit;
            End;
          End Loop C_Wdd;
          Commit;
        End Loop C_Wpv;
      End If;
      -- Trara o Status 
      If L_r_Molls_Lot.Comments Is Null
      Then
        If L_n_Count_Line >= 1
        Then
          L_r_Molls_Lot.Lot_Status_Code_To := 'COMPLETED SELECTION'; -- Seleção Concluída;
        Else
          -- Se nao encontrou linhas verificar se ja existe linhas na carga --
          Select Count(*)
            Into L_n_Count_Line
            From Mdb_Otm_Lot_Lines_All
           Where Lot_Invoice_Id = P_Lot_Invoice_Id;
          If L_n_Count_Line >= 1
          Then
            L_r_Molls_Lot.Lot_Status_Code_To := 'COMPLETED SELECTION'; -- Seleção Concluída;
          Else
            L_r_Molls_Lot.Lot_Status_Code_To := 'NOT COMPLETED SELECTION'; -- Seleção não Concluída  
          End If;
        End If;
      Else
        L_r_Molls_Lot.Lot_Status_Code_To := 'NOT COMPLETED SELECTION'; -- Seleção não Concluída          
      End If;
      -- Atualiza o Status e Inclui o Log do Status 
      L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
      L_r_Molls_Lot.Lot_Status_Code_From := R_Moli.Lot_Status_Code;
      L_r_Molls_Lot.Comments             := Nvl(L_r_Molls_Lot.Comments
                                               ,'Qtd.Linhas Selecionadas : ' ||
                                                L_n_Count_Line);
      L_r_Molls_Lot.Request_Id           := L_n_Conc_Request_Id;
      L_r_Molls_Lot.Org_Id               := R_Moli.Org_Id;
      L_r_Molls_Lot.Organization_Id      := R_Moli.Organization_Id;
      --
      Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
      Commit;
    End Loop C_Moli;
  Exception
    When Others Then
      -- Atualiza o Status e Inclui o Log do Status 
      L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
      L_r_Molls_Lot.Lot_Status_Code_From := 'NOT COMPLETED SELECTION'; -- Seleção não Concluída
      -- MDB_OM_007C_003 - Erro inesperado na Seleção : 
      L_r_Molls_Lot.Comments   := Fnd_Message.Get_String('MDB'
                                                        ,'MDB_OM_007C_003') ||
                                  Sqlerrm;
      L_r_Molls_Lot.Request_Id := L_n_Conc_Request_Id;
      L_r_Molls_Lot.Org_Id     := P_Org_Id;
      --
      Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
  End Selec_Line_p;

  ----------------------------------------------------------
  -- Procedure para Recuperar as linhas e retirar do Lote --
  ----------------------------------------------------------
  Procedure Delete_Line_p
  (
    P_Lot_Invoice_Id               Number Default Null
   ,P_Rowid                        Rowid Default Null
   ,P_Lot_Line_Id                  Number Default Null
   ,P_Delivery_Detail_Id           Number Default Null
   ,P_Return_Ship_Date_Flag        Varchar Default 'Y'
   ,P_Wdd_Otm_Status_Line_Code     Varchar2 Default Null
   ,P_Wdd_Otm_Status_Line_Comments Varchar2 Default Null
   ,P_Comments                     Varchar2 Default Null
  ) Is
    --------------------------------------------------------
    -- Cursor das Linhas para Enviar para retirar do Lote --
    --------------------------------------------------------
    Cursor C_Moll(Pc_Lot_Invoice_Id Number) Is
      Select Moll.*
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Selected_Flag = 'N';
    ------------------------------------------
    -- Cursor da Linha para retirar do Lote -- Por rowid
    ------------------------------------------
    Cursor C_Moll_Rowid(Pc_Rowid Rowid) Is
      Select Moll.*
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Rowid = Pc_Rowid;
    ------------------------------------------
    -- Cursor da Linha para retirar do Lote -- Por Line
    ------------------------------------------
    Cursor C_Moll_Line
    (
      Pc_Lot_Line_Id        Number
     ,Pc_Delivery_Detail_Id Number
    ) Is
      Select Moll.*
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Line_Id = Pc_Lot_Line_Id
         And Moll.Delivery_Detail_Id =
             Nvl(Pc_Delivery_Detail_Id, Moll.Delivery_Detail_Id);
    -- Variaveis 
    L_r_Molls_Line Mdb_Otm_Line_Log_Status_All%Rowtype;
    L_n_Commit     Number;
    L_v_Msg        Varchar2(4000);
    L_r_Moll       Mdb_Otm_Lot_Lines_All%Rowtype;
    L_r_Mlle       Mdb_Otm_Lot_Line_Excludeds_All %Rowtype;
  Begin
    -------------------------------------------------------------------
    -- Se o Lote estiver informado eh uma exclusao em massa e Manual --
    ------------------------------------------------------------------- 
    If P_Lot_Invoice_Id Is Not Null And
       P_Rowid Is Null And
       P_Lot_Line_Id Is Null And
       P_Delivery_Detail_Id Is Null
    Then
      ----------------------------------------      
      -- Cursor das Linhas nao selecionadas -- 
      ----------------------------------------
      For R_Moll In C_Moll(Pc_Lot_Invoice_Id => P_Lot_Invoice_Id)
      Loop
        -- Flag para retornar a DATA 
        If P_Return_Ship_Date_Flag = 'Y'
        Then
          -- Verifica se teva alteracao de data de entrega --
          If Trunc(R_Moll.Schedule_Ship_Date) !=
             Trunc(Nvl(R_Moll.Schedule_Ship_Date_Old
                      ,R_Moll.Schedule_Ship_Date))
          Then
            ------------------------------------------------------------------
            -- Procedure para Alterar a Data de Entrega Programada da Linha --
            ------------------------------------------------------------------
            Begin
              Mdb_Otm_Lot_Invoices_Pk.Schedule_Ship_Date_Update_p -- 
              (P_Action             => 'SCHEDULE_SHIP_DATE'
              ,P_Header_Id          => R_Moll.Header_Id
              ,P_Line_Id            => R_Moll.Line_Id --
              ,P_Schedule_Ship_Date => Trunc(R_Moll.Schedule_Ship_Date_Old) --
              ,P_Msg                => L_v_Msg --
               );
              Commit;
            Exception
              When Others Then
                Null; -- Nao para o processo
            End;
          End If;
        End If;
        -- Atualizar Status da WDD da Linha Nova
        L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
        L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
        L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
        L_r_Molls_Line.Status_Code_From   := R_Moll.Lot_Otm_Status_Line_Code;
        L_r_Molls_Line.Status_Code_To     := 'DELETED'; -- Seleção retirada manualmente (Quando for retirado do Lote de Corte)
        L_r_Molls_Line.Comments           := '';
        Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
        -- Inclui na tab de linhas deletadas
        L_r_Mlle.Wdd_Otm_Status_Line_Code     := L_r_Molls_Line.Status_Code_To;
        L_r_Mlle.Wdd_Otm_Status_Line_Comments := L_r_Molls_Line.Comments;
        L_r_Mlle.Comments                     := 'Linha excluida manualmente';
        Mdb_Otm_Lot_Invoices_Pk.Insert_Line_Deleted_p(P_r_Moll  => R_Moll --
                                                     ,P_r_Molle => L_r_Mlle);
        -- Atualiza a quantidade da linha no lote 
        Delete Mdb_Otm_Lot_Lines_All
         Where Lot_Line_Id = R_Moll.Lot_Line_Id;
        -- Controla o commit
        L_n_Commit := L_n_Commit + 1;
        If L_n_Commit >= 1000
        Then
          L_n_Commit := 0;
          Commit;
        End If;
      End Loop C_Moll;
    Else
      ----------------------------------------------------
      -- Cursor da Linha para retirar do Lote por RowId --
      ----------------------------------------------------
      If P_Rowid Is Not Null
      Then
        For R_Moll In C_Moll_Rowid(Pc_Rowid => P_Rowid)
        Loop
          L_r_Moll.Header_Id              := R_Moll.Header_Id;
          L_r_Moll.Line_Id                := R_Moll.Line_Id;
          L_r_Moll.Schedule_Ship_Date     := R_Moll.Schedule_Ship_Date;
          L_r_Moll.Schedule_Ship_Date_Old := R_Moll.Schedule_Ship_Date_Old;
          L_r_Moll.Lot_Line_Id            := R_Moll.Lot_Line_Id;
          -- Inclui na tab de linhas deletadas
          L_r_Mlle.Wdd_Otm_Status_Line_Code     := P_Wdd_Otm_Status_Line_Code;
          L_r_Mlle.Wdd_Otm_Status_Line_Comments := P_Wdd_Otm_Status_Line_Comments;
          L_r_Mlle.Comments                     := P_Comments;
          Mdb_Otm_Lot_Invoices_Pk.Insert_Line_Deleted_p(P_r_Moll  => R_Moll --
                                                       ,P_r_Molle => L_r_Mlle);
          -- Exclui do Lote 
          Delete Mdb_Otm_Lot_Lines_All
           Where Rowid = P_Rowid;
        End Loop C_Moll_Rowid;
      Else
        If P_Lot_Line_Id Is Not Null
        Then
          ----------------------------------------------------------
          -- Cursor da Linha para retirar do Lote por Id da Linha --
          ----------------------------------------------------------
          For R_Moll In C_Moll_Line(Pc_Lot_Line_Id        => P_Lot_Line_Id --
                                   ,Pc_Delivery_Detail_Id => P_Delivery_Detail_Id)
          Loop
            L_r_Moll.Header_Id              := R_Moll.Header_Id;
            L_r_Moll.Line_Id                := R_Moll.Line_Id;
            L_r_Moll.Schedule_Ship_Date     := R_Moll.Schedule_Ship_Date;
            L_r_Moll.Schedule_Ship_Date_Old := R_Moll.Schedule_Ship_Date_Old;
            L_r_Moll.Lot_Line_Id            := R_Moll.Lot_Line_Id;
            -- Inclui na tab de linhas deletadas
            L_r_Mlle.Wdd_Otm_Status_Line_Code     := P_Wdd_Otm_Status_Line_Code;
            L_r_Mlle.Wdd_Otm_Status_Line_Comments := P_Wdd_Otm_Status_Line_Comments;
            L_r_Mlle.Comments                     := P_Comments;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Line_Deleted_p(P_r_Moll  => R_Moll --
                                                         ,P_r_Molle => L_r_Mlle);
            -- Exclui do Lote 
            Delete Mdb_Otm_Lot_Lines_All
             Where Lot_Line_Id = R_Moll.Lot_Line_Id;
          End Loop C_Moll_Line;
        End If; -- If P_Lot_Line_Id Is Not Null Then
      End If; -- If P_Rowid Is Not Null Then
      -- Verifica se teva alteracao de data de entrega --
      If P_Return_Ship_Date_Flag = 'Y'
      Then
        If L_r_Moll.Header_Id Is Not Null And
           L_r_Moll.Line_Id Is Not Null And
           L_r_Moll.Schedule_Ship_Date Is Not Null And
           L_r_Moll.Schedule_Ship_Date_Old Is Not Null
        Then
          --
          If Trunc(L_r_Moll.Schedule_Ship_Date) !=
             Trunc(L_r_Moll.Schedule_Ship_Date_Old)
          Then
            ------------------------------------------------------------------
            -- Procedure para Alterar a Data de Entrega Programada da Linha --
            ------------------------------------------------------------------
            Begin
              Mdb_Otm_Lot_Invoices_Pk.Schedule_Ship_Date_Update_p -- 
              (P_Action             => 'SCHEDULE_SHIP_DATE'
              ,P_Header_Id          => L_r_Moll.Header_Id --
              ,P_Line_Id            => L_r_Moll.Line_Id --
              ,P_Schedule_Ship_Date => Trunc(L_r_Moll.Schedule_Ship_Date_Old) --
              ,P_Msg                => L_v_Msg --
               );
              Commit;
            Exception
              When Others Then
                Null; -- Nao para o processo
            End;
          End If;
        End If;
      End If;
    End If;
    Commit;
  End Delete_Line_p;

  ---------------------------------------------
  -- Procedure para fazer o BACNOKRDER TOTAL --
  ---------------------------------------------
  -- Concorrente : MDB - OTM - Corte de Faturamento - Backorder Total 
  -- Executavel  : MDB_OTM_LOT_BACKORDER_TOTAL
  Procedure Backorder_Total_p
  (
    Errbuf           Out Varchar2
   ,Retcode          Out Number
   ,P_Org_Id         In Number
   ,P_Lot_Invoice_Id In Number
  ) Is
    ----------------------------------
    -- Cursor para de Lote de Corte --
    ----------------------------------
    Cursor C_Moli(Pc_Lot_Invoice_Id Number) Is
      Select Moli.*
        From Mdb_Otm_Lot_Invoices_All Moli
       Where Lot_Invoice_Id = Pc_Lot_Invoice_Id;
    ------------------------
    -- Regra de Separacao --
    ------------------------
    Cursor C_Wpv(Pc_Picking_Rule_Id Number) Is
      Select Wpr.*
        From Wsh_Picking_Rules Wpr
       Where Wpr.Picking_Rule_Id = Pc_Picking_Rule_Id;
    ----------------------------------
    -- Cursor das Linhas de Entrega --
    ----------------------------------
    Cursor C_New_Delivery
    (
      Pc_Moli Mdb_Otm_Lot_Invoices_All%Rowtype
     ,Pc_Wpr  Wsh_Picking_Rules%Rowtype
    ) Is
      Select Wdd.Organization_Id
            ,Wdd.Ship_From_Location_Id --Pickup_Location_Id
            ,Wdd.Ship_To_Location_Id --Dropoff_Location_Id
            ,Decode(Wsp.Autocreate_Del_Orders_Flag
                   ,'Y'
                   ,Wdd.Source_Header_Id
                   ,0) Group_By_Order
            ,Decode(Wsp.Group_By_Customer_Flag, 'Y', Wdd.Customer_Id, 0) Group_By_Customer
            ,Decode(Wsp.Group_By_Freight_Terms_Flag
                   ,'Y'
                   ,Wdd.Freight_Terms_Code
                   ,'X') Group_By_Freight
            ,Decode(Wsp.Group_By_Fob_Flag, 'Y', Wdd.Fob_Code, 'X') Group_By_Fob
            ,Decode(Wsp.Group_By_Ship_Method_Flag
                   ,'Y'
                   ,Wdd.Ship_Method_Code
                   ,'X') Group_By_Ship_Method
            ,Count(*)
        From Wsh_Delivery_Details    Wdd
            ,Oe_Order_Lines_All      Ool
            ,Ra_Site_Uses_All        Rsu
            ,Fnd_Lookup_Values       Flv_Otm_Line_Status
            ,Wsh_Shipping_Parameters Wsp
       Where Wdd.Source_Code = 'OE'
         And Wdd.Organization_Id = Pc_Wpr.Organization_Id
            -- Subinv
         And Wdd.Subinventory = Pc_Wpr.Pick_From_Subinventory
            -- Pedido
         And Wdd.Source_Header_Id =
             Nvl(Pc_Moli.Header_Id, Wdd.Source_Header_Id)
            -- Metodo de entrega 
         And Wdd.Ship_Method_Code =
             Nvl(Pc_Moli.Ship_Method_Code, Wdd.Ship_Method_Code)
            -- Site Use / Endereco
         And Rsu.Site_Use_Id = Wdd.Ship_To_Site_Use_Id
         And Rsu.Address_Id = Nvl(Pc_Moli.Address_Id, Rsu.Address_Id)
            -- Status da Entrega 
         And Wdd.Released_Status = 'Y' -- Preparação/Separação Confirmada
            -- Linha do Pedido
         And Ool.Line_Id = Wdd.Source_Line_Id
         And Ool.Schedule_Ship_Date Between
             Trunc(Pc_Moli.Schedule_Ship_Start_Date) And
             Trunc(Pc_Moli.Schedule_Ship_End_Date) + .99999
         And Ool.Booked_Flag = 'Y'
         And Ool.Open_Flag = 'Y'
         And Ool.Cancelled_Flag = 'N'
            -- Verificar se o tipo da transacao envia a linha para o OTM
         And Exists
       (Select Null
                From Mdb_Otm_Transaction_Types_All Mott
               Where Mott.Org_Id = Ool.Org_Id
                 And Mott.Transaction_Type_Id = Ool.Line_Type_Id
                 And Mott.Otm_Send_To_Flag = 'Y'
                 And Mott.Enabled_Flag = 'Y')
            -- Nao existir em um carga do OM205
         And Not Exists
       (Select Null
                From Mdb_Om_Shipment_Lines Mosl
                    ,Mdb_Om_Shipments      Mos
               Where Mos.Status_Code In (1 -- Selecionado
                                        ,2 -- Resumo de Carga
                                        ,4 -- Processando Conf. Entrega
                                        ,5 -- Problema Conf. Entrega
                                         )
                 And Mos.Shipment_Id = Mosl.Shipment_Id
                 And Mosl.Delivery_Detail_Id = Wdd.Delivery_Detail_Id)
            -- Selecionar linhas que nao tem retencao
         And Mdb_Otm_Lot_Invoices_Pk.Hold_Exists_f(Ool.Header_Id
                                                  ,Ool.Line_Id) = 'N'
            -- Verificar o status OTM da linha 
         And Flv_Otm_Line_Status.Lookup_Type = 'MDB_OTM_LINE_STATUS'
         And Flv_Otm_Line_Status.Lookup_Code =
             Nvl(Wdd.Attribute1, 'NO PROCESS')
         And Flv_Otm_Line_Status.Attribute1 = 'Y'
         And Flv_Otm_Line_Status.Enabled_Flag = 'Y'
         And Flv_Otm_Line_Status.Language = Userenv('LANG')
         And Wsp.Organization_Id = Wdd.Organization_Id
       Group By Wdd.Organization_Id
               ,Wdd.Ship_From_Location_Id --Pickup_Location_Id
               ,Wdd.Ship_To_Location_Id --Dropoff_Location_Id
               ,Decode(Wsp.Autocreate_Del_Orders_Flag
                      ,'Y'
                      ,Wdd.Source_Header_Id
                      ,0) --Group_By_Order
               ,Decode(Wsp.Group_By_Customer_Flag, 'Y', Wdd.Customer_Id, 0) --Group_By_Customer
               ,Decode(Wsp.Group_By_Freight_Terms_Flag
                      ,'Y'
                      ,Wdd.Freight_Terms_Code
                      ,'X') --Group_By_Freight
               ,Decode(Wsp.Group_By_Fob_Flag, 'Y', Wdd.Fob_Code, 'X') --Group_By_Fob
               ,Decode(Wsp.Group_By_Ship_Method_Flag
                      ,'Y'
                      ,Wdd.Ship_Method_Code
                      ,'X') --Group_By_Ship_Method
      --
      ;
    ----------------------------------
    -- Cursor das Linhas de Entrega --
    ----------------------------------
    Cursor C_Wdd
    (
      Pc_Moli                  Mdb_Otm_Lot_Invoices_All%Rowtype
     ,Pc_Wpr                   Wsh_Picking_Rules%Rowtype
     ,Pc_Ship_From_Location_Id Number
     ,Pc_Ship_To_Location_Id   Number
     ,Pc_Group_By_Order        Varchar2
     ,Pc_Group_By_Customer     Varchar2
     ,Pc_Group_By_Freight      Varchar2
     ,Pc_Group_By_Fob          Varchar2
     ,Pc_Group_By_Ship_Method  Varchar2
    ) Is
      Select Wdd.Delivery_Detail_Id
            ,Ool.Schedule_Ship_Date
            ,Ool.Header_Id
            ,Ool.Line_Id
            ,Ool.Inventory_Item_Id
            ,Wdd.Requested_Quantity_Uom
            ,Wdd.Requested_Quantity
            ,Wdd.Unit_Price
            ,Rsu.Address_Id
            ,Wdd.Ship_Method_Code
            ,Wdd.Attribute1
            ,Wdd.Attribute2
            ,Wdd.Ship_From_Location_Id
            ,Wdd.Ship_To_Location_Id
            ,Decode(Wsp.Autocreate_Del_Orders_Flag
                   ,'Y'
                   ,Wdd.Source_Header_Id
                   ,0) Group_By_Order
            ,Decode(Wsp.Group_By_Customer_Flag, 'Y', Wdd.Customer_Id, 0) Group_By_Customer
            ,Decode(Wsp.Group_By_Freight_Terms_Flag
                   ,'Y'
                   ,Wdd.Freight_Terms_Code
                   ,'X') Group_By_Freight
            ,Decode(Wsp.Group_By_Fob_Flag, 'Y', Wdd.Fob_Code, 'X') Group_By_Fob
            ,Decode(Wsp.Group_By_Ship_Method_Flag
                   ,'Y'
                   ,Wdd.Ship_Method_Code
                   ,'X') Group_By_Ship_Method
        From Wsh_Delivery_Details    Wdd
            ,Oe_Order_Lines_All      Ool
            ,Ra_Site_Uses_All        Rsu
            ,Fnd_Lookup_Values       Flv_Otm_Line_Status
            ,Wsh_Shipping_Parameters Wsp
       Where Wdd.Source_Code = 'OE'
         And Wdd.Organization_Id = Pc_Wpr.Organization_Id
            -- Subinv
         And Wdd.Subinventory = Pc_Wpr.Pick_From_Subinventory
            -- Pedido
         And Wdd.Source_Header_Id =
             Nvl(Pc_Moli.Header_Id, Wdd.Source_Header_Id)
            -- Metodo de entrega 
         And Wdd.Ship_Method_Code =
             Nvl(Pc_Moli.Ship_Method_Code, Wdd.Ship_Method_Code)
            -- Site Use / Endereco
         And Rsu.Site_Use_Id = Wdd.Ship_To_Site_Use_Id
         And Rsu.Address_Id = Nvl(Pc_Moli.Address_Id, Rsu.Address_Id)
            -- Status da Entrega 
         And Wdd.Released_Status = 'Y' -- Preparação/Separação Confirmada
            -- Linha do Pedido
         And Ool.Line_Id = Wdd.Source_Line_Id
         And Ool.Schedule_Ship_Date Between
             Trunc(Pc_Moli.Schedule_Ship_Start_Date) And
             Trunc(Pc_Moli.Schedule_Ship_End_Date) + .99999
         And Ool.Booked_Flag = 'Y'
         And Ool.Open_Flag = 'Y'
         And Ool.Cancelled_Flag = 'N'
            -- Verificar se o tipo da transacao envia a linha para o OTM
         And Exists
       (Select Null
                From Mdb_Otm_Transaction_Types_All Mott
               Where Mott.Org_Id = Ool.Org_Id
                 And Mott.Transaction_Type_Id = Ool.Line_Type_Id
                 And Mott.Otm_Send_To_Flag = 'Y'
                 And Mott.Enabled_Flag = 'Y')
            -- Nao existir em um carga do OM205
         And Not Exists
       (Select Null
                From Mdb_Om_Shipment_Lines Mosl
                    ,Mdb_Om_Shipments      Mos
               Where Mos.Status_Code In (1 -- Selecionado
                                        ,2 -- Resumo de Carga
                                        ,4 -- Processando Conf. Entrega
                                        ,5 -- Problema Conf. Entrega
                                         )
                 And Mos.Shipment_Id = Mosl.Shipment_Id
                 And Mosl.Delivery_Detail_Id = Wdd.Delivery_Detail_Id)
            -- Selecionar linhas que nao tem retencao
         And Mdb_Otm_Lot_Invoices_Pk.Hold_Exists_f(Ool.Header_Id
                                                  ,Ool.Line_Id) = 'N'
            -- Verificar o status OTM da linha 
         And Flv_Otm_Line_Status.Lookup_Type = 'MDB_OTM_LINE_STATUS'
         And Flv_Otm_Line_Status.Lookup_Code =
             Nvl(Wdd.Attribute1, 'NO PROCESS')
         And Flv_Otm_Line_Status.Attribute1 = 'Y'
         And Flv_Otm_Line_Status.Enabled_Flag = 'Y'
         And Flv_Otm_Line_Status.Language = Userenv('LANG')
         And Wsp.Organization_Id = Wdd.Organization_Id
            -- Parametros do Grupamento 
         And Wdd.Ship_From_Location_Id = Pc_Ship_From_Location_Id
         And Wdd.Ship_To_Location_Id = Pc_Ship_To_Location_Id
         And Decode(Wsp.Autocreate_Del_Orders_Flag --
                   ,'Y'
                   ,Nvl(Wdd.Source_Header_Id, 0) --
                   ,0) = Nvl(Pc_Group_By_Order, Wdd.Source_Header_Id)
         And Decode(Wsp.Group_By_Customer_Flag --
                   ,'Y'
                   ,Nvl(Wdd.Customer_Id, 0) --
                   ,0) = Nvl(Pc_Group_By_Customer, Wdd.Customer_Id)
         And Decode(Wsp.Group_By_Freight_Terms_Flag --
                   ,'Y'
                   ,Nvl(Wdd.Freight_Terms_Code, 'X') --
                   ,'X') = Pc_Group_By_Freight
         And Decode(Wsp.Group_By_Fob_Flag --
                   ,'Y'
                   ,Nvl(Wdd.Fob_Code, 'X') --
                   ,'X') = Pc_Group_By_Fob
         And Decode(Wsp.Group_By_Ship_Method_Flag --
                   ,'Y'
                   ,Nvl(Wdd.Ship_Method_Code, 'X') --
                   ,'X') =
             Nvl(Pc_Group_By_Ship_Method, Nvl(Wdd.Ship_Method_Code, 'X'))
      --
       Order By Ool.Schedule_Ship_Date;
    --------------------------------------------------------
    -- Cursor das Linhas do Lote para equalizar com a WDD --
    --------------------------------------------------------
    Cursor C_Moll(Pc_Lot_Invoice_Id Number) Is
      Select Moll.*
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id;
    -- Variaveis 
    L_r_Moll            Mdb_Otm_Lot_Lines_All%Rowtype;
    L_r_Molls_Lot       Mdb_Otm_Lot_Log_Status_All%Rowtype;
    L_n_Conc_Request_Id Number := Fnd_Global.Conc_Request_Id;
    L_n_Commit          Number := 0;
    L_n_Count_Line      Number := 0;
    -- Variaveis para BackOrder
    L_Init_Msg_List Varchar2(30);
    L_Return_Status Varchar2(30);
    L_Msg_Count     Number;
    L_Msg_Data      Varchar2(4000); -- VARCHAR2(3000);
    L_Trip_Id       Varchar2(30);
    L_Trip_Name     Varchar2(30);
    R_Trip_Info     Wsh_Trips_Pub.Trip_Pub_Rec_Type;
    --
    L_Vinit_Msg_List Varchar2(1000) := 'Y';
    L_Vmsg_Summary   Varchar2(4000); -- VARCHAR2(3000);
    L_Nmsg_Count     Number;
    L_Vmsg_Details   Varchar2(4000); -- VARCHAR2(3000);   
    --
    L_Action_Code   Varchar2(15);
    L_Delivery_Id   Number;
    L_Delivery_Name Varchar2(30);
    R_Delivery_Info Wsh_Deliveries_Pub.Delivery_Pub_Rec_Type;
    -- Parameters for WSH_DELIVERY_DETAILS_PUB.Detail_to_Delivery
    R_Tabofdeldets     Wsh_Delivery_Details_Pub.Id_Tab_Type;
    R_Tab_Wdd_Unassign Wsh_Delivery_Details_Pub.Id_Tab_Type;
    L_Action_Assign    Varchar2(30);
    L_Count            Number;
    Changed_Attributes Wsh_Delivery_Details_Pub.Changedattributetabtype;
    L_Api_Commit       Varchar2(30) := Fnd_Api.G_False;
    L_Source_Code      Varchar2(15) := 'OE';
    L_Validation_Level Number;
    -- Trip Stop
    L_Count_Trip_Stop Number;
    R_Trip_Stop       Wsh_Trip_Stops_Pub.Trip_Stop_Pub_Rec_Type;
    L_Stop_Id         Number;
    L_Arrival_Date    Date;
    L_Departure_Date  Date;
    --
    L_v_Lot_Invoice_Num Varchar2(300);
    L_d_Sysdate         Date := Sysdate;
    --
    R_Action_Param_Trip Wsh_Trips_Pub.Action_Param_Rectype;
    --
    L_r_Molls_Line Mdb_Otm_Line_Log_Status_All%Rowtype;
    L_r_Wda        Wsh_Delivery_Assignments %Rowtype;
  Begin
    ----------------------------------
    -- Cursor para de Lote de Corte --
    ----------------------------------
    For R_Moli In C_Moli(Pc_Lot_Invoice_Id => P_Lot_Invoice_Id)
    Loop
      ----------------------------------------------------------
      -- Procedure para Recuperar as linhas e retirar do Lote --
      ----------------------------------------------------------
      Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p(P_Lot_Invoice_Id => R_Moli.Lot_Invoice_Id);
      -- Se estiver processando fora do app
      If L_n_Conc_Request_Id != -1
      Then
        L_v_Lot_Invoice_Num := R_Moli.Lot_Invoice_Num || '.' ||
                               L_n_Conc_Request_Id;
      Else
        L_v_Lot_Invoice_Num := R_Moli.Lot_Invoice_Num || '.' ||
                               To_Char(Sysdate, 'DD.MM.YYYY.HH24.MI.SS');
      End If;
      ------------------------
      -- Regra de Separacao --
      ------------------------
      For R_Wpv In C_Wpv(Pc_Picking_Rule_Id => R_Moli.Picking_Rule_Id)
      Loop
        --------------------
        ---- Create TRIP ---
        --------------------
        Wsh_Trips_Pub.Create_Update_Trip(P_Api_Version_Number => 1.0 --
                                        ,P_Init_Msg_List      => L_Init_Msg_List --
                                        ,X_Return_Status      => L_Return_Status --
                                        ,X_Msg_Count          => L_Msg_Count --
                                        ,X_Msg_Data           => L_Msg_Data --
                                        ,P_Action_Code        => 'CREATE' --
                                        ,P_Trip_Name          => L_v_Lot_Invoice_Num --
                                        ,P_Trip_Info          => R_Trip_Info --
                                        ,X_Trip_Id            => L_Trip_Id --
                                        ,X_Trip_Name          => L_Trip_Name --
                                         );
        If (L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Error Or
           L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Unexp_Error)
        Then
          Wsh_Util_Core.Get_Messages(P_Init_Msg_List => L_Vinit_Msg_List --
                                    ,X_Summary       => L_Vmsg_Summary --
                                    ,X_Details       => L_Vmsg_Details --
                                    ,X_Count         => L_Nmsg_Count --
                                     );
          If L_Msg_Count > 1
          Then
            -- MDB_OM_007C_004 - Chamada Wsh_Trips_Pub.Create_Update_Trip : 
            L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                   ,'MDB_OM_007C_004') ||
                                             L_Vmsg_Summary ||
                                             L_Vmsg_Details
                                            ,1
                                            ,4000);
          Else
            -- MDB_OM_007C_004 - Chamada Wsh_Trips_Pub.Create_Update_Trip :             
            L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                   ,'MDB_OM_007C_004') ||
                                             L_Vmsg_Summary
                                            ,1
                                            ,4000);
          End If;
          Exit; -- Se ocorrer erro sai do Loop
        End If;
        L_Action_Code := 'CREATE';
        ----------------------------------
        -- Cursor das Linhas de Entrega --
        ----------------------------------
        If L_r_Molls_Lot.Comments Is Null
        Then
          For R_Nd In C_New_Delivery(Pc_Moli => R_Moli, Pc_Wpr => R_Wpv)
          Loop
            -- Criar a Deliverie
            R_Delivery_Info.Customer_Id                  := R_Nd.Group_By_Customer;
            R_Delivery_Info.Organization_Id              := R_Moli.Organization_Id;
            R_Delivery_Info.Initial_Pickup_Location_Id   := R_Nd.Ship_From_Location_Id;
            R_Delivery_Info.Ultimate_Dropoff_Location_Id := R_Nd.Ship_To_Location_Id;
            R_Delivery_Info.Ship_Method_Code             := R_Nd.Group_By_Ship_Method;
            R_Delivery_Info.Freight_Terms_Code           := R_Nd.Group_By_Freight;
            R_Delivery_Info.Fob_Code                     := R_Nd.Group_By_Fob;
            R_Delivery_Info.Global_Attribute_Category    := 'JL.BR.WSHFSTRX.DLVY';
            R_Delivery_Info.Global_Attribute4            := ''; --R_Wdd.Vehicle_Uf; -- Código do Estado da Placa do Veículo
            R_Delivery_Info.Global_Attribute6            := ''; --R_Wdd.Vehicle_Number_Trailer; -- Placa do Cavalo Mecânico
            R_Delivery_Info.Global_Attribute7            := ''; --R_Wdd.Vehicle_Uf_Trailer; -- Código do Estado da Placa do Cavalo Mecânico
            -------------------------------------------------------
            -- Call to WSH_DELIVERIES_PUB.CREATE_UPDATE_DELIVERY --
            -------------------------------------------------------
            Wsh_Deliveries_Pub.Create_Update_Delivery(P_Api_Version_Number => 1.0 --
                                                     ,P_Init_Msg_List      => L_Init_Msg_List --
                                                     ,X_Return_Status      => L_Return_Status --
                                                     ,X_Msg_Count          => L_Msg_Count --
                                                     ,X_Msg_Data           => L_Msg_Data --
                                                     ,P_Action_Code        => L_Action_Code --
                                                     ,P_Delivery_Info      => R_Delivery_Info --
                                                     ,X_Delivery_Id        => L_Delivery_Id --
                                                     ,X_Name               => L_Delivery_Name --
                                                      );
            If (L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Error Or
               L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Unexp_Error)
            Then
              Wsh_Util_Core.Get_Messages(P_Init_Msg_List => L_Vinit_Msg_List --
                                        ,X_Summary       => L_Vmsg_Summary --
                                        ,X_Details       => L_Vmsg_Details --
                                        ,X_Count         => L_Nmsg_Count --
                                         );
              If L_Msg_Count > 1
              Then
                -- MDB_OM_007C_005 - Chamada Wsh_Deliveries_Pub.Create_Update_Delivery : 
                L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                       ,'MDB_OM_007C_005') ||
                                                 L_Vmsg_Summary ||
                                                 L_Vmsg_Details
                                                ,1
                                                ,4000);
              Else
                -- MDB_OM_007C_005 - Chamada Wsh_Deliveries_Pub.Create_Update_Delivery : 
                L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                       ,'MDB_OM_007C_005') ||
                                                 L_Vmsg_Summary
                                                ,1
                                                ,4000);
              End If;
              Exit; -- Se ocorrer erro sai do Loop
            End If;
            ----------------------
            -- Se null continua --
            -- Recuperar as WDD --
            ----------------------
            If L_r_Molls_Lot.Comments Is Null
            Then
              L_Count := 1;
              R_Tabofdeldets.Delete;
              For R_Wdd In C_Wdd(Pc_Moli                  => R_Moli --
                                ,Pc_Wpr                   => R_Wpv --
                                ,Pc_Ship_From_Location_Id => R_Nd.Ship_From_Location_Id --
                                ,Pc_Ship_To_Location_Id   => R_Nd.Ship_To_Location_Id --
                                ,Pc_Group_By_Order        => R_Nd.Group_By_Order --
                                ,Pc_Group_By_Customer     => R_Nd.Group_By_Customer --
                                ,Pc_Group_By_Freight      => Nvl(R_Nd.Group_By_Freight
                                                                ,'X') --
                                ,Pc_Group_By_Fob          => Nvl(R_Nd.Group_By_Fob
                                                                ,'X') --
                                ,Pc_Group_By_Ship_Method  => R_Nd.Group_By_Ship_Method --
                                 )
              Loop
                --- Backorder All
                Changed_Attributes(L_Count).Shipped_Quantity := 0;
                Changed_Attributes(L_Count).Cycle_Count_Quantity := R_Wdd.Requested_Quantity;
                Changed_Attributes(L_Count).Delivery_Detail_Id := R_Wdd.Delivery_Detail_Id;
                Changed_Attributes(L_Count).Attribute1 := 'NO PROCESS';
                Changed_Attributes(L_Count).Attribute2 := Null;
                --Call to WSH_DELIVERY_DETAILS_PUB.Update_Shipping_Attributes.
                Wsh_Delivery_Details_Pub.Update_Shipping_Attributes(P_Api_Version_Number => 1.0 --
                                                                   ,P_Init_Msg_List      => L_Init_Msg_List --
                                                                   ,P_Commit             => L_Api_Commit --
                                                                   ,X_Return_Status      => L_Return_Status --
                                                                   ,X_Msg_Count          => L_Msg_Count --
                                                                   ,X_Msg_Data           => L_Msg_Data --
                                                                   ,P_Changed_Attributes => Changed_Attributes --
                                                                   ,P_Source_Code        => L_Source_Code --
                                                                    );
                If (L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Error Or
                   L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Unexp_Error)
                Then
                  Wsh_Util_Core.Get_Messages(P_Init_Msg_List => L_Vinit_Msg_List --
                                            ,X_Summary       => L_Vmsg_Summary --
                                            ,X_Details       => L_Vmsg_Details --
                                            ,X_Count         => L_Nmsg_Count --
                                             );
                  If L_Msg_Count > 1
                  Then
                    -- MDB_OM_007C_006 - Chamada Wsh_Delivery_Details_Pub.Update_Shipping_Attributes : 
                    L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                           ,'MDB_OM_007C_006') ||
                                                     L_Vmsg_Summary ||
                                                     L_Vmsg_Details
                                                    ,1
                                                    ,4000);
                  Else
                    -- MDB_OM_007C_006 - Chamada Wsh_Delivery_Details_Pub.Update_Shipping_Attributes : 
                    L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                           ,'MDB_OM_007C_006') ||
                                                     L_Vmsg_Summary
                                                    ,1
                                                    ,4000);
                  End If;
                  Exit; -- Se ocorrer erro sai do Loop
                End If;
                --
                -- Verifica se a WDD esta associada a alguma Delivery e dessasocia
                Begin
                  Select *
                    Into L_r_Wda
                    From Wsh_Delivery_Assignments Wda
                   Where Wda.Delivery_Detail_Id = R_Wdd.Delivery_Detail_Id;
                Exception
                  When Others Then
                    L_r_Wda := Null;
                End;
                --------------------------------------
                -- Se estiver associado a uma carga --
                --------------------------------------
                If L_r_Wda.Delivery_Id Is Not Null
                Then
                  -- Call to WSH_DELIVERY_DETAILS_PUB.Detail_to_Delivery.
                  L_Action_Assign := 'UNASSIGN';
                  R_Tab_Wdd_Unassign(1) := R_Wdd.Delivery_Detail_Id;
                  Wsh_Delivery_Details_Pub.Detail_To_Delivery(P_Api_Version      => 1.0 --
                                                             ,P_Init_Msg_List    => L_Init_Msg_List --
                                                             ,P_Commit           => L_Api_Commit --
                                                             ,P_Validation_Level => L_Validation_Level --
                                                             ,X_Return_Status    => L_Return_Status --
                                                             ,X_Msg_Count        => L_Msg_Count --
                                                             ,X_Msg_Data         => L_Msg_Data --
                                                             ,P_Tabofdeldets     => R_Tab_Wdd_Unassign --
                                                             ,P_Action           => L_Action_Assign --
                                                             ,P_Delivery_Id      => L_r_Wda.Delivery_Id --
                                                              );
                  If (L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Error Or
                     L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Unexp_Error)
                  Then
                    Wsh_Util_Core.Get_Messages(P_Init_Msg_List => L_Vinit_Msg_List --
                                              ,X_Summary       => L_Vmsg_Summary --
                                              ,X_Details       => L_Vmsg_Details --
                                              ,X_Count         => L_Nmsg_Count --
                                               );
                    If L_Msg_Count > 1
                    Then
                      -- MDB_OM_007C_007 - Chamada Wsh_Delivery_Details_Pub.Detail_To_Delivery - UNASSIGN: 
                      L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                             ,'MDB_OM_007C_007') ||
                                                       L_Vmsg_Summary ||
                                                       L_Vmsg_Details
                                                      ,1
                                                      ,4000);
                    Else
                      -- MDB_OM_007C_007 - Chamada Wsh_Delivery_Details_Pub.Detail_To_Delivery - UNASSIGN: 
                      L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                             ,'MDB_OM_007C_007') ||
                                                       L_Vmsg_Summary
                                                      ,1
                                                      ,4000);
                    End If;
                  End If;
                End If;
                --
                R_Tabofdeldets(L_Count) := R_Wdd.Delivery_Detail_Id;
                L_Count := L_Count + 1;
                L_n_Count_Line := L_n_Count_Line + 1;
              End Loop C_Wdd;
              -- Se Null continua 
              -- Call to WSH_DELIVERY_DETAILS_PUB.Detail_to_Delivery - Inicio
              If L_r_Molls_Lot.Comments Is Null
              Then
                -- Call to WSH_DELIVERY_DETAILS_PUB.Detail_to_Delivery.
                L_Action_Assign := 'ASSIGN';
                Wsh_Delivery_Details_Pub.Detail_To_Delivery(P_Api_Version      => 1.0 --
                                                           ,P_Init_Msg_List    => L_Init_Msg_List --
                                                           ,P_Commit           => L_Api_Commit --
                                                           ,P_Validation_Level => L_Validation_Level --
                                                           ,X_Return_Status    => L_Return_Status --
                                                           ,X_Msg_Count        => L_Msg_Count --
                                                           ,X_Msg_Data         => L_Msg_Data --
                                                           ,P_Tabofdeldets     => R_Tabofdeldets --
                                                           ,P_Action           => L_Action_Assign --
                                                           ,P_Delivery_Id      => L_Delivery_Id --
                                                            );
                If (L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Error Or
                   L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Unexp_Error)
                Then
                  Wsh_Util_Core.Get_Messages(P_Init_Msg_List => L_Vinit_Msg_List --
                                            ,X_Summary       => L_Vmsg_Summary --
                                            ,X_Details       => L_Vmsg_Details --
                                            ,X_Count         => L_Nmsg_Count --
                                             );
                  If L_Msg_Count > 1
                  Then
                    -- MDB_OM_007C_008 - Chamada Wsh_Delivery_Details_Pub.Detail_To_Delivery : 
                    L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                           ,'MDB_OM_007C_008') ||
                                                     L_Vmsg_Summary ||
                                                     L_Vmsg_Details
                                                    ,1
                                                    ,4000);
                  Else
                    -- MDB_OM_007C_008 - Chamada Wsh_Delivery_Details_Pub.Detail_To_Delivery : 
                    L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                           ,'MDB_OM_007C_008') ||
                                                     L_Vmsg_Summary
                                                    ,1
                                                    ,4000);
                  End If;
                  Exit; -- Sai do Loop
                End If;
              Else
                Exit; -- Sai do Loop  
              End If; -- If L_r_Molls_Lot.Comments Is Null Then        
              -- Call to WSH_DELIVERY_DETAILS_PUB.Detail_to_Delivery. -- Fim
              -----------------------------------------
              -- Se Null continua                    -- 
              -- Verifica se tem Trip_Stop -- Inicio --
              -----------------------------------------              
              If L_r_Molls_Lot.Comments Is Null
              Then
                Begin
                  Select Count(*)
                    Into L_Count_Trip_Stop
                    From Wsh_Trip_Stops Wts
                        ,Wsh_Trips      Wt
                   Where Wts.Stop_Location_Id = R_Nd.Ship_From_Location_Id
                     And Wts.Trip_Id = Wt.Trip_Id
                     And Wt.Name = L_v_Lot_Invoice_Num;
                  --   
                  If L_Count_Trip_Stop = 0
                  Then
                    R_Trip_Stop.Planned_Arrival_Date   := Sysdate + 1;
                    R_Trip_Stop.Planned_Departure_Date := Sysdate + 1;
                    --- Create New Stop Pickup
                    Wsh_Trip_Stops_Pub.Create_Update_Stop(P_Api_Version_Number => 1.0 --
                                                         ,P_Init_Msg_List      => L_Init_Msg_List --
                                                         ,X_Return_Status      => L_Return_Status --
                                                         ,X_Msg_Count          => L_Msg_Count --
                                                         ,X_Msg_Data           => L_Msg_Data --
                                                         ,P_Action_Code        => 'CREATE' --
                                                         ,P_Stop_Info          => R_Trip_Stop --
                                                         ,P_Trip_Name          => L_v_Lot_Invoice_Num --
                                                         ,P_Stop_Location_Id   => R_Nd.Ship_From_Location_Id --
                                                         ,X_Stop_Id            => L_Stop_Id --
                                                          );
                    If (L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Error Or
                       L_Return_Status =
                       Wsh_Util_Core.G_Ret_Sts_Unexp_Error)
                    Then
                      If L_Msg_Count > 1
                      Then
                        -- MDB_OM_007C_009 - Chamada Wsh_Trip_Stops_Pub.Create_Update_Stop :
                        L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                               ,'MDB_OM_007C_009') ||
                                                         L_Vmsg_Summary ||
                                                         L_Vmsg_Details
                                                        ,1
                                                        ,4000);
                      Else
                        -- MDB_OM_007C_009 - Chamada Wsh_Trip_Stops_Pub.Create_Update_Stop :
                        L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                               ,'MDB_OM_007C_009') ||
                                                         L_Vmsg_Summary
                                                        ,1
                                                        ,4000);
                      End If;
                      Exit; -- Sai do Loop
                    End If;
                  End If;
                Exception
                  When Others Then
                    -- MDB_OM_007C_010 - Wsh_Trip_Stops_Pub.Create_Update_Stop - Erro sql trip stop: 
                    L_r_Molls_Lot.Comments := Fnd_Message.Get_String('MDB'
                                                                    ,'MDB_OM_007C_010') ||
                                              Sqlerrm;
                    Exit; -- Sai do Loop
                End;
                L_Arrival_Date                     := R_Trip_Stop.Planned_Departure_Date +
                                                      (1 / 24 / 60);
                L_Departure_Date                   := R_Trip_Stop.Planned_Departure_Date +
                                                      (1 / 24 / 60);
                R_Trip_Stop.Planned_Arrival_Date   := L_Arrival_Date;
                R_Trip_Stop.Planned_Departure_Date := L_Departure_Date;
                --- Create New Stop Dropoff
                Wsh_Trip_Stops_Pub.Create_Update_Stop(P_Api_Version_Number => 1.0 --
                                                     ,P_Init_Msg_List      => L_Init_Msg_List --
                                                     ,X_Return_Status      => L_Return_Status --
                                                     ,X_Msg_Count          => L_Msg_Count --
                                                     ,X_Msg_Data           => L_Msg_Data --
                                                     ,P_Action_Code        => 'CREATE' --
                                                     ,P_Stop_Info          => R_Trip_Stop --
                                                     ,P_Trip_Name          => L_v_Lot_Invoice_Num --
                                                     ,P_Stop_Location_Id   => R_Nd.Ship_To_Location_Id --
                                                     ,X_Stop_Id            => L_Stop_Id --
                                                      );
                If (L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Error Or
                   L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Unexp_Error)
                Then
                  If L_Msg_Count > 1
                  Then
                    -- MDB_OM_007C_009 - Chamada Wsh_Trip_Stops_Pub.Create_Update_Stop :
                    L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                           ,'MDB_OM_007C_009') ||
                                                     L_Vmsg_Summary ||
                                                     L_Vmsg_Details
                                                    ,1
                                                    ,4000);
                  Else
                    -- MDB_OM_007C_009 - Chamada Wsh_Trip_Stops_Pub.Create_Update_Stop :
                    L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                           ,'MDB_OM_007C_009') ||
                                                     L_Vmsg_Summary
                                                    ,1
                                                    ,4000);
                  End If;
                  Exit; -- Sai do Loop
                End If;
                ------------------------------
                --- Assign Delivery to Trip --
                ------------------------------
                Wsh_Deliveries_Pub.Delivery_Action(P_Api_Version_Number => 1.0 --
                                                  ,P_Init_Msg_List      => L_Init_Msg_List --
                                                  ,X_Return_Status      => L_Return_Status --
                                                  ,X_Msg_Count          => L_Msg_Count --
                                                  ,X_Msg_Data           => L_Msg_Data --
                                                  ,P_Action_Code        => 'ASSIGN-TRIP' --
                                                  ,P_Delivery_Id        => L_Delivery_Id --
                                                  ,P_Asg_Trip_Id        => L_Trip_Id --
                                                  ,P_Asg_Trip_Name      => L_v_Lot_Invoice_Num --
                                                  ,X_Trip_Id            => L_Trip_Id --
                                                  ,X_Trip_Name          => L_Trip_Name --
                                                   );
                If (L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Error Or
                   L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Unexp_Error)
                Then
                  If L_Msg_Count > 1
                  Then
                    -- MDB_OM_007C_012 - Chamada Wsh_Deliveries_Pub.Delivery_Action : 
                    L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                           ,'MDB_OM_007C_012') ||
                                                     L_Vmsg_Summary ||
                                                     L_Vmsg_Details
                                                    ,1
                                                    ,4000);
                  Else
                    -- MDB_OM_007C_012 - Chamada Wsh_Deliveries_Pub.Delivery_Action : 
                    L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                           ,'MDB_OM_007C_012') ||
                                                     L_Vmsg_Summary
                                                    ,1
                                                    ,4000);
                  End If;
                  Exit; -- Sai do Loop
                End If;
              End If; -- If L_r_Molls_Lot.Comments Is Null Then
              -------------------------------
              -- Verifica se tem Trip_Stop -- Fim              
              -------------------------------
            End If;
          End Loop C_New_Delivery;
          --------------------------------------
          -- Se nao tiver comentario continua --
          -- Confirma o BackOrder             -- Inicio
          --------------------------------------
          If L_r_Molls_Lot.Comments Is Null And
             L_n_Count_Line > 0
          Then
            R_Action_Param_Trip.Action_Code := 'TRIP-CONFIRM';
            R_Action_Param_Trip.Action_Flag := 'C';
            Wsh_Trips_Pub.Trip_Action(P_Api_Version_Number => 1.0 --
                                     ,P_Init_Msg_List      => L_Init_Msg_List --
                                     ,P_Commit             => L_Api_Commit --
                                     ,X_Return_Status      => L_Return_Status --
                                     ,X_Msg_Count          => L_Msg_Count --
                                     ,X_Msg_Data           => L_Msg_Data --
                                     ,P_Action_Param_Rec   => R_Action_Param_Trip --
                                     ,P_Trip_Name          => L_v_Lot_Invoice_Num --
                                      );
            --
            If (L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Error Or
               L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Unexp_Error)
            Then
              -- MDB_OM_007C_013 - Chamada Wsh_Trips_Pub.Trip_Action : 
              L_r_Molls_Lot.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                     ,'MDB_OM_007C_013') ||
                                               L_Msg_Data
                                              ,1
                                              ,4000);
            End If;
            --------------------------
          End If; -- If L_r_Molls_Lot.Comments Is Null Then
          --------------------------------------
          -- Confirma o BackOrder             -- Fim
          --------------------------------------
        End If; -- If L_r_Molls_Lot.Comments Is Null Then
      End Loop C_Wpv;
      --------------------------------------------------------
      -- Cursor das Linhas do Lote para equalizar com a WDD --
      --------------------------------------------------------
      L_n_Commit := 0;
      For R_Moll In C_Moll(Pc_Lot_Invoice_Id => P_Lot_Invoice_Id)
      Loop
        -- Bucar a quantidade para ver se foi alterada
        Begin
          Select Wdd.Requested_Quantity
            Into L_r_Moll.Requested_Quantity
            From Wsh_Delivery_Details Wdd
           Where Delivery_Detail_Id = R_Moll.Delivery_Detail_Id;
          -- Atualiza quantidade se estiver diferente
          If L_r_Moll.Requested_Quantity != R_Moll.Requested_Quantity
          Then
            -- Atualizar a Quantidade
            Update Mdb_Otm_Lot_Lines_All Moll
               Set Moll.Requested_Quantity = L_r_Moll.Requested_Quantity
             Where Moll.Lot_Line_Id = R_Moll.Lot_Line_Id;
          End If;
        Exception
          When No_Data_Found Then
            -- Deleta linha pq a WDD nao existe mais
            Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p --
            (P_Lot_Line_Id => R_Moll.Lot_Line_Id -- 
            ,P_Comments    => 'Linha Excluida porque a Linha de Entrega (WDD) foi Excluida' --
             );
        End;
        -- Controla o commit
        L_n_Commit := L_n_Commit + 1;
        If L_n_Commit > 1000
        Then
          L_n_Commit := 0;
          Commit;
        End If;
      End Loop C_Moll;
      -- Atualiza o Status e Inclui o Log do Status 
      -- Trara o Status 
      If L_r_Molls_Lot.Comments Is Null
      Then
        L_r_Molls_Lot.Lot_Status_Code_To := 'COMPLETED BACKORDER ALL'; -- Backorder Total Concluído
      Else
        L_r_Molls_Lot.Lot_Status_Code_To := 'NOT COMPLETED BACKORDER ALL'; -- Backorder Total não Concluído          
      End If;
      L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
      L_r_Molls_Lot.Lot_Status_Code_From := R_Moli.Lot_Status_Code;
      L_r_Molls_Lot.Comments             := Nvl(L_r_Molls_Lot.Comments
                                               ,'Qtd.Linhas Processadas : ' ||
                                                L_n_Count_Line);
      L_r_Molls_Lot.Request_Id           := L_n_Conc_Request_Id;
      L_r_Molls_Lot.Org_Id               := R_Moli.Org_Id;
      L_r_Molls_Lot.Organization_Id      := R_Moli.Organization_Id;
      L_r_Molls_Lot.Creation_Date        := Sysdate;
      L_r_Molls_Lot.Created_By           := Fnd_Global.User_Id;
      L_r_Molls_Lot.Last_Update_Date     := Sysdate;
      L_r_Molls_Lot.Last_Updated_By      := Fnd_Global.User_Id;
      L_r_Molls_Lot.Last_Update_Login    := Fnd_Global.Login_Id;
      --
      Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
      Commit;
    End Loop C_Moli;
  Exception
    When Others Then
      -- Atualiza o Status e Inclui o Log do Status 
      L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
      L_r_Molls_Lot.Lot_Status_Code_From := 'NOT COMPLETED BACKORDER ALL'; -- Backorder Total não Concluído
      -- MDB_OM_007C_014 - Erro inesperado no BackOrder :
      L_r_Molls_Lot.Comments   := Fnd_Message.Get_String('MDB'
                                                        ,'MDB_OM_007C_014') ||
                                  Sqlerrm;
      L_r_Molls_Lot.Request_Id := L_n_Conc_Request_Id;
      L_r_Molls_Lot.Org_Id     := P_Org_Id;
      --
      Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
  End Backorder_Total_p;

  --------------------------------------------------------
  -- Procedure para processar as fases do Lote de Corte --
  --------------------------------------------------------
  -- Concorrente : MDB - OTM - Corte de Faturamento 
  -- Executavel  : MDB_OTM_LOT_MAIN
  Procedure Lot_Main_p
  (
    Errbuf           Out Varchar2
   ,Retcode          Out Number
   ,P_Org_Id         In Number
   ,P_Lot_Invoice_Id In Number
  ) Is
    ----------------------------------
    -- Cursor para de Lote de Corte --
    ----------------------------------
    Cursor C_Moli(Pc_Lot_Invoice_Id Number) Is
      Select Moli.*
        From Mdb_Otm_Lot_Invoices_All Moli
       Where Lot_Invoice_Id = Pc_Lot_Invoice_Id;
    -- Variaveis 
    L_r_Molls_Lot       Mdb_Otm_Lot_Log_Status_All%Rowtype;
    L_n_Conc_Request_Id Number := Fnd_Global.Conc_Request_Id;
    L_n_Count           Number;
    L_n_Count_Err       Number;
    L_n_Qtt_Err         Number;
    L_n_Conc_Id         NUMBER;
    L_v_msg_Schedule    VARCHAR2(2000);
  Begin
    ----------------------------------
    -- Cursor para de Lote de Corte --
    ----------------------------------
    For R_Moli In C_Moli(Pc_Lot_Invoice_Id => P_Lot_Invoice_Id)
    Loop
      ----------------------------------------------------------
      -- Procedure para Recuperar as linhas e retirar do Lote --
      ----------------------------------------------------------
      Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p(P_Lot_Invoice_Id => R_Moli.Lot_Invoice_Id);
      -- Atualiza status comentando a Fase
      -- Atualiza o Status e Inclui o Log do Status 
      L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
      L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
      L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
      -- MDB_OM_007C_015 - Fase 10 - Validação das Configurações iniciada
      L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                             ,'MDB_OM_007C_015');
      L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
      L_r_Molls_Lot.Org_Id          := P_Org_Id;
      L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
      --
      Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
      -- Valida o Lote x Setup 
      Mdb_Otm_Lot_Invoices_Pk.Lot_Validation_p(P_Moli => R_Moli);
      ----------------------------------------------
      -- Verifica se teve algum erro na validacao --
      ----------------------------------------------
      Select Count(*)
        Into L_n_Count
        From Mdb_Otm_Lot_Lines_All
       Where Lot_Invoice_Id = P_Lot_Invoice_Id
         And Lot_Otm_Status_Line_Code != 'SELECTED';
      -- Se nao existir nenhum erro executar a fase de SPLIT
      If L_n_Count = 0
      Then
        -- Atualiza status comentando a Fase
        -- Atualiza o Status e Inclui o Log do Status 
        L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
        L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
        L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
        -- MDB_OM_007C_016 - Fase 10 - Validação das Configurações, terminou OK
        L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                               ,'MDB_OM_007C_016');
        L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
        L_r_Molls_Lot.Org_Id          := P_Org_Id;
        L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
        Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
        Commit;
        -- ## SPLIT       
        -- Atualiza status comentando a Fase
        -- Atualiza o Status e Inclui o Log do Status 
        L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
        L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
        L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
        -- MDB_OM_007C_017 - Fase 20 - SPLIT iniciado
        L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                               ,'MDB_OM_007C_017');
        L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
        L_r_Molls_Lot.Org_Id          := P_Org_Id;
        L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
        --
        Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
        Commit;
        -- SPLIT 
        Mdb_Otm_Lot_Invoices_Pk.Lot_Split_Select_p(P_Moli => R_Moli);
        ------------------------------------------
        -- Verifica se teve algum erro no SPLIT --
        ------------------------------------------
        Select Count(*)
          Into L_n_Count
          From Mdb_Otm_Lot_Lines_All
         Where Lot_Invoice_Id = P_Lot_Invoice_Id
           And Lot_Otm_Status_Line_Code = 'SPLIT ERROR';
        -- 
        If L_n_Count = 0
        Then
          -- Atualiza status comentando a Fase
          -- Atualiza o Status e Inclui o Log do Status 
          L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
          L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
          L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
          -- MDB_OM_007C_018 - Fase 20 - SPLIT, terminou OK
          L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                 ,'MDB_OM_007C_018');
          L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
          L_r_Molls_Lot.Org_Id          := P_Org_Id;
          L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
          Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
          -- ## Ajusta Data de Entrega Programada
          -- Atualiza status comentando a Fase
          -- Atualiza o Status e Inclui o Log do Status 
          L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
          L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
          L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
          -- MDB_OM_007C_019 - Fase 30 - Alteração de Data de Entrega Programada iniciado
          L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                 ,'MDB_OM_007C_019');
          L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
          L_r_Molls_Lot.Org_Id          := P_Org_Id;
          L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
          --
          Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
          -- Analiza Data de Entrega Programada
          Mdb_Otm_Lot_Invoices_Pk.Schedule_Ship_Date_Select_p(R_Moli,L_v_msg_Schedule,L_n_Qtt_Err);
          -- Verificar se tem erro de Schedule --
          Select Sum(Decode(Lot_Otm_Status_Line_Code --
                           ,'SCHEDULE DATE ERROR' --
                           ,1
                           ,0))
                ,Sum(Decode(Lot_Otm_Status_Line_Code --
                           ,'SCHEDULE DATE ERROR' --
                           ,0
                           ,1))
            Into L_n_Count_Err
                ,L_n_Count
            From Mdb_Otm_Lot_Lines_All
           Where Lot_Invoice_Id = P_Lot_Invoice_Id;
          --And Lot_Otm_Status_Line_Code = 'SCHEDULE DATE ERROR';
          --
          If L_n_Count_Err = 0 And
             L_n_Count > 0     AND
             L_n_Qtt_Err <= 0
          Then
            -- Atualiza status comentando a Fase
            -- Atualiza o Status e Inclui o Log do Status 
            L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
            L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
            L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
            -- MDB_OM_007C_020 - Fase 30 - Alteração de Data de Entrega Programada, terminou OK
            L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                   ,'MDB_OM_007C_020');
            L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
            L_r_Molls_Lot.Org_Id          := P_Org_Id;
            L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
            -- Atualiza status comentando a Fase
            -- Atualiza o Status e Inclui o Log do Status 
            L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
            L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
            L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
            -- MDB_OM_007C_021 - Fase 40 - Validação da Quantidade Mínima de Entrega iniciada
            L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                   ,'MDB_OM_007C_021');
            L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
            L_r_Molls_Lot.Org_Id          := P_Org_Id;
            L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
            Commit;
            Mdb_Otm_Lot_Invoices_Pk.Min_Delivery_Validation_p(P_Moli => R_Moli);
            ------------------------------------------------------
            -- Verifica se teve ainda tem linhas para processar --
            ------------------------------------------------------
            Select Count(*)
              Into L_n_Count
              From Mdb_Otm_Lot_Lines_All
             Where Lot_Invoice_Id = P_Lot_Invoice_Id
               And Lot_Otm_Status_Line_Code = 'SELECTED';
            -- Se tiver linhas para processar termina a fase e começa a de separacao   
            If L_n_Count > 0
            Then
              -- Atualiza status comentando a Fase
              -- Atualiza o Status e Inclui o Log do Status 
              L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
              L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
              L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
              -- MDB_OM_007C_022 - Fase 50 - Validação da Quantidade Mínima de Entrega terminou e existem no lote - linha(s) :
              L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                     ,'MDB_OM_007C_022') ||
                                               L_n_Count;
              L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
              L_r_Molls_Lot.Org_Id          := P_Org_Id;
              L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
              Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
              -- Incia o processo de separacao --
              -- Atualiza status comentando a Fase
              -- Atualiza o Status e Inclui o Log do Status 
              L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
              L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
              L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
              -- MDB_OM_007C_023 - Fase 60 - Separação iniciado
              L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                     ,'MDB_OM_007C_023');
              L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
              L_r_Molls_Lot.Org_Id          := P_Org_Id;
              L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
              Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
              Commit;
              ----------------------------------------------------------------
              -- Procedure para Recuperar as linhas para separar do Estoque --
              ----------------------------------------------------------------
              Mdb_Otm_Lot_Invoices_Pk.Picking_Batch_Select_p(P_Moli => R_Moli);
              ------------------------------------------------------
              -- Verifica se teve ainda tem linhas para processar --
              ------------------------------------------------------
              Select Count(*)
                Into L_n_Count
                From Mdb_Otm_Lot_Lines_All
               Where Lot_Invoice_Id = P_Lot_Invoice_Id
                 And Lot_Otm_Status_Line_Code = 'PICKING ERROR'; -- Erro na Separação
              If L_n_Count = 0
              Then
                -- Atualiza status comentando a Fase
                -- Atualiza o Status e Inclui o Log do Status 
                L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
                L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
                -- MDB_OM_007C_024 - Fase 60 - Separação, terminou OK
                L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                       ,'MDB_OM_007C_024');
                L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
                L_r_Molls_Lot.Org_Id          := P_Org_Id;
                L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
                -- Atualiza o Status e Inclui o Log do Status 
                L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
                L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
                -- MDB_OM_007C_025 - Fase 70 - Analise de Indivisibilidade iniciado
                L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                       ,'MDB_OM_007C_025');
                L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
                L_r_Molls_Lot.Org_Id          := P_Org_Id;
                L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
                Commit;
                Mdb_Otm_Lot_Invoices_Pk.Indivisible_Select_p(P_Moli => R_Moli);
                ------------------------------------------------------
                -- Verifica se teve ainda tem linhas para processar --
                ------------------------------------------------------
                Select Count(*)
                  Into L_n_Count
                  From Mdb_Otm_Lot_Lines_All
                 Where Lot_Invoice_Id = P_Lot_Invoice_Id
                   And Lot_Otm_Status_Line_Code = 'INDIVISIBLE ERROR'; -- Erro no processo de Indivisibilidade de Quantidade no Método de Entrega
                --
                If L_n_Count = 0
                Then
                  -- Atualiza status comentando a Fase
                  -- Atualiza o Status e Inclui o Log do Status 
                  L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                  L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
                  L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
                  -- MDB_OM_007C_026 - Fase 70 - Analise de Indivisibilidade, terminou OK
                  L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                         ,'MDB_OM_007C_026');
                  L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
                  L_r_Molls_Lot.Org_Id          := P_Org_Id;
                  L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                  Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
                  -- Atualiza status comentando a Fase
                  -- Atualiza o Status e Inclui o Log do Status 
                  L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                  L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
                  L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
                  -- MDB_OM_007C_060 - Fase 75 - Validação de Fracionamento iniciado
                  L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                         ,'MDB_OM_007C_060');
                  L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
                  L_r_Molls_Lot.Org_Id          := P_Org_Id;
                  L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                  Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
                  --
                  -- Processo de atualizacao de Validacao do Fracionamento
                  Mdb_Otm_Lot_Invoices_Pk.Secondary_Validation_p(P_Moli => R_Moli);
                  --
                  Select Count(*)
                    Into L_n_Count
                    From Mdb_Otm_Lot_Lines_All
                   Where Lot_Invoice_Id = P_Lot_Invoice_Id
                     And Lot_Otm_Status_Line_Code =
                         'FRACTIONAL SECONDARY ERROR';
                  --
                  If L_n_Count = 0
                  Then
                    -- Atualiza o Status e Inclui o Log do Status 
                    L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                    L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
                    L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING'; -- Corte de Faturamento Concluído
                    --  MDB_OM_007C_061 - Fase 75 - Validação de Fracionamento, terminou OK
                    L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                           ,'MDB_OM_007C_061');
                    L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
                    L_r_Molls_Lot.Org_Id          := P_Org_Id;
                    L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                    Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
                    -- Atualiza status comentando a Fase
                    -- Atualiza o Status e Inclui o Log do Status 
                    L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                    L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
                    L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING';
                    -- MDB_OM_007C_027 - Fase 80 - Atualização de Status para Enviar para OTM iniciado
                    L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                           ,'MDB_OM_007C_027');
                    L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
                    L_r_Molls_Lot.Org_Id          := P_Org_Id;
                    L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                    Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
                    --
                    -- Processo de atualizacao de status para liberar para OTM
                    Mdb_Otm_Lot_Invoices_Pk.Send_Otm_Update_p(P_Moli => R_Moli);
                    --
                    Select Count(*)
                      Into L_n_Count
                      From Mdb_Otm_Lot_Lines_All
                     Where Lot_Invoice_Id = P_Lot_Invoice_Id;
                    --
                    If L_n_Count > 0
                    Then
                      -- Atualiza o Status e Inclui o Log do Status 
                      L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                      L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
                      L_r_Molls_Lot.Lot_Status_Code_To   := 'WAITING COURT BILLING'; -- Corte de Faturamento Concluído
                      -- MDB_OM_007C_028 - Fase 80 - Atualização de Status para Enviar para OTM, terminou OK, Lote Concluido - linha(s) processada(s) : 
                      L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                             ,'MDB_OM_007C_028') ||
                                                       L_n_Count;
                      L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
                      L_r_Molls_Lot.Org_Id          := P_Org_Id;
                      L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                      Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
                      ----------------------------------------------------------------
                      -- Chama o Concorrente para preparar os pedidos do GAP OM008A --
                      -- Concorrente : MDB - OTM - Remessa - Geração de Pedidos     --
                      ----------------------------------------------------------------
                      L_n_Conc_Id := Fnd_Request.Submit_Request('MDB' --
                                                               ,'MDB_OTM_LOT_CREATE_RELEASE' --
                                                               ,'Lote de Corte' --
                                                               ,'' --
                                                               ,False --
                                                               ,P_Org_Id ---ORG_ID
                                                               ,R_Moli.Organization_Id -- ORGANIZATION_ID
                                                               ,P_Lot_Invoice_Id -- LOT_INVOICE_ID
                                                               ,'' -- HEADER_ID
                                                               ,Chr(0) --
                                                                );
                      If (L_n_Conc_Id = 0)
                      Then
                        --
                        -- Atualiza o Status e Inclui o Log do Status 
                        L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                        L_r_Molls_Lot.Lot_Status_Code_From := 'COMPLETED COURT BILLING';
                        L_r_Molls_Lot.Lot_Status_Code_To   := 'COMPLETED COURT BILLING'; -- Corte de Faturamento Concluído
                        -- MDB_OM_007C_029 - Fase 90 - Concorrente MDB - OTM - Remessa - Geração de Pedidos, não foi submetido : 
                        L_r_Molls_Lot.Comments        := Substr(Fnd_Message.Get_String('MDB'
                                                                                      ,'MDB_OM_007C_029') ||
                                                                Fnd_Message.Get
                                                               ,1
                                                               ,1900);
                        L_r_Molls_Lot.Request_Id      := L_n_Conc_Id;
                        L_r_Molls_Lot.Org_Id          := P_Org_Id;
                        L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                        Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
                      Else
                        -- Atualiza o Status e Inclui o Log do Status 
                        L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                        L_r_Molls_Lot.Lot_Status_Code_From := 'COMPLETED COURT BILLING';
                        L_r_Molls_Lot.Lot_Status_Code_To   := 'COMPLETED COURT BILLING'; -- Corte de Faturamento Concluído
                        -- MDB_OM_007C_030 - Fase 90 - Concorrente MDB - OTM - Remessa - Geração de Pedidos submetido com sucesso
                        L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                               ,'MDB_OM_007C_030');
                        L_r_Molls_Lot.Request_Id      := L_n_Conc_Id;
                        L_r_Molls_Lot.Org_Id          := P_Org_Id;
                        L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                        Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
                      End If; --- l_nconc_id  
                    Else
                      -- Atualiza o Status e Inclui o Log do Status 
                      L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                      L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
                      L_r_Molls_Lot.Lot_Status_Code_To   := 'NOT COMPLETED COURT BILLING';
                      -- MDB_OM_007C_031 - Fase 80 - Atualização de Status para Enviar para OTM, terminou, mas não encontrou linhas no Lote
                      L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                             ,'MDB_OM_007C_031');
                      L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
                      L_r_Molls_Lot.Org_Id          := P_Org_Id;
                      L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                      Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
                    End If;
                  Else
                    -- Atualiza o Status e Inclui o Log do Status 
                    L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                    L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
                    L_r_Molls_Lot.Lot_Status_Code_To   := 'NOT COMPLETED COURT BILLING';
                    -- MDB_OM_007C_063 - Fase 75 - Validação de Fracionamento, terminou com erro
                    L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                           ,'MDB_OM_007C_063');
                    L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
                    L_r_Molls_Lot.Org_Id          := P_Org_Id;
                    L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                    Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
                  End If;
                  --
                  Commit;
                  --                  
                Else
                  -- Atualiza status comentando a Fase
                  -- Atualiza o Status e Inclui o Log do Status 
                  L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                  L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
                  L_r_Molls_Lot.Lot_Status_Code_To   := 'NOT COMPLETED COURT BILLING';
                  -- MDB_OM_007C_032 - Fase 70 - Analise de Indivisibilidade não concluido
                  L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                         ,'MDB_OM_007C_032');
                  L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
                  L_r_Molls_Lot.Org_Id          := P_Org_Id;
                  L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                  Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
                  Commit;
                End If;
              Else
                -- Atualiza status comentando a Fase
                -- Atualiza o Status e Inclui o Log do Status 
                L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
                L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
                L_r_Molls_Lot.Lot_Status_Code_To   := 'NOT COMPLETED COURT BILLING';
                -- MDB_OM_007C_033 - Fase 60 - Separação não concluido
                L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                       ,'MDB_OM_007C_033');
                L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
                L_r_Molls_Lot.Org_Id          := P_Org_Id;
                L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
                Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
              End If;
              Commit;
            Else
              -- Atualiza status comentando a Fase
              -- Atualiza o Status e Inclui o Log do Status 
              L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
              L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
              L_r_Molls_Lot.Lot_Status_Code_To   := 'NOT COMPLETED COURT BILLING';
              -- MDB_OM_007C_034 - Fase 50 - Validação da Quantidade Mínima de Entrega terminou e não restou linhas no Lote
              L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                     ,'MDB_OM_007C_034');
              L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
              L_r_Molls_Lot.Org_Id          := P_Org_Id;
              L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
              Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
              Commit;
            End If; -- If L_n_Count > 0 Then
          Else
            -- Atualiza status comentando a Fase
            -- Atualiza o Status e Inclui o Log do Status 
            L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
            L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
            L_r_Molls_Lot.Lot_Status_Code_To   := 'NOT COMPLETED COURT BILLING';
            -- MDB_OM_007C_035 - Fase 30 - Alteração de Data de Entrega Programada terminou com erro(s) : 
            L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                   ,'MDB_OM_007C_035') ||
                                             L_n_Count_Err || ' - ERROR: ' || SUBSTR(L_v_msg_Schedule,0,1300);
            L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
            L_r_Molls_Lot.Org_Id          := P_Org_Id;
            L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
            Commit;
          End If;
        Else
          -- Atualiza status comentando a Fase
          -- Atualiza o Status e Inclui o Log do Status 
          L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
          L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
          L_r_Molls_Lot.Lot_Status_Code_To   := 'NOT COMPLETED COURT BILLING';
          -- MDB_OM_007C_036 - Fase 20 - SPLIT terminou com erro(s) : 
          L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                                 ,'MDB_OM_007C_036') ||
                                           L_n_Count;
          L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
          L_r_Molls_Lot.Org_Id          := P_Org_Id;
          L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
          Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
          Commit;
        End If;
      Else
        -- Atualiza status comentando a Fase
        -- Atualiza o Status e Inclui o Log do Status 
        L_r_Molls_Lot.Lot_Invoice_Id       := P_Lot_Invoice_Id;
        L_r_Molls_Lot.Lot_Status_Code_From := 'WAITING COURT BILLING';
        L_r_Molls_Lot.Lot_Status_Code_To   := 'NOT COMPLETED COURT BILLING';
        -- MDB_OM_007C_037 - Fase 10 - Validação das Configurações terminou com erro (s) :
        L_r_Molls_Lot.Comments        := Fnd_Message.Get_String('MDB'
                                                               ,'MDB_OM_007C_037') ||
                                         L_n_Count;
        L_r_Molls_Lot.Request_Id      := L_n_Conc_Request_Id;
        L_r_Molls_Lot.Org_Id          := P_Org_Id;
        L_r_Molls_Lot.Organization_Id := R_Moli.Organization_Id;
        Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
        Commit;
      End If;
    End Loop C_Moli;
  Exception
    When Others Then
      -- Atualiza o Status e Inclui o Log do Status 
      L_r_Molls_Lot.Lot_Invoice_Id     := P_Lot_Invoice_Id;
      L_r_Molls_Lot.Lot_Status_Code_To := 'NOT COMPLETED COURT BILLING';
      -- MDB_OM_007C_038 - Erro inesperado no Corte de Faturamento :
      L_r_Molls_Lot.Comments   := Fnd_Message.Get_String('MDB'
                                                        ,'MDB_OM_007C_038') ||
                                  Sqlerrm;
      L_r_Molls_Lot.Request_Id := L_n_Conc_Request_Id;
      L_r_Molls_Lot.Org_Id     := P_Org_Id;
      --
      Mdb_Otm_Lot_Invoices_Pk.Insert_Log_p(P_Molls => L_r_Molls_Lot);
  End Lot_Main_p;

  --------------------------------------------------------------
  -- Procedure para processar a equalizacao de linhas FASE 10 --
  --------------------------------------------------------------
  Procedure Lot_Validation_p(P_Moli Mdb_Otm_Lot_Invoices_All %Rowtype) Is
    -------------------------------------------------
    -- Cursor das Linhas com Erro para Reprocessar --
    -------------------------------------------------
    Cursor C_Moll_Repro(Pc_Lot_Invoice_Id Number) Is
      Select Moll.Rowid
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code != 'SELECTED'; -- 'SETUP NOT FOUND';
    --------------------------------
    -- Cursor dos Cliente do Lote --
    --------------------------------
    Cursor C_Moll_Add(Pc_Lot_Invoice_Id Number) Is
      Select Distinct Moll.Address_Id
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED';
    --------------------------------
    -- Cursor dos Metodos do Lote --
    --------------------------------
    Cursor C_Moll_Ship_Method(Pc_Lot_Invoice_Id Number) Is
      Select Distinct Moll.Ship_Method_Code
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED';
    ------------------------------------------
    -- Cursor das Rotas do Clientes do Lote --
    ------------------------------------------
    Cursor C_Moll_Customer_Route(Pc_Lot_Invoice_Id Number) Is
      Select Distinct Moll.Add_Customer_Route_Id
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED';
    ------------------------------
    -- Cursor dos Items do Lote --
    ------------------------------
    Cursor C_Moll_Item(Pc_Lot_Invoice_Id Number) Is
      Select Distinct Moll.Inventory_Item_Id
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED';
    ---------------------------------
    -- Cursor das Unidades do Lote --
    ---------------------------------
    Cursor C_Moll_Uom(Pc_Lot_Invoice_Id Number) Is
      Select Distinct Moll.Requested_Quantity_Uom
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED';
    -------------------------------
    -- Cursor dos Tipos de Linha -- 
    -------------------------------
    Cursor C_Moll_Line_Type(Pc_Lot_Invoice_Id Number) Is
      Select Distinct Moll.Line_Type_Id
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED';
    ----------------------------------------------
    -- Cursor das Linhas do Lote para equalizar --
    ----------------------------------------------
    Cursor C_Moll
    (
      Pc_Lot_Invoice_Id         Number
     ,Pc_Address_Id             Number
     ,Pc_Ship_Method_Code       Varchar2
     ,Pc_Add_Customer_Route_Id  Number
     ,Pc_Inventory_Item_Id      Number
     ,Pc_Requested_Quantity_Uom Varchar2
     ,Pc_Line_Type_Id           Number
    ) Is
      Select Moll.*
            ,Moll.Rowid          Rowid_Moll
            ,Wdd.Attribute1      Attribute1_Wdd
            ,Ooh.Order_Source_Id
        From Mdb_Otm_Lot_Lines_All Moll
            ,Wsh_Delivery_Details  Wdd
            ,Oe_Order_Headers_All  Ooh
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Address_Id = Nvl(Pc_Address_Id, Moll.Address_Id)
         And Moll.Ship_Method_Code =
             Nvl(Pc_Ship_Method_Code, Moll.Ship_Method_Code)
         And Nvl(Moll.Add_Customer_Route_Id, -1) =
             Nvl(Pc_Add_Customer_Route_Id
                ,Nvl(Moll.Add_Customer_Route_Id, -1))
         And Moll.Inventory_Item_Id =
             Nvl(Pc_Inventory_Item_Id, Moll.Inventory_Item_Id)
         And Moll.Requested_Quantity_Uom =
             Nvl(Pc_Requested_Quantity_Uom, Moll.Requested_Quantity_Uom)
         And Moll.Line_Type_Id = Nvl(Pc_Line_Type_Id, Moll.Line_Type_Id)
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
            --
         And Wdd.Delivery_Detail_Id = Moll.Delivery_Detail_Id
            -- 
         And Ooh.Header_Id = Moll.Header_Id
      --
      ;
    -- Variaveis
    L_r_Moo                 Mdb_Otm_Organizations_All%Rowtype;
    L_r_Moa                 Mdb_Otm_Addresses_All%Rowtype;
    L_r_Mosm                Mdb_Otm_Ship_Methods_All%Rowtype;
    L_r_Mocr                Mdb_Om_Customers_Routes%Rowtype;
    L_r_Moi                 Mdb_Otm_Items_All%Rowtype;
    L_r_Mouom               Mdb_Otm_Units_Of_Measure_All%Rowtype;
    L_r_Mott                Mdb_Otm_Transaction_Types_All%Rowtype;
    L_r_Moll                Mdb_Otm_Lot_Lines_All%Rowtype;
    L_r_Molls_Line          Mdb_Otm_Line_Log_Status_All%Rowtype;
    L_r_Ood                 Org_Organization_Definitions %Rowtype;
    L_n_Commit              Number := 0;
    L_v_Status              Varchar2(30); -- Variavel para apoio no processamento das linhas
    L_n_Day                 Number; -- Dia da Semana da Criacao da Carga
    L_n_Count_Line          Number;
    L_d_Next_Cut_Of_Date    Date;
    L_b_Lot_Manual          Boolean;
    L_n_Count_Approve_Stock Number; -- Para ver se a linha foi aprovada pelo planejamento de estoque
  Begin
    -------------------------------------------------------------    
    -- Verificar se eh uma carga manual                        --
    -- Se for manual valida somnente as configuracoes de setup --
    -------------------------------------------------------------
    If P_Moli.Address_Id Is Null And
       P_Moli.Header_Id Is Null And
       P_Moli.Ship_Method_Code Is Null
    Then
      L_b_Lot_Manual := False;
    Else
      L_b_Lot_Manual := True;
    End If;
    -------------------------------------------------
    -- Cursor das Linhas com Erro para Reprocessar --
    -------------------------------------------------
    For R_Moll_Repro In C_Moll_Repro(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      -- Atualiza para Selecionado para reprocessar as linha do Lote que estavam com problema 
      Update Mdb_Otm_Lot_Lines_All
         Set Lot_Otm_Status_Line_Code     = 'SELECTED'
            ,Lot_Otm_Status_Line_Comments = Null
       Where Rowid = R_Moll_Repro.Rowid;
      -- Controle de Commit
      L_n_Commit := L_n_Commit + 1;
      If L_n_Commit >= 1000
      Then
        L_n_Commit := 0;
        Commit;
      End If;
    End Loop C_Moll_Repro;
    Commit;
    -----------------------------
    -- Atualiza os dados da OI --
    -----------------------------
    Select *
      Into L_r_Moo
      From Mdb_Otm_Organizations_All Moo
     Where Moo.Organization_Id = P_Moli.Organization_Id;
    -- 
    Update Mdb_Otm_Lot_Lines_All Moo
       Set Moo.Org_Max_Line_Uom      = L_r_Moo.Max_Line_Uom
          ,Moo.Org_Max_Line_Quantity = L_r_Moo.Max_Line_Quantity
     Where Moo.Lot_Invoice_Id = P_Moli.Lot_Invoice_Id;
    Commit;
    --------------------------------
    -- ## Cursor dos Cliente do Lote -- Inicio 
    --------------------------------
    For R_Moll_Add In C_Moll_Add(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      ------------------------------------------        
      -- Recupera as conf.do Cliente/Endereco --
      ------------------------------------------
      Begin
        Select *
          Into L_r_Moa
          From Mdb_Otm_Addresses_All Moa
         Where Moa.Organization_Id = P_Moli.Organization_Id
           And Moa.Address_Id = R_Moll_Add.Address_Id
           And Moa.Enabled_Flag = 'Y';
        -----------------------------------------------------------------
        -- Atualiza as linhas com as configuracoes do Cliente/Endereco --
        -----------------------------------------------------------------
        Update Mdb_Otm_Lot_Lines_All Moll
           Set Moll.Add_Max_Line_Uom               = L_r_Moa.Max_Line_Uom
              ,Moll.Add_Max_Line_Quantity          = L_r_Moa.Max_Line_Quantity
              ,Moll.Add_Days_To_Split_Quantity     = L_r_Moa.Days_To_Split_Quantity
              ,Moll.Add_Vehicle_Per_Day_Quantity   = L_r_Moa.Vehicle_Per_Day_Quantity
              ,Moll.Add_Apply_Retention_Flag       = L_r_Moa.Apply_Retention_Flag
              ,Moll.Add_Customer_Route_Id          = L_r_Moa.Customer_Route_Id
              ,Moll.Add_Delivery_Lead_Time         = L_r_Moa.Delivery_Lead_Time
              ,Moll.Add_Billing_Forecast_Lead_Time = L_r_Moa.Billing_Forecast_Lead_Time
              ,Moll.Add_Billing_Cut_Sunday_Flag    = L_r_Moa.Billing_Cut_Sunday_Flag
              ,Moll.Add_Billing_Cut_Monday_Flag    = L_r_Moa.Billing_Cut_Monday_Flag
              ,Moll.Add_Billing_Cut_Tuesday_Flag   = L_r_Moa.Billing_Cut_Tuesday_Flag
              ,Moll.Add_Billing_Cut_Wednesday_Flag = L_r_Moa.Billing_Cut_Wednesday_Flag
              ,Moll.Add_Billing_Cut_Thursday_Flag  = L_r_Moa.Billing_Cut_Thursday_Flag
              ,Moll.Add_Billing_Cut_Friday_Flag    = L_r_Moa.Billing_Cut_Friday_Flag
              ,Moll.Add_Billing_Cut_Saturday_Flag  = L_r_Moa.Billing_Cut_Saturday_Flag
              ,Moll.Add_Send_Not_Reservation_Flag  = L_r_Moa.Send_Not_Reservation_Flag
         Where Moll.Lot_Invoice_Id = P_Moli.Lot_Invoice_Id
           And Moll.Address_Id = R_Moll_Add.Address_Id;
        Commit;
        -- Valida a Rota de Entrega --
        If L_r_Moa.Customer_Route_Id Is Null
        Then
          -- Atualiza o status da linha para erro de condiguracao --
          -- SETUP NOT FOUND
          ----------------------------------------------
          -- Cursor das Linhas do Lote para equalizar --
          ----------------------------------------------
          For R_Moll In C_Moll(Pc_Lot_Invoice_Id         => P_Moli.Lot_Invoice_Id --
                              ,Pc_Address_Id             => R_Moll_Add.Address_Id --
                              ,Pc_Ship_Method_Code       => Null --
                              ,Pc_Add_Customer_Route_Id  => Null --
                              ,Pc_Inventory_Item_Id      => Null --
                              ,Pc_Requested_Quantity_Uom => Null --
                              ,Pc_Line_Type_Id           => Null --
                               )
          Loop
            -- Status OTM na WDD e Log
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
            -- MDB_OM_007C_039 - Erro ao acessar as configurações do Cliente/Endereço - Rota de Entrega não informada
            L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                             ,'MDB_OM_007C_039');
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Atualiza Status no Lote
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Rowid = R_Moll.Rowid_Moll;
            -- Controle de Commit
            L_n_Commit := L_n_Commit + 1;
            If L_n_Commit >= 1000
            Then
              L_n_Commit := 0;
              Commit;
            End If;
          End Loop C_Moll;
        End If;
      Exception
        When Others Then
          -- Atualiza o status da linha para erro de condiguracao --
          -- SETUP NOT FOUND
          ----------------------------------------------
          -- Cursor das Linhas do Lote para equalizar --
          ----------------------------------------------
          For R_Moll In C_Moll(Pc_Lot_Invoice_Id         => P_Moli.Lot_Invoice_Id --
                              ,Pc_Address_Id             => R_Moll_Add.Address_Id --
                              ,Pc_Ship_Method_Code       => Null --
                              ,Pc_Add_Customer_Route_Id  => Null --
                              ,Pc_Inventory_Item_Id      => Null --
                              ,Pc_Requested_Quantity_Uom => Null --
                              ,Pc_Line_Type_Id           => Null --
                               )
          Loop
            -- Status OTM na WDD e Log
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
            -- MDB_OM_007C_040 - Erro ao acessar as configurações do Cliente/Endereço : 
            L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                             ,'MDB_OM_007C_040') ||
                                       Sqlerrm;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Atualiza Status no Lote
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Rowid = R_Moll.Rowid_Moll;
            -- Controle de Commit
            L_n_Commit := L_n_Commit + 1;
            If L_n_Commit >= 1000
            Then
              L_n_Commit := 0;
              Commit;
            End If;
          End Loop C_Moll;
      End;
    End Loop C_Moll_Add;
    --------------------------------
    -- ## Cursor dos Cliente do Lote -- Fim
    --------------------------------
    -------------------------------------------
    -- ## Cursor dos Metodos de Entrega do Lote -- Inicio 
    -------------------------------------------
    For R_Moll_Ship_Method In C_Moll_Ship_Method(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      ----------------------------------------------    
      -- Recupera as conf.do do Metodo de Entrega --
      ----------------------------------------------
      Begin
        Select *
          Into L_r_Mosm
          From Mdb_Otm_Ship_Methods_All Mosm
         Where Mosm.Organization_Id = P_Moli.Organization_Id
           And Mosm.Ship_Method_Code = R_Moll_Ship_Method.Ship_Method_Code
           And Mosm.Enabled_Flag = 'Y';
        -------------------------------------------------------
        -- Atualiza as linhas com as configuracoes do Metodo --
        -------------------------------------------------------
        Update Mdb_Otm_Lot_Lines_All Moll
           Set Moll.Smc_Max_Line_Uom               = L_r_Mosm.Max_Line_Uom
              ,Moll.Smc_Max_Line_Quantity          = L_r_Mosm.Max_Line_Quantity
              ,Moll.Smc_Min_Line_Uom               = L_r_Mosm.Min_Line_Uom
              ,Moll.Smc_Min_Line_Quantity          = L_r_Mosm.Min_Line_Quantity
              ,Moll.Smc_Separation_Sequence        = L_r_Mosm.Separation_Sequence
              ,Moll.Smc_Indivisible_Flag           = L_r_Mosm.Indivisible_Flag
              ,Moll.Smc_Delivery_Lead_Time         = L_r_Mosm.Delivery_Lead_Time
              ,Moll.Smc_Billing_Forecast_Lead_Time = L_r_Mosm.Billing_Forecast_Lead_Time
              ,Moll.Smc_Billing_Partial_Flag       = L_r_Mosm.Billing_Partial_Flag
              ,Moll.Smc_Send_Not_Reservation_Flag  = L_r_Mosm.Send_Not_Reservation_Flag
              ,Moll.Smc_Apply_Retention_Flag       = L_r_Mosm.Apply_Retention_Flag
         Where Moll.Lot_Invoice_Id = P_Moli.Lot_Invoice_Id
           And Moll.Ship_Method_Code = R_Moll_Ship_Method.Ship_Method_Code;
        Commit;
      Exception
        When Others Then
          -- Atualiza o status da linha para erro de condiguracao --
          -- SETUP NOT FOUND
          ----------------------------------------------
          -- Cursor das Linhas do Lote para equalizar --
          ----------------------------------------------
          For R_Moll In C_Moll(Pc_Lot_Invoice_Id         => P_Moli.Lot_Invoice_Id --
                              ,Pc_Address_Id             => Null --
                              ,Pc_Ship_Method_Code       => R_Moll_Ship_Method.Ship_Method_Code --
                              ,Pc_Add_Customer_Route_Id  => Null --
                              ,Pc_Inventory_Item_Id      => Null --
                              ,Pc_Requested_Quantity_Uom => Null -- 
                              ,Pc_Line_Type_Id           => Null --                              
                               )
          Loop
            -- Status OTM na WDD e Log
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
            -- MDB_OM_007C_041 - Erro ao acessar as configurações do Metodo de Entrega : 
            L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                             ,'MDB_OM_007C_041') ||
                                       R_Moll_Ship_Method.Ship_Method_Code ||
                                       ' - ' || Sqlerrm;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Atualiza Status no Lote
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Rowid = R_Moll.Rowid_Moll;
            -- Controle de Commit
            L_n_Commit := L_n_Commit + 1;
            If L_n_Commit >= 1000
            Then
              L_n_Commit := 0;
              Commit;
            End If;
          End Loop C_Moll;
      End;
    End Loop C_Moll_Ship_Method;
    -------------------------------------------
    -- ## Cursor dos Metodos de Entrega do Lote -- Fim 
    -------------------------------------------
    ---------------------------------------------
    -- ## Cursor das Rotas do Clientes do Lote -- Inicio 
    ---------------------------------------------
    For R_Moll_Customer_Route In C_Moll_Customer_Route(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      --------------------------------------------      
      -- Recupera as conf.do da Rota do Cliente --
      --------------------------------------------
      Begin
        Select *
          Into L_r_Mocr
          From Mdb_Om_Customers_Routes Mocr
         Where Mocr.Organization_Id = P_Moli.Organization_Id
           And Mocr.Customer_Route_Id =
               R_Moll_Customer_Route.Add_Customer_Route_Id
           And Mocr.Enabled_Flag = 'Y';
        ----------------------------------------------------------------
        -- Atualiza as linhas com as configuracoes da Rota do Cliente --
        ----------------------------------------------------------------
        Update Mdb_Otm_Lot_Lines_All Moll
           Set Moll.Moc_Min_Delivery_Uom           = L_r_Mocr.Min_Delivery_Uom
              ,Moll.Moc_Min_Delivery_Quantity      = L_r_Mocr.Min_Delivery_Quantity
              ,Moll.Moc_Delivery_Lead_Time         = L_r_Mocr.Delivery_Lead_Time
              ,Moll.Moc_Billing_Cut_Sunday_Flag    = L_r_Mocr.Billing_Cut_Sunday_Flag
              ,Moll.Moc_Billing_Cut_Monday_Flag    = L_r_Mocr.Billing_Cut_Monday_Flag
              ,Moll.Moc_Billing_Cut_Tuesday_Flag   = L_r_Mocr.Billing_Cut_Tuesday_Flag
              ,Moll.Moc_Billing_Cut_Wednesday_Flag = L_r_Mocr.Billing_Cut_Wednesday_Flag
              ,Moll.Moc_Billing_Cut_Thursday_Flag  = L_r_Mocr.Billing_Cut_Thursday_Flag
              ,Moll.Moc_Billing_Cut_Friday_Flag    = L_r_Mocr.Billing_Cut_Friday_Flag
              ,Moll.Moc_Billing_Cut_Saturday_Flag  = L_r_Mocr.Billing_Cut_Saturday_Flag
         Where Moll.Lot_Invoice_Id = P_Moli.Lot_Invoice_Id
           And Moll.Add_Customer_Route_Id =
               R_Moll_Customer_Route.Add_Customer_Route_Id;
        Commit;
      Exception
        When Others Then
          -- Atualiza o status da linha para erro de condiguracao --
          -- SETUP NOT FOUND
          ----------------------------------------------
          -- Cursor das Linhas do Lote para equalizar --
          ----------------------------------------------
          For R_Moll In C_Moll(Pc_Lot_Invoice_Id         => P_Moli.Lot_Invoice_Id --
                              ,Pc_Address_Id             => Null --
                              ,Pc_Ship_Method_Code       => Null --
                              ,Pc_Add_Customer_Route_Id  => R_Moll_Customer_Route.Add_Customer_Route_Id -- 
                              ,Pc_Inventory_Item_Id      => Null --
                              ,Pc_Requested_Quantity_Uom => Null --
                              ,Pc_Line_Type_Id           => Null --                              
                               )
          Loop
            -- Status OTM na WDD e Log
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
            -- MDB_OM_007C_042 - Erro ao acessar as configurações da Rota do Cliente : 
            L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                             ,'MDB_OM_007C_042') ||
                                       Sqlerrm;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Atualiza Status no Lote
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Rowid = R_Moll.Rowid_Moll;
            -- Controle de Commit
            L_n_Commit := L_n_Commit + 1;
            If L_n_Commit >= 1000
            Then
              L_n_Commit := 0;
              Commit;
            End If;
          End Loop C_Moll;
      End;
    End Loop C_Moll_Customer_Route;
    ---------------------------------------------
    -- ## Cursor das Rotas do Clientes do Lote -- Fim
    ---------------------------------------------
    ---------------------------------
    -- ## Cursor dos Items do Lote -- Inicio 
    ---------------------------------
    For R_Moll_Item In C_Moll_Item(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      ------------------------------        
      -- Recupera as conf.do Item --
      ------------------------------
      Begin
        Select *
          Into L_r_Moi
          From Mdb_Otm_Items_All Moi
         Where Moi.Organization_Id = P_Moli.Organization_Id
           And Moi.Inventory_Item_Id = R_Moll_Item.Inventory_Item_Id
           And Moi.Enabled_Flag = 'Y';
        -------------------------------------------
        -- Recupera a Unidade Secundaria do Item --
        -------------------------------------------
        Select Msi.Secondary_Uom_Code
              ,Msi.Primary_Uom_Code
          Into L_r_Moll.Secondary_Uom_Code
              ,L_r_Moll.Primary_Uom_Code
          From Mtl_System_Items_b Msi
         Where Msi.Organization_Id = P_Moli.Organization_Id
           And Msi.Inventory_Item_Id = R_Moll_Item.Inventory_Item_Id;
        -----------------------------------------------------
        -- Atualiza as linhas com as configuracoes do Item --
        -----------------------------------------------------
        Update Mdb_Otm_Lot_Lines_All Moll
           Set Moll.Inv_Send_Not_Reservation_Flag = L_r_Moi.Send_Not_Reservation_Flag
              ,Moll.Inv_Apply_Retention_Flag      = L_r_Moi.Apply_Retention_Flag
              ,Moll.Inv_Commodities_Code          = L_r_Moi.Commodities_Code
              ,Moll.Secondary_Uom_Code            = L_r_Moll.Secondary_Uom_Code
              ,Moll.Primary_Uom_Code              = L_r_Moll.Primary_Uom_Code
         Where Moll.Lot_Invoice_Id = P_Moli.Lot_Invoice_Id
           And Moll.Inventory_Item_Id = R_Moll_Item.Inventory_Item_Id;
        Commit;
      Exception
        When Others Then
          -- Atualiza o status da linha para erro de condiguracao --
          -- SETUP NOT FOUND
          ----------------------------------------------
          -- Cursor das Linhas do Lote para equalizar --
          ----------------------------------------------
          For R_Moll In C_Moll(Pc_Lot_Invoice_Id         => P_Moli.Lot_Invoice_Id --
                              ,Pc_Address_Id             => Null --
                              ,Pc_Ship_Method_Code       => Null --
                              ,Pc_Add_Customer_Route_Id  => Null -- 
                              ,Pc_Inventory_Item_Id      => R_Moll_Item.Inventory_Item_Id --
                              ,Pc_Requested_Quantity_Uom => Null --
                              ,Pc_Line_Type_Id           => Null --                              
                               )
          Loop
            -- Status OTM na WDD e Log
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
            -- MDB_OM_007C_043 - Erro ao acessar as configurações do Item : 
            L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                             ,'MDB_OM_007C_043') ||
                                       Sqlerrm;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Atualiza Status no Lote
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Rowid = R_Moll.Rowid_Moll;
            -- Controle de Commit
            L_n_Commit := L_n_Commit + 1;
            If L_n_Commit >= 1000
            Then
              L_n_Commit := 0;
              Commit;
            End If;
          End Loop C_Moll;
      End;
    End Loop C_Moll_Item;
    ---------------------------------
    -- ## Cursor dos Items do Lote -- Fim 
    ---------------------------------
    -------------------------------
    -- ## Cursor das UOM do Lote -- Inicio 
    -------------------------------
    For R_Moll_Uom In C_Moll_Uom(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      -----------------------------        
      -- Recupera as conf.da UOM --
      -----------------------------
      Begin
        Select *
          Into L_r_Mouom
          From Mdb_Otm_Units_Of_Measure_All Mouom
         Where Mouom.Org_Id = P_Moli.Org_Id
           And Mouom.Uom_Code_From = R_Moll_Uom.Requested_Quantity_Uom
           And Mouom.Enabled_Flag = 'Y';
      Exception
        When Others Then
          -- Atualiza o status da linha para erro de condiguracao --
          -- SETUP NOT FOUND
          ----------------------------------------------
          -- Cursor das Linhas do Lote para equalizar --
          ----------------------------------------------
          For R_Moll In C_Moll(Pc_Lot_Invoice_Id         => P_Moli.Lot_Invoice_Id --
                              ,Pc_Address_Id             => Null --
                              ,Pc_Ship_Method_Code       => Null --
                              ,Pc_Add_Customer_Route_Id  => Null -- 
                              ,Pc_Inventory_Item_Id      => Null --
                              ,Pc_Requested_Quantity_Uom => R_Moll_Uom.Requested_Quantity_Uom --
                              ,Pc_Line_Type_Id           => Null --                              
                               )
          Loop
            -- Status OTM na WDD e Log
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
            -- MDB_OM_007C_044 - Erro ao acessar as configurações da Unidade de Medida :
            L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                             ,'MDB_OM_007C_044') ||
                                       R_Moll_Uom.Requested_Quantity_Uom ||
                                       ' : ' || Sqlerrm;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Atualiza Status no Lote
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Rowid = R_Moll.Rowid_Moll;
            -- Controle de Commit
            L_n_Commit := L_n_Commit + 1;
            If L_n_Commit >= 1000
            Then
              L_n_Commit := 0;
              Commit;
            End If;
          End Loop C_Moll_Uom;
      End;
    End Loop C_Moll_Uom;
    -------------------------------
    -- ## Cursor das UOM do Lote -- Inicio 
    -------------------------------   
    ----------------------------------
    -- ## Cursor dos Tipos de Linha --  Inicio
    ----------------------------------
    For R_Moll_Line_Type In C_Moll_Line_Type(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      -----------------------------        
      -- Recupera as conf.da UOM --
      -----------------------------
      Begin
        Select *
          Into L_r_Mott
          From Mdb_Otm_Transaction_Types_All Mott
         Where Mott.Org_Id = P_Moli.Org_Id
           And Mott.Transaction_Type_Id = R_Moll_Line_Type.Line_Type_Id
           And Mott.Enabled_Flag = 'Y';
        -- Atualizar as informacoes da transacao nas linhas 
        -----------------------------------------------------
        -- Atualiza as linhas com as configuracoes do Item --
        -----------------------------------------------------
        Update Mdb_Otm_Lot_Lines_All Moll
           Set Moll.Lt_Send_Not_Reservation_Flag = L_r_Mott.Send_Not_Reservation_Flag
              ,Moll.Lt_Apply_Hold_Flag           = L_r_Mott.Apply_Hold_Flag
         Where Moll.Lot_Invoice_Id = P_Moli.Lot_Invoice_Id
           And Moll.Line_Type_Id = R_Moll_Line_Type.Line_Type_Id;
        Commit;
      Exception
        When Others Then
          -- Atualiza o status da linha para erro de condiguracao --
          -- SETUP NOT FOUND
          ----------------------------------------------
          -- Cursor das Linhas do Lote para equalizar --
          ----------------------------------------------
          For R_Moll In C_Moll(Pc_Lot_Invoice_Id         => P_Moli.Lot_Invoice_Id --
                              ,Pc_Address_Id             => Null --
                              ,Pc_Ship_Method_Code       => Null --
                              ,Pc_Add_Customer_Route_Id  => Null -- 
                              ,Pc_Inventory_Item_Id      => Null --
                              ,Pc_Requested_Quantity_Uom => Null --
                              ,Pc_Line_Type_Id           => R_Moll_Line_Type.Line_Type_Id --                              
                               )
          Loop
            -- Status OTM na WDD e Log
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
            -- MDB_OM_007C_045 - Erro ao acessar as configurações do Tipo da Transação da Linha : 
            L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                             ,'MDB_OM_007C_045') ||
                                       Sqlerrm;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Atualiza Status no Lote
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Rowid = R_Moll.Rowid_Moll;
            -- Controle de Commit
            L_n_Commit := L_n_Commit + 1;
            If L_n_Commit >= 1000
            Then
              L_n_Commit := 0;
              Commit;
            End If;
          End Loop C_Moll_Uom;
      End;
    End Loop C_Moll_Uom;
    ----------------------------------
    -- ## Cursor dos Tipos de Linha --  Fim
    ----------------------------------
    ----------------------------------------------    
    -- ## Validar as Retencoes e Datas de Corte -- Inicio 
    ----------------------------------------------    
    L_n_Day := To_Number(To_Char(P_Moli.Creation_Date, 'D'));
    -------------------------------
    -- Cursor das Linhas do Lote --
    -------------------------------
    For R_Moll In C_Moll(Pc_Lot_Invoice_Id         => P_Moli.Lot_Invoice_Id --
                        ,Pc_Address_Id             => Null -- 
                        ,Pc_Ship_Method_Code       => Null -- 
                        ,Pc_Add_Customer_Route_Id  => Null -- 
                        ,Pc_Inventory_Item_Id      => Null -- 
                        ,Pc_Requested_Quantity_Uom => Null -- 
                        ,Pc_Line_Type_Id           => Null -- 
                         )
    Loop
      L_v_Status := R_Moll.Lot_Otm_Status_Line_Code;
      L_r_Moll   := Null;
      --------------------------------------------------------------
      -- ## Verificar se tem aplicacao de retencao para aprovacao -- Inicio 
      --------------------------------------------------------------
      -- Somente se nao for manual
      If Not L_b_Lot_Manual
      Then
        If Nvl(R_Moll.Lt_Apply_Hold_Flag, 'N') = 'Y' Or -- Retencao no Tipo da Linha 
           Nvl(R_Moll.Add_Apply_Retention_Flag, 'N') = 'Y' Or -- no Cliente
           Nvl(R_Moll.Smc_Apply_Retention_Flag, 'N') = 'Y' Or -- Metodo 
           Nvl(R_Moll.Inv_Apply_Retention_Flag, 'N') = 'Y'
        Then
          -- Verifica se a DDI foi Aprovada pelo Planejamento OM012
          Select Count(*)
            Into L_n_Count_Approve_Stock
            From Mdb_Om_Lot_Plan_Lines_All   Molpl
                ,Mdb_Om_Lot_Plan_Headers_All Molph
           Where Molpl.Delivery_Detail_Id = R_Moll.Delivery_Detail_Id
             And Molph.Lot_Plan_Id = Molpl.Lot_Plan_Id
             And Molph.Lot_Status_Code = 'COMPLETED'; -- Concluido
          If L_n_Count_Approve_Stock = 0
          Then
            -- Item
            -- Status OTM na WDD e Log
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'WAITING FOR APPROVAL PLAN'; -- Aprovação pelo Lote de Planejamento de Embarque
            L_v_Status                        := L_r_Molls_Line.Status_Code_To;
            L_r_Molls_Line.Comments           := Null;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Tira do Lote 
            Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p --
            (P_Rowid                        => R_Moll.Rowid_Moll -- 
            ,P_Wdd_Otm_Status_Line_Code     => L_r_Molls_Line.Status_Code_To --
            ,P_Wdd_Otm_Status_Line_Comments => L_r_Molls_Line.Comments --
            ,P_Comments                     => 'Excluida no processo de validação, para aprovação do Planejamento' --
             );
          End If;
        End If;
      End If; -- If Not L_b_Lot_Manual Then
      --------------------------------------------------------------
      -- ## Verificar se tem aplicacao de retencao para aprovacao -- Fim
      --------------------------------------------------------------      
      -------------------------------------------------------------------------------
      -- ## Verificar se tem algum dia da semana que nao pode entregar por cliente -- Inicio
      -- Se o status continuar como Selecionado                                    --
      -------------------------------------------------------------------------------
      -- Somente se nao for manual
      If Not L_b_Lot_Manual
      Then
        If L_v_Status = 'SELECTED'
        Then
          If (L_n_Day = 1 And
             Nvl(R_Moll.Add_Billing_Cut_Sunday_Flag, 'Y') = 'N') Or -- Domingo
             (L_n_Day = 2 And
             Nvl(R_Moll.Add_Billing_Cut_Monday_Flag, 'Y') = 'N') Or -- Segunda
             (L_n_Day = 3 And
             Nvl(R_Moll.Add_Billing_Cut_Tuesday_Flag, 'Y') = 'N') Or -- Terca
             (L_n_Day = 4 And
             Nvl(R_Moll.Add_Billing_Cut_Wednesday_Flag, 'Y') = 'N') Or -- Quarta
             (L_n_Day = 5 And
             Nvl(R_Moll.Add_Billing_Cut_Thursday_Flag, 'Y') = 'N') Or -- Quinta
             (L_n_Day = 6 And
             Nvl(R_Moll.Add_Billing_Cut_Friday_Flag, 'Y') = 'N') Or -- Sext
             (L_n_Day = 7 And
             Nvl(R_Moll.Add_Billing_Cut_Saturday_Flag, 'Y') = 'N') -- Sabado
          Then
            -- Status OTM na WDD e Log
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'DAY OUT CUSTOMER DELIVERY'; -- Fora do Dia de Entrega do Cliente
            L_v_Status                        := L_r_Molls_Line.Status_Code_To;
            L_r_Molls_Line.Comments           := Null;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Atualiza Status no Lote
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Rowid = R_Moll.Rowid_Moll;
          End If;
        End If;
      End If;
      -------------------------------------------------------------------------------
      -- ## Verificar se tem algum dia da semana que nao pode entregar por cliente -- Fim
      -- Se o status continuar como Selecionado                                    --
      -------------------------------------------------------------------------------      
      -------------------------------------------------------------------------------
      -- ## Verificar se tem algum dia da semana que nao pode entregar por Rota    -- Inicio
      -- Se o status continuar como Selecionado                                    --
      -------------------------------------------------------------------------------
      -- Somente se nao for manual
      If Not L_b_Lot_Manual
      Then
        If L_v_Status = 'SELECTED'
        Then
          If (L_n_Day = 1 And
             Nvl(R_Moll.Moc_Billing_Cut_Sunday_Flag, 'Y') = 'N') Or -- Domingo
             (L_n_Day = 2 And
             Nvl(R_Moll.Moc_Billing_Cut_Monday_Flag, 'Y') = 'N') Or -- Segunda
             (L_n_Day = 3 And
             Nvl(R_Moll.Moc_Billing_Cut_Tuesday_Flag, 'Y') = 'N') Or -- Terca
             (L_n_Day = 4 And
             Nvl(R_Moll.Moc_Billing_Cut_Wednesday_Flag, 'Y') = 'N') Or -- Quarta
             (L_n_Day = 5 And
             Nvl(R_Moll.Moc_Billing_Cut_Thursday_Flag, 'Y') = 'N') Or -- Quinta
             (L_n_Day = 6 And
             Nvl(R_Moll.Moc_Billing_Cut_Friday_Flag, 'Y') = 'N') Or -- Sext
             (L_n_Day = 7 And
             Nvl(R_Moll.Moc_Billing_Cut_Saturday_Flag, 'Y') = 'N') -- Sabado
          Then
            -- Status OTM na WDD e Log
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'DAY OUT CUSTOMER DELIVERY'; -- Fora do Dia de Entrega do Cliente
            L_v_Status                        := L_r_Molls_Line.Status_Code_To;
            L_r_Molls_Line.Comments           := 'Na Rota de Entrega';
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Atualiza Status no Lote
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Rowid = R_Moll.Rowid_Moll;
          End If;
        End If;
      End If;
      -------------------------------------------------------------------------------
      -- ## Verificar se tem algum dia da semana que nao pode entregar por Rota    -- Fim
      -- Se o status continuar como Selecionado                                    --
      -------------------------------------------------------------------------------  
      ----------------------------------------------------------------------
      -- ## Valida se o Metodo de Entrega nao permite Faturamento Parcial -- Inicio
      ----------------------------------------------------------------------
      -- Somente se nao for manual
      If Not L_b_Lot_Manual
      Then
        If L_v_Status = 'SELECTED'
        Then
          If Nvl(R_Moll.Smc_Billing_Partial_Flag, 'N') = 'N'
          Then
            Select Count(*)
              Into L_n_Count_Line
              From Oe_Order_Lines_All Ool
             Where Ool.Header_Id = R_Moll.Header_Id
               And Nvl(Ool.Invoice_Interface_Status_Code, 'N') = 'YES';
            If L_n_Count_Line != 0
            Then
              -- Status OTM na WDD e Log
              L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
              L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
              L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
              L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                      ,'NO PROCESS');
              L_r_Molls_Line.Status_Code_To     := 'PARTIAL BILLING'; -- Faturamento Parcial
              L_v_Status                        := L_r_Molls_Line.Status_Code_To;
              L_r_Molls_Line.Comments           := Null;
              Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
              -- Atualiza Status no Lote
              Update Mdb_Otm_Lot_Lines_All
                 Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                    ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
               Where Rowid = R_Moll.Rowid_Moll;
            End If;
          End If;
        End If;
      End If;
      ----------------------------------------------------------------------
      -- ## Valida se o Metodo de Entrega nao permite Faturamento Parcial -- Fim
      ----------------------------------------------------------------------
      -------------------------------------------------------------------------------  
      --------------------------------------------------------------
      -- ## Valida se o Metodo de Entrega tem Calendario de Corte -- Inicio
      --------------------------------------------------------------
      -- Somente se nao for manual
      If Not L_b_Lot_Manual
      Then
        If L_v_Status = 'SELECTED'
        Then
          Select Count(*)
            Into L_n_Count_Line
            From Mdb_Otm_Court_Dates_All Mocd
           Where Mocd.Organization_Id = R_Moll.Organization_Id
             And Mocd.Ship_Method_Code = R_Moll.Ship_Method_Code;
          -----------------------
          -- Tem dias de Corte --
          -----------------------
          If L_n_Count_Line != 0
          Then
            Select Count(*)
              Into L_n_Count_Line
              From Mdb_Otm_Court_Dates_All Mocd
             Where Mocd.Organization_Id = R_Moll.Organization_Id
               And Mocd.Ship_Method_Code = R_Moll.Ship_Method_Code
               And Trunc(Mocd.Cut_Of_Date) = Trunc(R_Moll.Creation_Date);
            -----------------------------------------------------------
            -- O dia de corte não é o dia da data de criacao do lote --
            -----------------------------------------------------------
            If L_n_Count_Line = 0
            Then
              ------------------------------
              -- Recupera o Proximo Corte --
              ------------------------------
              Select Min(Mocd.Cut_Of_Date)
                Into L_d_Next_Cut_Of_Date
                From Mdb_Otm_Court_Dates_All Mocd
               Where Mocd.Organization_Id = R_Moll.Organization_Id
                 And Mocd.Ship_Method_Code = R_Moll.Ship_Method_Code
                 And Trunc(Mocd.Cut_Of_Date) >= Trunc(R_Moll.Creation_Date);
              -----------------------------
              -- Status OTM na WDD e Log --
              -----------------------------
              L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
              L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
              L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
              L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                      ,'NO PROCESS');
              L_r_Molls_Line.Status_Code_To     := 'OUTSIDE EXPEDITION CALENDAR'; -- Fora do Calendário de Expedição 
              L_v_Status                        := L_r_Molls_Line.Status_Code_To;
              If L_d_Next_Cut_Of_Date Is Not Null
              Then
                L_r_Molls_Line.Comments := To_Char(L_d_Next_Cut_Of_Date
                                                  ,'DD-MON-YYYY');
              Else
                L_r_Molls_Line.Comments := '- ser definida';
              End If;
              Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
              -----------------------------
              -- Atualiza Status no Lote --
              -----------------------------
              Update Mdb_Otm_Lot_Lines_All
                 Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                    ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
               Where Rowid = R_Moll.Rowid_Moll;
            End If;
          End If;
        End If;
      End If; -- If Not L_b_Lot_Manual Then
      --------------------------------------------------------------
      -- ## Valida se o Metodo de Entrega tem Calendario de Corte -- Fim
      --------------------------------------------------------------
      -----------------------------------------------------------
      -- ## Verificar qual quantidade Maxima da Linha Utilizar -- Inicio
      -----------------------------------------------------------
      -- Se a quantidade for informada no cliente
      If L_v_Status = 'SELECTED'
      Then
        -- Se Quantidade Maxima informada no End.Cliente
        If R_Moll.Add_Max_Line_Uom Is Not Null And
           R_Moll.Add_Max_Line_Quantity Is Not Null
        Then
          L_r_Moll.Use_Max_Line_Source   := 'ADD'; -- End.Cliente
          L_r_Moll.Use_Max_Line_Quantity := R_Moll.Add_Max_Line_Quantity;
          L_r_Moll.Use_Max_Line_Uom      := R_Moll.Add_Max_Line_Uom;
          --
          If R_Moll.Requested_Quantity_Uom != R_Moll.Add_Max_Line_Uom
          Then
            -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
            L_r_Moll.Requested_Quantity_Conv_To_Set := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                       (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                       ,P_From_Quantity => R_Moll.Requested_Quantity --
                                                       ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                       ,P_To_Unit       => R_Moll.Add_Max_Line_Uom --
                                                        );
            -- Converte a Quantidade Maxima da Configuracao para a Unidade de Medida da Linha 
            L_r_Moll.Max_Line_Set_Conv_To_Requested := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                       (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                       ,P_From_Quantity => L_r_Moll.Use_Max_Line_Quantity --
                                                       ,P_From_Unit     => L_r_Moll.Use_Max_Line_Uom --
                                                       ,P_To_Unit       => R_Moll.Requested_Quantity_Uom --
                                                        );
            -- Trata a indivisibilidade 
            If Nvl(R_Moll.Smc_Indivisible_Flag, 'N') = 'Y'
            Then
              L_r_Moll.Max_Line_Set_Conv_To_Requested := Trunc(L_r_Moll.Max_Line_Set_Conv_To_Requested);
            End If;
          Else
            L_r_Moll.Requested_Quantity_Conv_To_Set := R_Moll.Requested_Quantity;
            L_r_Moll.Max_Line_Set_Conv_To_Requested := R_Moll.Add_Max_Line_Quantity;
            -- Trata a indivisibilidade 
            If Nvl(R_Moll.Smc_Indivisible_Flag, 'N') = 'Y'
            Then
              L_r_Moll.Max_Line_Set_Conv_To_Requested := Trunc(L_r_Moll.Max_Line_Set_Conv_To_Requested);
            End If;
          End If;
          -- Se nao encontrou a conversao inclui um erro          
          If L_r_Moll.Requested_Quantity_Conv_To_Set In (-99999, 0) Or
             L_r_Moll.Max_Line_Set_Conv_To_Requested In (-99999, 0)
          Then
            -----------------------------
            -- Status OTM na WDD e Log --
            -----------------------------
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
            L_v_Status                        := L_r_Molls_Line.Status_Code_To;
            -- MDB_OM_007C_046 - Erro ao converter a Unidade de Medida Maxima da Linha do End/Cliente : de 
            L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                             ,'MDB_OM_007C_046') ||
                                       R_Moll.Add_Max_Line_Uom || ' para ' ||
                                       R_Moll.Requested_Quantity_Uom ||
                                       ' ou ao contrario';
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -----------------------------
            -- Atualiza Status no Lote --
            -----------------------------
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code       = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments   = L_r_Molls_Line.Comments
                  ,Requested_Quantity_Conv_To_Set = L_r_Moll.Requested_Quantity_Conv_To_Set
             Where Rowid = R_Moll.Rowid_Moll;
          Else
            -----------------------------
            -- Atualiza Status no Lote --
            -----------------------------
            Update Mdb_Otm_Lot_Lines_All
               Set Requested_Quantity_Conv_To_Set = L_r_Moll.Requested_Quantity_Conv_To_Set
                  ,Use_Max_Line_Source            = L_r_Moll.Use_Max_Line_Source
                  ,Use_Max_Line_Quantity          = L_r_Moll.Use_Max_Line_Quantity
                  ,Use_Max_Line_Uom               = L_r_Moll.Use_Max_Line_Uom
                  ,Max_Line_Set_Conv_To_Requested = L_r_Moll.Max_Line_Set_Conv_To_Requested
             Where Rowid = R_Moll.Rowid_Moll;
          End If;
        Else
          -- Se Quantidade Maxima informada no Metodo
          If R_Moll.Smc_Max_Line_Uom Is Not Null And
             R_Moll.Smc_Max_Line_Quantity Is Not Null
          Then
            L_r_Moll.Use_Max_Line_Source   := 'SMC'; -- Metodo de Entrega
            L_r_Moll.Use_Max_Line_Quantity := R_Moll.Smc_Max_Line_Quantity;
            L_r_Moll.Use_Max_Line_Uom      := R_Moll.Smc_Max_Line_Uom;
            --
            If R_Moll.Requested_Quantity_Uom != R_Moll.Smc_Max_Line_Uom
            Then
              -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
              L_r_Moll.Requested_Quantity_Conv_To_Set := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                         (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                         ,P_From_Quantity => R_Moll.Requested_Quantity --
                                                         ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                         ,P_To_Unit       => R_Moll.Smc_Max_Line_Uom --
                                                          );
              -- Converte a Quantidade Maxima da Configuracao para a Unidade de Medida da Linha 
              L_r_Moll.Max_Line_Set_Conv_To_Requested := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                         (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                         ,P_From_Quantity => L_r_Moll.Use_Max_Line_Quantity --
                                                         ,P_From_Unit     => L_r_Moll.Use_Max_Line_Uom --
                                                         ,P_To_Unit       => R_Moll.Requested_Quantity_Uom --
                                                          );
              -- Trata a indivisibilidade 
              If Nvl(R_Moll.Smc_Indivisible_Flag, 'N') = 'Y'
              Then
                L_r_Moll.Max_Line_Set_Conv_To_Requested := Trunc(L_r_Moll.Max_Line_Set_Conv_To_Requested);
              End If;
            Else
              L_r_Moll.Requested_Quantity_Conv_To_Set := R_Moll.Requested_Quantity;
              L_r_Moll.Max_Line_Set_Conv_To_Requested := R_Moll.Smc_Max_Line_Quantity;
              -- Trata a indivisibilidade 
              If Nvl(R_Moll.Smc_Indivisible_Flag, 'N') = 'Y'
              Then
                L_r_Moll.Max_Line_Set_Conv_To_Requested := Trunc(L_r_Moll.Max_Line_Set_Conv_To_Requested);
              End If;
            End If;
            -- Se nao encontrou a conversao inclui um erro
            If L_r_Moll.Requested_Quantity_Conv_To_Set In (-99999, 0) Or
               L_r_Moll.Max_Line_Set_Conv_To_Requested In (-99999, 0)
            Then
              -----------------------------
              -- Status OTM na WDD e Log --
              -----------------------------
              L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
              L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
              L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
              L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                      ,'NO PROCESS');
              L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
              L_v_Status                        := L_r_Molls_Line.Status_Code_To;
              -- MDB_OM_007C_047 - Erro ao converter a Unidade de Medida Maxima da Linha do Metodo de Entrega : de 
              L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                               ,'MDB_OM_007C_047') ||
                                         R_Moll.Smc_Max_Line_Uom ||
                                         ' para ' ||
                                         R_Moll.Requested_Quantity_Uom ||
                                         ' ou ao contrario';
              Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
              -----------------------------
              -- Atualiza Status no Lote --
              -----------------------------
              Update Mdb_Otm_Lot_Lines_All
                 Set Lot_Otm_Status_Line_Code       = L_r_Molls_Line.Status_Code_To
                    ,Lot_Otm_Status_Line_Comments   = L_r_Molls_Line.Comments
                    ,Requested_Quantity_Conv_To_Set = L_r_Moll.Requested_Quantity_Conv_To_Set
               Where Rowid = R_Moll.Rowid_Moll;
            Else
              -----------------------------
              -- Atualiza Status no Lote --
              -----------------------------
              Update Mdb_Otm_Lot_Lines_All
                 Set Requested_Quantity_Conv_To_Set = L_r_Moll.Requested_Quantity_Conv_To_Set
                    ,Use_Max_Line_Source            = L_r_Moll.Use_Max_Line_Source
                    ,Use_Max_Line_Quantity          = L_r_Moll.Use_Max_Line_Quantity
                    ,Use_Max_Line_Uom               = L_r_Moll.Use_Max_Line_Uom
                    ,Max_Line_Set_Conv_To_Requested = L_r_Moll.Max_Line_Set_Conv_To_Requested
               Where Rowid = R_Moll.Rowid_Moll;
            End If;
          Else
            -- Se Quantidade Maxima informada na OI
            If R_Moll.Org_Max_Line_Uom Is Not Null And
               R_Moll.Org_Max_Line_Quantity Is Not Null
            Then
              L_r_Moll.Use_Max_Line_Source   := 'ORG'; -- Organizacao de Inventario
              L_r_Moll.Use_Max_Line_Quantity := R_Moll.Org_Max_Line_Quantity;
              L_r_Moll.Use_Max_Line_Uom      := R_Moll.Org_Max_Line_Uom;
              --
              If R_Moll.Requested_Quantity_Uom != R_Moll.Org_Max_Line_Uom
              Then
                -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
                L_r_Moll.Requested_Quantity_Conv_To_Set := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                           (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                           ,P_From_Quantity => R_Moll.Requested_Quantity --
                                                           ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                           ,P_To_Unit       => R_Moll.Org_Max_Line_Uom --
                                                            );
                -- Converte a Quantidade Maxima da Configuracao para a Unidade de Medida da Linha 
                L_r_Moll.Max_Line_Set_Conv_To_Requested := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                           (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                           ,P_From_Quantity => L_r_Moll.Use_Max_Line_Quantity --
                                                           ,P_From_Unit     => L_r_Moll.Use_Max_Line_Uom --
                                                           ,P_To_Unit       => R_Moll.Requested_Quantity_Uom --
                                                            );
                -- Trata a indivisibilidade 
                If Nvl(R_Moll.Smc_Indivisible_Flag, 'N') = 'Y'
                Then
                  L_r_Moll.Max_Line_Set_Conv_To_Requested := Trunc(L_r_Moll.Max_Line_Set_Conv_To_Requested);
                End If;
              Else
                L_r_Moll.Requested_Quantity_Conv_To_Set := R_Moll.Requested_Quantity;
                -- Trata a indivisibilidade 
                If Nvl(R_Moll.Smc_Indivisible_Flag, 'N') = 'Y'
                Then
                  L_r_Moll.Max_Line_Set_Conv_To_Requested := Trunc(L_r_Moll.Max_Line_Set_Conv_To_Requested);
                End If;
              End If;
              -- Se nao encontrou a conversao inclui um erro
              If L_r_Moll.Requested_Quantity_Conv_To_Set In (-99999, 0) Or
                 L_r_Moll.Max_Line_Set_Conv_To_Requested In (-99999, 0)
              Then
                -----------------------------
                -- Status OTM na WDD e Log --
                -----------------------------
                L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
                L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
                L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
                L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                        ,'NO PROCESS');
                L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
                L_v_Status                        := L_r_Molls_Line.Status_Code_To;
                -- MDB_OM_007C_048 - Erro ao converter a Unidade de Medida Maxima da Linha da Organização : de 
                L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                                 ,'MDB_OM_007C_048') ||
                                           R_Moll.Org_Max_Line_Uom ||
                                           ' para ' ||
                                           R_Moll.Requested_Quantity_Uom ||
                                           ' ou ao contrario';
                Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
                -----------------------------
                -- Atualiza Status no Lote --
                -----------------------------
                Update Mdb_Otm_Lot_Lines_All
                   Set Lot_Otm_Status_Line_Code       = L_r_Molls_Line.Status_Code_To
                      ,Lot_Otm_Status_Line_Comments   = L_r_Molls_Line.Comments
                      ,Requested_Quantity_Conv_To_Set = L_r_Moll.Requested_Quantity_Conv_To_Set
                 Where Rowid = R_Moll.Rowid_Moll;
              Else
                -----------------------------
                -- Atualiza Status no Lote --
                -----------------------------
                Update Mdb_Otm_Lot_Lines_All
                   Set Requested_Quantity_Conv_To_Set = L_r_Moll.Requested_Quantity_Conv_To_Set
                      ,Use_Max_Line_Source            = L_r_Moll.Use_Max_Line_Source
                      ,Use_Max_Line_Quantity          = L_r_Moll.Use_Max_Line_Quantity
                      ,Use_Max_Line_Uom               = L_r_Moll.Use_Max_Line_Uom
                      ,Max_Line_Set_Conv_To_Requested = L_r_Moll.Max_Line_Set_Conv_To_Requested
                 Where Rowid = R_Moll.Rowid_Moll;
              End If;
            End If;
          End If; -- Se Quantidade Maxima informada no Metodo
        End If; -- Se Quantidade Maxima informada no End.Cliente
      End If;
      -----------------------------------------------------------     
      -- ## Verificar qual quantidade Maxima da Linha Utilizar -- Fim
      -----------------------------------------------------------    
      -----------------------------------------------------------
      -- ## Verificar qual quantidade Minima da Linha Utilizar -- Inicio
      -----------------------------------------------------------
      If L_v_Status = 'SELECTED'
      Then
        -- Verificar se tem configuracao para a rota de entrega do cliente
        If R_Moll.Moc_Min_Delivery_Uom Is Not Null And
           R_Moll.Moc_Min_Delivery_Quantity Is Not Null
        Then
          --
          -- Se a UOM Solicitada for Dif da UOM da Config.
          If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom
          Then
            -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
            L_r_Moll.Moc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                   (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                   ,P_From_Quantity => R_Moll.Requested_Quantity --
                                                   ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                   ,P_To_Unit       => R_Moll.Moc_Min_Delivery_Uom --
                                                    );
          Else
            L_r_Moll.Moc_Min_Requested_Quantity := R_Moll.Requested_Quantity;
          End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then
          -- Se nao encontrou a conversao inclui um erro          
          If L_r_Moll.Moc_Min_Requested_Quantity In (-99999, 0)
          Then
            -----------------------------
            -- Status OTM na WDD e Log --
            -----------------------------
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
            L_v_Status                        := L_r_Molls_Line.Status_Code_To;
            -- MDB_OM_007C_049 - Erro ao converter a Unidade de Medida Minima da Linha da Rota de Entrega R_Moll.Add_Max_Line_Uom : 
            L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                             ,'MDB_OM_007C_049') ||
                                       R_Moll.Moc_Min_Delivery_Uom;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -----------------------------
            -- Atualiza Status no Lote --
            -----------------------------
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Rowid = R_Moll.Rowid_Moll;
          Else
            -----------------------------
            -- Atualiza Status no Lote --
            -----------------------------
            Update Mdb_Otm_Lot_Lines_All
               Set Moc_Min_Requested_Quantity = L_r_Moll.Moc_Min_Requested_Quantity
             Where Rowid = R_Moll.Rowid_Moll;
          End If;
        End If; -- Rota de Entrega        
      End If; -- If L_v_Status = 'SELECTED' Then
      --
      If L_v_Status = 'SELECTED'
      Then
        -- Verificar se tem configuracao para a rota de entrega do cliente
        If R_Moll.Smc_Min_Line_Uom Is Not Null And
           R_Moll.Smc_Min_Line_Quantity Is Not Null
        Then
          --
          -- Se a UOM Solicitada for Dif da UOM da Config.
          If R_Moll.Requested_Quantity_Uom != R_Moll.Smc_Min_Line_Uom
          Then
            -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
            L_r_Moll.Smc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                   (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                   ,P_From_Quantity => R_Moll.Requested_Quantity --
                                                   ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                   ,P_To_Unit       => R_Moll.Smc_Min_Line_Uom --
                                                    );
          Else
            L_r_Moll.Smc_Min_Requested_Quantity := R_Moll.Requested_Quantity;
          End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then
          -- Se nao encontrou a conversao inclui um erro          
          If L_r_Moll.Smc_Min_Requested_Quantity In (-99999, 0)
          Then
            -----------------------------
            -- Status OTM na WDD e Log --
            -----------------------------
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
            L_v_Status                        := L_r_Molls_Line.Status_Code_To;
            -- MDB_OM_007C_050 - Erro ao converter a Unidade de Medida Minima da Linha do Metodo de Entrega : 
            L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                             ,'MDB_OM_007C_050') ||
                                       R_Moll.Smc_Min_Line_Uom;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -----------------------------
            -- Atualiza Status no Lote --
            -----------------------------
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Rowid = R_Moll.Rowid_Moll;
          Else
            -----------------------------
            -- Atualiza Status no Lote --
            -----------------------------
            Update Mdb_Otm_Lot_Lines_All
               Set Smc_Min_Requested_Quantity = L_r_Moll.Smc_Min_Requested_Quantity
             Where Rowid = R_Moll.Rowid_Moll;
          End If;
        End If; -- Metodo        
      End If; -- If L_v_Status = 'SELECTED' Then      
      -----------------------------------------------------------
      -- ## Verificar qual quantidade Minima da Linha Utilizar -- Inicio
      -----------------------------------------------------------
      -----------------------------------------------------
      -- ## Atualizar qual DELIVERY_LEAD_TIME sera usado -- Inicio
      -----------------------------------------------------
      -- Por Cliente/Endereco
      If R_Moll.Add_Delivery_Lead_Time Is Not Null
      Then
        Update Mdb_Otm_Lot_Lines_All
           Set Use_Delivery_Lead_Source = 'ADD'
              ,Use_Delivery_Lead_Time   = R_Moll.Add_Delivery_Lead_Time
         Where Rowid = R_Moll.Rowid_Moll;
      Else
        -- Por Rota de Entrega de Cliente
        If R_Moll.Moc_Delivery_Lead_Time Is Not Null
        Then
          Update Mdb_Otm_Lot_Lines_All
             Set Use_Delivery_Lead_Source = 'MOC'
                ,Use_Delivery_Lead_Time   = R_Moll.Moc_Delivery_Lead_Time
           Where Rowid = R_Moll.Rowid_Moll;
        Else
          -- Por Metodo de Entrega          
          If R_Moll.Smc_Delivery_Lead_Time Is Not Null
          Then
            Update Mdb_Otm_Lot_Lines_All
               Set Use_Delivery_Lead_Source = 'SMC'
                  ,Use_Delivery_Lead_Time   = R_Moll.Smc_Delivery_Lead_Time
             Where Rowid = R_Moll.Rowid_Moll;
          End If;
        End If; -- If R_Moll.Smc_Delivery_Lead_Time Is Not Null Then
      End If; -- If R_Moll.Add_Delivery_Lead_Time Is Not Null Then
      -------------------------------
      -- Recupera os Pesos do Item -- Inicio 
      -------------------------------
      Begin
        Mdb_Om_Ship_Lines_Temp_Pk.Get_Item_Weights_p --
        (P_Inventory_Item_Id     => R_Moll.Inventory_Item_Id -- In Number -- 
        ,P_Organization_Id       => R_Moll.Organization_Id -- In Number -- 
        ,P_Requested_Quantity    => R_Moll.Requested_Quantity -- In Number -- 
        ,P_Requested_Uom_Code    => R_Moll.Requested_Quantity_Uom -- 
        ,P_Unit_Weight_Item      => L_r_Moll.Unit_Weight_Item -- In Out Number -- Peso Unitatio do Item
        ,P_Unit_Weight_Container => L_r_Moll.Unit_Weight_Container -- In Out Number -- Peso Unitario do conteiner
        ,P_Net_Weight            => L_r_Moll.Net_Weight_Line -- In Out Number -- Peso Liquido
        ,P_Gross_Weight          => L_r_Moll.Gross_Weight_Line -- In Out Number -- Peso Bruto
         );
        -- Validacao do Calculo do CUBO -- 
        L_r_Moll.Cube_Quantity_Mdb := Mdb_Otm_Create_Order_Pk.Get_Cube_Quantity_Mdb_f --
                                      (R_Moll.Org_Id --
                                      ,R_Moll.Inventory_Item_Id --
                                      ,R_Moll.Requested_Quantity --
                                      ,R_Moll.Requested_Quantity_Uom --
                                      ,L_r_Moll.Unit_Weight_Item --
                                       );
        -- Atualizar os Pesos 
        Update Mdb_Otm_Lot_Lines_All
           Set Unit_Weight_Item      = L_r_Moll.Unit_Weight_Item
              ,Unit_Weight_Container = L_r_Moll.Unit_Weight_Container
              ,Net_Weight_Line       = L_r_Moll.Net_Weight_Line
              ,Gross_Weight_Line     = L_r_Moll.Gross_Weight_Line
              ,Cube_Quantity_Mdb     = L_r_Moll.Cube_Quantity_Mdb
         Where Rowid = R_Moll.Rowid_Moll;
        -----------------------------
        -- Status OTM na WDD e Log --
        -----------------------------
        -- Se o Cubo MDB estiver negativo ocorreu erro na conversao
        If L_r_Moll.Cube_Quantity_Mdb < 0
        Then
          L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
          L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
          L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
          L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                  ,'NO PROCESS');
          L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
          L_v_Status                        := L_r_Molls_Line.Status_Code_To;
          -- MDB_OM_007C_058 - Erro ao calcular o Cubo MDB, valor negativo, provável falta e conversão - CUBO MDB Calculado : 
          L_r_Molls_Line.Comments := Substr(Fnd_Message.Get_String('MDB'
                                                                  ,'MDB_OM_007C_058') ||
                                            To_Char(L_r_Moll.Cube_Quantity_Mdb)
                                           ,1
                                           ,150);
          Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
          -----------------------------
          -- Atualiza Status no Lote --
          -----------------------------
          Update Mdb_Otm_Lot_Lines_All
             Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
           Where Rowid = R_Moll.Rowid_Moll;
        End If;
      Exception
        When Others Then
          -----------------------------
          -- Status OTM na WDD e Log --
          -----------------------------
          L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
          L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
          L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
          L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                  ,'NO PROCESS');
          L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
          L_v_Status                        := L_r_Molls_Line.Status_Code_To;
          -- MDB_OM_007C_011 - Erro ao Recuperar as informações de Peso do Item : 
          L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                           ,'MDB_OM_007C_011') ||
                                     Sqlerrm;
          Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
          -----------------------------
          -- Atualiza Status no Lote --
          -----------------------------
          Update Mdb_Otm_Lot_Lines_All
             Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
           Where Rowid = R_Moll.Rowid_Moll;
      End;
      -------------------------------
      -- Recupera os Pesos do Item -- Inicio 
      -------------------------------
      -------------------------------
      -- Tratamendo de Req.Interna -- Inicio
      -------------------------------
      If R_Moll.Order_Source_Id = 10
      Then
        Begin
          --- Busca id e código OI destino 
          --- Buscando máximo id, pois no EBS o relacionamento da requisição com a entrega é a nivel de item
          --- Porém uma requisição e uma ordem no OM sempre serão referente entrega para unica OI destino 
          Select Max(Prl.Destination_Organization_Id)
            Into L_r_Ood.Organization_Id
            From Oe_Order_Lines_All         Ool
                ,Po_Requisition_Lines_All   Prl
                ,Po_Requisition_Headers_All Prh
           Where Ool.Header_Id = R_Moll.Header_Id
             And Prl.Requisition_Line_Id = Ool.Source_Document_Line_Id
             And Prh.Requisition_Header_Id = Prl.Requisition_Header_Id
             And Prh.Requisition_Header_Id = Ool.Source_Document_Id
             And Prl.Source_Organization_Id = R_Moll.Organization_Id;
          --
          Select Ood.Organization_Code
            Into L_r_Ood.Organization_Code
            From Org_Organization_Definitions Ood
           Where Ood.Organization_Id = L_r_Ood.Organization_Id;
          --- Recupera o Nome OTM da OI destino 
          Select Moo.Otm_Organization_Name
            Into L_r_Moo.Otm_Organization_Name
            From Mdb_Otm_Organizations_All Moo
           Where Moo.Organization_Id = L_r_Ood.Organization_Id;
        Exception
          When Others Then
            -----------------------------
            -- Status OTM na WDD e Log --
            -----------------------------
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SETUP NOT FOUND';
            L_v_Status                        := L_r_Molls_Line.Status_Code_To;
            -- MDB_OM_007C_059 - Erro ao acessar as configurações da OI Destino em uma Transferencia Interna :  
            L_r_Molls_Line.Comments := Fnd_Message.Get_String('MDB'
                                                             ,'MDB_OM_007C_059') ||
                                       L_r_Ood.Organization_Code || ' - ' ||
                                       Sqlerrm;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -----------------------------
            -- Atualiza Status no Lote --
            -----------------------------
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Rowid = R_Moll.Rowid_Moll;
        End;
      End If; -- If R_Moll.Order_Source_Id = 10 Then
    End Loop C_Moll;
    ----------------------------------------------    
    -- ## Validar as Retencoes e Datas de Corte -- Inicio 
    ----------------------------------------------        
  End Lot_Validation_p;

  ----------------------- -------------
  -- Procedure para Executar o SPLIt --
  ------------------------------------
  Procedure Lot_Split_Select_p(P_Moli Mdb_Otm_Lot_Invoices_All %Rowtype) Is
    ---------------------------------------------------------
    -- Cursor das Linhas com quantidade menor que o maximo --
    ---------------------------------------------------------
    Cursor C_Moll(Pc_Lot_Invoice_Id Number) Is
      Select Moll.*
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
         And Moll.Requested_Quantity > Moll.Max_Line_Set_Conv_To_Requested
         AND Moll.Lot_Unique_Order_Flag <> 'Y'; -- nao seja pedido unico no OTM;
    ----------------------------------
    -- Cursor das Linhas de Entrega --
    ----------------------------------
    Cursor C_Wdd
    (
      Pc_Header_Id Number
     ,Pc_Line_Id   Number
    ) Is
      Select Wdd.Delivery_Detail_Id
            ,Ool.Schedule_Ship_Date
            ,Ool.Header_Id
            ,Ool.Line_Id
            ,Ool.Inventory_Item_Id
            ,Wdd.Requested_Quantity_Uom
            ,Wdd.Requested_Quantity
            ,Wdd.Unit_Price
            ,Rsu.Address_Id
            ,Wdd.Ship_Method_Code
            ,Wdd.Attribute1
            ,Wdd.Attribute2
            ,Ra.Global_Attribute3 || Ra.Global_Attribute4 ||
             Ra.Global_Attribute5 Document_Number
            ,Ool.Line_Number
            ,Ool.Shipment_Number
            ,Ooh.Order_Number
            ,Ool.Line_Type_Id
            ,Ra.Customer_Id
        From Wsh_Delivery_Details Wdd
            ,Oe_Order_Lines_All   Ool
            ,Oe_Order_Headers_All Ooh
            ,Ra_Site_Uses_All     Rsu
            ,Ra_Addresses_All     Ra
            ,Fnd_Lookup_Values    Flv_Otm_Line_Status
       Where Wdd.Source_Code = 'OE'
            -- Pedido
         And Wdd.Source_Header_Id = Pc_Header_Id
         And Wdd.Source_Line_Id = Pc_Line_Id
            -- Site Use / Endereco
         And Rsu.Site_Use_Id = Wdd.Ship_To_Site_Use_Id
            -- Endereco
         And Ra.Address_Id = Rsu.Address_Id
            -- Status da Entrega 
            -- Linha do Pedido
         And Ool.Line_Id = Wdd.Source_Line_Id
         And Ooh.Header_Id = Ool.Header_Id
            -- Verificar o status OTM da linha 
         And Flv_Otm_Line_Status.Lookup_Type = 'MDB_OTM_LINE_STATUS'
         And Flv_Otm_Line_Status.Lookup_Code =
             Nvl(Wdd.Attribute1, 'NO PROCESS')
         And Flv_Otm_Line_Status.Attribute1 = 'Y'
         And Flv_Otm_Line_Status.Enabled_Flag = 'Y'
         And Flv_Otm_Line_Status.Language = Userenv('LANG')
      --
      ;
    -- Variaveis 
    L_n_Ordered_Quantity_New Number; -- Novo valor da linha atual
    L_b_Loop                 Boolean := False;
    L_n_Split_By             Number := Fnd_Global.User_Id;
    L_n_Header_Id            Number;
    L_n_Line_Id_Actual       Number;
    L_n_Line_Id_New          Number;
    L_n_Inventory_Item_Id    Number;
    L_v_Msg                  Varchar2(4000);
    -- Variaveis 
    L_r_Moll            Mdb_Otm_Lot_Lines_All%Rowtype;
    L_r_Molls_Lot       Mdb_Otm_Lot_Log_Status_All%Rowtype;
    L_r_Molls_Line      Mdb_Otm_Line_Log_Status_All%Rowtype;
    L_n_Conc_Request_Id Number := Fnd_Global.Conc_Request_Id;
  Begin
    ---------------------------------------------------------
    -- Cursor das Linhas com quantidade menor que o maximo --
    ---------------------------------------------------------
    For R_Moll In C_Moll(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      L_b_Loop                 := False;
      L_n_Ordered_Quantity_New := R_Moll.Requested_Quantity;
      -- Loop para dividir a linha ate que o valor inicia for menor ou igual ao maximo da linha
      While Not L_b_Loop
      Loop
        -- Nova quantidade igual a quantidade solicitada menos a maxima, para gerar uma nova linha com o valor maximo
        L_n_Ordered_Quantity_New := L_n_Ordered_Quantity_New -
                                    R_Moll.Max_Line_Set_Conv_To_Requested;
        -- Trata a indivibilidade
        If Nvl(R_Moll.Smc_Indivisible_Flag, 'N') = 'Y'
        Then
          L_n_Ordered_Quantity_New := Trunc(L_n_Ordered_Quantity_New);
        End If;
        L_n_Header_Id         := R_Moll.Header_Id;
        L_n_Line_Id_Actual    := R_Moll.Line_Id;
        L_n_Inventory_Item_Id := R_Moll.Inventory_Item_Id;
        -------------------
        -- Chama o SPLIT -- 
        -------------------
        Mdb_Otm_Lot_Invoices_Pk.Lot_Split_Create_p(P_Split_By               => L_n_Split_By -- 
                                                  ,P_Header_Id              => L_n_Header_Id --
                                                  ,P_Line_Id_Actual         => L_n_Line_Id_Actual --
                                                  ,P_Line_Id_New            => L_n_Line_Id_New --    
                                                  ,P_Inventory_Item_Id      => L_n_Inventory_Item_Id -- 
                                                  ,P_Ordered_Quantity_Alt   => L_n_Ordered_Quantity_New -- 
                                                  ,P_Ordered_Quantity_Split => R_Moll.Max_Line_Set_Conv_To_Requested --
                                                  ,P_Msg                    => L_v_Msg --
                                                   );
        If L_v_Msg = 'OK'
        Then
          -----------------------------
          -- Inclui a linha na Carga --
          -----------------------------
          ----------------------------------
          -- Cursor das Linhas de Entrega --
          ----------------------------------
          For R_Wdd In C_Wdd(Pc_Header_Id => L_n_Header_Id
                            ,Pc_Line_Id   => L_n_Line_Id_New)
          Loop
            -- Recupera as informacoes da linha Pai
            Select Moll.*
              Into L_r_Moll
              From Mdb_Otm_Lot_Lines_All Moll
             Where Lot_Line_Id = R_Moll.Lot_Line_Id;
            -- Prepara a linha para inclusao
            Select Mdb_Otm_Lot_Lines_S.Nextval
              Into L_r_Moll.Lot_Line_Id
              From Dual;
            L_r_Moll.Schedule_Ship_Date           := R_Wdd.Schedule_Ship_Date;
            L_r_Moll.Line_Id                      := R_Wdd.Line_Id;
            L_r_Moll.Line_Number                  := R_Wdd.Line_Number;
            L_r_Moll.Shipment_Number              := R_Wdd.Shipment_Number;
            L_r_Moll.Line_Type_Id                 := R_Wdd.Line_Type_Id;
            L_r_Moll.Delivery_Detail_Id           := R_Wdd.Delivery_Detail_Id;
            L_r_Moll.Inventory_Item_Id            := R_Wdd.Inventory_Item_Id;
            L_r_Moll.Requested_Quantity_Uom       := R_Wdd.Requested_Quantity_Uom;
            L_r_Moll.Requested_Quantity           := R_Wdd.Requested_Quantity;
            L_r_Moll.Unit_Price                   := R_Wdd.Unit_Price;
            L_r_Moll.Selected_Flag                := 'Y';
            L_r_Moll.Address_Id                   := R_Wdd.Address_Id;
            L_r_Moll.Document_Number              := R_Wdd.Document_Number;
            L_r_Moll.Ship_Method_Code             := R_Wdd.Ship_Method_Code;
            L_r_Moll.Lot_Otm_Status_Line_Code     := 'SELECTED';
            L_r_Moll.Lot_Otm_Status_Line_Comments := Null;
            L_r_Moll.Creation_Date                := Sysdate;
            L_r_Moll.Created_By                   := Fnd_Global.User_Id;
            L_r_Moll.Last_Update_Date             := Sysdate;
            L_r_Moll.Last_Updated_By              := Fnd_Global.User_Id;
            L_r_Moll.Last_Update_Login            := Fnd_Global.Login_Id;
            L_r_Moll.Split_From_Line_Id           := L_n_Line_Id_Actual;
            L_r_Moll.Customer_Id                  := R_Wdd.Customer_Id;
            -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
            If R_Wdd.Requested_Quantity_Uom != L_r_Moll.Use_Max_Line_Uom
            Then
              L_r_Moll.Requested_Quantity_Conv_To_Set := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                         (P_Item_Id       => R_Wdd.Inventory_Item_Id --
                                                         ,P_From_Quantity => R_Wdd.Requested_Quantity --
                                                         ,P_From_Unit     => R_Wdd.Requested_Quantity_Uom --
                                                         ,P_To_Unit       => L_r_Moll.Use_Max_Line_Uom --
                                                          );
            Else
              L_r_Moll.Requested_Quantity_Conv_To_Set := R_Wdd.Requested_Quantity;
            End If;
            -- Se a UOM Solicitada for Dif da UOM da Config.
            If L_r_Moll.Requested_Quantity_Uom !=
               Nvl(L_r_Moll.Smc_Min_Line_Uom
                  ,L_r_Moll.Requested_Quantity_Uom)
            Then
              -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
              L_r_Moll.Smc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                     (P_Item_Id       => L_r_Moll.Inventory_Item_Id --
                                                     ,P_From_Quantity => R_Wdd.Requested_Quantity --
                                                     ,P_From_Unit     => R_Wdd.Requested_Quantity_Uom --
                                                     ,P_To_Unit       => L_r_Moll.Smc_Min_Line_Uom --
                                                      );
            Else
              L_r_Moll.Smc_Min_Requested_Quantity := R_Wdd.Requested_Quantity;
            End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then                                                        
            -- Se a UOM Solicitada for Dif da UOM da Config.
            If L_r_Moll.Requested_Quantity_Uom !=
               Nvl(L_r_Moll.Moc_Min_Delivery_Uom
                  ,L_r_Moll.Requested_Quantity_Uom)
            Then
              -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
              L_r_Moll.Moc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                     (P_Item_Id       => L_r_Moll.Inventory_Item_Id --
                                                     ,P_From_Quantity => R_Wdd.Requested_Quantity --
                                                     ,P_From_Unit     => L_r_Moll.Requested_Quantity_Uom --
                                                     ,P_To_Unit       => L_r_Moll.Moc_Min_Delivery_Uom --
                                                      );
            Else
              L_r_Moll.Moc_Min_Requested_Quantity := R_Wdd.Requested_Quantity;
            End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then
            --
            -- Recupera os pessos do Item e da Linha 
            Begin
              Mdb_Om_Ship_Lines_Temp_Pk.Get_Item_Weights_p --
              (P_Inventory_Item_Id     => R_Moll.Inventory_Item_Id -- In Number -- 
              ,P_Organization_Id       => R_Moll.Organization_Id -- In Number -- 
              ,P_Requested_Quantity    => R_Wdd.Requested_Quantity -- In Number -- 
              ,P_Requested_Uom_Code    => R_Wdd.Requested_Quantity_Uom --               
              ,P_Unit_Weight_Item      => L_r_Moll.Unit_Weight_Item -- In Out Number -- Peso Unitatio do Item
              ,P_Unit_Weight_Container => L_r_Moll.Unit_Weight_Container -- In Out Number -- Peso Unitario do conteiner
              ,P_Net_Weight            => L_r_Moll.Net_Weight_Line -- In Out Number -- Peso Liquido
              ,P_Gross_Weight          => L_r_Moll.Gross_Weight_Line -- In Out Number -- Peso Bruto
               );
              -- Validacao do Calculo do CUBO -- 
              L_r_Moll.Cube_Quantity_Mdb := Mdb_Otm_Create_Order_Pk.Get_Cube_Quantity_Mdb_f --
                                            (R_Moll.Org_Id --
                                            ,R_Moll.Inventory_Item_Id --
                                            ,R_Wdd.Requested_Quantity --
                                            ,R_Wdd.Requested_Quantity_Uom --
                                            ,L_r_Moll.Unit_Weight_Item --
                                             );
            End;
            --
            Begin
              -- Inclui a linha no Lote
              Insert Into Mdb_Otm_Lot_Lines_All
              Values L_r_Moll;
              -- Atualizar Status da WDD
              L_r_Molls_Line.Delivery_Detail_Id := R_Wdd.Delivery_Detail_Id;
              L_r_Molls_Line.Organization_Id    := P_Moli.Organization_Id;
              L_r_Molls_Line.Org_Id             := P_Moli.Org_Id;
              L_r_Molls_Line.Status_Code_From   := Nvl(R_Wdd.Attribute1
                                                      ,'NO PROCESS');
              L_r_Molls_Line.Status_Code_To     := L_r_Moll.Lot_Otm_Status_Line_Code;
              L_r_Molls_Line.Comments           := L_r_Moll.Lot_Otm_Status_Line_Comments;
              Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            Exception
              When Others Then
                -- MDB_OM_007C_051 - Erro não esperado no SPLIT ao Incluir a Linha no Lote - Id da Linha de Entrega : 
                L_r_Molls_Lot.Comments := Fnd_Message.Get_String('MDB'
                                                                ,'MDB_OM_007C_051') ||
                                          R_Wdd.Delivery_Detail_Id || ' - ' ||
                                          Sqlerrm;
                L_v_Msg                := L_r_Molls_Lot.Comments;
                -- Atualiza Status no Lote
                Update Mdb_Otm_Lot_Lines_All Moll
                   Set Lot_Otm_Status_Line_Code     = 'SPLIT ERROR' -- Erro no SPLIT;
                      ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
                 Where Moll.Lot_Line_Id = R_Moll.Lot_Line_Id;
                Commit;
                Exit;
            End;
          End Loop C_Wdd;
          -- Converte o novo valor para a Unidade de Media da Configuracao
          If L_r_Moll.Requested_Quantity_Uom != L_r_Moll.Use_Max_Line_Uom
          Then
            L_r_Moll.Requested_Quantity_Conv_To_Set := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                       (P_Item_Id       => L_r_Moll.Inventory_Item_Id --
                                                       ,P_From_Quantity => L_n_Ordered_Quantity_New --
                                                       ,P_From_Unit     => L_r_Moll.Requested_Quantity_Uom --
                                                       ,P_To_Unit       => L_r_Moll.Use_Max_Line_Uom --
                                                        );
          Else
            L_r_Moll.Requested_Quantity_Conv_To_Set := L_n_Ordered_Quantity_New;
          End If;
          -- Se a UOM Solicitada for Dif da UOM da Config.
          If R_Moll.Requested_Quantity_Uom !=
             Nvl(R_Moll.Smc_Min_Line_Uom, R_Moll.Requested_Quantity_Uom)
          Then
            -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
            L_r_Moll.Smc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                   (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                   ,P_From_Quantity => L_n_Ordered_Quantity_New --
                                                   ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                   ,P_To_Unit       => R_Moll.Smc_Min_Line_Uom --
                                                    );
          Else
            L_r_Moll.Smc_Min_Requested_Quantity := L_n_Ordered_Quantity_New;
          End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then                                                        
          -- Se a UOM Solicitada for Dif da UOM da Config.
          If R_Moll.Requested_Quantity_Uom !=
             Nvl(R_Moll.Moc_Min_Delivery_Uom, R_Moll.Requested_Quantity_Uom)
          Then
            -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
            L_r_Moll.Moc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                   (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                   ,P_From_Quantity => L_n_Ordered_Quantity_New --
                                                   ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                   ,P_To_Unit       => R_Moll.Moc_Min_Delivery_Uom --
                                                    );
          Else
            L_r_Moll.Moc_Min_Requested_Quantity := L_n_Ordered_Quantity_New;
          End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then
          --
          -- Recupera os pessos do Item e da Linha 
          Begin
            Mdb_Om_Ship_Lines_Temp_Pk.Get_Item_Weights_p --
            (P_Inventory_Item_Id     => R_Moll.Inventory_Item_Id -- In Number -- 
            ,P_Organization_Id       => R_Moll.Organization_Id -- In Number -- 
            ,P_Requested_Quantity    => L_n_Ordered_Quantity_New -- In Number -- 
            ,P_Unit_Weight_Item      => L_r_Moll.Unit_Weight_Item -- In Out Number -- Peso Unitatio do Item
            ,P_Unit_Weight_Container => L_r_Moll.Unit_Weight_Container -- In Out Number -- Peso Unitario do conteiner
            ,P_Net_Weight            => L_r_Moll.Net_Weight_Line -- In Out Number -- Peso Liquido
            ,P_Gross_Weight          => L_r_Moll.Gross_Weight_Line -- In Out Number -- Peso Bruto
             );
            -- Validacao do Calculo do CUBO -- 
            L_r_Moll.Cube_Quantity_Mdb := Mdb_Otm_Create_Order_Pk.Get_Cube_Quantity_Mdb_f --
                                          (R_Moll.Org_Id --
                                          ,R_Moll.Inventory_Item_Id --
                                          ,L_n_Ordered_Quantity_New --
                                          ,R_Moll.Requested_Quantity_Uom --
                                          ,R_Moll.Unit_Weight_Item --
                                           );
          End;
          -- Atualiza a quantidade da linha no lote 
          Update Mdb_Otm_Lot_Lines_All
             Set Requested_Quantity             = L_n_Ordered_Quantity_New
                ,Requested_Quantity_Conv_To_Set = L_r_Moll.Requested_Quantity_Conv_To_Set
                ,Moc_Min_Requested_Quantity     = L_r_Moll.Moc_Min_Requested_Quantity
                ,Smc_Min_Requested_Quantity     = L_r_Moll.Smc_Min_Requested_Quantity
                ,Unit_Weight_Container          = L_r_Moll.Unit_Weight_Container
                ,Net_Weight_Line                = L_r_Moll.Net_Weight_Line
                ,Gross_Weight_Line              = L_r_Moll.Gross_Weight_Line
                ,Cube_Quantity_Mdb              = L_r_Moll.Cube_Quantity_Mdb
           Where Lot_Line_Id = R_Moll.Lot_Line_Id;
          Commit;
          -- Se Nova quantidade menor ou igual a maxima sai do Loop
          If L_n_Ordered_Quantity_New <=
             R_Moll.Max_Line_Set_Conv_To_Requested
          Then
            L_b_Loop := True; -- Sai do Loop
          End If;
        Else
          Begin
            -- Atualizar Status da WDD
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Lot_Otm_Status_Line_Code
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SPLIT ERROR'; -- Erro no SPLIT
            L_r_Molls_Line.Comments           := L_v_Msg;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Atualiza Status no Lote
            Update Mdb_Otm_Lot_Lines_All Moll
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Moll.Lot_Line_Id = R_Moll.Lot_Line_Id;
            Commit;
            Exit;
          Exception
            When Others Then
              Exit;
          End;
        End If;
      End Loop;
    End Loop C_Moll;
  End Lot_Split_Select_p;

  ----------------------------------
  -- Procedure para Criar o SPLIt --
  ----------------------------------
  Procedure Lot_Split_Create_p
  (
    P_Split_By               In Number
   ,P_Header_Id              In Number
   ,P_Line_Id_Actual         In Number
   ,P_Line_Id_New            In Out Number
   ,P_Inventory_Item_Id      In Number
   ,P_Ordered_Quantity_Alt   In Number
   ,P_Ordered_Quantity_Split In Number
   ,P_Msg                    In Out Varchar2
  ) Is
    L_Header_Rec                 Oe_Order_Pub.Header_Rec_Type;
    L_Line_Tbl                   Oe_Order_Pub.Line_Tbl_Type;
    L_Action_Request_Tbl         Oe_Order_Pub.Request_Tbl_Type;
    L_Header_Adj_Tbl             Oe_Order_Pub.Header_Adj_Tbl_Type;
    L_Line_Adj_Tbl               Oe_Order_Pub.Line_Adj_Tbl_Type;
    L_Header_Scr_Tbl             Oe_Order_Pub.Header_Scredit_Tbl_Type;
    L_Line_Scredit_Tbl           Oe_Order_Pub.Line_Scredit_Tbl_Type;
    L_Request_Rec                Oe_Order_Pub.Request_Rec_Type;
    L_Return_Status              Varchar2(1000);
    L_Msg_Count                  Number;
    L_Msg_Data                   Varchar2(1000);
    P_Api_Version_Number         Number := 1.0;
    P_Init_Msg_List              Varchar2(10) := Fnd_Api.G_False;
    P_Return_Values              Varchar2(10) := Fnd_Api.G_False;
    P_Action_Commit              Varchar2(10) := Fnd_Api.G_False;
    X_Return_Status              Varchar2(1);
    X_Msg_Count                  Number;
    X_Msg_Data                   Varchar2(100);
    P_Header_Rec                 Oe_Order_Pub.Header_Rec_Type := Oe_Order_Pub.G_Miss_Header_Rec;
    P_Old_Header_Rec             Oe_Order_Pub.Header_Rec_Type := Oe_Order_Pub.G_Miss_Header_Rec;
    P_Header_Val_Rec             Oe_Order_Pub.Header_Val_Rec_Type := Oe_Order_Pub.G_Miss_Header_Val_Rec;
    P_Old_Header_Val_Rec         Oe_Order_Pub.Header_Val_Rec_Type := Oe_Order_Pub.G_Miss_Header_Val_Rec;
    P_Header_Adj_Tbl             Oe_Order_Pub.Header_Adj_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Tbl;
    P_Old_Header_Adj_Tbl         Oe_Order_Pub.Header_Adj_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Tbl;
    P_Header_Adj_Val_Tbl         Oe_Order_Pub.Header_Adj_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Val_Tbl;
    P_Old_Header_Adj_Val_Tbl     Oe_Order_Pub.Header_Adj_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Val_Tbl;
    P_Header_Price_Att_Tbl       Oe_Order_Pub.Header_Price_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Price_Att_Tbl;
    P_Old_Header_Price_Att_Tbl   Oe_Order_Pub.Header_Price_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Price_Att_Tbl;
    P_Header_Adj_Att_Tbl         Oe_Order_Pub.Header_Adj_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Att_Tbl;
    P_Old_Header_Adj_Att_Tbl     Oe_Order_Pub.Header_Adj_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Att_Tbl;
    P_Header_Adj_Assoc_Tbl       Oe_Order_Pub.Header_Adj_Assoc_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Assoc_Tbl;
    P_Old_Header_Adj_Assoc_Tbl   Oe_Order_Pub.Header_Adj_Assoc_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Assoc_Tbl;
    P_Header_Scredit_Tbl         Oe_Order_Pub.Header_Scredit_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Scredit_Tbl;
    P_Old_Header_Scredit_Tbl     Oe_Order_Pub.Header_Scredit_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Scredit_Tbl;
    P_Header_Scredit_Val_Tbl     Oe_Order_Pub.Header_Scredit_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Scredit_Val_Tbl;
    P_Old_Header_Scredit_Val_Tbl Oe_Order_Pub.Header_Scredit_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Scredit_Val_Tbl;
    P_Line_Tbl                   Oe_Order_Pub.Line_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Tbl;
    P_Old_Line_Tbl               Oe_Order_Pub.Line_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Tbl;
    P_Line_Val_Tbl               Oe_Order_Pub.Line_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Val_Tbl;
    P_Old_Line_Val_Tbl           Oe_Order_Pub.Line_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Val_Tbl;
    P_Line_Adj_Tbl               Oe_Order_Pub.Line_Adj_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Tbl;
    P_Old_Line_Adj_Tbl           Oe_Order_Pub.Line_Adj_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Tbl;
    P_Line_Adj_Val_Tbl           Oe_Order_Pub.Line_Adj_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Val_Tbl;
    P_Old_Line_Adj_Val_Tbl       Oe_Order_Pub.Line_Adj_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Val_Tbl;
    P_Line_Price_Att_Tbl         Oe_Order_Pub.Line_Price_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Price_Att_Tbl;
    P_Old_Line_Price_Att_Tbl     Oe_Order_Pub.Line_Price_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Price_Att_Tbl;
    P_Line_Adj_Att_Tbl           Oe_Order_Pub.Line_Adj_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Att_Tbl;
    P_Old_Line_Adj_Att_Tbl       Oe_Order_Pub.Line_Adj_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Att_Tbl;
    P_Line_Adj_Assoc_Tbl         Oe_Order_Pub.Line_Adj_Assoc_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Assoc_Tbl;
    P_Old_Line_Adj_Assoc_Tbl     Oe_Order_Pub.Line_Adj_Assoc_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Assoc_Tbl;
    P_Line_Scredit_Tbl           Oe_Order_Pub.Line_Scredit_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Scredit_Tbl;
    P_Old_Line_Scredit_Tbl       Oe_Order_Pub.Line_Scredit_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Scredit_Tbl;
    P_Line_Scredit_Val_Tbl       Oe_Order_Pub.Line_Scredit_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Scredit_Val_Tbl;
    P_Old_Line_Scredit_Val_Tbl   Oe_Order_Pub.Line_Scredit_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Scredit_Val_Tbl;
    P_Lot_Serial_Tbl             Oe_Order_Pub.Lot_Serial_Tbl_Type := Oe_Order_Pub.G_Miss_Lot_Serial_Tbl;
    P_Old_Lot_Serial_Tbl         Oe_Order_Pub.Lot_Serial_Tbl_Type := Oe_Order_Pub.G_Miss_Lot_Serial_Tbl;
    P_Lot_Serial_Val_Tbl         Oe_Order_Pub.Lot_Serial_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Lot_Serial_Val_Tbl;
    P_Old_Lot_Serial_Val_Tbl     Oe_Order_Pub.Lot_Serial_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Lot_Serial_Val_Tbl;
    P_Action_Request_Tbl         Oe_Order_Pub.Request_Tbl_Type := Oe_Order_Pub.G_Miss_Request_Tbl;
    X_Header_Val_Rec             Oe_Order_Pub.Header_Val_Rec_Type;
    X_Header_Adj_Tbl             Oe_Order_Pub.Header_Adj_Tbl_Type;
    X_Header_Adj_Val_Tbl         Oe_Order_Pub.Header_Adj_Val_Tbl_Type;
    X_Header_Price_Att_Tbl       Oe_Order_Pub.Header_Price_Att_Tbl_Type;
    X_Header_Adj_Att_Tbl         Oe_Order_Pub.Header_Adj_Att_Tbl_Type;
    X_Header_Adj_Assoc_Tbl       Oe_Order_Pub.Header_Adj_Assoc_Tbl_Type;
    X_Header_Scredit_Tbl         Oe_Order_Pub.Header_Scredit_Tbl_Type;
    X_Header_Scredit_Val_Tbl     Oe_Order_Pub.Header_Scredit_Val_Tbl_Type;
    X_Line_Val_Tbl               Oe_Order_Pub.Line_Val_Tbl_Type;
    X_Line_Adj_Tbl               Oe_Order_Pub.Line_Adj_Tbl_Type;
    X_Line_Adj_Val_Tbl           Oe_Order_Pub.Line_Adj_Val_Tbl_Type;
    X_Line_Price_Att_Tbl         Oe_Order_Pub.Line_Price_Att_Tbl_Type;
    X_Line_Adj_Att_Tbl           Oe_Order_Pub.Line_Adj_Att_Tbl_Type;
    X_Line_Adj_Assoc_Tbl         Oe_Order_Pub.Line_Adj_Assoc_Tbl_Type;
    X_Line_Scredit_Tbl           Oe_Order_Pub.Line_Scredit_Tbl_Type;
    X_Line_Scredit_Val_Tbl       Oe_Order_Pub.Line_Scredit_Val_Tbl_Type;
    X_Lot_Serial_Tbl             Oe_Order_Pub.Lot_Serial_Tbl_Type;
    X_Lot_Serial_Val_Tbl         Oe_Order_Pub.Lot_Serial_Val_Tbl_Type;
    X_Action_Request_Tbl         Oe_Order_Pub.Request_Tbl_Type;
    X_Debug_File                 Varchar2(100);
    L_Line_Tbl_Index             Number;
    L_Msg_Index_Out              Number(10);
    L_Msg_Index_In               Number(10) := 1;
  Begin
    -- Linha atual que ser alterada 
    L_Line_Tbl_Index       := 1;
    L_Header_Rec           := Oe_Order_Pub.G_Miss_Header_Rec;
    L_Header_Rec.Header_Id := P_Header_Id; -- header_id of the order 
    L_Header_Rec.Operation := Oe_Globals.G_Opr_Update;
    --
    L_Line_Tbl(L_Line_Tbl_Index) := Oe_Order_Pub.G_Miss_Line_Rec;
    L_Line_Tbl(L_Line_Tbl_Index).Operation := Oe_Globals.G_Opr_Update;
    L_Line_Tbl(L_Line_Tbl_Index).Split_By := P_Split_By; -- user_id 
    L_Line_Tbl(L_Line_Tbl_Index).Split_Action_Code := 'SPLIT';
    L_Line_Tbl(L_Line_Tbl_Index).Header_Id := P_Header_Id; -- header_id of the order 
    L_Line_Tbl(L_Line_Tbl_Index).Line_Id := P_Line_Id_Actual; -- line_id of the order line 
    L_Line_Tbl(L_Line_Tbl_Index).Ordered_Quantity := P_Ordered_Quantity_Alt; -- new ordered quantity 
    L_Line_Tbl(L_Line_Tbl_Index).Change_Reason := 'MISC'; -- change reason code 
    -- Linha que sera criada
    L_Line_Tbl_Index := 2;
    L_Line_Tbl(L_Line_Tbl_Index) := Oe_Order_Pub.G_Miss_Line_Rec;
    L_Line_Tbl(L_Line_Tbl_Index).Operation := Oe_Globals.G_Opr_Create;
    L_Line_Tbl(L_Line_Tbl_Index).Split_By := P_Split_By; -- user_id 
    L_Line_Tbl(L_Line_Tbl_Index).Split_Action_Code := 'SPLIT';
    L_Line_Tbl(L_Line_Tbl_Index).Split_From_Line_Id := P_Line_Id_Actual; -- line_id of  original line 
    L_Line_Tbl(L_Line_Tbl_Index).Inventory_Item_Id := P_Inventory_Item_Id; -- inventory item id 
    L_Line_Tbl(L_Line_Tbl_Index).Ordered_Quantity := P_Ordered_Quantity_Split; -- ordered quantity 
    -- CALL TO PROCESS ORDER 
    Oe_Order_Pub.Process_Order(P_Api_Version_Number => 1.0 --
                              ,P_Init_Msg_List      => Fnd_Api.G_False --
                              ,P_Return_Values      => Fnd_Api.G_False --
                              ,P_Action_Commit      => Fnd_Api.G_False --
                              ,X_Return_Status      => L_Return_Status --
                              ,X_Msg_Count          => L_Msg_Count --
                              ,X_Msg_Data           => L_Msg_Data --
                              ,P_Header_Rec         => L_Header_Rec --
                              ,P_Line_Tbl           => L_Line_Tbl --
                              ,P_Action_Request_Tbl => L_Action_Request_Tbl --
                               -- OUT PARAMETERS 
                              ,X_Header_Rec             => L_Header_Rec --
                              ,X_Header_Val_Rec         => X_Header_Val_Rec --
                              ,X_Header_Adj_Tbl         => X_Header_Adj_Tbl --
                              ,X_Header_Adj_Val_Tbl     => X_Header_Adj_Val_Tbl --
                              ,X_Header_Price_Att_Tbl   => X_Header_Price_Att_Tbl --
                              ,X_Header_Adj_Att_Tbl     => X_Header_Adj_Att_Tbl --
                              ,X_Header_Adj_Assoc_Tbl   => X_Header_Adj_Assoc_Tbl --
                              ,X_Header_Scredit_Tbl     => X_Header_Scredit_Tbl --
                              ,X_Header_Scredit_Val_Tbl => X_Header_Scredit_Val_Tbl --
                              ,X_Line_Tbl               => L_Line_Tbl --
                              ,X_Line_Val_Tbl           => X_Line_Val_Tbl --
                              ,X_Line_Adj_Tbl           => X_Line_Adj_Tbl --
                              ,X_Line_Adj_Val_Tbl       => X_Line_Adj_Val_Tbl --
                              ,X_Line_Price_Att_Tbl     => X_Line_Price_Att_Tbl --
                              ,X_Line_Adj_Att_Tbl       => X_Line_Adj_Att_Tbl --
                              ,X_Line_Adj_Assoc_Tbl     => X_Line_Adj_Assoc_Tbl --
                              ,X_Line_Scredit_Tbl       => X_Line_Scredit_Tbl --
                              ,X_Line_Scredit_Val_Tbl   => X_Line_Scredit_Val_Tbl --
                              ,X_Lot_Serial_Tbl         => X_Lot_Serial_Tbl --
                              ,X_Lot_Serial_Val_Tbl     => X_Lot_Serial_Val_Tbl --
                              ,X_Action_Request_Tbl     => L_Action_Request_Tbl --
                               );
    -- Check the return status 
    If L_Return_Status = Fnd_Api.G_Ret_Sts_Success
    Then
      P_Msg         := 'OK';
      P_Line_Id_New := L_Line_Tbl(2).Line_Id; -- Nova linha
    Else
      -- Retrieve messages 
      Oe_Msg_Pub.Get(P_Msg_Index     => L_Msg_Index_In --
                    ,P_Encoded       => Fnd_Api.G_False --
                    ,P_Data          => L_Msg_Data --
                    ,P_Msg_Index_Out => L_Msg_Index_Out --
                     );
      P_Msg := Nvl(L_Msg_Data, 'NOK');
    End If;
  End Lot_Split_Create_p;

  ----------------------------------------------------------------------------------
  -- Procedure para Recuperar as linhas para alterar a Data de Entrega Programada --
  ----------------------------------------------------------------------------------
  Procedure Schedule_Ship_Date_Select_p(P_Moli Mdb_Otm_Lot_Invoices_All %ROWTYPE
                                       ,P_MSG                IN OUT VARCHAR2
                                       ,P_QTT_ERROR          IN OUT NUMBER) Is
    ---------------------------------------------------------------
    -- Cursor das Linha do Lote para atualizar a Data de Entrega --
    ---------------------------------------------------------------
    Cursor C_Moll_Upd(Pc_Lot_Invoice_Id Number) Is
      Select Moll.*
            ,Moll.Rowid
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED';
    ---------------------------------------------------------------
    -- Cursor dos clientes que tem que alterar a data de entrega --
    ---------------------------------------------------------------
    Cursor C_Add(Pc_Lot_Invoice_Id Number) Is
      Select Moll.Address_Id
            ,Count(*) Qtd
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
         And Nvl(Moll.Add_Days_To_Split_Quantity, 0) != 0
       Group By Moll.Address_Id;
    -----------------------------------------------------------------
    -- Cursor das configuracoes usadas na linha para o Cliente/End --
    -----------------------------------------------------------------
    Cursor C_Add_Use
    (
      Pc_Lot_Invoice_Id Number
     ,Pc_Address_Id     Number
    ) Is
      Select Moll.Add_Days_To_Split_Quantity
            ,Nvl(Moll.Add_Vehicle_Per_Day_Quantity, 1) Add_Vehicle_Per_Day_Quantity
            ,Moll.Use_Max_Line_Quantity
            ,(Nvl(Moll.Add_Vehicle_Per_Day_Quantity, 1) *
             Moll.Use_Max_Line_Quantity) Vehicle_Max
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Address_Id = Pc_Address_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
         And Nvl(Moll.Add_Days_To_Split_Quantity, 0) != 0
         And Rownum = 1;
    -------------------------------------
    -- Cursor das Linha do Cliente/End -- 
    -------------------------------------
    Cursor C_Moll
    (
      Pc_Lot_Invoice_Id Number
     ,Pc_Address_Id     Number
    ) Is
      Select Moll.*
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Address_Id = Pc_Address_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
         And Nvl(Moll.Add_Days_To_Split_Quantity, 0) != 0
       Order By Moll.Requested_Quantity_Conv_To_Set Desc
               ,Moll.Line_Number
               ,Moll.Shipment_Number;
    ---------------               
    -- Variaveis --
    ---------------
    L_n_Line                   Number := 0;
    L_d_Schedule_Ship_Date_New Date;
    L_d_Schedule_Ship_Date_Cal Date;
    L_d_Schedule_Ship_Date_Ini Date;
    L_d_Base_Date_New          Date;
    L_d_Base_Date_Temp         Date;
    L_v_Msg                    Varchar2(1000);
    L_r_Moll                   Mdb_Otm_Lot_Lines_All%Rowtype;
    L_r_Molls_Line             Mdb_Otm_Line_Log_Status_All%Rowtype;
    L_n_Vehicle_Max_Use        Number;
    L_n_Qtt_Errors             NUMBER := 0;
  Begin
    L_v_Msg := 'OK';
    ---------------------------------------------------------------
    -- Cursor das Linha do Lote para atualizar a Data de Entrega --
    ---------------------------------------------------------------
    For R_Moll_Upd In C_Moll_Upd(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      --------------------------------------------------------------------------------------------------
      -- Se a data de entrega for menor trago para a data de criacao do lote
      --------------------------------------------------------------------------------------------------
      If Trunc(R_Moll_Upd.Schedule_Ship_Date) < Trunc(P_Moli.Creation_Date)
      Then
        --
        L_d_Base_Date_New := Trunc(P_Moli.Creation_Date);
        ------------------------------------------------------------------
        -- Procedure para Alterar a Data de Entrega Programada da Linha --
        ------------------------------------------------------------------
        Begin
          Mdb_Otm_Lot_Invoices_Pk.Schedule_Ship_Date_Update_p -- 
          (P_Action             => 'SCHEDULE_SHIP_DATE'
          ,P_Header_Id          => R_Moll_Upd.Header_Id --
          ,P_Line_Id            => R_Moll_Upd.Line_Id --
          ,P_Schedule_Ship_Date => L_d_Base_Date_New --
          ,P_Msg                => L_v_Msg --
           );
        Exception
          When Others Then
            L_v_Msg := 'Erro não esperado ao alterar a Data de Entrega (00) : ' ||
                       Sqlerrm;
            P_MSG := ' - Erro no pedido: ' || R_Moll_Upd.Order_Number || ' Linha: '|| R_Moll_Upd.Line_Number||'.'||R_Moll_Upd.Shipment_Number 
                     || L_v_Msg;
        End;
        --
        If L_v_Msg = 'OK'
        Then
          -- Atualiza a DATA da linha no lote 
          Update Mdb_Otm_Lot_Lines_All Moll
             Set Moll.Schedule_Ship_Date     = Trunc(L_d_Base_Date_New)
                ,Moll.Schedule_Ship_Date_Old = Decode(Moll.Schedule_Ship_Date_Old --
                                                     ,Null
                                                     ,Trunc(R_Moll_Upd.Schedule_Ship_Date) --
                                                     ,Moll.Schedule_Ship_Date_Old)
           Where Lot_Line_Id = R_Moll_Upd.Lot_Line_Id;
          Commit;
        Else
          BEGIN
            -- Atualiza o ERRO na linha no lote 
            UPDATE_STATUS_LINE_P(R_Moll_Upd.Lot_Line_Id, L_v_Msg, 'SCHEDULE DATE ERROR');
            
            -- Atualizar Status da WDD
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll_Upd.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll_Upd.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll_Upd.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll_Upd.Lot_Otm_Status_Line_Code
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'SCHEDULE DATE ERROR'; -- Erro na Alteracao da Data
            L_r_Molls_Line.Comments           := L_v_Msg;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            Commit;
            P_MSG := ' - Erro no pedido: ' || R_Moll_Upd.Order_Number || ' Linha: '|| R_Moll_Upd.Line_Number||'.'||R_Moll_Upd.Shipment_Number 
                     || L_v_Msg; 
            L_n_Qtt_Errors := L_n_Qtt_Errors + 1;    
                   
          Exception
            When Others Then
              L_v_Msg := 'Erro não esperado ao alterar a Data de Entrega (00) : ' ||
                         Sqlerrm;
              P_MSG := ' - Erro no pedido: ' || R_Moll_Upd.Order_Number || ' Linha: '|| R_Moll_Upd.Line_Number||'.'||R_Moll_Upd.Shipment_Number 
                     || L_v_Msg;
              L_n_Qtt_Errors := L_n_Qtt_Errors + 1;
          End;
        End If; -- If L_v_Msg = 'OK' Then
      End If; -- If Trunc(L_d_Base_Date_New) != Trunc(R_Moll_Upd.Schedule_Ship_Date) Then
    End Loop C_Moll_Upd;
    --------------------------------------------------------------------------
    -- Se nao teve problema na atualizacao do Lead Time de Coleta continuar --
    --------------------------------------------------------------------------
    If L_v_Msg = 'OK'
    Then
      ---------------------------------------------------------------
      -- Cursor dos clientes que tem que alterar a data de entrega --
      ---------------------------------------------------------------      
      For R_Add In C_Add(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
      Loop
        -----------------------------------------------------------------
        -- Cursor das configuracoes usadas na linha para o Cliente/End --
        -----------------------------------------------------------------
        For R_Add_Use In C_Add_Use(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id -- 
                                  ,Pc_Address_Id     => R_Add.Address_Id --
                                   )
        Loop
          -- Recupera a da iniciao 
          Select Min(Moll.Schedule_Ship_Date)
            Into L_d_Schedule_Ship_Date_Ini
            From Mdb_Otm_Lot_Lines_All Moll
           Where Moll.Lot_Invoice_Id = P_Moli.Lot_Invoice_Id
             And Moll.Address_Id = R_Add.Address_Id
             And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
             And Nvl(Moll.Add_Days_To_Split_Quantity, 0) != 0;
          -- 
          L_d_Base_Date_New   := Trunc(L_d_Schedule_Ship_Date_Ini); -- Data Inicial / Menor data do Endereco
          L_n_Vehicle_Max_Use := 0; -- Quantidade usar no veiculo
          -------------------------------------
          -- Cursor das Linha do Cliente/End -- 
          -------------------------------------
          For R_Moll In C_Moll(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id -- 
                              ,Pc_Address_Id     => R_Add.Address_Id --
                               )
          Loop
            -- Se a quantidade usada mais a linha for menor o igual a quantidade maxima do veiculo
            -- Entrou no Veiculo
            If (L_n_Vehicle_Max_Use + R_Moll.Requested_Quantity_Conv_To_Set) <=
               R_Add_Use.Vehicle_Max
            Then
              L_n_Vehicle_Max_Use := L_n_Vehicle_Max_Use +
                                     R_Moll.Requested_Quantity_Conv_To_Set;
              ------------------------------------------------------------------
              -- Procedure para Alterar a Data de Entrega Programada da Linha --
              ------------------------------------------------------------------
              Begin
                Mdb_Otm_Lot_Invoices_Pk.Schedule_Ship_Date_Update_p -- 
                (P_Action             => 'SCHEDULE_SHIP_DATE'
                ,P_Header_Id          => R_Moll.Header_Id --
                ,P_Line_Id            => R_Moll.Line_Id --
                ,P_Schedule_Ship_Date => L_d_Base_Date_New --
                ,P_Msg                => L_v_Msg --
                 );
              Exception
                When Others Then
                  -- MDB_OM_007C_052 - Erro não esperado ao alterar a Data de Entrega (01) : 
                  L_v_Msg := Fnd_Message.Get_String('MDB'
                                                   ,'MDB_OM_007C_052') ||
                             Sqlerrm;
                  P_MSG := ' - Erro no pedido: ' || R_Moll.Order_Number || ' Linha: '|| R_Moll.Line_Number||'.'||R_Moll.Shipment_Number 
                     || L_v_Msg;
              End;
              --
              If L_v_Msg = 'OK'
              Then
                -- Atualiza a DATA da linha no lote 
                Update Mdb_Otm_Lot_Lines_All Moll
                   Set Moll.Schedule_Ship_Date     = L_d_Base_Date_New
                      ,Moll.Schedule_Ship_Date_Old = Decode(Moll.Schedule_Ship_Date_Old
                                                           ,Null
                                                           ,Trunc(R_Moll.Schedule_Ship_Date)
                                                           ,Moll.Schedule_Ship_Date_Old)
                 Where Lot_Line_Id = R_Moll.Lot_Line_Id;
                Commit;
              Else
                BEGIN
                  
                  -- Atualiza o ERRO na linha no lote 
                  UPDATE_STATUS_LINE_P(R_Moll.Lot_Line_Id, L_v_Msg, 'SCHEDULE DATE ERROR');
                
                  -- Atualizar Status da WDD
                  L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
                  L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
                  L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
                  L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Lot_Otm_Status_Line_Code
                                                          ,'NO PROCESS');
                  L_r_Molls_Line.Status_Code_To     := 'SCHEDULE DATE ERROR'; -- Erro no SPLIT
                  L_r_Molls_Line.Comments           := L_v_Msg;
                  Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
                  
                  P_MSG := ' - Erro no pedido: ' || R_Moll.Order_Number || ' Linha: '|| R_Moll.Line_Number||'.'||R_Moll.Shipment_Number 
                     || L_v_Msg;
                  Commit;
                  L_n_Qtt_Errors := L_n_Qtt_Errors + 1;
                Exception
                  When Others Then
                    -- MDB_OM_007C_053 - Erro não esperado ao alterar a Data de Entrega (02) : 
                    L_v_Msg := Fnd_Message.Get_String('MDB'
                                                     ,'MDB_OM_007C_053') ||
                               Sqlerrm;
                    P_MSG := ' - Erro no pedido: ' || R_Moll.Order_Number || ' Linha: '|| R_Moll.Line_Number||'.'||R_Moll.Shipment_Number 
                     || L_v_Msg;
                    L_n_Qtt_Errors := L_n_Qtt_Errors + 1;
                End;
              End If;
            Else
              -- Se a quantidade usada mais a linha for maior que a quantidade maxima do veiculo
              -- Nao entrou no veiculo, entao ir para a proxima data
              -- Verificar o proximo dia util
              -- Atualizar linha com a data e a quantidade usada com a quantidade da linha
              L_n_Vehicle_Max_Use := R_Moll.Requested_Quantity_Conv_To_Set;
              -- Soma o intervalo de dias do parametro
              L_d_Base_Date_New := Trunc(L_d_Base_Date_New +
                                         R_Add_Use.Add_Days_To_Split_Quantity);
              -- Recupera a proxima data util
              L_d_Schedule_Ship_Date_Cal := Trunc(Mdb_Otm_Lot_Invoices_Pk.Get_Next_Day_Utl_f -- 
                                                  (P_Address_Id => R_Moll.Address_Id --
                                                 ,P_Day        => L_d_Base_Date_New -- 
                                                   ));
              -- Se for nao nula e dif da data base sobrepoe a mesma
              If L_d_Schedule_Ship_Date_Cal Is Not Null And
                 L_d_Schedule_Ship_Date_Cal != L_d_Base_Date_New
              Then
                L_d_Base_Date_New := L_d_Schedule_Ship_Date_Cal;
              End If;
              ------------------------------------------------------------------
              -- Procedure para Alterar a Data de Entrega Programada da Linha --
              ------------------------------------------------------------------
              Begin
                Mdb_Otm_Lot_Invoices_Pk.Schedule_Ship_Date_Update_p -- 
                (P_Action             => 'SCHEDULE_SHIP_DATE'
                ,P_Header_Id          => R_Moll.Header_Id --
                ,P_Line_Id            => R_Moll.Line_Id --
                ,P_Schedule_Ship_Date => L_d_Base_Date_New --
                ,P_Msg                => L_v_Msg --
                 );
              Exception
                When Others Then
                  -- MDB_OM_007C_054 - Erro não esperado ao alterar a Data de Entrega (03) : 
                  L_v_Msg := Fnd_Message.Get_String('MDB'
                                                   ,'MDB_OM_007C_054') ||
                             Sqlerrm;
                  P_MSG := ' - Erro no pedido: ' || R_Moll.Order_Number || ' Linha: '|| R_Moll.Line_Number||'.'||R_Moll.Shipment_Number 
                     || L_v_Msg;
              End;
              --
              If L_v_Msg = 'OK'
              Then
                -- Atualiza a DATA da linha no lote 
                Update Mdb_Otm_Lot_Lines_All Moll
                   Set Moll.Schedule_Ship_Date = L_d_Base_Date_New
                 Where Lot_Line_Id = R_Moll.Lot_Line_Id;
                Commit;
              Else
                BEGIN
                  
                  -- Atualiza o ERRO na linha no lote 
                  UPDATE_STATUS_LINE_P(R_Moll.Lot_Line_Id, L_v_Msg, 'SCHEDULE DATE ERROR');
                  
                  -- Atualizar Status da WDD
                  L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
                  L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
                  L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
                  L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Lot_Otm_Status_Line_Code
                                                          ,'NO PROCESS');
                  L_r_Molls_Line.Status_Code_To     := 'SCHEDULE DATE ERROR'; -- Erro no SPLIT
                  L_r_Molls_Line.Comments           := L_v_Msg;
                  Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
                  
                  P_MSG := ' - Erro no pedido: ' || R_Moll.Order_Number || ' Linha: '|| R_Moll.Line_Number||'.'||R_Moll.Shipment_Number 
                     || L_v_Msg;
                  Commit;
                  L_n_Qtt_Errors := L_n_Qtt_Errors + 1;
                Exception
                  When Others Then
                    -- MDB_OM_007C_055 - Erro não esperado ao alterar a Data de Entrega (04) : 
                    L_v_Msg := Fnd_Message.Get_String('MDB'
                                                     ,'MDB_OM_007C_055') ||
                               Sqlerrm;
                    P_MSG := ' - Erro no pedido: ' || R_Moll.Order_Number || ' Linha: '|| R_Moll.Line_Number||'.'||R_Moll.Shipment_Number 
                     || L_v_Msg;
                    L_n_Qtt_Errors := L_n_Qtt_Errors + 1;
                End;
              End If;
            End If;
          End Loop C_Moll;
          --         
        End Loop C_Add_Use;
        -- Retira as Linhas do Lote que ficaram com Data Maior que a Data de Criacao do Lote
        If L_v_Msg = 'OK'
        Then
          -------------------------------------
          -- Cursor das Linha do Cliente/End -- 
          -------------------------------------
          For R_Moll In C_Moll(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id -- 
                              ,Pc_Address_Id     => R_Add.Address_Id --
                               )
          Loop
            If Trunc(R_Moll.Schedule_Ship_Date) >
               Trunc(P_Moli.Creation_Date)
            Then
              -----------------------------
              -- Status OTM na WDD e Log --
              -----------------------------
              L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
              L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
              L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
              L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Lot_Otm_Status_Line_Code
                                                      ,'NO PROCESS');
              L_r_Molls_Line.Status_Code_To     := 'RESTRITION PLAN CUSTOMER'; -- Restrição de Entrega no Cliente
              L_r_Molls_Line.Comments           := ' - Replanejado para ' ||
                                                   To_Char(R_Moll.Schedule_Ship_Date
                                                          ,'DD-MON-YYYY');
              Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
              -- Retiro a linha do Lote de Corte --
              Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p --
              (P_Lot_Line_Id                  => R_Moll.Lot_Line_Id --
              ,P_Return_Ship_Date_Flag        => 'N' --
              ,P_Wdd_Otm_Status_Line_Code     => L_r_Molls_Line.Status_Code_To --
              ,P_Wdd_Otm_Status_Line_Comments => L_r_Molls_Line.Comments --
              ,P_Comments                     => 'Excluida no processo de validação' --              
               );
            End If;
          End Loop C_Moll;
        End If;
        Commit;
      End Loop C_Add;
    End If; -- OK
    P_QTT_ERROR := L_n_Qtt_Errors;
  End Schedule_Ship_Date_Select_p;

  ------------------------------------------------------------------
  -- Procedure para Alterar a Data de Entrega Programada da Linha --
  ------------------------------------------------------------------
  Procedure Schedule_Ship_Date_Update_p
  (
    P_Action             In Varchar2 Default Null
   ,P_Header_Id          In Number
   ,P_Line_Id            In Number
   ,P_Schedule_Ship_Date In Date Default Null
   ,P_Ship_Set_Id        In Number Default Null
   ,P_Subinventory       In Varchar2 Default Null
   ,P_Msg                In Out Varchar2
  ) Is
    L_Header_Rec                 Oe_Order_Pub.Header_Rec_Type;
    L_Line_Tbl                   Oe_Order_Pub.Line_Tbl_Type;
    L_Action_Request_Tbl         Oe_Order_Pub.Request_Tbl_Type;
    L_Header_Adj_Tbl             Oe_Order_Pub.Header_Adj_Tbl_Type;
    L_Line_Adj_Tbl               Oe_Order_Pub.Line_Adj_Tbl_Type;
    L_Header_Scr_Tbl             Oe_Order_Pub.Header_Scredit_Tbl_Type;
    L_Line_Scredit_Tbl           Oe_Order_Pub.Line_Scredit_Tbl_Type;
    L_Request_Rec                Oe_Order_Pub.Request_Rec_Type;
    L_Return_Status              Varchar2(1000);
    L_Msg_Count                  Number;
    L_Msg_Data                   Varchar2(1000);
    P_Api_Version_Number         Number := 1.0;
    P_Init_Msg_List              Varchar2(10) := Fnd_Api.G_False;
    P_Return_Values              Varchar2(10) := Fnd_Api.G_False;
    P_Action_Commit              Varchar2(10) := Fnd_Api.G_False;
    X_Return_Status              Varchar2(1);
    X_Msg_Count                  Number;
    X_Msg_Data                   Varchar2(100);
    P_Header_Rec                 Oe_Order_Pub.Header_Rec_Type := Oe_Order_Pub.G_Miss_Header_Rec;
    X_Header_Rec                 Oe_Order_Pub.Header_Rec_Type := Oe_Order_Pub.G_Miss_Header_Rec;
    P_Old_Header_Rec             Oe_Order_Pub.Header_Rec_Type := Oe_Order_Pub.G_Miss_Header_Rec;
    P_Header_Val_Rec             Oe_Order_Pub.Header_Val_Rec_Type := Oe_Order_Pub.G_Miss_Header_Val_Rec;
    P_Old_Header_Val_Rec         Oe_Order_Pub.Header_Val_Rec_Type := Oe_Order_Pub.G_Miss_Header_Val_Rec;
    P_Header_Adj_Tbl             Oe_Order_Pub.Header_Adj_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Tbl;
    P_Old_Header_Adj_Tbl         Oe_Order_Pub.Header_Adj_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Tbl;
    P_Header_Adj_Val_Tbl         Oe_Order_Pub.Header_Adj_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Val_Tbl;
    P_Old_Header_Adj_Val_Tbl     Oe_Order_Pub.Header_Adj_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Val_Tbl;
    P_Header_Price_Att_Tbl       Oe_Order_Pub.Header_Price_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Price_Att_Tbl;
    P_Old_Header_Price_Att_Tbl   Oe_Order_Pub.Header_Price_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Price_Att_Tbl;
    P_Header_Adj_Att_Tbl         Oe_Order_Pub.Header_Adj_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Att_Tbl;
    P_Old_Header_Adj_Att_Tbl     Oe_Order_Pub.Header_Adj_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Att_Tbl;
    P_Header_Adj_Assoc_Tbl       Oe_Order_Pub.Header_Adj_Assoc_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Assoc_Tbl;
    P_Old_Header_Adj_Assoc_Tbl   Oe_Order_Pub.Header_Adj_Assoc_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Adj_Assoc_Tbl;
    P_Header_Scredit_Tbl         Oe_Order_Pub.Header_Scredit_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Scredit_Tbl;
    P_Old_Header_Scredit_Tbl     Oe_Order_Pub.Header_Scredit_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Scredit_Tbl;
    P_Header_Scredit_Val_Tbl     Oe_Order_Pub.Header_Scredit_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Scredit_Val_Tbl;
    P_Old_Header_Scredit_Val_Tbl Oe_Order_Pub.Header_Scredit_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Header_Scredit_Val_Tbl;
    X_Line_Tbl                   Oe_Order_Pub.Line_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Tbl;
    P_Old_Line_Tbl               Oe_Order_Pub.Line_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Tbl;
    P_Line_Val_Tbl               Oe_Order_Pub.Line_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Val_Tbl;
    P_Old_Line_Val_Tbl           Oe_Order_Pub.Line_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Val_Tbl;
    P_Line_Adj_Tbl               Oe_Order_Pub.Line_Adj_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Tbl;
    P_Old_Line_Adj_Tbl           Oe_Order_Pub.Line_Adj_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Tbl;
    P_Line_Adj_Val_Tbl           Oe_Order_Pub.Line_Adj_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Val_Tbl;
    P_Old_Line_Adj_Val_Tbl       Oe_Order_Pub.Line_Adj_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Val_Tbl;
    P_Line_Price_Att_Tbl         Oe_Order_Pub.Line_Price_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Price_Att_Tbl;
    P_Old_Line_Price_Att_Tbl     Oe_Order_Pub.Line_Price_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Price_Att_Tbl;
    P_Line_Adj_Att_Tbl           Oe_Order_Pub.Line_Adj_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Att_Tbl;
    P_Old_Line_Adj_Att_Tbl       Oe_Order_Pub.Line_Adj_Att_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Att_Tbl;
    P_Line_Adj_Assoc_Tbl         Oe_Order_Pub.Line_Adj_Assoc_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Assoc_Tbl;
    P_Old_Line_Adj_Assoc_Tbl     Oe_Order_Pub.Line_Adj_Assoc_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Adj_Assoc_Tbl;
    P_Line_Scredit_Tbl           Oe_Order_Pub.Line_Scredit_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Scredit_Tbl;
    P_Old_Line_Scredit_Tbl       Oe_Order_Pub.Line_Scredit_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Scredit_Tbl;
    P_Line_Scredit_Val_Tbl       Oe_Order_Pub.Line_Scredit_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Scredit_Val_Tbl;
    P_Old_Line_Scredit_Val_Tbl   Oe_Order_Pub.Line_Scredit_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Line_Scredit_Val_Tbl;
    P_Lot_Serial_Tbl             Oe_Order_Pub.Lot_Serial_Tbl_Type := Oe_Order_Pub.G_Miss_Lot_Serial_Tbl;
    P_Old_Lot_Serial_Tbl         Oe_Order_Pub.Lot_Serial_Tbl_Type := Oe_Order_Pub.G_Miss_Lot_Serial_Tbl;
    P_Lot_Serial_Val_Tbl         Oe_Order_Pub.Lot_Serial_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Lot_Serial_Val_Tbl;
    P_Old_Lot_Serial_Val_Tbl     Oe_Order_Pub.Lot_Serial_Val_Tbl_Type := Oe_Order_Pub.G_Miss_Lot_Serial_Val_Tbl;
    P_Action_Request_Tbl         Oe_Order_Pub.Request_Tbl_Type := Oe_Order_Pub.G_Miss_Request_Tbl;
    X_Header_Val_Rec             Oe_Order_Pub.Header_Val_Rec_Type;
    X_Header_Adj_Tbl             Oe_Order_Pub.Header_Adj_Tbl_Type;
    X_Header_Adj_Val_Tbl         Oe_Order_Pub.Header_Adj_Val_Tbl_Type;
    X_Header_Price_Att_Tbl       Oe_Order_Pub.Header_Price_Att_Tbl_Type;
    X_Header_Adj_Att_Tbl         Oe_Order_Pub.Header_Adj_Att_Tbl_Type;
    X_Header_Adj_Assoc_Tbl       Oe_Order_Pub.Header_Adj_Assoc_Tbl_Type;
    X_Header_Scredit_Tbl         Oe_Order_Pub.Header_Scredit_Tbl_Type;
    X_Header_Scredit_Val_Tbl     Oe_Order_Pub.Header_Scredit_Val_Tbl_Type;
    X_Line_Val_Tbl               Oe_Order_Pub.Line_Val_Tbl_Type;
    X_Line_Adj_Tbl               Oe_Order_Pub.Line_Adj_Tbl_Type;
    X_Line_Adj_Val_Tbl           Oe_Order_Pub.Line_Adj_Val_Tbl_Type;
    X_Line_Price_Att_Tbl         Oe_Order_Pub.Line_Price_Att_Tbl_Type;
    X_Line_Adj_Att_Tbl           Oe_Order_Pub.Line_Adj_Att_Tbl_Type;
    X_Line_Adj_Assoc_Tbl         Oe_Order_Pub.Line_Adj_Assoc_Tbl_Type;
    X_Line_Scredit_Tbl           Oe_Order_Pub.Line_Scredit_Tbl_Type;
    X_Line_Scredit_Val_Tbl       Oe_Order_Pub.Line_Scredit_Val_Tbl_Type;
    X_Lot_Serial_Tbl             Oe_Order_Pub.Lot_Serial_Tbl_Type;
    X_Lot_Serial_Val_Tbl         Oe_Order_Pub.Lot_Serial_Val_Tbl_Type;
    X_Action_Request_Tbl         Oe_Order_Pub.Request_Tbl_Type;
    X_Debug_File                 Varchar2(100);
    L_Msg_Index_Out              Number(10);
    L_Line_Tbl_Index             Number;
    L_Msg_Index_In               Number(10) := 1;
  Begin
    --This is to update a line to an existing order  
    L_Line_Tbl_Index := 1;
    -- Changed attributes 
    L_Line_Tbl(L_Line_Tbl_Index) := Oe_Order_Pub.G_Miss_Line_Rec;
    If P_Action = 'SCHEDULE_SHIP_DATE'
    Then
      If P_Schedule_Ship_Date Is Not Null
      Then
        L_Line_Tbl(L_Line_Tbl_Index).Schedule_Ship_Date := P_Schedule_Ship_Date;
        L_Line_Tbl(L_Line_Tbl_Index).Earliest_Acceptable_Date := P_Schedule_Ship_Date;
        L_Line_Tbl(L_Line_Tbl_Index).Latest_Acceptable_Date := P_Schedule_Ship_Date;
      End If;
    Elsif P_Action = 'SHIP_SET_ID'
    Then
      L_Line_Tbl(L_Line_Tbl_Index).Ship_Set_Id := P_Ship_Set_Id;
    Elsif P_Action = 'SUBINVENTORY'
    Then
      If P_Subinventory Is Not Null
      Then
        L_Line_Tbl(L_Line_Tbl_Index).Subinventory := P_Subinventory;
      End If;
    End If; -- If P_Action = 
    --End If;
    -- Primary key of the entity i.e. the order line 
    L_Line_Tbl(L_Line_Tbl_Index).Line_Id := P_Line_Id;
    --L_Line_Tbl(L_Line_Tbl_Index).Change_Reason := 'Not provided';
    -- Indicates to process order that this is an update operation 
    L_Line_Tbl(L_Line_Tbl_Index).Operation := Oe_Globals.G_Opr_Update;
    -- CALL TO PROCESS ORDER  
    Oe_Order_Pub.Process_Order(P_Api_Version_Number => 1.0 --
                              ,P_Init_Msg_List      => Fnd_Api.G_False --
                              ,P_Return_Values      => Fnd_Api.G_False --
                              ,P_Action_Commit      => Fnd_Api.G_False --
                              ,X_Return_Status      => L_Return_Status --
                              ,X_Msg_Count          => L_Msg_Count --
                              ,X_Msg_Data           => L_Msg_Data --
                              ,P_Header_Rec         => L_Header_Rec --
                              ,P_Line_Tbl           => L_Line_Tbl --
                              ,P_Action_Request_Tbl => L_Action_Request_Tbl --
                               -- OUT PARAMETERS  
                              ,X_Header_Rec             => X_Header_Rec --
                              ,X_Header_Val_Rec         => X_Header_Val_Rec --
                              ,X_Header_Adj_Tbl         => X_Header_Adj_Tbl --
                              ,X_Header_Adj_Val_Tbl     => X_Header_Adj_Val_Tbl --
                              ,X_Header_Price_Att_Tbl   => X_Header_Price_Att_Tbl --
                              ,X_Header_Adj_Att_Tbl     => X_Header_Adj_Att_Tbl --
                              ,X_Header_Adj_Assoc_Tbl   => X_Header_Adj_Assoc_Tbl --
                              ,X_Header_Scredit_Tbl     => X_Header_Scredit_Tbl --
                              ,X_Header_Scredit_Val_Tbl => X_Header_Scredit_Val_Tbl --
                              ,X_Line_Tbl               => X_Line_Tbl --
                              ,X_Line_Val_Tbl           => X_Line_Val_Tbl --
                              ,X_Line_Adj_Tbl           => X_Line_Adj_Tbl --
                              ,X_Line_Adj_Val_Tbl       => X_Line_Adj_Val_Tbl --
                              ,X_Line_Price_Att_Tbl     => X_Line_Price_Att_Tbl --
                              ,X_Line_Adj_Att_Tbl       => X_Line_Adj_Att_Tbl --
                              ,X_Line_Adj_Assoc_Tbl     => X_Line_Adj_Assoc_Tbl --
                              ,X_Line_Scredit_Tbl       => X_Line_Scredit_Tbl --
                              ,X_Line_Scredit_Val_Tbl   => X_Line_Scredit_Val_Tbl --
                              ,X_Lot_Serial_Tbl         => X_Lot_Serial_Tbl --
                              ,X_Lot_Serial_Val_Tbl     => X_Lot_Serial_Val_Tbl --
                              ,X_Action_Request_Tbl     => X_Action_Request_Tbl --
                               );
    -- Check the return status 
    If L_Return_Status = Fnd_Api.G_Ret_Sts_Success
    Then
      P_Msg := 'OK';
    Else
      -- Retrieve messages 
      Oe_Msg_Pub.Get(P_Msg_Index     => L_Msg_Index_In --
                    ,P_Encoded       => Fnd_Api.G_False --
                    ,P_Data          => L_Msg_Data --
                    ,P_Msg_Index_Out => L_Msg_Index_Out --
                     );
      P_Msg := Nvl(L_Msg_Data, 'NOK');
    End If;
  End Schedule_Ship_Date_Update_p;

  -------------------------------------------------------------
  -- Procedure para validar a quantidade minima para entrega --
  -------------------------------------------------------------
  Procedure Min_Delivery_Validation_p(P_Moli Mdb_Otm_Lot_Invoices_All %Rowtype) Is
    -------------------------------------------------------------------
    -- Cursor para recuperar a quantidade minima por rota de entrega --
    -------------------------------------------------------------------
    Cursor C_Mocr(Pc_Lot_Invoice_Id Number) Is
      Select Moll.Add_Customer_Route_Id
            ,Sum(Moll.Moc_Min_Requested_Quantity) Moc_Min_Requested_Quantity_Sum
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
         And Moll.Moc_Min_Requested_Quantity Is Not Null -- So quem tem conf.de minimo
       Group By Moll.Add_Customer_Route_Id;
    ---------------------------------------------------------------------------
    -- Cursor para recuperar a configuracao da rota de entrega usada no Lote -- 
    ---------------------------------------------------------------------------
    Cursor C_Mocr_Set
    (
      Pc_Lot_Invoice_Id        Number
     ,Pc_Add_Customer_Route_Id Number
    ) Is
      Select Moll.Moc_Min_Delivery_Quantity
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Add_Customer_Route_Id = Pc_Add_Customer_Route_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
         And Moll.Moc_Min_Requested_Quantity Is Not Null -- So quem tem conf.de minimo
         And Rownum = 1;
    ----------------------------------------------
    -- Cursor das Linhas do Lote para equalizar --
    ----------------------------------------------
    Cursor C_Moll_Mocr
    (
      Pc_Lot_Invoice_Id        Number
     ,Pc_Add_Customer_Route_Id Number
    ) Is
      Select Moll.*
            ,Moll.Rowid     Rowid_Moll
            ,Wdd.Attribute1 Attribute1_Wdd
        From Mdb_Otm_Lot_Lines_All Moll
            ,Wsh_Delivery_Details  Wdd
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Add_Customer_Route_Id = Pc_Add_Customer_Route_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
         And Wdd.Delivery_Detail_Id = Moll.Delivery_Detail_Id
         And Moll.Moc_Min_Requested_Quantity Is Not Null -- So quem tem conf.de minimo
      ;
    ---------------------------------------------------------------------
    -- Cursor para recuperar a quantidade minima por Metodo de Entrega --
    ---------------------------------------------------------------------
    Cursor C_Mosm(Pc_Lot_Invoice_Id Number) Is
      Select Moll.Ship_Method_Code
            ,Sum(Moll.Smc_Min_Requested_Quantity) Smc_Min_Requested_Quantity_Sum
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
         And Moll.Smc_Min_Requested_Quantity Is Not Null -- So quem tem conf.de minimo
       Group By Moll.Ship_Method_Code;
    -----------------------------------------------------------------------------
    -- Cursor para recuperar a configuracao do Metodo de Entrega usada no Lote -- 
    -----------------------------------------------------------------------------
    Cursor C_Mosm_Set
    (
      Pc_Lot_Invoice_Id   Number
     ,Pc_Ship_Method_Code Varchar2
    ) Is
      Select Moll.Smc_Min_Line_Quantity
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Ship_Method_Code = Pc_Ship_Method_Code
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
         And Moll.Smc_Min_Requested_Quantity Is Not Null -- So quem tem conf.de minimo
         And Rownum = 1;
    ----------------------------------------------
    -- Cursor das Linhas do Lote para equalizar --
    ----------------------------------------------
    Cursor C_Moll_Mosm
    (
      Pc_Lot_Invoice_Id   Number
     ,Pc_Ship_Method_Code Varchar2
    ) Is
      Select Moll.*
            ,Moll.Rowid     Rowid_Moll
            ,Wdd.Attribute1 Attribute1_Wdd
        From Mdb_Otm_Lot_Lines_All Moll
            ,Wsh_Delivery_Details  Wdd
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Ship_Method_Code = Pc_Ship_Method_Code
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
         And Wdd.Delivery_Detail_Id = Moll.Delivery_Detail_Id
         And Moll.Smc_Min_Requested_Quantity Is Not Null -- So quem tem conf.de minimo         
      ;
    -- Variaveis 
    L_n_Commit     Number := 0;
    L_r_Molls_Line Mdb_Otm_Line_Log_Status_All%Rowtype;
  Begin
    -------------------------------------------------------------------
    -- Cursor para recuperar a quantidade minima por rota de entrega -- Inicio
    -------------------------------------------------------------------
    For R_Mocr In C_Mocr(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      --Select Moll.Add_Customer_Route_Id
      ---------------------------------------------------------------------------
      -- Cursor para recuperar a configuracao da rota de entrega usada no Lote -- 
      ---------------------------------------------------------------------------
      For R_Mocr_Set In C_Mocr_Set(Pc_Lot_Invoice_Id        => P_Moli.Lot_Invoice_Id --
                                  ,Pc_Add_Customer_Route_Id => R_Mocr.Add_Customer_Route_Id --
                                   )
      Loop
        ----------------------------------------
        -- Se não atingiu a quantidade minima --
        ----------------------------------------
        If R_Mocr.Moc_Min_Requested_Quantity_Sum <
           R_Mocr_Set.Moc_Min_Delivery_Quantity
        Then
          ----------------------------------------------
          -- Cursor das Linhas do Lote para equalizar --
          ----------------------------------------------
          For R_Moll_Mocr In C_Moll_Mocr(Pc_Lot_Invoice_Id        => P_Moli.Lot_Invoice_Id --
                                        ,Pc_Add_Customer_Route_Id => R_Mocr.Add_Customer_Route_Id --
                                         )
          Loop
            -- Status OTM na WDD e Log
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll_Mocr.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll_Mocr.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll_Mocr.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll_Mocr.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'QTD MINIMUM DELIVERY'; -- Abaixo da Quantidade Mínima de Remessa 
            L_r_Molls_Line.Comments           := To_Char(Sysdate
                                                        ,'DD-MON-YYYY');
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Atualiza Status no Lote
            Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p --
            (P_Rowid                        => R_Moll_Mocr.Rowid_Moll
            ,P_Wdd_Otm_Status_Line_Code     => L_r_Molls_Line.Status_Code_To --
            ,P_Wdd_Otm_Status_Line_Comments => L_r_Molls_Line.Comments --
            ,P_Comments                     => 'Excluida no processo de validação' --
             );
            -- Controle de Commit
            L_n_Commit := L_n_Commit + 1;
            If L_n_Commit >= 1000
            Then
              L_n_Commit := 0;
              Commit;
            End If;
          End Loop C_Moll_Mocr;
        End If;
      End Loop C_Mocr_Set;
    End Loop C_Mocr;
    -------------------------------------------------------------------
    -- Cursor para recuperar a quantidade minima por rota de entrega -- Fim
    -------------------------------------------------------------------
    -------------------------------------------------------------------
    -- Cursor para recuperar a quantidade minima por Metodo de Entrega -- Inicio
    -------------------------------------------------------------------
    For R_Mosm In C_Mosm(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      --Select Moll.Add_Customer_Route_Id
      -----------------------------------------------------------------------------
      -- Cursor para recuperar a configuracao do Metodo de Entrega usada no Lote -- 
      -----------------------------------------------------------------------------
      For R_Mosm_Set In C_Mosm_Set(Pc_Lot_Invoice_Id   => P_Moli.Lot_Invoice_Id --
                                  ,Pc_Ship_Method_Code => R_Mosm.Ship_Method_Code --
                                   )
      Loop
        ----------------------------------------
        -- Se não atingiu a quantidade minima --
        ----------------------------------------
        If R_Mosm.Smc_Min_Requested_Quantity_Sum <
           R_Mosm_Set.Smc_Min_Line_Quantity
        Then
          ----------------------------------------------
          -- Cursor das Linhas do Lote para equalizar --
          ----------------------------------------------
          For R_Moll_Mosm In C_Moll_Mosm(Pc_Lot_Invoice_Id   => P_Moli.Lot_Invoice_Id --
                                        ,Pc_Ship_Method_Code => R_Mosm.Ship_Method_Code --
                                         )
          Loop
            -- Status OTM na WDD e Log
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll_Mosm.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll_Mosm.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll_Mosm.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll_Mosm.Attribute1_Wdd
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'QTD MINIMUM DELIVERY'; -- Abaixo da Quantidade Mínima de Remessa 
            L_r_Molls_Line.Comments           := To_Char(Sysdate
                                                        ,'DD-MON-YYYY');
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -- Atualiza Status no Lote
            Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p --
            (P_Rowid                        => R_Moll_Mosm.Rowid_Moll -- 
            ,P_Wdd_Otm_Status_Line_Code     => L_r_Molls_Line.Status_Code_To --
            ,P_Wdd_Otm_Status_Line_Comments => L_r_Molls_Line.Comments --
            ,P_Comments                     => 'Excluida no processo de validação' --
             );
            -- Controle de Commit
            L_n_Commit := L_n_Commit + 1;
            If L_n_Commit >= 1000
            Then
              L_n_Commit := 0;
              Commit;
            End If;
          End Loop C_Moll_Mosm;
        End If;
      End Loop C_Mosm_Set;
    End Loop C_Mosm;
    -------------------------------------------------------------------
    -- Cursor para recuperar a quantidade minima por Metodo de Entrega -- Fim
    -------------------------------------------------------------------
  End Min_Delivery_Validation_p;

  ----------------------------------------------------------------
  -- Procedure para Recuperar as linhas para separar do Estoque --
  ----------------------------------------------------------------
  Procedure Picking_Batch_Select_p(P_Moli Mdb_Otm_Lot_Invoices_All %Rowtype) Is
    ------------------------
    -- Regra de Separacao --
    ------------------------
    Cursor C_Wpv(Pc_Picking_Rule_Id Number) Is
      Select Wpr.*
        From Wsh_Picking_Rules Wpr
       Where Wpr.Picking_Rule_Id = Pc_Picking_Rule_Id;
    ------------------------------------------------------
    -- Cursor das Linhas itens que precisam ter reserva -- 
    ------------------------------------------------------
    Cursor C_Moll(Pc_Lot_Invoice_Id Number) Is
      Select Moll.*
        From Mdb_Otm_Lot_Lines_All Moll
            ,Wsh_Delivery_Details  Wdd
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
            --
         And Wdd.Delivery_Detail_Id = Moll.Delivery_Detail_Id
         And Wdd.Released_Status In ('B' -- Com Backorder /
                                    ,'R' -- Pronto para Liberação
                                     -- 'Y' -- Preparação/Separação Confirmada
                                     )
       Order By Moll.Smc_Separation_Sequence
               ,Moll.Shipment_Priority_Code Asc Nulls Last
               ,Moll.Schedule_Ship_Date
               ,Moll.Header_Id
               ,Moll.Line_Number
               ,Moll.Shipment_Number;
    -- 
    ----------------------------------
    -- Cursor das Linhas de Entrega --
    ----------------------------------
    Cursor C_Wdd
    (
      Pc_Header_Id          Number
     ,Pc_Line_Id            Number
     ,Pc_Delivery_Detail_Id Number
    ) Is
      Select Wdd.Delivery_Detail_Id
            ,Ool.Schedule_Ship_Date
            ,Ool.Header_Id
            ,Ool.Line_Id
            ,Ool.Inventory_Item_Id
            ,Wdd.Requested_Quantity_Uom
            ,Wdd.Requested_Quantity
            ,Wdd.Unit_Price
            ,Rsu.Address_Id
            ,Wdd.Ship_Method_Code
            ,Wdd.Attribute1
            ,Wdd.Attribute2
            ,Ra.Global_Attribute3 || Ra.Global_Attribute4 ||
             Ra.Global_Attribute5 Document_Number
            ,Ool.Line_Number
            ,Ool.Shipment_Number
            ,Ooh.Order_Number
            ,Ool.Line_Type_Id
            ,Wdd.Released_Status -- 'R' -- Pronto para Liberação / 'B' -- Com Backorder / 'Y' -- Preparação/Separação Confirmada
        From Wsh_Delivery_Details Wdd
            ,Oe_Order_Lines_All   Ool
            ,Oe_Order_Headers_All Ooh
            ,Ra_Site_Uses_All     Rsu
            ,Ra_Addresses_All     Ra
            ,Fnd_Lookup_Values    Flv_Otm_Line_Status
       Where Wdd.Source_Code = 'OE'
            -- Pedido
         And Wdd.Source_Header_Id = Pc_Header_Id
         And Wdd.Source_Line_Id = Pc_Line_Id
         And Wdd.Delivery_Detail_Id = Pc_Delivery_Detail_Id
            -- Site Use / Endereco
         And Rsu.Site_Use_Id = Wdd.Ship_To_Site_Use_Id
            -- Endereco
         And Ra.Address_Id = Rsu.Address_Id
            -- Status da Entrega 
            -- Linha do Pedido
         And Ool.Line_Id = Wdd.Source_Line_Id
         And Ooh.Header_Id = Ool.Header_Id
            -- Verificar o status OTM da linha 
         And Flv_Otm_Line_Status.Lookup_Type = 'MDB_OTM_LINE_STATUS'
         And Flv_Otm_Line_Status.Lookup_Code =
             Nvl(Wdd.Attribute1, 'NO PROCESS')
         And Flv_Otm_Line_Status.Enabled_Flag = 'Y'
         And Flv_Otm_Line_Status.Language = Userenv('LANG') --    
      Union
      Select Wdd.Delivery_Detail_Id
            ,Ool.Schedule_Ship_Date
            ,Ool.Header_Id
            ,Ool.Line_Id
            ,Ool.Inventory_Item_Id
            ,Wdd.Requested_Quantity_Uom
            ,Wdd.Requested_Quantity
            ,Wdd.Unit_Price
            ,Rsu.Address_Id
            ,Wdd.Ship_Method_Code
            ,Wdd.Attribute1
            ,Wdd.Attribute2
            ,Ra.Global_Attribute3 || Ra.Global_Attribute4 ||
             Ra.Global_Attribute5 Document_Number
            ,Ool.Line_Number
            ,Ool.Shipment_Number
            ,Ooh.Order_Number
            ,Ool.Line_Type_Id
            ,Wdd.Released_Status -- 'R' -- Pronto para Liberação / 'B' -- Com Backorder / 'Y' -- Preparação/Separação Confirmada
        From Wsh_Delivery_Details Wdd
            ,Oe_Order_Lines_All   Ool
            ,Oe_Order_Headers_All Ooh
            ,Ra_Site_Uses_All     Rsu
            ,Ra_Addresses_All     Ra
            ,Fnd_Lookup_Values    Flv_Otm_Line_Status
       Where Wdd.Source_Code = 'OE'
            -- Pedido
         And Wdd.Source_Header_Id = Pc_Header_Id
         And Wdd.Source_Line_Id = Pc_Line_Id
         And Wdd.Split_From_Delivery_Detail_Id = Pc_Delivery_Detail_Id
            -- Site Use / Endereco
         And Rsu.Site_Use_Id = Wdd.Ship_To_Site_Use_Id
            -- Endereco
         And Ra.Address_Id = Rsu.Address_Id
            -- Status da Entrega 
            -- Linha do Pedido
         And Ool.Line_Id = Wdd.Source_Line_Id
         And Ooh.Header_Id = Ool.Header_Id
            -- Verificar o status OTM da linha 
         And Flv_Otm_Line_Status.Lookup_Type = 'MDB_OTM_LINE_STATUS'
         And Flv_Otm_Line_Status.Lookup_Code =
             Nvl(Wdd.Attribute1, 'NO PROCESS')
         And Flv_Otm_Line_Status.Enabled_Flag = 'Y'
         And Flv_Otm_Line_Status.Language = Userenv('LANG') --             
       Order By 1;
    -- Variaveis 
    L_v_Msg        Varchar2(1000);
    L_r_Molls_Line Mdb_Otm_Line_Log_Status_All%Rowtype;
    L_r_Moll       Mdb_Otm_Lot_Lines_All%Rowtype;
    L_n_Batch_Id   Number;
  Begin
    ------------------------
    -- Regra de Separacao --
    ------------------------
    For R_Wpv In C_Wpv(Pc_Picking_Rule_Id => P_Moli.Picking_Rule_Id)
    Loop
      ------------------------------------------------------
      -- Cursor das Linhas itens que precisam ter reserva -- 
      ------------------------------------------------------
      For R_Moll In C_Moll(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
      Loop
        -----------------------------------
        -- Chama o processo de Separacao --
        -----------------------------------
        Mdb_Otm_Lot_Invoices_Pk.Picking_Batch_Line_p(P_Moli     => P_Moli --
                                                    ,P_Moll     => R_Moll --
                                                    ,P_Wpr      => R_Wpv --
                                                    ,P_Batch_Id => L_n_Batch_Id --
                                                    ,P_Msg      => L_v_Msg --
                                                     );
        If L_v_Msg = 'OK'
        Then
          ----------------------------------
          -- Cursor das Linhas de Entrega --
          ----------------------------------
          For R_Wdd In C_Wdd(Pc_Header_Id          => R_Moll.Header_Id --
                            ,Pc_Line_Id            => R_Moll.Line_Id --
                            ,Pc_Delivery_Detail_Id => R_Moll.Delivery_Detail_Id --
                             )
          Loop
            L_r_Moll := Null;
            -- 'Y' -- Preparação/Separação Confirmada  
            If R_Wdd.Released_Status = 'Y'
            Then
              -- Verificar se a linha ja esta no Lote --
              If R_Moll.Delivery_Detail_Id = R_Wdd.Delivery_Detail_Id
              Then
                -- Se tem diferenca para atualizar a linha atual do Lote
                If R_Moll.Requested_Quantity != R_Wdd.Requested_Quantity
                Then
                  -- Atualiza a linha
                  -- Converte o novo valor para a Unidade de Media da Configuracao
                  If R_Moll.Requested_Quantity_Uom !=
                     R_Moll.Use_Max_Line_Uom
                  Then
                    L_r_Moll.Requested_Quantity_Conv_To_Set := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                               (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                               ,P_From_Quantity => R_Wdd.Requested_Quantity --
                                                               ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                               ,P_To_Unit       => R_Moll.Use_Max_Line_Uom --
                                                                );
                  Else
                    L_r_Moll.Requested_Quantity_Conv_To_Set := R_Wdd.Requested_Quantity;
                  End If;
                  -- Se a UOM Solicitada for Dif da UOM da Config.
                  If R_Moll.Requested_Quantity_Uom !=
                     Nvl(R_Moll.Smc_Min_Line_Uom
                        ,R_Moll.Requested_Quantity_Uom)
                  Then
                    -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
                    L_r_Moll.Smc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                           (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                           ,P_From_Quantity => R_Wdd.Requested_Quantity --
                                                           ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                           ,P_To_Unit       => R_Moll.Smc_Min_Line_Uom --
                                                            );
                  Else
                    L_r_Moll.Smc_Min_Requested_Quantity := R_Wdd.Requested_Quantity;
                  End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then                                                        
                  -- Se a UOM Solicitada for Dif da UOM da Config.
                  If R_Moll.Requested_Quantity_Uom !=
                     Nvl(R_Moll.Moc_Min_Delivery_Uom
                        ,R_Moll.Requested_Quantity_Uom)
                  Then
                    -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
                    L_r_Moll.Moc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                           (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                           ,P_From_Quantity => R_Wdd.Requested_Quantity --
                                                           ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                           ,P_To_Unit       => R_Moll.Moc_Min_Delivery_Uom --
                                                            );
                  Else
                    L_r_Moll.Moc_Min_Requested_Quantity := R_Wdd.Requested_Quantity;
                  End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then
                  -- Atualiza a quantidade da linha no lote 
                  Update Mdb_Otm_Lot_Lines_All Roll
                     Set Roll.Requested_Quantity             = R_Wdd.Requested_Quantity
                        ,Roll.Requested_Quantity_Conv_To_Set = Nvl(L_r_Moll.Requested_Quantity_Conv_To_Set
                                                                  ,Roll.Requested_Quantity_Conv_To_Set)
                        ,Roll.Moc_Min_Requested_Quantity     = Nvl(L_r_Moll.Moc_Min_Requested_Quantity
                                                                  ,Roll.Moc_Min_Requested_Quantity)
                        ,Roll.Smc_Min_Requested_Quantity     = Nvl(L_r_Moll.Smc_Min_Requested_Quantity
                                                                  ,Roll.Smc_Min_Requested_Quantity)
                  --,Roll.Lot_Otm_Status_Line_Code       = 'SELECTED' -- 'PREPARED FOR SEND OTM' -- Preparado para Envio para OTM
                   Where Lot_Line_Id = R_Moll.Lot_Line_Id;
                End If;
                -- Atualizar Status da WDD
                --L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
                --L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
                --L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
                --L_r_Molls_Line.Status_Code_From   := Nvl(R_Wdd.Attribute1, 'NO PROCESS');
                --L_r_Molls_Line.Status_Code_To     := 'SELECTED'; -- 'PREPARED FOR SEND OTM'; -- Preparado para Envio para OTM
                --L_r_Molls_Line.Comments           := Null;
                --Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
              Else
                -- Eh uma linha nova para incluir no lote 
                -- Recupera as informacoes da linha Pai
                L_r_Moll := R_Moll;
                -- Prepara a linha para inclusao
                Select Mdb_Otm_Lot_Lines_S.Nextval
                  Into L_r_Moll.Lot_Line_Id
                  From Dual;
                L_r_Moll.Schedule_Ship_Date           := trunc(R_Wdd.Schedule_Ship_Date);
                L_r_Moll.Line_Id                      := R_Wdd.Line_Id;
                L_r_Moll.Line_Number                  := R_Wdd.Line_Number;
                L_r_Moll.Shipment_Number              := R_Wdd.Shipment_Number;
                L_r_Moll.Line_Type_Id                 := R_Wdd.Line_Type_Id;
                L_r_Moll.Delivery_Detail_Id           := R_Wdd.Delivery_Detail_Id;
                L_r_Moll.Inventory_Item_Id            := R_Wdd.Inventory_Item_Id;
                L_r_Moll.Requested_Quantity_Uom       := R_Wdd.Requested_Quantity_Uom;
                L_r_Moll.Requested_Quantity           := R_Wdd.Requested_Quantity;
                L_r_Moll.Unit_Price                   := R_Wdd.Unit_Price;
                L_r_Moll.Selected_Flag                := 'Y';
                L_r_Moll.Address_Id                   := R_Wdd.Address_Id;
                L_r_Moll.Document_Number              := R_Wdd.Document_Number;
                L_r_Moll.Ship_Method_Code             := R_Wdd.Ship_Method_Code;
                L_r_Moll.Lot_Otm_Status_Line_Code     := 'SELECTED'; -- 'PREPARED FOR SEND OTM'; -- Preparado para Envio para OTM
                L_r_Moll.Lot_Otm_Status_Line_Comments := Null;
                L_r_Moll.Creation_Date                := Sysdate;
                L_r_Moll.Created_By                   := Fnd_Global.User_Id;
                L_r_Moll.Last_Update_Date             := Sysdate;
                L_r_Moll.Last_Updated_By              := Fnd_Global.User_Id;
                L_r_Moll.Last_Update_Login            := Fnd_Global.Login_Id;
                L_r_Moll.Batch_Id                     := L_n_Batch_Id;
                L_r_Moll.Split_From_Line_Id           := Null;
                L_r_Moll.Split_From_Line_Id_Wdd       := R_Moll.Line_Id;
                -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
                If R_Wdd.Requested_Quantity_Uom !=
                   L_r_Moll.Use_Max_Line_Uom
                Then
                  L_r_Moll.Requested_Quantity_Conv_To_Set := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                             (P_Item_Id       => R_Wdd.Inventory_Item_Id --
                                                             ,P_From_Quantity => R_Wdd.Requested_Quantity --
                                                             ,P_From_Unit     => R_Wdd.Requested_Quantity_Uom --
                                                             ,P_To_Unit       => L_r_Moll.Use_Max_Line_Uom --
                                                              );
                Else
                  L_r_Moll.Requested_Quantity_Conv_To_Set := R_Wdd.Requested_Quantity;
                End If;
                -- Se a UOM Solicitada for Dif da UOM da Config.
                If L_r_Moll.Requested_Quantity_Uom !=
                   Nvl(L_r_Moll.Smc_Min_Line_Uom
                      ,L_r_Moll.Requested_Quantity_Uom)
                Then
                  -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
                  L_r_Moll.Smc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                         (P_Item_Id       => L_r_Moll.Inventory_Item_Id --
                                                         ,P_From_Quantity => R_Wdd.Requested_Quantity --
                                                         ,P_From_Unit     => R_Wdd.Requested_Quantity_Uom --
                                                         ,P_To_Unit       => L_r_Moll.Smc_Min_Line_Uom --
                                                          );
                Else
                  L_r_Moll.Smc_Min_Requested_Quantity := R_Wdd.Requested_Quantity;
                End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then                                                        
                -- Se a UOM Solicitada for Dif da UOM da Config.
                If L_r_Moll.Requested_Quantity_Uom !=
                   Nvl(L_r_Moll.Moc_Min_Delivery_Uom
                      ,L_r_Moll.Requested_Quantity_Uom)
                Then
                  -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
                  L_r_Moll.Moc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                         (P_Item_Id       => L_r_Moll.Inventory_Item_Id --
                                                         ,P_From_Quantity => R_Wdd.Requested_Quantity --
                                                         ,P_From_Unit     => L_r_Moll.Requested_Quantity_Uom --
                                                         ,P_To_Unit       => L_r_Moll.Moc_Min_Delivery_Uom --
                                                          );
                Else
                  L_r_Moll.Moc_Min_Requested_Quantity := R_Wdd.Requested_Quantity;
                End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then
                --
                Begin
                  -- Inclui a linha no Lote
                  Insert Into Mdb_Otm_Lot_Lines_All
                  Values L_r_Moll;
                  -- Atualizar Status da WDD
                  L_r_Molls_Line.Delivery_Detail_Id := R_Wdd.Delivery_Detail_Id;
                  L_r_Molls_Line.Organization_Id    := P_Moli.Organization_Id;
                  L_r_Molls_Line.Org_Id             := P_Moli.Org_Id;
                  L_r_Molls_Line.Status_Code_From   := Nvl(R_Wdd.Attribute1
                                                          ,'NO PROCESS'); -- 'PREPARED FOR SEND OTM';
                  L_r_Molls_Line.Status_Code_To     := 'SELECTED'; -- 'PREPARED FOR SEND OTM'; -- Preparado para Envio para OTM;
                  L_r_Molls_Line.Comments           := Null;
                  Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
                End;
              End If; -- If R_Moll.Delivery_Detail_Id = R_Wdd.Delivery_Detail_Id Then
              -- 'B' -- Com Backorder                
            Elsif R_Wdd.Released_Status = 'B'
            Then
              -- Atualizar Status da WDD
              L_r_Molls_Line.Delivery_Detail_Id := R_Wdd.Delivery_Detail_Id;
              L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
              L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
              L_r_Molls_Line.Status_Code_From   := Nvl(R_Wdd.Attribute1
                                                      ,'NO PROCESS');
              L_r_Molls_Line.Status_Code_To     := 'BACKORDER AUTO'; -- Ruptura Automática (BackOrder)
              L_r_Molls_Line.Comments           := To_Char(Sysdate
                                                          ,'DD-MON-RRRR HH24:MI:SS');
              Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
              --------------------
              -- Retira do Lote --
              --------------------
              Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p --
              (P_Lot_Line_Id                  => R_Moll.Lot_Line_Id -- 
              ,P_Delivery_Detail_Id           => R_Wdd.Delivery_Detail_Id
              ,P_Wdd_Otm_Status_Line_Code     => L_r_Molls_Line.Status_Code_To --
              ,P_Wdd_Otm_Status_Line_Comments => L_r_Molls_Line.Comments --
              ,P_Comments                     => 'Excluida no processo de SPLIT' --
               );
            Else
              -- Ver status para as linhas q nao tem saldo e nao ficaram em BACK ORDER ???
              -- Atualizar Status da WDD
              L_r_Molls_Line.Delivery_Detail_Id := R_Wdd.Delivery_Detail_Id;
              L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
              L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
              L_r_Molls_Line.Status_Code_From   := Nvl(R_Wdd.Attribute1
                                                      ,'NO PROCESS');
              L_r_Molls_Line.Status_Code_To     := 'BACKORDER AUTO'; -- Ruptura Automática (BackOrder)
              L_r_Molls_Line.Comments           := To_Char(Sysdate
                                                          ,'DD-MON-RRRR HH24:MI:SS');
              Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
              --------------------
              -- Retira do Lote --
              --------------------
              Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p --
              (P_Lot_Line_Id                  => R_Moll.Lot_Line_Id -- 
              ,P_Delivery_Detail_Id           => R_Wdd.Delivery_Detail_Id --
              ,P_Wdd_Otm_Status_Line_Code     => L_r_Molls_Line.Status_Code_To --
              ,P_Wdd_Otm_Status_Line_Comments => L_r_Molls_Line.Comments --
              ,P_Comments                     => 'Excluida no processo de SPLIT' --
               );
            End If; -- If L_r_Wdd.Released_Status 
          End Loop C_Wdd;
        Else
          Begin
            -- Atualizar Status da WDD
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Lot_Otm_Status_Line_Code
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'PICKING ERROR'; -- Erro na Separação
            L_r_Molls_Line.Comments           := L_v_Msg;
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            -----------------------------
            -- Atualiza Status no Lote --
            -----------------------------
            Update Mdb_Otm_Lot_Lines_All
               Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                  ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
             Where Lot_Line_Id = R_Moll.Lot_Line_Id;
            Commit;
            Exit;
            --Exception
            --  When Others Then
            --    Exit;
          End;
        End If;
      End Loop C_Moll;
    End Loop C_Wpv;
  End Picking_Batch_Select_p;

  --------------------------------------------------------------
  -- Procedure para processar a linha para separar do Estoque --
  --------------------------------------------------------------
  Procedure Picking_Batch_Line_p
  (
    P_Moli     Mdb_Otm_Lot_Invoices_All %Rowtype
   ,P_Moll     Mdb_Otm_Lot_Lines_All %Rowtype
   ,P_Wpr      Wsh_Picking_Rules %Rowtype
   ,P_Batch_Id In Out Number
   ,P_Msg      In Out Varchar2
  ) Is
    --
    L_Return_Status  Varchar2(1);
    L_Msg_Count      Number(15);
    L_Msg_Data       Varchar2(2000);
    L_Count          Number(15);
    L_Msg_Data_Out   Varchar2(2000);
    L_Mesg           Varchar2(2000);
    P_Count          Number(15);
    L_n_New_Batch_Id Number;
    L_Rule_Id        Number;
    L_Rule_Name      Varchar2(2000);
    L_Batch_Prefix   Varchar2(2000);
    L_Batch_Info_Rec Wsh_Picking_Batches_Pub.Batch_Info_Rec;
    L_Request_Id     Number;
    L_Msg_Index_Out  Number(10);
    L_Msg_Index_In   Number := 1;
    --
    L_v_Return_Status Varchar2(1);
    L_n_Msg_Count     Number(15);
    L_v_Msg_Data      Varchar2(2000);
  Begin
    L_Batch_Info_Rec.Delivery_Detail_Id         := P_Moll.Delivery_Detail_Id; -- Lote
    L_Batch_Info_Rec.Backorders_Only_Flag       := P_Wpr.Backorders_Only_Flag;
    L_Batch_Info_Rec.Document_Set_Id            := 1006; --Null; -- P_Wpr.Document_Set_Id;
    L_Batch_Info_Rec.Existing_Rsvs_Only_Flag    := P_Wpr.Existing_Rsvs_Only_Flag;
    L_Batch_Info_Rec.Shipment_Priority_Code     := P_Moll.Shipment_Priority_Code; -- Lote
    L_Batch_Info_Rec.Ship_Method_Code           := P_Moll.Ship_Method_Code; -- Lote
    L_Batch_Info_Rec.Customer_Id                := P_Wpr.Customer_Id;
    L_Batch_Info_Rec.Order_Header_Id            := P_Moll.Header_Id;
    L_Batch_Info_Rec.Ship_Set_Number            := P_Wpr.Ship_Set_Number;
    L_Batch_Info_Rec.Inventory_Item_Id          := P_Wpr.Inventory_Item_Id;
    L_Batch_Info_Rec.Order_Type_Id              := P_Wpr.Order_Type_Id;
    L_Batch_Info_Rec.From_Requested_Date        := P_Wpr.From_Requested_Date;
    L_Batch_Info_Rec.To_Requested_Date          := P_Wpr.To_Requested_Date;
    L_Batch_Info_Rec.From_Scheduled_Ship_Date   := P_Wpr.From_Scheduled_Ship_Date;
    L_Batch_Info_Rec.To_Scheduled_Ship_Date     := P_Wpr.To_Scheduled_Ship_Date;
    L_Batch_Info_Rec.Ship_To_Location_Id        := P_Wpr.Ship_To_Location_Id;
    L_Batch_Info_Rec.Ship_From_Location_Id      := P_Wpr.Ship_From_Location_Id;
    L_Batch_Info_Rec.Include_Planned_Lines      := P_Wpr.Include_Planned_Lines;
    L_Batch_Info_Rec.Pick_Grouping_Rule_Id      := P_Wpr.Pick_Grouping_Rule_Id;
    L_Batch_Info_Rec.Pick_Sequence_Rule_Id      := P_Wpr.Pick_Sequence_Rule_Id;
    L_Batch_Info_Rec.Autocreate_Delivery_Flag   := P_Wpr.Autocreate_Delivery_Flag;
    L_Batch_Info_Rec.Attribute_Category         := P_Wpr.Attribute_Category;
    L_Batch_Info_Rec.Attribute1                 := P_Wpr.Attribute1;
    L_Batch_Info_Rec.Attribute2                 := P_Wpr.Attribute2;
    L_Batch_Info_Rec.Attribute3                 := P_Wpr.Attribute3;
    L_Batch_Info_Rec.Attribute4                 := P_Wpr.Attribute4;
    L_Batch_Info_Rec.Attribute5                 := P_Wpr.Attribute5;
    L_Batch_Info_Rec.Attribute6                 := P_Wpr.Attribute6;
    L_Batch_Info_Rec.Attribute7                 := P_Wpr.Attribute7;
    L_Batch_Info_Rec.Attribute8                 := P_Wpr.Attribute8;
    L_Batch_Info_Rec.Attribute9                 := P_Wpr.Attribute9;
    L_Batch_Info_Rec.Attribute10                := P_Wpr.Attribute10;
    L_Batch_Info_Rec.Attribute11                := P_Wpr.Attribute11;
    L_Batch_Info_Rec.Attribute12                := P_Wpr.Attribute12;
    L_Batch_Info_Rec.Attribute13                := P_Wpr.Attribute13;
    L_Batch_Info_Rec.Attribute14                := P_Wpr.Attribute14;
    L_Batch_Info_Rec.Attribute15                := P_Wpr.Attribute15;
    L_Batch_Info_Rec.Autodetail_Pr_Flag         := P_Wpr.Autodetail_Pr_Flag;
    L_Batch_Info_Rec.Default_Stage_Subinventory := P_Wpr.Default_Stage_Subinventory;
    L_Batch_Info_Rec.Default_Stage_Locator_Id   := P_Wpr.Default_Stage_Locator_Id;
    L_Batch_Info_Rec.Pick_From_Subinventory     := P_Wpr.Pick_From_Subinventory;
    L_Batch_Info_Rec.Pick_From_Locator_Id       := P_Wpr.Pick_From_Locator_Id;
    L_Batch_Info_Rec.Auto_Pick_Confirm_Flag     := P_Wpr.Auto_Pick_Confirm_Flag;
    L_Batch_Info_Rec.Project_Id                 := P_Wpr.Project_Id;
    L_Batch_Info_Rec.Task_Id                    := P_Wpr.Task_Id;
    L_Batch_Info_Rec.Organization_Id            := P_Wpr.Organization_Id;
    L_Batch_Info_Rec.Ship_Confirm_Rule_Id       := P_Wpr.Ship_Confirm_Rule_Id;
    L_Batch_Info_Rec.Autopack_Flag              := P_Wpr.Autopack_Flag;
    L_Batch_Info_Rec.Autopack_Level             := P_Wpr.Autopack_Level;
    L_Batch_Info_Rec.Task_Planning_Flag         := P_Wpr.Task_Planning_Flag;
    L_Batch_Info_Rec.Category_Set_Id            := P_Wpr.Category_Set_Id;
    L_Batch_Info_Rec.Category_Id                := P_Wpr.Category_Id;
    L_Batch_Info_Rec.Region_Id                  := P_Wpr.Region_Id;
    L_Batch_Info_Rec.Zone_Id                    := P_Wpr.Zone_Id;
    L_Batch_Info_Rec.Ac_Delivery_Criteria       := P_Wpr.Ac_Delivery_Criteria;
    L_Batch_Info_Rec.Rel_Subinventory           := P_Wpr.Rel_Subinventory;
    L_Batch_Info_Rec.Append_Flag                := P_Wpr.Append_Flag;
    L_Batch_Info_Rec.Task_Priority              := P_Wpr.Task_Priority;
    L_Rule_Id                                   := P_Wpr.Picking_Rule_Id;
    L_Rule_Name                                 := P_Wpr.Name;
    L_Batch_Prefix                              := Null;
    -- Cria Lote
    Wsh_Picking_Batches_Pub.Create_Batch(P_Api_Version   => 1.0 --
                                        ,P_Init_Msg_List => Fnd_Api.G_True --
                                        ,P_Commit        => Fnd_Api.G_True --
                                        ,X_Return_Status => L_Return_Status --
                                        ,X_Msg_Count     => L_Msg_Count --
                                        ,X_Msg_Data      => L_Msg_Data --
                                        ,P_Rule_Id       => L_Rule_Id --
                                        ,P_Rule_Name     => L_Rule_Name --
                                        ,P_Batch_Rec     => L_Batch_Info_Rec --
                                        ,P_Batch_Prefix  => L_Batch_Prefix --
                                        ,X_Batch_Id      => L_n_New_Batch_Id --
                                         );
    If L_Return_Status In
       (Wsh_Util_Core.G_Ret_Sts_Success, Wsh_Util_Core.G_Ret_Sts_Warning)
    Then
      P_Msg := 'OK';
    Else
      -- Retrieve messages 
      Oe_Msg_Pub.Get(P_Msg_Index     => L_Msg_Index_In --
                    ,P_Encoded       => Fnd_Api.G_False --
                    ,P_Data          => L_Msg_Data --
                    ,P_Msg_Index_Out => L_Msg_Index_Out --
                     );
      -- MDB_OM_007C_056 - Chamada Wsh_Picking_Batches_Pub.Create_Batch :
      P_Msg := Fnd_Message.Get_String('MDB', 'MDB_OM_007C_056') ||
               Nvl(L_Msg_Data, 'NOK');
    End If;
    --
    If P_Msg = 'OK'
    Then
      Commit;
      L_v_Return_Status := Null;
      L_n_Msg_Count     := Null;
      L_v_Msg_Data      := Null;
      -- Release the batch Created Above
      Wsh_Picking_Batches_Pub.Release_Batch(P_Api_Version   => 1.0 --
                                           ,P_Init_Msg_List => Fnd_Api.G_True --
                                           ,P_Commit        => Fnd_Api.G_True --
                                           ,X_Return_Status => L_v_Return_Status --
                                           ,X_Msg_Count     => L_n_Msg_Count --
                                           ,X_Msg_Data      => L_v_Msg_Data --
                                           ,P_Batch_Id      => L_n_New_Batch_Id --
                                           ,P_Batch_Name    => Null --
                                           ,P_Log_Level     => 1 --
                                           ,P_Release_Mode  => 'ONLINE' -- (ONLINE or CONCURRENT)
                                           ,X_Request_Id    => L_Request_Id --
                                            );
      /*
      If L_v_Return_Status In
         (Wsh_Util_Core.G_Ret_Sts_Success, Wsh_Util_Core.G_Ret_Sts_Warning) Then
        P_Msg := 'OK';
      Else
      
        If L_n_Msg_Count = 1 Then
          P_Msg := 'Release Batch - ' ||
                   Nvl(L_v_Msg_Data, 'Erro não esperado no Batch : ' ||
                        L_n_New_Batch_Id ||
                        ' - L_v_Return_Status : ' ||
                        L_v_Return_Status ||
                        ' - P_Moll.Delivery_Detail_Id : ' ||
                        P_Moll.Delivery_Detail_Id ||
                        ' - L_n_Msg_Count : ' || L_n_Msg_Count);
        Else
          Loop
            L_v_Msg_Data   := Fnd_Msg_Pub.Get(Fnd_Msg_Pub.G_Next, Fnd_Api.G_False);
            L_Msg_Index_In := L_Msg_Index_In + 1;
            If L_v_Msg_Data Is Not Null Then
              P_Msg := Substr(P_Msg ||' '||L_v_Msg_Data,1,4000);
            Else
              Exit;
            End If;
          End Loop;
          P_Msg := Substr(P_Msg ||' - Batch_Id '||L_n_New_Batch_Id ,1,4000);
        End If;
      End If;
        */
    End If;
  End Picking_Batch_Line_p;

  ---------------------------------------------------------------------
  -- Procedure para Recuperar as linhas para tratar a indivibilidade --
  ---------------------------------------------------------------------
  Procedure Indivisible_Select_p(P_Moli Mdb_Otm_Lot_Invoices_All %Rowtype) Is
    ------------------------------------------------------
    -- Cursor das Linhas itens que precisam ter reserva -- 
    ------------------------------------------------------
    Cursor C_Moll(Pc_Lot_Invoice_Id Number) Is
      Select Moll.*
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
         And Nvl(Moll.Smc_Indivisible_Flag, 'N') = 'Y'
         And Trunc(Moll.Requested_Quantity) != Moll.Requested_Quantity;
    --
    L_n_Delivery_Detail_Id_New Number;
    L_v_Msg                    Varchar2(4000);
    L_r_Molls_Line             Mdb_Otm_Line_Log_Status_All%Rowtype;
    L_r_Moll                   Mdb_Otm_Lot_Lines_All%Rowtype;
    L_n_Qty_Split              Number;
  Begin
    ------------------------------------------------------
    -- Cursor das Linhas itens que precisam ter reserva -- 
    ------------------------------------------------------
    For R_Moll In C_Moll(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      L_r_Moll.Requested_Quantity := Trunc(R_Moll.Requested_Quantity);
      L_n_Qty_Split               := R_Moll.Requested_Quantity -
                                     Trunc(R_Moll.Requested_Quantity);
      -- Se for maior que zero 
      If L_r_Moll.Requested_Quantity > 0
      Then
        -----------------------------------------------
        -- Procedure para criar as linhas com fracao --
        -----------------------------------------------
        Mdb_Otm_Lot_Invoices_Pk.Indivisible_Qty_Split_p(P_Delivery_Detail_Id     => R_Moll.Delivery_Detail_Id --
                                                       ,P_Delivery_Detail_Id_New => L_n_Delivery_Detail_Id_New --
                                                       ,P_Qty_Split              => L_n_Qty_Split -- L_r_Moll.Requested_Quantity --
                                                       ,P_Msg                    => L_v_Msg --
                                                        );
        --
        If L_v_Msg = 'OK'
        Then
          -- Atualiza o status da linha nova
          -- Converte o novo valor para a Unidade de Media da Configuracao
          If R_Moll.Requested_Quantity_Uom != R_Moll.Use_Max_Line_Uom
          Then
            L_r_Moll.Requested_Quantity_Conv_To_Set := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                       (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                       ,P_From_Quantity => L_r_Moll.Requested_Quantity --
                                                       ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                       ,P_To_Unit       => R_Moll.Use_Max_Line_Uom --
                                                        );
          Else
            L_r_Moll.Requested_Quantity_Conv_To_Set := L_r_Moll.Requested_Quantity;
          End If;
          -- Se a UOM Solicitada for Dif da UOM da Config.
          If R_Moll.Requested_Quantity_Uom !=
             Nvl(R_Moll.Smc_Min_Line_Uom, R_Moll.Requested_Quantity_Uom)
          Then
            -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
            L_r_Moll.Smc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                   (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                   ,P_From_Quantity => L_r_Moll.Requested_Quantity --
                                                   ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                   ,P_To_Unit       => R_Moll.Smc_Min_Line_Uom --
                                                    );
          Else
            L_r_Moll.Smc_Min_Requested_Quantity := L_r_Moll.Requested_Quantity;
          End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then                                                        
          -- Se a UOM Solicitada for Dif da UOM da Config.
          If R_Moll.Requested_Quantity_Uom !=
             Nvl(R_Moll.Moc_Min_Delivery_Uom, R_Moll.Requested_Quantity_Uom)
          Then
            -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
            L_r_Moll.Moc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                   (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                   ,P_From_Quantity => L_r_Moll.Requested_Quantity --
                                                   ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                   ,P_To_Unit       => R_Moll.Moc_Min_Delivery_Uom --
                                                    );
          Else
            L_r_Moll.Moc_Min_Requested_Quantity := L_r_Moll.Requested_Quantity;
          End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then
          -- Atualiza a quantidade da linha no lote 
          Update Mdb_Otm_Lot_Lines_All Roll
             Set Roll.Requested_Quantity             = L_r_Moll.Requested_Quantity
                ,Roll.Requested_Quantity_Conv_To_Set = Nvl(L_r_Moll.Requested_Quantity_Conv_To_Set
                                                          ,Roll.Requested_Quantity_Conv_To_Set)
                ,Roll.Moc_Min_Requested_Quantity     = Nvl(L_r_Moll.Moc_Min_Requested_Quantity
                                                          ,Roll.Moc_Min_Requested_Quantity)
                ,Roll.Smc_Min_Requested_Quantity     = Nvl(L_r_Moll.Smc_Min_Requested_Quantity
                                                          ,Roll.Smc_Min_Requested_Quantity)
          --,Roll.Lot_Otm_Status_Line_Code       = 'SELECTED' -- 'PREPARED FOR SEND OTM' -- Preparado para Envio para OTM
           Where Lot_Line_Id = R_Moll.Lot_Line_Id;
          -- Atualizar Status da WDD da Linha Nova
          L_r_Molls_Line.Delivery_Detail_Id := L_n_Delivery_Detail_Id_New;
          L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
          L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
          L_r_Molls_Line.Status_Code_From   := 'NO PROCESS';
          L_r_Molls_Line.Status_Code_To     := 'BACKORDER FRACTIONAL METHOD'; -- Ruptura por Fracionado do Método de Entrega
          L_r_Molls_Line.Comments           := To_Char(Sysdate
                                                      ,'DD-MON-RRRR HH24:MI:SS');
          Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
        Else
          -- Atualizar Status da WDD
          L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
          L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
          L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
          L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Lot_Otm_Status_Line_Code
                                                  ,'NO PROCESS');
          L_r_Molls_Line.Status_Code_To     := 'INDIVISIBLE ERROR'; -- Erro no processo de Indivisibilidade de Quantidade no Método de Entrega
          L_r_Molls_Line.Comments           := L_v_Msg;
          Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
          -----------------------------
          -- Atualiza Status no Lote --
          -----------------------------
          Update Mdb_Otm_Lot_Lines_All
             Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
           Where Lot_Line_Id = R_Moll.Lot_Line_Id;
        End If;
      Else
        -- Atualizar Status da WDD da Linha Nova
        L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
        L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
        L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
        L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Lot_Otm_Status_Line_Code
                                                ,'NO PROCESS');
        L_r_Molls_Line.Status_Code_To     := 'BACKORDER FRACTIONAL METHOD'; -- Ruptura por Fracionado do Método de Entrega
        L_r_Molls_Line.Comments           := To_Char(Sysdate
                                                    ,'DD-MON-RRRR HH24:MI:SS');
        Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
        --------------------
        -- Retida do Lote --
        --------------------
        Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p --
        (P_Lot_Line_Id                  => R_Moll.Lot_Line_Id --
        ,P_Wdd_Otm_Status_Line_Code     => L_r_Molls_Line.Status_Code_To --
        ,P_Wdd_Otm_Status_Line_Comments => L_r_Molls_Line.Comments --
        ,P_Comments                     => 'Excluida no processo de Indivisibilidade' --
         );
      End If; -- If L_r_Moll.Requested_Quantity > 0 Then
      Commit;
    End Loop C_Moll;
  End Indivisible_Select_p;

  -----------------------------------------------
  -- Procedure para criar as linhas com fracao --
  -----------------------------------------------
  Procedure Indivisible_Qty_Split_p
  (
    P_Delivery_Detail_Id     In Out Number
   ,P_Delivery_Detail_Id_New In Out Number
   ,P_Qty_Split              In Out Number
   ,P_Msg                    In Out Varchar2
  ) Is
    -- Parameters for WSH_DELIVERY_DETAILS_PUB.Split_line
    L_Init_Msg_List    Varchar2(30);
    L_Api_Commit       Varchar2(30) := Fnd_Api.G_False;
    L_Validation_Level Number;
    L_Return_Status    Varchar2(30);
    L_Msg_Count        Number;
    L_Msg_Data         Varchar2(4000); -- VARCHAR2(3000);        
    L_Qty_Split2       Number;
  Begin
    P_Msg := 'OK';
    -- 
    Begin
      Wsh_Delivery_Details_Pub.Split_Line(P_Api_Version      => 1.0 --
                                         ,P_Init_Msg_List    => L_Init_Msg_List --
                                         ,P_Commit           => L_Api_Commit --
                                         ,P_Validation_Level => L_Validation_Level --
                                         ,X_Return_Status    => L_Return_Status --
                                         ,X_Msg_Count        => L_Msg_Count --
                                         ,X_Msg_Data         => L_Msg_Data --
                                         ,P_From_Detail_Id   => P_Delivery_Detail_Id --
                                         ,X_New_Detail_Id    => P_Delivery_Detail_Id_New --
                                         ,X_Split_Quantity   => P_Qty_Split --
                                         ,X_Split_Quantity2  => L_Qty_Split2 --
                                          );
      If (L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Error Or
         L_Return_Status = Wsh_Util_Core.G_Ret_Sts_Unexp_Error)
      Then
        -- MDB_OM_007C_057 - Chamada Wsh_Delivery_Details_Pub.Split_Line : 
        P_Msg := Substr(Fnd_Message.Get_String('MDB', 'MDB_OM_007C_057') ||
                        L_Msg_Data
                       ,1
                       ,4000);
      End If;
    Exception
      When Others Then
        P_Msg := Sqlerrm;
    End;
  End Indivisible_Qty_Split_p;

  -------------------------------------------------------------------------
  -- Procedure para Recuperar as linhas para tratar a Unidade Secundaria --
  -------------------------------------------------------------------------
  Procedure Secondary_Validation_p(P_Moli Mdb_Otm_Lot_Invoices_All %Rowtype) Is
    ------------------------------------------------------
    -- Cursor das Linhas itens que precisam ter reserva -- 
    ------------------------------------------------------
    Cursor C_Moll(Pc_Lot_Invoice_Id Number) Is
      Select Moll.*
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED'
         And Moll.Requested_Quantity != Trunc(Moll.Requested_Quantity);
    -- Variaveis --
    L_r_Moll                   Mdb_Otm_Lot_Lines_All %Rowtype;
    L_r_Molls_Line             Mdb_Otm_Line_Log_Status_All%Rowtype;
    L_n_Qty_Split_Sec          Number;
    L_n_Qty_Split              Number;
    L_n_Delivery_Detail_Id_New Number;
    L_v_Msg                    Varchar2(4000);
  Begin
    ------------------------------------------------------
    -- Cursor das Linhas itens que precisam ter reserva -- 
    ------------------------------------------------------
    For R_Moll In C_Moll(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      -- Inicializa variaveis
      L_r_Moll                   := Null;
      L_r_Molls_Line             := Null;
      L_n_Qty_Split_Sec          := Null;
      L_n_Qty_Split              := Null;
      L_n_Delivery_Detail_Id_New := Null;
      L_v_Msg                    := Null;
      -- Se a Unidade da Linha WDD eh a Primaria 
      If R_Moll.Requested_Quantity_Uom = R_Moll.Primary_Uom_Code
      Then
        -- Unidade de Medida Secundaria Informada
        If R_Moll.Secondary_Uom_Code Is Not Null
        Then
          L_r_Moll.Requested_Quantity_Sec := Round(Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                   (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                  ,P_From_Quantity => R_Moll.Requested_Quantity --
                                                  ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                  ,P_To_Unit       => R_Moll.Secondary_Uom_Code --
                                                    )
                                                  ,2);
          -- Se conversao for Zero retira a Linha do Lote
          If Trunc(L_r_Moll.Requested_Quantity_Sec) != 0
          Then
            -- Se conversao for maior que Zero e tiver decimal
            If L_r_Moll.Requested_Quantity_Sec !=
               Trunc(L_r_Moll.Requested_Quantity_Sec)
            Then
              -- Total menos o Inteiro, para ficar o decimal
              L_n_Qty_Split_Sec := L_r_Moll.Requested_Quantity_Sec -
                                   Trunc(L_r_Moll.Requested_Quantity_Sec);
              -- Converte o Decimal para a Unidade da WDD
              L_n_Qty_Split := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                               (P_Item_Id       => R_Moll.Inventory_Item_Id --
                               ,P_From_Quantity => L_n_Qty_Split_Sec --
                               ,P_From_Unit     => R_Moll.Secondary_Uom_Code --
                               ,P_To_Unit       => R_Moll.Requested_Quantity_Uom --
                                );
              -----------------------------------------------
              -- Procedure para criar as linhas com fracao --
              -----------------------------------------------
              Mdb_Otm_Lot_Invoices_Pk.Indivisible_Qty_Split_p -- 
              (P_Delivery_Detail_Id     => R_Moll.Delivery_Detail_Id --
              ,P_Delivery_Detail_Id_New => L_n_Delivery_Detail_Id_New --
              ,P_Qty_Split              => L_n_Qty_Split -- 
              ,P_Msg                    => L_v_Msg --
               );
              Dbms_Output.Put_Line('L_v_Msg.....' || L_v_Msg);
              If L_v_Msg = 'OK'
              Then
                --
                L_r_Moll.Requested_Quantity := R_Moll.Requested_Quantity -
                                               L_n_Qty_Split;
                -- Atualiza o status da linha nova
                -- Converte o novo valor para a Unidade de Media da Configuracao
                If R_Moll.Requested_Quantity_Uom != R_Moll.Use_Max_Line_Uom
                Then
                  L_r_Moll.Requested_Quantity_Conv_To_Set := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                             (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                             ,P_From_Quantity => L_r_Moll.Requested_Quantity --
                                                             ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                             ,P_To_Unit       => R_Moll.Use_Max_Line_Uom --
                                                              );
                Else
                  L_r_Moll.Requested_Quantity_Conv_To_Set := L_r_Moll.Requested_Quantity;
                End If;
                -- Se a UOM Solicitada for Dif da UOM da Config.
                If R_Moll.Requested_Quantity_Uom !=
                   Nvl(R_Moll.Smc_Min_Line_Uom
                      ,R_Moll.Requested_Quantity_Uom)
                Then
                  -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
                  L_r_Moll.Smc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                         (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                         ,P_From_Quantity => L_r_Moll.Requested_Quantity --
                                                         ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                         ,P_To_Unit       => R_Moll.Smc_Min_Line_Uom --
                                                          );
                Else
                  L_r_Moll.Smc_Min_Requested_Quantity := L_r_Moll.Requested_Quantity;
                End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then                                                        
                -- Se a UOM Solicitada for Dif da UOM da Config.
                If R_Moll.Requested_Quantity_Uom !=
                   Nvl(R_Moll.Moc_Min_Delivery_Uom
                      ,R_Moll.Requested_Quantity_Uom)
                Then
                  -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
                  L_r_Moll.Moc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                         (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                         ,P_From_Quantity => L_r_Moll.Requested_Quantity --
                                                         ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                         ,P_To_Unit       => R_Moll.Moc_Min_Delivery_Uom --
                                                          );
                Else
                  L_r_Moll.Moc_Min_Requested_Quantity := L_r_Moll.Requested_Quantity;
                End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then
                -- Atualiza a quantidade da linha no lote 
                Update Mdb_Otm_Lot_Lines_All Roll
                   Set Roll.Requested_Quantity             = L_r_Moll.Requested_Quantity
                      ,Roll.Requested_Quantity_Conv_To_Set = Nvl(L_r_Moll.Requested_Quantity_Conv_To_Set
                                                                ,Roll.Requested_Quantity_Conv_To_Set)
                      ,Roll.Moc_Min_Requested_Quantity     = Nvl(L_r_Moll.Moc_Min_Requested_Quantity
                                                                ,Roll.Moc_Min_Requested_Quantity)
                      ,Roll.Smc_Min_Requested_Quantity     = Nvl(L_r_Moll.Smc_Min_Requested_Quantity
                                                                ,Roll.Smc_Min_Requested_Quantity)
                --,Roll.Lot_Otm_Status_Line_Code       = 'SELECTED' -- 'PREPARED FOR SEND OTM' -- Preparado para Envio para OTM
                 Where Lot_Line_Id = R_Moll.Lot_Line_Id;
                -- Atualizar Status da WDD da Linha Nova
                L_r_Molls_Line.Delivery_Detail_Id := L_n_Delivery_Detail_Id_New;
                L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
                L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
                L_r_Molls_Line.Status_Code_From   := 'NO PROCESS';
                L_r_Molls_Line.Status_Code_To     := 'FRACTIONAL SECONDARY UOM'; -- Ruptura por Fracionado na Unidade Secundária
                L_r_Molls_Line.Comments           := To_Char(Sysdate
                                                            ,'DD-MON-RRRR HH24:MI:SS');
                Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
              Else
                -- Atualizar Status da WDD
                L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
                L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
                L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
                L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Lot_Otm_Status_Line_Code
                                                        ,'NO PROCESS');
                L_r_Molls_Line.Status_Code_To     := 'FRACTIONAL SECONDARY ERROR'; -- Erro no processo de Validação do Fracinament da  Unidade Secundaria
                L_r_Molls_Line.Comments           := 'SPLIT - ' || L_v_Msg;
                Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
                -----------------------------
                -- Atualiza Status no Lote --
                -----------------------------
                Update Mdb_Otm_Lot_Lines_All
                   Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                      ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
                 Where Lot_Line_Id = R_Moll.Lot_Line_Id;
              End If;
            End If; -- If Trunc(L_r_Moll.Requested_Quantity_Sec) != L_r_Moll.Requested_Quantity_Sec Then
          Else
            -- Atualizar Status da WDD da Linha Nova
            L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
            L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
            L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
            L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Lot_Otm_Status_Line_Code
                                                    ,'NO PROCESS');
            L_r_Molls_Line.Status_Code_To     := 'FRACTIONAL SECONDARY UOM'; -- Unidade Secundária Fracionada
            L_r_Molls_Line.Comments           := To_Char(Sysdate
                                                        ,'DD-MON-RRRR HH24:MI:SS');
            Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
            --------------------
            -- Retida do Lote --
            --------------------
            Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p --
            (P_Lot_Line_Id                  => R_Moll.Lot_Line_Id --
            ,P_Wdd_Otm_Status_Line_Code     => L_r_Molls_Line.Status_Code_To --
            ,P_Wdd_Otm_Status_Line_Comments => L_r_Molls_Line.Comments --
            ,P_Comments                     => 'Excluida no processo de Fracionamento na Unidade Secundaria - valor inteiro igual a ZERO' --
             );
          End If; -- If Trunc(L_r_Moll.Requested_Quantity_Sec) = 0
        Else
          -- Atualizar Status da WDD da Linha Nova
          L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
          L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
          L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
          L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Lot_Otm_Status_Line_Code
                                                  ,'NO PROCESS');
          L_r_Molls_Line.Status_Code_To     := 'FRACTIONAL PRIMARY UOM'; -- Unidade Primaria Fracionada e sem Unidade Secundária
          L_r_Molls_Line.Comments           := To_Char(Sysdate
                                                      ,'DD-MON-RRRR HH24:MI:SS');
          Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
          --------------------
          -- Retida do Lote --
          --------------------
          Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p --
          (P_Lot_Line_Id                  => R_Moll.Lot_Line_Id --
          ,P_Wdd_Otm_Status_Line_Code     => L_r_Molls_Line.Status_Code_To --
          ,P_Wdd_Otm_Status_Line_Comments => L_r_Molls_Line.Comments --
          ,P_Comments                     => 'Excluida no processo de Fracionamento na Unidade Secundaria - Item sem Unidade de Medida Secundaria' --
           );
        End If; -- If R_Moll.Secondary_Uom_Code Is Not Null
        -- Se a Unidade da Linha WDD eh a Secundaria
      Elsif R_Moll.Requested_Quantity_Uom =
            Nvl(R_Moll.Secondary_Uom_Code, 'X')
      Then
        -- Total menos o Inteiro, para ficar o decimal
        L_n_Qty_Split := R_Moll.Requested_Quantity -
                         Trunc(R_Moll.Requested_Quantity);
        -----------------------------------------------
        -- Procedure para criar as linhas com fracao --
        -----------------------------------------------
        Mdb_Otm_Lot_Invoices_Pk.Indivisible_Qty_Split_p -- 
        (P_Delivery_Detail_Id     => R_Moll.Delivery_Detail_Id --
        ,P_Delivery_Detail_Id_New => L_n_Delivery_Detail_Id_New --
        ,P_Qty_Split              => L_n_Qty_Split -- 
        ,P_Msg                    => L_v_Msg --
         );
        If L_v_Msg = 'OK'
        Then
          --
          L_r_Moll.Requested_Quantity := Trunc(R_Moll.Requested_Quantity);
          -- Atualiza o status da linha nova
          -- Converte o novo valor para a Unidade de Media da Configuracao
          If R_Moll.Requested_Quantity_Uom != R_Moll.Use_Max_Line_Uom
          Then
            L_r_Moll.Requested_Quantity_Conv_To_Set := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                       (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                       ,P_From_Quantity => L_r_Moll.Requested_Quantity --
                                                       ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                       ,P_To_Unit       => R_Moll.Use_Max_Line_Uom --
                                                        );
          Else
            L_r_Moll.Requested_Quantity_Conv_To_Set := L_r_Moll.Requested_Quantity;
          End If;
          -- Se a UOM Solicitada for Dif da UOM da Config.
          If R_Moll.Requested_Quantity_Uom !=
             Nvl(R_Moll.Smc_Min_Line_Uom, R_Moll.Requested_Quantity_Uom)
          Then
            -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
            L_r_Moll.Smc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                   (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                   ,P_From_Quantity => L_r_Moll.Requested_Quantity --
                                                   ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                   ,P_To_Unit       => R_Moll.Smc_Min_Line_Uom --
                                                    );
          Else
            L_r_Moll.Smc_Min_Requested_Quantity := L_r_Moll.Requested_Quantity;
          End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then                                                        
          -- Se a UOM Solicitada for Dif da UOM da Config.
          If R_Moll.Requested_Quantity_Uom !=
             Nvl(R_Moll.Moc_Min_Delivery_Uom, R_Moll.Requested_Quantity_Uom)
          Then
            -- Converter a Quantidade da Linha para a Unidade de Medida Maxima da Configuracao
            L_r_Moll.Moc_Min_Requested_Quantity := Mdb_Otm_Lot_Invoices_Pk.Inv_Um_Convert_f -- 
                                                   (P_Item_Id       => R_Moll.Inventory_Item_Id --
                                                   ,P_From_Quantity => L_r_Moll.Requested_Quantity --
                                                   ,P_From_Unit     => R_Moll.Requested_Quantity_Uom --
                                                   ,P_To_Unit       => R_Moll.Moc_Min_Delivery_Uom --
                                                    );
          Else
            L_r_Moll.Moc_Min_Requested_Quantity := L_r_Moll.Requested_Quantity;
          End If; -- If R_Moll.Requested_Quantity_Uom != R_Moll.Moc_Min_Delivery_Uom Then
          -- Atualiza a quantidade da linha no lote 
          Update Mdb_Otm_Lot_Lines_All Roll
             Set Roll.Requested_Quantity             = L_r_Moll.Requested_Quantity
                ,Roll.Requested_Quantity_Conv_To_Set = Nvl(L_r_Moll.Requested_Quantity_Conv_To_Set
                                                          ,Roll.Requested_Quantity_Conv_To_Set)
                ,Roll.Moc_Min_Requested_Quantity     = Nvl(L_r_Moll.Moc_Min_Requested_Quantity
                                                          ,Roll.Moc_Min_Requested_Quantity)
                ,Roll.Smc_Min_Requested_Quantity     = Nvl(L_r_Moll.Smc_Min_Requested_Quantity
                                                          ,Roll.Smc_Min_Requested_Quantity)
          --,Roll.Lot_Otm_Status_Line_Code       = 'SELECTED' -- 'PREPARED FOR SEND OTM' -- Preparado para Envio para OTM
           Where Lot_Line_Id = R_Moll.Lot_Line_Id;
          -- Atualizar Status da WDD da Linha Nova
          L_r_Molls_Line.Delivery_Detail_Id := L_n_Delivery_Detail_Id_New;
          L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
          L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
          L_r_Molls_Line.Status_Code_From   := 'NO PROCESS';
          L_r_Molls_Line.Status_Code_To     := 'FRACTIONAL SECONDARY UOM'; -- Ruptura por Fracionado na Unidade Secundária
          L_r_Molls_Line.Comments           := To_Char(Sysdate
                                                      ,'DD-MON-RRRR HH24:MI:SS');
          Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
        Else
          -- Atualizar Status da WDD
          L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
          L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
          L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
          L_r_Molls_Line.Status_Code_From   := Nvl(R_Moll.Lot_Otm_Status_Line_Code
                                                  ,'NO PROCESS');
          L_r_Molls_Line.Status_Code_To     := 'FRACTIONAL SECONDARY ERROR'; -- Erro no processo de Validação do Fracinament da  Unidade Secundaria
          L_r_Molls_Line.Comments           := L_v_Msg;
          Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
          -----------------------------
          -- Atualiza Status no Lote --
          -----------------------------
          Update Mdb_Otm_Lot_Lines_All
             Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
                ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
           Where Lot_Line_Id = R_Moll.Lot_Line_Id;
        End If;
      End If; -- -- Se a Unidade da Linha WDD eh a Primaria
    End Loop C_Moll;
  End Secondary_Validation_p;

  -----------------------------------------------------------
  -- Procedure para atualizar as linhas prontas para o OTM --
  -----------------------------------------------------------
  Procedure Send_Otm_Update_p(P_Moli Mdb_Otm_Lot_Invoices_All %Rowtype) Is
    ----------------------------------------------
    -- Cursor das Linhas para Enviar para o OTM --
    ----------------------------------------------
    Cursor C_Moll(Pc_Lot_Invoice_Id Number) Is
      Select Moll.*
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code = 'SELECTED';
    L_r_Molls_Line Mdb_Otm_Line_Log_Status_All%Rowtype;
    L_n_Commit     Number;
  Begin
    ------------------------------------------------------
    -- Cursor das Linhas itens que precisam ter reserva -- 
    ------------------------------------------------------
    For R_Moll In C_Moll(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      -- Atualizar Status da WDD da Linha Nova
      L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
      L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
      L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
      L_r_Molls_Line.Status_Code_From   := R_Moll.Lot_Otm_Status_Line_Code;
      L_r_Molls_Line.Status_Code_To     := 'PREPARED FOR SEND OTM'; -- Preparado para Envio para OTM
      L_r_Molls_Line.Comments           := To_Char(Sysdate, 'DD-MON-RRRR');
      Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
      -- Atualiza a quantidade da linha no lote 
      Update Mdb_Otm_Lot_Lines_All
         Set Lot_Otm_Status_Line_Code     = L_r_Molls_Line.Status_Code_To
            ,Lot_Otm_Status_Line_Comments = L_r_Molls_Line.Comments
       Where Lot_Line_Id = R_Moll.Lot_Line_Id;
      -- Controla o commit
      L_n_Commit := L_n_Commit + 1;
      If L_n_Commit >= 1000
      Then
        L_n_Commit := 0;
        Commit;
      End If;
    End Loop C_Moll;
    Commit;
  End Send_Otm_Update_p;

  -------------------------------------------------------------
  -- Procedure para atualizar as linhas de um lote cancelado --
  -------------------------------------------------------------
  Procedure Cancel_Selected_p(P_Moli Mdb_Otm_Lot_Invoices_All %Rowtype) Is
    ----------------------------------------------
    -- Cursor das Linhas para Enviar para o OTM --
    ----------------------------------------------
    Cursor C_Moll(Pc_Lot_Invoice_Id Number) Is
      Select Moll.*
            ,Moli.Lot_Invoice_Num
        From Mdb_Otm_Lot_Lines_All    Moll
            ,Mdb_Otm_Lot_Invoices_All Moli
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moli.Lot_Invoice_Id = Moll.Lot_Invoice_Id;
    L_r_Molls_Line Mdb_Otm_Line_Log_Status_All%Rowtype;
    L_n_Commit     Number;
    L_v_Msg        Varchar2(1000);
  Begin
    ------------------------------------------------------
    -- Cursor das Linhas itens que precisam ter reserva -- 
    ------------------------------------------------------
    For R_Moll In C_Moll(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      -- Atualizar Status da WDD da Linha Nova
      L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
      L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
      L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
      L_r_Molls_Line.Status_Code_From   := R_Moll.Lot_Otm_Status_Line_Code;
      L_r_Molls_Line.Status_Code_To     := 'NO PROCESS'; -- Nao processado
      L_r_Molls_Line.Comments           := 'Lote Cancelado : ' ||
                                           R_Moll.Lot_Invoice_Num;
      Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
      -- Volta a data de entrega 
      If R_Moll.Schedule_Ship_Date_Old Is Not Null
      Then
        ------------------------------------------------------------------
        -- Procedure para Alterar a Data de Entrega Programada da Linha --
        ------------------------------------------------------------------
        Begin
          Mdb_Otm_Lot_Invoices_Pk.Schedule_Ship_Date_Update_p -- 
          (P_Action             => 'SCHEDULE_SHIP_DATE'
          ,P_Header_Id          => R_Moll.Header_Id --
          ,P_Line_Id            => R_Moll.Line_Id --
          ,P_Schedule_Ship_Date => R_Moll.Schedule_Ship_Date_Old --
          ,P_Msg                => L_v_Msg --
           );
        Exception
          When Others Then
            -- MDB_OM_007C_054 - Erro não esperado ao alterar a Data de Entrega (03) : 
            L_v_Msg := Fnd_Message.Get_String('MDB', 'MDB_OM_007C_054') ||
                       Sqlerrm;
        End;
      End If;
      Commit;
    End Loop C_Moll;
  End Cancel_Selected_p;

  -------------------------------------------------------
  -- Procedure para excluir as linhas com erro do lote -- 
  -------------------------------------------------------
  Procedure Delete_Error_p(P_Moli Mdb_Otm_Lot_Invoices_All %Rowtype) Is
    ----------------------------------------------
    -- Cursor das Linhas para Enviar para o OTM --
    ----------------------------------------------
    Cursor C_Moll(Pc_Lot_Invoice_Id Number) Is
      Select Moll.*
        From Mdb_Otm_Lot_Lines_All Moll
       Where Moll.Lot_Invoice_Id = Pc_Lot_Invoice_Id
         And Moll.Lot_Otm_Status_Line_Code In
             ('SETUP NOT FOUND' -- Configuração não encontrada
             ,'PARTIAL BILLING' -- Faturamento Parcial
             ,'DAY OUT CUSTOMER DELIVERY' -- Fora do Dia de Entrega do Cliente
             ,'OUTSIDE EXPEDITION CALENDAR' -- Fora do Calendário de Expedição
             ,'SPLIT ERROR' -- Erro no processo de SPLIT.
             ,'SCHEDULE DATE ERROR' -- Erro na alteração da Data de Entrega
              );
    L_r_Molls_Line Mdb_Otm_Line_Log_Status_All%Rowtype;
    L_n_Commit     Number;
  Begin
    ------------------------------------------------------
    -- Cursor das Linhas itens que precisam ter reserva -- 
    ------------------------------------------------------
    For R_Moll In C_Moll(Pc_Lot_Invoice_Id => P_Moli.Lot_Invoice_Id)
    Loop
      -- Atualizar Status da WDD da Linha Nova
      L_r_Molls_Line.Delivery_Detail_Id := R_Moll.Delivery_Detail_Id;
      L_r_Molls_Line.Organization_Id    := R_Moll.Organization_Id;
      L_r_Molls_Line.Org_Id             := R_Moll.Org_Id;
      L_r_Molls_Line.Status_Code_From   := R_Moll.Lot_Otm_Status_Line_Code;
      L_r_Molls_Line.Status_Code_To     := 'NO PROCESS'; -- Nao processado
      L_r_Molls_Line.Comments           := 'Linha excluida do Lote por conter erros';
      Mdb_Otm_Lot_Invoices_Pk.Insert_Log_Status_Otm_Line_p(P_Molls => L_r_Molls_Line);
      --
      Mdb_Otm_Lot_Invoices_Pk.Delete_Line_p -- 
      (P_Lot_Line_Id                  => R_Moll.Lot_Line_Id -- 
      ,P_Wdd_Otm_Status_Line_Code     => L_r_Molls_Line.Status_Code_To --
      ,P_Wdd_Otm_Status_Line_Comments => L_r_Molls_Line.Comments --
      ,P_Comments                     => 'Excluida no processo de Exclusao de Linhas com Erro' --
       );
      -- Controla o commit
      L_n_Commit := L_n_Commit + 1;
      If L_n_Commit >= 1000
      Then
        L_n_Commit := 0;
        Commit;
      End If;
    End Loop C_Moll;
    Commit;
  End Delete_Error_p;

  ----------------------------------------------
  -- Funcao para verficar se existe retencoes --
  ----------------------------------------------
  Function Hold_Exists_f
  (
    P_Header_Id Number
   ,P_Line_Id   Number
  ) Return Varchar2 Is
    --
    L_Hold_Exists Varchar2(1);
  Begin
    -- Verifica se tem retencao para o pedido
    Begin
      Select 'Y'
        Into L_Hold_Exists
        From Oe_Order_Holds_v
       Where Header_Id = P_Header_Id
         And Line_Id Is Null
         And Released_Flag = 'N';
    Exception
      When Too_Many_Rows Then
        L_Hold_Exists := 'Y';
      When Others Then
        L_Hold_Exists := 'N';
    End;
    -- Se nao tiver retencao para o Cabecalho vejo para a Linha 
    If L_Hold_Exists = 'N'
    Then
      Begin
        Select 'Y'
          Into L_Hold_Exists
          From Oe_Order_Holds_v
         Where Header_Id = P_Header_Id
           And Line_Id = P_Line_Id
           And Released_Flag = 'N';
      Exception
        When Too_Many_Rows Then
          L_Hold_Exists := 'Y';
        When Others Then
          L_Hold_Exists := 'N';
      End;
    End If;
    Return(L_Hold_Exists);
  End Hold_Exists_f;

  --------------------------------
  -- Procedure para Incluir Log --
  --------------------------------
  Procedure Insert_Log_p(P_Molls In Mdb_Otm_Lot_Log_Status_All%Rowtype) Is
    L_r_p_Molls Mdb_Otm_Lot_Log_Status_All%Rowtype := P_Molls;
  Begin
    -- Atualiza o Status --
    Update Mdb_Otm_Lot_Invoices_All
       Set Last_Update_Date  = Sysdate
          ,Last_Updated_By   = Fnd_Global.User_Id
          ,Last_Update_Login = Fnd_Global.Login_Id
          ,Lot_Status_Code   = L_r_p_Molls.Lot_Status_Code_To
     Where Lot_Invoice_Id = L_r_p_Molls.Lot_Invoice_Id;
    -- Inclui o Log
    L_r_p_Molls.Creation_Date     := Nvl(L_r_p_Molls.Creation_Date, Sysdate);
    L_r_p_Molls.Created_By        := Nvl(L_r_p_Molls.Created_By, -1);
    L_r_p_Molls.Last_Update_Date  := Nvl(L_r_p_Molls.Last_Update_Date
                                        ,Sysdate);
    L_r_p_Molls.Last_Updated_By   := Nvl(L_r_p_Molls.Last_Updated_By, -1);
    L_r_p_Molls.Last_Update_Login := Nvl(L_r_p_Molls.Last_Update_Login, -1);
    L_r_p_Molls.Org_Id            := Nvl(L_r_p_Molls.Org_Id
                                        ,Fnd_Profile.Value('ORG_ID'));
    L_r_p_Molls.Organization_Id   := Nvl(L_r_p_Molls.Organization_Id
                                        ,Fnd_Profile.Value('MFG_ORGANIZATION_ID'));
    --
    Insert Into Mdb_Otm_Lot_Log_Status_All
    Values L_r_p_Molls;
  End;

  -------------------------------------------------------
  -- Procedure para Incluir Log do Status OTM da linha --
  -------------------------------------------------------
  Procedure Insert_Log_Status_Otm_Line_p(P_Molls In Mdb_Otm_Line_Log_Status_All%Rowtype) Is
    L_r_Molls Mdb_Otm_Line_Log_Status_All%Rowtype := P_Molls;
  Begin
    -- Atualizar a WDD
    Update Wsh_Delivery_Details
       Set Attribute1 = L_r_Molls.Status_Code_To
          ,Attribute2 = L_r_Molls.Comments
     Where Delivery_Detail_Id = L_r_Molls.Delivery_Detail_Id;
    -- Inclui o Log
    L_r_Molls.Creation_Date     := Nvl(L_r_Molls.Creation_Date, Sysdate);
    L_r_Molls.Created_By        := Nvl(L_r_Molls.Created_By, -1);
    L_r_Molls.Last_Update_Date  := Nvl(L_r_Molls.Last_Update_Date, Sysdate);
    L_r_Molls.Last_Updated_By   := Nvl(L_r_Molls.Last_Updated_By, -1);
    L_r_Molls.Last_Update_Login := Nvl(L_r_Molls.Last_Update_Login, -1);
    Insert Into Mdb_Otm_Line_Log_Status_All
    Values L_r_Molls;
  End Insert_Log_Status_Otm_Line_p;

  ---------------------------------------------
  -- Funcao para retornar o proximo dia util --
  ---------------------------------------------
  Function Get_Next_Day_Utl_f
  (
    P_Address_Id In Number
   ,P_Day        In Date
  ) Return Date Is
    -- Variaveis --
    L_d_Day                    Date;
    L_n_Day                    Number;
    L_d_Next_Date              Date;
    L_v_Calendar_Name          Varchar2(30) := Fnd_Profile.Value('JLBR_CALENDAR');
    L_v_City                   Varchar2(60);
    L_v_State                  Varchar2(60);
    L_v_Payment_Action         Varchar2(1) := '2'; -- NEXT DAY    
    L_v_Workdaydate_Char       Varchar2(10);
    L_n_Check_Date_Return_Code Number(1);
  Begin
    If P_Address_Id Is Not Null And
       P_Day Is Not Null
    Then
      L_n_Day := To_Number(To_Char(P_Day, 'D'));
      If L_n_Day = 1
      Then
        -- Domingo
        L_d_Day := P_Day + 1;
      Elsif L_n_Day = 7
      Then
        -- Sabado
        L_d_Day := P_Day + 2;
      Else
        L_d_Day := P_Day;
      End If;
      -- Recupera a Cidade e o Estado do Endereco
      Begin
        Select City
              ,State
          Into L_v_City
              ,L_v_State
          From Ra_Addresses_All
         Where Address_Id = P_Address_Id;
        -- Calcula a proxima data util
        Begin
          Jl_Br_Workday_Calendar.Jl_Br_Check_Date(P_Date     => to_char(L_d_Day, 'DD-MM-YYYY') --
                                                 ,P_Calendar => L_v_Calendar_Name --
                                                 ,P_City     => L_v_City --
                                                 ,P_Action   => L_v_Payment_Action --
                                                 ,P_New_Date => L_v_Workdaydate_Char --
                                                 ,P_Status   => L_n_Check_Date_Return_Code --
                                                 ,P_State    => L_v_State --
                                                  );
          Select To_Date(L_v_Workdaydate_Char, 'DD-MM-YYYY')
            Into L_d_Next_Date
            From Dual;
        End;
      End;
    End If;
    Return(Nvl(L_d_Next_Date, L_d_Day));
  End Get_Next_Day_Utl_f;

  ------------------------------------
  -- Funcao para convercao de itens --
  ------------------------------------
  Function Inv_Um_Convert_f
  (
    P_Item_Id       Number
   ,P_From_Quantity Number
   ,P_From_Unit     Varchar2
   ,P_To_Unit       Varchar2
  ) Return Number Is
    L_n_Ret Number;
  Begin
    L_n_Ret := Inv_Convert.Inv_Um_Convert --
               (Item_Id       => P_Item_Id -- id do item de inventario
               ,Precision     => 5 -- precision
               ,From_Quantity => P_From_Quantity -- 
               ,From_Unit     => P_From_Unit -- 
               ,To_Unit       => P_To_Unit --
               ,From_Name     => '' --
               ,To_Name       => '' --
                );
    If L_n_Ret = -99999
    Then
      L_n_Ret := Inv_Convert.Inv_Um_Convert --
                 (Item_Id       => P_Item_Id -- id do item de inventario
                 ,Precision     => 5 -- precision
                 ,From_Quantity => P_From_Quantity -- 
                 ,From_Unit     => P_From_Unit -- 
                 ,To_Unit       => P_To_Unit --
                 ,From_Name     => '' --
                 ,To_Name       => '' --
                  );
    End If;
    Return(L_n_Ret);
  End Inv_Um_Convert_f;

  -- Funcao para verificar se tem alguem usando o Lote 
  Function Use_Lot_Ver_f
  (
    P_Lot_Invoice_Id Number
   ,P_User_Id        Number
  ) Return Varchar2 Is
    -- Cursor do Lote
    Cursor C_Moli(Pc_Lot_Invoice_Id Number) Is
      Select *
        From Mdb_Otm_Lot_Invoices_All
       Where Lot_Invoice_Id = Pc_Lot_Invoice_Id;
    -- Variaveis 
    L_v_Ret            Varchar2(1000) := 'OK';
    L_r_Mola           Mdb_Otm_Lot_Accesses_All%Rowtype;
    L_r_Fu             Fnd_User%Rowtype;
    L_n_Count_Sessions Number;
  Begin
    -- Recuperar inf do Lote 
    For R_Moli In C_Moli(Pc_Lot_Invoice_Id => P_Lot_Invoice_Id)
    Loop
      -- Dependendo do Status do Lote valida o acesso 
      If R_Moli.Lot_Status_Code In ('CREATED' -- Criado
                                   ,'WAITING SELECTION' -- Aguardando Seleção
                                   ,'COMPLETED SELECTION' -- Seleção Concluída
                                   ,'NOT COMPLETED SELECTION' -- Seleção não Concluída
                                   ,'WAITING BACKORDER ALL' -- Aguardando Backorder Total
                                   ,'COMPLETED BACKORDER ALL' -- Backorder Total Concluído
                                   ,'NOT COMPLETED BACKORDER ALL' -- Backorder Total não Concluído
                                   ,'WAITING COURT BILLING' -- Aguardando Corte de Faturamento
                                   ,'NOT COMPLETED COURT BILLING' -- Corte de Faturamento não Concluído
                                    )
      Then
        -- Verificar se o Lote esta sendo usado
        Begin
          Select *
            Into L_r_Mola
            From Mdb_Otm_Lot_Accesses_All
           Where Lot_Invoice_Id = P_Lot_Invoice_Id;
        Exception
          When Others Then
            Null;
        End;
        -- Se nao estiver sendo usado por nenhum usuario
        If L_r_Mola.Lot_Invoice_Id Is Null
        Then
          L_r_Mola.Lot_Invoice_Id    := R_Moli.Lot_Invoice_Id;
          L_r_Mola.Organization_Id   := R_Moli.Organization_Id;
          L_r_Mola.Org_Id            := R_Moli.Org_Id;
          L_r_Mola.Creation_Date     := Sysdate;
          L_r_Mola.Created_By        := P_User_Id;
          L_r_Mola.Last_Update_Date  := Sysdate;
          L_r_Mola.Last_Updated_By   := P_User_Id;
          L_r_Mola.Last_Update_Login := Fnd_Global.Login_Id;
          -- Inclui o acesso 
          Begin
            Insert Into Mdb_Otm_Lot_Accesses_All
            Values L_r_Mola;
            Commit;
          Exception
            When Dup_Val_On_Index Then
              -- Se retornou erro recupera as inf
              Begin
                Select *
                  Into L_r_Mola
                  From Mdb_Otm_Lot_Accesses_All
                 Where Lot_Invoice_Id = P_Lot_Invoice_Id;
              Exception
                When Others Then
                  Null;
              End;
          End;
        End If;
        -- Verifica se o usuario que esta no controle eh o mesmo que esta abrindo o lote
        If L_r_Mola.Created_By != P_User_Id
        Then
          -- Recupera o Numere do usuario
          Select *
            Into L_r_Fu
            From Fnd_User
           Where User_Id = L_r_Mola.Created_By;
          -- Verificar se tem alguma session valida para o usuario
          Select Count(*)
            Into L_n_Count_Sessions
            From V$session
           Where Username Is Not Null
             And Module = 'MDBOTMLOTINVOICES'
             And Action Like 'FRM:' || L_r_Fu.User_Name || '%'
             And Logon_Time >= Trunc(Sysdate);
          -- Se nao encontrou nenhuma sessao atualiza
          If L_n_Count_Sessions = 0
          Then
            Update Mdb_Otm_Lot_Accesses_All Mola
               Set Mola.Creation_Date    = Sysdate
                  ,Mola.Created_By       = P_User_Id
                  ,Mola.Last_Update_Date = Sysdate
                  ,Mola.Last_Updated_By  = P_User_Id
             Where Lot_Invoice_Id = P_Lot_Invoice_Id;
            Commit;
          Else
            L_v_Ret := 'O Lote está sendo usado pelo usuário ' ||
                       L_r_Fu.User_Name;
          End If;
        End If;
      Else
        L_v_Ret := Mdb_Otm_Lot_Invoices_Pk.Use_Lot_Del_f(P_Lot_Invoice_Id => P_Lot_Invoice_Id);
      End If;
    End Loop C_Moli;
    Return(L_v_Ret);
  End Use_Lot_Ver_f;

  -- Funcao para deletar o controle de acesso do lote 
  Function Use_Lot_Del_f(P_Lot_Invoice_Id Number) Return Varchar2 Is
    L_v_Ret Varchar2(1000) := 'OK';
  Begin
    Delete Mdb_Otm_Lot_Accesses_All
     Where Lot_Invoice_Id = P_Lot_Invoice_Id;
    Return(L_v_Ret);
  End Use_Lot_Del_f;

  -- Procedure para Incluir as Linhas deletadas --
  Procedure Insert_Line_Deleted_p
  (
    P_r_Moll  Mdb_Otm_Lot_Lines_All %Rowtype
   ,P_r_Molle Mdb_Otm_Lot_Line_Excludeds_All %Rowtype
  ) Is
    L_r_Molle Mdb_Otm_Lot_Line_Excludeds_All %Rowtype;
  Begin
    L_r_Molle.Lot_Line_Id                    := P_r_Moll.Lot_Line_Id;
    L_r_Molle.Lot_Line_Id                    := P_r_Moll.Lot_Line_Id;
    L_r_Molle.Lot_Invoice_Id                 := P_r_Moll.Lot_Invoice_Id;
    L_r_Molle.Organization_Id                := P_r_Moll.Organization_Id;
    L_r_Molle.Org_Id                         := P_r_Moll.Org_Id;
    L_r_Molle.Schedule_Ship_Date             := P_r_Moll.Schedule_Ship_Date;
    L_r_Molle.Schedule_Ship_Date_Old         := P_r_Moll.Schedule_Ship_Date_Old;
    L_r_Molle.Header_Id                      := P_r_Moll.Header_Id;
    L_r_Molle.Order_Number                   := P_r_Moll.Order_Number;
    L_r_Molle.Line_Id                        := P_r_Moll.Line_Id;
    L_r_Molle.Line_Number                    := P_r_Moll.Line_Number;
    L_r_Molle.Shipment_Number                := P_r_Moll.Shipment_Number;
    L_r_Molle.Delivery_Detail_Id             := P_r_Moll.Delivery_Detail_Id;
    L_r_Molle.Inventory_Item_Id              := P_r_Moll.Inventory_Item_Id;
    L_r_Molle.Requested_Quantity_Uom         := P_r_Moll.Requested_Quantity_Uom;
    L_r_Molle.Requested_Quantity             := P_r_Moll.Requested_Quantity;
    L_r_Molle.Unit_Price                     := P_r_Moll.Unit_Price;
    L_r_Molle.Shipment_Priority_Code         := P_r_Moll.Shipment_Priority_Code;
    L_r_Molle.Selected_Flag                  := P_r_Moll.Selected_Flag;
    L_r_Molle.Line_Type_Id                   := P_r_Moll.Line_Type_Id;
    L_r_Molle.Lt_Send_Not_Reservation_Flag   := P_r_Moll.Lt_Send_Not_Reservation_Flag;
    L_r_Molle.Lt_Apply_Hold_Flag             := P_r_Moll.Lt_Apply_Hold_Flag;
    L_r_Molle.Org_Max_Line_Uom               := P_r_Moll.Org_Max_Line_Uom;
    L_r_Molle.Org_Max_Line_Quantity          := P_r_Moll.Org_Max_Line_Quantity;
    L_r_Molle.Address_Id                     := P_r_Moll.Address_Id;
    L_r_Molle.Customer_Id                    := P_r_Moll.Customer_Id;
    L_r_Molle.Document_Number                := P_r_Moll.Document_Number;
    L_r_Molle.Add_Max_Line_Uom               := P_r_Moll.Add_Max_Line_Uom;
    L_r_Molle.Add_Max_Line_Quantity          := P_r_Moll.Add_Max_Line_Quantity;
    L_r_Molle.Add_Days_To_Split_Quantity     := P_r_Moll.Add_Days_To_Split_Quantity;
    L_r_Molle.Add_Vehicle_Per_Day_Quantity   := P_r_Moll.Add_Vehicle_Per_Day_Quantity;
    L_r_Molle.Add_Apply_Retention_Flag       := P_r_Moll.Add_Apply_Retention_Flag;
    L_r_Molle.Add_Customer_Route_Id          := P_r_Moll.Add_Customer_Route_Id;
    L_r_Molle.Add_Delivery_Lead_Time         := P_r_Moll.Add_Delivery_Lead_Time;
    L_r_Molle.Add_Billing_Forecast_Lead_Time := P_r_Moll.Add_Billing_Forecast_Lead_Time;
    L_r_Molle.Add_Billing_Cut_Sunday_Flag    := P_r_Moll.Add_Billing_Cut_Sunday_Flag;
    L_r_Molle.Add_Billing_Cut_Monday_Flag    := P_r_Moll.Add_Billing_Cut_Monday_Flag;
    L_r_Molle.Add_Billing_Cut_Tuesday_Flag   := P_r_Moll.Add_Billing_Cut_Tuesday_Flag;
    L_r_Molle.Add_Billing_Cut_Wednesday_Flag := P_r_Moll.Add_Billing_Cut_Wednesday_Flag;
    L_r_Molle.Add_Billing_Cut_Thursday_Flag  := P_r_Moll.Add_Billing_Cut_Thursday_Flag;
    L_r_Molle.Add_Billing_Cut_Friday_Flag    := P_r_Moll.Add_Billing_Cut_Friday_Flag;
    L_r_Molle.Add_Billing_Cut_Saturday_Flag  := P_r_Moll.Add_Billing_Cut_Saturday_Flag;
    L_r_Molle.Add_Send_Not_Reservation_Flag  := P_r_Moll.Add_Send_Not_Reservation_Flag;
    L_r_Molle.Ship_Method_Code               := P_r_Moll.Ship_Method_Code;
    L_r_Molle.Smc_Max_Line_Uom               := P_r_Moll.Smc_Max_Line_Uom;
    L_r_Molle.Smc_Max_Line_Quantity          := P_r_Moll.Smc_Max_Line_Quantity;
    L_r_Molle.Smc_Min_Line_Uom               := P_r_Moll.Smc_Min_Line_Uom;
    L_r_Molle.Smc_Min_Line_Quantity          := P_r_Moll.Smc_Min_Line_Quantity;
    L_r_Molle.Smc_Min_Requested_Quantity     := P_r_Moll.Smc_Min_Requested_Quantity;
    L_r_Molle.Smc_Separation_Sequence        := P_r_Moll.Smc_Separation_Sequence;
    L_r_Molle.Smc_Indivisible_Flag           := P_r_Moll.Smc_Indivisible_Flag;
    L_r_Molle.Smc_Delivery_Lead_Time         := P_r_Moll.Smc_Delivery_Lead_Time;
    L_r_Molle.Smc_Billing_Forecast_Lead_Time := P_r_Moll.Smc_Billing_Forecast_Lead_Time;
    L_r_Molle.Smc_Billing_Partial_Flag       := P_r_Moll.Smc_Billing_Partial_Flag;
    L_r_Molle.Smc_Send_Not_Reservation_Flag  := P_r_Moll.Smc_Send_Not_Reservation_Flag;
    L_r_Molle.Smc_Apply_Retention_Flag       := P_r_Moll.Smc_Apply_Retention_Flag;
    L_r_Molle.Moc_Min_Delivery_Uom           := P_r_Moll.Moc_Min_Delivery_Uom;
    L_r_Molle.Moc_Min_Delivery_Quantity      := P_r_Moll.Moc_Min_Delivery_Quantity;
    L_r_Molle.Moc_Min_Requested_Quantity     := P_r_Moll.Moc_Min_Requested_Quantity;
    L_r_Molle.Moc_Delivery_Lead_Time         := P_r_Moll.Moc_Delivery_Lead_Time;
    L_r_Molle.Moc_Billing_Cut_Sunday_Flag    := P_r_Moll.Moc_Billing_Cut_Sunday_Flag;
    L_r_Molle.Moc_Billing_Cut_Monday_Flag    := P_r_Moll.Moc_Billing_Cut_Monday_Flag;
    L_r_Molle.Moc_Billing_Cut_Tuesday_Flag   := P_r_Moll.Moc_Billing_Cut_Tuesday_Flag;
    L_r_Molle.Moc_Billing_Cut_Wednesday_Flag := P_r_Moll.Moc_Billing_Cut_Wednesday_Flag;
    L_r_Molle.Moc_Billing_Cut_Thursday_Flag  := P_r_Moll.Moc_Billing_Cut_Thursday_Flag;
    L_r_Molle.Moc_Billing_Cut_Friday_Flag    := P_r_Moll.Moc_Billing_Cut_Friday_Flag;
    L_r_Molle.Moc_Billing_Cut_Saturday_Flag  := P_r_Moll.Moc_Billing_Cut_Saturday_Flag;
    L_r_Molle.Inv_Send_Not_Reservation_Flag  := P_r_Moll.Inv_Send_Not_Reservation_Flag;
    L_r_Molle.Inv_Apply_Retention_Flag       := P_r_Moll.Inv_Apply_Retention_Flag;
    L_r_Molle.Inv_Commodities_Code           := P_r_Moll.Inv_Commodities_Code;
    L_r_Molle.Otm_Order_Number               := P_r_Moll.Otm_Order_Number;
    L_r_Molle.Release_Id                     := P_r_Moll.Release_Id;
    L_r_Molle.Lot_Otm_Status_Line_Code       := P_r_Moll.Lot_Otm_Status_Line_Code;
    L_r_Molle.Lot_Otm_Status_Line_Comments   := P_r_Moll.Lot_Otm_Status_Line_Comments;
    L_r_Molle.Use_Max_Line_Source            := P_r_Moll.Use_Max_Line_Source;
    L_r_Molle.Use_Max_Line_Uom               := P_r_Moll.Use_Max_Line_Uom;
    L_r_Molle.Use_Max_Line_Quantity          := P_r_Moll.Use_Max_Line_Quantity;
    L_r_Molle.Max_Line_Set_Conv_To_Requested := P_r_Moll.Max_Line_Set_Conv_To_Requested;
    L_r_Molle.Requested_Quantity_Conv_To_Set := P_r_Moll.Requested_Quantity_Conv_To_Set;
    L_r_Molle.Split_From_Line_Id             := P_r_Moll.Split_From_Line_Id;
    L_r_Molle.Split_From_Line_Id_Wdd         := P_r_Moll.Split_From_Line_Id_Wdd;
    L_r_Molle.Batch_Id                       := P_r_Moll.Batch_Id;
    L_r_Molle.Creation_Date                  := P_r_Moll.Creation_Date;
    L_r_Molle.Created_By                     := P_r_Moll.Created_By;
    L_r_Molle.Last_Update_Date               := P_r_Moll.Last_Update_Date;
    L_r_Molle.Last_Updated_By                := P_r_Moll.Last_Updated_By;
    L_r_Molle.Last_Update_Login              := P_r_Moll.Last_Update_Login;
    L_r_Molle.Use_Delivery_Lead_Source       := P_r_Moll.Use_Delivery_Lead_Source;
    L_r_Molle.Use_Delivery_Lead_Time         := P_r_Moll.Use_Delivery_Lead_Time;
    L_r_Molle.Cube_Quantity_Mdb              := P_r_Moll.Cube_Quantity_Mdb;
    L_r_Molle.Unit_Weight_Item               := P_r_Moll.Unit_Weight_Item;
    L_r_Molle.Unit_Weight_Container          := P_r_Moll.Unit_Weight_Container;
    L_r_Molle.Net_Weight_Line                := P_r_Moll.Net_Weight_Line;
    L_r_Molle.Gross_Weight_Line              := P_r_Moll.Gross_Weight_Line;
    L_r_Molle.Wdd_Otm_Status_Line_Code       := P_r_Molle.Wdd_Otm_Status_Line_Code;
    L_r_Molle.Wdd_Otm_Status_Line_Comments   := P_r_Molle.Wdd_Otm_Status_Line_Comments;
    L_r_Molle.Comments                       := P_r_Molle.Comments;
    Insert Into Mdb_Otm_Lot_Line_Excludeds_All
    Values L_r_Molle;
  End Insert_Line_Deleted_p;
  
   /**
   * Funcao para retornar o lote de planejamento da delivery
   */  
  Function get_lot_plan_id_f(p_nDelivery_detail_id MDB_OTM_LOT_LINES_ALL.DELIVERY_DETAIL_ID%TYPE) Return MDB_OM_LOT_PLAN_HEADERS_ALL.LOT_PLAN_ID%TYPE IS
    l_nLot_plan_id   MDB_OM_LOT_PLAN_HEADERS_ALL.LOT_PLAN_ID%TYPE;
  BEGIN
    
  -- busca planejamento CONCLUIDO e indivisivel
    SELECT nvl(max(MOLPH.LOT_PLAN_ID),-1) 
      INTO l_nLot_plan_id
      FROM MDB_OM_LOT_PLAN_HEADERS_ALL MOLPH,
           MDB_OM_LOT_PLAN_LINES_ALL   MOLPL
     WHERE MOLPH.LOT_PLAN_ID = MOLPL.LOT_PLAN_ID
       AND MOLPL.DELIVERY_DETAIL_ID = p_nDelivery_detail_id
       AND MOLPH.LOT_STATUS_CODE = 'COMPLETED' -- concluido
       AND MOLPH.LOT_UNIQUE_ORDER_FLAG = 'Y';  -- indivisivel
  
    RETURN l_nLot_plan_id;
  END;
  
  -- Procedure para Atualizar status da linha do lote --
  PROCEDURE update_status_line_p(P_N_LOTE_LINE_ID NUMBER,
                                 P_V_MSG          VARCHAR2,
                                 P_V_STATUS       VARCHAR2) IS
  BEGIN
    Update Mdb_Otm_Lot_Lines_All Moll
             Set Moll.Lot_Otm_Status_Line_Code = P_V_STATUS
               , Moll.Lot_Otm_Status_Line_Comments = P_V_MSG
             Where Lot_Line_Id = P_N_LOTE_LINE_ID;
    Commit;
    
  END UPDATE_STATUS_LINE_P;

End Mdb_Otm_Lot_Invoices_Pk;
/