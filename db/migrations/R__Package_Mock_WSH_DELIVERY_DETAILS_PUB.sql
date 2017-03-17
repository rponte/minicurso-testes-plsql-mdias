create or replace PACKAGE WSH_DELIVERY_DETAILS_PUB AUTHID CURRENT_USER AS

TYPE ID_TAB_TYPE IS table of number INDEX BY BINARY_INTEGER;

PROCEDURE detail_to_delivery(
  -- Standard parameters
  p_api_version        IN   NUMBER,
  p_init_msg_list      IN   VARCHAR2  DEFAULT FND_API.G_FALSE,
  p_commit             IN   VARCHAR2  DEFAULT FND_API.G_FALSE,
  p_validation_level   IN   NUMBER    DEFAULT FND_API.G_VALID_LEVEL_FULL,
  x_return_status      OUT NOCOPY     VARCHAR2,
  x_msg_count          OUT NOCOPY     NUMBER,
  x_msg_data           OUT NOCOPY     VARCHAR2,

  -- program specific parameters
  p_TabOfDelDets    IN    ID_TAB_TYPE,
  p_action      IN    VARCHAR2,
  p_delivery_id   IN    NUMBER DEFAULT FND_API.G_MISS_NUM,
  p_delivery_name IN    VARCHAR2 DEFAULT FND_API.G_MISS_CHAR
);


PROCEDURE split_line(
  -- Standard parameters
  p_api_version   IN    NUMBER,
  p_init_msg_list     IN    VARCHAR2 DEFAULT FND_API.G_FALSE,
  p_commit            IN    VARCHAR2 DEFAULT FND_API.G_FALSE,
  p_validation_level  IN    NUMBER  DEFAULT FND_API.G_VALID_LEVEL_FULL,
  x_return_status OUT NOCOPY    VARCHAR2,
  x_msg_count   OUT NOCOPY    NUMBER,
  x_msg_data    OUT NOCOPY    VARCHAR2,

  -- program specific parameters
  p_from_detail_id  IN    NUMBER,
  x_new_detail_id OUT NOCOPY    NUMBER,
  x_split_quantity  IN  OUT NOCOPY  NUMBER,
  x_split_quantity2 IN  OUT NOCOPY  NUMBER  /* added for OPM */
);


