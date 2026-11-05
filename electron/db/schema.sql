-- =====================================================
-- CATEGORIES (matches Android CategoryEntity)
-- =====================================================

CREATE TABLE IF NOT EXISTS categories (
  id TEXT PRIMARY KEY,

  name TEXT NOT NULL,
  desc TEXT NOT NULL,
  image TEXT,

  taxRate REAL,
  taxType TEXT,

   taxRate1 REAL,
  taxType1 TEXT,

  sortOrder INTEGER NOT NULL DEFAULT 0,
  slug TEXT,
  isFeatured INTEGER NOT NULL DEFAULT 0,
  kitchenPrintReq INTEGER,
  updatedAt INTEGER,
  isDeleted INTEGER NOT NULL DEFAULT 0,
  outletId TEXT
);

CREATE INDEX IF NOT EXISTS idx_categories_name
ON categories(name);

-- =====================================================
-- PRODUCTS (matches Android ProductEntity)
-- =====================================================

CREATE TABLE IF NOT EXISTS products (
  id TEXT PRIMARY KEY,

  searchCode TEXT,

  name TEXT NOT NULL,
  price REAL NOT NULL,
  discountPrice REAL,
  image TEXT,

  foodType TEXT,
  taxCategory TEXT NOT NULL DEFAULT 'FOOD_GST',

  sortOrder INTEGER NOT NULL DEFAULT 0,
  kitchenPrintReq INTEGER,

  categoryId TEXT NOT NULL,
  productCat TEXT NOT NULL,

  parentId TEXT,
  baseProductId TEXT,
  discountEligible INTEGER NOT NULL DEFAULT 1,
  hasVariants INTEGER NOT NULL DEFAULT 0,
  hasModifiers INTEGER NOT NULL DEFAULT 0,

  currentStock REAL,

  productMode TEXT DEFAULT 'raw_stock',

  taxRate REAL,
  taxType TEXT,

   taxRate1 REAL,
  taxType1 TEXT,

  type TEXT,

  outletId TEXT,
  favorite INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_products_name
ON products(name);

CREATE INDEX IF NOT EXISTS idx_products_category
ON products(categoryId);

CREATE INDEX IF NOT EXISTS idx_products_searchCode
ON products(searchCode);

CREATE INDEX IF NOT EXISTS idx_products_sort
ON products(sortOrder, name);

CREATE INDEX IF NOT EXISTS idx_products_foodType
ON products(foodType);

-- =====================================================
-- CART ITEMS
-- =====================================================



 

CREATE TABLE IF NOT EXISTS pos_cart_item (
  id INTEGER PRIMARY KEY AUTOINCREMENT,

  productId TEXT NOT NULL,
  productMode TEXT NOT NULL,
  currentStock REAL NOT NULL DEFAULT 0,

  name TEXT NOT NULL,
  categoryId TEXT NOT NULL,
  categoryName TEXT NOT NULL,
 taxCategory TEXT NOT NULL DEFAULT 'FOOD_GST',
  parentId TEXT,
  isVariant INTEGER NOT NULL,

  basePrice REAL NOT NULL,
  finalPrice REAL NOT NULL DEFAULT 0,
  discountEligible INTEGER NOT NULL DEFAULT 1,
  modifierTotal REAL NOT NULL DEFAULT 0,

  quantity INTEGER NOT NULL,

  taxRate REAL NOT NULL DEFAULT 0,
  taxType TEXT NOT NULL DEFAULT 'exclusive',

   taxRate1 REAL,
  taxType1 TEXT,

  sessionId TEXT NOT NULL,

  tableId TEXT,
  tableName TEXT,

  createdById TEXT NOT NULL DEFAULT '',
  createdByName TEXT NOT NULL DEFAULT '',

  note TEXT NOT NULL DEFAULT '',
  modifiersJson TEXT NOT NULL DEFAULT '',

  sentToKitchen INTEGER NOT NULL DEFAULT 0,
  kitchenPrintReq INTEGER NOT NULL DEFAULT 0,
  printStatus TEXT NOT NULL DEFAULT 'PENDING',

  createdAt INTEGER NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_cart_unique
ON pos_cart_item(productId, tableId, note, modifiersJson);


-- =====================================================
-- MODIFIER GROUPS (matches Android ModifierGroupEntity)
-- =====================================================

CREATE TABLE IF NOT EXISTS modifier_groups (
  id TEXT PRIMARY KEY,

  name TEXT NOT NULL,

  minSelection INTEGER NOT NULL,
  maxSelection INTEGER NOT NULL,

  sortOrder INTEGER NOT NULL DEFAULT 0,

  status TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_modifier_groups_sort
ON modifier_groups(sortOrder, name);


-- =====================================================
-- MODIFIER ITEMS (matches Android ModifierItemEntity)
-- =====================================================

CREATE TABLE IF NOT EXISTS modifier_items (
  id TEXT PRIMARY KEY,

  name TEXT NOT NULL,

  groupId TEXT NOT NULL,

  price REAL NOT NULL,

  isDefault INTEGER NOT NULL DEFAULT 0,

  sortOrder INTEGER NOT NULL DEFAULT 0,

  status TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_modifier_items_group
ON modifier_items(groupId);

CREATE INDEX IF NOT EXISTS idx_modifier_items_sort
ON modifier_items(groupId, sortOrder, name);

-- =====================================================
-- PRODUCT MODIFIERS (matches Android ProductModifierEntity)
-- =====================================================

CREATE TABLE IF NOT EXISTS product_modifiers (
  id TEXT PRIMARY KEY,

  productId TEXT NOT NULL,

  groupId TEXT NOT NULL,

  sortOrder INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_product_modifiers_product
ON product_modifiers(productId);

CREATE INDEX IF NOT EXISTS idx_product_modifiers_group
ON product_modifiers(groupId);

CREATE INDEX IF NOT EXISTS idx_product_modifiers_sort
ON product_modifiers(productId, sortOrder);




CREATE TABLE IF NOT EXISTS pos_kot_items (
  id TEXT PRIMARY KEY,
  kotNumber TEXT NOT NULL,
  categoryName TEXT NOT NULL,
   taxCategory TEXT NOT NULL DEFAULT 'FOOD_GST',
  productMode TEXT NOT NULL,
  currentStock REAL DEFAULT 0,

  sessionId TEXT,
  kotBatchId TEXT NOT NULL,

  tableNo TEXT,
  tableName TEXT,

  productId TEXT NOT NULL,
  name TEXT NOT NULL,
  categoryId TEXT NOT NULL,

  createdById TEXT DEFAULT '',
  createdByName TEXT DEFAULT '',

  parentId TEXT,
  isVariant INTEGER NOT NULL DEFAULT 0,
discountEligible INTEGER NOT NULL DEFAULT 1,
  basePrice REAL NOT NULL,
  finalPrice REAL NOT NULL DEFAULT 0,
  modifierTotal REAL NOT NULL DEFAULT 0,
  quantity INTEGER NOT NULL,

  taxRate REAL NOT NULL DEFAULT 0,
  taxType TEXT NOT NULL DEFAULT 'exclusive',

   taxRate1 REAL,
  taxType1 TEXT,

  status TEXT NOT NULL DEFAULT 'PENDING',
  note TEXT DEFAULT '',
  modifiersJson TEXT DEFAULT '',

  kitchenPrintReq INTEGER NOT NULL DEFAULT 1,
  kitchenPrinted INTEGER NOT NULL DEFAULT 0,
  createdAt INTEGER NOT NULL,

  source TEXT NOT NULL DEFAULT 'POS',

  syncedToCloud INTEGER NOT NULL DEFAULT 0,
  syncedFromCloud INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_kot_batch
ON pos_kot_items(kotBatchId);

CREATE INDEX IF NOT EXISTS idx_kot_session
ON pos_kot_items(sessionId);

CREATE INDEX IF NOT EXISTS idx_kot_table
ON pos_kot_items(tableNo);

CREATE INDEX IF NOT EXISTS idx_kot_product
ON pos_kot_items(productId);

CREATE INDEX IF NOT EXISTS idx_kot_synced
ON pos_kot_items(syncedToCloud);

CREATE INDEX IF NOT EXISTS idx_kot_source
ON pos_kot_items(source);





CREATE TABLE IF NOT EXISTS pos_kot_batch (
  id TEXT PRIMARY KEY,

  kotNumber TEXT NOT NULL UNIQUE,

  sessionId TEXT,

  tableNo TEXT,
  tableName TEXT,

  orderType TEXT NOT NULL DEFAULT 'DINE_IN',

  deviceId TEXT,
  deviceName TEXT,
  appVersion TEXT,

  createdAt INTEGER NOT NULL,

  sentBy TEXT,

  syncStatus TEXT NOT NULL DEFAULT 'PENDING',
  lastSyncedAt INTEGER
);

CREATE INDEX IF NOT EXISTS idx_kot_batch_table
ON pos_kot_batch(tableNo);

CREATE INDEX IF NOT EXISTS idx_kot_batch_created
ON pos_kot_batch(createdAt);

CREATE INDEX IF NOT EXISTS idx_kot_batch_sync
ON pos_kot_batch(syncStatus);

CREATE INDEX IF NOT EXISTS idx_kot_batch_session
ON pos_kot_batch(sessionId);


CREATE TABLE IF NOT EXISTS pos_kot_sequence (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  nextNumber INTEGER NOT NULL DEFAULT 1
);

INSERT OR IGNORE INTO pos_kot_sequence (
  id,
  nextNumber
)
VALUES (
  1,
  1
);
-- =====================================================
-- KOT HISTORY
--  
-- =====================================================



CREATE TABLE IF NOT EXISTS pos_kot_history (

  id TEXT PRIMARY KEY,

  -- =================================================
  -- ORIGINAL KOT
  -- =================================================

  kotBatchId TEXT NOT NULL,
  kotNumber TEXT NOT NULL,

  -- =================================================
  -- TABLE
  -- =================================================

  tableNo TEXT NOT NULL,
  tableName TEXT,

  orderType TEXT NOT NULL,

  -- =================================================
  -- BILL / ORDER LINK
  -- =================================================

  orderId TEXT,
  billNo TEXT,

  -- =================================================
  -- STATUS
  -- =================================================

  status TEXT NOT NULL DEFAULT 'COMPLETED',

  -- =================================================
  -- BUSINESS DATE
  -- =================================================

  businessDate TEXT NOT NULL,

  -- =================================================
  -- TIME
  -- =================================================

  createdAt INTEGER NOT NULL,
  completedAt INTEGER,

  -- =================================================
  -- DELETE / VOID
  -- =================================================

  deletedAt INTEGER,
  deletedById TEXT,
  deletedByName TEXT,

  -- =================================================
  -- DEVICE
  -- =================================================

  deviceId TEXT NOT NULL,
  deviceName TEXT,
  appVersion TEXT,

  -- =================================================
  -- USER
  -- =================================================

  sentBy TEXT,

  -- =================================================
  -- SYNC
  -- =================================================

  syncStatus TEXT NOT NULL DEFAULT 'PENDING',
  lastSyncedAt INTEGER
);


-- =====================================================
-- INDEXES
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_kot_history_batch
ON pos_kot_history(kotBatchId);


CREATE INDEX IF NOT EXISTS idx_kot_history_number
ON pos_kot_history(kotNumber);


CREATE INDEX IF NOT EXISTS idx_kot_history_table
ON pos_kot_history(tableNo);


CREATE INDEX IF NOT EXISTS idx_kot_history_date
ON pos_kot_history(businessDate);


CREATE INDEX IF NOT EXISTS idx_kot_history_status
ON pos_kot_history(status);


CREATE INDEX IF NOT EXISTS idx_kot_history_order
ON pos_kot_history(orderId);


CREATE INDEX IF NOT EXISTS idx_kot_history_bill
ON pos_kot_history(billNo);



CREATE TABLE IF NOT EXISTS pos_kot_history_items (

  id TEXT PRIMARY KEY,
kotBatchId TEXT NOT NULL,
  kotHistoryId TEXT NOT NULL,

  kotNumber TEXT NOT NULL,

  tableNo TEXT NOT NULL,

  productId TEXT NOT NULL,

  name TEXT NOT NULL,

  categoryId TEXT,

  categoryName TEXT,

  parentId TEXT,

  isVariant INTEGER NOT NULL DEFAULT 0,

  productMode TEXT,

  basePrice REAL NOT NULL DEFAULT 0,

  quantity REAL NOT NULL DEFAULT 0,

  modifierPrice REAL NOT NULL DEFAULT 0,

  modifierSummary TEXT,

  modifiersJson TEXT,

  note TEXT,

  taxRate REAL NOT NULL DEFAULT 0,
  taxType TEXT,

  taxRate1 REAL,
  taxType1 TEXT,

  taxAmountPerItem REAL NOT NULL DEFAULT 0,

  taxTotal REAL NOT NULL DEFAULT 0,

  finalPricePerItem REAL NOT NULL DEFAULT 0,

  finalTotal REAL NOT NULL DEFAULT 0,

  status TEXT NOT NULL,

  source TEXT NOT NULL,

  createdAt INTEGER NOT NULL,

  deletedAt INTEGER,

  syncStatus TEXT NOT NULL DEFAULT 'PENDING',

  lastSyncedAt INTEGER,

  FOREIGN KEY (kotHistoryId)
    REFERENCES pos_kot_history(id)
    ON DELETE CASCADE
);



CREATE INDEX IF NOT EXISTS idx_pos_kot_history_items_historyId
ON pos_kot_history_items(kotHistoryId);

CREATE INDEX IF NOT EXISTS idx_pos_kot_history_items_kotNumber
ON pos_kot_history_items(kotNumber);

CREATE INDEX IF NOT EXISTS idx_pos_kot_history_items_tableNo
ON pos_kot_history_items(tableNo);

CREATE INDEX IF NOT EXISTS idx_pos_kot_history_items_status
ON pos_kot_history_items(status);

CREATE INDEX IF NOT EXISTS idx_pos_kot_history_items_productId
ON pos_kot_history_items(productId);

-- =====================================================
-- POS BILL
--  
-- =====================================================

CREATE TABLE IF NOT EXISTS pos_bill_items (
  id TEXT PRIMARY KEY,

  -- Linking
  billItemGroupKey TEXT,
  sessionId TEXT,
  tableNo TEXT,
  tableName TEXT,
 taxCategory TEXT NOT NULL DEFAULT 'FOOD_GST',
  -- Product
  productId TEXT NOT NULL,
  name TEXT NOT NULL,
  categoryId TEXT NOT NULL,
  categoryName TEXT NOT NULL,

  -- Variant
  parentId TEXT,
  isVariant INTEGER NOT NULL DEFAULT 0,

  -- Pricing
  basePrice REAL NOT NULL,
  finalPrice REAL NOT NULL DEFAULT 0,
  discountEligible INTEGER NOT NULL DEFAULT 1,
  modifierTotal REAL NOT NULL DEFAULT 0,
  quantity INTEGER NOT NULL,

  -- Tax
  taxRate REAL NOT NULL DEFAULT 0,
  taxType TEXT NOT NULL DEFAULT 'exclusive',

   taxRate1 REAL,
  taxType1 TEXT,
  -- Notes / modifiers
  note TEXT DEFAULT '',
  modifiersJson TEXT DEFAULT '',

  -- Billing status
  status TEXT NOT NULL DEFAULT 'OPEN',
  billed INTEGER NOT NULL DEFAULT 0,
  billNo TEXT DEFAULT '',
  billId TEXT DEFAULT '',

  createdAt INTEGER NOT NULL,

  -- Source
  source TEXT NOT NULL DEFAULT 'POS',

  syncedToCloud INTEGER NOT NULL DEFAULT 0,
  syncedFromCloud INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_bill_items_table
ON pos_bill_items(tableNo);

CREATE INDEX IF NOT EXISTS idx_bill_items_status
ON pos_bill_items(status);

CREATE INDEX IF NOT EXISTS idx_bill_items_billed
ON pos_bill_items(billed);
-- =====================================================
-- POS ORDER MASTER
-- Matches Android PosOrderMasterEntity
-- =====================================================

CREATE TABLE IF NOT EXISTS pos_order_master (

  -- =====================================================
  -- CORE IDENTIFIERS
  -- =====================================================

  id TEXT PRIMARY KEY,

  srno TEXT NOT NULL,

  orderType TEXT NOT NULL,

  tableNo TEXT,

  tableName TEXT,

  saleType TEXT DEFAULT '',

  reason TEXT DEFAULT '',


  -- =====================================================
  -- CUSTOMER SNAPSHOT
  -- =====================================================

  customerName TEXT,

  customerPhone TEXT,

  customerId TEXT,


  -- =====================================================
  -- USER SNAPSHOT
  -- =====================================================

  createdById TEXT DEFAULT '',

  createdByName TEXT DEFAULT '',

  finalizedById TEXT DEFAULT '',

  finalizedByName TEXT DEFAULT '',


  -- =====================================================
  -- DELIVERY ADDRESS SNAPSHOT
  -- =====================================================

  dAddressLine1 TEXT,

  dAddressLine2 TEXT,

  dCity TEXT,

  dState TEXT,

  dZipcode TEXT,

  dLandmark TEXT,


  -- =====================================================
  -- AMOUNTS
  -- =====================================================

  deliveryFee REAL NOT NULL DEFAULT 0,

  deliveryTax REAL NOT NULL DEFAULT 0,

  itemTotal REAL NOT NULL DEFAULT 0,

  itemTax REAL NOT NULL DEFAULT 0,
  itemTax1 REAL NOT NULL DEFAULT 0,

  taxTotal REAL NOT NULL DEFAULT 0,

  -- =====================================================
-- TAX DETAILS
-- =====================================================

-- taxAmount REAL NOT NULL DEFAULT 0,

-- taxAmount1 REAL NOT NULL DEFAULT 0,

taxCategory TEXT NOT NULL DEFAULT 'FOOD_GST',

  discountTotal REAL NOT NULL DEFAULT 0,

  grandTotal REAL NOT NULL DEFAULT 0,


  -- =====================================================
  -- PAYMENT
  -- =====================================================

  paymentMode TEXT NOT NULL,

  paymentStatus TEXT NOT NULL,

  paidAmount REAL NOT NULL DEFAULT 0,

  dueAmount REAL NOT NULL DEFAULT 0,


  -- =====================================================
  -- ORDER STATE
  -- =====================================================

  orderStatus TEXT NOT NULL,


  -- =====================================================
  -- SOURCE & DEVICE META
  -- =====================================================

  source TEXT NOT NULL DEFAULT 'POS',

  deviceId TEXT NOT NULL,

  deviceName TEXT,

  appVersion TEXT,


  -- =====================================================
  -- TIMING
  -- =====================================================

  businessDate TEXT NOT NULL,
  realDate TEXT NOT NULL,

  createdAt INTEGER NOT NULL,

  updatedAt INTEGER,


  -- =====================================================
  -- SYNC CONTROL
  -- =====================================================

  syncStatus TEXT NOT NULL,

  lastSyncedAt INTEGER,

  -- =====================================================
-- BILL SUMMARY
-- =====================================================

   gstBillCount INTEGER NOT NULL DEFAULT 0,
   vatBillCount INTEGER NOT NULL DEFAULT 0,
  -- =====================================================
  -- EXTRA
  -- =====================================================

  notes TEXT
);


-- =====================================================
-- INDEXES
-- =====================================================

-- Sync queue
CREATE INDEX IF NOT EXISTS idx_pos_order_master_syncStatus
ON pos_order_master(syncStatus);


-- General chronological lookup
CREATE INDEX IF NOT EXISTS idx_pos_order_master_createdAt
ON pos_order_master(createdAt);


-- Order type filtering
CREATE INDEX IF NOT EXISTS idx_pos_order_master_orderType
ON pos_order_master(orderType);


-- Date search
CREATE INDEX IF NOT EXISTS idx_pos_order_master_businessDate
ON pos_order_master(businessDate);


-- Table lookup
CREATE INDEX IF NOT EXISTS idx_pos_order_master_tableNo
ON pos_order_master(tableNo);


-- Bill/order number lookup
CREATE INDEX IF NOT EXISTS idx_pos_order_master_srno
ON pos_order_master(srno);


-- =====================================================
-- IMPORTANT FOR ORDERS SCREEN
-- =====================================================
-- Used by:
--
-- WHERE businessDate = ?
-- ORDER BY createdAt DESC
--
CREATE INDEX IF NOT EXISTS idx_pos_order_master_date_created
ON pos_order_master(
  businessDate,
  createdAt DESC
);




 
-- =====================================================
-- POS ORDER ITEMS
-- Matches Android PosOrderItemEntity
-- =====================================================

CREATE TABLE IF NOT EXISTS pos_order_items (

  id TEXT PRIMARY KEY,

  categoryName TEXT NOT NULL,
  taxCategory TEXT NOT NULL DEFAULT 'FOOD_GST',
  productMode TEXT NOT NULL,
  currentStock REAL NOT NULL DEFAULT 0,

  orderMasterId TEXT NOT NULL,
  productId TEXT NOT NULL,

  createdById TEXT NOT NULL DEFAULT '',
  createdByName TEXT NOT NULL DEFAULT '',

  name TEXT NOT NULL,
  categoryId TEXT NOT NULL,

  parentId TEXT,
  isVariant INTEGER NOT NULL DEFAULT 0,

  basePrice REAL NOT NULL,
  quantity INTEGER NOT NULL,
  itemSubtotal REAL NOT NULL DEFAULT 0,

  currency TEXT,
  status TEXT,

  taxRate REAL NOT NULL DEFAULT 0,
  taxType TEXT NOT NULL DEFAULT 'exclusive',

  taxRate1 REAL,
  taxType1 TEXT,

  taxAmountPerItem REAL NOT NULL DEFAULT 0,
  taxTotal REAL NOT NULL DEFAULT 0,

  note TEXT NOT NULL DEFAULT '',
  modifiersJson TEXT NOT NULL DEFAULT '',
  modifierPrice REAL NOT NULL DEFAULT 0,
  modifierSummary TEXT NOT NULL DEFAULT '',

  finalPricePerItem REAL NOT NULL DEFAULT 0,
  finalTotal REAL NOT NULL DEFAULT 0,

  source TEXT NOT NULL DEFAULT 'POS',

  createdAt INTEGER NOT NULL
);

-- Order lookup
CREATE INDEX IF NOT EXISTS idx_pos_order_items_orderMasterId
ON pos_order_items(orderMasterId);

-- Order + GST/VAT filtering
CREATE INDEX IF NOT EXISTS idx_pos_order_items_order_taxCategory
ON pos_order_items(orderMasterId, taxCategory);

-- Product reports
CREATE INDEX IF NOT EXISTS idx_pos_order_items_productId
ON pos_order_items(productId);

-- Parent/variant lookup
CREATE INDEX IF NOT EXISTS idx_pos_order_items_parentId
ON pos_order_items(parentId);

-- Category reports
CREATE INDEX IF NOT EXISTS idx_pos_order_items_categoryId
ON pos_order_items(categoryId);

-- Category name lookup
CREATE INDEX IF NOT EXISTS idx_pos_order_items_categoryName
ON pos_order_items(categoryName);

-- Status filtering
CREATE INDEX IF NOT EXISTS idx_pos_order_items_status
ON pos_order_items(status);

-- Status + chronological reports
CREATE INDEX IF NOT EXISTS idx_pos_order_items_status_createdAt
ON pos_order_items(status, createdAt);

-- Chronological lookup
CREATE INDEX IF NOT EXISTS idx_pos_order_items_createdAt
ON pos_order_items(createdAt);

-- =====================================================
-- POS ORDER PAYMENTS
-- Matches Android PosOrderPaymentEntity
-- =====================================================

CREATE TABLE IF NOT EXISTS pos_order_payments (

  id TEXT PRIMARY KEY,

  orderId TEXT NOT NULL,

  ownerId TEXT NOT NULL,
  outletId TEXT NOT NULL,

   taxCategory TEXT NOT NULL,

  amount REAL NOT NULL,

  mode TEXT NOT NULL,

  provider TEXT,
  method TEXT,

  status TEXT NOT NULL,

  deviceId TEXT NOT NULL,

  createdAt INTEGER NOT NULL,

  businessDate TEXT NOT NULL,

  syncStatus TEXT NOT NULL DEFAULT 'PENDING',

  lastSyncedAt INTEGER,

  isVoided INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_pos_order_payments_orderId
ON pos_order_payments(orderId);

CREATE INDEX IF NOT EXISTS idx_pos_order_payments_syncStatus
ON pos_order_payments(syncStatus);
 






    

-- =====================================================
-- TABLES
-- =====================================================

CREATE TABLE IF NOT EXISTS tables (
  id TEXT PRIMARY KEY,

  tableName TEXT NOT NULL,

  status TEXT NOT NULL DEFAULT 'AVAILABLE',

  waiterName TEXT,
  waiterId TEXT,

  activeOrderId TEXT,

  guestsCount INTEGER,

  area TEXT DEFAULT 'General',

  sortOrder INTEGER DEFAULT 0,

  cartCount INTEGER DEFAULT 0,
  kitchenCount INTEGER DEFAULT 0,
  billCount INTEGER DEFAULT 0,
  billAmount REAL DEFAULT 0,

  updatedAt INTEGER,
  createdAt INTEGER,

  notes TEXT,

  synced INTEGER DEFAULT 1
);

CREATE INDEX IF NOT EXISTS idx_tables_area
ON tables(area);

CREATE INDEX IF NOT EXISTS idx_tables_sort
ON tables(sortOrder);

CREATE INDEX IF NOT EXISTS idx_tables_status
ON tables(status);
 
 -- =====================================================
-- POS USERS
-- =====================================================

CREATE TABLE IF NOT EXISTS pos_users (
  userId TEXT PRIMARY KEY,

  outletId TEXT DEFAULT '',

  fullName TEXT NOT NULL,

  username TEXT DEFAULT '',

  mobile TEXT DEFAULT '',

  employeeId TEXT DEFAULT '',

  role TEXT NOT NULL,

  loginPin TEXT NOT NULL,

  allowPosLogin INTEGER NOT NULL DEFAULT 1,

  isActive INTEGER NOT NULL DEFAULT 1,

  createdAt INTEGER NOT NULL,

  updatedAt INTEGER NOT NULL,

  syncStatus TEXT NOT NULL DEFAULT 'PENDING',

  lastSyncedAt INTEGER
);

CREATE INDEX IF NOT EXISTS idx_pos_users_active
  ON pos_users(isActive);

CREATE INDEX IF NOT EXISTS idx_pos_users_role
  ON pos_users(role);



-- =====================================================
-- OUTLET (SINGLE ROW)
-- =====================================================

CREATE TABLE IF NOT EXISTS outlet (
  outletId TEXT PRIMARY KEY,

  outletName TEXT DEFAULT '',
  ownerId TEXT DEFAULT '',

  addressLine1 TEXT DEFAULT '',
  addressLine2 TEXT,
  addressLine3 TEXT,

  city TEXT DEFAULT '',
  state TEXT,
  zipcode TEXT,
  countryName TEXT,

  taxType TEXT,
  taxMode TEXT DEFAULT 'PER_ITEM',

  gstVatNumber TEXT,
  fssaiNumber TEXT DEFAULT '',

  phone TEXT DEFAULT '',
  phone2 TEXT,

  email TEXT,
  web TEXT,

  logoUrl TEXT,

  printerWidth INTEGER DEFAULT 80,
  printerIPBill TEXT DEFAULT '',
  printerIPKitchen TEXT DEFAULT '',
  printerName TEXT,

  footerNote TEXT,

  qrEnabled INTEGER DEFAULT 0,
  qrText TEXT,
  qrTitle TEXT,

  upiId TEXT,
  upiName TEXT,
  upiTitle TEXT,

  countryCode TEXT DEFAULT 'IN',

  currencyCode TEXT DEFAULT 'INR',

  localeTag TEXT DEFAULT 'en-IN',

  isActive INTEGER DEFAULT 1,

  posType TEXT DEFAULT 'RESTAU',

  showCategorySidebar INTEGER DEFAULT 1,

  startupScreen TEXT DEFAULT 'tables'
);





-- =====================================================
-- ORDER COUNTER
-- Same structure as Android
-- =====================================================

CREATE TABLE IF NOT EXISTS order_counter (
  id INTEGER PRIMARY KEY CHECK (id = 1),

  invoiceSerialNo INTEGER NOT NULL DEFAULT 0,

  updatedAt INTEGER NOT NULL
);


-- =====================================================
-- ENSURE SINGLE COUNTER ROW EXISTS
-- =====================================================

INSERT OR IGNORE INTO order_counter (
  id,
  invoiceSerialNo,
  updatedAt
)
VALUES (
  1,
  0,
  strftime('%s', 'now') * 1000
);


-- =====================================================
-- ORDER SERIAL MAP
-- Same structure as Android
-- =====================================================

CREATE TABLE IF NOT EXISTS order_serial_map (
  mapKey TEXT PRIMARY KEY,

  orderId TEXT,

  orderSerialNo INTEGER NOT NULL,

  srno TEXT NOT NULL,

  createdAt INTEGER NOT NULL
);


-- =====================================================
-- ORDER SERIAL MAP INDEXES
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_order_serial_map_orderId
ON order_serial_map(orderId);

CREATE INDEX IF NOT EXISTS idx_order_serial_map_srno
ON order_serial_map(srno);



-- =====================================================
-- LIQUOR VAT ORDER SERIAL MAP
-- =====================================================

CREATE TABLE IF NOT EXISTS liquor_vat_order_serial_map (
  mapKey TEXT PRIMARY KEY,

  orderId TEXT,

  orderSerialNo INTEGER NOT NULL,

  srno TEXT NOT NULL,

  createdAt INTEGER NOT NULL
);


-- =====================================================
-- LIQUOR VAT ORDER SERIAL MAP INDEXES
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_liquor_vat_order_serial_map_orderId
ON liquor_vat_order_serial_map(orderId);

CREATE INDEX IF NOT EXISTS idx_liquor_vat_order_serial_map_srno
ON liquor_vat_order_serial_map(srno);




-- =====================================================
-- LIQUOR VAT ORDER COUNTER
-- =====================================================

CREATE TABLE IF NOT EXISTS liquor_vat_order_counter (
  id INTEGER PRIMARY KEY CHECK (id = 1),

  invoiceSerialNo INTEGER NOT NULL DEFAULT 0,

  updatedAt INTEGER NOT NULL
);


-- =====================================================
-- ENSURE SINGLE COUNTER ROW EXISTS
-- =====================================================

INSERT OR IGNORE INTO liquor_vat_order_counter (
  id,
  invoiceSerialNo,
  updatedAt
)
VALUES (
  1,
  0,
  strftime('%s', 'now') * 1000
);
-- =====================================================
-- BUSINESS DAY
-- =====================================================



  CREATE TABLE IF NOT EXISTS pos_business_day (

    id TEXT PRIMARY KEY,

    businessDate TEXT NOT NULL,

    openedAt INTEGER NOT NULL,

    openedById TEXT NOT NULL,

    openedByName TEXT NOT NULL,

    openingCash REAL NOT NULL DEFAULT 0,

    isClosed INTEGER NOT NULL DEFAULT 0,

    closedAt INTEGER,

    closedById TEXT,

    closedByName TEXT,

    status TEXT NOT NULL DEFAULT 'OPEN',

    updatedAt INTEGER NOT NULL

  );




-- =====================================================
-- DAY CLOSING HISTORY
-- =====================================================
 

 
 CREATE TABLE IF NOT EXISTS pos_day_closing (

    id TEXT PRIMARY KEY,

    businessDate TEXT NOT NULL,

    openedAt INTEGER NOT NULL,
    closedAt INTEGER NOT NULL,

    openedById TEXT NOT NULL,
    openedByName TEXT NOT NULL,

    closedById TEXT NOT NULL,
    closedByName TEXT NOT NULL,

    openingCash REAL NOT NULL,

    expectedCash REAL NOT NULL,

    actualCash REAL NOT NULL,

    cashHandedOver REAL NOT NULL DEFAULT 0,

    cashDifference REAL NOT NULL,

    totalSales REAL NOT NULL,

    totalRefund REAL NOT NULL,

    totalDiscount REAL NOT NULL,

    totalTax REAL NOT NULL,

    cashSales REAL NOT NULL,

    cardSales REAL NOT NULL,

    upiSales REAL NOT NULL,

    walletSales REAL NOT NULL,

    creditSales REAL NOT NULL,

    complimentarySales REAL NOT NULL,

    totalOrders INTEGER NOT NULL,

    syncStatus TEXT NOT NULL,

    createdAt INTEGER NOT NULL

);
 
-- =====================================================
-- DAY CLOSING DATE INDEX
-- =====================================================

 
  CREATE INDEX IF NOT EXISTS
  idx_pos_day_closing_businessDate
  ON pos_day_closing (businessDate);
 

-- =====================================================
-- CASH TRANSACTIONS
-- =====================================================

CREATE TABLE IF NOT EXISTS pos_cash_transactions (

    id TEXT PRIMARY KEY,

    businessDate TEXT NOT NULL,

    type TEXT NOT NULL,

    amount REAL NOT NULL,

    reason TEXT NOT NULL DEFAULT '',

    notes TEXT NOT NULL DEFAULT '',

    createdById TEXT NOT NULL DEFAULT '',

    createdByName TEXT NOT NULL DEFAULT '',

    createdAt INTEGER NOT NULL

);

-- =====================================================
-- CASH TRANSACTIONS INDEXES
-- =====================================================

CREATE INDEX IF NOT EXISTS
idx_pos_cash_transactions_businessDate
ON pos_cash_transactions (businessDate);

CREATE INDEX IF NOT EXISTS
idx_pos_cash_transactions_type
ON pos_cash_transactions (type);



-- =====================================================
-- POS SHIFT
-- =====================================================

CREATE TABLE IF NOT EXISTS pos_shift (

    id TEXT PRIMARY KEY,

    businessDate TEXT NOT NULL,

    shiftNumber INTEGER NOT NULL,

    openedAt INTEGER NOT NULL,
    closedAt INTEGER,

    openedById TEXT NOT NULL,
    openedByName TEXT NOT NULL,

    closedById TEXT,
    closedByName TEXT,

    openingCash REAL NOT NULL DEFAULT 0,

    expectedCash REAL NOT NULL DEFAULT 0,

    actualCash REAL,

    cashHandedOver REAL,

    cashDifference REAL,

    status TEXT NOT NULL DEFAULT 'OPEN',

    notes TEXT NOT NULL DEFAULT '',

    createdAt INTEGER NOT NULL
);


-- =====================================================
-- POS SESSIONS
-- =====================================================

 
  CREATE TABLE IF NOT EXISTS pos_sessions (
    sessionId TEXT PRIMARY KEY,
    userId TEXT NOT NULL,
    outletId TEXT NOT NULL,
    fullName TEXT NOT NULL,
    employeeId TEXT,
    role TEXT,
    loginAt INTEGER NOT NULL,
    logoutAt INTEGER,
    lastActivityAt INTEGER NOT NULL,
    isActive INTEGER NOT NULL DEFAULT 1
  );
 

-- =====================================================
-- FIRE STORE
-- =====================================================
 CREATE TABLE IF NOT EXISTS firebase_config (
  id INTEGER PRIMARY KEY CHECK (id = 1),

  clientId TEXT NOT NULL,

  apiKey TEXT NOT NULL,
  authDomain TEXT,
  databaseURL TEXT,
  projectId TEXT NOT NULL,
  storageBucket TEXT,
  messagingSenderId TEXT,
  appId TEXT NOT NULL,
  measurementId TEXT,

  updatedAt INTEGER NOT NULL
);







-- ============================================================
-- LOYALTY MANAGEMENT SYSTEM
-- Complete database schema
-- SQLite / better-sqlite3
-- ============================================================


-- ============================================================
-- 1. LOYALTY PROGRAM
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_program (
    id TEXT PRIMARY KEY,

    programName TEXT NOT NULL,

    description TEXT,

    currencyCode TEXT,

    -- Example: spend 100 currency units to earn 100 points
    earnSpendMinor INTEGER NOT NULL DEFAULT 10000,
    earnPoints INTEGER NOT NULL DEFAULT 100,

    -- Example: 100 points = 100 minor currency units
    redeemPoints INTEGER NOT NULL DEFAULT 100,
    redeemValueMinor INTEGER NOT NULL DEFAULT 100,

    minRedeemPoints INTEGER NOT NULL DEFAULT 100,
    maxRedeemPercent INTEGER NOT NULL DEFAULT 100,

    pointsExpiryDays INTEGER NOT NULL DEFAULT 365,

    allowPartialRedemption INTEGER NOT NULL DEFAULT 1,
    allowEarnOnDiscountedBills INTEGER NOT NULL DEFAULT 0,
    allowEarnOnRedeemedAmount INTEGER NOT NULL DEFAULT 0,

    isActive INTEGER NOT NULL DEFAULT 1,

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CHECK (earnSpendMinor > 0),
    CHECK (earnPoints > 0),
    CHECK (redeemPoints > 0),
    CHECK (redeemValueMinor > 0),
    CHECK (minRedeemPoints >= 0),
    CHECK (maxRedeemPercent BETWEEN 0 AND 100),
    CHECK (pointsExpiryDays >= 0)
);


-- ============================================================
-- 2. PROGRAM OUTLETS
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_program_outlet (
    id TEXT PRIMARY KEY,

    programId TEXT NOT NULL,

    -- References the existing POS outlet ID
    outletId TEXT NOT NULL,

    isActive INTEGER NOT NULL DEFAULT 1,

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (programId)
        REFERENCES loyalty_program(id)
        ON DELETE RESTRICT,

    UNIQUE(programId, outletId)
);


-- ============================================================
-- 3. LOYALTY CUSTOMER
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_customer (
    id TEXT PRIMARY KEY,

    name TEXT NOT NULL,

    phone TEXT NOT NULL UNIQUE,

    email TEXT,

    address TEXT,

    dateOfBirth TEXT,

    gender TEXT,

    notes TEXT,

    isActive INTEGER NOT NULL DEFAULT 1,

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 4. LOYALTY TIER
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_tier (
    id TEXT PRIMARY KEY,

    programId TEXT NOT NULL,

    tierName TEXT NOT NULL,

    description TEXT,

    -- Qualification thresholds
    minLifetimeSpendMinor INTEGER NOT NULL DEFAULT 0,
    minLifetimeEarnedPoints INTEGER NOT NULL DEFAULT 0,

    -- 10000 = 1x earning multiplier
    earnMultiplierBps INTEGER NOT NULL DEFAULT 10000,

    bonusPoints INTEGER NOT NULL DEFAULT 0,

    discountPercent REAL NOT NULL DEFAULT 0,

    priority INTEGER NOT NULL DEFAULT 0,

    isActive INTEGER NOT NULL DEFAULT 1,

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (programId)
        REFERENCES loyalty_program(id)
        ON DELETE RESTRICT,

    UNIQUE(programId, tierName),

    CHECK (minLifetimeSpendMinor >= 0),
    CHECK (minLifetimeEarnedPoints >= 0),
    CHECK (earnMultiplierBps > 0),
    CHECK (bonusPoints >= 0),
    CHECK (discountPercent BETWEEN 0 AND 100)
);


-- ============================================================
-- 5. LOYALTY ACCOUNT
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_account (
    id TEXT PRIMARY KEY,

    customerId TEXT NOT NULL,

    programId TEXT NOT NULL,

    tierId TEXT,

    balancePoints INTEGER NOT NULL DEFAULT 0,

    lifetimeEarned INTEGER NOT NULL DEFAULT 0,

    lifetimeRedeemed INTEGER NOT NULL DEFAULT 0,

    lifetimeExpired INTEGER NOT NULL DEFAULT 0,

    lifetimeAdjusted INTEGER NOT NULL DEFAULT 0,

    lifetimeSpendMinor INTEGER NOT NULL DEFAULT 0,

    joinedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    lastActivityAt TEXT,

    isActive INTEGER NOT NULL DEFAULT 1,

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customerId)
        REFERENCES loyalty_customer(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (programId)
        REFERENCES loyalty_program(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (tierId)
        REFERENCES loyalty_tier(id)
        ON DELETE SET NULL,

    UNIQUE(customerId, programId),

    CHECK (balancePoints >= 0),
    CHECK (lifetimeEarned >= 0),
    CHECK (lifetimeRedeemed >= 0),
    CHECK (lifetimeExpired >= 0),
    CHECK (lifetimeSpendMinor >= 0)
);


-- ============================================================
-- 6. LOYALTY TRANSACTION LEDGER
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_transaction (
    id TEXT PRIMARY KEY,

    accountId TEXT NOT NULL,

    transactionType TEXT NOT NULL,

    -- Positive = credit
    -- Negative = debit
    points INTEGER NOT NULL,

    balanceAfter INTEGER NOT NULL,

    orderId TEXT,

    orderNo TEXT,

    outletId TEXT,

    referenceTransactionId TEXT,

    campaignId TEXT,

    rewardRedemptionId TEXT,

    idempotencyKey TEXT UNIQUE,

    description TEXT,

    businessDate TEXT,

    createdBy TEXT,

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (accountId)
        REFERENCES loyalty_account(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (referenceTransactionId)
        REFERENCES loyalty_transaction(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (campaignId)
        REFERENCES loyalty_campaign(id)
        ON DELETE SET NULL,

    CHECK (
        transactionType IN (
            'EARN',
            'REDEEM',
            'EXPIRE',
            'ADJUST',
            'REVERSAL',
            'REFERRAL',
            'BONUS'
        )
    ),

    CHECK (points != 0),
    CHECK (balanceAfter >= 0)
);


-- ============================================================
-- 7. POINT LOTS
-- Every earning transaction creates a separate points lot.
-- This makes expiry accurate.
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_point_lot (
    id TEXT PRIMARY KEY,

    accountId TEXT NOT NULL,

    transactionId TEXT NOT NULL UNIQUE,

    originalPoints INTEGER NOT NULL,

    remainingPoints INTEGER NOT NULL,

    earnedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    expiresAt TEXT,

    status TEXT NOT NULL DEFAULT 'ACTIVE',

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (accountId)
        REFERENCES loyalty_account(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (transactionId)
        REFERENCES loyalty_transaction(id)
        ON DELETE RESTRICT,

    CHECK (originalPoints > 0),
    CHECK (remainingPoints >= 0),
    CHECK (remainingPoints <= originalPoints),

    CHECK (
        status IN (
            'ACTIVE',
            'PARTIALLY_USED',
            'USED',
            'EXPIRED',
            'REVERSED'
        )
    )
);


-- ============================================================
-- 8. POINT ALLOCATION
-- Tracks exactly which points lots were used during redemption.
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_point_allocation (
    id TEXT PRIMARY KEY,

    redemptionTransactionId TEXT NOT NULL,

    pointLotId TEXT NOT NULL,

    pointsUsed INTEGER NOT NULL,

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (redemptionTransactionId)
        REFERENCES loyalty_transaction(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (pointLotId)
        REFERENCES loyalty_point_lot(id)
        ON DELETE RESTRICT,

    UNIQUE(redemptionTransactionId, pointLotId),

    CHECK (pointsUsed > 0)
);


-- ============================================================
-- 9. LOYALTY REWARDS
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_reward (
    id TEXT PRIMARY KEY,

    programId TEXT NOT NULL,

    rewardName TEXT NOT NULL,

    description TEXT,

    rewardType TEXT NOT NULL,

    pointsRequired INTEGER NOT NULL,

    -- Optional product reference from existing POS products
    productId TEXT,

    rewardValueMinor INTEGER NOT NULL DEFAULT 0,

    stockQuantity INTEGER,

    maxPerCustomer INTEGER,

    validFrom TEXT,

    validUntil TEXT,

    isActive INTEGER NOT NULL DEFAULT 1,

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (programId)
        REFERENCES loyalty_program(id)
        ON DELETE RESTRICT,

    CHECK (
        rewardType IN (
            'DISCOUNT',
            'FREE_PRODUCT',
            'FREE_ITEM',
            'FIXED_VALUE',
            'CUSTOM'
        )
    ),

    CHECK (pointsRequired > 0),
    CHECK (rewardValueMinor >= 0),
    CHECK (stockQuantity IS NULL OR stockQuantity >= 0)
);


-- ============================================================
-- 10. REWARD REDEMPTION
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_reward_redemption (
    id TEXT PRIMARY KEY,

    accountId TEXT NOT NULL,

    rewardId TEXT NOT NULL,

    transactionId TEXT,

    voucherId TEXT,

    pointsSpent INTEGER NOT NULL,

    status TEXT NOT NULL DEFAULT 'PENDING',

    redeemedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    usedAt TEXT,

    expiresAt TEXT,

    outletId TEXT,

    orderId TEXT,

    createdBy TEXT,

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (accountId)
        REFERENCES loyalty_account(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (rewardId)
        REFERENCES loyalty_reward(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (transactionId)
        REFERENCES loyalty_transaction(id)
        ON DELETE RESTRICT,

    CHECK (pointsSpent > 0),

    CHECK (
        status IN (
            'PENDING',
            'ISSUED',
            'USED',
            'EXPIRED',
            'CANCELLED'
        )
    )
);


-- ============================================================
-- 11. LOYALTY VOUCHER / COUPON
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_voucher (
    id TEXT PRIMARY KEY,

    accountId TEXT,

    rewardRedemptionId TEXT,

    campaignId TEXT,

    voucherCode TEXT NOT NULL UNIQUE,

    voucherType TEXT NOT NULL,

    discountValue REAL NOT NULL DEFAULT 0,

    discountAmountMinor INTEGER NOT NULL DEFAULT 0,

    maxDiscountMinor INTEGER,

    minOrderAmountMinor INTEGER NOT NULL DEFAULT 0,

    usageLimit INTEGER NOT NULL DEFAULT 1,

    usedCount INTEGER NOT NULL DEFAULT 0,

    validFrom TEXT,

    validUntil TEXT,

    status TEXT NOT NULL DEFAULT 'ACTIVE',

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (accountId)
        REFERENCES loyalty_account(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (rewardRedemptionId)
        REFERENCES loyalty_reward_redemption(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (campaignId)
        REFERENCES loyalty_campaign(id)
        ON DELETE SET NULL,

    CHECK (
        voucherType IN (
            'PERCENT',
            'FIXED',
            'FREE_ITEM'
        )
    ),

    CHECK (discountValue >= 0),
    CHECK (discountAmountMinor >= 0),
    CHECK (minOrderAmountMinor >= 0),
    CHECK (usageLimit > 0),
    CHECK (usedCount >= 0),
    CHECK (usedCount <= usageLimit),

    CHECK (
        status IN (
            'ACTIVE',
            'USED',
            'EXPIRED',
            'CANCELLED'
        )
    )
);


-- ============================================================
-- 12. LOYALTY CAMPAIGNS
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_campaign (
    id TEXT PRIMARY KEY,

    programId TEXT NOT NULL,

    campaignName TEXT NOT NULL,

    description TEXT,

    campaignType TEXT NOT NULL,

    -- Examples: multiplier 2x or bonus points
    earnMultiplierBps INTEGER NOT NULL DEFAULT 10000,

    bonusPoints INTEGER NOT NULL DEFAULT 0,

    minOrderAmountMinor INTEGER NOT NULL DEFAULT 0,

    maxBonusPoints INTEGER,

    startDate TEXT NOT NULL,

    endDate TEXT NOT NULL,

    usageLimit INTEGER,

    usedCount INTEGER NOT NULL DEFAULT 0,

    isActive INTEGER NOT NULL DEFAULT 1,

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (programId)
        REFERENCES loyalty_program(id)
        ON DELETE RESTRICT,

    CHECK (
        campaignType IN (
            'DOUBLE_POINTS',
            'BONUS_POINTS',
            'MULTIPLIER',
            'SPECIAL'
        )
    ),

    CHECK (earnMultiplierBps > 0),
    CHECK (bonusPoints >= 0),
    CHECK (minOrderAmountMinor >= 0),
    CHECK (usedCount >= 0)
);


-- ============================================================
-- 13. LOYALTY REFERRALS
-- ============================================================

CREATE TABLE IF NOT EXISTS loyalty_referral (
    id TEXT PRIMARY KEY,

    programId TEXT NOT NULL,

    referrerAccountId TEXT NOT NULL,

    referredCustomerId TEXT NOT NULL,

    referralCode TEXT NOT NULL UNIQUE,

    referralStatus TEXT NOT NULL DEFAULT 'PENDING',

    referrerBonusPoints INTEGER NOT NULL DEFAULT 0,

    referredBonusPoints INTEGER NOT NULL DEFAULT 0,

    referrerTransactionId TEXT,

    referredTransactionId TEXT,

    completedOrderId TEXT,

    referredAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    completedAt TEXT,

    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (programId)
        REFERENCES loyalty_program(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (referrerAccountId)
        REFERENCES loyalty_account(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (referredCustomerId)
        REFERENCES loyalty_customer(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (referrerTransactionId)
        REFERENCES loyalty_transaction(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (referredTransactionId)
        REFERENCES loyalty_transaction(id)
        ON DELETE RESTRICT,

    UNIQUE(programId, referredCustomerId),

    CHECK (referrerBonusPoints >= 0),
    CHECK (referredBonusPoints >= 0),

    CHECK (
        referralStatus IN (
            'PENDING',
            'COMPLETED',
            'CANCELLED'
        )
    )
);


-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_loyalty_customer_name
ON loyalty_customer(name);

CREATE INDEX IF NOT EXISTS idx_loyalty_account_customer
ON loyalty_account(customerId);

CREATE INDEX IF NOT EXISTS idx_loyalty_account_program
ON loyalty_account(programId);

CREATE INDEX IF NOT EXISTS idx_loyalty_account_tier
ON loyalty_account(tierId);

CREATE INDEX IF NOT EXISTS idx_loyalty_transaction_account
ON loyalty_transaction(accountId, createdAt);

CREATE INDEX IF NOT EXISTS idx_loyalty_transaction_order
ON loyalty_transaction(orderId);

CREATE INDEX IF NOT EXISTS idx_loyalty_transaction_date
ON loyalty_transaction(businessDate);

CREATE INDEX IF NOT EXISTS idx_loyalty_point_lot_account
ON loyalty_point_lot(accountId, status);

CREATE INDEX IF NOT EXISTS idx_loyalty_point_lot_expiry
ON loyalty_point_lot(expiresAt, status);

CREATE INDEX IF NOT EXISTS idx_loyalty_allocation_lot
ON loyalty_point_allocation(pointLotId);

CREATE INDEX IF NOT EXISTS idx_loyalty_reward_program
ON loyalty_reward(programId, isActive);

CREATE INDEX IF NOT EXISTS idx_loyalty_reward_redemption_account
ON loyalty_reward_redemption(accountId, status);

CREATE INDEX IF NOT EXISTS idx_loyalty_voucher_code
ON loyalty_voucher(voucherCode);

CREATE INDEX IF NOT EXISTS idx_loyalty_voucher_account
ON loyalty_voucher(accountId);

CREATE INDEX IF NOT EXISTS idx_loyalty_campaign_dates
ON loyalty_campaign(startDate, endDate, isActive);

CREATE INDEX IF NOT EXISTS idx_loyalty_referral_account
ON loyalty_referral(referrerAccountId);







