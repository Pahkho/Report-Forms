# 合计
select ''                                 as stock_date,    -- 日期
       ''                                 as workflow_no,   -- 交易号
       ''                                 as bill_no,       -- 单据号码
       bas_customer.code                  as customer_name, -- 客户/供应商名称
       ''                                 as style_color,   -- 花号
       ''                                 as coding,        -- 编码
       ''                                 as gb_coding,     -- 国标码
       sum(trade_sale_bill_line.sale_qty) as out_qty,        -- 出库数量
       ''                                 AS in_qty        -- 入库数量
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
#   AND (trade_sale_bill.stock_date >= '2022-03-20' AND trade_sale_bill.stock_date <= '2022-03-31')
#   AND bas_customer.code LIKE ('') -- 供应商
#   AND ('1' IN ('@queryType'))
group by
         bas_customer.code           -- 客户/供应商名称


# 明细
select trade_sale_bill.stock_date         as stock_date,    -- 日期
       trade_sale_bill.workflow_no        as workflow_no,   -- 交易号
       trade_sale_bill.bill_no            as bill_no,       -- 单据号码
       bas_customer.code                  as customer_name, -- 客户/供应商名称
       gds_goods_skc.code                 as style_color,   -- 花号
       ''                                 as coding,        -- 编码
       ''                                 as gb_coding,     -- 国标码
       ''                                 as in_qty,        -- 入库数量
       sum(trade_sale_bill_line.sale_qty) as out_qty        -- 出库数量
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
#   AND (trade_sale_bill.stock_date >= '2022-03-20' AND trade_sale_bill.stock_date <= '2022-03-31')
#   AND bas_customer.code LIKE ('') -- 供应商
#   AND ('3' IN ('@queryType'))
group by trade_sale_bill.stock_date,  -- 日期
         trade_sale_bill.workflow_no, -- 交易号
         trade_sale_bill.bill_no,     -- 单据号码
         bas_customer.code,           -- 客户/供应商名称
         gds_goods_skc.code           -- 花号



# 编码
select trade_sale_bill.stock_date         as stock_date,    -- 日期
       trade_sale_bill.workflow_no        as workflow_no,   -- 交易号
       trade_sale_bill.bill_no            as bill_no,       -- 单据号码
       bas_customer.code                  as customer_name, -- 客户/供应商名称
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
#   AND (trade_sale_bill.stock_date >= '2022-03-20' AND trade_sale_bill.stock_date <= '2022-03-31')
#   AND bas_customer.code LIKE ('') -- 供应商
#   AND ('2' IN ('@queryType'))
group by trade_sale_bill.stock_date,  -- 日期
         trade_sale_bill.workflow_no, -- 交易号
         trade_sale_bill.bill_no,     -- 单据号码
         bas_customer.code,           -- 客户/供应商名称
         gds_goods_skc.code,          -- 花号
         gds_singlproduct.code,       -- 编码
         gds_barcode.barcode -- 国标码