--bug 1747202: default these attributes so they won't be updated.
TYPE ChangedAttributeRecType IS RECORD (
  source_header_id    NUMBER    DEFAULT FND_API.G_MISS_NUM,
  source_line_id      NUMBER    DEFAULT FND_API.G_MISS_NUM,
  sold_to_org_id      NUMBER    DEFAULT FND_API.G_MISS_NUM,
  customer_number           NUMBER    DEFAULT FND_API.G_MISS_NUM,
  sold_to_contact_id    NUMBER    DEFAULT FND_API.G_MISS_NUM,
  ship_from_org_id    NUMBER    DEFAULT FND_API.G_MISS_NUM,
  ship_from_org_code    VARCHAR2(3) DEFAULT FND_API.G_MISS_CHAR,
  ship_to_org_id      NUMBER    DEFAULT FND_API.G_MISS_NUM,
  ship_to_org_code    VARCHAR2(3) DEFAULT FND_API.G_MISS_CHAR,
  ship_to_contact_id    NUMBER    DEFAULT FND_API.G_MISS_NUM,
  deliver_to_org_id   NUMBER    DEFAULT FND_API.G_MISS_NUM,
  deliver_to_org_code   VARCHAR2(3) DEFAULT FND_API.G_MISS_CHAR,
  deliver_to_contact_id   NUMBER    DEFAULT FND_API.G_MISS_NUM,
  intmed_ship_to_org_id   NUMBER    DEFAULT FND_API.G_MISS_NUM,
  intmed_ship_to_org_code   VARCHAR2(3) DEFAULT FND_API.G_MISS_CHAR,
  intmed_ship_to_contact_id NUMBER    DEFAULT FND_API.G_MISS_NUM,
  ship_tolerance_above    NUMBER    DEFAULT FND_API.G_MISS_NUM,
  ship_tolerance_below    NUMBER    DEFAULT FND_API.G_MISS_NUM,
  ordered_quantity    NUMBER    DEFAULT FND_API.G_MISS_NUM,
  ordered_quantity2   NUMBER    DEFAULT FND_API.G_MISS_NUM, /* added for OPM*/
  order_quantity_uom    VARCHAR2(3) DEFAULT FND_API.G_MISS_CHAR,
  ordered_quantity_uom2   VARCHAR2(3) DEFAULT FND_API.G_MISS_CHAR, /* added for OPM*/
        preferred_grade     VARCHAR2(4) DEFAULT FND_API.G_MISS_CHAR, /* added for OPM */
  ordered_qty_unit_of_measure   VARCHAR2(25)  DEFAULT FND_API.G_MISS_CHAR,
  ordered_qty_unit_of_measure2  VARCHAR2(25)  DEFAULT FND_API.G_MISS_CHAR, /* added for OPM*/
  subinventory      VARCHAR2(10)  DEFAULT FND_API.G_MISS_CHAR,
  revision      VARCHAR2(3) DEFAULT FND_API.G_MISS_CHAR,
  lot_number      VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  sublot_number     VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  customer_requested_lot_flag VARCHAR2(1) DEFAULT FND_API.G_MISS_CHAR,
  serial_number     VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  locator_id      NUMBER    DEFAULT FND_API.G_MISS_NUM,
  date_requested      DATE    DEFAULT FND_API.G_MISS_DATE,
  date_scheduled      DATE    DEFAULT FND_API.G_MISS_DATE,
  master_container_item_id  NUMBER    DEFAULT FND_API.G_MISS_NUM,
  detail_container_item_id  NUMBER    DEFAULT FND_API.G_MISS_NUM,
  shipping_method_code    VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  carrier_id      NUMBER    DEFAULT FND_API.G_MISS_NUM,
  freight_terms_code    VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  freight_terms_name    VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  freight_carrier_code    VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  shipment_priority_code    VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  fob_code      VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  fob_name      VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  dep_plan_required_flag    VARCHAR2(1) DEFAULT FND_API.G_MISS_CHAR,
  customer_prod_seq   VARCHAR2(50)  DEFAULT FND_API.G_MISS_CHAR,
  customer_dock_code    VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  gross_weight      NUMBER    DEFAULT FND_API.G_MISS_NUM,
  net_weight      NUMBER    DEFAULT FND_API.G_MISS_NUM,
  weight_uom_code     VARCHAR2(3) DEFAULT FND_API.G_MISS_CHAR,
  weight_uom_desc     VARCHAR2(50)  DEFAULT FND_API.G_MISS_CHAR,
  volume        NUMBER    DEFAULT FND_API.G_MISS_NUM,
  volume_uom_code     VARCHAR2(3) DEFAULT FND_API.G_MISS_CHAR,
  volume_uom_desc     VARCHAR2(50)  DEFAULT FND_API.G_MISS_CHAR,
  top_model_line_id   NUMBER    DEFAULT FND_API.G_MISS_NUM,
  ship_set_id     NUMBER    DEFAULT FND_API.G_MISS_NUM,
  ato_line_id     NUMBER    DEFAULT FND_API.G_MISS_NUM,
  arrival_set_id      NUMBER    DEFAULT FND_API.G_MISS_NUM,
  ship_model_complete_flag  VARCHAR2(1) DEFAULT FND_API.G_MISS_CHAR,
  cust_po_number      VARCHAR2(50)  DEFAULT FND_API.G_MISS_CHAR,
  released_status     VARCHAR2(1) DEFAULT FND_API.G_MISS_CHAR,
  packing_instructions    VARCHAR2(2000)  DEFAULT FND_API.G_MISS_CHAR,
  shipping_instructions   VARCHAR2(2000)  DEFAULT FND_API.G_MISS_CHAR,
  container_name      VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  container_flag      VARCHAR2(1) DEFAULT FND_API.G_MISS_CHAR,
  delivery_detail_id    NUMBER    DEFAULT FND_API.G_MISS_NUM,
  shipped_quantity                NUMBER    DEFAULT FND_API.G_MISS_NUM,
  cycle_count_quantity            NUMBER    DEFAULT FND_API.G_MISS_NUM,
  shipped_quantity2               NUMBER          DEFAULT FND_API.G_MISS_NUM, /* Bug 3055126  */
  cycle_count_quantity2           NUMBER          DEFAULT FND_API.G_MISS_NUM, /* Bug 3055126  */
  tracking_number                 VARCHAR2(30)  DEFAULT FND_API.G_MISS_CHAR,
  attribute_category              VARCHAR2(150)   DEFAULT FND_API.G_MISS_CHAR, /* Bug 3105907 */
  attribute1      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute2      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute3      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute4      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute5      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute6      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute7      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute8      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute9      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute10     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute11     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute12     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute13     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute14     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  attribute15     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  to_serial_number                VARCHAR2(30)    DEFAULT FND_API.G_MISS_CHAR,
  -- Bug 3723831 :tp attributes also part of the public API update_shipping_attributes
  tp_attribute_category              VARCHAR2(150)   DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute1      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute2      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute3      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute4      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute5      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute6      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute7      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute8      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute9      VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute10     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute11     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute12     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute13     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute14     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  tp_attribute15     VARCHAR2(150) DEFAULT FND_API.G_MISS_CHAR,
  -- J: W/V Changes
  filled_volume NUMBER    DEFAULT FND_API.G_MISS_NUM
  );

TYPE ChangedAttributeTabType IS TABLE OF ChangedAttributeRecType
  INDEX BY BINARY_INTEGER;


