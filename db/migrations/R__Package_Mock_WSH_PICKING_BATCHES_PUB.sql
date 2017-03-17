create or replace PACKAGE WSH_PICKING_BATCHES_PUB AUTHID CURRENT_USER AS
-- $Header: WSHPRPBS.pls 115.5.11510.2 2004/11/30 20:57:01 kvenkate ship $
/*#
 * This is the public interface for picking batches. This package
 * has procedures for creating and releasing picking batches.
 * @rep:scope public
 * @rep:product WSH
 * @rep:displayname Picking Batch
 * @rep:lifecycle active
 * @rep:category BUSINESS_ENTITY WSH_DELIVERY_LINE
 * @rep:category BUSINESS_ENTITY WSH_DELIVERY
 * @rep:category BUSINESS_ENTITY WSH_TRIP
 * @rep:category BUSINESS_ENTITY PICKING_BATCHES
 */
--
--===================
-- PUBLIC VARS
--===================
--
--
 TYPE Batch_Info_rec IS Record (
             Backorders_Only_Flag        wsh_picking_batches.Backorders_Only_Flag%TYPE,
	     Document_Set_Id             wsh_picking_batches.Document_Set_Id%TYPE,
	     Document_Set_Name           wsh_report_sets.name%TYPE,
             Existing_Rsvs_Only_Flag     wsh_picking_batches.Existing_Rsvs_Only_Flag%TYPE,
             Shipment_Priority_Code      wsh_picking_batches.Shipment_Priority_Code%TYPE,
             Ship_Method_Code            wsh_picking_batches.Ship_Method_Code%TYPE,
	     Ship_Method_Name            fnd_lookup_values_vl.meaning%TYPE,
             Customer_Id                 wsh_picking_batches.Customer_Id%TYPE,
	     Customer_Number             ra_customers.customer_number%TYPE,
             Order_Header_Id             wsh_picking_batches.Order_Header_Id%TYPE,
	     Order_Number                oe_order_headers_all.Order_Number%TYPE,
	     Ship_Set_Id                 wsh_picking_batches.Ship_Set_Number%TYPE,
	     Ship_Set_Number             oe_sets.set_name%TYPE,
             Inventory_Item_Id           wsh_picking_batches.Inventory_Item_Id%TYPE,
             Order_Type_Id               wsh_picking_batches.Order_Type_Id%TYPE,
	     Order_Type_Name             oe_transaction_types_tl.name%TYPE,
             From_Requested_Date         DATE,
             To_Requested_Date           DATE,
             From_Scheduled_Ship_Date    DATE,
             To_Scheduled_Ship_Date      DATE,
             Ship_To_Location_Id         wsh_picking_batches.Ship_To_Location_Id%TYPE,
	     Ship_To_Location_code       hr_locations_all_tl.location_code%TYPE,
             Ship_From_Location_Id       wsh_picking_batches.Ship_From_Location_Id%TYPE,
	     Ship_From_Location_code     hr_locations_all_tl.location_code%TYPE,
             Trip_Id                     wsh_picking_batches.Trip_Id%TYPE,
	     Trip_Name                   wsh_trips.name%TYPE,
             Delivery_Id                 wsh_picking_batches.Delivery_Id%TYPE,
	     Delivery_Name               wsh_new_deliveries.name%TYPE,
             Include_Planned_Lines       wsh_picking_batches.Include_Planned_Lines%TYPE,
             Pick_Grouping_Rule_Id       wsh_picking_batches.Pick_Grouping_Rule_Id%TYPE,
             Pick_Grouping_Rule_Name     wsh_pick_grouping_rules.name%TYPE,
             Pick_Sequence_Rule_Id       wsh_picking_batches.Pick_Sequence_Rule_Id%TYPE,
             Pick_Sequence_Rule_Name     wsh_pick_sequence_rules.name%TYPE,
	     Autocreate_Delivery_Flag    wsh_picking_batches.Autocreate_Delivery_Flag%TYPE,
             Attribute_Category          wsh_picking_batches.Attribute_Category%TYPE,
             Attribute1                  wsh_picking_batches.Attribute1%TYPE,
             Attribute2                  wsh_picking_batches.Attribute2%TYPE,
             Attribute3                  wsh_picking_batches.Attribute3%TYPE,
             Attribute4                  wsh_picking_batches.Attribute4%TYPE,
             Attribute5                  wsh_picking_batches.Attribute5%TYPE,
             Attribute6                  wsh_picking_batches.Attribute6%TYPE,
             Attribute7                  wsh_picking_batches.Attribute7%TYPE,
             Attribute8                  wsh_picking_batches.Attribute8%TYPE,
             Attribute9                  wsh_picking_batches.Attribute9%TYPE,
             Attribute10                 wsh_picking_batches.Attribute10%TYPE,
             Attribute11                 wsh_picking_batches.Attribute11%TYPE,
             Attribute12                 wsh_picking_batches.Attribute12%TYPE,
             Attribute13                 wsh_picking_batches.Attribute13%TYPE,
             Attribute14                 wsh_picking_batches.Attribute14%TYPE,
             Attribute15                 wsh_picking_batches.Attribute15%TYPE,
             Autodetail_Pr_Flag          wsh_picking_batches.Autodetail_Pr_Flag%TYPE,
	     -- Bug#: 3266659 - Removing carrier params
             -- Carrier_Id                  wsh_picking_batches.Carrier_Id%TYPE,
             -- Carrier_Name                wsh_carriers_v.carrier_name%TYPE,
             Trip_Stop_Id                wsh_picking_batches.Trip_Stop_Id%TYPE,
	     Trip_Stop_location_id       wsh_trip_stops.Stop_Id%TYPE,
             Default_Stage_Subinventory  wsh_picking_batches.Default_Stage_Subinventory%TYPE,
             Default_Stage_Locator_Id    wsh_picking_batches.Default_Stage_Locator_Id%TYPE,
             Pick_From_Subinventory      wsh_picking_batches.Pick_From_Subinventory%TYPE,
             Pick_From_locator_Id        wsh_picking_batches.Pick_From_locator_Id%TYPE,
             Auto_Pick_Confirm_Flag      wsh_picking_batches.Auto_Pick_Confirm_Flag%TYPE,
             Delivery_Detail_Id          wsh_picking_batches.Delivery_Detail_Id%TYPE,
             Project_Id                  wsh_picking_batches.Project_Id%TYPE,
             Task_Id                     wsh_picking_batches.Task_Id%TYPE,
             Organization_Id             wsh_picking_batches.Organization_Id%TYPE,
	     Organization_Code           org_organization_definitions.organization_code%TYPE,
             Ship_Confirm_Rule_Id        wsh_picking_batches.Ship_Confirm_Rule_Id%TYPE,
	     Ship_Confirm_Rule_Name      wsh_Ship_Confirm_rules.name%TYPE,
             Autopack_Flag               wsh_picking_batches.Autopack_Flag%TYPE,
             Autopack_Level              wsh_picking_batches.Autopack_Level%TYPE,
             Task_Planning_Flag          wsh_picking_batches.Task_Planning_Flag%TYPE,
	     -- Bug#: 3266659 - Removing carrier params
             -- Non_Picking_flag            wsh_picking_batches.Non_Picking_flag%TYPE,
             Category_Set_ID             wsh_picking_batches.Category_Set_ID%TYPE,
             Category_ID                 wsh_picking_batches.Category_ID%TYPE,
             Ship_Set_Smc_Flag           wsh_picking_batches.Ship_Set_Smc_Flag%TYPE,
	     -- Bug#: 3266659 - Adding the  columns like zone, region, delivery criteria, release
	     --			subinventory and append flag
	     region_ID                   wsh_picking_batches.region_id%TYPE,
	     zone_ID                     wsh_picking_batches.zone_id%TYPE,
	     ac_Delivery_Criteria        wsh_picking_batches.ac_delivery_criteria%TYPE,
	     rel_subinventory            wsh_picking_batches.rel_subinventory%TYPE,
	     append_flag                 wsh_picking_batches.append_flag%TYPE := 'N',
             task_priority               wsh_picking_batches.task_priority%TYPE
  );

