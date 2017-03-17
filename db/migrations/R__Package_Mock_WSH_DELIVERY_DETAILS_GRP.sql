create or replace PACKAGE WSH_DELIVERY_DETAILS_GRP AUTHID CURRENT_USER AS

	TYPE serialRangeRecType IS RECORD
    (
      delivery_detail_id NUMBER,
      from_serial_number VARCHAR2(30),
      to_serial_number   VARCHAR2(30),
      quantity           NUMBER,
      attribute_category VARCHAR2(30),
      attribute1         VARCHAR2(150),
      attribute2         VARCHAR2(150),
      attribute3         VARCHAR2(150),
      attribute4         VARCHAR2(150),
      attribute5         VARCHAR2(150),
      attribute6         VARCHAR2(150),
      attribute7         VARCHAR2(150),
      attribute8         VARCHAR2(150),
      attribute9         VARCHAR2(150),
      attribute10        VARCHAR2(150),
      attribute11        VARCHAR2(150),
      attribute12        VARCHAR2(150),
      attribute13        VARCHAR2(150),
      attribute14        VARCHAR2(150),
      attribute15        VARCHAR2(150)
    );

	TYPE serialRangeTabType IS TABLE OF serialRangeRecType
        INDEX BY BINARY_INTEGER;

END WSH_DELIVERY_DETAILS_GRP;
/