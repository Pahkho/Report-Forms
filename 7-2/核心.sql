select workflow.id,
       bas_stock_organization.accounting_company_id,
       bas_shop_business_info.area_id,
       bas_shop_business_info.shop_id,
       workflow.stock_type,
       workflow.logic_warehouse_id,
       gds_goods_base_attribute.field_2,
       (CASE
            WHEN gds_category_tree.level_num = 1 THEN
                gds_category_tree.id
            WHEN gds_category_tree.level_num = 2 THEN
                gds_category_tree.parent_id
            else null
           END)                                                                                                                                  category_tree_id_1,-- 大类

       (CASE
            WHEN gds_category_tree.level_num = 1 THEN
                null
            WHEN gds_category_tree.level_num = 2 THEN
                gds_category_tree.id
            ELSE NULL
           END)                                                                                                                                  category_tree_id_2, -- 小类
       gds_goods_base_attribute.field_4,
       workflow.goods_id,
       workflow.sku_id,
       gds_goods.classification_id                                                                                                               classification_id,

       IF(workflow.stock_date between date_sub('@STOCK_DATE_START_FUNC', interval extract(day from '@STOCK_DATE_START_FUNC') - 1 day) and
              CONCAT(date_sub(date_format('@STOCK_DATE_START_FUNC', '%y-%m-%d'), interval 1 day), ' ', '23:59:59')
              and workflow.qty_type in ('1'), workflow.change_qty, 0)                                                                            qty1,-- 期初--流水在库

       IF(workflow.stock_date between date_sub('@STOCK_DATE_START_FUNC', interval extract(day from '@STOCK_DATE_START_FUNC') - 1 day) and
              CONCAT(date_sub(date_format('@STOCK_DATE_START_FUNC', '%y-%m-%d'), interval 1 day), ' ', '23:59:59')
              and workflow.qty_type in ('3'), workflow.change_qty, 0)                                                                            qty2,-- 期初--流水在途

       IF(workflow.stock_date between date_sub('@STOCK_DATE_START_FUNC', interval extract(day from '@STOCK_DATE_START_FUNC') - 1 day) and
              CONCAT(date_sub(date_format('@STOCK_DATE_START_FUNC', '%y-%m-%d'), interval 1 day), ' ', '23:59:59')
              and workflow.qty_type in ('1'), workflow.change_qty, 0) * IFNULL(t9.price, 0)                                                      amount1,-- 期初--流水在库金额

       IF(workflow.stock_date between date_sub('@STOCK_DATE_START_FUNC', interval extract(day from '@STOCK_DATE_START_FUNC') - 1 day) and
              CONCAT(date_sub(date_format('@STOCK_DATE_START_FUNC', '%y-%m-%d'), interval 1 day), ' ', '23:59:59')
              and workflow.qty_type in ('3'), workflow.change_qty, 0) * IFNULL(t9.price, 0)                                                      amount2,-- 期初--流水在途金额

       IF(workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END') OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@'
                                                                                         and workflow.qty_type in ('1'), workflow.change_qty, 0) qty3,-- 期末结存--流水在库

       IF(workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END') OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@'
                                                                                         and workflow.qty_type in ('3'), workflow.change_qty, 0) qty4,-- 期末结存--流水在途

       IF(workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END') OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@'
                                                                                         and workflow.qty_type in ('1'), workflow.change_qty, 0) *
                                                                                    IFNULL(t9.price, 0)                                          amount3,-- 期末结存--流水在库金额

       IF(workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END') OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@'
                                                                                         and workflow.qty_type in ('3'), workflow.change_qty, 0) *
                                                                                    IFNULL(t9.price, 0)                                          amount4,-- 期末结存--流水在途金额

       IF(workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END') OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@'
                                                                                         and workflow.qty_type in ('1') and workflow.bill_name in ('67', '94'),
                                                                                     workflow.change_qty, 0)                                     qty5,-- 进货数量

       IF(workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END') OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@'
                                                                                         and workflow.qty_type in ('1') and workflow.bill_name in ('68', '98'),
                                                                                     workflow.change_qty, 0)                                     qty6,-- 退回数量

       IF(workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END') OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@'
                                                                                         and workflow.qty_type in ('1') and
                                                                                     (workflow.bill_name in ('71', '77', '69') or (workflow.bill_name = '89' and workflow.sale_confirm = 'Y')),
                                                                                     workflow.change_qty, 0)                                     qty7,-- 销售--销售数量

       IF(workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END') OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@'
                                                                                         and workflow.qty_type in ('1') and
                                                                                     (workflow.bill_name in ('71', '77', '69') or (workflow.bill_name = '89' and workflow.sale_confirm = 'Y')),
                                                                                     workflow.amount, 0)                                         amount5,-- 销售--销售金额

       IF(workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END') OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@'
                                                                                         and workflow.qty_type in ('1') and
                                                                                     (workflow.bill_name in ('71', '77', '69') or (workflow.bill_name = '89' and workflow.sale_confirm = 'Y')),
                                                                                     workflow.change_qty, 0) * IFNULL(t9.price, 0)               amount6,-- 销售--零售价金额

       IF(workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END') OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@'
                                                                                         and workflow.qty_type in ('1') and workflow.bill_name in ('86'),
                                                                                     workflow.change_qty, 0)                                     qty8,-- 调出数量

       IF(workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END') OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@'
                                                                                         and workflow.qty_type in ('1') and workflow.bill_name in ('85'),
                                                                                     workflow.change_qty, 0)                                     qty9,-- 调入数量

       IF(workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END') OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@'
                                                                                         and workflow.qty_type in ('1') and workflow.bill_name in ('1D') and
                                                                                     workflow.bill_type in ('91'), workflow.change_qty, 0)       qty10-- 盈亏数量

