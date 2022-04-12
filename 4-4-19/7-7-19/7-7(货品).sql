SELECT
	a.hl AS hl,
	a.gName AS gName,
	COALESCE ( "大类" ) AS dl,
	IFNULL( b.qcsl, 0 ) AS qcsl,
	IFNULL( b.qcje, 0 ) AS qcje,
	IFNULL( c.bcjhsl, 0 ) AS bcjhsl,
	IFNULL( c.bcjhje, 0 ) AS bcjhje,
	IFNULL( d.bcthsl, 0 ) AS bcthsl,
	IFNULL( d.bcthje, 0 ) AS bcthje,
	IFNULL( e.bcxssl, 0 ) AS bcxssl,
	IFNULL( e.bcxsje, 0 ) AS bcxsje,
	IFNULL( f.bqhhsl, 0 ) AS bqhhsl,
	IFNULL( f.bqhhje, 0 ) AS bqhhje,
	IFNULL( g.bcyksl, 0 ) AS bcyksl,
	IFNULL( g.bcykje, 0 ) AS bcykje,
	IFNULL( h.nbdbdcsl, 0 ) AS nbdbdcsl,
	IFNULL( i.nbdbdrsl, 0 ) AS nbdbdrsl,
	COALESCE ( 0 ) AS nbdbje,
	IFNULL(
		IFNULL( b.qcsl, 0 )+ IFNULL( c.bcjhsl, 0 )+ IFNULL( d.bcthsl, 0 )- IFNULL( e.bcxssl, 0 )- IFNULL( f.bqhhsl, 0 )+ IFNULL( g.bcyksl, 0 )- IFNULL( h.nbdbdcsl, 0 )+ IFNULL( i.nbdbdrsl, 0 ),
		0
	) AS bqqmsl,
	IFNULL(
		IFNULL( b.qcje, 0 )+ IFNULL( c.bcjhje, 0 )+ IFNULL( d.bcthje, 0 )- IFNULL( e.bcxsje, 0 )- IFNULL( f.bqhhje, 0 )+ IFNULL( g.bcykje, 0 ),
		0
	) AS bqqmje
