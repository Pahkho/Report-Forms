-- -------------------------所有类型-合计--------------------------------
select ''              AS stock_date,    -- 日期
       ''              AS workflow_no,   -- 交易号
       ''              AS bill_no,       -- 单据号码
       T.customer_name as customer_name, -- 客户/供应商名称
       ''              AS style_color,   -- 花号
       ''              AS coding,        -- 编码
       ''              AS gb_coding,     -- 国标码
       sum(T.in_qty)   AS in_qty,        -- 入库数量
       sum(T.out_qty)  AS out_qty        -- 出库数量
from (
--  成品入库
         select ''                                     AS stock_date,    -- 日期
                ''                                     AS workflow_no,   -- 交易号
                ''                                     AS bill_no,       -- 单据号码
                bas_supplier.code                      as customer_name, -- 客户/供应商名称
                ''                                     AS style_color,   -- 花号
                ''                                     AS coding,        -- 编码
                ''                                     AS gb_coding,     -- 国标码
                sum(trade_purchase_bill_goods.pur_qty) AS in_qty,        -- 入库数量
                ''                                     AS out_qty        -- 出库数量
         from trade_purchase_bill
                  LEFT JOIN bas_supplier on trade_purchase_bill.supplier_id = bas_supplier.id -- 公司
                  LEFT JOIN trade_purchase_bill_goods
                            on trade_purchase_bill.id = trade_purchase_bill_goods.bill_id
         where trade_purchase_bill.delivery_status = '13'
           AND trade_purchase_bill.base_company_id = '10001'
           AND (trade_purchase_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by bas_supplier.code

         UNION ALL

--  退供应商
         select ''                                            AS stock_date,   -- 日期
                ''                                            AS workflow_no,  -- 交易号
                ''                                            AS bill_no,      -- 单据号码
                bas_supplier.name                             AS custmer_name, -- 客户/供应商名称
                ''                                            AS style_color,  -- 花号
                ''                                            AS coding,       -- 编码
                ''                                            AS gb_coding,    -- 国标码
                sum(trade_purchase_return_bill_goods.pur_qty) AS out_qty,      -- 出库数量
                ''                                            AS in_qty        -- 入库数量
         from trade_purchase_return_bill
                  left join bas_supplier on trade_purchase_return_bill.supplier_id = bas_supplier.id
                  left join trade_purchase_return_bill_goods
                            on trade_purchase_return_bill.id = trade_purchase_return_bill_goods.bill_id
         where trade_purchase_return_bill.delivery_status = 8
           AND trade_purchase_return_bill.base_company_id = '10001'
           AND (trade_purchase_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by bas_supplier.name -- 客户/供应商名称

         union all
--  发货单
         select ''                                 as stock_date,    -- 日期
                ''                                 as workflow_no,   -- 交易号
                ''                                 as bill_no,       -- 单据号码
                bas_customer.name                  as customer_name, -- 客户/供应商名称
                ''                                 as style_color,   -- 花号
                ''                                 as coding,        -- 编码
                ''                                 as gb_coding,     -- 国标码
                sum(trade_sale_bill_line.sale_qty) as out_qty,       -- 出库数量
                ''                                 AS in_qty         -- 入库数量
         from trade_sale_bill
                  left join bas_customer on trade_sale_bill.customer_id = bas_customer.id
                  left join trade_sale_bill_line on trade_sale_bill.id = trade_sale_bill_line.bill_id
         where trade_sale_bill.delivery_status = 8
           AND trade_sale_bill.sale_method = 'S'
           AND trade_sale_bill.base_company_id = 10001
           AND (trade_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by bas_customer.name -- 客户/供应商名称
         union all

--  换货
         select ''                                 AS stock_date,    -- 日期
                ''                                 AS workflow_no,   -- 交易号
                ''                                 AS bill_no,       -- 单据号码
                bas_customer.name                  AS customer_name, -- 客户/供应商
                ''                                 AS style_color,   -- 花号
                ''                                 AS coding,        -- 编码
                ''                                 AS gb_coding,     -- 国标码
                sum(trade_sale_bill_line.sale_qty) AS out_qty,       -- 出库数量
                ''                                 AS in_qty         -- 入库数量
         from trade_sale_bill
                  left join bas_customer on trade_sale_bill.customer_id = bas_customer.id
                  left join trade_sale_bill_line on trade_sale_bill.id = trade_sale_bill_line.bill_id
         where trade_sale_bill.delivery_status = 8
           AND trade_sale_bill.sale_method = 'C'
           AND trade_sale_bill.base_company_id = 10001
           AND (trade_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by bas_customer.name
         union all

--  溢亏
         select ''                  AS stock_date,    -- 日期
                ''                  AS workflow_no,   -- 交易号
                ''                  AS bill_no,       -- 单据号码
                ''                  AS customer_name, -- 客户/供应商名称
                ''                  AS style_color,   -- 花号
                ''                  AS coding,        -- 编码
                ''                  AS gb_coding,     -- 国标码
                sum(CASE
                        WHEN stk_stklogic_adjbill_detail.qty > 0 THEN stk_stklogic_adjbill_detail.qty
                        ELSE 0 END) AS in_qty,        -- 入库数量
                sum(CASE
                        WHEN stk_stklogic_adjbill_detail.qty < 0 THEN stk_stklogic_adjbill_detail.qty
                        ELSE 0 END) AS out_qty        -- 出库数量
         from stk_stock_logic_adjust_bill
                  left join bas_logic_warehouse
                            on stk_stock_logic_adjust_bill.warehouse_id = bas_logic_warehouse.id
                  left join stk_stklogic_adjbill_detail
                            on stk_stock_logic_adjust_bill.id = stk_stklogic_adjbill_detail.bill_id
         where stk_stock_logic_adjust_bill.bill_status = '05'
           AND bas_logic_warehouse.accounting_company_id = 10001
           AND (stk_stock_logic_adjust_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           -- AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         GROUP BY ''
         union all

--  代销调拨
         select ''                                    AS stock_date,    -- 日期
                ''                                    AS workflow_no,   -- 交易号
                ''                                    AS bill_no,       -- 单据号码
                bas_customer.name                     AS customer_name, -- 客户/供应商名称
                ''                                    AS style_color,   -- 花号
                ''                                    AS coding,-- 编码
                ''                                    AS gb_coding,-- 国标码
                ''                                    AS in_qty,        -- 入库数量
                sum(drp_cons_sale_bill_line.sale_qty) AS out_qty-- 出库数量
         from drp_cons_sale_bill
                  left join bas_customer on drp_cons_sale_bill.customer_id = bas_customer.id
                  left join drp_cons_sale_bill_line
                            on drp_cons_sale_bill.id = drp_cons_sale_bill_line.cons_sale_bill_id
         where drp_cons_sale_bill.bill_status = '05'
           and drp_cons_sale_bill.base_company_id = 10001
           AND (drp_cons_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by bas_customer.name -- 客户/供应商名称

         union all
--  代销退货
         select ''                                      AS stock_date,    -- 日期
                ''                                      AS workflow_no,   -- 交易号
                ''                                      AS bill_no,       -- 单据号码
                bas_customer.name                       AS customer_name, -- 客户/供应商名称
                ''                                      AS style_color,   -- 花号
                ''                                      AS coding,-- 编码
                ''                                      AS gb_coding,-- 国标码
                sum(drp_cons_return_bill_line.sale_qty) as in_qty,-- 入库数量
                ''                                      as out_qty        -- 出库数量
         from drp_cons_return_bill
                  left join bas_customer on drp_cons_return_bill.customer_id = bas_customer.id
                  left join drp_cons_return_bill_line
                            on drp_cons_return_bill.id = drp_cons_return_bill_line.cons_sale_return_bill_id
         where drp_cons_return_bill.bill_status = '05'
           and drp_cons_return_bill.base_company_id = 10001
           AND (drp_cons_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by bas_customer.name
         union all

--  经销退货
         select ''                                        AS stock_date,    -- 日期
                ''                                        AS workflow_no,   -- 交易号
                ''                                        AS bill_no,       -- 单据号码
                bas_customer.name                         AS customer_name, -- 客户/供应商名称
                ''                                        AS style_color,   -- 花号
                ''                                        AS coding,-- 编码
                ''                                        AS gb_coding,-- 国标码
                sum(trade_sale_return_bill_line.sale_qty) AS in_qty,        -- 入库数量
                ''                                        AS out_qty        -- 出库数量
         from trade_sale_return_bill
                  left join bas_customer on trade_sale_return_bill.customer_id = bas_customer.id
                  left join trade_sale_return_bill_line
                            on trade_sale_return_bill.id = trade_sale_return_bill_line.bill_id
         where trade_sale_return_bill.delivery_status = '13'
           AND trade_sale_return_bill.base_company_id = '10001'
           AND (trade_sale_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by bas_customer.name
         union all
--  仓库调拨
         select ''                                 AS stock_date,    -- 日期
                ''                                 AS workflow_no,   -- 交易号
                ''                                 AS bill_no,       -- 单据号码
                ''                                 AS customer_name, -- 客户/供应商名称
                ''                                 AS customer_name, -- 花号
                ''                                 AS coding,        -- 编码
                ''                                 AS gb_coding,     -- 国标码
                sum(stk_allocateoutbill_goods.qty) AS out_qty,       -- 出库数量
                ''                                 AS in_qty         -- 入库数量
         from stk_allocate_out_bill
                  left join stk_allocateoutbill_goods
                            on stk_allocate_out_bill.id = stk_allocateoutbill_goods.allocate_out_bill_id
         where stk_allocate_out_bill.status = '05'
           and stk_allocate_out_bill.stock_organization_out_id = 10001
           AND (stk_allocate_out_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           -- AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         GROUP BY ''
         union all
--  退客处理
         select ''                              AS stock_date,    -- 日期
                ''                              AS workflow_no,   -- 交易号
                ''                              AS bill_no,       -- 单据号码
                bas_customer.name               AS customer_name, -- 客户/供应商名称
                ''                              AS style_color,   -- 花号
                ''                              AS coding,-- 编码
                ''                              AS gb_coding,-- 国标码
                sum(wms_stockoutbill_goods.qty) AS out_qty,       -- 出库数量
                ''                              as in_qty
         from wms_stock_out_bill
                  left join bas_customer on wms_stock_out_bill.business_party_id = bas_customer.id
                  left join wms_stockoutbill_goods
                            on wms_stock_out_bill.id = wms_stockoutbill_goods.stockoutbill_id
         where wms_stock_out_bill.status = '05'
           and wms_stock_out_bill.business_type_id = 598903405221556317
           AND (wms_stock_out_bill.out_warehouse_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by bas_customer.name
     ) T
GROUP BY T.customer_name
UNION ALL
-- -----------------------------------所有类型-明细 -------------------------------------
select T.stock_date    AS stock_date,    -- 日期
       T.workflow_no   AS workflow_no,   -- 交易号
       T.bill_no       AS bill_no,       -- 单据号码
       T.customer_name AS customer_name, -- 客户/供应商名称
       T.style_color   AS style_color,   -- 花号
       ''              AS coding,        -- 编码
       ''              AS gb_coding,     -- 国标码
       sum(T.in_qty)   AS in_qty,        -- 入库数量
       sum(T.out_qty)  AS out_qty        -- 出库数量
from (
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
                  INNER JOIN bas_supplier on trade_purchase_bill.supplier_id = bas_supplier.id -- 公司
                  INNER JOIN trade_purchase_bill_goods
                             on trade_purchase_bill.id = trade_purchase_bill_goods.bill_id
                  INNER JOIN gds_singlproduct on trade_purchase_bill_goods.sku_id = gds_singlproduct.id
                  INNER JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         where trade_purchase_bill.delivery_status = '13'
           AND trade_purchase_bill.base_company_id = '10001'
           AND (trade_purchase_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
           AND ('2' IN ('${queryType}'))                    -- 查询类型
           AND ('0' IN ('${boundType}'))                    -- 出入库类型
           AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
         group by trade_purchase_bill.stock_date,  -- 日期
                  trade_purchase_bill.workflow_no, -- 交易号
                  trade_purchase_bill.bill_no,     -- 单据号码
                  bas_supplier.code,               -- 客户/供应商名称
                  gds_goods_skc.code               --
         union all

--  退供应商
         select trade_purchase_return_bill.stock_date         AS stock_date,   -- 日期
                trade_purchase_return_bill.workflow_no        AS workflow_no,  -- 交易号
                trade_purchase_return_bill.bill_no            AS bill_no,      -- 单据号码
                bas_supplier.name                             AS custmer_name, -- 客户/供应商名称
                gds_goods_skc.code                            AS style_color,  -- 花号
                ''                                            AS coding,       -- 编码
                ''                                            AS gb_coding,    -- 国标码
                sum(trade_purchase_return_bill_goods.pur_qty) AS out_qty,      -- 出库数量
                ''                                            AS in_qty        -- 入库数量
         from trade_purchase_return_bill
                  inner JOIN bas_supplier on trade_purchase_return_bill.supplier_id = bas_supplier.id
                  inner JOIN trade_purchase_return_bill_goods
                             on trade_purchase_return_bill.id = trade_purchase_return_bill_goods.bill_id
                  inner JOIN gds_singlproduct
                             on trade_purchase_return_bill_goods.sku_id = gds_singlproduct.id
                  inner JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         where trade_purchase_return_bill.delivery_status = 8
           AND trade_purchase_return_bill.base_company_id = '10001'
           AND (trade_purchase_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
           AND ('2' IN ('${queryType}'))                    -- 查询类型
           AND ('0' IN ('${boundType}'))                    -- 出入库类型
           AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
         group by trade_purchase_return_bill.stock_date,  -- 日期
                  trade_purchase_return_bill.workflow_no, -- 交易号
                  trade_purchase_return_bill.bill_no,     -- 单据号码
                  bas_supplier.name,                      -- 客户/供应商名称
                  gds_goods_skc.code
         union all
--  发货单
         select trade_sale_bill.stock_date         AS stock_date,    -- 日期
                trade_sale_bill.workflow_no        AS workflow_no,   -- 交易号
                trade_sale_bill.bill_no            AS bill_no,       -- 单据号码
                bas_customer.name                  AS customer_name, -- 客户/供应商名称
                gds_goods_skc.code                 AS style_color,   -- 花号
                ''                                 AS coding,        -- 编码
                ''                                 AS gb_coding,     -- 国标码
                ''                                 AS in_qty,        -- 入库数量
                sum(trade_sale_bill_line.sale_qty) AS out_qty        -- 出库数量
         from trade_sale_bill
                  INNER JOIN bas_customer on trade_sale_bill.customer_id = bas_customer.id
                  INNER JOIN trade_sale_bill_line on trade_sale_bill.id = trade_sale_bill_line.bill_id
                  INNER JOIN gds_singlproduct on trade_sale_bill_line.sku_id = gds_singlproduct.id
                  INNER JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         where trade_sale_bill.delivery_status = 8
           AND trade_sale_bill.sale_method = 'S'
           AND trade_sale_bill.base_company_id = 10001
           AND (trade_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('2' IN ('${queryType}'))                    -- 查询类型
           AND ('0' IN ('${boundType}'))                    -- 出入库类型
           AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
         group by trade_sale_bill.stock_date,  -- 日期
                  trade_sale_bill.workflow_no, -- 交易号
                  trade_sale_bill.bill_no,     -- 单据号码
                  bas_customer.name,           -- 客户/供应商名称
                  gds_goods_skc.code           -- 花号
         union all
--  换货单
         select trade_sale_bill.stock_date         AS stock_date,    -- 日期
                trade_sale_bill.workflow_no        AS workflow_no,   -- 交易号
                trade_sale_bill.bill_no            AS bill_no,       -- 单据号码
                bas_customer.name                  AS customer_name, -- 客户/供应商
                gds_goods_skc.code                 AS style_color,   -- 花号
                ''                                 AS coding,        -- 编码
                ''                                 AS gb_coding,     -- 国标码
                sum(trade_sale_bill_line.sale_qty) AS out_qty,       -- 出库数量
                ''                                 AS in_qty         -- 入库数量
         from trade_sale_bill
                  INNER JOIN bas_customer on trade_sale_bill.customer_id = bas_customer.id
                  INNER JOIN trade_sale_bill_line on trade_sale_bill.id = trade_sale_bill_line.bill_id
                  INNER JOIN gds_singlproduct on trade_sale_bill_line.sku_id = gds_singlproduct.id
                  INNER JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         where trade_sale_bill.delivery_status = 8
           AND trade_sale_bill.sale_method = 'C'
           AND trade_sale_bill.base_company_id = 10001
           AND (trade_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('2' IN ('${queryType}'))                    -- 查询类型
           AND ('0' IN ('${boundType}'))                    -- 出入库类型
           AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
         group by trade_sale_bill.stock_date,  -- 日期
                  trade_sale_bill.workflow_no, -- 交易号
                  trade_sale_bill.bill_no,     -- 单据号码
                  bas_customer.name,
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
                  INNER JOIN bas_logic_warehouse
                             on stk_stock_logic_adjust_bill.warehouse_id = bas_logic_warehouse.id
                  INNER JOIN stk_stklogic_adjbill_detail
                             on stk_stock_logic_adjust_bill.id = stk_stklogic_adjbill_detail.bill_id
                  INNER JOIN gds_singlproduct on stk_stklogic_adjbill_detail.sku_id = gds_singlproduct.id
                  LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         where stk_stock_logic_adjust_bill.bill_status = '05'
           AND bas_logic_warehouse.accounting_company_id = 10001
           AND (stk_stock_logic_adjust_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ('2' IN ('${queryType}'))                    -- 查询类型
           AND ('0' IN ('${boundType}'))                    -- 出入库类型
           AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
         group by stk_stock_logic_adjust_bill.stock_date,
                  stk_stock_logic_adjust_bill.workflow_no,
                  stk_stock_logic_adjust_bill.bill_no,
                  gds_goods_skc.code
         union all
--  代销调拨
         select drp_cons_sale_bill.stock_date         AS stock_date,    -- 日期
                drp_cons_sale_bill.workflow_no        AS workflow_no,   -- 交易号
                drp_cons_sale_bill.bill_no            AS bill_no,       -- 单据号码
                bas_customer.name                     AS customer_name, -- 客户/供应商名称
                gds_goods_skc.code                    AS style_color,   -- 花号
                ''                                    AS coding,        -- 编码
                ''                                    AS gb_coding,     -- 国标码
                ''                                    AS in_qty,        -- 入库数量
                sum(drp_cons_sale_bill_line.sale_qty) AS out_qty        -- 出库数量
         from drp_cons_sale_bill
                  INNER JOIN bas_customer on drp_cons_sale_bill.customer_id = bas_customer.id
                  INNER JOIN drp_cons_sale_bill_line
                             on drp_cons_sale_bill.id = drp_cons_sale_bill_line.cons_sale_bill_id
                  INNER JOIN gds_singlproduct on drp_cons_sale_bill_line.sku_id = gds_singlproduct.id
                  INNER JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         where drp_cons_sale_bill.bill_status = '05'
           and drp_cons_sale_bill.base_company_id = 10001
           AND (drp_cons_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('2' IN ('${queryType}'))                    -- 查询类型
           AND ('0' IN ('${boundType}'))                    -- 出入库类型
           AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
         group by drp_cons_sale_bill.stock_date,  -- 日期
                  drp_cons_sale_bill.workflow_no, -- 交易号
                  drp_cons_sale_bill.bill_no,     -- 单据号码
                  bas_customer.name,              -- 客户/供应商名称
                  gds_goods_skc.code              -- 花号
         union all
--  代销退货
         select drp_cons_return_bill.stock_date         AS stock_date,    -- 日期
                drp_cons_return_bill.workflow_no        AS workflow_no,   -- 交易号
                drp_cons_return_bill.bill_no            AS bill_no,       -- 单据号码
                bas_customer.name                       AS customer_name, -- 客户/供应商名称
                gds_goods_skc.code                      AS style_color,   -- 花号
                ''                                      AS coding,        -- 编码
                ''                                      AS gb_coding,     -- 国标码
                sum(drp_cons_return_bill_line.sale_qty) AS in_qty,        -- 入库数量
                ''                                      AS out_qty        -- 出库数量
         from drp_cons_return_bill
                  INNER JOIN bas_customer on drp_cons_return_bill.customer_id = bas_customer.id
                  INNER JOIN drp_cons_return_bill_line
                             on drp_cons_return_bill.id =
                                drp_cons_return_bill_line.cons_sale_return_bill_id
                  INNER JOIN gds_singlproduct on drp_cons_return_bill_line.sku_id = gds_singlproduct.id
                  INNER JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         where drp_cons_return_bill.bill_status = '05'
           and drp_cons_return_bill.base_company_id = 10001
           AND (drp_cons_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('2' IN ('${queryType}'))                    -- 查询类型
           AND ('0' IN ('${boundType}'))                    -- 出入库类型
           AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
         group by drp_cons_return_bill.stock_date,  -- 日期
                  drp_cons_return_bill.workflow_no, -- 交易号
                  drp_cons_return_bill.bill_no,     -- 单据号码
                  bas_customer.name,                -- 客户/供应商名称
                  gds_goods_skc.code                -- 花号
         union all

--  经销退货
         select trade_sale_return_bill.stock_date         AS stock_date,    -- 日期
                trade_sale_return_bill.workflow_no        AS workflow_no,   -- 交易号
                trade_sale_return_bill.bill_no            AS bill_no,       -- 单据号码
                bas_customer.name                         AS customer_name, -- 客户/供应商名称
                gds_goods_skc.code                        AS style_color,   -- 花号
                ''                                        AS coding,-- 编码
                ''                                        AS gb_coding,-- 国标码
                sum(trade_sale_return_bill_line.sale_qty) AS in_qty,        -- 入库数量
                ''                                        AS out_qty        -- 出库数量
         from trade_sale_return_bill
                  INNER JOIN bas_customer on trade_sale_return_bill.customer_id = bas_customer.id
                  INNER JOIN trade_sale_return_bill_line
                             on trade_sale_return_bill.id = trade_sale_return_bill_line.bill_id
                  INNER JOIN gds_singlproduct on trade_sale_return_bill_line.sku_id = gds_singlproduct.id
                  INNER JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         where trade_sale_return_bill.delivery_status = '13'
           AND trade_sale_return_bill.base_company_id = '10001'
           AND (trade_sale_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('2' IN ('${queryType}'))                    -- 查询类型
           AND ('0' IN ('${boundType}'))                    -- 出入库类型
           AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
         group by trade_sale_return_bill.stock_date,  -- 日期
                  trade_sale_return_bill.workflow_no, -- 交易号
                  trade_sale_return_bill.bill_no,     -- 单据号码
                  bas_customer.name,                  -- 客户/供应商名称
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
                  INNER JOIN stk_allocateoutbill_goods
                             on stk_allocate_out_bill.id = stk_allocateoutbill_goods.allocate_out_bill_id
                  INNER JOIN gds_singlproduct on stk_allocateoutbill_goods.sku_id = gds_singlproduct.id
                  INNER JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         where stk_allocate_out_bill.status = '05'
           and stk_allocate_out_bill.stock_organization_out_id = 10001
           AND (stk_allocate_out_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ('2' IN ('${queryType}'))                    -- 查询类型
           AND ('0' IN ('${boundType}'))                    -- 出入库类型
           AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
         group by stk_allocate_out_bill.stock_date,
                  stk_allocate_out_bill.workflow_no,
                  stk_allocate_out_bill.bill_no,
                  gds_goods_skc.code
         union all

--  退客处理
         select wms_stock_out_bill.out_warehouse_date AS stock_date,    -- 日期
                wms_stock_out_bill.workflow_no        AS workflow_no,   -- 交易号
                wms_stock_out_bill.bill_no            AS bill_no,       -- 单据号码
                bas_customer.name                     AS customer_name, -- 客户/供应商名称
                gds_goods_skc.code                    AS style_color,   -- 花号
                ''                                    AS coding,-- 编码
                ''                                    AS gb_coding,-- 国标码
                sum(wms_stockoutbill_goods.qty)       AS out_qty,       -- 出库数量
                ''                                    AS in_qty
         from wms_stock_out_bill
                  LEFT JOIN bas_customer on wms_stock_out_bill.business_party_id = bas_customer.id
                  INNER JOIN wms_stockoutbill_goods
                             on wms_stock_out_bill.id = wms_stockoutbill_goods.stockoutbill_id
                  INNER JOIN gds_singlproduct on wms_stockoutbill_goods.sku_id = gds_singlproduct.id
                  LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
         where wms_stock_out_bill.status = '05'
           and wms_stock_out_bill.business_type_id = 598903405221556317
           AND (wms_stock_out_bill.out_warehouse_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('2' IN ('${queryType}'))                    -- 查询类型
           AND ('0' IN ('${boundType}'))                    -- 出入库类型
           AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
         group by wms_stock_out_bill.out_warehouse_date, -- 日期
                  wms_stock_out_bill.workflow_no,        -- 交易号
                  wms_stock_out_bill.bill_no,            -- 单据号码
                  bas_customer.name,                     -- 客户/供应商名称
                  gds_goods_skc.code -- 花号
     ) T
GROUP BY T.stock_date,
         T.workflow_no,
         T.bill_no,
         T.customer_name, -- 客户/供应商名称
         T.style_color
UNION ALL
-- ---------------------------------所有类型-编码
--  成品入库
select T.stock_date    AS stock_date,    -- 日期
       T.workflow_no   AS workflow_no,   -- 交易号
       T.bill_no       AS bill_no,       -- 单据号码
       T.customer_name AS customer_name, -- 客户/供应商名称
       T.style_color   AS style_color,   -- 花号
       T.coding        AS coding,        -- 编码
       T.gb_coding     AS gb_coding,     -- 国标码
       SUM(T.in_qty)   AS in_qty,        -- 入库数量
       SUM(T.out_qty)  AS out_qty        -- 出库数量
from (
         select trade_purchase_bill.stock_date         AS stock_date,    -- 日期
                trade_purchase_bill.workflow_no        AS workflow_no,   -- 交易号
                trade_purchase_bill.bill_no            AS bill_no,       -- 单据号码
                bas_supplier.code                      AS customer_name, -- 客户/供应商名称
                ''                                     AS style_color,   -- 花号
                ''                                     AS coding,        -- 编码
                ''                                     AS gb_coding,     -- 国标码
                sum(trade_purchase_bill_goods.pur_qty) AS in_qty,        -- 入库数量
                ''                                     AS out_qty        -- 出库数量
         from trade_purchase_bill
                  LEFT JOIN bas_supplier on trade_purchase_bill.supplier_id = bas_supplier.id
                  LEFT JOIN trade_purchase_bill_goods on trade_purchase_bill.id = trade_purchase_bill_goods.bill_id
         where trade_purchase_bill.delivery_status = '13'
           AND trade_purchase_bill.base_company_id = '10001'
           AND (trade_purchase_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
           AND ('3' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by trade_purchase_bill.stock_date,  -- 日期
                  trade_purchase_bill.workflow_no, -- 交易号
                  trade_purchase_bill.bill_no,     -- 单据号码
                  bas_supplier.code                -- 客户/供应商名称
         union all

--  退供应商
         select trade_purchase_return_bill.stock_date         AS stock_date,   -- 日期
                trade_purchase_return_bill.workflow_no        AS workflow_no,  -- 交易号
                trade_purchase_return_bill.bill_no            AS bill_no,      -- 单据号码
                bas_supplier.name                             AS custmer_name, -- 客户/供应商名称
                ''                                            AS style_color,  -- 花号
                ''                                            AS coding,       -- 编码
                ''                                            AS gb_coding,    -- 国标码
                sum(trade_purchase_return_bill_goods.pur_qty) AS out_qty,      -- 出库数量
                ''                                            AS in_qty        -- 入库数量
         from trade_purchase_return_bill
                  left join bas_supplier on trade_purchase_return_bill.supplier_id = bas_supplier.id
                  left join trade_purchase_return_bill_goods
                            on trade_purchase_return_bill.id = trade_purchase_return_bill_goods.bill_id
         where trade_purchase_return_bill.delivery_status = 8
           AND trade_purchase_return_bill.base_company_id = '10001'
           AND trade_purchase_return_bill.base_company_id = '10001'
           AND (trade_purchase_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
           AND ('3' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by trade_purchase_return_bill.stock_date,  -- 日期
                  trade_purchase_return_bill.workflow_no, -- 交易号
                  trade_purchase_return_bill.bill_no,     -- 单据号码
                  bas_supplier.name                       -- 客户/供应商名称
         union all

--  发货单
         select trade_sale_bill.stock_date         as stock_date,    -- 日期
                trade_sale_bill.workflow_no        as workflow_no,   -- 交易号
                trade_sale_bill.bill_no            as bill_no,       -- 单据号码
                bas_customer.name                  as customer_name, -- 客户/供应商名称
                ''                                 as style_color,   -- 花号
                gds_singlproduct.code              as coding,        -- 编码
                gds_barcode.barcode                as gb_coding,     -- 国标码
                sum(trade_sale_bill_line.sale_qty) as out_qty,       -- 出库数量
                ''                                 AS in_qty         -- 入库数量
         from trade_sale_bill
                  left join bas_customer on trade_sale_bill.customer_id = bas_customer.id
                  left join trade_sale_bill_line on trade_sale_bill.id = trade_sale_bill_line.bill_id
                  left join gds_singlproduct on trade_sale_bill_line.sku_id = gds_singlproduct.id
                  left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
                  left join gds_barcode on trade_sale_bill_line.sku_id = gds_barcode.sku_id
             AND gds_barcode.type = 1 -- 国标条码
         where trade_sale_bill.delivery_status = 8
           AND trade_sale_bill.sale_method = 'S'
           AND trade_sale_bill.base_company_id = 10001
           AND (trade_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('3' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by trade_sale_bill.stock_date,  -- 日期
                  trade_sale_bill.workflow_no, -- 交易号
                  trade_sale_bill.bill_no,     -- 单据号码
                  bas_customer.name,           -- 客户/供应商名称
                  gds_singlproduct.code,       -- 编码
                  gds_barcode.barcode          -- 国标码
         union all
--  代销调拨
         select drp_cons_sale_bill.stock_date         AS stock_date,    -- 日期
                drp_cons_sale_bill.workflow_no        AS workflow_no,   -- 交易号
                drp_cons_sale_bill.bill_no            AS bill_no,       -- 单据号码
                bas_customer.name                     AS customer_name, -- 客户/供应商名称
                ''                                    AS style_color,   -- 花号
                gds_singlproduct.code                 AS coding,-- 编码
                gds_barcode.barcode                   AS gb_coding,-- 国标码
                ''                                    AS in_qty,        -- 入库数量
                sum(drp_cons_sale_bill_line.sale_qty) AS out_qty-- 出库数量
         from drp_cons_sale_bill
                  left join bas_customer on drp_cons_sale_bill.customer_id = bas_customer.id
                  left join drp_cons_sale_bill_line on drp_cons_sale_bill.id = drp_cons_sale_bill_line.cons_sale_bill_id
                  left join gds_singlproduct on drp_cons_sale_bill_line.sku_id = gds_singlproduct.id
                  left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
                  left join gds_barcode
                            on drp_cons_sale_bill_line.sku_id = gds_barcode.sku_id AND gds_barcode.type = 1 -- 国标条码
         where drp_cons_sale_bill.bill_status = '05'
           and drp_cons_sale_bill.base_company_id = 10001
           AND (drp_cons_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('3' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by drp_cons_sale_bill.stock_date,  -- 日期
                  drp_cons_sale_bill.workflow_no, -- 交易号
                  drp_cons_sale_bill.bill_no,     -- 单据号码
                  bas_customer.name,              -- 客户/供应商名称
                  gds_singlproduct.code,          -- 编码
                  gds_barcode.barcode             -- 国标码
         union all

--  代销退货
         select drp_cons_return_bill.stock_date         AS stock_date,    -- 日期
                drp_cons_return_bill.workflow_no        AS workflow_no,   -- 交易号
                drp_cons_return_bill.bill_no            AS bill_no,       -- 单据号码
                bas_customer.name                       AS customer_name, -- 客户/供应商名称
                ''                                      AS style_color,   -- 花号
                gds_singlproduct.code                   AS coding,-- 编码
                gds_barcode.barcode                     AS gb_coding,-- 国标码
                sum(drp_cons_return_bill_line.sale_qty) as in_qty,-- 入库数量
                ''                                      as out_qty        -- 出库数量
         from drp_cons_return_bill
                  left join bas_customer on drp_cons_return_bill.customer_id = bas_customer.id
                  left join drp_cons_return_bill_line
                            on drp_cons_return_bill.id = drp_cons_return_bill_line.cons_sale_return_bill_id
                  left join gds_singlproduct on drp_cons_return_bill_line.sku_id = gds_singlproduct.id
                  left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
                  left join gds_barcode on drp_cons_return_bill_line.sku_id = gds_barcode.sku_id
             AND gds_barcode.type = 1 -- 国标条码
         where drp_cons_return_bill.bill_status = '05'
           and drp_cons_return_bill.base_company_id = 10001
           AND (drp_cons_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('3' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by drp_cons_return_bill.stock_date,  -- 日期
                  drp_cons_return_bill.workflow_no, -- 交易号
                  drp_cons_return_bill.bill_no,     -- 单据号码
                  bas_customer.name,                -- 客户/供应商名称
                  gds_singlproduct.code,            -- 编码
                  gds_barcode.barcode               -- 国标码
         union all
--  经销退货
         select trade_sale_return_bill.stock_date         AS stock_date,    -- 日期
                trade_sale_return_bill.workflow_no        AS workflow_no,   -- 交易号
                trade_sale_return_bill.bill_no            AS bill_no,       -- 单据号码
                bas_customer.name                         AS customer_name, -- 客户/供应商名称
                ''                                        AS style_color,   -- 花号
                gds_singlproduct.code                     AS coding,-- 编码
                gds_barcode.barcode                       AS gb_coding,-- 国标码
                sum(trade_sale_return_bill_line.sale_qty) AS in_qty,        -- 入库数量
                ''                                        AS out_qty        -- 出库数量
         from trade_sale_return_bill
                  left join bas_customer on trade_sale_return_bill.customer_id = bas_customer.id
                  left join trade_sale_return_bill_line
                            on trade_sale_return_bill.id = trade_sale_return_bill_line.bill_id
                  left join gds_singlproduct on trade_sale_return_bill_line.sku_id = gds_singlproduct.id
                  left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
                  left join gds_barcode on trade_sale_return_bill_line.sku_id = gds_barcode.sku_id
             AND gds_barcode.type = 1 -- 国标条码
         where trade_sale_return_bill.delivery_status = '13'
           AND trade_sale_return_bill.base_company_id = '10001'
           AND (trade_sale_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
           AND ('3' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by trade_sale_return_bill.stock_date,  -- 日期
                  trade_sale_return_bill.workflow_no, -- 交易号
                  trade_sale_return_bill.bill_no,     -- 单据号码
                  bas_customer.name,                  -- 客户/供应商名称
                  gds_singlproduct.code,-- 编码
                  gds_barcode.barcode -- 国标码
     ) T
GROUP BY T.stock_date,    -- 日期
         T.workflow_no,   -- 交易号
         T.bill_no,       -- 单据号码
         T.customer_name, -- 客户/供应商名称
         T.coding,        -- 编码
         T.gb_coding -- 国标码
UNION ALL
-- -------------------------other-合计----------------------------------
--  成品入库
SELECT ''                                     AS stock_date,    -- 日期
       ''                                     AS workflow_no,   -- 交易号
       ''                                     AS bill_no,       -- 单据号码
       bas_supplier.code                      AS customer_name, -- 客户/供应商名称
       ''                                     AS style_color,   -- 花号
       ''                                     AS coding,        -- 编码
       ''                                     AS gb_coding,     -- 国标码
       sum(trade_purchase_bill_goods.pur_qty) AS in_qty,        -- 入库数量
       ''                                     AS out_qty        -- 出库数量
FROM trade_purchase_bill
         LEFT JOIN bas_supplier ON trade_purchase_bill.supplier_id = bas_supplier.id
         LEFT JOIN trade_purchase_bill_goods ON trade_purchase_bill.id = trade_purchase_bill_goods.bill_id
WHERE trade_purchase_bill.delivery_status = '13'
  AND trade_purchase_bill.base_company_id = '10001'
  AND (trade_purchase_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
  AND ('1' IN ('${queryType}')) -- 查询类型
  AND ('1' IN ('${boundType}')) -- 出入库类型
GROUP BY bas_supplier.code

UNION ALL

--  退供应商
SELECT ''                                            AS stock_date,   -- 日期
       ''                                            AS workflow_no,  -- 交易号
       ''                                            AS bill_no,      -- 单据号码
       bas_supplier.name                             AS custmer_name, -- 客户/供应商名称
       ''                                            AS style_color,  -- 花号
       ''                                            AS coding,       -- 编码
       ''                                            AS gb_coding,    -- 国标码
       sum(trade_purchase_return_bill_goods.pur_qty) AS out_qty,      -- 出库数量
       ''                                            AS in_qty        -- 入库数量
FROM trade_purchase_return_bill
         LEFT JOIN bas_supplier ON trade_purchase_return_bill.supplier_id = bas_supplier.id
         LEFT JOIN trade_purchase_return_bill_goods
                   ON trade_purchase_return_bill.id = trade_purchase_return_bill_goods.bill_id
WHERE trade_purchase_return_bill.delivery_status = 8
  AND trade_purchase_return_bill.base_company_id = '10001'
  AND (trade_purchase_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
  AND ('1' IN ('${queryType}')) -- 查询类型
  AND ('2' IN ('${boundType}')) -- 出入库类型
GROUP BY bas_supplier.name -- 客户/供应商名称

UNION ALL

--  发货单
SELECT ''                                 AS stock_date,    -- 日期
       ''                                 AS workflow_no,   -- 交易号
       ''                                 AS bill_no,       -- 单据号码
       bas_customer.name                  AS customer_name, -- 客户/供应商名称
       ''                                 AS style_color,   -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       sum(trade_sale_bill_line.sale_qty) AS out_qty,       -- 出库数量
       ''                                 AS in_qty         -- 入库数量
FROM trade_sale_bill
         LEFT JOIN bas_customer ON trade_sale_bill.customer_id = bas_customer.id
         LEFT JOIN trade_sale_bill_line ON trade_sale_bill.id = trade_sale_bill_line.bill_id
WHERE trade_sale_bill.delivery_status = 8
  AND trade_sale_bill.sale_method = 'S'
  AND trade_sale_bill.base_company_id = 10001
  AND (trade_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('1' IN ('${queryType}')) -- 查询类型
  AND ('3' IN ('${boundType}')) -- 出入库类型
GROUP BY bas_customer.name -- 客户/供应商名称
UNION ALL

--  换货单
SELECT ''                                 AS stock_date,    -- 日期
       ''                                 AS workflow_no,   -- 交易号
       ''                                 AS bill_no,       -- 单据号码
       bas_customer.name                  AS customer_name, -- 客户/供应商
       ''                                 AS style_color,   -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       sum(trade_sale_bill_line.sale_qty) AS out_qty,       -- 出库数量
       ''                                 AS in_qty         -- 入库数量
FROM trade_sale_bill
         LEFT JOIN bas_customer ON trade_sale_bill.customer_id = bas_customer.id
         LEFT JOIN trade_sale_bill_line ON trade_sale_bill.id = trade_sale_bill_line.bill_id
WHERE trade_sale_bill.delivery_status = 8
  AND trade_sale_bill.sale_method = 'C'
  AND trade_sale_bill.base_company_id = 10001
  AND (trade_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('1' IN ('${queryType}')) -- 查询类型
  AND ('4' IN ('${boundType}')) -- 出入库类型
GROUP BY bas_customer.name
UNION ALL

--  溢亏
SELECT ''                  AS stock_date,    -- 日期
       ''                  AS workflow_no,   -- 交易号
       ''                  AS bill_no,       -- 单据号码
       ''                  AS customer_name, -- 客户/供应商名称
       ''                  AS style_color,   -- 花号
       ''                  AS coding,        -- 编码
       ''                  AS gb_coding,     -- 国标码
       sum(CASE
               WHEN stk_stklogic_adjbill_detail.qty > 0 THEN stk_stklogic_adjbill_detail.qty
               ELSE 0 END) AS in_qty,        -- 入库数量
       sum(CASE
               WHEN stk_stklogic_adjbill_detail.qty < 0 THEN stk_stklogic_adjbill_detail.qty
               ELSE 0 END) AS out_qty        -- 出库数量
FROM stk_stock_logic_adjust_bill
         LEFT JOIN bas_logic_warehouse ON stk_stock_logic_adjust_bill.warehouse_id = bas_logic_warehouse.id
         LEFT JOIN stk_stklogic_adjbill_detail ON stk_stock_logic_adjust_bill.id = stk_stklogic_adjbill_detail.bill_id
WHERE stk_stock_logic_adjust_bill.bill_status = '05'
  AND bas_logic_warehouse.accounting_company_id = 10001
  AND (stk_stock_logic_adjust_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ('1' IN ('${queryType}')) -- 查询类型
  AND ('5' IN ('${boundType}')) -- 出入库类型
GROUP BY ''

UNION ALL

--  代销调拨
SELECT ''                                    AS stock_date,    -- 日期
       ''                                    AS workflow_no,   -- 交易号
       ''                                    AS bill_no,       -- 单据号码
       bas_customer.name                     AS customer_name, -- 客户/供应商名称
       ''                                    AS style_color,   -- 花号
       ''                                    AS coding,-- 编码
       ''                                    AS gb_coding,-- 国标码
       ''                                    AS in_qty,        -- 入库数量
       sum(drp_cons_sale_bill_line.sale_qty) AS out_qty-- 出库数量
FROM drp_cons_sale_bill
         LEFT JOIN bas_customer ON drp_cons_sale_bill.customer_id = bas_customer.id
         LEFT JOIN drp_cons_sale_bill_line ON drp_cons_sale_bill.id = drp_cons_sale_bill_line.cons_sale_bill_id
WHERE drp_cons_sale_bill.bill_status = '05'
  AND drp_cons_sale_bill.base_company_id = 10001
  AND (drp_cons_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('1' IN ('${queryType}')) -- 查询类型
  AND ('6' IN ('${boundType}')) -- 出入库类型
GROUP BY bas_customer.name -- 客户/供应商名称

UNION ALL
--  代销退货
SELECT ''                                      AS stock_date,    -- 日期
       ''                                      AS workflow_no,   -- 交易号
       ''                                      AS bill_no,       -- 单据号码
       bas_customer.name                       AS customer_name, -- 客户/供应商名称
       ''                                      AS style_color,   -- 花号
       ''                                      AS coding,-- 编码
       ''                                      AS gb_coding,-- 国标码
       sum(drp_cons_return_bill_line.sale_qty) AS in_qty,-- 入库数量
       ''                                      AS out_qty        -- 出库数量
FROM drp_cons_return_bill
         LEFT JOIN bas_customer ON drp_cons_return_bill.customer_id = bas_customer.id
         LEFT JOIN drp_cons_return_bill_line
                   ON drp_cons_return_bill.id = drp_cons_return_bill_line.cons_sale_return_bill_id
WHERE drp_cons_return_bill.bill_status = '05'
  AND drp_cons_return_bill.base_company_id = 10001
  AND (drp_cons_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('1' IN ('${queryType}')) -- 查询类型
  AND ('7' IN ('${boundType}')) -- 出入库类型
GROUP BY bas_customer.name
UNION ALL

--  经销退货
SELECT ''                                        AS stock_date,    -- 日期
       ''                                        AS workflow_no,   -- 交易号
       ''                                        AS bill_no,       -- 单据号码
       bas_customer.name                         AS customer_name, -- 客户/供应商名称
       ''                                        AS style_color,   -- 花号
       ''                                        AS coding,-- 编码
       ''                                        AS gb_coding,-- 国标码
       sum(trade_sale_return_bill_line.sale_qty) AS in_qty,        -- 入库数量
       ''                                        AS out_qty        -- 出库数量
FROM trade_sale_return_bill
         LEFT JOIN bas_customer ON trade_sale_return_bill.customer_id = bas_customer.id
         LEFT JOIN trade_sale_return_bill_line ON trade_sale_return_bill.id = trade_sale_return_bill_line.bill_id
WHERE trade_sale_return_bill.delivery_status = '13'
  AND trade_sale_return_bill.base_company_id = '10001'
  AND (trade_sale_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('1' IN ('${queryType}')) -- 查询类型
  AND ('8' IN ('${boundType}')) -- 出入库类型
GROUP BY bas_customer.name
UNION ALL
--  仓库调拨
SELECT ''                                 AS stock_date,    -- 日期
       ''                                 AS workflow_no,   -- 交易号
       ''                                 AS bill_no,       -- 单据号码
       ''                                 AS customer_name, -- 客户/供应商名称
       ''                                 AS customer_name, -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       sum(stk_allocateoutbill_goods.qty) AS out_qty,       -- 出库数量
       ''                                 AS in_qty         -- 入库数量
FROM stk_allocate_out_bill
         LEFT JOIN stk_allocateoutbill_goods
                   ON stk_allocate_out_bill.id = stk_allocateoutbill_goods.allocate_out_bill_id
WHERE stk_allocate_out_bill.status = '05'
  AND stk_allocate_out_bill.stock_organization_out_id = 10001
  AND (stk_allocate_out_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ('1' IN ('${queryType}')) -- 查询类型
  AND ('9' IN ('${boundType}')) -- 出入库类型
GROUP BY ''
UNION ALL

--  退客处理
SELECT ''                              AS stock_date,    -- 日期
       ''                              AS workflow_no,   -- 交易号
       ''                              AS bill_no,       -- 单据号码
       bas_customer.name               AS customer_name, -- 客户/供应商名称
       ''                              AS style_color,   -- 花号
       ''                              AS coding,-- 编码
       ''                              AS gb_coding,-- 国标码
       sum(wms_stockoutbill_goods.qty) AS out_qty,       -- 出库数量
       ''                              AS in_qty
FROM wms_stock_out_bill
         LEFT JOIN bas_customer ON wms_stock_out_bill.business_party_id = bas_customer.id
         LEFT JOIN wms_stockoutbill_goods ON wms_stock_out_bill.id = wms_stockoutbill_goods.stockoutbill_id
WHERE wms_stock_out_bill.status = '05'
  AND wms_stock_out_bill.business_type_id = 598903405221556317
  AND (wms_stock_out_bill.out_warehouse_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('1' IN ('${queryType}'))  -- 查询类型
  AND ('10' IN ('${boundType}')) -- 出入库类型
GROUP BY bas_customer.name


UNION ALL

-- ----------------------------- 明细 ------------------------------------
--  成品入库
SELECT trade_purchase_bill.stock_date         AS stock_date,    -- 日期
       trade_purchase_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_purchase_bill.bill_no            AS bill_no,       -- 单据号码
       bas_supplier.code                      AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                     AS style_color,   -- 花号
       ''                                     AS coding,        -- 编码
       ''                                     AS gb_coding,     -- 国标码
       sum(trade_purchase_bill_goods.pur_qty) AS in_qty,        -- 入库数量
       ''                                     AS out_qty        -- 出库数量
FROM trade_purchase_bill
         LEFT JOIN bas_supplier ON trade_purchase_bill.supplier_id = bas_supplier.id -- 公司
         LEFT JOIN trade_purchase_bill_goods
                   ON trade_purchase_bill.id = trade_purchase_bill_goods.bill_id
         LEFT JOIN gds_singlproduct ON trade_purchase_bill_goods.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
WHERE trade_purchase_bill.delivery_status = '13'
  AND trade_purchase_bill.base_company_id = '10001'
  AND (trade_purchase_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
  AND ('2' IN ('${queryType}'))                    -- 查询类型
  AND ('1' IN ('${boundType}'))                    -- 出入库类型
  AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
GROUP BY trade_purchase_bill.stock_date,  -- 日期
         trade_purchase_bill.workflow_no, -- 交易号
         trade_purchase_bill.bill_no,     -- 单据号码
         bas_supplier.code,               -- 客户/供应商名称
         gds_goods_skc.code               -- 花号
UNION ALL

--  退供应商
SELECT trade_purchase_return_bill.stock_date         AS stock_date,   -- 日期
       trade_purchase_return_bill.workflow_no        AS workflow_no,  -- 交易号
       trade_purchase_return_bill.bill_no            AS bill_no,      -- 单据号码
       bas_supplier.name                             AS custmer_name, -- 客户/供应商名称
       gds_goods_skc.code                            AS style_color,  -- 花号
       ''                                            AS coding,       -- 编码
       ''                                            AS gb_coding,    -- 国标码
       sum(trade_purchase_return_bill_goods.pur_qty) AS out_qty,      -- 出库数量
       ''                                            AS in_qty        -- 入库数量
FROM trade_purchase_return_bill
         LEFT JOIN bas_supplier ON trade_purchase_return_bill.supplier_id = bas_supplier.id
         LEFT JOIN trade_purchase_return_bill_goods
                   ON trade_purchase_return_bill.id = trade_purchase_return_bill_goods.bill_id
         LEFT JOIN gds_singlproduct
                   ON trade_purchase_return_bill_goods.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
WHERE trade_purchase_return_bill.delivery_status = 8
  AND trade_purchase_return_bill.base_company_id = '10001'
  AND (trade_purchase_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
  AND ('2' IN ('${queryType}'))                    -- 查询类型
  AND ('2' IN ('${boundType}'))                    -- 出入库类型
  AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
GROUP BY trade_purchase_return_bill.stock_date,  -- 日期
         trade_purchase_return_bill.workflow_no, -- 交易号
         trade_purchase_return_bill.bill_no,     -- 单据号码
         bas_supplier.name,                      -- 客户/供应商名称
         gds_goods_skc.code
UNION ALL
--  发货单
SELECT trade_sale_bill.stock_date         AS stock_date,    -- 日期
       trade_sale_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_sale_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.name                  AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                 AS style_color,   -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       ''                                 AS in_qty,        -- 入库数量
       sum(trade_sale_bill_line.sale_qty) AS out_qty        -- 出库数量
FROM trade_sale_bill
         LEFT JOIN bas_customer ON trade_sale_bill.customer_id = bas_customer.id
         LEFT JOIN trade_sale_bill_line ON trade_sale_bill.id = trade_sale_bill_line.bill_id
         LEFT JOIN gds_singlproduct ON trade_sale_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
         LEFT JOIN gds_barcode ON trade_sale_bill_line.sku_id = gds_barcode.sku_id
    AND gds_barcode.type = 1 -- 国标条码
WHERE trade_sale_bill.delivery_status = 8
  AND trade_sale_bill.sale_method = 'S'
  AND trade_sale_bill.base_company_id = 10001
  AND (trade_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('2' IN ('${queryType}'))                    -- 查询类型
  AND ('3' IN ('${boundType}'))                    -- 出入库类型
  AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
GROUP BY trade_sale_bill.stock_date,  -- 日期
         trade_sale_bill.workflow_no, -- 交易号
         trade_sale_bill.bill_no,     -- 单据号码
         bas_customer.name,           -- 客户/供应商名称
         gds_goods_skc.code           -- 花号
UNION ALL

--  换货单
SELECT trade_sale_bill.stock_date         AS stock_date,    -- 日期
       trade_sale_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_sale_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.name                  AS customer_name, -- 客户/供应商
       gds_goods_skc.code                 AS style_color,   -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       sum(trade_sale_bill_line.sale_qty) AS out_qty,       -- 出库数量
       ''                                 AS in_qty         -- 入库数量
FROM trade_sale_bill
         LEFT JOIN bas_customer ON trade_sale_bill.customer_id = bas_customer.id
         LEFT JOIN trade_sale_bill_line ON trade_sale_bill.id = trade_sale_bill_line.bill_id
         LEFT JOIN gds_singlproduct ON trade_sale_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
WHERE trade_sale_bill.delivery_status = 8
  AND trade_sale_bill.sale_method = 'C'
  AND trade_sale_bill.base_company_id = 10001
  AND (trade_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('2' IN ('${queryType}'))                    -- 查询类型
  AND ('4' IN ('${boundType}'))                    -- 出入库类型
  AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
GROUP BY trade_sale_bill.stock_date,  -- 日期
         trade_sale_bill.workflow_no, -- 交易号
         trade_sale_bill.bill_no,     -- 单据号码
         bas_customer.name,
         gds_goods_skc.code
UNION ALL
--  溢亏
SELECT stk_stock_logic_adjust_bill.stock_date  AS stock_date,    -- 日期
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
FROM stk_stock_logic_adjust_bill
         INNER JOIN bas_logic_warehouse
                   ON stk_stock_logic_adjust_bill.warehouse_id = bas_logic_warehouse.id
         INNER JOIN stk_stklogic_adjbill_detail
                   ON stk_stock_logic_adjust_bill.id = stk_stklogic_adjbill_detail.bill_id
         INNER JOIN gds_singlproduct ON stk_stklogic_adjbill_detail.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
WHERE stk_stock_logic_adjust_bill.bill_status = '05'
  AND bas_logic_warehouse.accounting_company_id = 10001
  AND (stk_stock_logic_adjust_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ('2' IN ('${queryType}'))                    -- 查询类型
  AND ('5' IN ('${boundType}'))                    -- 出入库类型
  AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
GROUP BY stk_stock_logic_adjust_bill.stock_date,
         stk_stock_logic_adjust_bill.workflow_no,
         stk_stock_logic_adjust_bill.bill_no,
         gds_goods_skc.code
UNION ALL

--  代销调拨
SELECT drp_cons_sale_bill.stock_date         AS stock_date,    -- 日期
       drp_cons_sale_bill.workflow_no        AS workflow_no,   -- 交易号
       drp_cons_sale_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.name                     AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                    AS style_color,   -- 花号
       ''                                    AS coding,        -- 编码
       ''                                    AS gb_coding,     -- 国标码
       ''                                    AS in_qty,        -- 入库数量
       sum(drp_cons_sale_bill_line.sale_qty) AS out_qty        -- 出库数量
FROM drp_cons_sale_bill
         LEFT JOIN bas_customer ON drp_cons_sale_bill.customer_id = bas_customer.id
         LEFT JOIN drp_cons_sale_bill_line
                   ON drp_cons_sale_bill.id = drp_cons_sale_bill_line.cons_sale_bill_id
         LEFT JOIN gds_singlproduct ON drp_cons_sale_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
         LEFT JOIN gds_barcode ON drp_cons_sale_bill_line.sku_id = gds_barcode.sku_id AND
                                  gds_barcode.type = 1 -- 国标条码
WHERE drp_cons_sale_bill.bill_status = '05'
  AND drp_cons_sale_bill.base_company_id = 10001
  AND (drp_cons_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('2' IN ('${queryType}'))                    -- 查询类型
  AND ('6' IN ('${boundType}'))                    -- 出入库类型
  AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
GROUP BY drp_cons_sale_bill.stock_date,  -- 日期
         drp_cons_sale_bill.workflow_no, -- 交易号
         drp_cons_sale_bill.bill_no,     -- 单据号码
         bas_customer.name,              -- 客户/供应商名称
         gds_goods_skc.code              -- 花号
UNION ALL

--  代销退货
SELECT drp_cons_return_bill.stock_date         AS stock_date,    -- 日期
       drp_cons_return_bill.workflow_no        AS workflow_no,   -- 交易号
       drp_cons_return_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.name                       AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                      AS style_color,   -- 花号
       ''                                      AS coding,        -- 编码
       ''                                      AS gb_coding,     -- 国标码
       sum(drp_cons_return_bill_line.sale_qty) AS in_qty,        -- 入库数量
       ''                                      AS out_qty        -- 出库数量
FROM drp_cons_return_bill
         LEFT JOIN bas_customer ON drp_cons_return_bill.customer_id = bas_customer.id
         LEFT JOIN drp_cons_return_bill_line
                   ON drp_cons_return_bill.id =
                      drp_cons_return_bill_line.cons_sale_return_bill_id
         LEFT JOIN gds_singlproduct ON drp_cons_return_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
         LEFT JOIN gds_barcode ON drp_cons_return_bill_line.sku_id = gds_barcode.sku_id
    AND gds_barcode.type = 1 -- 国标条码
WHERE drp_cons_return_bill.bill_status = '05'
  AND drp_cons_return_bill.base_company_id = 10001
  AND (drp_cons_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('2' IN ('${queryType}'))                    -- 查询类型
  AND ('7' IN ('${boundType}'))                    -- 出入库类型
  AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
GROUP BY drp_cons_return_bill.stock_date,  -- 日期
         drp_cons_return_bill.workflow_no, -- 交易号
         drp_cons_return_bill.bill_no,     -- 单据号码
         bas_customer.name,                -- 客户/供应商名称
         gds_goods_skc.code                -- 花号
UNION ALL

--  经销退货
SELECT trade_sale_return_bill.stock_date         AS stock_date,    -- 日期
       trade_sale_return_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_sale_return_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.name                         AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                        AS style_color,   -- 花号
       ''                                        AS coding,-- 编码
       ''                                        AS gb_coding,-- 国标码
       sum(trade_sale_return_bill_line.sale_qty) AS in_qty,        -- 入库数量
       ''                                        AS out_qty        -- 出库数量
FROM trade_sale_return_bill
         LEFT JOIN bas_customer ON trade_sale_return_bill.customer_id = bas_customer.id
         LEFT JOIN trade_sale_return_bill_line
                   ON trade_sale_return_bill.id = trade_sale_return_bill_line.bill_id
         LEFT JOIN gds_singlproduct ON trade_sale_return_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
WHERE trade_sale_return_bill.delivery_status = '13'
  AND trade_sale_return_bill.base_company_id = '10001'
  AND (trade_sale_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('2' IN ('${queryType}'))                    -- 查询类型
  AND ('8' IN ('${boundType}'))                    -- 出入库类型
  AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
GROUP BY trade_sale_return_bill.stock_date,  -- 日期
         trade_sale_return_bill.workflow_no, -- 交易号
         trade_sale_return_bill.bill_no,     -- 单据号码
         bas_customer.name,                  -- 客户/供应商名称
         gds_goods_skc.code                  -- 花号
UNION ALL

--  仓库调拨
SELECT stk_allocate_out_bill.stock_date   AS stock_date,    -- 日期
       stk_allocate_out_bill.workflow_no  AS workflow_no,   -- 交易号
       stk_allocate_out_bill.bill_no      AS bill_no,       -- 单据号码
       ''                                 AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                 AS style_color,   -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       sum(stk_allocateoutbill_goods.qty) AS out_qty,       -- 出库数量
       ''                                 AS in_qty         -- 入库数量
FROM stk_allocate_out_bill
         LEFT JOIN stk_allocateoutbill_goods
                   ON stk_allocate_out_bill.id = stk_allocateoutbill_goods.allocate_out_bill_id
         LEFT JOIN gds_singlproduct ON stk_allocateoutbill_goods.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
WHERE stk_allocate_out_bill.status = '05'
  AND stk_allocate_out_bill.stock_organization_out_id = 10001
   AND (stk_allocate_out_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
   AND ('2' IN ('${queryType}'))                    -- 查询类型
   AND ('9' IN ('${boundType}'))                    -- 出入库类型
   AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
GROUP BY stk_allocate_out_bill.stock_date,
         stk_allocate_out_bill.workflow_no,
         stk_allocate_out_bill.bill_no,
         gds_goods_skc.code
UNION ALL

--  退客处理
SELECT wms_stock_out_bill.out_warehouse_date AS stock_date,    -- 日期
       wms_stock_out_bill.workflow_no        AS workflow_no,   -- 交易号
       wms_stock_out_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.name                     AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                    AS style_color,   -- 花号
       ''                                    AS coding,-- 编码
       ''                                    AS gb_coding,-- 国标码
       sum(wms_stockoutbill_goods.qty)       AS out_qty,       -- 出库数量
       ''                                    AS in_qty
FROM wms_stock_out_bill
         LEFT JOIN bas_customer ON wms_stock_out_bill.business_party_id = bas_customer.id
         LEFT JOIN wms_stockoutbill_goods
                   ON wms_stock_out_bill.id = wms_stockoutbill_goods.stockoutbill_id
         LEFT JOIN gds_singlproduct ON wms_stockoutbill_goods.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
WHERE wms_stock_out_bill.status = '05'
  AND wms_stock_out_bill.business_type_id = 598903405221556317
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND (wms_stock_out_bill.out_warehouse_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ('2' IN ('${queryType}'))                    -- 查询类型
  AND ('10' IN ('${boundType}'))                   -- 出入库类型
  AND gds_goods_skc.code LIKE ('%${decor}%') -- 花号
GROUP BY wms_stock_out_bill.out_warehouse_date, -- 日期
         wms_stock_out_bill.workflow_no,        -- 交易号
         wms_stock_out_bill.bill_no,            -- 单据号码
         bas_customer.name,                     -- 客户/供应商名称
         gds_goods_skc.code                     -- 花号
UNION ALL
-- -------------------------------- 编码----------------------------------------
--  成品入库
SELECT trade_purchase_bill.stock_date         AS stock_date,    -- 日期
       trade_purchase_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_purchase_bill.bill_no            AS bill_no,       -- 单据号码
       bas_supplier.name                      AS customer_name, -- 客户/供应商名称
       ''                                     AS style_color,   -- 花号
       ''                                     AS coding,        -- 编码
       ''                                     AS gb_coding,     -- 国标码
       sum(trade_purchase_bill_goods.pur_qty) AS in_qty,        -- 入库数量
       ''                                     AS out_qty        -- 出库数量
FROM trade_purchase_bill
         LEFT JOIN bas_supplier ON trade_purchase_bill.supplier_id = bas_supplier.id
         LEFT JOIN trade_purchase_bill_goods ON trade_purchase_bill.id = trade_purchase_bill_goods.bill_id
WHERE trade_purchase_bill.delivery_status = '13'
  AND trade_purchase_bill.base_company_id = '10001'
  AND (trade_purchase_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
  AND ('3' IN ('${queryType}')) -- 查询类型
  AND ('1' IN ('${boundType}')) -- 出入库类型
GROUP BY trade_purchase_bill.stock_date,  -- 日期
         trade_purchase_bill.workflow_no, -- 交易号
         trade_purchase_bill.bill_no,     -- 单据号码
         bas_supplier.name                -- 客户/供应商名称
UNION ALL

--  退供应商
SELECT trade_purchase_return_bill.stock_date         AS stock_date,   -- 日期
       trade_purchase_return_bill.workflow_no        AS workflow_no,  -- 交易号
       trade_purchase_return_bill.bill_no            AS bill_no,      -- 单据号码
       bas_supplier.name                             AS custmer_name, -- 客户/供应商名称
       ''                                            AS style_color,  -- 花号
       ''                                            AS coding,       -- 编码
       ''                                            AS gb_coding,    -- 国标码
       sum(trade_purchase_return_bill_goods.pur_qty) AS out_qty,      -- 出库数量
       ''                                            AS in_qty        -- 入库数量
FROM trade_purchase_return_bill
         LEFT JOIN bas_supplier ON trade_purchase_return_bill.supplier_id = bas_supplier.id
         LEFT JOIN trade_purchase_return_bill_goods
                   ON trade_purchase_return_bill.id = trade_purchase_return_bill_goods.bill_id
WHERE trade_purchase_return_bill.delivery_status = 8
  AND trade_purchase_return_bill.base_company_id = '10001'
  AND trade_purchase_return_bill.base_company_id = '10001'
  AND (trade_purchase_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_supplier.name LIKE '%${customerOrSupplierName}%') OR (bas_supplier.code LIKE '%${customerOrSupplierName}%'))
  AND ('3' IN ('${queryType}')) -- 查询类型
  AND ('2' IN ('${boundType}')) -- 出入库类型
GROUP BY trade_purchase_return_bill.stock_date,  -- 日期
         trade_purchase_return_bill.workflow_no, -- 交易号
         trade_purchase_return_bill.bill_no,     -- 单据号码
         bas_supplier.name                       -- 客户/供应商名称
UNION ALL

--  发货单
SELECT trade_sale_bill.stock_date         AS stock_date,    -- 日期
       trade_sale_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_sale_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.name                  AS customer_name, -- 客户/供应商名称
       ''                                 AS style_color,   -- 花号
       gds_singlproduct.code              AS coding,        -- 编码
       gds_barcode.barcode                AS gb_coding,     -- 国标码
       sum(trade_sale_bill_line.sale_qty) AS out_qty,       -- 出库数量
       ''                                 AS in_qty         -- 入库数量
FROM trade_sale_bill
         LEFT JOIN bas_customer ON trade_sale_bill.customer_id = bas_customer.id
         LEFT JOIN trade_sale_bill_line ON trade_sale_bill.id = trade_sale_bill_line.bill_id
         LEFT JOIN gds_singlproduct ON trade_sale_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
         LEFT JOIN gds_barcode ON trade_sale_bill_line.sku_id = gds_barcode.sku_id
    AND gds_barcode.type = 1 -- 国标条码
WHERE trade_sale_bill.delivery_status = 8
  AND trade_sale_bill.sale_method = 'S'
  AND trade_sale_bill.base_company_id = 10001
  AND (trade_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('3' IN ('${queryType}')) -- 查询类型
  AND ('3' IN ('${boundType}')) -- 出入库类型
GROUP BY trade_sale_bill.stock_date,  -- 日期
         trade_sale_bill.workflow_no, -- 交易号
         trade_sale_bill.bill_no,     -- 单据号码
         bas_customer.name,           -- 客户/供应商名称
         gds_singlproduct.code,       -- 编码
         gds_barcode.barcode          -- 国标码
UNION ALL

--  代销调拨
SELECT drp_cons_sale_bill.stock_date         AS stock_date,    -- 日期
       drp_cons_sale_bill.workflow_no        AS workflow_no,   -- 交易号
       drp_cons_sale_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.name                     AS customer_name, -- 客户/供应商名称
       ''                                    AS style_color,   -- 花号
       gds_singlproduct.code                 AS coding,-- 编码
       gds_barcode.barcode                   AS gb_coding,-- 国标码
       ''                                    AS in_qty,        -- 入库数量
       sum(drp_cons_sale_bill_line.sale_qty) AS out_qty-- 出库数量
FROM drp_cons_sale_bill
         LEFT JOIN bas_customer ON drp_cons_sale_bill.customer_id = bas_customer.id
         LEFT JOIN drp_cons_sale_bill_line ON drp_cons_sale_bill.id = drp_cons_sale_bill_line.cons_sale_bill_id
         LEFT JOIN gds_singlproduct ON drp_cons_sale_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
         LEFT JOIN gds_barcode ON drp_cons_sale_bill_line.sku_id = gds_barcode.sku_id AND gds_barcode.type = 1 -- 国标条码
WHERE drp_cons_sale_bill.bill_status = '05'
  AND drp_cons_sale_bill.base_company_id = 10001
  AND (drp_cons_sale_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('3' IN ('${queryType}')) -- 查询类型
  AND ('6' IN ('${boundType}')) -- 出入库类型
GROUP BY drp_cons_sale_bill.stock_date,  -- 日期
         drp_cons_sale_bill.workflow_no, -- 交易号
         drp_cons_sale_bill.bill_no,     -- 单据号码
         bas_customer.name,              -- 客户/供应商名称
         gds_singlproduct.code,          -- 编码
         gds_barcode.barcode             -- 国标码
UNION ALL

--  代销退货
SELECT drp_cons_return_bill.stock_date         AS stock_date,    -- 日期
       drp_cons_return_bill.workflow_no        AS workflow_no,   -- 交易号
       drp_cons_return_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.name                       AS customer_name, -- 客户/供应商名称
       ''                                      AS style_color,   -- 花号
       gds_singlproduct.code                   AS coding,-- 编码
       gds_barcode.barcode                     AS gb_coding,-- 国标码
       sum(drp_cons_return_bill_line.sale_qty) AS in_qty,-- 入库数量
       ''                                      AS out_qty        -- 出库数量
FROM drp_cons_return_bill
         LEFT JOIN bas_customer ON drp_cons_return_bill.customer_id = bas_customer.id
         LEFT JOIN drp_cons_return_bill_line
                   ON drp_cons_return_bill.id = drp_cons_return_bill_line.cons_sale_return_bill_id
         LEFT JOIN gds_singlproduct ON drp_cons_return_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
         LEFT JOIN gds_barcode ON drp_cons_return_bill_line.sku_id = gds_barcode.sku_id
    AND gds_barcode.type = 1 -- 国标条码
WHERE drp_cons_return_bill.bill_status = '05'
  AND drp_cons_return_bill.base_company_id = 10001
  AND (drp_cons_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('3' IN ('${queryType}')) -- 查询类型
  AND ('7' IN ('${boundType}')) -- 出入库类型
GROUP BY drp_cons_return_bill.stock_date,  -- 日期
         drp_cons_return_bill.workflow_no, -- 交易号
         drp_cons_return_bill.bill_no,     -- 单据号码
         bas_customer.name,                -- 客户/供应商名称
         gds_singlproduct.code,            -- 编码
         gds_barcode.barcode               -- 国标码

UNION ALL
--  经销退货
SELECT trade_sale_return_bill.stock_date         AS stock_date,    -- 日期
       trade_sale_return_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_sale_return_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.name                         AS customer_name, -- 客户/供应商名称
       ''                                        AS style_color,   -- 花号
       gds_singlproduct.code                     AS coding,-- 编码
       gds_barcode.barcode                       AS gb_coding,-- 国标码
       sum(trade_sale_return_bill_line.sale_qty) AS in_qty,        -- 入库数量
       ''                                        AS out_qty        -- 出库数量
FROM trade_sale_return_bill
         LEFT JOIN bas_customer ON trade_sale_return_bill.customer_id = bas_customer.id
         LEFT JOIN trade_sale_return_bill_line ON trade_sale_return_bill.id = trade_sale_return_bill_line.bill_id
         LEFT JOIN gds_singlproduct ON trade_sale_return_bill_line.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc ON gds_singlproduct.skc_id = gds_goods_skc.id
         LEFT JOIN gds_barcode ON trade_sale_return_bill_line.sku_id = gds_barcode.sku_id
    AND gds_barcode.type = 1 -- 国标条码
WHERE trade_sale_return_bill.delivery_status = '13'
  AND trade_sale_return_bill.base_company_id = '10001'
  AND (trade_sale_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
  AND ((bas_customer.name LIKE '%${customerOrSupplierName}%') OR (bas_customer.code LIKE '%${customerOrSupplierName}%'))
  AND ('3' IN ('${queryType}')) -- 查询类型
  AND ('8' IN ('${boundType}')) -- 出入库类型
GROUP BY trade_sale_return_bill.stock_date,  -- 日期
         trade_sale_return_bill.workflow_no, -- 交易号
         trade_sale_return_bill.bill_no,     -- 单据号码
         bas_customer.name,                  -- 客户/供应商名称
         gds_singlproduct.code,-- 编码
         gds_barcode.barcode -- 国标码
ORDER BY
IF(('1' IN ('${sequence}') ),
    style_color,
    workflow_no)