SELECT
		ANY_VALUE(seq) AS seq,
		ANY_VALUE(t.huoLing) AS huoLing,
		ANY_VALUE(t.type) AS type,
		ANY_VALUE(t.typeCode) AS typeCode,
		ANY_VALUE(t.daLei) AS daLei,
		SUM(t.saleQty),
		SUM(t.retailAmount),
		SUM(t.taxSaleAmount),
		SUM(t.exTaxSaleAmount),
		SUM(t.saleCostQty),
		(SUM(t.exTaxSaleAmount)-SUM(t.saleCostQty)) AS grossProfit,
		IF(((SUM(t.exTaxSaleAmount)-SUM(t.saleCostQty))/SUM(t.exTaxSaleAmount)) IS NULL,0,((SUM(t.exTaxSaleAmount)-SUM(t.saleCostQty))/SUM(t.exTaxSaleAmount))) AS grossProfitRate
FROM (
   SELECT
		  1 AS seq,
      '货龄' AS huoLing,
			'经销' AS type,
			NULL AS typeCode,
			'大类' AS daLei,
			SUM(sslw.change_qty) AS saleQty,
			SUM(sslw.change_qty)*ANY_VALUE(mpc2.price) AS retailAmount,
			SUM(sslw.amount) AS taxSaleAmount,
			SUM(sslw.extax_amount) AS exTaxSaleAmount,
			SUM(IF(sslw.unit_cost IS NULL OR sslw.unit_cost = '',0,sslw.unit_cost)*IF(sslw.change_qty IS NULL OR sslw.change_qty = '',0,sslw.change_qty)) AS saleCostQty
		FROM stk_stock_logic_workflow sslw
		 LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
		 LEFT JOIN bas_brand bb ON gg.brand_id = bb.id
		 LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
		 LEFT JOIN (
				SELECT mpc1.* FROM (
					SELECT ANY_VALUE(price) AS price,ANY_VALUE(id) AS id,ANY_VALUE(goods_id) AS goods_id,
					ANY_VALUE(create_time) AS create_time FROM mkt_price_control
						WHERE 1=1 AND price_id = 1 ORDER BY create_time DESC LIMIT 9999999
			 ) mpc1 GROUP BY mpc1.goods_id
		 )mpc2 ON mpc2.goods_id = sslw.goods_id
		WHERE 1=1
		  AND (sslw.bill_name IN (71,77))
			AND (sslw.qty_type = 1)
			AND (ggba.field_4 LIKE '%${E3PLUS_QC_ART_NO}%' )
			AND (bb.id IN ('${E3PLUS_QC_BRAND_ID}') OR 1=1)
			AND ((DATE_FORMAT(sslw.create_time,'%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}') )
	UNION ALL
		SELECT tab.* FROM (
				SELECT
				  2 AS seq,
					'货龄' AS huoLing,
					'退货冲红' AS type,
					NULL AS typeCode,
					'大类' AS daLei,
					SUM(tt.saleQty) AS saleQty,
					ANY_VALUE(tt.saleQty)*ANY_VALUE(tt.price) AS retailAmount,
					ANY_VALUE(tt.amount) AS taxSaleAmount,
					ANY_VALUE(tt.extaxAmount) AS exTaxSaleAmount,
					ANY_VALUE(IF(tt.saleQty IS NULL OR tt.saleQty = '',0,tt.saleQty))*SUM(IF(fcpic.item_cost IS NULL OR fcpic.item_cost = '',0,fcpic.item_cost)) AS saleCostQty
				FROM (
						SELECT
							ANY_VALUE(tsrbl.id) AS tsrblId,
							ANY_VALUE(tsrb.base_company_id) AS baseCompanyId,
							ANY_VALUE(tsrb.complete_time) AS completeTime,
							ANY_VALUE(tsrbl.sku_id) AS skuId,
							ANY_VALUE(tsrbl.amount) AS amount,
							ANY_VALUE(tsrbl.extax_amount) AS extaxAmount,
							ANY_VALUE(tsrbl.sale_qty) AS saleQty,
							ANY_VALUE(mpc2.price) AS price
						FROM trade_sale_return_bill_line tsrbl
							LEFT JOIN trade_sale_return_bill tsrb ON tsrbl.bill_id = tsrb.id
							LEFT JOIN gds_goods gg ON gg.id = tsrbl.goods_id
							LEFT JOIN bas_brand bb ON gg.brand_id = bb.id
							LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
							LEFT JOIN (
									SELECT mpc1.* FROM (
										SELECT ANY_VALUE(price) AS price,ANY_VALUE(id) AS id,ANY_VALUE(goods_id) AS goods_id,
										ANY_VALUE(create_time) AS create_time FROM mkt_price_control
											WHERE 1=1 AND price_id = 1 ORDER BY create_time DESC LIMIT 9999999
								 ) mpc1 GROUP BY mpc1.goods_id
							 )mpc2 ON mpc2.goods_id = tsrbl.goods_id
						WHERE 1=1
							AND tsrb.bill_status = 5
							AND tsrb.sale_method = 'S'
							AND (ggba.field_4 LIKE '%${E3PLUS_QC_ART_NO}%' )
							AND (bb.id IN ('${E3PLUS_QC_BRAND_ID}') OR 1=1)
							AND ((DATE_FORMAT(tsrb.create_time,'%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}') )
					) tt LEFT JOIN fin_cst_pac_item_costs fcpic ON (fcpic.sku_id = tt.skuId AND fcpic.base_company_id = tt.baseCompanyId
							AND fcpic.period_start_date <= tt.completeTime AND fcpic.period_end_date >= tt.completeTime)
					WHERE 1=1
					GROUP BY tt.tsrblId
		) tab
	UNION ALL
			SELECT
				3 AS seq,
				'货龄' AS huoLing,
				ANY_VALUE(CONCAT('代销-',bso.name)) AS type,
				ANY_VALUE(bso.code) AS typeCode,
				'大类' AS daLei,
				SUM(sslw.change_qty) AS saleQty,
				SUM(sslw.change_qty*ANY_VALUE(mpc2.price)) AS retailAmount,
				SUM(sslw.amount) AS taxSaleAmount,
				SUM(sslw.extax_amount) AS exTaxSaleAmount,
				SUM(IF(sslw.change_qty IS NULL OR sslw.change_qty = '',0,sslw.change_qty)*IF(sslw.unit_cost IS NULL OR sslw.unit_cost = '',0,sslw.unit_cost)) AS saleCostQty
			FROM  stk_stock_logic_workflow sslw
				LEFT JOIN bas_logic_warehouse blw ON blw.id = sslw.logic_warehouse_id
				LEFT JOIN bas_stock_organization bso ON bso.id = blw.stock_organization_id
				LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
				LEFT JOIN bas_brand bb ON bb.id = gg.brand_id
				LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
				LEFT JOIN (
									SELECT mpc1.* FROM (
										SELECT ANY_VALUE(price) AS price,ANY_VALUE(id) AS id,ANY_VALUE(goods_id) AS goods_id,
										ANY_VALUE(create_time) AS create_time FROM mkt_price_control
											WHERE 1=1 AND price_id = 1 ORDER BY create_time DESC LIMIT 9999999
								 ) mpc1 GROUP BY mpc1.goods_id
							 )mpc2 ON mpc2.goods_id = sslw.goods_id
			WHERE 1=1
				AND sslw.bill_name IN (89,99)
				AND sslw.qty_type = 1
				AND sslw.sale_confirm = 'Y'
				AND bso.code IN (44010087,44010086,44010083,44010081,51020050,21010028,11010014)
				AND (ggba.field_4 LIKE '%${E3PLUS_QC_ART_NO}%' )
				AND (bb.id IN ('${E3PLUS_QC_BRAND_ID}') OR 1=1)
				AND ((DATE_FORMAT(sslw.create_time,'%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}') )
			GROUP BY bso.id
		UNION ALL
			SELECT
				4 AS seq,
				'货龄' AS huoLing,
				ANY_VALUE(CONCAT('代销-',bso.name)) AS type,
				ANY_VALUE(bso.code) AS typeCode,
				'大类' AS daLei,
				SUM(sslw.change_qty) AS saleQty,
				SUM(sslw.change_qty*mpc2.price) AS retailAmount,
				SUM(sslw.amount) AS taxSaleAmount,
				SUM(sslw.extax_amount) AS exTaxSaleAmount,
				SUM(IF(sslw.change_qty IS NULL OR sslw.change_qty = '',0,sslw.change_qty)*IF(sslw.unit_cost IS NULL OR sslw.change_qty = '',0,sslw.change_qty)) AS saleCostQty
			FROM stk_stock_logic_workflow sslw
				LEFT JOIN bas_logic_warehouse blw ON blw.id = sslw.logic_warehouse_id
				LEFT JOIN bas_stock_organization bso ON bso.id = blw.stock_organization_id
				LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
				LEFT JOIN bas_brand bb ON bb.id = gg.brand_id
				LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
				LEFT JOIN (
									SELECT mpc1.* FROM (
										SELECT ANY_VALUE(price) AS price,ANY_VALUE(id) AS id,ANY_VALUE(goods_id) AS goods_id,
										ANY_VALUE(create_time) AS create_time FROM mkt_price_control
											WHERE 1=1 AND price_id = 1 ORDER BY create_time DESC LIMIT 9999999
								 ) mpc1 GROUP BY mpc1.goods_id
							 )mpc2 ON mpc2.goods_id = sslw.goods_id
			WHERE 1=1
				AND sslw.bill_name IN (89,99)
				AND sslw.qty_type = 1
				AND sslw.sale_confirm = 'Y'
				AND bso.code not IN (44010087,44010086,44010083,44010081,51020050,21010028,11010014)
				AND (ggba.field_4 LIKE '%${E3PLUS_QC_ART_NO}%' )
				AND (bb.id IN ('${E3PLUS_QC_BRAND_ID}') OR 1=1)
				AND ((DATE_FORMAT(sslw.create_time,'%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}') )
			GROUP BY bso.id
	UNION ALL
			SELECT
				5 AS seq,
				'货龄' AS huoLing,
				'经销库存转销售成本' AS type,
				NULL AS typeCode,
				'大类' AS daLei,
				0 AS saleQty,
				0 AS retailAmount,
				0 AS taxSaleAmount,
				0 AS exTaxSaleAmount,
			  SUM(IF(fcpug.cost_amount IS NULL OR fcpug.cost_amount = '',0,fcpug.cost_amount)) AS saleCostQty
		FROM fin_cst_pac_update_goods fcpug
			LEFT JOIN fin_cst_pac_update fcpu ON fcpug.bill_id = fcpu.id
			LEFT JOIN bas_accounting_company bac ON bac.id = fcpu.base_company_id
			LEFT JOIN gds_goods gg ON gg.id = fcpug.goods_id
			LEFT JOIN bas_brand bb ON bb.id = gg.brand_id
			LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
		WHERE 1=1
			AND fcpu.bill_type = '1C'
			AND bac.code = '00000001'
			AND fcpug.stock_type = 1
			AND (ggba.field_4 LIKE '%${E3PLUS_QC_ART_NO}%' )
			AND (bb.id IN ('${E3PLUS_QC_BRAND_ID}') OR 1=1)
			AND ((DATE_FORMAT(fcpu.create_time,'%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}') )
	UNION ALL
		SELECT
			6 AS seq,
			'货龄' AS huoLing,
			'代销库存转销售成本' AS type,
			NULL AS typeCode,
			'大类' AS daLei,
			0 AS saleQty,
			0 AS retailAmount,
			0 AS taxSaleAmount,
			0 AS exTaxSaleAmount,
			SUM(IF(fcpug.cost_amount IS NULL OR fcpug.cost_amount = '',0,fcpug.cost_amount)) AS saleCostQty
			FROM fin_cst_pac_update_goods fcpug
				LEFT JOIN fin_cst_pac_update fcpu ON fcpug.bill_id = fcpu.id
				LEFT JOIN bas_accounting_company bac ON bac.id = fcpu.base_company_id
				LEFT JOIN gds_goods gg ON gg.id = fcpug.goods_id
				LEFT JOIN bas_brand bb ON bb.id = gg.brand_id
				LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
			WHERE 1=1
				AND fcpu.bill_type = '1C'
				AND bac.code = '00000001'
				AND fcpug.stock_type = 2
				AND (ggba.field_4 LIKE '%${E3PLUS_QC_ART_NO}%' )
				AND (bb.id IN ('${E3PLUS_QC_BRAND_ID}') OR 1=1)
				AND ((DATE_FORMAT(fcpu.create_time,'%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}') )
	UNION ALL
		SELECT
			7 AS seq,
			'货龄' AS huoLing,
			'换/退货差异成本' AS type,
			NULL AS typeCode,
			'大类' AS daLei,
			0 AS saleQty,
			0 AS retailAmount,
			0 AS taxSaleAmount,
			0 AS exTaxSaleAmount,
			0 AS saleCostQty
)t
WHERE 1=1
GROUP BY t.type
ORDER BY seq;