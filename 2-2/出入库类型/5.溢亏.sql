# 合计
select ''                                                                                                 AS stock_date,    -- 日期
       ''                                                                                                 AS workflow_no,   -- 交易号
       ''                                                                                                 AS bill_no,       -- 单据号码
       ''                                                                                                 AS customer_name, -- 客户/供应商名称
       ''                                                                                                 AS style_color,   -- 花号
       ''                                                                                                 AS coding,        -- 编码
       ''                                                                                                 AS gb_coding,     -- 国标码
       sum(CASE
               WHEN stk_stklogic_adjbill_detail.qty > 0 THEN stk_stklogic_adjbill_detail.qty
               ELSE 0 END)                                                                                AS in_qty,        -- 入库数量
       sum(CASE
               WHEN stk_stklogic_adjbill_detail.qty < 0 THEN stk_stklogic_adjbill_detail.qty
               ELSE 0 END)                                                                                AS out_qty        -- 出库数量
from stk_stock_logic_adjust_bill
         left join bas_logic_warehouse on stk_stock_logic_adjust_bill.warehouse_id = bas_logic_warehouse.id
         left join stk_stklogic_adjbill_detail on stk_stock_logic_adjust_bill.id = stk_stklogic_adjbill_detail.bill_id
where stk_stock_logic_adjust_bill.bill_status = '05'
  AND bas_logic_warehouse.accounting_company_id = 10001
  AND stk_stock_logic_adjust_bill.stock_date BETWEEN '2022-03-20' AND '2022-03-31'



select stk_stock_logic_adjust_bill.stock_date                                                             AS stock_date,    -- 日期
       stk_stock_logic_adjust_bill.workflow_no                                                            AS workflow_no,   -- 交易号
       stk_stock_logic_adjust_bill.bill_no                                                                AS bill_no,       -- 单据号码
       ''                                                                                                 AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                                                                                 AS style_color,   -- 花号
       ''                                                                                                 AS coding,        -- 编码
       ''                                                                                                 AS gb_coding,     -- 国标码
       sum(CASE
               WHEN stk_stklogic_adjbill_detail.qty > 0 THEN stk_stklogic_adjbill_detail.qty
               ELSE 0 END)                                                                                AS in_qty,        -- 入库数量
       sum(CASE
               WHEN stk_stklogic_adjbill_detail.qty < 0 THEN stk_stklogic_adjbill_detail.qty
               ELSE 0 END)                                                                                AS out_qty        -- 出库数量
from stk_stock_logic_adjust_bill
         left join bas_logic_warehouse on stk_stock_logic_adjust_bill.warehouse_id = bas_logic_warehouse.id
         left join stk_stklogic_adjbill_detail
                   on stk_stock_logic_adjust_bill.id = stk_stklogic_adjbill_detail.bill_id
         left join gds_singlproduct on stk_stklogic_adjbill_detail.sku_id = gds_singlproduct.id
         left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where stk_stock_logic_adjust_bill.bill_status = '05'
  AND bas_logic_warehouse.accounting_company_id = 10001
group by stk_stock_logic_adjust_bill.stock_date,
         stk_stock_logic_adjust_bill.workflow_no,
         stk_stock_logic_adjust_bill.bill_no,
         gds_goods_skc.code


# 编码
select ''                                                                                                 AS stock_date,    -- 日期
       ''                                                                                                 AS workflow_no,   -- 交易号
       ''                                                                                                 AS bill_no,       -- 单据号码
       ''                                                                                                 AS customer_name, -- 客户/供应商名称
       ''                                                                                                 AS style_color,   -- 花号
       ''                                                                                                 AS coding,        -- 编码
       ''                                                                                                 AS gb_coding,     -- 国标码
       sum(CASE
               WHEN stk_stklogic_adjbill_detail.qty > 0 THEN stk_stklogic_adjbill_detail.qty
               ELSE 0 END)                                                                                AS in_qty,        -- 入库数量
       sum(CASE
               WHEN stk_stklogic_adjbill_detail.qty < 0 THEN stk_stklogic_adjbill_detail.qty
               ELSE 0 END)                                                                                AS out_qty        -- 出库数量
from stk_stock_logic_adjust_bill
         left join bas_logic_warehouse on stk_stock_logic_adjust_bill.warehouse_id = bas_logic_warehouse.id
         left join stk_stklogic_adjbill_detail
                   on stk_stock_logic_adjust_bill.id = stk_stklogic_adjbill_detail.bill_id
#          left join gds_singlproduct on stk_stklogic_adjbill_detail.sku_id = gds_singlproduct.id
#          left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where stk_stock_logic_adjust_bill.bill_status = '05'
  AND bas_logic_warehouse.accounting_company_id = 10001