--===================
-- PROCEDURES
--===================

-- Start of comments
--
-- API Name          : Create_Batch
-- Type              : Public
-- Purpose
-- Pre-reqs          : None.
-- Function          : The procedure takes in a rule_id / rule_name and brings up the default
--                     values for a new batch to be created.
--                     It then uses the information in the in parameter p_batch_rec and replaces the
--                     values it picked up from the rule with the not null members of p_batch_rec
--                     It then creates a new batch_id and inserts a new batch in the picking batch table
--                     It will do some basic validations on the  the input parameters
--
--
-- PARAMETERS        : p_api_version_number    known api version  number
--                     p_init_msg_list         FND_API.G_TRUE to reset list
--                     p_commit                FND_API.G_TRUE to perform a commit
--                     x_return_status         return status
--                     x_msg_count             number of messages in the list
--                     x_msg_data              text of messages
--                     p_rule_id               Pick Release Rule Id --For Defaulting purpose
--                     p_rule_name             Pick Release Rule Name --For Defaulting purpose
--                     p_batch_rec             which contains all the Picking Batch parameters.
--                     p_batch_prefix          Which used to prefix for the Batch Name
--                                             i.e, Batch_Name becomes p_batch_prefix-batch_id
--                     x_batch_id              Returns the batch Id created
-- VERSION          :  current version         1.0
--                     initial version         1.0
-- End of comments

