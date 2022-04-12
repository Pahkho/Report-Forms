SELECT project.id,
       project.name,
       IFNULL(a.monthSaleroomRetail, 0)       AS monthSaleroomRetail,
       IFNULL(b.monthSaleroom, 0)             AS monthSaleroom,
       IFNULL(c.monthPositiveTaxInclusive, 0) AS monthPositiveTaxInclusive,
       IFNULL(d.monthPositiveNo, 0)           AS monthPositiveNo,
       IFNULL(e.monthBestSellerTax, 0)        AS monthBestSellerTax,
       IFNULL(f.monthBestSellerNo, 0)         AS monthBestSellerNo,
       IFNULL(g.monthClassTax, 0)             AS monthClassTax,
       IFNULL(h.monthClassNo, 0)              AS monthClassNo,
       IFNULL(i.accumulativeSales, 0)         AS accumulativeSales,
       IFNULL(j.accumulativeSaleroom, 0)      AS accumulativeSaleroom,
       IFNULL(k.accumulativePositive, 0)      AS accumulativePositive,
       IFNULL(l.accumulativeBestSeller, 0)    AS accumulativeBestSeller,
       IFNULL(m.accumulativeClassd, 0)        AS accumulativeClassd
FROM (SELECT id, NAME FROM bas_customer UNION ALL SELECT id, NAME FROM bas_shop) project
         RIGHT JOIN
     (SELECT IFNULL(SUM(monthSaleroomRetail), 0) AS monthSaleroomRetail, project
      FROM (SELECT a.change_qty * b.price AS monthSaleroomRetail, a.business_party_id AS project
            FROM (SELECT * FROM stk_stock_logic_workflow WHERE bill_name IN ('71', '77') AND qty_type = '1') a
                     LEFT JOIN
                     (SELECT * FROM mkt_price_control WHERE price_id = '1') b ON a.goods_id = b.goods_id
            WHERE (a.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (a.owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.change_qty * b.price AS monthSaleroomRetail, a.business_party_id AS project
            FROM (SELECT *
                  FROM stk_stock_logic_workflow
                  WHERE bill_name IN ('89', '99')
                    AND sale_confirm = 'Y'
                    AND qty_type = '1') a
                     LEFT JOIN (SELECT * FROM mkt_price_control WHERE price_id = '1') b ON a.goods_id = b.goods_id
            WHERE (a.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (a.owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.change_qty * b.price AS monthSaleroomRetail, c.shop_id AS project
            FROM (SELECT * FROM stk_stock_logic_workflow WHERE bill_name = ('69') AND qty_type = '1') a
                     LEFT JOIN
                     (SELECT * FROM mkt_price_control WHERE price_id = '1') b ON a.goods_id = b.goods_id
                     LEFT JOIN trade_retail_bill c ON a.bill_no = c.`bill_no`
            WHERE (a.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (a.owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.change_qty * b.price AS monthSaleroomRetail, c.shop_id AS project
            FROM (SELECT * FROM stk_stock_logic_workflow WHERE bill_name = ('74') AND qty_type = '1') a
                     LEFT JOIN
                     (SELECT * FROM mkt_price_control WHERE price_id = '1') b ON a.goods_id = b.goods_id
                     LEFT JOIN trade_retail_bill c ON a.bill_no = c.`bill_no`
            WHERE (a.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (a.owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) a
      GROUP BY project) a ON project.id = a.project
         LEFT JOIN
     (SELECT IFNULL(SUM(monthSaleroom), 0) AS monthSaleroom, project
      FROM (SELECT amount AS monthSaleroom, business_party_id AS project
            FROM stk_stock_logic_workflow
            WHERE bill_name IN ('71', '77')
              AND (stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS monthSaleroom, b.customer_id AS project
            FROM drp_cons_sale_bill_line a
                     LEFT JOIN drp_cons_sale_bill b ON a.cons_sale_bill_id = b.id
            WHERE (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS monthSaleroom, b.customer_id AS project
            FROM drp_cons_return_bill_line a
                     LEFT JOIN drp_cons_return_bill b ON a.cons_sale_return_bill_id = b.id
            WHERE (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS monthSaleroom, a.`shop_id` AS project
            FROM trade_retail_bill_payment a
                     LEFT JOIN trade_retail_bill b ON a.bill_id = b.id
            WHERE (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS monthSaleroom, a.`shop_id` AS project
            FROM trade_retail_return_bill_payment a
                     LEFT JOIN trade_retail_return_bill b ON a.bill_id = b.id
            WHERE (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) b
      GROUP BY project) b ON project.id = b.project
         LEFT JOIN
     (SELECT IFNULL(SUM(monthPositiveTaxInclusive), 0) AS monthPositiveTaxInclusive, project
      FROM (SELECT amount AS monthPositiveTaxInclusive, business_party_id AS project
            FROM stk_stock_logic_workflow
            WHERE bill_name IN ('71', '77')
              AND sales_item_id = '12'
              AND (stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS monthPositiveTaxInclusive, b.customer_id AS project
            FROM drp_cons_sale_bill_line a
                     LEFT JOIN drp_cons_sale_bill b ON a.cons_sale_bill_id = b.id
            WHERE b.sale_project_id = '12'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS monthPositiveTaxInclusive, b.customer_id AS project
            FROM drp_cons_return_bill_line a
                     LEFT JOIN drp_cons_return_bill b ON a.cons_sale_return_bill_id = b.id
            WHERE b.sale_project_id = '12'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS monthPositiveTaxInclusive, a.`shop_id` AS project
            FROM trade_retail_bill_payment a
                     LEFT JOIN trade_retail_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '12'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS monthPositiveTaxInclusive, a.`shop_id` AS project
            FROM trade_retail_return_bill_payment a
                     LEFT JOIN trade_retail_return_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '12'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) c
      GROUP BY project) c ON project.id = c.project
         LEFT JOIN
     (SELECT IFNULL(SUM(monthPositiveNo), 0) AS monthPositiveNo, project
      FROM (SELECT extax_amount AS monthPositiveNo, business_party_id AS project
            FROM stk_stock_logic_workflow
            WHERE bill_name IN ('71', '77')
              AND sales_item_id = '12'
              AND (stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.extax_amount AS monthPositiveNo, b.customer_id AS project
            FROM drp_cons_sale_bill_line a
                     LEFT JOIN drp_cons_sale_bill b ON a.cons_sale_bill_id = b.id
            WHERE b.sale_project_id = '12'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.extax_amount AS monthPositiveNo, b.customer_id AS project
            FROM drp_cons_return_bill_line a
                     LEFT JOIN drp_cons_return_bill b ON a.cons_sale_return_bill_id = b.id
            WHERE b.sale_project_id = '12'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.extax_amount AS monthPositiveNo, b.`shop_id` AS project
            FROM trade_retail_bill_line a
                     LEFT JOIN trade_retail_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '12'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.extax_amount AS monthPositiveNo, b.`shop_id` AS project
            FROM trade_retail_return_bill_line a
                     LEFT JOIN trade_retail_return_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '12'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) d
      GROUP BY project) d ON project.id = d.project
         LEFT JOIN
     (SELECT IFNULL(SUM(monthBestSellerTax), 0) AS monthBestSellerTax, project
      FROM (SELECT amount AS monthBestSellerTax, business_party_id AS project
            FROM stk_stock_logic_workflow
            WHERE bill_name IN ('71', '77')
              AND sales_item_id = '10030'
              AND (stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS monthBestSellerTax, b.customer_id AS project
            FROM drp_cons_sale_bill_line a
                     LEFT JOIN drp_cons_sale_bill b ON a.cons_sale_bill_id = b.id
            WHERE b.sale_project_id = '10030'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS monthBestSellerTax, b.customer_id AS project
            FROM drp_cons_return_bill_line a
                     LEFT JOIN drp_cons_return_bill b ON a.cons_sale_return_bill_id = b.id
            WHERE b.sale_project_id = '10030'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS monthBestSellerTax, a.`shop_id` AS project
            FROM trade_retail_bill_payment a
                     LEFT JOIN trade_retail_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '10030'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS monthBestSellerTax, a.`shop_id` AS project
            FROM trade_retail_return_bill_payment a
                     LEFT JOIN trade_retail_return_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '10030'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) e
      GROUP BY project) e ON project.id = e.project
         LEFT JOIN
     (SELECT IFNULL(SUM(monthBestSellerNo), 0) AS monthBestSellerNo, project
      FROM (SELECT extax_amount AS monthBestSellerNo, business_party_id AS project
            FROM stk_stock_logic_workflow
            WHERE bill_name IN ('71', '77')
              AND sales_item_id = '10030'
              AND (stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.extax_amount AS monthBestSellerNo, b.customer_id AS project
            FROM drp_cons_sale_bill_line a
                     LEFT JOIN drp_cons_sale_bill b ON a.cons_sale_bill_id = b.id
            WHERE b.sale_project_id = '10030'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.extax_amount AS monthBestSellerNo, b.customer_id AS project
            FROM drp_cons_return_bill_line a
                     LEFT JOIN drp_cons_return_bill b ON a.cons_sale_return_bill_id = b.id
            WHERE b.sale_project_id = '10030'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.extax_amount AS monthBestSellerNo, b.`shop_id` AS project
            FROM trade_retail_bill_line a
                     LEFT JOIN trade_retail_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '10030'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.extax_amount AS monthBestSellerNo, b.`shop_id` AS project
            FROM trade_retail_return_bill_line a
                     LEFT JOIN trade_retail_return_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '10030'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) f
      GROUP BY project) f ON project.id = f.project
         LEFT JOIN
     (SELECT IFNULL(SUM(monthClassTax), 0) AS monthClassTax, project
      FROM (SELECT amount AS monthClassTax, business_party_id AS project
            FROM stk_stock_logic_workflow
            WHERE bill_name IN ('71', '77')
              AND sales_item_id = '10029'
              AND (stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS monthClassTax, b.customer_id AS project
            FROM drp_cons_sale_bill_line a
                     LEFT JOIN drp_cons_sale_bill b ON a.cons_sale_bill_id = b.id
            WHERE b.sale_project_id = '10029'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS monthClassTax, b.customer_id AS project
            FROM drp_cons_return_bill_line a
                     LEFT JOIN drp_cons_return_bill b ON a.cons_sale_return_bill_id = b.id
            WHERE b.sale_project_id = '10029'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS monthClassTax, a.`shop_id` AS project
            FROM trade_retail_bill_payment a
                     LEFT JOIN trade_retail_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '10029'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS monthClassTax, a.`shop_id` AS project
            FROM trade_retail_return_bill_payment a
                     LEFT JOIN trade_retail_return_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '10029'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) g
      GROUP BY project) g ON project.id = f.project
         LEFT JOIN
     (SELECT IFNULL(SUM(monthClassNo), 0) AS monthClassNo, project
      FROM (SELECT extax_amount AS monthClassNo, business_party_id AS project
            FROM stk_stock_logic_workflow
            WHERE bill_name IN ('71', '77')
              AND sales_item_id = '10029'
              AND (stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.extax_amount AS monthClassNo, b.customer_id AS project
            FROM drp_cons_sale_bill_line a
                     LEFT JOIN drp_cons_sale_bill b ON a.cons_sale_bill_id = b.id
            WHERE b.sale_project_id = '10029'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.extax_amount AS monthClassNo, b.customer_id AS project
            FROM drp_cons_return_bill_line a
                     LEFT JOIN drp_cons_return_bill b ON a.cons_sale_return_bill_id = b.id
            WHERE b.sale_project_id = '10029'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.extax_amount AS monthClassNo, b.`shop_id` AS project
            FROM trade_retail_bill_line a
                     LEFT JOIN trade_retail_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '10029'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.extax_amount AS monthClassNo, b.`shop_id` AS project
            FROM trade_retail_return_bill_line a
                     LEFT JOIN trade_retail_return_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '10029'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) h
      GROUP BY project) h ON project.id = h.project
         LEFT JOIN
     (SELECT IFNULL(SUM(accumulativeSales), 0) AS accumulativeSales, project
      FROM (SELECT a.change_qty * b.price AS accumulativeSales, a.business_party_id AS project
            FROM (SELECT * FROM stk_stock_logic_workflow WHERE bill_name IN ('71', '77') AND qty_type = '1') a
                     LEFT JOIN
                     (SELECT * FROM mkt_price_control WHERE price_id = '1') b ON a.goods_id = b.goods_id
            WHERE (a.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (a.owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.change_qty * b.price AS accumulativeSales, a.business_party_id AS project
            FROM (SELECT *
                  FROM stk_stock_logic_workflow
                  WHERE bill_name IN ('89', '99')
                    AND sale_confirm = 'Y'
                    AND qty_type = '1') a
                     LEFT JOIN (SELECT * FROM mkt_price_control WHERE price_id = '1') b ON a.goods_id = b.goods_id
            WHERE (a.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (a.owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.change_qty * b.price AS accumulativeSales, c.shop_id AS project
            FROM (SELECT * FROM stk_stock_logic_workflow WHERE bill_name = ('69') AND qty_type = '1') a
                     LEFT JOIN
                     (SELECT * FROM mkt_price_control WHERE price_id = '1') b ON a.goods_id = b.goods_id
                     LEFT JOIN trade_retail_bill c ON a.bill_no = c.`bill_no`
            WHERE (a.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (a.owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.change_qty * b.price AS accumulativeSales, c.shop_id AS project
            FROM (SELECT * FROM stk_stock_logic_workflow WHERE bill_name = ('74') AND qty_type = '1') a
                     LEFT JOIN
                     (SELECT * FROM mkt_price_control WHERE price_id = '1') b ON a.goods_id = b.goods_id
                     LEFT JOIN trade_retail_bill c ON a.bill_no = c.`bill_no`
            WHERE (a.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (a.owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) i
      GROUP BY project) i ON project.id = i.project
         LEFT JOIN
     (SELECT IFNULL(SUM(accumulativeSaleroom), 0) AS accumulativeSaleroom, project
      FROM (SELECT amount AS accumulativeSaleroom, business_party_id AS project
            FROM stk_stock_logic_workflow
            WHERE bill_name IN ('71', '77')
              AND (stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS accumulativeSaleroom, b.customer_id AS project
            FROM drp_cons_sale_bill_line a
                     LEFT JOIN drp_cons_sale_bill b ON a.cons_sale_bill_id = b.id
            WHERE (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS accumulativeSaleroom, b.customer_id AS project
            FROM drp_cons_return_bill_line a
                     LEFT JOIN drp_cons_return_bill b ON a.cons_sale_return_bill_id = b.id
            WHERE (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS accumulativeSaleroom, a.`shop_id` AS project
            FROM trade_retail_bill_payment a
                     LEFT JOIN trade_retail_bill b ON a.bill_id = b.id
            WHERE (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS accumulativeSaleroom, a.`shop_id` AS project
            FROM trade_retail_return_bill_payment a
                     LEFT JOIN trade_retail_return_bill b ON a.bill_id = b.id
            WHERE (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) j
      GROUP BY project) j ON project.id = j.project
         LEFT JOIN
     (SELECT IFNULL(SUM(accumulativePositive), 0) AS accumulativePositive, project
      FROM (SELECT amount AS accumulativePositive, business_party_id AS project
            FROM stk_stock_logic_workflow
            WHERE bill_name IN ('71', '77')
              AND sales_item_id = '12'
              AND (stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS accumulativePositive, b.customer_id AS project
            FROM drp_cons_sale_bill_line a
                     LEFT JOIN drp_cons_sale_bill b ON a.cons_sale_bill_id = b.id
            WHERE b.sale_project_id = '12'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS accumulativePositive, b.customer_id AS project
            FROM drp_cons_return_bill_line a
                     LEFT JOIN drp_cons_return_bill b ON a.cons_sale_return_bill_id = b.id
            WHERE b.sale_project_id = '12'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS accumulativePositive, a.`shop_id` AS project
            FROM trade_retail_bill_payment a
                     LEFT JOIN trade_retail_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '12'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS accumulativePositive, a.`shop_id` AS project
            FROM trade_retail_return_bill_payment a
                     LEFT JOIN trade_retail_return_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '12'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) k
      GROUP BY project) k ON project.id = k.project
         LEFT JOIN
     (SELECT IFNULL(SUM(accumulativeBestSeller), 0) AS accumulativeBestSeller, project
      FROM (SELECT amount AS accumulativeBestSeller, business_party_id AS project
            FROM stk_stock_logic_workflow
            WHERE bill_name IN ('71', '77')
              AND sales_item_id = '10030'
              AND (stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS accumulativeBestSeller, b.customer_id AS project
            FROM drp_cons_sale_bill_line a
                     LEFT JOIN drp_cons_sale_bill b ON a.cons_sale_bill_id = b.id
            WHERE b.sale_project_id = '10030'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS accumulativeBestSeller, b.customer_id AS project
            FROM drp_cons_return_bill_line a
                     LEFT JOIN drp_cons_return_bill b ON a.cons_sale_return_bill_id = b.id
            WHERE b.sale_project_id = '10030'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS accumulativeBestSeller, a.`shop_id` AS project
            FROM trade_retail_bill_payment a
                     LEFT JOIN trade_retail_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '10030'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS accumulativeBestSeller, a.`shop_id` AS project
            FROM trade_retail_return_bill_payment a
                     LEFT JOIN trade_retail_return_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '10030'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) l
      GROUP BY project) l ON project.id = l.project
         LEFT JOIN
     (SELECT IFNULL(SUM(accumulativeClassd), 0) AS accumulativeClassd, project
      FROM (SELECT amount AS accumulativeClassd, business_party_id AS project
            FROM stk_stock_logic_workflow
            WHERE bill_name IN ('71', '77')
              AND sales_item_id = '10029'
              AND (stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (owner_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS accumulativeClassd, b.customer_id AS project
            FROM drp_cons_sale_bill_line a
                     LEFT JOIN drp_cons_sale_bill b ON a.cons_sale_bill_id = b.id
            WHERE b.sale_project_id = '10029'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.goods_price AS accumulativeClassd, b.customer_id AS project
            FROM drp_cons_return_bill_line a
                     LEFT JOIN drp_cons_return_bill b ON a.cons_sale_return_bill_id = b.id
            WHERE b.sale_project_id = '10029'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS accumulativeClassd, a.`shop_id` AS project
            FROM trade_retail_bill_payment a
                     LEFT JOIN trade_retail_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '10029'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
            UNION ALL
            SELECT a.settle_amount AS accumulativeClassd, a.`shop_id` AS project
            FROM trade_retail_return_bill_payment a
                     LEFT JOIN trade_retail_return_bill b ON a.bill_id = b.id
            WHERE b.sale_project_id = '10029'
              AND (b.stock_date LIKE '%@startDate%' OR '@startDate'='%@%')
              OR (b.base_company_id IN ('@accountingCompanyId') OR '@accountingCompanyId'='@')
           ) m
      GROUP BY project) m ON project.id = m.project