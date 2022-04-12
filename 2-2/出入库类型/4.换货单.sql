# 合计
select ''                                 AS stock_date,    -- 日期
       ''                                 AS workflow_no,   -- 交易号
       ''                                 AS bill_no,       -- 单据号码
       bas_customer.code                  AS customer_name, -- 客户/供应商
       ''                                 AS style_color,   -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       sum(trade_sale_bill_line.sale_qty) AS out_qty,       -- 出库数量
       ''                                 AS in_qty         -- 入库数量
from trade_sale_bill
         left join bas_customer on trade_sale_bill.customer_id = bas_customer.id
         left join trade_sale_bill_line on trade_sale_bill.id = trade_sale_bill_line.bill_id
#          left join gds_singlproduct on trade_sale_bill_line.sku_id = gds_singlproduct.id
#          left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where trade_sale_bill.delivery_status = 8
  AND trade_sale_bill.sale_method = 'C'
  AND trade_sale_bill.base_company_id = 10001
#   AND (trade_sale_bill.stock_date >= '2022-03-20' AND trade_sale_bill.stock_date <= '2022-03-31')
#   AND bas_customer.cod -- 供应商
#   AND queryType'))
group by bas_customer.code

# 明细
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
         left join bas_customer on trade_sale_bill.customer_id = bas_customer.id
         left join trade_sale_bill_line on trade_sale_bill.id = trade_sale_bill_line.bill_id
         left join gds_singlproduct on trade_sale_bill_line.sku_id = gds_singlproduct.id
         left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where trade_sale_bill.delivery_status = 8
  AND trade_sale_bill.sale_method = 'C'
  AND trade_sale_bill.base_company_id = 10001
#   AND (trade_sale_bill.stock_date >= '2022-03-20' AND trade_sale_bill.stock_date <= '2022-03-31')
#   AND bas_customer.cod -- 供应商
#   AND queryType'))
group by trade_sale_bill.stock_date,  -- 日期
         trade_sale_bill.workflow_no, -- 交易号
         trade_sale_bill.bill_no,     -- 单据号码
         bas_customer.code,
         gds_goods_skc.code

# 编码
select ''                                 AS stock_date,    -- 日期
       ''                                 AS workflow_no,   -- 交易号
       ''                                 AS bill_no,       -- 单据号码
       bas_customer.code                  AS customer_name, -- 客户/供应商
       ''                                 AS style_color,   -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       sum(trade_sale_bill_line.sale_qty) AS out_qty,       -- 出库数量
       ''                                 AS in_qty         -- 入库数量
from trade_sale_bill
         left join bas_customer on trade_sale_bill.customer_id = bas_customer.id
         left join trade_sale_bill_line on trade_sale_bill.id = trade_sale_bill_line.bill_id
#          left join gds_singlproduct on trade_sale_bill_line.sku_id = gds_singlproduct.id
#          left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where trade_sale_bill.delivery_status = 8
  AND trade_sale_bill.sale_method = 'C'
  AND trade_sale_bill.base_company_id = 10001
#   AND (trade_sale_bill.stock_date >= '2022-03-20' AND trade_sale_bill.stock_date <= '2022-03-31')
#   AND bas_customer.cod -- 供应商
#   AND queryType'))
group by bas_customer.code



