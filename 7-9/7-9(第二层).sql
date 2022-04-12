select `goods_code`                             as `goods_code`,
       `name`                                   as `goods_name`,
       IFNULL(retail_amount, 0)                 as retail_amount,
       IFNULL(settle_amount / retail_amount, 0) as discount_rate,
       IFNULL(pay_amount, 0)                    as pay_amount,
       IFNULL(settle_amount, 0)                 as settle_amount,
       IFNULL(pay_amount / retail_amount, 0)    as rate_of_return,
       IFNULL(extax_amount, 0)                  as extax_amount,
       IFNULL(selling_cost, 0)                  as selling_cost,
       IFNULL(extax_amount - selling_cost, 0)   as gross_margin
from (select attribute.field_10                         as `goods_code`,
             goods.`name`                               as `name`,
             sum(workflow.change_qty * control.price)   as retail_amount,
             sum(payment.pay_amount)                    as pay_amount,
             sum(payment.settle_amount)                 as settle_amount,
             sum(billLine.extax_amount)                 as extax_amount,
             sum(workflow.change_qty * costs.item_cost) as selling_cost
      from bas_shop shop
               left join bas_shop_use_warehouse useWarehouse on useWarehouse.shop_id = shop.id
               left join stk_stock_logic_workflow workflow
                         on workflow.logic_warehouse_id = useWarehouse.logic_warehouse_id
               left join mkt_price_control control on control.price_id = 1 and
                                                      (workflow.stock_date BETWEEN control.enable_time AND control.disable_time) and
                                                      workflow.goods_id = control.goods_id
               left join trade_retail_bill_payment payment on payment.bill_no = workflow.bill_no
               left join trade_retail_bill_line billLine on billLine.bill_id = payment.bill_id
               left join fin_cst_pac_item_costs costs
                         on (workflow.stock_date BETWEEN costs.period_start_date AND costs.period_end_date) and
                            costs.goods_id = workflow.goods_id and costs.base_company_id = workflow.owner_id
               left join gds_goods_base_attribute attribute on attribute.goods_id = workflow.goods_id
               left join gds_goods goods on attribute.goods_id = goods.id
      where shop.`code` = '${shop_code}'
        and workflow.bill_name in ('69', '74')
        and workflow.stock_type = '2'
        and workflow.qty_type = '1'
        and workflow.sale_confirm = 'Y'
        AND DATE_FORMAT(workflow.stock_date, '%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}'
        AND (shop.accounting_company_id IN ('${E3PLUS_QC_ID}') OR 1 = 1)
      group by attribute.field_10, goods.`name`) temp