/*#
 * This procedure is used to create a picking batch. The procedure takes in a pick release
 * rule_id / rule_name and brings up the default values for a new batch to be created.
 * It then uses the information in the parameter p_batch_rec and replaces the values it
 * picked up from the rule with the not null values of p_batch_rec. A new batch is
 * inserted in the picking batch table.
 * @param p_api_version         version number of the API
 * @param p_init_msg_list       messages will be initialized, if set as true
 * @param p_commit              commits the transaction, if set as true
 * @param x_return_status       return status of the API
 * @param x_msg_count           number of messages, if any
 * @param x_msg_data            message text, if any
 * @param p_rule_id             pick release rule id for getting the defaulting rule to be used
 * @param p_rule_name           pick release rule name for getting the defaulting rule to be used
 * @param p_batch_rec           record structure for picking batch parameters.
 * @param p_batch_prefix        prefix for the batch name
 * @param x_batch_id            batch_id that is created by this procedure
 * @rep:scope public
 * @rep:lifecycle active
 * @rep:displayname Create Picking Batch
 */
 PROCEDURE Create_Batch (
        ----- Standard parameters
         p_api_version        IN   NUMBER,
         p_init_msg_list      IN   VARCHAR2  DEFAULT NULL,
         p_commit             IN   VARCHAR2  DEFAULT NULL,
         x_return_status      OUT  NOCOPY    VARCHAR2,
         x_msg_count          OUT  NOCOPY    NUMBER,
         x_msg_data           OUT  NOCOPY    VARCHAR2,

        ---- Program specific paramters.
         p_rule_id            IN   NUMBER    DEFAULT NULL,
	 p_rule_name          IN   VARCHAR2  DEFAULT NULL,
         p_batch_rec          IN   WSH_PICKING_BATCHES_PUB.Batch_Info_Rec,
         p_batch_prefix       IN   VARCHAR2  DEFAULT NULL,
         x_batch_id           OUT  NOCOPY    NUMBER

 );


-- Start of comments
--
-- API Name          : Release_Batch
-- Type              : Public
-- Purpose
-- Pre-reqs          : None.
-- Function          : The procedure takes in a Batch_id/ Batch_name and depending on the p_release_mode
--                     value it process the batch.   p_log_level value should be greator than 0 when
--                     customer want to get the pick release log incase of concurrent pick release
--
--                     It will do some basic validations on the  the input parameters
--                     like log_level should be positive  ,and on the not null values of p_batch_rec.
--
-- PARAMETERS        : p_api_version_number    known api version  number
--                     p_init_msg_list         FND_API.G_TRUE to reset list
--                     p_commit                FND_API.G_TRUE to perform a commit
--                     x_return_status         return status
--                     x_msg_count             number of messages in the list
--                     x_msg_data              text of messages
--                     p_batch_id              Picking Batch Id which is used to get Batch
--					       information from the wsh_picking_batches table.
--                     p_batch_name            Picking Batch Name which is used to get Batch
--					       information from the wsh_picking_batches table.
--                     p_log_level             Controlls the log message generated by cuncurrent
--					       pick release process.
--                     p_release_mode          Used to do ONLINE or CONCURRENT pick release,
--                                             Default is "CONCURREN"
--                     x_request_id            Returns request Id for concurrent pick release request
-- VERSION           : current version         1.0
--                     initial version         1.0
-- End of comments

