create or replace PACKAGE WSH_TRIPS_PUB AUTHID CURRENT_USER as

TYPE Trip_Pub_Rec_Type IS RECORD (
 	TRIP_ID                         NUMBER DEFAULT FND_API.G_MISS_NUM,
	NAME                            VARCHAR2(30) DEFAULT FND_API.G_MISS_CHAR,
 	ARRIVE_AFTER_TRIP_ID            NUMBER DEFAULT FND_API.G_MISS_NUM,
	ARRIVE_AFTER_TRIP_NAME          VARCHAR2(30) DEFAULT FND_API.G_MISS_CHAR,
 	VEHICLE_ITEM_ID                 NUMBER DEFAULT FND_API.G_MISS_NUM,
	VEHICLE_ITEM_DESC               VARCHAR2(240) DEFAULT FND_API.G_MISS_CHAR,
 	VEHICLE_ORGANIZATION_ID         NUMBER DEFAULT FND_API.G_MISS_NUM,
 	VEHICLE_ORGANIZATION_CODE       VARCHAR2(3) DEFAULT FND_API.G_MISS_CHAR,
 	VEHICLE_NUMBER                  VARCHAR2(30) DEFAULT FND_API.G_MISS_CHAR,
 	VEHICLE_NUM_PREFIX              VARCHAR2(10) DEFAULT FND_API.G_MISS_CHAR,
 	CARRIER_ID                      NUMBER DEFAULT FND_API.G_MISS_NUM,
 	SHIP_METHOD_CODE                VARCHAR2(30) DEFAULT FND_API.G_MISS_CHAR,
 	SHIP_METHOD_NAME                VARCHAR2(80) DEFAULT FND_API.G_MISS_CHAR,
 	ROUTE_ID                        NUMBER DEFAULT FND_API.G_MISS_NUM,
 	ROUTING_INSTRUCTIONS            VARCHAR2(2000) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE_CATEGORY              VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE1                      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE2                      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE3                      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE4                      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE5                      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE6                      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE7                      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE8                      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE9                      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE10                     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE11                     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE12                     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE13                     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE14                     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	ATTRIBUTE15                     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
 	CREATION_DATE                   DATE DEFAULT FND_API.G_MISS_DATE,
 	CREATED_BY                      NUMBER DEFAULT FND_API.G_MISS_NUM,
 	LAST_UPDATE_DATE                DATE DEFAULT FND_API.G_MISS_DATE,
 	LAST_UPDATED_BY                 NUMBER DEFAULT FND_API.G_MISS_NUM,
 	LAST_UPDATE_LOGIN               NUMBER DEFAULT FND_API.G_MISS_NUM,
 	PROGRAM_APPLICATION_ID          NUMBER DEFAULT FND_API.G_MISS_NUM,
 	PROGRAM_ID                      NUMBER DEFAULT FND_API.G_MISS_NUM,
 	PROGRAM_UPDATE_DATE             DATE DEFAULT FND_API.G_MISS_DATE,
 	REQUEST_ID                      NUMBER DEFAULT FND_API.G_MISS_NUM,
    SERVICE_LEVEL                   VARCHAR2(30) DEFAULT FND_API.G_MISS_CHAR,
    MODE_OF_TRANSPORT               VARCHAR2(30) DEFAULT FND_API.G_MISS_CHAR,
    OPERATOR                        VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR);

	TYPE Action_Param_Rectype IS RECORD (
         ACTION_CODE                    VARCHAR2(500)
        ,ORGANIZATION_ID                NUMBER
        ,REPORT_SET_NAME                VARCHAR2(30)
        ,REPORT_SET_ID                  NUMBER
        ,OVERRIDE_FLAG                  VARCHAR2(1)
        ,ACTUAL_DATE                    DATE
        ,ACTION_FLAG                    VARCHAR2(1)   DEFAULT 'S'
        ,AUTOINTRANSIT_FLAG             VARCHAR2(1)   DEFAULT 'Y'
        ,AUTOCLOSE_FLAG                 VARCHAR2(1)   DEFAULT 'Y'
        ,STAGE_DEL_FLAG                 VARCHAR2(1)   DEFAULT 'Y'
        ,SHIP_METHOD                    VARCHAR2(30)
        ,BILL_OF_LADING_FLAG            VARCHAR2(1)   DEFAULT 'Y'
        ,DEFER_INTERFACE_FLAG           VARCHAR2(1)   DEFAULT 'N'
        ,ACTUAL_DEPARTURE_DATE          DATE          DEFAULT SYSDATE
      );


  PROCEDURE Create_Update_Trip
  ( p_api_version_number     IN   NUMBER,
    p_init_msg_list          IN   VARCHAR2,
    x_return_status          OUT NOCOPY   VARCHAR2,
    x_msg_count              OUT NOCOPY   NUMBER,
    x_msg_data               OUT NOCOPY   VARCHAR2,
    p_action_code            IN   VARCHAR2,
    p_trip_info	         IN OUT NOCOPY   Trip_Pub_Rec_Type,
    p_trip_name              IN   VARCHAR2 DEFAULT FND_API.G_MISS_CHAR,
    x_trip_id                OUT NOCOPY   NUMBER,
    x_trip_name              OUT NOCOPY   VARCHAR2);

  PROCEDURE Trip_Action
  ( p_api_version_number     IN   NUMBER,
    p_init_msg_list          IN   VARCHAR2,
    p_commit                 IN   VARCHAR2 DEFAULT FND_API.G_FALSE,
    x_return_status          OUT  NOCOPY   VARCHAR2,
    x_msg_count              OUT  NOCOPY   NUMBER,
    x_msg_data               OUT  NOCOPY   VARCHAR2,
    p_action_param_rec       IN   WSH_TRIPS_PUB.Action_Param_Rectype,
    p_trip_id                IN   NUMBER DEFAULT NULL,
    p_trip_name              IN   VARCHAR2 DEFAULT NULL );

END WSH_TRIPS_PUB;
/

create or replace PACKAGE BODY WSH_TRIPS_PUB as

  PROCEDURE Trip_Action
	  ( p_api_version_number     IN   NUMBER,
	    p_init_msg_list          IN   VARCHAR2,
	    p_commit                 IN   VARCHAR2,
	    x_return_status          OUT  NOCOPY   VARCHAR2,
	    x_msg_count              OUT  NOCOPY   NUMBER,
	    x_msg_data               OUT  NOCOPY   VARCHAR2,
	    p_action_param_rec       IN   WSH_TRIPS_PUB.Action_Param_Rectype,
	    p_trip_id                IN   NUMBER ,
	    p_trip_name              IN   VARCHAR2 ) IS
  BEGIN
	null;
  END Trip_Action;

	PROCEDURE Create_Update_Trip
	  ( p_api_version_number     IN   NUMBER,
	    p_init_msg_list          IN   VARCHAR2,
	    x_return_status          OUT NOCOPY   VARCHAR2,
	    x_msg_count              OUT NOCOPY   NUMBER,
	    x_msg_data               OUT NOCOPY   VARCHAR2,
	    p_action_code            IN   VARCHAR2,
	    p_trip_info          IN OUT NOCOPY   Trip_Pub_Rec_Type,
	    p_trip_name              IN   VARCHAR2 DEFAULT FND_API.G_MISS_CHAR,
	    x_trip_id                OUT NOCOPY   NUMBER,
	    x_trip_name              OUT NOCOPY   VARCHAR2) IS
	BEGIN
    	-- sempre sucesso
		x_return_status := WSH_UTIL_CORE.G_RET_STS_SUCCESS;
	END Create_Update_Trip;

END WSH_TRIPS_PUB;
/