from stk_stock_logic_workflow workflow
         left join bas_stock_organization on workflow.stock_organization_id = bas_stock_organization.id

         left join bas_shop_use_warehouse on workflow.logic_warehouse_id = bas_shop_use_warehouse.logic_warehouse_id
         left join bas_shop_business_info on bas_shop_use_warehouse.shop_id = bas_shop_business_info.shop_id

         left join gds_goods on workflow.goods_Id = gds_goods.id
         left join gds_goods_base_attribute on gds_goods.id = gds_goods_base_attribute.goods_id
         left join (select t1.goods_id, t1.price
                    from mkt_price_control t1
                             inner join (select t1.goods_id, MAX(t1.create_time) create_time
                                         from mkt_price_control t1
                                         group by t1.goods_id) t on t1.goods_id = t.goods_id
                    where t1.create_time = t.create_time
                      and t1.price_id = 1
                      and t1.status = '09'
                      and enable_time <= IF('@STOCK_DATE_START_FUNC' = '', date_sub(date_format(now(), '%y-%m-%d'), interval extract(day from now()) - 1 day),
                                            '@STOCK_DATE_START_FUNC')
                      and disable_time >= IF('@STOCK_DATE_END_FUNC' = '', now(), '@STOCK_DATE_END_FUNC')
) t9 on t9.goods_id = workflow.goods_id
         left join gds_category_tree on gds_goods_base_attribute.category_tree_id = gds_category_tree.id
where 1 = 1
    -- and (bas_stock_organization.accounting_company_id IN ('@BASE_COMPANY_ID') OR '@BASE_COMPANY_ID'='@')
    -- and (bas_shop_business_info.area_id IN ('@AREA_ID') OR '@AREA_ID'='@')
    and (bas_shop_business_info.area_id IN ('@SHOP_ID') OR '@SHOP_ID' = '@')
    and (workflow.stock_type IN ('@STOCK_TYPE') OR '@STOCK_TYPE' = '@')
    and (workflow.logic_warehouse_id IN ('@LOGIC_WAREHOUSE_ID') OR '@LOGIC_WAREHOUSE_ID' = '@')
    and (gds_goods.classification_id IN ('@CLASSIFICATION_ID') OR '@CLASSIFICATION_ID' = '@')
    and IF('${CATEGORY_TREE_ID_1}' = '', 1 = 1,
           CASE
               WHEN gds_category_tree.level_num = 1 THEN
                   (gds_category_tree.id IN ('@CATEGORY_TREE_ID_1') OR '@CATEGORY_TREE_ID_1' = '@')
               WHEN gds_category_tree.level_num = 2 THEN
                   (gds_category_tree.parent_id IN ('@CATEGORY_TREE_ID_1') OR '@CATEGORY_TREE_ID_1' = '@')
               else 1 != 1
               END
          )-- 大类
    and IF('${CATEGORY_TREE_ID_2}' = '', 1 = 1,
           CASE
               WHEN gds_category_tree.level_num = 1 THEN
                   1 != 1
               WHEN gds_category_tree.level_num = 2 THEN
                   (gds_category_tree.id IN ('@CATEGORY_TREE_ID_2') OR '@CATEGORY_TREE_ID_2' = '@')
               else 1 != 1
               END
          )-- 小类
    and (gds_goods_base_attribute.field_2 IN ('@FIELD4') OR '@FIELD4' = '@')
    and (gds_goods_base_attribute.field_4 LIKE '%@FIELD10%' OR '@FIELD10' = '%@%')
    and (gds_goods.id IN ('@GOODS_ID') OR '@GOODS_ID' = '@')
    and (workflow.stock_organization_id IN ('@STOCK_ORGANIZATION_ID') OR '@STOCK_ORGANIZATION_ID' = '@')
    and workflow.qty_type in ('1', '3')
    and (workflow.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END')
   OR ('@STOCK_DATE_START' = '@' AND '@STOCK_DATE_END' = '@')