/*#
 * This procedure is used to release a picking batch. The procedure takes in a pick release
 * Batch_id/ Batch_name and depending on the pick release mode value it processes the batch.
 * Log level value should be greater than 0 when the pick release log is needed.
 * @param p_api_version         version number of the API
 * @param p_init_msg_list       messages will be initialized, if set as true
 * @param p_commit              commits the transaction, if set as true
 * @param x_return_status       return status of the API
 * @param x_msg_count           number of messages, if any
 * @param x_msg_data            message text, if any
 * @param p_batch_id            Picking Batch Id to be released.
 * @param p_batch_name          Picking Batch Name to be released.
 * @param p_log_level           log level to control the log messages generated by concurrent pick release process
 * @param p_release_mode        pick release mode 'ONLINE' or 'CONCURRENT'
 * @param x_request_id          request id for concurrent pick release request
 * @rep:scope public
 * @rep:lifecycle active
 * @rep:displayname Release Picking Batch
 */
 PROCEDURE Release_Batch (
         -- Standard parameters
         p_api_version        IN   NUMBER,
         p_init_msg_list      IN   VARCHAR2  DEFAULT NULL,
         p_commit             IN   VARCHAR2  DEFAULT NULL,
         x_return_status      OUT  NOCOPY    VARCHAR2,
         x_msg_count          OUT  NOCOPY    NUMBER,
         x_msg_data           OUT  NOCOPY    VARCHAR2,
         -- program specific paramters.
          p_batch_id          IN   NUMBER   DEFAULT NULL,
	  p_batch_name        IN   VARCHAR2   DEFAULT NULL,
          p_log_level         IN   NUMBER   DEFAULT NULL,
	  p_release_mode      IN   VARCHAR2 DEFAULT 'CONCURRENT',
	  x_request_id        OUT  NOCOPY   NUMBER
        ) ;



-- Start of comments
--
-- API Name          : Get_Batch_Record
-- Type              : Public
-- Purpose
-- Pre-reqs          : None.
-- Function          : The procedure takes in a Batch_id or Batch_name and retrieves
--                     the batch record from wsh_picking_batches.
--                     Note: Non-database attributes will be NULL.
--
-- PARAMETERS        : p_api_version_number    known api version  number
--                     p_init_msg_list         FND_API.G_TRUE to reset list
--                     p_commit                FND_API.G_TRUE to perform a commit
--                     x_return_status         return status
--                     x_msg_count             number of messages in the list
--                     x_msg_data              text of messages
--                     p_batch_id              Picking Batch Id which is used to get Batch
--					       information from the wsh_picking_batches table.
--                     p_batch_name            Picking Batch Name which is used to get Batch
--					       information from the wsh_picking_batches table.
--                     x_batch_rec             Batch record from wsh_picking_batches
-- VERSION           : current version         1.0
--                     initial version         1.0
-- End of comments

