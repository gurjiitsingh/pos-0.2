const { db } = require('./sqlite.cjs');

// =====================================================
// LIQUOR VAT REPORT REPOSITORY
// =====================================================

function getLiquorVatReport(startDate, endDate) {

  // ===================================================
  // VALIDATION
  // ===================================================

  if (!startDate || !endDate || startDate > endDate) {
    throw new Error('Invalid liquor VAT report date range');
  }

  // ===================================================
  // OVERALL LIQUOR SALES
  // ===================================================

  const salesStats = db
    .prepare(`
      SELECT
        COUNT(DISTINCT om.id) AS totalOrders,

        COALESCE(SUM(oi.finalTotal), 0) AS totalSales,

        0 AS totalDiscount,

        0 AS totalTax,

        0 AS totalPaid,

        0 AS totalDue

      FROM pos_order_items oi

      INNER JOIN pos_order_master om
        ON om.id = oi.orderMasterId

      WHERE om.realDate BETWEEN ? AND ?

        AND UPPER(om.orderStatus) = 'COMPLETED'

        AND UPPER(oi.status) = 'DONE'

        AND UPPER(oi.taxCategory) = 'LIQUOR_VAT'
    `)
    .get(startDate, endDate);


 
// ===================================================
// PAYMENT BREAKDOWN
// ===================================================

const paymentStats = db
  .prepare(`
    SELECT

      COALESCE(SUM(
        CASE WHEN UPPER(p.mode) = 'CASH'
        THEN p.amount ELSE 0 END
      ), 0) AS cash,

      COALESCE(SUM(
        CASE WHEN UPPER(p.mode) = 'CARD'
        THEN p.amount ELSE 0 END
      ), 0) AS card,

      COALESCE(SUM(
        CASE WHEN UPPER(p.mode) = 'UPI'
        THEN p.amount ELSE 0 END
      ), 0) AS upi,

      COALESCE(SUM(
        CASE WHEN UPPER(p.mode) = 'WALLET'
        THEN p.amount ELSE 0 END
      ), 0) AS wallet,

      COALESCE(SUM(
        CASE WHEN UPPER(p.mode) = 'CREDIT'
        THEN p.amount ELSE 0 END
      ), 0) AS credit

    FROM pos_order_payments p

    INNER JOIN pos_order_master om
      ON om.id = p.orderId

  WHERE om.realDate BETWEEN ? AND ?

  AND UPPER(om.orderStatus) = 'COMPLETED'

  AND UPPER(om.taxCategory) = 'LIQUOR_VAT'

  AND (
    p.isVoided IS NULL
    OR p.isVoided = 0
  )

  AND (
    p.status IS NULL
    OR UPPER(p.status) != 'VOIDED'
  )
  `)
  .get(startDate, endDate);

  // ===================================================
  // CATEGORY SALES
  // ===================================================

  const categorySales = db
    .prepare(`
      SELECT
        oi.categoryId AS categoryId,

        oi.categoryName AS categoryName,

        COALESCE(SUM(oi.quantity), 0) AS quantity,

        COALESCE(SUM(oi.finalTotal), 0) AS sales

      FROM pos_order_items oi

      INNER JOIN pos_order_master om
        ON om.id = oi.orderMasterId

      WHERE om.realDate BETWEEN ? AND ?

        AND UPPER(om.orderStatus) = 'COMPLETED'

        AND UPPER(oi.status) = 'DONE'

        AND UPPER(oi.taxCategory) = 'LIQUOR_VAT'

      GROUP BY
        oi.categoryId,
        oi.categoryName

      ORDER BY sales DESC
    `)
    .all(startDate, endDate);


  // ===================================================
  // PRODUCT SALES
  // ===================================================

  const productSales = db
    .prepare(`
      SELECT
        oi.productId AS productId,

        oi.name AS productName,

        oi.categoryId AS categoryId,

        oi.categoryName AS categoryName,

        COALESCE(SUM(oi.quantity), 0) AS quantity,

        COALESCE(SUM(oi.finalTotal), 0) AS sales

      FROM pos_order_items oi

      INNER JOIN pos_order_master om
        ON om.id = oi.orderMasterId

      WHERE om.realDate BETWEEN ? AND ?

        AND UPPER(om.orderStatus) = 'COMPLETED'

        AND UPPER(oi.status) = 'DONE'

        AND UPPER(oi.taxCategory) = 'LIQUOR_VAT'

      GROUP BY
        oi.productId,
        oi.name,
        oi.categoryId,
        oi.categoryName

      ORDER BY sales DESC
    `)
    .all(startDate, endDate);


  // ===================================================
  // ORDER TYPE SALES
  // ===================================================

  const orderTypeSales = db
    .prepare(`
      SELECT
        om.orderType,

        COUNT(DISTINCT om.id) AS orders,

        COALESCE(SUM(oi.finalTotal), 0) AS sales

      FROM pos_order_master om

      INNER JOIN pos_order_items oi
        ON oi.orderMasterId = om.id

      WHERE om.realDate BETWEEN ? AND ?

        AND UPPER(om.orderStatus) = 'COMPLETED'

        AND UPPER(oi.status) = 'DONE'

        AND UPPER(oi.taxCategory) = 'LIQUOR_VAT'

      GROUP BY om.orderType

      ORDER BY sales DESC
    `)
    .all(startDate, endDate);


  // ===================================================
  // STAFF SALES
  // ===================================================

  const staffSales = db
    .prepare(`
      SELECT
        om.createdById AS staffId,

        om.createdByName AS staffName,

        COUNT(DISTINCT om.id) AS orders,

        COALESCE(SUM(oi.finalTotal), 0) AS sales

      FROM pos_order_master om

      INNER JOIN pos_order_items oi
        ON oi.orderMasterId = om.id

      WHERE om.realDate BETWEEN ? AND ?

        AND UPPER(om.orderStatus) = 'COMPLETED'

        AND UPPER(oi.status) = 'DONE'

        AND UPPER(oi.taxCategory) = 'LIQUOR_VAT'

      GROUP BY
        om.createdById,
        om.createdByName

      ORDER BY sales DESC
    `)
    .all(startDate, endDate);


  // ===================================================
  // HOURLY SALES
  // ===================================================

  const hourlySales = db
    .prepare(`
      SELECT
        strftime(
          '%H',
          om.createdAt / 1000,
          'unixepoch'
        ) AS hour,

        COUNT(DISTINCT om.id) AS orders,

        COALESCE(SUM(oi.finalTotal), 0) AS sales

      FROM pos_order_master om

      INNER JOIN pos_order_items oi
        ON oi.orderMasterId = om.id

      WHERE om.realDate BETWEEN ? AND ?

        AND UPPER(om.orderStatus) = 'COMPLETED'

        AND UPPER(oi.status) = 'DONE'

        AND UPPER(oi.taxCategory) = 'LIQUOR_VAT'

      GROUP BY hour

      ORDER BY hour
    `)
    .all(startDate, endDate);


  // ===================================================
  // RETURN
  // ===================================================

  return {

    overview: {
      totalOrders: Number(salesStats?.totalOrders || 0),
      totalSales: Number(salesStats?.totalSales || 0),
      totalDiscount: Number(salesStats?.totalDiscount || 0),
      totalTax: Number(salesStats?.totalTax || 0),
      totalPaid: Number(salesStats?.totalPaid || 0),
      totalDue: Number(salesStats?.totalDue || 0),
    },

    payments: paymentStats,

    categorySales,
    productSales,
    orderTypeSales,
    staffSales,
    hourlySales,
  };
}

module.exports = {
  getLiquorVatReport,
};