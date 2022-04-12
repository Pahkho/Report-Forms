explain
--  成品入库
select trade_purchase_bill.stock_date         AS stock_date,    -- 日期
       trade_purchase_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_purchase_bill.bill_no            AS bill_no,       -- 单据号码
       bas_supplier.code                      AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                     AS style_color,   -- 花号
       ''                                     AS coding,        -- 编码
       ''                                     AS gb_coding,     -- 国标码
       sum(trade_purchase_bill_goods.pur_qty) AS in_qty,        -- 入库数量
       ''                                     AS out_qty        -- 出库数量
from trade_purchase_bill
         LEFT JOIN bas_supplier on trade_purchase_bill.supplier_id = bas_supplier.id -- 公司
         LEFT JOIN trade_purchase_bill_goods
                   on trade_purchase_bill.id = trade_purchase_bill_goods.bill_id
         LEFT JOIN gds_singlproduct on trade_purchase_bill_goods.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where trade_purchase_bill.delivery_status = '13'
  AND trade_purchase_bill.base_company_id = '10001'
--    AND (trade_purchase_bill.stock_date >= '2022-03-20' AND trade_purchase_bill.stock_date <= '2022-03-31')
--    AND bas_supplier.code LIKE ('') -- 供应商
--    AND ('2' IN ('@queryType'))
group by trade_purchase_bill.stock_date,  -- 日期
         trade_purchase_bill.workflow_no, -- 交易号
         trade_purchase_bill.bill_no,     -- 单据号码
         bas_supplier.code,               -- 客户/供应商名称
         gds_goods_skc.code               -- 花号
union all
--  退供应商
select trade_purchase_return_bill.stock_date         AS stock_date,   -- 日期
       trade_purchase_return_bill.workflow_no        AS workflow_no,  -- 交易号
       trade_purchase_return_bill.bill_no            AS bill_no,      -- 单据号码
       bas_supplier.code                             AS custmer_name, -- 客户/供应商名称
       gds_goods_skc.code                            AS style_color,  -- 花号
       ''                                            AS coding,       -- 编码
       ''                                            AS gb_coding,    -- 国标码
       sum(trade_purchase_return_bill_goods.pur_qty) AS out_qty,      -- 出库数量
       ''                                            AS in_qty        -- 入库数量
from trade_purchase_return_bill
         LEFT JOIN bas_supplier on trade_purchase_return_bill.supplier_id = bas_supplier.id
         LEFT JOIN trade_purchase_return_bill_goods
                   on trade_purchase_return_bill.id = trade_purchase_return_bill_goods.bill_id
         LEFT JOIN gds_singlproduct
                   on trade_purchase_return_bill_goods.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where trade_purchase_return_bill.delivery_status = 8
  AND trade_purchase_return_bill.base_company_id = '10001'
--    AND (trade_purchase_return_bill.stock_date >= '2022-03-20' AND trade_purchase_bill.stock_date <= '2022-03-31')
--    AND bas_supplier.code LIKE ('') -- 供应商
--    AND ('1' IN ('@queryType'))
group by trade_purchase_return_bill.stock_date,  -- 日期
         trade_purchase_return_bill.workflow_no, -- 交易号
         trade_purchase_return_bill.bill_no,     -- 单据号码
         bas_supplier.code,                      -- 客户/供应商名称
         gds_goods_skc.code
union all
--  发货单
select trade_sale_bill.stock_date         AS stock_date,    -- 日期
       trade_sale_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_sale_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.code                  AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                 AS style_color,   -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       ''                                 AS in_qty,        -- 入库数量
       sum(trade_sale_bill_line.sale_qty) AS out_qty        -- 出库数量
from trade_sale_bill
         LEFT JOIN bas_customer on trade_sale_bill.customer_id = bas_customer.id
         LEFT JOIN trade_sale_bill_line on trade_sale_bill.id = trade_sale_bill_line.bill_id
         LEFT JOIN gds_singlproduct on trade_sale_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         LEFT JOIN gds_barcode on trade_sale_bill_line.sku_id = gds_barcode.sku_id
    AND gds_barcode.type = 1 -- 国标条码
where trade_sale_bill.delivery_status = 8
  AND trade_sale_bill.sale_method = 'S'
  AND trade_sale_bill.base_company_id = 10001
--    AND (trade_sale_bill.stock_date >= '2022-03-20' AND trade_sale_bill.stock_date <= '2022-03-31')
--    AND bas_customer.code LIKE ('') -- 供应商
--    AND ('3' IN ('@queryType'))
group by trade_sale_bill.stock_date,  -- 日期
         trade_sale_bill.workflow_no, -- 交易号
         trade_sale_bill.bill_no,     -- 单据号码
         bas_customer.code,           -- 客户/供应商名称
         gds_goods_skc.code           -- 花号
