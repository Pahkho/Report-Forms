SELECT goods_code                               AS `goods_code`,
       goods_name                               as `goods_name`,
       IFNULL(retail_amount, 0)                 AS retail_amount,  -- 零售金额
       IFNULL(settle_amount / retail_amount, 0) AS discount_rate,  -- 折扣率
       IFNULL(pay_amount, 0)                    AS pay_amount,     -- 实际销售金额
       IFNULL(settle_amount, 0)                 AS settle_amount,  -- 结算金额
       IFNULL(pay_amount / retail_amount, 0)    AS rate_of_return, -- 回款率
       IFNULL(extax_amount, 0)                  AS extax_amount,   -- 除税金额
       IFNULL(selling_cost, 0)                  AS selling_cost,   -- 销售成本
       IFNULL(extax_amount - selling_cost, 0)   AS gross_margin    -- 毛利
FROM (
         SELECT attribute.field_4 AS                                                goods_code,    -- 货号
                goods.`name`      AS                                                goods_name,    -- 货号名称
                round(sum(t.settle_qty * b.retail_price), 2)                        retail_amount, -- 零售金额
                round(sum(t.settle_qty * b.price), 2)                               pay_amount,    -- 实际销售金额
                round(sum(t.settle_qty * b.pre_settle_price), 2)                    settle_amount, -- 结算金额
                round(sum(t.settle_qty * b.pre_settle_price / (1 + b.tax_rate)), 2) extax_amount,  -- 除税金额
                round(sum(t.settle_qty * IFNULL(c.item_cost, 0)), 2)                selling_cost   -- 销售成本
         FROM trade_retail_bill_shipment_info t
                  LEFT JOIN bas_shop a ON t.shop_id = a.id
             AND a.`code` = '${shop_code}'
             AND (a.accounting_company_id IN ('${E3PLUS_QC_ID}') OR 1 = 1)
                  LEFT JOIN trade_retail_bill_line b ON t.bill_line_id = b.id
                  LEFT JOIN fin_cst_pac_item_costs_summary c ON t.stock_channle_id = c.summary_org_id
                  LEFT JOIN gds_goods_base_attribute attribute on attribute.goods_id = b.goods_id
                  LEFT join gds_goods goods on attribute.goods_id = goods.id
             AND b.goods_id = c.summary_item_id
         WHERE t.stock_type = 2
           AND t.cons_status = 'Y'
           AND ((DATE_FORMAT(t.delivery_time, '%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}'))
         GROUP BY attribute.field_4, -- 货号
                  goods.`name`

         UNION ALL

         SELECT attribute.field_4 AS                                                goods_code,    -- 货号
                goods.`name`      AS                                                goods_name,
                round(sum(t.settle_qty * b.retail_price), 2)                        retail_amount, -- 零售金额
                round(sum(t.settle_qty * b.price), 2)                               pay_amount,    -- 实际销售金额
                round(sum(t.settle_qty * b.pre_settle_price), 2)                    settle_amount, -- 结算金额
                round(sum(t.settle_qty * b.pre_settle_price / (1 + b.tax_rate)), 2) extax_amount,  -- 除税金额
                round(sum(t.settle_qty * IFNULL(c.item_cost, 0)), 2)                selling_cost   -- 销售成本
         FROM trade_retail_return_bill_shipment_info t
                  LEFT JOIN bas_shop a ON t.shop_id = a.id
             AND a.`code` = '${shop_code}'
             AND (a.accounting_company_id IN ('${E3PLUS_QC_ID}') OR 1 = 1)
                  LEFT JOIN trade_retail_return_bill_line b ON t.bill_line_id = b.id
                  LEFT JOIN fin_cst_pac_item_costs_summary c ON t.stock_channle_id = c.summary_org_id
                  LEFT JOIN gds_goods_base_attribute attribute on attribute.goods_id = b.goods_id
                  LEFT join gds_goods goods on attribute.goods_id = goods.id
             AND b.goods_id = c.summary_item_id
         WHERE t.stock_type = 2
           AND t.cons_status = 'Y'
           AND ((DATE_FORMAT(t.delivery_time, '%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}'))
         GROUP BY attribute.field_4, -- 货号
                  goods.`name`
     ) temp

