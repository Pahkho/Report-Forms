# 合计
select ''                                      AS stock_date,    -- 日期
       ''                                      AS workflow_no,   -- 交易号
       ''                                      AS bill_no,       -- 单据号码
       bas_customer.code                       AS customer_name, -- 客户/供应商名称
       ''                                      AS style_color,   -- 花号
       ''                                      AS coding,-- 编码
       ''                                      AS gb_coding,-- 国标码
       sum(drp_cons_return_bill_line.sale_qty) as in_qty,-- 入库数量
       ''                                      as out_qty        -- 出库数量
from drp_cons_return_bill
         left join bas_customer on drp_cons_return_bill.customer_id = bas_customer.id
         left join drp_cons_return_bill_line
                   on drp_cons_return_bill.id = drp_cons_return_bill_line.cons_sale_return_bill_id
#          left join gds_singlproduct on drp_cons_return_bill_line.sku_id = gds_singlproduct.id
#          left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
#          left join gds_barcode on drp_cons_return_bill_line.sku_id = gds_barcode.sku_id
#     AND gds_barcode.type = 1 -- 国标条码
where drp_cons_return_bill.bill_status = '05'
  and drp_cons_return_bill.base_company_id = 10001
group by bas_customer.code
-- 客户/供应商名称
# select b.code,b.name from bas_customer b where b.code =31010032


# 明细
select drp_cons_return_bill.stock_date         AS stock_date,    -- 日期
       drp_cons_return_bill.workflow_no        AS workflow_no,   -- 交易号
       drp_cons_return_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.code                       AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                      AS style_color,   -- 花号
       ''                                      AS coding,-- 编码
       ''                                      AS gb_coding,-- 国标码
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
group by drp_cons_return_bill.stock_date,  -- 日期
         drp_cons_return_bill.workflow_no, -- 交易号
         drp_cons_return_bill.bill_no,     -- 单据号码
         bas_customer.code,                -- 客户/供应商名称
         gds_goods_skc.code
-- 花号


# 编码
select drp_cons_return_bill.stock_date         AS stock_date,    -- 日期
       drp_cons_return_bill.workflow_no        AS workflow_no,   -- 交易号
       drp_cons_return_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.code                       AS customer_name, -- 客户/供应商名称
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
group by drp_cons_return_bill.stock_date,  -- 日期
         drp_cons_return_bill.workflow_no, -- 交易号
         drp_cons_return_bill.bill_no,     -- 单据号码
         bas_customer.code,                -- 客户/供应商名称
         gds_singlproduct.code,-- 编码
         gds_barcode.barcode -- 国标码