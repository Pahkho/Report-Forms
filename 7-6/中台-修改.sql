SELECT '1' AS 1
FROM (
         select CASE -- 查询类别1
                    WHEN '1' in ('@QUERY_TYPE_1')  THEN tc1.id
                    WHEN '3' in ('@QUERY_TYPE_1')  THEN tc3.id
                    WHEN '5' in ('@QUERY_TYPE_1')  THEN tc5.id
                    WHEN '6' in ('@QUERY_TYPE_1')  THEN tc6.id
                    WHEN '8' in ('@QUERY_TYPE_1')  THEN tc8.id
                    WHEN '9' in ('@QUERY_TYPE_1')  THEN tc9.id
                    WHEN '11' in ('@QUERY_TYPE_1')  THEN tc11.id
                    WHEN '12' in ('@QUERY_TYPE_1')  THEN tc12.id
                    WHEN '13' in ('@QUERY_TYPE_1')  THEN tc13.id
                    WHEN '2' in ('@QUERY_TYPE_1')  THEN tt.column1
                    WHEN '4' in ('@QUERY_TYPE_1')  THEN tt.column1
                    WHEN '7' in ('@QUERY_TYPE_1')  THEN tt.column1
                    WHEN '10' in ('@QUERY_TYPE_1')  THEN tt.column1
                    WHEN '14' in ('@QUERY_TYPE_1')  THEN tt.column1
                    else tc1.id
                    END column1_id,
                CASE-- 查询类别1
                    WHEN '1' in ('@QUERY_TYPE_1')  THEN tc1.name
                    WHEN '3' in ('@QUERY_TYPE_1')  THEN tc3.name
                    WHEN '5' in ('@QUERY_TYPE_1')  THEN tc5.name
                    WHEN '6' in ('@QUERY_TYPE_1')  THEN tc6.name
                    WHEN '8' in ('@QUERY_TYPE_1')  THEN tc8.name
                    WHEN '9' in ('@QUERY_TYPE_1')  THEN tc9.name
                    WHEN '11' in ('@QUERY_TYPE_1')  THEN tc11.name
                    WHEN '12' in ('@QUERY_TYPE_1')  THEN tc12.name
                    WHEN '13' in ('@QUERY_TYPE_1')  THEN tc13.name
                    WHEN '2' in ('@QUERY_TYPE_1')  THEN tt.column1
                    WHEN '4' in ('@QUERY_TYPE_1')  THEN tt.column1
                    WHEN '7' in ('@QUERY_TYPE_1')  THEN CASE WHEN tt.column1 = '1' THEN '经销' WHEN tt.column1 = '2' THEN '代销' END
                    WHEN '10' in ('@QUERY_TYPE_1')  THEN tt.column1
                    WHEN '14' in ('@QUERY_TYPE_1')  THEN tt.column1
                    else tc1.name
                    END column1,
                CASE    -- 查询类别2
                    WHEN '1' in ('@QUERY_TYPE_2') THEN td1.id
                    WHEN '3' in ('@QUERY_TYPE_2') THEN td3.id
                    WHEN '5' in ('@QUERY_TYPE_2') THEN td5.id
                    WHEN '6' in ('@QUERY_TYPE_2') THEN td6.id
                    WHEN '8' in ('@QUERY_TYPE_2') THEN td8.id
                    WHEN '9' in ('@QUERY_TYPE_2') THEN td9.id
                    WHEN '11' in ('@QUERY_TYPE_2') THEN td11.id
                    WHEN '12' in ('@QUERY_TYPE_2') THEN td12.id
                    WHEN '13' in ('@QUERY_TYPE_2') THEN td13.id
                    WHEN '2' in ('@QUERY_TYPE_2') THEN tt.column2
                    WHEN '4' in ('@QUERY_TYPE_2') THEN tt.column2
                    WHEN '7' in ('@QUERY_TYPE_2') THEN tt.column2
                    WHEN '10' in ('@QUERY_TYPE_2') THEN tt.column2
                    WHEN '14' in ('@QUERY_TYPE_2') THEN tt.column2
                    else tt.column2
                    END column2_id,
                CASE    -- 查询类别2
                    WHEN '1' in ('@QUERY_TYPE_2')  THEN td1.name
                    WHEN '3' in ('@QUERY_TYPE_2')  THEN td3.name
                    WHEN '5' in ('@QUERY_TYPE_2')  THEN td5.name
                    WHEN '6' in ('@QUERY_TYPE_2')  THEN td6.name
                    WHEN '8' in ('@QUERY_TYPE_2')  THEN td8.name
                    WHEN '9' in ('@QUERY_TYPE_2')  THEN td9.name
                    WHEN '11' in ('@QUERY_TYPE_2')  THEN td11.name
                    WHEN '12' in ('@QUERY_TYPE_2')  THEN td12.name
                    WHEN '13' in ('@QUERY_TYPE_2')  THEN td13.name
                    WHEN '2' in ('@QUERY_TYPE_2')  THEN tt.column2
                    WHEN '4' in ('@QUERY_TYPE_2')  THEN tt.column2
                    WHEN '7' in ('@QUERY_TYPE_2')  THEN CASE WHEN tt.column2 = '1' THEN '经销' WHEN tt.column2 = '2' THEN '代销' END
                    WHEN '10' in ('@QUERY_TYPE_2')  THEN tt.column2
                    WHEN '14' in ('@QUERY_TYPE_2')  THEN tt.column2
                    else tt.column2
                    END column2,
                sale_qty,   -- 销售数量
                retail_amount,  -- 零售价金额
                sale_amount,    -- 销售金额
                discount_rate,  -- 折扣率
                settle_amount,  -- 结算金额
                extax_amount,   -- 不含税销售金额
                return_rate,    -- 汇款率
                cost_amount,    -- 成本金额
                gross_profit,   -- 毛利额
                gross_margin    -- 毛利率
         from (
                  select CASE
                             WHEN '1' in ('@QUERY_TYPE_1')  THEN t.accounting_company_id
                             WHEN '2' in ('@QUERY_TYPE_1')  THEN t.sale_type
                             WHEN '3' in ('@QUERY_TYPE_1')  THEN t.area_id
                             WHEN '4' in ('@QUERY_TYPE_1')  THEN t.stock_date
                             WHEN '5' in ('@QUERY_TYPE_1')  THEN t.shop_id
                             WHEN '6' in ('@QUERY_TYPE_1')  THEN t.business_party_id
                             WHEN '7' in ('@QUERY_TYPE_1')  THEN t.stock_type
                             WHEN '8' in ('@QUERY_TYPE_1')  THEN t.logic_warehouse_id
                             WHEN '9' in ('@QUERY_TYPE_1')  THEN t.sales_item_id
                             WHEN '10' in ('@QUERY_TYPE_1')  THEN t.bill_no
                             WHEN '11' in ('@QUERY_TYPE_1')  THEN t.field_4
                             WHEN '12' in ('@QUERY_TYPE_1')  THEN t.category_tree_id_1
                             WHEN '13' in ('@QUERY_TYPE_1')  THEN t.category_tree_id_2
                             WHEN '14' in ('@QUERY_TYPE_1')  THEN t.field_10
                             else t.accounting_company_id
                             END                                            column1,
                         CASE
                             WHEN '1' in ('@QUERY_TYPE_2')  THEN t.accounting_company_id
                             WHEN '2' in ('@QUERY_TYPE_2')  THEN t.sale_type
                             WHEN '3' in ('@QUERY_TYPE_2')  THEN t.area_id
                             WHEN '4' in ('@QUERY_TYPE_2')  THEN t.stock_date
                             WHEN '5' in ('@QUERY_TYPE_2')  THEN t.shop_id
                             WHEN '6' in ('@QUERY_TYPE_2')  THEN t.business_party_id
                             WHEN '7' in ('@QUERY_TYPE_2')  THEN t.stock_type
                             WHEN '8' in ('@QUERY_TYPE_2')  THEN t.logic_warehouse_id
                             WHEN '9' in ('@QUERY_TYPE_2')  THEN t.sales_item_id
                             WHEN '10' in ('@QUERY_TYPE_2')  THEN t.bill_no
                             WHEN '11' in ('@QUERY_TYPE_2')  THEN t.field_4
                             WHEN '12' in ('@QUERY_TYPE_2')  THEN t.category_tree_id_1
                             WHEN '13' in ('@QUERY_TYPE_2')  THEN t.category_tree_id_2
                             WHEN '14' in ('@QUERY_TYPE_2')  THEN t.field_10
                             else t.sale_type
                             END                                            column2,
                         SUM(sale_qty)                                      sale_qty,
                         SUM(retail_amount)                                 retail_amount,
                         SUM(sale_amount)                                   sale_amount,
                         IFNULL(SUM(sale_qty) / SUM(retail_amount), 0)      discount_rate,
                         SUM(settle_amount)                                 settle_amount,
                         SUM(extax_amount)                                  extax_amount,
                         IFNULL(SUM(settle_amount) / SUM(retail_amount), 0) return_rate,
                         SUM(cost_amount)                                   cost_amount,
                         SUM(gross_profit)                                  gross_profit,
                         IFNULL(SUM(gross_profit) / SUM(extax_amount), 0)   gross_margin
                  from (
                           select t1.id,
                                  t3.id                                    accounting_company_id,
                                  CASE
                                      WHEN t1.bill_name in ('71', '77') THEN '经销'
                                      WHEN t1.bill_name in ('89', '99') THEN '代销'
                                      WHEN t1.bill_name in ('69', '74') THEN '零售'
                                      END                                  sale_type,
                                  t6.id                                    area_id,
                                  t10.id                                   shop_id,
                                  t1.business_party_id,
                                  t1.stock_date,
                                  t1.stock_type,
                               /*
                               CASE
                                       WHEN t1.stock_type='1' THEN
                                           '经销'
                                       WHEN t1.stock_type='2' THEN
                                                   '代销'
                                   END stock_type,*/
                                  t11.id                                   logic_warehouse_id,
                                  t1.sales_item_id,
                                  t1.bill_no,
                                  t12.id                                   classification_id,
                                  (select CASE
                                              WHEN t.level_num = 1 THEN t.id
                                              WHEN t.level_num = 2 THEN t.parent_id
                                              else null
                                              END stock_type
                                   from gds_category_tree t
                                   where t.id = t13.id)                    category_tree_id_1,-- 大类

                                  (select CASE WHEN t.level_num = 1 THEN null
                                               WHEN t.level_num = 2 THEN t.id
                                               else null
                                               END stock_type
                                   from gds_category_tree t
                                   where t.id = t13.id)                    category_tree_id_2, -- 小类
                                  t8.field_10,
                                  t8.field_4,
                                  t1.change_qty                            sale_qty,
                                  t1.change_qty * IFNULL(t9.price, 0)      retail_amount,
                                  IFNULL(CASE
                                             WHEN t1.bill_name in ('71', '77') THEN t1.amount
                                             WHEN t1.bill_name in ('89') THEN t14.goods_price
                                             WHEN t1.bill_name in ('99') THEN t15.goods_price
                                             WHEN t1.bill_name in ('69') THEN t16.amount
                                             WHEN t1.bill_name in ('74') THEN t17.amount
                                             ELSE 0
                                             END, 0)                       sale_amount,-- 销售金额
                                  IFNULL(CASE
                                             WHEN t1.bill_name in ('71', '77') THEN t1.amount / (t1.change_qty * IFNULL(t9.price, 0))
                                             WHEN t1.bill_name in ('89') THEN t14.goods_price / (t1.change_qty * IFNULL(t9.price, 0))
                                             WHEN t1.bill_name in ('99') THEN t15.goods_price / (t1.change_qty * IFNULL(t9.price, 0))
                                             WHEN t1.bill_name in ('69') THEN t16.amount / (t1.change_qty * IFNULL(t9.price, 0))
                                             WHEN t1.bill_name in ('74') THEN t17.amount / (t1.change_qty * IFNULL(t9.price, 0))
                                             ELSE 0
                                             END, 0)                       discount_rate,-- 折扣率
                                  IFNULL(CASE      -- 单据名称
                                             WHEN t1.bill_name in ('71', '77') THEN t1.amount
                                             WHEN t1.bill_name in ('89') THEN t14.goods_price
                                             WHEN t1.bill_name in ('99') THEN t15.goods_price
                                             WHEN t1.bill_name in ('69') THEN t18.settle_amount-- 结算金额
                                             WHEN t1.bill_name in ('74') THEN t19.settle_amount-- 结算金额
                                             ELSE 0
                                             END, 0)                       settle_amount,-- 结算金额
                                  IFNULL(CASE
                                             WHEN t1.bill_name in ('71', '77') THEN t1.extax_amount
                                             WHEN t1.bill_name in ('89') THEN t14.extax_amount
                                             WHEN t1.bill_name in ('99') THEN t15.extax_amount
                                             WHEN t1.bill_name in ('69') THEN t16.extax_amount
                                             WHEN t1.bill_name in ('74') THEN t17.extax_amount
                                             ELSE 0
                                             END, 0)                       extax_amount,-- 不含税销售金额
                                  IFNULL(CASE
                                             WHEN t1.bill_name in ('71', '77') THEN t1.amount / (t1.change_qty * IFNULL(t9.price, 0))
                                             WHEN t1.bill_name in ('89') THEN t14.goods_price / (t1.change_qty * IFNULL(t9.price, 0))
                                             WHEN t1.bill_name in ('99') THEN t15.goods_price / (t1.change_qty * IFNULL(t9.price, 0))
                                             WHEN t1.bill_name in ('69') THEN t18.settle_amount / (t1.change_qty * IFNULL(t9.price, 0))
                                             WHEN t1.bill_name in ('74') THEN t19.settle_amount / (t1.change_qty * IFNULL(t9.price, 0))
                                             ELSE 0
                                             END, 0)                       return_rate,
                                  t1.change_qty * IFNULL(t20.item_cost, 0) cost_amount,

                                  IFNULL(CASE
                                             WHEN t1.bill_name in ('71', '77') THEN
                                                     IFNULL(t1.extax_amount, 0) - (t1.change_qty * IFNULL(t20.item_cost, 0))
                                             WHEN t1.bill_name in ('89') THEN
                                                     IFNULL(t14.extax_amount, 0) - (t1.change_qty * IFNULL(t20.item_cost, 0))
                                             WHEN t1.bill_name in ('99') THEN
                                                     IFNULL(t15.extax_amount, 0) - (t1.change_qty * IFNULL(t20.item_cost, 0))
                                             WHEN t1.bill_name in ('69') THEN
                                                     IFNULL(t16.extax_amount, 0) - (t1.change_qty * IFNULL(t20.item_cost, 0))
                                             WHEN t1.bill_name in ('74') THEN
                                                     IFNULL(t17.extax_amount, 0) - (t1.change_qty * IFNULL(t20.item_cost, 0))
                                             ELSE 0
                                             END, 0)                       gross_profit,
                                  IFNULL(CASE
                                             WHEN t1.bill_name in ('71', '77') THEN
                                                     (IFNULL(t1.extax_amount, 0) - (t1.change_qty * IFNULL(t20.item_cost, 0))) / IFNULL(t1.extax_amount, 0)
                                             WHEN t1.bill_name in ('89') THEN
                                                     (IFNULL(t14.extax_amount, 0) - (t1.change_qty * IFNULL(t20.item_cost, 0))) / IFNULL(t14.extax_amount, 0)
                                             WHEN t1.bill_name in ('99') THEN
                                                     (IFNULL(t15.extax_amount, 0) - (t1.change_qty * IFNULL(t20.item_cost, 0))) / IFNULL(t15.extax_amount, 0)
                                             WHEN t1.bill_name in ('69') THEN
                                                     (IFNULL(t16.extax_amount, 0) - (t1.change_qty * IFNULL(t20.item_cost, 0))) / IFNULL(t16.extax_amount, 0)
                                             WHEN t1.bill_name in ('74') THEN
                                                     (IFNULL(t17.extax_amount, 0) - (t1.change_qty * IFNULL(t20.item_cost, 0))) / IFNULL(t17.extax_amount, 0)
                                             ELSE 0
                                             END, 0)                       gross_margin
                           from stk_stock_logic_workflow t1
                                    left join bas_stock_organization t2 on t1.stock_organization_id = t2.id
                                    left join bas_accounting_company t3 on t2.accounting_company_id = t3.id
                                    left join bas_shop_use_warehouse t4 on t1.logic_warehouse_id = t4.logic_warehouse_id
                                    left join bas_shop_business_info t5 on t4.shop_id = t5.shop_id
                                    left join bas_area t6 on t5.area_id = t6.id
                                    left join bas_shop t10 on t5.shop_id = t10.id
                                    left join gds_goods t7 on t1.goods_Id = t7.id
                                    left join gds_goods_base_attribute t8 on t7.id = t8.goods_id
                                    left join bas_logic_warehouse t11 on t1.logic_warehouse_id = t11.id
                                    left join (select t1.goods_id, t1.price
                                               from mkt_price_control t1
                                                        left join (select t1.goods_id, MAX(t1.create_time) create_time
                                                                   from mkt_price_control t1
                                                                   where price_id = 1
                                                                     and status = '09'
                                                                     and ((enable_time <= '@STOCK_DATE_START_TIME') )
                                                                     and ((disable_time >= '@STOCK_DATE_END_TIME') )
                                                                   group by t1.goods_id) t on t1.goods_id = t.goods_id
                                               where t1.create_time = t.create_time
                           ) t9 on t9.goods_id = t1.goods_id

                                    left join gds_classification t12 on t7.classification_id = t12.id
                                    left join gds_category_tree t13 on t8.category_tree_id = t13.id
                                    left join drp_cons_sale_bill_line t14 on t1.bill_name in ('89') and t1.bill_detail_id = CAST(t14.id AS CHAR)
                                    left join drp_cons_return_bill_line t15 on t1.bill_name in ('99') and t1.bill_detail_id = CAST(t15.id AS CHAR)
                                    left join trade_retail_bill_line t16 on t1.bill_name in ('69') and t1.bill_detail_id = CAST(t16.id AS CHAR)
                                    left join trade_retail_return_bill_line t17 on t1.bill_name in ('74') and t1.bill_detail_id = CAST(t17.id AS CHAR)
                                    left join (select tt1.bill_no, SUM(IFNULL(settle_amount, 0)) settle_amount
                                               from trade_retail_bill tt1
                                                        left join trade_retail_bill_payment tt2 on tt1.id = tt2.bill_id
                                               group by tt1.bill_no) t18 on t18.bill_no = t1.bill_no

                                    left join (select tt1.bill_no, SUM(IFNULL(settle_amount, 0)) settle_amount
                                               from trade_retail_return_bill tt1
                                                        left join trade_retail_return_bill_payment tt2 on tt1.id = tt2.bill_id
                                               group by tt1.bill_no) t19 on t19.bill_no = t1.bill_no

                                    left join (select sku_id, SUM(IFNULL(item_cost, 0)) item_cost from fin_cst_pac_item_costs t group by sku_id) t20 on t20.sku_id = t1.sku_id

                           where qty_type in (1)
                               and (bill_name in ('71', '77', '69', '74') or (bill_name in ('89', '99') and sale_confirm = 'Y'))
                               and (t3.id IN ('@BASE_COMPANY_ID') )  -- 核算公司
                               AND
                                 (CASE
                                      WHEN '经销' in ('@SALE_TYPE')  THEN    -- 销售类型
                                          t1.bill_name in ('71', '77')
                                      WHEN '代销' in ('@SALE_TYPE')  THEN
                                          t1.bill_name in ('89', '99')
                                      WHEN '零售' in ('@SALE_TYPE')  THEN
                                          t1.bill_name in ('69', '74')
                                      ELSE 1 = 1
                                     END)
                               and (t6.id IN ('@AREA_ID') )  -- 营销区域
                               and (t10.id IN ('@SHOP_ID') ) -- 商店ID
                               and (t1.stock_type IN ('@STOCK_TYPE') )    -- 库存类型
                               and (t11.id IN ('@LOGIC_WAREHOUSE_ID'))   -- 逻辑仓库
                               and (t12.id IN ('@CLASSIFICATION_ID') )     -- 货品类别
                               and (t13.id IN ('@CATEGORY_TREE_ID_1') )   -- 大类
                               and (t13.id IN ('@CATEGORY_TREE_ID_2') )   -- 小类
                               -- and (t8.field_4 IN ('@FIELD4') OR '@FIELD4'='@')
                               and (t8.field_10 LIKE '%@FIELD10%' )    -- 货号
                               and (t1.stock_date BETWEEN '@STOCK_DATE_START' AND '@STOCK_DATE_END')    -- 库存日期
                           and (t1.stock_date IN ('@BILL_DATE') OR '@BILL_DATE'='@')
                           and (t1.business_party_id IN ('@CUSTOMER_ID') OR '@CUSTOMER_ID'='@')
                           and (t1.sales_item_id IN ('@SALES_ITEM_ID') OR '@SALES_ITEM_ID'='@')
                           and (t1.bill_no IN ('@BILL_NO') OR '@BILL_NO'='@')
                           -- LIMIT 0,1000
                       ) t
                  group by case
                               when '1' in ('@QUERY_TYPE_1')  then t.accounting_company_id
                               when '2' in ('@QUERY_TYPE_1')  then t.sale_type
                               when '3' in ('@QUERY_TYPE_1')  then t.area_id
                               when '4' in ('@QUERY_TYPE_1')  then t.stock_date
                               when '5' in ('@QUERY_TYPE_1')  then t.shop_id
                               when '6' in ('@QUERY_TYPE_1')  then t.business_party_id
                               when '7' in ('@QUERY_TYPE_1')  then t.stock_type
                               when '8' in ('@QUERY_TYPE_1')  then t.logic_warehouse_id
                               when '9' in ('@QUERY_TYPE_1')  then t.sales_item_id
                               when '10' in ('@QUERY_TYPE_1')  then t.bill_no
                               when '11' in ('@QUERY_TYPE_1')  then t.field_4
                               when '12' in ('@QUERY_TYPE_1')  then t.category_tree_id_1
                               when '13' in ('@QUERY_TYPE_1')  then t.category_tree_id_2
                               when '14' in ('@QUERY_TYPE_1')  then t.field_10
                               else t.accounting_company_id
                               end
                          ,
                           case
                               when '1' in ('@QUERY_TYPE_2')  then t.accounting_company_id
                               when '2' in ('@QUERY_TYPE_2')  then t.sale_type
                               when '3' in ('@QUERY_TYPE_2')  then t.area_id
                               when '4' in ('@QUERY_TYPE_2')  then t.stock_date
                               when '5' in ('@QUERY_TYPE_2')  then t.shop_id
                               when '6' in ('@QUERY_TYPE_2')  then t.business_party_id
                               when '7' in ('@QUERY_TYPE_2')  then t.stock_type
                               when '8' in ('@QUERY_TYPE_2')  then t.logic_warehouse_id
                               when '9' in ('@QUERY_TYPE_2')  then t.sales_item_id
                               when '10' in ('@QUERY_TYPE_2')  then t.bill_no
                               when '11' in ('@QUERY_TYPE_2')  then t.field_4
                               when '12' in ('@QUERY_TYPE_2')  then t.category_tree_id_1
                               when '13' in ('@QUERY_TYPE_2')  then t.category_tree_id_2
                               when '14' in ('@QUERY_TYPE_2')  then t.field_10
                               else t.sale_type
                               end
              ) tt
                  left join bas_accounting_company tc1 on tt.column1 = CAST(tc1.id AS CHAR)
                  left join bas_area tc3 on tt.column1 = CAST(tc3.id AS CHAR)
                  left join bas_shop tc5 on tt.column1 = CAST(tc5.id AS CHAR)
                  left join bas_customer tc6 on tt.column1 = CAST(tc6.id AS CHAR)
                  left join bas_logic_warehouse tc8 on tt.column1 = CAST(tc8.id AS CHAR)
                  left join bas_sales_item tc9 on tt.column1 = CAST(tc9.id AS CHAR)
                  left join gds_attrvalue tc11 on tt.column1 = CAST(tc11.id AS CHAR)
                  left join gds_category_tree tc12 on tt.column1 = CAST(tc12.id AS CHAR)
                  left join gds_category_tree tc13 on tt.column1 = CAST(tc13.id AS CHAR)

                  left join bas_accounting_company td1 on tt.column2 = CAST(td1.id AS CHAR)
                  left join bas_area td3 on tt.column2 = CAST(td3.id AS CHAR)
                  left join bas_shop td5 on tt.column2 = CAST(td5.id AS CHAR)
                  left join bas_customer td6 on tt.column2 = CAST(td6.id AS CHAR)
                  left join bas_logic_warehouse td8 on tt.column2 = CAST(td8.id AS CHAR)
                  left join bas_sales_item td9 on tt.column2 = CAST(td9.id AS CHAR)
                  left join gds_attrvalue td11 on tt.column2 = CAST(td11.id AS CHAR)
                  left join gds_category_tree td12 on tt.column2 = CAST(td12.id AS CHAR)
                  left join gds_category_tree td13 on tt.column2 = CAST(td13.id AS CHAR)
         /*
         union all
         select 999999999999999999 column1_id,'库存转经销成本' column1,0 column2_id,'库存转经销成本' column2,0 sale_qty,0 retail_amount,0 sale_amount,0 discount_rate,
         0 settle_amount,0 extax_amount,0 return_rate,
         IFNULL((select SUM(tt1.cost_amount) from fin_cst_pac_update_goods tt1
                                 left join fin_cst_pac_update tt2 on tt1.bill_id = tt2.id
                                  where tt2.bill_status='03' and tt2.stock_type='1' and tt2.bill_type='1C'),0) cost_amount,
         0-IFNULL((select SUM(tt1.cost_amount) from fin_cst_pac_update_goods tt1
                                 left join fin_cst_pac_update tt2 on tt1.bill_id = tt2.id
                                  where tt2.bill_status='03' and tt2.stock_type='1' and tt2.bill_type='1C'),0) gross_profit,
         0 gross_margin*/
     ) ttt
WHERE 1 = 1 -- and ttt.column1_id='575991300173303809'
ORDER BY ttt.column1_id asc, ttt.column2