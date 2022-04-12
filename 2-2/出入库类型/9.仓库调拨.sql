# 合计
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
#          left join gds_singlproduct on stk_allocateoutbill_goods.sku_id = gds_singlproduct.id
#          left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where stk_allocate_out_bill.status = '05'
  and stk_allocate_out_bill.stock_organization_out_id = 10001


# 明细
select stk_allocate_out_bill.stock_date   AS stock_date,    -- 日期
       stk_allocate_out_bill.workflow_no  AS workflow_no,   -- 交易号
       stk_allocate_out_bill.bill_no      AS bill_no,       -- 单据号码
       ''                                 AS customer_name, -- 客户/供应商名称
       gds_goods_skc.code                 AS style_color, -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       sum(stk_allocateoutbill_goods.qty) AS out_qty,       -- 出库数量
       ''                                 AS in_qty         -- 入库数量
from stk_allocate_out_bill
         left join stk_allocateoutbill_goods
                   on stk_allocate_out_bill.id = stk_allocateoutbill_goods.allocate_out_bill_id
         left join gds_singlproduct on stk_allocateoutbill_goods.sku_id = gds_singlproduct.id
         left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where stk_allocate_out_bill.status = '05'
  and stk_allocate_out_bill.stock_organization_out_id = 10001
group by stk_allocate_out_bill.stock_date,
         stk_allocate_out_bill.workflow_no,
         stk_allocate_out_bill.bill_no,
         gds_goods_skc.code

# 没有编码报表
select ''                                 AS stock_date,    -- 日期
       ''                                 AS workflow_no,   -- 交易号
       ''                                 AS bill_no,       -- 单据号码
       ''                                 AS customer_name, -- 客户/供应商名称
       ''                                 AS style_color, -- 花号
       ''                                 AS coding,        -- 编码
       ''                                 AS gb_coding,     -- 国标码
       sum(stk_allocateoutbill_goods.qty) AS out_qty,       -- 出库数量
       ''                                 AS in_qty         -- 入库数量
from stk_allocate_out_bill
         left join stk_allocateoutbill_goods
                   on stk_allocate_out_bill.id = stk_allocateoutbill_goods.allocate_out_bill_id
#          left join gds_singlproduct on stk_allocateoutbill_goods.sku_id = gds_singlproduct.id
#          left join gds_goods_skc on gds_singlproduct.skc_id = gds_goods_skc.id
where stk_allocate_out_bill.status = '05'
  and stk_allocate_out_bill.stock_organization_out_id = 10001
# group by stk_allocate_out_bill.stock_date,
#          stk_allocate_out_bill.workflow_no,
#          stk_allocate_out_bill.bill_no,
#          gds_goods_skc.code
