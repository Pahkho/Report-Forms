SELECT
	`code` AS `code`,
	`name` AS `name`,
	IFNULL( retail_amount, 0 ) AS retail_amount,
	IFNULL( settle_amount / retail_amount, 0 ) AS discount_rate,
	IFNULL( pay_amount, 0 ) AS pay_amount,
	IFNULL( settle_amount, 0 ) AS settle_amount,
	IFNULL( pay_amount / retail_amount, 0 ) AS rate_of_return,
	IFNULL( extax_amount, 0 ) AS extax_amount,
	IFNULL( selling_cost, 0 ) AS selling_cost,
	IFNULL( extax_amount - selling_cost, 0 ) AS gross_margin
FROM
	(
	SELECT
		a.CODE,
		a.NAME,
		round( sum( t.settle_qty * b.retail_price ), 2 ) retail_amount,
		round( sum( t.settle_qty * b.price ), 2 ) pay_amount,
		round( sum( t.settle_qty * b.pre_settle_price ), 2 ) settle_amount,
		round( sum( t.settle_qty * b.pre_settle_price / ( 1+b.tax_rate ) ), 2 ) extax_amount,
		round( sum( t.settle_qty * IFNULL ( c.item_cost, 0 )), 2 ) selling_cost
	FROM
		trade_retail_bill_shipment_info t
		LEFT JOIN bas_shop a ON t.shop_id = a.id AND (a.accounting_company_id IN (0) OR 1=1)
		LEFT JOIN trade_retail_bill_line b ON t.bill_line_id = b.id
		LEFT JOIN fin_cst_pac_item_costs_summary c ON t.stock_channle_id = c.summary_org_id
		AND b.goods_id = c.summary_item_id
	WHERE
		t.stock_type = 2
		AND t.cons_status = 'Y'
		AND ((DATE_FORMAT(t.delivery_time,'%Y-%m') BETWEEN '2020-01' AND '2022-05'))
	GROUP BY
		a.CODE,
		a.NAME

	UNION ALL

	SELECT
		a.CODE,
		a.NAME,
		round( sum( t.settle_qty * b.retail_price ), 2 ) retail_amount,
		round( sum( t.settle_qty * b.price ), 2 ) pay_amount,
		round( sum( t.settle_qty * b.pre_settle_price ), 2 ) settle_amount,
		round( sum( t.settle_qty * b.pre_settle_price / ( 1+b.tax_rate ) ), 2 ) extax_amount,
		round( sum( t.settle_qty * IFNULL ( c.item_cost, 0 )), 2 ) selling_cost
	FROM
		trade_retail_return_bill_shipment_info t
		LEFT JOIN bas_shop a ON t.shop_id = a.id AND (a.accounting_company_id IN (0) OR 1=1)
		LEFT JOIN trade_retail_return_bill_line b ON t.bill_line_id = b.id
		LEFT JOIN fin_cst_pac_item_costs_summary c ON t.stock_channle_id = c.summary_org_id
		AND b.goods_id = c.summary_item_id
	WHERE
		t.stock_type = 2
		AND t.cons_status = 'Y'
		AND ((DATE_FORMAT(t.delivery_time,'%Y-%m') BETWEEN '2022-01' AND '2022-05'))
	GROUP BY
		a.CODE,
		a.NAME
	) temp

