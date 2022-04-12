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
           AND ((bas_supplier.name LIKE '%${customer_name}%') OR (bas_supplier.code LIKE '%${customer_name}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
-- AND ('1' IN ('@sequence')) -- 排序
         group by bas_supplier.code

         UNION ALL

--  退供应商
         select ''                                            AS stock_date,   -- 日期
                ''                                            AS workflow_no,  -- 交易号
                ''                                            AS bill_no,      -- 单据号码
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
           AND (trade_purchase_return_bill.stock_date BETWEEN '${date_begin}' AND '${date_end}')
           AND ((bas_supplier.name LIKE '%${customer_name}%') OR (bas_supplier.code LIKE '%${customer_name}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by bas_supplier.code -- 客户/供应商名称

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
           AND ((bas_customer.name LIKE '%${customer_name}%') OR (bas_customer.code LIKE '%${customer_name}%'))
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
           AND ((bas_customer.name LIKE '%${customer_name}%') OR (bas_customer.code LIKE '%${customer_name}%'))
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
           -- AND ((bas_supplier.name LIKE '%${customer_name}%') OR (bas_supplier.code LIKE '%${customer_name}%'))
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
           AND ((bas_customer.name LIKE '%${customer_name}%') OR (bas_customer.code LIKE '%${customer_name}%'))
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
           AND ((bas_customer.name LIKE '%${customer_name}%') OR (bas_customer.code LIKE '%${customer_name}%'))
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
           AND ((bas_customer.name LIKE '%${customer_name}%') OR (bas_customer.code LIKE '%${customer_name}%'))
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
           -- AND ((bas_supplier.name LIKE '%${customer_name}%') OR (bas_supplier.code LIKE '%${customer_name}%'))
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
           AND ((bas_customer.name LIKE '%${customer_name}%') OR (bas_customer.code LIKE '%${customer_name}%'))
           AND ('1' IN ('${queryType}')) -- 查询类型
           AND ('0' IN ('${boundType}')) -- 出入库类型
         group by bas_customer.name
     ) T
GROUP BY T.customer_name