/*#
 * This procedure is used to get a picking batch record. The procedure takes in a pick release
 * Batch_id/ Batch_name and retrieves the batch record from wsh_picking_batches.
 * @param p_api_version         version number of the API
 * @param p_init_msg_list       messages will be initialized, if set as true
 * @param p_commit              commits the transaction, if set as true
 * @param x_return_status       return status of the API
 * @param x_msg_count           number of messages, if any
 * @param x_msg_data            message text, if any
 * @param p_batch_id            Picking Batch Id used to get the picking batch information.
 * @param p_batch_name          Picking Batch Name used to get the picking batch information
 * @param x_batch_rec           Picking batch record
 * @rep:scope public
 * @rep:lifecycle active
 * @rep:displayname Retrieve Picking Batch Record
 */
 PROCEDURE Get_Batch_Record(
         -- Standard parameters
         p_api_version        IN   NUMBER,
         p_init_msg_list      IN   VARCHAR2  DEFAULT NULL,
         p_commit             IN   VARCHAR2  DEFAULT NULL,
         x_return_status      OUT  NOCOPY    VARCHAR2,
         x_msg_count          OUT  NOCOPY    NUMBER,
         x_msg_data           OUT  NOCOPY    VARCHAR2,
         -- program specific paramters.
         p_batch_id           IN   NUMBER     DEFAULT NULL,
         p_batch_name         IN   VARCHAR2   DEFAULT NULL,
         x_batch_rec          OUT  NOCOPY     WSH_PICKING_BATCHES_PUB.Batch_Info_Rec
        ) ;



END WSH_PICKING_BATCHES_PUB;
/

create or replace PACKAGE BODY WSH_PICKING_BATCHES_PUB AS
/* $Header: WSHPRPBB.pls 115.3 2004/03/03 00:16:21 wrudge noship $ */

--
-- Package Variables
--
--===================
-- CONSTANTS
--===================
--
  G_PKG_NAME CONSTANT VARCHAR2(50) := 'WSH_PICKING_BATCHES_PUB';
-- add your constants here if any
--
--
--===================
-- PROCEDURES
--===================

PROCEDURE Create_Batch (
         -- Standard parameters
         p_api_version        IN   NUMBER,
         p_init_msg_list      IN   VARCHAR2  DEFAULT NULL,
         p_commit             IN   VARCHAR2  DEFAULT NULL,
         x_return_status      OUT NOCOPY     VARCHAR2,
         x_msg_count          OUT NOCOPY     NUMBER,
         x_msg_data           OUT NOCOPY     VARCHAR2,

         -- program specific paramters.
         p_rule_id            IN   NUMBER   DEFAULT NULL,
	 p_rule_name          IN   VARCHAR2 DEFAULT NULL,
         p_batch_rec          IN   WSH_PICKING_BATCHES_PUB.Batch_Info_Rec ,
         p_batch_prefix       IN   VARCHAR2 DEFAULT NULL ,
         x_batch_id           OUT  NOCOPY   NUMBER

 ) IS
BEGIN
	null;
END Create_Batch;

 
PROCEDURE Release_Batch (
         -- Standard parameters
         p_api_version        IN   NUMBER,
         p_init_msg_list      IN   VARCHAR2  DEFAULT  NULL,
         p_commit             IN   VARCHAR2  DEFAULT  NULL,
         x_return_status      OUT  NOCOPY    VARCHAR2,
         x_msg_count          OUT  NOCOPY    NUMBER,
         x_msg_data           OUT  NOCOPY    VARCHAR2,
         -- program specific paramters.
          p_batch_id          IN   NUMBER    DEFAULT NULL,
	  p_batch_name        IN   VARCHAR2    DEFAULT NULL,
          p_log_level         IN   NUMBER    DEFAULT NULL,
	  p_release_mode      IN   VARCHAR2  DEFAULT 'CONCURRENT',
	  x_request_id       OUT  NOCOPY    NUMBER
        )  IS
BEGIN
	null;
END Release_Batch;



 PROCEDURE Get_Batch_Record(
         -- Standard parameters
         p_api_version        IN   NUMBER,
         p_init_msg_list      IN   VARCHAR2  DEFAULT NULL,
         p_commit             IN   VARCHAR2  DEFAULT NULL,
         x_return_status      OUT  NOCOPY    VARCHAR2,
         x_msg_count          OUT  NOCOPY    NUMBER,
         x_msg_data           OUT  NOCOPY    VARCHAR2,
         -- program specific paramters.
         p_batch_id           IN   NUMBER     DEFAULT NULL,
         p_batch_name         IN   VARCHAR2   DEFAULT NULL,
         x_batch_rec          OUT  NOCOPY     WSH_PICKING_BATCHES_PUB.Batch_Info_Rec
        ) IS
	BEGIN
    	null;
	END Get_Batch_Record;

END WSH_PICKING_BATCHES_PUB;