FROM
	(
	SELECT
		ggba.field_2 AS hl,
		ga.NAME AS gName
	FROM
		gds_goods_base_attribute ggba
		INNER JOIN gds_attrvalue ga ON ggba.field_2 = ga.id
	WHERE
		(ggba.field_4 LIKE '%@HH%' OR '@HH'='%@%')
	GROUP BY
		ggba.field_2
	) a
	LEFT JOIN (
	SELECT
		ggba.field_2 hl,
		IFNULL( sum( fcpic.total_layer_qty ), 0 ) AS qcsl,
		IFNULL( sum( fcpic.item_value ), 0 ) AS qcje
	FROM
		fin_cst_pac_item_costs_summary fcpic
		LEFT JOIN gds_goods_base_attribute ggba ON fcpic.summary_item_id = ggba.goods_id
		and (ggba.field_4 LIKE '%@HH%' OR '@HH'='%@%')
		LEFT JOIN bas_customer bc ON fcpic.summary_org_id = bc.accounting_company_id AND (bc.id IN ('@CUSTOMER') OR '@CUSTOMER'='@')
	WHERE
	 ((fcpic.period_start_date >= CONCAT('@BEGIN_DATE','-01'))
     OR ('@BEGIN_DATE'='@'))
		AND ((fcpic.period_end_date <= CONCAT('@END_DATE','-31')) OR ('@END_DATE'='@'))
	GROUP BY
		ggba.field_2
	) b ON a.hl = b.hl
	LEFT JOIN (
	SELECT
		ggba.field_2 AS hl,
		IFNULL( sum( sslw.change_qty ), 0 ) AS bcjhsl,
		IFNULL( sum( sslw.amount ), 0 ) bcjhje
	FROM
		stk_stock_logic_workflow sslw
		LEFT JOIN (
		SELECT
			blp.id ownerId
		FROM
			bas_customer bc
			LEFT JOIN bas_legal_person_company blpc ON bc.legal_person_company_id = blpc.id
			LEFT JOIN bas_legal_person blp ON blpc.legal_person_code = blp.CODE
		WHERE
		(bc.id IN ('@CUSTOMER') OR '@CUSTOMER'='@')) o ON sslw.owner_id = o.ownerId
		LEFT JOIN gds_goods_base_attribute ggba ON sslw.goods_id = ggba.goods_id
	WHERE
		(ggba.field_4 LIKE '%@HH%' OR '@HH'='%@%')
		AND sslw.bill_name = "67"
		AND sslw.qty_type = "1"
		AND ((sslw.stock_date BETWEEN CONCAT('@BEGIN_DATE','-01')
				AND CONCAT('@END_DATE','-31'))
		OR ('@BEGIN_DATE'='@' AND '@END_DATE'='@'))
	GROUP BY
		ggba.field_2
	) c ON a.hl = c.hl
	LEFT JOIN (
	SELECT
		ggba.field_2 hl,
		IFNULL( sum( sslw.change_qty ), 0 ) bcthsl,
		IFNULL( sum( sslw.amount ), 0 ) bcthje
	FROM
		stk_stock_logic_workflow sslw
		LEFT JOIN (
		SELECT
			blp.id ownerId
		FROM
			bas_customer bc
			LEFT JOIN bas_legal_person_company blpc ON bc.legal_person_company_id = blpc.id
			LEFT JOIN bas_legal_person blp ON blpc.legal_person_code = blp.CODE
		WHERE
		(bc.id IN ('@CUSTOMER') OR '@CUSTOMER'='@')) o ON sslw.owner_id = o.ownerId
		LEFT JOIN gds_goods_base_attribute ggba ON sslw.goods_id = ggba.goods_id
	WHERE
		(ggba.field_4 LIKE '%@HH%' OR '@HH'='%@%')
		AND sslw.bill_name = "68"
		AND sslw.qty_type = "1"
		AND ((sslw.stock_date BETWEEN CONCAT('@BEGIN_DATE','-01')
				AND CONCAT('@END_DATE','-31'))
		OR ('@BEGIN_DATE'='@' AND '@END_DATE'='@'))
	GROUP BY
		ggba.field_2
	) d ON a.hl = d.hl
	LEFT JOIN (
	SELECT
		ggba.field_2 hl,
		IFNULL( sum( sslw.change_qty ), 0 ) bcxssl,
		IFNULL( sum( IFNULL( sslw.amount, 0 )+ IFNULL( f.costAmount, 0 )), 0 ) bcxsje
	FROM
		stk_stock_logic_workflow sslw
		INNER JOIN gds_goods_base_attribute ggba ON sslw.goods_id = ggba.goods_id
		LEFT JOIN (
		SELECT
			fcpug.goods_id goodsId,
			fcpug.cost_amount costAmount
		FROM
			fin_cst_pac_update_goods fcpug
			LEFT JOIN fin_cst_pac_update fcpu ON fcpu.id = fcpug.bill_id
			LEFT JOIN bas_customer bc ON bc.accounting_company_id = fcpu.base_company_id
		  and (bc.id IN ('@CUSTOMER') OR '@CUSTOMER'='@')
		WHERE
 ((fcpu.stock_date BETWEEN CONCAT('@BEGIN_DATE','-01')
					AND CONCAT('@END_DATE','-31'))
			OR ('@BEGIN_DATE'='@' AND '@END_DATE'='@'))) f ON sslw.goods_id = f.goodsId
	WHERE
		(ggba.field_4 LIKE '%@HH%' OR '@HH'='%@%')
		AND sslw.bill_name = "71"
		AND sslw.qty_type = "1"
		AND ((sslw.stock_date BETWEEN CONCAT('@BEGIN_DATE','-01')
				AND CONCAT('@END_DATE','-31'))
		OR ('@BEGIN_DATE'='@' AND '@END_DATE'='@'))
	GROUP BY
		ggba.field_2
	) e ON a.hl = e.hl
	LEFT JOIN (
	SELECT
		ggba.field_2 hl,
		IFNULL( sum( tsbl.qty ), 0 ) bqhhsl,
		IFNULL( sum( tsbl.amount ), 0 ) bqhhje
	FROM
		trade_sale_bill tsb
		LEFT JOIN trade_sale_bill_line tsbl ON tsb.id = tsbl.bill_id
		LEFT JOIN bas_customer bc ON bc.accounting_company_id = tsb.base_company_id
		AND (bc.id IN ('@CUSTOMER') OR '@CUSTOMER'='@')
		LEFT JOIN gds_goods_base_attribute ggba ON tsbl.goods_id = ggba.goods_id
		and (ggba.field_10 LIKE '%@HH%' OR '@HH'='%@%')
	WHERE
      tsb.bill_status = "15"
		AND tsb.sale_method = "C"
		AND ((tsb.stock_date BETWEEN CONCAT('@BEGIN_DATE','-01')
				AND CONCAT('@END_DATE','-31'))
		OR ('@BEGIN_DATE'='@' AND '@END_DATE'='@'))
	GROUP BY
		ggba.field_2
	) f ON a.hl = f.hl
	LEFT JOIN (
	SELECT
		ggba.field_2 hl,
		IFNULL( sum( sslw.change_qty ), 0 ) bcyksl,
		IFNULL( sum( sslw.amount ), 0 ) bcykje
	FROM
		stk_stock_logic_workflow sslw
		LEFT JOIN (
		SELECT
			blp.id ownerId
		FROM
			bas_customer bc
			LEFT JOIN bas_legal_person_company blpc ON bc.legal_person_company_id = blpc.id
			LEFT JOIN bas_legal_person blp ON blpc.legal_person_code = blp.CODE
		WHERE
		(bc.id IN ('@CUSTOMER') OR '@CUSTOMER'='@')) o ON sslw.owner_id = o.ownerId
		LEFT JOIN gds_goods_base_attribute ggba ON sslw.goods_id = ggba.goods_id
	WHERE
		(ggba.field_4 LIKE '%@HH%' OR '@HH'='%@%')
		AND sslw.bill_name = "1D"
		AND sslw.bill_type = "91"
		AND sslw.qty_type = "1"
		AND ((sslw.stock_date BETWEEN CONCAT('@BEGIN_DATE','-01')
				AND CONCAT('@END_DATE','-31')) OR ('@BEGIN_DATE'='@' AND '@END_DATE'='@'))
	GROUP BY
		ggba.field_2
	) g ON a.hl = g.hl
	LEFT JOIN (
	SELECT
		ggba.field_2 hl,
		IFNULL( sum( sslw.change_qty ), 0 ) nbdbdcsl
	FROM
		stk_stock_logic_workflow sslw
		LEFT JOIN (
		SELECT
			blp.id ownerId
		FROM
			bas_customer bc
			LEFT JOIN bas_legal_person_company blpc ON bc.legal_person_company_id = blpc.id
			LEFT JOIN bas_legal_person blp ON blpc.legal_person_code = blp.CODE
		WHERE
		(bc.id IN ('@CUSTOMER') OR '@CUSTOMER'='@')) o ON sslw.owner_id = o.ownerId
		LEFT JOIN gds_goods_base_attribute ggba ON sslw.goods_id = ggba.goods_id
	WHERE
		(ggba.field_4 LIKE '%@HH%' OR '@HH'='%@%')
		AND sslw.bill_name = "86"
		AND sslw.qty_type = "1"
		AND ((sslw.stock_date BETWEEN CONCAT('@BEGIN_DATE','-01')
		AND CONCAT('@END_DATE','-31'))
		OR ('@BEGIN_DATE'='@' AND '@END_DATE'='@'))
	GROUP BY
		ggba.field_2
	) h ON a.hl = h.hl
	LEFT JOIN (
	SELECT
		ggba.field_2 hl,
		IFNULL( sum( sslw.change_qty ), 0 ) nbdbdrsl
	FROM
		stk_stock_logic_workflow sslw
		LEFT JOIN (
		SELECT
			blp.id ownerId
		FROM
			bas_customer bc
			LEFT JOIN bas_legal_person_company blpc ON bc.legal_person_company_id = blpc.id
			LEFT JOIN bas_legal_person blp ON blpc.legal_person_code = blp.CODE
		WHERE
		(bc.id IN ('@CUSTOMER') OR '@CUSTOMER'='@')) o ON sslw.owner_id = o.ownerId
		LEFT JOIN gds_goods_base_attribute ggba ON sslw.goods_id = ggba.goods_id
	WHERE
		(ggba.field_4 LIKE '%@HH%' OR '@HH'='%@%')
		AND sslw.bill_name = "85"
		AND sslw.qty_type = "1"
		AND ((sslw.stock_date BETWEEN CONCAT('@BEGIN_DATE','-01')
				AND CONCAT('@END_DATE','-31'))
		OR ('@BEGIN_DATE'='@' AND '@END_DATE'='@'))
	GROUP BY
	ggba.field_2
	) i ON a.hl = i.hl