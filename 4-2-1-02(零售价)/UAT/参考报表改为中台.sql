SELECT a.name AS                                                                                                                                       NAME,
       SUM(IFNULL(d.d, 0))                                                                                                                             d,
       ROUND(SUM(IFNULL(d.d1, 0.00)), 2)                                                                                                               d1,
       SUM(IFNULL(e.d2, 0))                                                                                                                            d2,
       ROUND(SUM(IFNULL(e.d3, 0.00)), 2)                                                                                                               d3,
       SUM(IFNULL(f.d4, 0))                                                                                                                            d4,
       ROUND(SUM(IFNULL(f.d5, 0.00)), 2)                                                                                                               d5,
       SUM(IFNULL(i.d6, 0))                                                                                                                            d6,
       ROUND(SUM(IFNULL(i.d7, 0.00)), 2)                                                                                                               d7,
       SUM(IFNULL(j.d8, 0))                                                                                                                            d8,
       ROUND(SUM(IFNULL(j.d9, 0.00)), 2)                                                                                                               d9,
       SUM(IFNULL(k.d10, 0))                                                                                                                           d10,
       ROUND(SUM(IFNULL(k.d11, 0.00)), 2)                                                                                                              d11,
       SUM(IFNULL(m.d12, 0))                                                                                                                           d12,
       ROUND(SUM(IFNULL(m.d13, 0.00)), 2)                                                                                                              d13,
       SUM(IFNULL(n.d14, 0))                                                                                                                           d14,
       ROUND(SUM(IFNULL(n.d15, 0.00)), 2)                                                                                                              d15,
       SUM(IFNULL(d, 0) + IFNULL(d2, 0) + IFNULL(d4, 0) + IFNULL(d6, 0) + IFNULL(d8, 0) + IFNULL(d10, 0) + IFNULL(d12, 0) + IFNULL(d14, 0))            balance_amount,
       ROUND(SUM(IFNULL(d1, 0) + IFNULL(d3, 0) + IFNULL(d5, 0) + IFNULL(d7, 0) + IFNULL(d9, 0) + IFNULL(d11, 0) + IFNULL(d13, 0) + IFNULL(d15, 0)), 2) balance_price,
       a.cid