union all
--  换货单
select trade_sale_bill.stock_date         AS stock_date,    -- 日期
       trade_sale_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_sale_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.code                  AS customer_name, -- 客户/供应商
       gds_goods_skc.code                 AS style_color,   -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       sum(trade_sale_bill_line.sale_qty) AS out_qty,       -- 出库数量
       ''                                 AS in_qty         -- 入库数量
from trade_sale_bill
         LEFT JOIN bas_customer on trade_sale_bill.customer_id = bas_customer.id
         LEFT JOIN trade_sale_bill_line on trade_sale_bill.id = trade_sale_bill_line.bill_id
         LEFT JOIN gds_singlproduct on trade_sale_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where trade_sale_bill.delivery_status = 8
  AND trade_sale_bill.sale_method = 'C'
  AND trade_sale_bill.base_company_id = 10001
--    AND (trade_sale_bill.stock_date >= '2022-03-20' AND trade_sale_bill.stock_date <= '2022-03-31')
--    AND bas_customer.cod -- 供应商
--    AND queryType'))
group by trade_sale_bill.stock_date,  -- 日期
         trade_sale_bill.workflow_no, -- 交易号
         trade_sale_bill.bill_no,     -- 单据号码
         bas_customer.code,
         gds_goods_skc.code
union all
--  溢亏
select stk_stock_logic_adjust_bill.stock_date  AS stock_date,    -- 日期
       stk_stock_logic_adjust_bill.workflow_no AS workflow_no,   -- 交易号
       stk_stock_logic_adjust_bill.bill_no     AS bill_no,       -- 单据号码
       ''                                      AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                      AS style_color,   -- 花号
       ''                                      AS coding,        -- 编码
       ''                                      AS gb_coding,     -- 国标码
       sum(CASE
               WHEN stk_stklogic_adjbill_detail.qty > 0 THEN stk_stklogic_adjbill_detail.qty
               ELSE 0 END)                     AS in_qty,        -- 入库数量
       sum(CASE
               WHEN stk_stklogic_adjbill_detail.qty < 0 THEN stk_stklogic_adjbill_detail.qty
               ELSE 0 END)                     AS out_qty
from stk_stock_logic_adjust_bill
         LEFT JOIN bas_logic_warehouse
                   on stk_stock_logic_adjust_bill.warehouse_id = bas_logic_warehouse.id
         LEFT JOIN stk_stklogic_adjbill_detail
                   on stk_stock_logic_adjust_bill.id = stk_stklogic_adjbill_detail.bill_id
         LEFT JOIN gds_singlproduct on stk_stklogic_adjbill_detail.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where stk_stock_logic_adjust_bill.bill_status = '05'
  AND bas_logic_warehouse.accounting_company_id = 10001
group by stk_stock_logic_adjust_bill.stock_date,
         stk_stock_logic_adjust_bill.workflow_no,
         stk_stock_logic_adjust_bill.bill_no,
         gds_goods_skc.code
union all
--  代销调拨
select drp_cons_sale_bill.stock_date         AS stock_date,    -- 日期
       drp_cons_sale_bill.workflow_no        AS workflow_no,   -- 交易号
       drp_cons_sale_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.code                     AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                    AS style_color,   -- 花号
       ''                                    AS coding,        -- 编码
       ''                                    AS gb_coding,     -- 国标码
       ''                                    AS in_qty,        -- 入库数量
       sum(drp_cons_sale_bill_line.sale_qty) AS out_qty        -- 出库数量
from drp_cons_sale_bill
         LEFT JOIN bas_customer on drp_cons_sale_bill.customer_id = bas_customer.id
         LEFT JOIN drp_cons_sale_bill_line
                   on drp_cons_sale_bill.id = drp_cons_sale_bill_line.cons_sale_bill_id
         LEFT JOIN gds_singlproduct on drp_cons_sale_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         LEFT JOIN gds_barcode on drp_cons_sale_bill_line.sku_id = gds_barcode.sku_id AND
                                  gds_barcode.type = 1 -- 国标条码
where drp_cons_sale_bill.bill_status = '05'
  and drp_cons_sale_bill.base_company_id = 10001
group by drp_cons_sale_bill.stock_date,  -- 日期
         drp_cons_sale_bill.workflow_no, -- 交易号
         drp_cons_sale_bill.bill_no,     -- 单据号码
         bas_customer.code,              -- 客户/供应商名称
         gds_goods_skc.code              -- 花号
union all
--  代销退货
select drp_cons_return_bill.stock_date         AS stock_date,    -- 日期
       drp_cons_return_bill.workflow_no        AS workflow_no,   -- 交易号
       drp_cons_return_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.code                       AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                      AS style_color,   -- 花号
       ''                                      AS coding,        -- 编码
       ''                                      AS gb_coding,     -- 国标码
       sum(drp_cons_return_bill_line.sale_qty) AS in_qty,        -- 入库数量
       ''                                      AS out_qty        -- 出库数量
