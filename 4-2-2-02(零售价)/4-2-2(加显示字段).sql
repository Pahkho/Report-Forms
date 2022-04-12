SELECT goods_code                       AS 款号,
       goods_name                       AS 名称,
       inventory_name                   AS 库存组织,
       sum(begin_qty)                   AS 期初数量,
       round(sum(begin_value), 2)       AS 期初金额,
       sum(in_qty)                      AS 本期调进数量,
       round(sum(in_value), 2)          AS 本期调进金额,
       sum(issue_qty)                   AS 本期销售数量,
       round(sum(issue_value), 2)       AS 本期销售金额,
       sum(profit_loss_qty)             AS 本期盈亏数量,
       round(sum(profit_loss_value), 2) AS 本期盈亏金额,
       sum(return_qty)                  AS 本期退回数量,
       round(sum(return_value), 2)      AS 本期退回金额,
       sum(begin_qty) + sum(in_qty) - sum(issue_qty) + sum(profit_loss_qty) -
       sum(return_qty)                  AS 期末数量,
       round(sum(begin_value) + sum(in_value) - sum(issue_value) + sum(profit_loss_value) - sum(return_value),
             2)                         AS 期末金额
FROM (
         SELECT c1.CODE                     goods_code,
                c1.NAME                     goods_name,
                b.name                      inventory_name,
                sum(a1.begin_qty)           begin_qty,
                sum(a1.begin_qty * e.price) begin_value,
                0                           in_qty,
                0                           in_value,
                0                           issue_qty,
                0                           issue_value,
                0                           profit_loss_qty,
                0                           profit_loss_value,
                0                           return_qty,
                0                           return_value,
                0                           end_qty,
                0                           end_value
         FROM fin_cst_pac_item_costs_summary a1
            LEFT JOIN bas_stock_organization b on a1.summary_org_id = b.id
                  INNER JOIN gds_goods c1 ON a1.summary_item_id = c1.id
                  LEFT JOIN gds_goods_base_attribute av ON av.goods_id = c1.id
                  INNER JOIN (
             SELECT a.summary_item_id,
                    max(b.modify_time) max_time
             FROM fin_cst_pac_item_costs_summary a
                      INNER JOIN mkt_price_control b ON a.summary_item_id = b.goods_id
                 AND a.create_time BETWEEN b.enable_time
                                                            AND b.disable_time
                      INNER JOIN gds_goods c ON a.summary_item_id = c.id
                      LEFT JOIN gds_goods_base_attribute av ON av.goods_id = c.id
             WHERE ((DATE_FORMAT(a.period_start_date, '%Y-%m') BETWEEN '@startEndDate_START' AND '@startEndDate_END') OR
                    ('@startEndDate_START' = '@' AND '@startEndDate_END' = '@'))
             GROUP BY a.summary_item_id
         ) d -- 获取最新取价
                             ON d.summary_item_id = a1.summary_item_id
                  INNER JOIN mkt_price_control e ON e.goods_id = d.summary_item_id
             AND e.modify_time = d.max_time
         WHERE ((DATE_FORMAT(a1.period_start_date, '%Y-%m') BETWEEN '@startEndDate_START' AND '@startEndDate_END') OR
                ('@startEndDate_START' = '@' AND '@startEndDate_END' = '@'))
         GROUP BY c1.CODE,
                  c1.NAME,
                  b.name
         UNION ALL
         SELECT c1.CODE               goods_code,
                c1.NAME               goods_name,
                b.name                inventory_name,
                0                     begin_qty,
                0                     begin_value,
                sum(a1.qty)           in_qty,
                sum(a1.qty * e.price) in_value,
                0                     issue_qty,
                0                     issue_value,
                0                     profit_loss_qty,
                0                     profit_loss_value,
                0                     return_qty,
                0                     return_value,
                0                     end_qty,
                0                     end_value
         FROM stk_assigner_workflow a1
             LEFT JOIN bas_stock_organization b on a1.stock_organization_id = b.id
                  INNER JOIN gds_goods c1 ON a1.goods_id = c1.id
                  LEFT JOIN gds_goods_base_attribute av ON av.goods_id = c1.id
                  INNER JOIN (
             SELECT a.goods_id,
                    max(b.modify_time) max_time
             FROM stk_assigner_workflow a
                      INNER JOIN mkt_price_control b ON a.goods_id = b.goods_id
                 AND a.create_time BETWEEN b.enable_time
                                                            AND b.disable_time
                      INNER JOIN gds_goods c ON a.goods_id = c.id
                      LEFT JOIN gds_goods_base_attribute av ON av.goods_id = c.id
             WHERE a.assigner_id = '10001'
               AND a.qty_type = 11
               AND ((a.create_time BETWEEN '@startEndDate_START' AND '@startEndDate_END') OR
                    ('@startEndDate_START' = '@' AND '@startEndDate_END' = '@'))
               AND (a.assignee_id in ('@assignee') OR '@assignee' = '@')
               AND (a.goods_id in ('@goods') OR '@goods' = '@')
               AND (c.brand_id in ('@brand') OR '@brand' = '@')
               AND (av.field_14 in ('@field22') OR '@field22' = '@')
               AND (a.stock_organization_id in ('@inventory') OR '@inventory' = '@')
             GROUP BY a.goods_id
         ) d -- 获取最新取价
                             ON d.goods_id = a1.goods_id
                  INNER JOIN mkt_price_control e ON e.goods_id = d.goods_id
             AND e.modify_time = d.max_time
         WHERE a1.assigner_id = '10001'
           AND a1.qty_type = 11
           AND ((a1.create_time BETWEEN '@startEndDate_START' AND '@startEndDate_END') OR
                ('@startEndDate_START' = '@' AND '@startEndDate_END' = '@'))
           AND (a1.assignee_id in ('@assignee') OR '@assignee' = '@')
           AND (a1.goods_id in ('@goods') OR '@goods' = '@')
           AND (c1.brand_id in ('@brand') OR '@brand' = '@')
           AND (av.field_14 in ('@field22') OR '@field22' = '@')
           AND (a1.stock_organization_id in ('@inventory') OR '@inventory' = '@')
         GROUP BY c1.CODE,
                  c1.NAME,
                  b.name
         UNION ALL
         SELECT c1.CODE               goods_code,
                c1.NAME               goods_name,
                b.name                inventory_name,
                0                     begin_qty,
                0                     begin_value,
                0                     in_qty,
                0                     in_value,
                sum(a1.qty)           issue_qty,
                sum(a1.qty * e.price) issue_value,
                0                     profit_loss_qty,
                0                     profit_loss_value,
                0                     return_qty,
                0                     return_value,
                0                     end_qty,
                0                     end_value
         FROM stk_assigner_workflow a1
             LEFT JOIN bas_stock_organization b on a1.stock_organization_id = b.id
                  INNER JOIN gds_goods c1 ON a1.goods_id = c1.id
                  LEFT JOIN gds_goods_base_attribute av ON av.goods_id = c1.id
                  INNER JOIN (
             SELECT a.goods_id,
                    max(b.modify_time) max_time
             FROM stk_assigner_workflow a
                      INNER JOIN mkt_price_control b ON a.goods_id = b.goods_id
                 AND a.create_time BETWEEN b.enable_time
                                                            AND b.disable_time
                      INNER JOIN gds_goods c ON a.goods_id = c.id
                      LEFT JOIN gds_goods_base_attribute av ON av.goods_id = c.id
             WHERE a.assigner_id = '10001'
               AND a.qty_type = 13
               AND ((a.create_time BETWEEN '@startEndDate_START' AND '@startEndDate_END') OR
                    ('@startEndDate_START' = '@' AND '@startEndDate_END' = '@'))
               AND (a.assignee_id in ('@assignee') OR '@assignee' = '@')
               AND (a.goods_id in ('@goods') OR '@goods' = '@')
               AND (c.brand_id in ('@brand') OR '@brand' = '@')
               AND (av.field_14 in ('@field22') OR '@field22' = '@')
               AND (a.stock_organization_id in ('@inventory') OR '@inventory' = '@')
             GROUP BY a.goods_id
         ) d -- 获取最新取价
                             ON d.goods_id = a1.goods_id
                  INNER JOIN mkt_price_control e ON e.goods_id = d.goods_id
             AND e.modify_time = d.max_time
         WHERE a1.assigner_id = '10001'
           AND a1.qty_type = 13
           AND ((a1.create_time BETWEEN '@startEndDate_START' AND '@startEndDate_END') OR
                ('@startEndDate_START' = '@' AND '@startEndDate_END' = '@'))
           AND (a1.assignee_id in ('@assignee') OR '@assignee' = '@')
           AND (a1.goods_id in ('@goods') OR '@goods' = '@')
           AND (c1.brand_id in ('@brand') OR '@brand' = '@')
           AND (av.field_14 in ('@field22') OR '@field22' = '@')
           AND (a1.stock_organization_id in ('@inventory') OR '@inventory' = '@')
         GROUP BY c1.CODE,
                  c1.NAME,
                  b.name
         UNION ALL
         SELECT c1.CODE               goods_code,
                c1.NAME               goods_name,
                b.name                inventory_name,
                0                     begin_qty,
                0                     begin_value,
                0                     in_qty,
                0                     in_value,
                0                     issue_qty,
                0                     issue_value,
                sum(a1.qty)           profit_loss_qty,
                sum(a1.qty * e.price) profit_loss_value,
                0                     return_qty,
                0                     return_value,
                0                     end_qty,
                0                     end_value
         FROM stk_assigner_workflow a1
                LEFT JOIN bas_stock_organization b on a1.stock_organization_id = b.id
                  INNER JOIN gds_goods c1 ON a1.goods_id = c1.id
                  LEFT JOIN gds_goods_base_attribute av ON av.goods_id = c1.id
                  INNER JOIN (
             SELECT a.goods_id,
                    max(b.modify_time) max_time
             FROM stk_assigner_workflow a
                      INNER JOIN mkt_price_control b ON a.goods_id = b.goods_id
                 AND a.create_time BETWEEN b.enable_time
                                                            AND b.disable_time
                      INNER JOIN gds_goods c ON a.goods_id = c.id
                      LEFT JOIN gds_goods_base_attribute av ON av.goods_id = c.id
             WHERE a.assigner_id = '10001'
               AND a.qty_type = 16
               AND ((a.create_time BETWEEN '@startEndDate_START' AND '@startEndDate_END') OR
                    ('@startEndDate_START' = '@' AND '@startEndDate_END' = '@'))
               AND (a.assignee_id in ('@assignee') OR '@assignee' = '@')
               AND (a.goods_id in ('@goods') OR '@goods' = '@')
               AND (c.brand_id in ('@brand') OR '@brand' = '@')
               AND (av.field_14 in ('@field22') OR '@field22' = '@')
               AND (a.stock_organization_id in ('@inventory') OR '@inventory' = '@')
             GROUP BY a.goods_id
         ) d -- 获取最新取价
                             ON d.goods_id = a1.goods_id
                  INNER JOIN mkt_price_control e ON e.goods_id = d.goods_id
             AND e.modify_time = d.max_time
         WHERE a1.assigner_id = '10001'
           AND a1.qty_type = 16
           AND ((a1.create_time BETWEEN '@startEndDate_START' AND '@startEndDate_END') OR
                ('@startEndDate_START' = '@' AND '@startEndDate_END' = '@'))
           AND (a1.assignee_id in ('@assignee') OR '@assignee' = '@')
           AND (a1.goods_id in ('@goods') OR '@goods' = '@')
           AND (c1.brand_id in ('@brand') OR '@brand' = '@')
           AND (av.field_14 in ('@field22') OR '@field22' = '@')
           AND (a1.stock_organization_id in ('@inventory') OR '@inventory' = '@')
         GROUP BY c1.CODE,
                  c1.NAME,
                  b.name
         UNION ALL
         SELECT c1.CODE               goods_code,
                c1.NAME               goods_name,
                b.name                inventory_name,
                0                     begin_qty,
                0                     begin_value,
                0                     in_qty,
                0                     in_value,
                0                     issue_qty,
                0                     issue_value,
                0                     profit_loss_qty,
                0                     profit_loss_value,
                sum(a1.qty)           return_qty,
                sum(a1.qty * e.price) return_value,
                0                     end_qty,
                0                     end_value
         FROM stk_assigner_workflow a1
                  LEFT JOIN bas_stock_organization b on a1.stock_organization_id = b.id
                  INNER JOIN gds_goods c1 ON a1.goods_id = c1.id
                  LEFT JOIN gds_goods_base_attribute av ON av.goods_id = c1.id
                  INNER JOIN (
             SELECT a.goods_id,
                    max(b.modify_time) max_time
             FROM stk_assigner_workflow a
                      INNER JOIN mkt_price_control b ON a.goods_id = b.goods_id
                 AND a.create_time BETWEEN b.enable_time
                                                            AND b.disable_time
                      INNER JOIN gds_goods c ON a.goods_id = c.id
                      LEFT JOIN gds_goods_base_attribute av ON av.goods_id = c.id
             WHERE a.assigner_id = '10001'
               AND a.qty_type = 12
               AND ((a.create_time BETWEEN '@startEndDate_START' AND '@startEndDate_END') OR
                    ('@startEndDate_START' = '@' AND '@startEndDate_END' = '@'))
               AND (a.assignee_id in ('@assignee') OR '@assignee' = '@')
               AND (a.goods_id in ('@goods') OR '@goods' = '@')
               AND (c.brand_id in ('@brand') OR '@brand' = '@')
               AND (av.field_14 in ('@field22') OR '@field22' = '@')
               AND (a.stock_organization_id in ('@inventory') OR '@inventory' = '@')
             GROUP BY a.goods_id
         ) d -- 获取最新取价
                             ON d.goods_id = a1.goods_id
                  INNER JOIN mkt_price_control e ON e.goods_id = d.goods_id
             AND e.modify_time = d.max_time
         WHERE a1.assigner_id = '10001'
           AND a1.qty_type = 12
           AND ((a1.create_time BETWEEN '@startEndDate_START' AND '@startEndDate_END') OR
                ('@startEndDate_START' = '@' AND '@startEndDate_END' = '@'))
           AND (a1.assignee_id in ('@assignee') OR '@assignee' = '@')
           AND (a1.goods_id in ('@goods') OR '@goods' = '@')
           AND (c1.brand_id in ('@brand') OR '@brand' = '@')
           AND (av.field_14 in ('@field22') OR '@field22' = '@')
           AND (a1.stock_organization_id in ('@inventory') OR '@inventory' = '@')
         GROUP BY c1.CODE,
                  c1.NAME,
                  b.name
     ) d
GROUP BY goods_code,
         goods_name,
         inventory_name