FROM (SELECT a.id, c.aid, c.cid, c.name AS NAME
      FROM gds_goods a
               INNER JOIN gds_goods_base_attribute b ON a.id = b.goods_id
               INNER JOIN (SELECT a.id aid, b.id cid, b.name
                           FROM gds_category_tree a,
                                (SELECT id, NAME FROM gds_category_tree WHERE level_num = 1) b
                           WHERE a.parent_id = b.id) c
                          ON b.`category_tree_id` = c.`aid`) a
         LEFT JOIN
     (SELECT a.summary_item_id                    AS goods_id,
             SUM(a.begin_qty)                     AS d,
             ROUND(SUM(a.begin_qty * c.price), 2) AS d1
      FROM fin_cst_pac_item_costs_summary a -- PAC商品成本表
               LEFT JOIN gds_goods b
                         ON a.summary_item_id = b.id
               LEFT JOIN mkt_price_control c -- 价格管理控制表
                         ON b.id = c.goods_id
               LEFT JOIN mkt_price_regulation d -- 价格定义规定表
                         ON c.price_id = d.id
      WHERE a.stock_type = 1 -- 账户类型
        AND d.id = 1
        AND ((DATE_FORMAT(a.create_time, '%Y-%m') BETWEEN '@CREATE_TIME_START' AND '@CREATE_TIME_END') OR ('@CREATE_TIME_START' = '@' AND '@CREATE_TIME_END' = '@'))
      GROUP BY a.summary_item_id) d ON d.goods_id = a.id
         LEFT JOIN
     (SELECT a.`goods_id`,
             SUM(a.change_qty) AS                      d2,
             ROUND(0 - SUM(a.change_qty * e.price), 2) d3
      FROM stk_stock_logic_workflow a
               LEFT JOIN bas_stock_organization b
                         ON a.stock_organization_id = b.id
               LEFT JOIN bas_accounting_company c
                         ON b.accounting_company_id = c.id
               LEFT JOIN gds_goods d
                         ON a.goods_id = d.id
               LEFT JOIN mkt_price_control e
                         ON d.id = e.goods_id
               LEFT JOIN mkt_price_regulation f
                         ON e.price_id = f.id
      WHERE c.CODE = '00000001'
        AND a.stock_type = 1
        AND a.qty_type = 1
        AND a.bill_name IN ('67', '68')
        AND f.id = 1
        AND ((DATE_FORMAT(a.create_time, '%Y-%m') BETWEEN '@CREATE_TIME_START' AND '@CREATE_TIME_END') OR ('@CREATE_TIME_START' = '@' AND '@CREATE_TIME_END' = '@'))
      GROUP BY a.goods_id) e
     ON e.goods_id = a.`id`
         LEFT JOIN
     (SELECT a.`goods_id`,
             0 - SUM(a.change_qty)                     AS d4,
             ROUND(0 - SUM(a.change_qty * e.price), 2) AS d5
      FROM stk_stock_logic_workflow a
               LEFT JOIN bas_stock_organization b
                         ON a.stock_organization_id = b.id
               LEFT JOIN bas_accounting_company c
                         ON b.accounting_company_id = c.id
               LEFT JOIN gds_goods d
                         ON a.goods_id = d.id
               LEFT JOIN mkt_price_control e
                         ON d.id = e.goods_id
               LEFT JOIN mkt_price_regulation f
                         ON e.price_id = f.id
      WHERE c.CODE = '00000001'
        AND a.stock_type = 1
        AND a.qty_type = 1
        AND a.bill_name = '71'
        AND f.id = 1
        AND ((DATE_FORMAT(a.create_time, '%Y-%m') BETWEEN '@CREATE_TIME_START' AND '@CREATE_TIME_END') OR ('@CREATE_TIME_START' = '@' AND '@CREATE_TIME_END' = '@'))
      GROUP BY a.`goods_id`) f
     ON f.goods_id = a.id
         LEFT JOIN
     (SELECT a.`goods_id`,

             SUM(a.change_qty) AS                  d6,
             ROUND(SUM(a.change_qty * e.price), 2) d7
      FROM stk_stock_logic_workflow a
               LEFT JOIN bas_stock_organization b
                         ON a.stock_organization_id = b.id
               LEFT JOIN bas_accounting_company c
                         ON b.accounting_company_id = c.id
               LEFT JOIN gds_goods d
                         ON a.goods_id = d.id
               LEFT JOIN mkt_price_control e
                         ON d.id = e.goods_id
               LEFT JOIN mkt_price_regulation f
                         ON e.price_id = f.id
      WHERE c.CODE = '00000001'
        AND a.stock_type = 1
        AND a.qty_type = 1
        AND a.bill_name = '1D'
        AND f.id = 1
        AND ((DATE_FORMAT(a.create_time, '%Y-%m') BETWEEN '@CREATE_TIME_START' AND '@CREATE_TIME_END') OR ('@CREATE_TIME_START' = '@' AND '@CREATE_TIME_END' = '@'))
      GROUP BY a.`goods_id`) i
     ON i.goods_id = a.`id`
         LEFT JOIN
     (SELECT a.`goods_id`,
             SUM(a.change_qty)                     AS d8,
             ROUND(SUM(a.change_qty * e.price), 2) AS d9
      FROM stk_stock_logic_workflow a
               LEFT JOIN bas_stock_organization b
                         ON a.stock_organization_id = b.id
               LEFT JOIN bas_accounting_company c
                         ON b.accounting_company_id = c.id
               LEFT JOIN gds_goods d
                         ON a.goods_id = d.id
               LEFT JOIN mkt_price_control e
                         ON d.id = e.goods_id
               LEFT JOIN mkt_price_regulation f
                         ON e.price_id = f.id
      WHERE c.CODE = '00000001'
        AND a.stock_type = 1
        AND a.qty_type = 1
        AND a.bill_name = '77'
        AND f.id = 1
        AND ((DATE_FORMAT(a.create_time, '%Y-%m') BETWEEN '@CREATE_TIME_START' AND '@CREATE_TIME_END') OR ('@CREATE_TIME_START' = '@' AND '@CREATE_TIME_END' = '@'))
      GROUP BY a.`goods_id`
     ) j
     ON j.goods_id = a.`id`
         LEFT JOIN
     (SELECT a.`goods_id`,
             SUM(a.change_qty)                     AS d10,
             ROUND(SUM(a.change_qty * e.price), 2) AS d11
      FROM stk_stock_logic_workflow a
               LEFT JOIN bas_stock_organization b
                         ON a.stock_organization_id = b.id
               LEFT JOIN bas_accounting_company c
                         ON b.accounting_company_id = c.id
               LEFT JOIN gds_goods d
                         ON a.goods_id = d.id
               LEFT JOIN mkt_price_control e
                         ON d.id = e.goods_id
               LEFT JOIN mkt_price_regulation f
                         ON e.price_id = f.id
      WHERE c.CODE = '00000001'
        AND a.stock_type = 1
        AND a.qty_type = 1
        AND a.bill_type = '06'
        AND f.id = 1
        AND ((DATE_FORMAT(a.create_time, '%Y-%m') BETWEEN '@CREATE_TIME_START' AND '@CREATE_TIME_END') OR ('@CREATE_TIME_START' = '@' AND '@CREATE_TIME_END' = '@'))
      GROUP BY a.`goods_id`) k
     ON k.goods_id = a.id
         LEFT JOIN
     (SELECT a.`goods_id`,
             0 - SUM(a.change_qty)                     AS d12,
             ROUND(0 - SUM(a.change_qty * e.price), 2) AS d13
      FROM stk_stock_logic_workflow a
               LEFT JOIN bas_stock_organization b
                         ON a.stock_organization_id = b.id
               LEFT JOIN bas_accounting_company c
                         ON b.accounting_company_id = c.id
               LEFT JOIN gds_goods d
                         ON a.goods_id = d.id
               LEFT JOIN mkt_price_control e
                         ON d.id = e.goods_id
               LEFT JOIN mkt_price_regulation f
                         ON e.price_id = f.id
      WHERE c.CODE = '00000001'
        AND a.stock_type = 1
        AND a.qty_type = 1
        AND a.bill_name IN ('89', '86', '1U')
        AND f.id = 1
        AND ((DATE_FORMAT(a.create_time, '%Y-%m') BETWEEN '@CREATE_TIME_START' AND '@CREATE_TIME_END') OR ('@CREATE_TIME_START' = '@' AND '@CREATE_TIME_END' = '@'))
      GROUP BY a.`goods_id`) m
     ON m.goods_id = a.`id`
         LEFT JOIN
     (SELECT a.`goods_id`,
             SUM(a.change_qty)                     AS d14,
             ROUND(SUM(a.change_qty * e.price), 2) AS d15
      FROM stk_stock_logic_workflow a
               LEFT JOIN bas_stock_organization b
                         ON a.stock_organization_id = b.id
               LEFT JOIN bas_accounting_company c
                         ON b.accounting_company_id = c.id
               LEFT JOIN gds_goods d
                         ON a.goods_id = d.id
               LEFT JOIN mkt_price_control e
                         ON d.id = e.goods_id
               LEFT JOIN mkt_price_regulation f
                         ON e.price_id = f.id
      WHERE c.CODE = '00000001'
        AND a.stock_type = 1
        AND a.qty_type = 1
        AND a.bill_name IN ('99', '85', '1V')
        AND f.id = 1
        AND (DATE_FORMAT(a.create_time, '%Y-%m') BETWEEN '@CREATE_TIME_START' AND '@CREATE_TIME_END')
      GROUP BY a.`goods_id`) n
     ON n.goods_id = a.id
WHERE 1 = 1
  AND (cid IN ('@ID') OR '@ID' = '@')
GROUP BY a.`name`, cid
HAVING CASE
           WHEN ''@BALANCE_AMOUNT'' IS NULL
    OR ''@BALANCE_AMOUNT'' = '[0]' OR  ''@BALANCE_PRICE'' = 'null'
        THEN 1 = 1
        ELSE BALANCE_AMOUNT != 0
    END
AND
     CASE
        WHEN ''@BALANCE_PRICE'' IS NULL OR  ''@BALANCE_PRICE'' = '[0]'  OR  ''@BALANCE_PRICE'' = 'null'
        THEN 1 = 1
        ELSE BALANCE_PRICE != 0
    END