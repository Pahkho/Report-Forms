# 合计
select ''                              AS stock_date,    -- 日期
       ''                              AS workflow_no,   -- 交易号
       ''                              AS bill_no,       -- 单据号码
       bas_customer.code               AS customer_name, -- 客户/供应商名称
       ''                              AS style_color,   -- 花号
       ''                              AS coding,-- 编码
       ''                              AS gb_coding,-- 国标码
       sum(wms_stockoutbill_goods.qty) AS out_qty,       -- 出库数量
       ''                              as in_qty
from wms_stock_out_bill
         left join bas_customer on wms_stock_out_bill.business_party_id = bas_customer.id
         left join wms_stockoutbill_goods on wms_stock_out_bill.id = wms_stockoutbill_goods.stockoutbill_id
where wms_stock_out_bill.status = '05'
  and wms_stock_out_bill.business_type_id = 598903405221556317
group by bas_customer.code


# 明细
select wms_stock_out_bill.out_warehouse_date AS stock_date,    -- 日期
       wms_stock_out_bill.workflow_no        AS workflow_no,   -- 交易号
       wms_stock_out_bill.bill_no            AS bill_no,       -- 单据号码
       bas_customer.code                     AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                    AS style_color,   -- 花号
       ''                                    AS coding,-- 编码
       ''                                    AS gb_coding,-- 国标码
       sum(wms_stockoutbill_goods.qty)       AS out_qty,       -- 出库数量
       ''                                    as in_qty
from wms_stock_out_bill
         left join bas_customer on wms_stock_out_bill.business_party_id = bas_customer.id
         left join wms_stockoutbill_goods on wms_stock_out_bill.id = wms_stockoutbill_goods.stockoutbill_id
         left join gds_singlproduct on wms_stockoutbill_goods.sku_id = gds_singlproduct.id
         left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where wms_stock_out_bill.status = '05'explain ANALYZE
  and wms_stock_out_bill.business_type_id = 598903405221556318
group by wms_stock_out_bill.out_warehouse_date, -- 日期
         wms_stock_out_bill.workflow_no,        -- 交易号
         wms_stock_out_bill.bill_no,            -- 单据号码
         bas_customer.code,                     -- 客户/供应商名称
         gds_goods_skc.code                     -- 花号

# 没有编码报表
select ''                              AS stock_date,    -- 日期
       ''                              AS workflow_no,   -- 交易号
       ''                              AS bill_no,       -- 单据号码
       bas_customer.code               AS customer_name, -- 客户/供应商名称
       ''                              AS style_color,   -- 花号
       ''                              AS coding,-- 编码
       ''                              AS gb_coding,-- 国标码
       sum(wms_stockoutbill_goods.qty) AS out_qty,       -- 出库数量
       ''                              as in_qty
from wms_stock_out_bill
         left join bas_customer on wms_stock_out_bill.business_party_id = bas_customer.id
         left join wms_stockoutbill_goods on wms_stock_out_bill.id = wms_stockoutbill_goods.stockoutbill_id
where wms_stock_out_bill.status = '05'
  and wms_stock_out_bill.business_type_id = 598903405221556317
group by bas_customer.code