from drp_cons_return_bill
         LEFT JOIN bas_customer on drp_cons_return_bill.customer_id = bas_customer.id
         LEFT JOIN drp_cons_return_bill_line
                   on drp_cons_return_bill.id =
                      drp_cons_return_bill_line.cons_sale_return_bill_id
         LEFT JOIN gds_singlproduct on drp_cons_return_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         LEFT JOIN gds_barcode on drp_cons_return_bill_line.sku_id = gds_barcode.sku_id
    AND gds_barcode.type = 1 -- 国标条码
where drp_cons_return_bill.bill_status = '05'
  and drp_cons_return_bill.base_company_id = 10001
group by drp_cons_return_bill.stock_date,  -- 日期
         drp_cons_return_bill.workflow_no, -- 交易号
         drp_cons_return_bill.bill_no,     -- 单据号码
         bas_customer.code,                -- 客户/供应商名称
         gds_goods_skc.code                -- 花号
union all
--  经销退货
select trade_sale_return_bill.stock_date         AS stock_date,    -- 日期
       trade_sale_return_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_sale_return_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.code                         AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                        AS style_color,   -- 花号
       ''                                        AS coding,-- 编码
       ''                                        AS gb_coding,-- 国标码
       sum(trade_sale_return_bill_line.sale_qty) AS in_qty,        -- 入库数量
       ''                                        AS out_qty        -- 出库数量
from trade_sale_return_bill
         LEFT JOIN bas_customer on trade_sale_return_bill.customer_id = bas_customer.id
         LEFT JOIN trade_sale_return_bill_line
                   on trade_sale_return_bill.id = trade_sale_return_bill_line.bill_id
         LEFT JOIN gds_singlproduct on trade_sale_return_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
--  LEFT JOIN gds_barcode on trade_sale_return_bill_line.sku_id=gds_barcode.sku_id
--                               AND gds_barcode.type=1 -- 国标条码
where trade_sale_return_bill.delivery_status = '13'
  AND trade_sale_return_bill.base_company_id = '10001'
group by trade_sale_return_bill.stock_date,  -- 日期
         trade_sale_return_bill.workflow_no, -- 交易号
         trade_sale_return_bill.bill_no,     -- 单据号码
         bas_customer.code,                  -- 客户/供应商名称
         gds_goods_skc.code                  -- 花号
union all
--  仓库调拨
select stk_allocate_out_bill.stock_date   AS stock_date,    -- 日期
       stk_allocate_out_bill.workflow_no  AS workflow_no,   -- 交易号
       stk_allocate_out_bill.bill_no      AS bill_no,       -- 单据号码
       ''                                 AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                 AS style_color,   -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       sum(stk_allocateoutbill_goods.qty) AS out_qty,       -- 出库数量
       ''                                 AS in_qty         -- 入库数量
from stk_allocate_out_bill
         LEFT JOIN stk_allocateoutbill_goods
                   on stk_allocate_out_bill.id = stk_allocateoutbill_goods.allocate_out_bill_id
         LEFT JOIN gds_singlproduct on stk_allocateoutbill_goods.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where stk_allocate_out_bill.status = '05'
  and stk_allocate_out_bill.stock_organization_out_id = 10001
group by stk_allocate_out_bill.stock_date,
         stk_allocate_out_bill.workflow_no,
         stk_allocate_out_bill.bill_no,
         gds_goods_skc.code
union all

--  退客处理
select wms_stock_out_bill.out_warehouse_date AS stock_date,    -- 日期
       wms_stock_out_bill.workflow_no        AS workflow_no,   -- 交易号
       wms_stock_out_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.code                     AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                    AS style_color,   -- 花号
       ''                                    AS coding,-- 编码
       ''                                    AS gb_coding,-- 国标码
       sum(wms_stockoutbill_goods.qty)       AS out_qty,       -- 出库数量
       ''                                    AS in_qty
from wms_stock_out_bill
         LEFT JOIN bas_customer on wms_stock_out_bill.business_party_id = bas_customer.id
         LEFT JOIN wms_stockoutbill_goods
                   on wms_stock_out_bill.id = wms_stockoutbill_goods.stockoutbill_id
         LEFT JOIN gds_singlproduct on wms_stockoutbill_goods.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where wms_stock_out_bill.status = '05'
--    and wms_stock_out_bill.business_type_id = 598903405221556317
group by wms_stock_out_bill.out_warehouse_date, -- 日期
         wms_stock_out_bill.workflow_no,        -- 交易号
         wms_stock_out_bill.bill_no,            -- 单据号码
         bas_customer.code,                     -- 客户/供应商名称
         gds_goods_skc.code
-- 花号
--                       ) T