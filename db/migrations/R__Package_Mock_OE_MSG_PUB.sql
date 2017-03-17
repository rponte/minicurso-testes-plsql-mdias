create or replace PACKAGE OE_MSG_PUB AUTHID CURRENT_USER AS

    G_FIRST	    CONSTANT	NUMBER	:=  -1	;
    G_NEXT	    CONSTANT	NUMBER	:=  -2	;
    G_LAST	    CONSTANT	NUMBER	:=  -3	;
    G_PREVIOUS	    CONSTANT	NUMBER	:=  -4	;


    G_msg_level_threshold	NUMBER    	:= FND_API.G_MISS_NUM;

TYPE G_MSG_CONTEXT_REC_TYPE IS RECORD
    (ENTITY_CODE       		VARCHAR2(30)
    ,ENTITY_REF       		VARCHAR2(50)
    ,ENTITY_ID         		NUMBER
    ,HEADER_ID         		NUMBER
    ,LINE_ID           		NUMBER
    ,ORDER_SOURCE_ID            NUMBER
    ,ORIG_SYS_DOCUMENT_REF	VARCHAR2(50)
    ,ORIG_SYS_DOCUMENT_LINE_REF	VARCHAR2(50)
    ,ORIG_SYS_SHIPMENT_REF	VARCHAR2(50)
    ,CHANGE_SEQUENCE		VARCHAR2(50)
    ,SOURCE_DOCUMENT_TYPE_ID    NUMBER
    ,SOURCE_DOCUMENT_ID		NUMBER
    ,SOURCE_DOCUMENT_LINE_ID	NUMBER
    ,ATTRIBUTE_CODE       	VARCHAR2(30)
    ,CONSTRAINT_ID		NUMBER
    ,PROCESS_ACTIVITY		NUMBER
   );

TYPE Msg_Context_Tbl_Type IS TABLE OF G_MSG_CONTEXT_REC_TYPE
 INDEX BY BINARY_INTEGER;

G_msg_context_tbl                   Msg_Context_Tbl_Type;
G_msg_context_count                 NUMBER          := 0;
G_msg_context_index                 NUMBER          := 0;


-- API message record type
   TYPE G_MSG_REC_TYPE IS RECORD
   ( MESSAGE          		  Varchar2(2000)
    ,ENTITY_CODE       		  VARCHAR2(30)
    ,ENTITY_ID         		  NUMBER
    ,HEADER_ID         		  NUMBER
    ,LINE_ID           		  NUMBER
    ,ORDER_SOURCE_ID              NUMBER
    ,ORIG_SYS_DOCUMENT_REF	  VARCHAR2(50)
    ,ORIG_SYS_DOCUMENT_LINE_REF   VARCHAR2(50)
    ,SOURCE_DOCUMENT_TYPE_ID      NUMBER
    ,SOURCE_DOCUMENT_ID		  NUMBER
    ,SOURCE_DOCUMENT_LINE_ID	  NUMBER
    ,ATTRIBUTE_CODE       	  VARCHAR2(30)
    ,CONSTRAINT_ID		  NUMBER
    ,PROCESS_ACTIVITY		  NUMBER
    ,NOTIFICATION_FLAG            VARCHAR2(1)
    ,MESSAGE_TEXT                 Varchar2(2000)
    ,TYPE                 	  Varchar2(30)
    ,ENTITY_REF       		  VARCHAR2(50)
    ,ORIG_SYS_SHIPMENT_REF   	  VARCHAR2(50)
    ,CHANGE_SEQUENCE   	  	  VARCHAR2(50)
    ,PROCESSED                VARCHAR2(1)
   );


--  API message table type
--
--  	PL/SQL table of VARCHAR2(2000)
--	This is the datatype of the API message list

    TYPE Msg_Tbl_Type IS TABLE OF G_MSG_REC_TYPE
    INDEX BY BINARY_INTEGER;

--  Global message table variable.
--  this variable is global to the OE_MSG_PUB package only.
    G_msg_tbl	    		Msg_Tbl_Type;

--  Global variable holding the message count.
    G_msg_count   		NUMBER      	:= 0;

--  Index used by the Get function to keep track of the last fetched
--  message.
    G_msg_index			NUMBER		:= 0;

--  Global variable holding the process_activity values.
    G_process_activity	        NUMBER          := NULL;
    
    
    PROCEDURE    Get
	(   p_msg_index     IN  NUMBER      := G_NEXT           ,
	    p_encoded       IN  VARCHAR2    := FND_API.G_TRUE   ,
		p_data OUT NOCOPY VARCHAR2 ,
		p_msg_index_out OUT NOCOPY NUMBER
	);
    
END OE_MSG_PUB;
/

create or replace PACKAGE BODY OE_MSG_PUB AS

	PROCEDURE    Get
	(   p_msg_index     IN  NUMBER      := G_NEXT           ,
	    p_encoded       IN  VARCHAR2    := FND_API.G_TRUE   ,
		p_data OUT NOCOPY VARCHAR2 ,
		p_msg_index_out OUT NOCOPY NUMBER
	) is
	begin
		null;
	end;

END OE_MSG_PUB;
/