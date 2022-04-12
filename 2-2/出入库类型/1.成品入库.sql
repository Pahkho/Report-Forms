# 合计
select ''                                     AS stock_date,    -- 日期
       ''                                     AS workflow_no,   -- 交易号
       ''                                     AS bill_no,       -- 单据号码
       bas_supplier.code                      as customer_name, -- 客户/供应商名称
       ''                                     AS style_color,   -- 花号
       ''                                     AS coding,        -- 编码
       ''                                     AS gb_coding,     -- 国标码
       sum(trade_purchase_bill_goods.pur_qty) AS in_qty,       -- 入库数量
       ''                                     AS out_qty        -- 出库数量

from trade_purchase_bill
         LEFT JOIN bas_supplier on trade_purchase_bill.supplier_id = bas_supplier.id -- 公司
         LEFT JOIN trade_purchase_bill_goods on trade_purchase_bill.id = trade_purchase_bill_goods.bill_id
#          LEFT JOIN gds_singlproduct on trade_purchase_bill_goods.sku_id = gds_singlproduct.id
#          LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where trade_purchase_bill.delivery_status = '13'
  AND trade_purchase_bill.base_company_id = '10001'
#   AND (trade_purchase_bill.stock_date >= '2022-03-20' AND trade_purchase_bill.stock_date <= '2022-03-31')
#   AND bas_supplier.code LIKE ('') -- 供应商
#   AND ('1' IN ('@queryType'))
group by bas_supplier.code

union all

# 明细
select trade_purchase_bill.stock_date         AS stock_date,    -- 日期
       trade_purchase_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_purchase_bill.bill_no            AS bill_no,       -- 单据号码
       bas_supplier.code                      AS customer_code, -- 客户/供应商名称
       bas_supplier.name                      AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                     AS style_color,   -- 花号
       ''                                     AS coding,        -- 编码
       ''                                     AS gb_coding,     -- 国标码
       sum(trade_purchase_bill_goods.pur_qty) AS in_qty,       -- 入库数量
       ''                                     AS out_qty        -- 出库数量
from trade_purchase_bill
         LEFT JOIN bas_supplier on trade_purchase_bill.supplier_id = bas_supplier.id -- 公司
         LEFT JOIN trade_purchase_bill_goods on trade_purchase_bill.id = trade_purchase_bill_goods.bill_id
         LEFT JOIN gds_singlproduct on trade_purchase_bill_goods.sku_id = gds_singlproduct.id
         LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where trade_purchase_bill.delivery_status = '13'
  AND trade_purchase_bill.base_company_id = '10001'
#   AND (trade_purchase_bill.stock_date >= '2022-03-20' AND trade_purchase_bill.stock_date <= '2022-03-31')
  AND bas_supplier.name LIKE ('%金致皮%') -- 供应商
#   AND ('2' IN ('@queryType'))
group by trade_purchase_bill.stock_date,  -- 日期
         trade_purchase_bill.workflow_no, -- 交易号
         trade_purchase_bill.bill_no,     -- 单据号码
         bas_supplier.code,               -- 客户/供应商名称
         bas_supplier.name,
         gds_goods_skc.code               -- 花号
order by bas_supplier.code desc

union all

# 编码
select trade_purchase_bill.stock_date         AS stock_date,    -- 日期
       trade_purchase_bill.workflow_no        AS workflow_no,   -- 交易号
       trade_purchase_bill.bill_no            AS bill_no,       -- 单据号码
       bas_supplier.code                      AS customer_name, -- 客户/供应商名称
       ''                                     AS style_color,   -- 花号
       ''                                     AS coding,        -- 编码
       ''                                     AS gb_coding,     -- 国标码
       sum(trade_purchase_bill_goods.pur_qty) AS in_qty,       -- 入库数量
       ''                                     AS out_qty        -- 出库数量
from trade_purchase_bill
         LEFT JOIN bas_supplier on trade_purchase_bill.supplier_id = bas_supplier.id -- 公司
         LEFT JOIN trade_purchase_bill_goods on trade_purchase_bill.id = trade_purchase_bill_goods.bill_id
#          LEFT JOIN gds_singlproduct on trade_purchase_bill_goods.sku_id = gds_singlproduct.id
#          LEFT JOIN gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where trade_purchase_bill.delivery_status = '13'
  AND trade_purchase_bill.base_company_id = '10001'
  AND (trade_purchase_bill.stock_date >= '2022-03-20' AND trade_purchase_bill.stock_date <= '2022-03-31')
#   AND bas_supplier.code LIKE ('') -- 供应商
#   AND ('3' IN ('@queryType'))
group by trade_purchase_bill.stock_date,  -- 日期
         trade_purchase_bill.workflow_no, -- 交易号
         trade_purchase_bill.bill_no,     -- 单据号码
         bas_supplier.code -- 客户/供应商名称





