SELECT
		ANY_VALUE(t.seq) AS seq,
		ANY_VALUE(t.huoLing) AS huoLing,
		ANY_VALUE(t.type) AS type,
		ANY_VALUE(t.daLei) AS daLei,
		ANY_VALUE(t.field_id) AS field_id,
		ANY_VALUE(t.field_name) AS field_name,
		ANY_VALUE(t.field_code) AS field_code,
		ANY_VALUE(t.field_4) AS field_4,
		SUM(t.saleQty),
		SUM(t.retailAmount),
		SUM(t.taxSaleAmount),
		SUM(t.exTaxSaleAmount),
		SUM(t.saleCostQty),
		(SUM(t.exTaxSaleAmount)-SUM(t.saleCostQty)) AS grossProfit,
		((SUM(t.exTaxSaleAmount)-SUM(t.saleCostQty))/SUM(t.exTaxSaleAmount)) AS grossProfitRate
FROM (
   SELECT
		  1 AS seq,
      '货龄' AS huoLing,
			'经销' AS type,
			'大类' AS daLei,
			ANY_VALUE(bc.id) AS field_id,
			ANY_VALUE(bc.name) AS field_name,
			ANY_VALUE(bc.code) AS field_code,
			ANY_VALUE(ggba.field_4) AS field_4,
			SUM(sslw.change_qty) AS saleQty,
			SUM(sslw.change_qty)*ANY_VALUE(mpc2.price) AS retailAmount,
			SUM(sslw.amount) AS taxSaleAmount,
			SUM(sslw.extax_amount) AS exTaxSaleAmount,
			SUM(sslw.unit_cost*sslw.change_qty) AS saleCostQty
		FROM stk_stock_logic_workflow sslw
		 LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
		 LEFT JOIN bas_brand bb ON gg.brAND_id = bb.id
		 LEFT JOIN bas_customer bc ON bc.id = sslw.business_party_id
		 LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
		 LEFT JOIN (
				SELECT mpc1.* FROM (
						SELECT ANY_VALUE(price) AS price,ANY_VALUE(id) AS id,ANY_VALUE(goods_id) AS goods_id,
						ANY_VALUE(create_time) AS create_time FROM mkt_price_control
							WHERE 1=1 AND price_id = 1 ORDER BY create_time DESC LIMIT 9999999
			 ) mpc1 GROUP BY mpc1.goods_id
		 )mpc2 ON mpc2.goods_id = sslw.goods_id
		WHERE 1='${seq}'
				AND (sslw.bill_name in (71,77))
				AND (sslw.qty_type = 1)
				AND bc.id = '${field_id}'
				AND (IF('${E3PLUS_QC_ART_NO}' IS NULL OR '${E3PLUS_QC_ART_NO}'='' OR '${E3PLUS_QC_ART_NO}'='%@%',1=1,ggba.field_4 = '${E3PLUS_QC_ART_NO}'))
				AND (bb.id IN ('${E3PLUS_QC_BRAND_ID}'))
				AND ((DATE_FORMAT(sslw.create_time,'%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}'))
		GROUP BY ggba.field_4
UNION ALL
	SELECT
		tab.seq AS seq,
		tab.huoLing AS huoLing,
		tab.type AS type,
		tab.daLei AS daLei,
		ANY_VALUE(tab.field_id) AS field_id,
		ANY_VALUE(tab.field_name) AS field_name ,
		ANY_VALUE(tab.field_code) AS field_code,
		ANY_VALUE(tab.field_4) AS field_4,
		ANY_VALUE(tab.saleQty) AS saleQty,
		ANY_VALUE(tab.retailAmount) AS retailAmount,
		ANY_VALUE(tab.taxSaleAmount) AS taxSaleAmount,
		ANY_VALUE(tab.exTaxSaleAmount) AS exTaxSaleAmount,
		ANY_VALUE(tab.saleCostQty) AS saleCostQty
	FROM  (
				SELECT
				  2 AS seq,
					'货龄' AS huoLing,
					'退货冲红' AS type,
					'大类' AS daLei,
					ANY_VALUE(tt.field_id) AS field_id,
					ANY_VALUE(tt.field_name) AS field_name ,
					ANY_VALUE(tt.field_code) AS field_code,
					ANY_VALUE(tt.field_4) AS field_4,
					SUM(tt.saleQty) AS saleQty,
					SUM(tt.saleQty*tt.price) AS retailAmount,
					ANY_VALUE(tt.amount) AS taxSaleAmount,
					ANY_VALUE(tt.extaxAmount) AS exTaxSaleAmount,
					SUM(tt.saleQty*fcpic.item_cost) AS saleCostQty
				FROM (
						SELECT
							ANY_VALUE(tsrbl.id) AS tsrblId,
							ANY_VALUE(tsrb.base_company_id) AS baseCompanyId,
							ANY_VALUE(tsrb.complete_time) AS completeTime,
							ANY_VALUE(tsrbl.sku_id) AS skuId,
							ANY_VALUE(tsrbl.amount) AS amount,
							ANY_VALUE(tsrbl.extax_amount) AS extaxAmount,
							ANY_VALUE(tsrbl.sale_qty) AS saleQty,
							ANY_VALUE(mpc2.price) AS price,
							ANY_VALUE(bc.id) AS field_id,
							ANY_VALUE(bc.name) AS field_name,
							ANY_VALUE(bc.code) AS field_code,
							ANY_VALUE(ggba.field_4) AS field_4
						FROM trade_sale_return_bill_line tsrbl
							LEFT JOIN trade_sale_return_bill tsrb ON tsrbl.bill_id = tsrb.id
							LEFT JOIN gds_goods gg ON gg.id = tsrbl.goods_id
							LEFT JOIN bas_brand bb ON gg.brAND_id = bb.id
							LEFT JOIN bas_customer bc ON bc.id = tsrb.customer_id
							LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
							LEFT JOIN (
								SELECT mpc1.* FROM (
										SELECT ANY_VALUE(price) AS price,ANY_VALUE(id) AS id,ANY_VALUE(goods_id) AS goods_id,
										ANY_VALUE(create_time) AS create_time FROM mkt_price_control
											WHERE 1=1 AND price_id = 1 ORDER BY create_time DESC LIMIT 9999999
							 ) mpc1 GROUP BY mpc1.goods_id
						 )mpc2 ON mpc2.goods_id = tsrbl.goods_id
						WHERE 2='${seq}'
							AND tsrb.bill_status = 5
							AND tsrb.sale_method = 'S'
							AND bc.id = '${field_id}'
							AND (IF('${E3PLUS_QC_ART_NO}' IS NULL OR '${E3PLUS_QC_ART_NO}'='' OR '${E3PLUS_QC_ART_NO}'='%@%',1=1,ggba.field_4 = '${E3PLUS_QC_ART_NO}'))
							AND (bb.id IN ('${E3PLUS_QC_BRAND_ID}'))
							AND ((DATE_FORMAT(tsrb.create_time,'%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}'))
					) tt LEFT JOIN fin_cst_pac_item_costs fcpic ON (fcpic.sku_id = tt.skuId AND fcpic.base_company_id = tt.baseCompanyId
							AND fcpic.period_start_date <= tt.completeTime AND fcpic.period_end_date >= tt.completeTime)
					WHERE 2='${seq}'
					GROUP BY tt.tsrblId
		) tab GROUP BY tab.field_id
	UNION ALL
		SELECT
					3 AS seq,
					'货龄' AS huoLing,
					ANY_VALUE(CONCAT('代销-',bso.name)) AS type,
					'大类' AS daLei,
					ANY_VALUE(bs.id) AS field_id,
					ANY_VALUE(bs.name) AS field_name,
					ANY_VALUE(bs.code) AS field_code,
					ANY_VALUE(ggba.field_4) AS field_4,
					SUM(sslw.change_qty) AS saleQty,
					SUM(sslw.change_qty*mpc2.price) AS retailAmount,
					SUM(sslw.amount) AS taxSaleAmount,
					SUM(sslw.extax_amount) AS exTaxSaleAmount,
					SUM(sslw.change_qty*sslw.unit_cost) AS saleCostQty
		FROM stk_stock_logic_workflow sslw
			LEFT JOIN bas_logic_warehouse blw  ON blw.id = sslw.logic_warehouse_id
			LEFT JOIN bas_stock_organizatiON bso ON bso.id = blw.stock_organization_id
			LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
			LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
			LEFT JOIN bas_brand bb ON bb.id = gg.brAND_id
			LEFT JOIN bas_shop_use_warehouse bsuw ON bsuw.logic_warehouse_id = sslw.logic_warehouse_id
			LEFT JOIN bas_shop bs ON bs.id = bsuw.shop_id
			LEFT JOIN (
								SELECT mpc1.* FROM (
										SELECT ANY_VALUE(price) AS price,ANY_VALUE(id) AS id,ANY_VALUE(goods_id) AS goods_id,
										ANY_VALUE(create_time) AS create_time FROM mkt_price_control
											WHERE 1=1 AND price_id = 1 ORDER BY create_time DESC LIMIT 9999999
							 ) mpc1 GROUP BY mpc1.goods_id
						 )mpc2 ON mpc2.goods_id = sslw.goods_id
		WHERE 3='${seq}'
				AND sslw.bill_name IN (89,99)
				AND sslw.qty_type = 1
				AND sslw.sale_confirm = 'Y'
				AND bs.id = '${field_id}'
				AND bso.code = '${typeCode}'
				AND (IF('${E3PLUS_QC_ART_NO}' IS NULL OR '${E3PLUS_QC_ART_NO}'='' OR '${E3PLUS_QC_ART_NO}'='%@%',1=1,ggba.field_4 = '${E3PLUS_QC_ART_NO}'))
				AND (bb.id IN ('${E3PLUS_QC_BRAND_ID}'))
				AND ((DATE_FORMAT(sslw.create_time,'%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}'))
		GROUP BY ggba.field_4
	UNION ALL
			SELECT
					4 AS seq,
					'货龄' AS huoLing,
					ANY_VALUE(CONCAT('代销-',bso.name)) AS type,
					'大类' AS daLei,
					ANY_VALUE(bs.id) AS field_id,
					ANY_VALUE(bs.name) AS field_name,
					ANY_VALUE(bs.code) AS field_code,
					ANY_VALUE(ggba.field_4) AS field_4,
					SUM(sslw.change_qty) AS saleQty,
					SUM(sslw.change_qty*mpc2.price) AS retailAmount,
					SUM(sslw.amount) AS taxSaleAmount,
					SUM(sslw.extax_amount) AS exTaxSaleAmount,
					SUM(sslw.change_qty*sslw.unit_cost) AS saleCostQty
			FROM stk_stock_logic_workflow sslw
				LEFT JOIN bas_logic_warehouse blw  ON blw.id = sslw.logic_warehouse_id
				LEFT JOIN bas_stock_organizatiON bso ON bso.id = blw.stock_organization_id
				LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
				LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
				LEFT JOIN bas_brand bb ON bb.id = gg.brAND_id
				LEFT JOIN bas_shop_use_warehouse bsuw ON bsuw.logic_warehouse_id = sslw.logic_warehouse_id
				LEFT JOIN bas_shop bs ON bs.id = bsuw.shop_id
				LEFT JOIN (
									SELECT mpc1.* FROM (
										SELECT ANY_VALUE(price) AS price,ANY_VALUE(id) AS id,ANY_VALUE(goods_id) AS goods_id,
										ANY_VALUE(create_time) AS create_time FROM mkt_price_control
											WHERE 1=1 AND price_id = 1 ORDER BY create_time DESC LIMIT 9999999
								 ) mpc1 GROUP BY mpc1.goods_id
							 )mpc2 ON mpc2.goods_id = sslw.goods_id
			WHERE 4='${seq}'
					AND sslw.bill_name IN (89,99)
					AND sslw.qty_type = 1
					AND sslw.sale_confirm = 'Y'
					AND bs.id = '${field_id}'
					AND bso.code = '${typeCode}'
					AND (IF('${E3PLUS_QC_ART_NO}' IS NULL OR '${E3PLUS_QC_ART_NO}'='' OR '${E3PLUS_QC_ART_NO}'='%@%',1=1,ggba.field_4 = '${E3PLUS_QC_ART_NO}'))
					AND (bb.id IN ('${E3PLUS_QC_BRAND_ID}'))
					AND ((DATE_FORMAT(sslw.create_time,'%Y-%m') BETWEEN '${E3PLUS_QC_CREATE_TIME_START}' AND '${E3PLUS_QC_CREATE_TIME_END}'))
			GROUP BY ggba.field_4
)t WHERE 1=1 GROUP BY t.field_id;