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
           AND ((bas_supplier.name LIKE '%${customer_name}%') OR (bas_supplier.code LIKE '%${customer_name}%'))
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
                bas_supplier.code                             AS custmer_name, -- 客户/供应商名称
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
           AND ((bas_supplier.name LIKE '%${customer_name}%') OR (bas_supplier.code LIKE '%${customer_name}%'))
           AND ('3' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by trade_purchase_return_bill.stock_date,  -- 日期
                  trade_purchase_return_bill.workflow_no, -- 交易号
                  trade_purchase_return_bill.bill_no,     -- 单据号码
                  bas_supplier.code                       -- 客户/供应商名称
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
           AND ((bas_customer.name LIKE '%${customer_name}%') OR (bas_customer.code LIKE '%${customer_name}%'))
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
           AND ((bas_customer.name LIKE '%${customer_name}%') OR (bas_customer.code LIKE '%${customer_name}%'))
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
           AND ((bas_customer.name LIKE '%${customer_name}%') OR (bas_customer.code LIKE '%${customer_name}%'))
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
           AND ((bas_customer.name LIKE '%${customer_name}%') OR (bas_customer.code LIKE '%${customer_name}%'))
           AND ('3' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by trade_sale_return_bill.stock_date,  -- 日期
                  trade_sale_return_bill.workflow_no, -- 交易号
                  trade_sale_return_bill.bill_no,     -- 单据号码
                  bas_customer.name,                  -- 客户/供应商名称
                  gds_singlproduct.code,-- 编码
                  gds_barcode.barcode -- 国标码
     ) T
GROUP BY stock_date,    -- 日期
         workflow_no,   -- 交易号
         bill_no,       -- 单据号码
         customer_name, -- 客户/供应商名称
         coding,        -- 编码
         gb_coding -- 国标码