PROCEDURE Update_Shipping_Attributes (
  p_api_version_number     IN     NUMBER
, p_init_msg_list          IN     VARCHAR2
, p_commit                 IN     VARCHAR2
, x_return_status             OUT NOCOPY  VARCHAR2
, x_msg_count                 OUT NOCOPY  NUMBER
, x_msg_data                  OUT NOCOPY  VARCHAR2
, p_changed_attributes    IN     WSH_DELIVERY_DETAILS_PUB.ChangedAttributeTabType
, p_source_code            IN     VARCHAR2
, p_container_flag         IN     VARCHAR2 DEFAULT NULL
);

PROCEDURE Update_Shipping_Attributes (
  p_api_version_number     IN     NUMBER
, p_init_msg_list          IN     VARCHAR2
, p_commit                 IN     VARCHAR2
, x_return_status             OUT NOCOPY  VARCHAR2
, x_msg_count                 OUT NOCOPY  NUMBER
, x_msg_data                  OUT NOCOPY  VARCHAR2
, p_changed_attributes    IN     WSH_DELIVERY_DETAILS_PUB.ChangedAttributeTabType
, p_source_code            IN     VARCHAR2
, p_container_flag         IN     VARCHAR2 DEFAULT NULL
, p_serial_range_tab       IN     WSH_DELIVERY_DETAILS_GRP.serialRangeTabType
);


END WSH_DELIVERY_DETAILS_PUB;
/


create or replace PACKAGE BODY WSH_DELIVERY_DETAILS_PUB AS

	PROCEDURE detail_to_delivery(
	  -- Standard parameters
	  p_api_version        IN   NUMBER,
	  p_init_msg_list      IN   VARCHAR2  DEFAULT FND_API.G_FALSE,
	  p_commit             IN   VARCHAR2  DEFAULT FND_API.G_FALSE,
	  p_validation_level   IN   NUMBER    DEFAULT FND_API.G_VALID_LEVEL_FULL,
	  x_return_status      OUT NOCOPY     VARCHAR2,
	  x_msg_count          OUT NOCOPY     NUMBER,
	  x_msg_data           OUT NOCOPY     VARCHAR2,
	
	  -- program specific parameters
	  p_TabOfDelDets    IN    ID_TAB_TYPE,
	  p_action      IN    VARCHAR2,
	  p_delivery_id   IN    NUMBER DEFAULT FND_API.G_MISS_NUM,
	  p_delivery_name IN    VARCHAR2 DEFAULT FND_API.G_MISS_CHAR
	) is
	begin
		null;
	end;
	
	PROCEDURE split_line(
	  -- Standard parameters
	  p_api_version   IN    NUMBER,
	  p_init_msg_list     IN    VARCHAR2 DEFAULT FND_API.G_FALSE,
	  p_commit            IN    VARCHAR2 DEFAULT FND_API.G_FALSE,
	  p_validation_level  IN    NUMBER  DEFAULT FND_API.G_VALID_LEVEL_FULL,
	  x_return_status OUT NOCOPY    VARCHAR2,
	  x_msg_count   OUT NOCOPY    NUMBER,
	  x_msg_data    OUT NOCOPY    VARCHAR2,
	
	  -- program specific parameters
	  p_from_detail_id  IN    NUMBER,
	  x_new_detail_id OUT NOCOPY    NUMBER,
	  x_split_quantity  IN  OUT NOCOPY  NUMBER,
	  x_split_quantity2 IN  OUT NOCOPY  NUMBER  /* added for OPM */
	) is
	begin
		null;
	end;
	
	PROCEDURE Update_Shipping_Attributes (
	  p_api_version_number     IN     NUMBER
	, p_init_msg_list          IN     VARCHAR2
	, p_commit                 IN     VARCHAR2
	, x_return_status             OUT NOCOPY  VARCHAR2
	, x_msg_count                 OUT NOCOPY  NUMBER
	, x_msg_data                  OUT NOCOPY  VARCHAR2
	, p_changed_attributes    IN     WSH_DELIVERY_DETAILS_PUB.ChangedAttributeTabType
	, p_source_code            IN     VARCHAR2
	, p_container_flag         IN     VARCHAR2 DEFAULT NULL
	) is
	begin
		null;
	end;
	
	PROCEDURE Update_Shipping_Attributes (
	  p_api_version_number     IN     NUMBER
	, p_init_msg_list          IN     VARCHAR2
	, p_commit                 IN     VARCHAR2
	, x_return_status             OUT NOCOPY  VARCHAR2
	, x_msg_count                 OUT NOCOPY  NUMBER
	, x_msg_data                  OUT NOCOPY  VARCHAR2
	, p_changed_attributes    IN     WSH_DELIVERY_DETAILS_PUB.ChangedAttributeTabType
	, p_source_code            IN     VARCHAR2
	, p_container_flag         IN     VARCHAR2 DEFAULT NULL
	, p_serial_range_tab       IN     WSH_DELIVERY_DETAILS_GRP.serialRangeTabType
	) is
	begin
		null;
	end;

END WSH_DELIVERY_DETAILS_PUB;
/