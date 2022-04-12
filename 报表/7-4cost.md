${E3PLUS_RSQL}

7-4cost(5) : 

599969328820965436

2021-04

2021-08



![image-20220322165610400](C:\Users\77498\AppData\Roaming\Typora\typora-user-images\image-20220322165610400.png)

在e3原始语句中写死了

```
SELECT
-- 货号
	a2.field_4 AS 'huoHao',
-- 	期初数量
	(
	SELECT sum( b1.end_qty ) FROM fin_stock_period_summary b1 
	WHERE
		b1.base_company_id = a1.base_company_id 
		AND b1.goods_id = a2.goods_id 
		AND b1.start_date 
		LIKE (SELECT concat('%',EXTRACT(YEAR FROM concat( '2021-12', '-01' )),'-',
			IF ( EXTRACT( MONTH FROM concat( '2021-12', '-01' ))< 11, '0', '' ),
				EXTRACT(MONTH FROM concat( '2021-12', '-01' ))- 1,'-',
			IF ( EXTRACT( DAY FROM concat( '2021-12', '-01' ))< 11, '0', '' ),
				EXTRACT(DAY FROM concat( '2021-12', '-01' )),'%' ) 
		)
		) AS 'startQty',
		
-- 		期初金额
	(
	SELECT sum( b1.end_qty * a1.item_cost ) 
	FROM fin_stock_period_summary b1 
	WHERE
-- 	核算公司=查询账套
		b1.base_company_id = a1.base_company_id 
		AND b1.goods_id = a2.goods_id 
		AND b1.start_date 
		LIKE (SELECT concat('%',EXTRACT(YEAR FROM concat( '2021-12', '-01' )),'-',
			IF ( EXTRACT( MONTH FROM concat( '2021-12', '-01' ))< 11, '0', '' ),
				EXTRACT(MONTH FROM concat( '2021-12', '-01' ))- 1,'-',
			IF ( EXTRACT( DAY FROM concat( '2021-12', '-01' ))< 11, '0', '' ),
				EXTRACT(DAY FROM concat( '2021-12', '-01' )),'%' ) 
		)
	) AS 'startAmount',
		
-- 		期初单价 = 期初金额/期初数量
	((
		SELECT sum( b1.end_qty * a1.item_cost ) 
		FROM
			fin_stock_period_summary b1 
		WHERE
			b1.base_company_id = a1.base_company_id 
			AND b1.goods_id = a2.goods_id 
			AND b1.start_date 
		LIKE (SELECT concat('%',EXTRACT(YEAR FROM concat( '2021-12', '-01' )),'-',
			IF ( EXTRACT( MONTH FROM concat( '2021-12', '-01' ))< 11, '0', '' ),
				EXTRACT(MONTH FROM concat( '2021-12', '-01' ))- 1,'-',
			IF ( EXTRACT( DAY FROM concat( '2021-12', '-01' ))< 11, '0', '' ),
				EXTRACT(DAY FROM concat( '2021-12', '-01' )),'%' ) 
				)
			) / (
		SELECT sum( b1.end_qty ) 
		FROM
			fin_stock_period_summary b1 
		WHERE
			b1.base_company_id = a1.base_company_id 
			AND b1.goods_id = a2.goods_id 
			AND b1.start_date 
		LIKE (SELECT concat('%',EXTRACT(YEAR FROM concat( '2021-12', '-01' )),'-',
			IF ( EXTRACT( MONTH FROM concat( '2021-12', '-01' ))< 11, '0', '' ),
				EXTRACT(MONTH FROM concat( '2021-12', '-01' ))- 1,'-',
			IF ( EXTRACT( DAY FROM concat( '2021-12', '-01' ))< 11, '0', '' ),
				EXTRACT(DAY FROM concat( '2021-12', '-01' )),'%' ) 
		)
			)
			) AS 'startPrice',
			
-- 			进货数量
	sum( a4.pur_qty ) AS 'jinHuoQty',
-- 	进货金额
	sum( a4.amount ) AS 'jinHuoAmount',
	
-- 	进货单价
	ifnull( sum( a4.amount )/ sum( a4.pur_qty ), 0 ) AS 'jinHuoPrice',
	
-- 	进货退回数量
	(
	SELECT
		ifnull( sum( b2.pur_qty )*(- 1 ), 0 ) 
	FROM
		trade_purchase_return_bill b1
		LEFT JOIN trade_purchase_return_bill_goods b2 ON b1.id = b2.bill_id 
	WHERE
		b1.base_company_id = a1.base_company_id 
		AND b1.bill_status = '03' 
		AND b2.goods_id = a2.goods_id 
		AND b1.pur_method = 'P' 
		AND (
			b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
		AND concat( '2022-12', '-31' )) 
	) AS 'JinHuoTuiQty',
	
-- 	进货退回金额
	(
	SELECT
		ifnull( sum( b2.amount )*(- 1 ), 0 ) 
	FROM
		trade_purchase_return_bill b1
		LEFT JOIN trade_purchase_return_bill_goods b2 ON b1.id = b2.bill_id 
	WHERE
		b1.base_company_id = a1.base_company_id 
		AND b1.bill_status = '03' 
		AND b2.goods_id = a2.goods_id 
		AND b1.pur_method = 'P' 
		AND (
			b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
		AND concat( '2022-12', '-31' )) 
	) AS 'JinHuoTuiAmount',
	
-- 	进货退回单价
	(
	SELECT
		ifnull( sum( b2.amount )/ sum( b2.pur_qty ), 0 ) 
	FROM
		trade_purchase_return_bill b1
		LEFT JOIN trade_purchase_return_bill_goods b2 ON b1.id = b2.bill_id 
	WHERE
		b1.base_company_id = a1.base_company_id 
		AND b1.bill_status = '03' 
		AND b2.goods_id = a2.goods_id 
		AND b1.pur_method = 'P' 
		AND (
			b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
		AND concat( '2022-12', '-31' )) 
	) AS 'JinHuoTuiPrice',
	
-- 	销售数量
	(
	SELECT
		ifnull( sum( b1.change_qty ), 0 ) 
	FROM
		stk_stock_logic_workflow b1
		INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
	WHERE
		b2.accounting_company_id = a1.base_company_id 
		AND b1.bill_name IN ( '76', '77' ) 
		AND b1.stock_type IN ( '1' ) 
		AND b1.qty_type IN ( '1' ) 
		AND b1.goods_id = a2.goods_id 
		AND (
			b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
		AND concat( '2022-12', '-31' )) 
	) AS 'xiaoShouQty',
	
-- 	销售金额
	((
		SELECT
			ifnull( sum( b1.amount ), 0 ) 
		FROM
			stk_stock_logic_workflow b1
			INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
		WHERE
			b2.accounting_company_id = a1.base_company_id 
			AND b1.bill_name IN ( '76', '77' ) 
			AND b1.stock_type IN ( '1' ) 
			AND b1.qty_type IN ( '1' ) 
			AND b1.goods_id = a2.goods_id 
			AND (
				b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
			AND concat( '2022-12', '-31' )) 
			) + (
		SELECT
			ifnull( sum( b2.cost_amount ), 0 ) 
		FROM
			fin_cst_pac_update b1
			LEFT JOIN fin_cst_pac_update_goods b2 ON b1.id = b2.bill_id 
		WHERE
			b1.base_company_id = a1.base_company_id 
			AND b2.goods_id = a2.goods_id 
			AND b1.bill_type IN ( '1C' ) 
			AND b1.bill_status IN ( '03' ) 
			AND (
				b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
			AND concat( '2022-12', '-31' )))) 'xiaoShouAmount',
			
-- 			销售单价
	(((
			SELECT
				ifnull( sum( b1.amount ), 0 ) 
			FROM
				stk_stock_logic_workflow b1
				INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
			WHERE
				b2.accounting_company_id = a1.base_company_id 
				AND b1.bill_name IN ( '76', '77' ) 
				AND b1.stock_type IN ( '1' ) 
				AND b1.qty_type IN ( '1' ) 
				AND b1.goods_id = a2.goods_id 
				AND (
					b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
				AND concat( '2022-12', '-31' )) 
				) + (
			SELECT
				ifnull( sum( b2.cost_amount ), 0 ) 
			FROM
				fin_cst_pac_update b1
				LEFT JOIN fin_cst_pac_update_goods b2 ON b1.id = b2.bill_id 
			WHERE
				b1.base_company_id = a1.base_company_id 
				AND b2.goods_id = a2.goods_id 
				AND b1.bill_type IN ( '1C' ) 
				AND b1.bill_status IN ( '03' ) 
				AND (
					b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
				AND concat( '2022-12', '-31' )))) / (
		SELECT
			ifnull( sum( b1.change_qty ), 0 ) 
		FROM
			stk_stock_logic_workflow b1
			INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
		WHERE
			b2.accounting_company_id = a1.base_company_id 
			AND b1.bill_name IN ( '76', '77' ) 
			AND b1.stock_type IN ( '1' ) 
			AND b1.qty_type IN ( '1' ) 
			AND b1.goods_id = a2.goods_id 
			AND (
				b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
			AND concat( '2022-12', '-31' )) 
		)) AS 'xiaoShouPrice',
		
-- 		客户退货数量
	0 AS 'keTuiHuoQty',
-- 	客户退货金额
	0 AS 'KeTuiHuoAmount',
-- 	客户退货单价
	0 AS 'KeTuiHuoPrice',
	
-- 	内部调拨调出数量
	(
	SELECT
		ifnull( sum( b1.change_qty ), 0 ) 
	FROM
		stk_stock_logic_workflow b1
		INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
	WHERE
		b2.accounting_company_id = a1.base_company_id 
		AND b1.stock_type IN ( '1' ) 
		AND b1.qty_type IN ( '1' ) 
		AND b1.bill_name IN ( '86' ) 
		AND b1.goods_id = a2.goods_id 
		AND (
			b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
		AND concat( '2022-12', '-31' )) 
	) AS 'diaoBoChuQty',
	
-- 	内部调拨调入数量
	(
	SELECT
		ifnull( sum( b1.change_qty ), 0 ) 
	FROM
		stk_stock_logic_workflow b1
		INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
	WHERE
		b2.accounting_company_id = a1.base_company_id 
		AND b1.stock_type IN ( '1' ) 
		AND b1.qty_type IN ( '1' ) 
		AND b1.bill_name IN ( '85' ) 
		AND b1.goods_id = a2.goods_id 
		AND (
			b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
		AND concat( '2022-12', '-31' ))) AS 'diaoBoRuRuQty',
		
-- 		内部调拨金额=期末结存金额-(期初金额+进货金额+进货退回金额-销售金额+客户退货金额+盈亏金额)。
	((
		SELECT
			ifnull( sum( b1.item_value ), 0 ) 
		FROM
			fin_cst_pac_item_costs b1 
		WHERE
			b1.goods_id = a1.goods_id 
			AND (
			b1.base_company_id IN ( 10001 )) 
			AND b1.period_end_date 
		LIKE (
		SELECT concat('%',EXTRACT(YEAR FROM concat( '2022-12', '-31' )),'-',
			IF( EXTRACT( MONTH FROM concat( '2022-12', '-31' ))< 11, '0', '' ),
				EXTRACT(MONTH FROM concat( '2022-12', '-31' ))- 1,'-',
			IF( EXTRACT( DAY FROM concat( '2022-12', '-31' ))< 11, '0', '' ),
				EXTRACT(DAY FROM concat( '2022-12', '-31' )),'%' ) 
		)
				) -((
			SELECT
				sum( b1.end_qty * a1.item_cost ) 
			FROM
				fin_stock_period_summary b1 
			WHERE
				b1.base_company_id = a1.base_company_id 
				AND b1.goods_id = a2.goods_id 
				AND b1.start_date 
			LIKE (SELECT concat('%',EXTRACT(YEAR FROM concat( '2021-12', '-01' )),'-',
			IF ( EXTRACT( MONTH FROM concat( '2021-12', '-01' ))< 11, '0', '' ),
				EXTRACT(MONTH FROM concat( '2021-12', '-01' ))- 1,'-',
			IF ( EXTRACT( DAY FROM concat( '2021-12', '-01' ))< 11, '0', '' ),
				EXTRACT(DAY FROM concat( '2021-12', '-01' )),'%' ) 
		)
				) +(
			SELECT
				ifnull( sum( b2.amount )*(- 1 ), 0 ) 
			FROM
				trade_purchase_return_bill b1
				LEFT JOIN trade_purchase_return_bill_goods b2 ON b1.id = b2.bill_id 
			WHERE
				b1.base_company_id = a1.base_company_id 
				AND b1.bill_status = '03' 
				AND b2.goods_id = a2.goods_id 
				AND b1.pur_method = 'P' 
				AND (
-- 				trade_purchase_return_bill b1 
--        stock.date 库存日期
					b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
				AND concat( '2022-12', '-31' ))) +(
			SELECT
				ifnull( sum( b2.amount )*(- 1 ), 0 ) 
			FROM
				trade_purchase_return_bill b1
				LEFT JOIN trade_purchase_return_bill_goods b2 ON b1.id = b2.bill_id 
			WHERE
				b1.base_company_id = a1.base_company_id 
				AND b1.bill_status = '03' 
				AND b2.goods_id = a2.goods_id 
				AND b1.pur_method = 'P' 
				AND (
					b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
					AND concat( '2022-12', '-31' ))) -((
				SELECT
					ifnull( sum( b1.amount ), 0 ) 
				FROM
					stk_stock_logic_workflow b1
					INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
				WHERE
					b2.accounting_company_id = a1.base_company_id 
					AND b1.bill_name IN ( '76', '77' ) 
					AND b1.stock_type IN ( '1' ) 
					AND b1.qty_type IN ( '1' ) 
					AND b1.goods_id = a2.goods_id 
					AND (
						b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
					AND concat( '2022-12', '-31' )) 
					) + (
				SELECT
					ifnull( sum( b2.cost_amount ), 0 ) 
				FROM
					fin_cst_pac_update b1
					LEFT JOIN fin_cst_pac_update_goods b2 ON b1.id = b2.bill_id 
				WHERE
					b1.base_company_id = a1.base_company_id 
					AND b2.goods_id = a2.goods_id 
					AND b1.bill_type IN ( '1C' ) 
					AND b1.bill_status IN ( '03' ) 
					AND (
						b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
					AND concat( '2022-12', '-31' )))) + 0 +(
			SELECT
				ifnull( sum( b1.amount ), 0 ) 
			FROM
				stk_stock_logic_workflow b1
				INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
			WHERE
				b2.accounting_company_id = a1.base_company_id 
				AND b1.stock_type IN ( '1' ) 
				AND b1.qty_type IN ( '1' ) 
				AND b1.bill_name IN ( '1D' ) 
				AND b1.bill_type IN ( '91' ) 
				AND b1.goods_id = a2.goods_id 
				AND (
					b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
				AND concat( '2022-12', '-31' )) 
			))) AS 'diaoBoAmount',
			
-- 			盈亏数量
	(
	SELECT
		ifnull( sum( b1.change_qty ), 0 ) 
	FROM
		stk_stock_logic_workflow b1
		INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
	WHERE
		b2.accounting_company_id = a1.base_company_id 
		AND b1.stock_type IN ( '1' ) 
		AND b1.qty_type IN ( '1' ) 
		AND b1.bill_name IN ( '1D' ) 
		AND b1.bill_type IN ( '91' ) 
		AND b1.goods_id = a2.goods_id 
		AND (
			b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
		AND concat( '2022-12', '-31' )) 
	) AS 'yingKuiQty',
	
-- 	盈亏金额
	(
	SELECT
		ifnull( sum( b1.amount ), 0 ) 
	FROM
		stk_stock_logic_workflow b1
		INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
	WHERE
		b2.accounting_company_id = a1.base_company_id 
		AND b1.stock_type IN ( '1' ) 
		AND b1.qty_type IN ( '1' ) 
		AND b1.bill_name IN ( '1D' ) 
		AND b1.bill_type IN ( '91' ) 
		AND b1.goods_id = a2.goods_id 
		AND (
			b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
		AND concat( '2022-12', '-31' )) 
	) AS 'yingKuiAmount',
	
-- 	盈亏单价
	((
		SELECT
			ifnull( sum( b1.amount ), 0 ) 
		FROM
			stk_stock_logic_workflow b1
			INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
		WHERE
			b2.accounting_company_id = a1.base_company_id 
			AND b1.stock_type IN ( '1' ) 
			AND b1.qty_type IN ( '1' ) 
			AND b1.bill_name IN ( '1D' ) 
			AND b1.bill_type IN ( '91' ) 
			AND b1.goods_id = a2.goods_id 
			AND (
				b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
			AND concat( '2022-12', '-31' )) 
			) / (
		SELECT
			ifnull( sum( b1.change_qty ), 0 ) 
		FROM
			stk_stock_logic_workflow b1
			INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
		WHERE
			b2.accounting_company_id = a1.base_company_id 
			AND b1.stock_type IN ( '1' ) 
			AND b1.qty_type IN ( '1' ) 
			AND b1.bill_name IN ( '1D' ) 
			AND b1.bill_type IN ( '91' ) 
			AND b1.goods_id = a2.goods_id 
			AND (
				b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
			AND concat( '2022-12', '-31' )) 
		)) AS 'yinKuiPrice',
		
-- 		期末结存数量
	((
		SELECT
			sum( b1.end_qty ) 
		FROM
			fin_stock_period_summary b1 
		WHERE
			b1.base_company_id = a1.base_company_id 
			AND b1.goods_id = a2.goods_id 
			AND b1.start_date 
		LIKE (SELECT concat('%',EXTRACT(YEAR FROM concat( '2021-12', '-01' )),'-',
			IF ( EXTRACT( MONTH FROM concat( '2021-12', '-01' ))< 11, '0', '' ),
				EXTRACT(MONTH FROM concat( '2021-12', '-01' ))- 1,'-',
			IF ( EXTRACT( DAY FROM concat( '2021-12', '-01' ))< 11, '0', '' ),
				EXTRACT(DAY FROM concat( '2021-12', '-01' )),'%' ) 
		)
			) + sum( a4.pur_qty ) +(
		SELECT
			ifnull( sum( b2.pur_qty )*(- 1 ), 0 ) 
		FROM
			trade_purchase_return_bill b1
			LEFT JOIN trade_purchase_return_bill_goods b2 ON b1.id = b2.bill_id 
		WHERE
			b1.base_company_id = a1.base_company_id 
			AND b1.bill_status = '03' 
			AND b2.goods_id = a2.goods_id 
			AND b1.pur_method = 'P' 
			AND (
				b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
			AND concat( '2022-12', '-31' ))) -(
		SELECT
			ifnull( sum( b1.change_qty ), 0 ) 
		FROM
			stk_stock_logic_workflow b1
			INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
		WHERE
			b2.accounting_company_id = a1.base_company_id 
			AND b1.bill_name IN ( '76', '77' ) 
			AND b1.stock_type IN ( '1' ) 
			AND b1.qty_type IN ( '1' ) 
			AND b1.goods_id = a2.goods_id 
			AND (
				b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
			AND concat( '2022-12', '-31' ))) -(
		SELECT
			ifnull( sum( b2.sale_qty ), 0 ) 
		FROM
			trade_sale_bill b1
			LEFT JOIN trade_sale_bill_line b2 ON b1.id = b2.bill_id 
		WHERE
			b1.base_company_id = a1.base_company_id 
			AND b1.bill_status IN ( '05' ) 
			AND b1.sale_method IN ( 'C' ) 
			AND (
				b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
			AND concat( '2022-12', '-31' ))) +(
		SELECT
			ifnull( sum( b1.change_qty ), 0 ) 
		FROM
			stk_stock_logic_workflow b1
			INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
		WHERE
			b2.accounting_company_id = a1.base_company_id 
			AND b1.stock_type IN ( '1' ) 
			AND b1.qty_type IN ( '1' ) 
			AND b1.bill_name IN ( '1D' ) 
			AND b1.bill_type IN ( '91' ) 
			AND b1.goods_id = a2.goods_id 
			AND (
				b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
			AND concat( '2022-12', '-31' ))) -(
		SELECT
			ifnull( sum( b1.change_qty ), 0 ) 
		FROM
			stk_stock_logic_workflow b1
			INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
		WHERE
			b2.accounting_company_id = a1.base_company_id 
			AND b1.stock_type IN ( '1' ) 
			AND b1.qty_type IN ( '1' ) 
			AND b1.bill_name IN ( '86' ) 
			AND b1.goods_id = a2.goods_id 
			AND (
				b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
			AND concat( '2022-12', '-31' ))) +(
		SELECT
			ifnull( sum( b1.change_qty ), 0 ) 
		FROM
			stk_stock_logic_workflow b1
			INNER JOIN bas_stock_organization b2 ON b1.stock_organization_id = b2.id 
		WHERE
			b2.accounting_company_id = a1.base_company_id 
			AND b1.stock_type IN ( '1' ) 
			AND b1.qty_type IN ( '1' ) 
			AND b1.bill_name IN ( '85' ) 
			AND b1.goods_id = a2.goods_id 
			AND (
				b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
			AND concat( '2022-12', '-31' )) 
		)) AS 'endQty',
-- 					AND b1.stock_date BETWEEN concat( '2021-08', '-01' ) 
-- 		AND concat( '2021-09', '-31' ))) AS 'endQty',
-- 换货数量
	(
	SELECT
		ifnull( sum( b2.sale_qty ), 0 ) 
	FROM
		trade_sale_bill b1
		LEFT JOIN trade_sale_bill_line b2 ON b1.id = b2.bill_id 
	WHERE
		b1.base_company_id = a1.base_company_id 
		AND b1.bill_status IN ( '05' ) 
		AND b1.sale_method IN ( 'C' ) 
		AND (
			b1.stock_date BETWEEN concat( '2021-12', '-01' ) 
		AND concat( '2022-12', '-31' ))) 'changeQty',
-- 		期末结存金额
	(
	SELECT
		ifnull( sum( b1.item_value ), 0 ) 
	FROM
		fin_cst_pac_item_costs b1 
	WHERE
		b1.goods_id = a1.goods_id 
 		AND b1.base_company_id = 10001 
		AND b1.period_end_date 
		LIKE (
		SELECT concat('%',EXTRACT(YEAR FROM concat( '2022-12', '-31' )),'-',
			IF( EXTRACT( MONTH FROM concat( '2022-12', '-31' ))< 11, '0', '' ),
				EXTRACT(MONTH FROM concat( '2022-12', '-31' ))- 1,'-',
			IF( EXTRACT( DAY FROM concat( '2022-12', '-31' ))< 11, '0', '' ),
				EXTRACT(DAY FROM concat( '2022-12', '-31' )),'%' ) 
		)
		) AS 'endAmount' 	
FROM
	fin_cst_pac_item_costs a1
	LEFT JOIN gds_goods_base_attribute a2 ON a1.goods_id = a2.goods_id
	LEFT JOIN trade_purchase_bill a3 ON a1.base_company_id = a3.base_company_id
	LEFT JOIN trade_purchase_bill_goods a4 ON a4.bill_id = a3.id 
WHERE
	a3.bill_status = '03' 
	AND a1.goods_id = a4.goods_id 
	AND (a1.base_company_id IN ( 10001 )) 
	AND a1.period_start_date 
	BETWEEN concat( '2021-12', '-01' ) 
		AND concat( '2022-12', '-31' )
GROUP BY
	a2.field_4
```













SELECT
		tt.seasonId AS seasonId,	
		tt.seasonCode AS seasonCode,
		tt.seasonName AS seasonName,
		'大类' AS daLei,
		SUM(tt.beginQty) AS beginQty,
		SUM(tt.beginAmount) AS beginAmount,
		SUM(tt.puQty) AS puQty,
		SUM(tt.puAmount + tt.costAmount) AS puAmount,
		SUM(tt.saleQty) AS saleQty,
		SUM(tt.saleAmount1+tt.saleAmount2) AS saleAmount,
		SUM(tt.profitLossQty) AS profitLossQty,
		SUM(tt.profitLossAmount) AS profitLossAmount,
		SUM(tt.returnQty) AS returnQty,
		SUM(tt.returnAmount) AS returnAmount,
		SUM(tt.exchangeQty) AS exchangeQty,
		SUM(tt.exchangeAmount) AS exchangeAmount, 
		SUM(tt.transferQty) AS transferQty,
		SUM(tt.transferAmount) AS transferAmount,
		SUM(tt.proxySaleReturnQty) AS proxySaleReturnQty,
		SUM(tt.proxySaleReturnAmount) AS proxySaleReturnAmount,
		SUM(tt.beginQty+tt.endQty) AS endQty,
		SUM(tt.endAmount) AS endAmount
FROM (
		SELECT
				SUM(sslw.change_qty) AS beginQty,
				SUM(sslw.change_qty*sslw.unit_cost) AS beginAmount,
				0 AS puQty,
				0 AS puAmount,
				0 AS costAmount,
				0 AS saleQty,
				0 AS saleAmount1,
				0 AS saleAmount2,
				0 AS profitLossQty,
				0 AS profitLossAmount,
				0 AS returnQty,
				0 AS returnAmount,
				0 AS exchangeQty,
				0 AS exchangeAmount,
				0 AS transferQty,
				0 AS transferAmount,
				0 AS proxySaleReturnQty,
				0 AS proxySaleReturnAmount,
				0 AS endQty,
				0 AS endAmount,
				ga.id AS seasonId,	
				ga.code AS seasonCode,
				ga.name AS seasonName
			FROM stk_stock_logic_workflow sslw
				LEFT JOIN bas_legal_person blp ON sslw.owner_id = blp.id
				LEFT JOIN bas_legal_person_company blpc ON blp.code = blpc.legal_person_code
				LEFT JOIN bas_accounting_company bac ON bac.legal_person_company_id = blpc.id
				LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
				LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
				LEFT JOIN gds_attrvalue ga ON ga.id = ggba.field_4
			WHERE 1=1
				AND sslw.stock_type = 1
				AND qty_type = 1
				AND bac.code = '00000001'
				AND (ggba.field_10 LIKE '${E3PLUS_QC_ART_NO}')
				AND (ggba.field_22 IN ('${E3PLUS_QC_GOODS_TYPE}'))
				AND ((DATE_FORMAT(sslw.stock_date,'%Y-%m-%d')) <= '${E3PLUS_QC_STOCK_DATE_START}')
			GROUP BY ga.id
		UNION ALL	
			SELECT
				0 AS beginQty,
				0 AS beginAmount,
				SUM(sslw.change_qty) AS puQty,
				SUM(sslw.change_qty*sslw.unit_cost) AS puAmount,
				0 AS costAmount,
				0 AS saleQty,
				0 AS saleAmount1,
				0 AS saleAmount2,
				0 AS profitLossQty,
				0 AS profitLossAmount,
				0 AS returnQty,
				0 AS returnAmount,
				0 AS exchangeQty,
				0 AS exchangeAmount,
				0 AS transferQty,
				0 AS transferAmount,
				0 AS proxySaleReturnQty,
				0 AS proxySaleReturnAmount,
				0 AS endQty,
				0 AS endAmount,
				ga.id AS seasonId,	
				ga.code AS seasonCode,
				ga.name AS seasonName
			FROM stk_stock_logic_workflow sslw
				LEFT JOIN bas_legal_person blp ON sslw.owner_id = blp.id
				LEFT JOIN bas_legal_person_company blpc ON blp.code = blpc.legal_person_code
				LEFT JOIN bas_accounting_company bac ON bac.legal_person_company_id = blpc.id
				LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
				LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
				LEFT JOIN gds_attrvalue ga ON ga.id = ggba.field_4
			WHERE 1=1
				AND sslw.stock_type = 1
				AND qty_type = 1
				AND bill_name IN (67,68)
				AND bac.code = '00000001'
				AND (ggba.field_10 LIKE '${E3PLUS_QC_ART_NO}')
				AND (ggba.field_22 IN ('${E3PLUS_QC_GOODS_TYPE}'))
				AND (DATE_FORMAT(sslw.stock_date,'%Y-%m-%d') BETWEEN '${E3PLUS_QC_STOCK_DATE_START}' AND '${E3PLUS_QC_STOCK_DATE_END}')
			GROUP BY ga.id
	UNION ALL			
		SELECT
				0 AS beginQty,
				0 AS beginAmount,
				0 AS puQty,
				0 AS puAmount,
				0 AS costAmount,
				SUM(sslw.change_qty) AS saleQty,
				SUM(sslw.change_qty*sslw.unit_cost) AS saleAmount1,
				0 AS saleAmount2,
				0 AS profitLossQty,
				0 AS profitLossAmount,
				0 AS returnQty,
				0 AS returnAmount,
				0 AS exchangeQty,
				0 AS exchangeAmount,
				0 AS transferQty,
				0 AS transferAmount,
				0 AS proxySaleReturnQty,
				0 AS proxySaleReturnAmount,
				0 AS endQty,
				0 AS endAmount,
				ga.id AS seasonId,	
				ga.code AS seasonCode,
				ga.name AS seasonName
			FROM stk_stock_logic_workflow sslw
				LEFT JOIN bas_legal_person blp ON sslw.owner_id = blp.id
				LEFT JOIN bas_legal_person_company blpc ON blp.code = blpc.legal_person_code
				LEFT JOIN bas_accounting_company bac ON bac.legal_person_company_id = blpc.id
				LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
				LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
				LEFT JOIN gds_attrvalue ga ON ga.id = ggba.field_4
			WHERE 1=1
				AND sslw.stock_type = 1
				AND qty_type = 1
				AND bill_name IN (71,77)
				AND bac.code = '00000001'
				AND (ggba.field_10 LIKE '${E3PLUS_QC_ART_NO}')
				AND (ggba.field_22 IN ('${E3PLUS_QC_GOODS_TYPE}'))
				AND (DATE_FORMAT(sslw.stock_date,'%Y-%m-%d') BETWEEN '${E3PLUS_QC_STOCK_DATE_START}' AND '${E3PLUS_QC_STOCK_DATE_END}')
			GROUP BY ga.id	
		UNION ALL		
				SELECT
					0 AS beginQty,
					0 AS beginAmount,
					0 AS puQty,
					0 AS puAmount,
					0 AS costAmount,
					0 AS saleQty,
					0 AS saleAmount1,
					SUM(fcpug.cost_amount) AS saleAmount2,
					0 AS profitLossQty,
					0 AS profitLossAmount,
					0 AS returnQty,
					0 AS returnAmount,
					0 AS exchangeQty,
					0 AS exchangeAmount,
					0 AS transferQty,
					0 AS transferAmount,
					0 AS proxySaleReturnQty,
					0 AS proxySaleReturnAmount,
					0 AS endQty,
					0 AS endAmount,
					ga.id AS seasonId,	
					ga.code AS seasonCode,
					ga.name AS seasonName
				FROM fin_cst_pac_update_goods fcpug
					LEFT JOIN fin_cst_pac_update fcpu ON fcpug.bill_id = fcpu.id
					LEFT JOIN bas_accounting_company bac ON bac.id = fcpu.base_company_id
					LEFT JOIN gds_goods gg ON gg.id = fcpug.goods_id
					LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
					LEFT JOIN gds_attrvalue ga ON ga.id = ggba.field_4
				WHERE 1=1
					AND fcpu.bill_type = '1C'
					AND bac.code = '00000001'
					AND fcpu.stock_type = 1
					AND (ggba.field_10 LIKE '${E3PLUS_QC_ART_NO}')
					AND (ggba.field_22 IN ('${E3PLUS_QC_GOODS_TYPE}'))
					AND (DATE_FORMAT(fcpu.stock_date,'%Y-%m-%d') BETWEEN '${E3PLUS_QC_STOCK_DATE_START}' AND '${E3PLUS_QC_STOCK_DATE_END}')
				GROUP BY ga.id	
		UNION ALL
				SELECT
					0 AS beginQty,
					0 AS beginAmount,
					0 AS puQty,
					0 AS puAmount,
					0 AS costAmount,
					0 AS saleQty,
					0 AS saleAmount1,
					0 AS saleAmount2,
					SUM(sslw.change_qty) AS profitLossQty,
					SUM(sslw.change_qty*sslw.unit_cost) AS profitLossAmount,
					0 AS returnQty,
					0 AS returnAmount,
					0 AS exchangeQty,
					0 AS exchangeAmount,
					0 AS transferQty,
					0 AS transferAmount,
					0 AS proxySaleReturnQty,
					0 AS proxySaleReturnAmount,
					0 AS endQty,
					0 AS endAmount,
					ga.id AS seasonId,	
					ga.code AS seasonCode,
					ga.name AS seasonName
				FROM stk_stock_logic_workflow sslw
					LEFT JOIN bas_legal_person blp ON sslw.owner_id = blp.id
					LEFT JOIN bas_legal_person_company blpc ON blp.code = blpc.legal_person_code
					LEFT JOIN bas_accounting_company bac ON bac.legal_person_company_id = blpc.id
					LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
					LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
					LEFT JOIN gds_attrvalue ga ON ga.id = ggba.field_4
				WHERE 1=1
					AND sslw.stock_type = 1
					AND sslw.bill_type = '91'
					AND sslw.bill_name IN ('1D')
					AND bac.code = '00000001'
					AND (ggba.field_10 LIKE '${E3PLUS_QC_ART_NO}')
					AND (ggba.field_22 IN ('${E3PLUS_QC_GOODS_TYPE}'))
					AND (DATE_FORMAT(sslw.stock_date,'%Y-%m-%d') BETWEEN '${E3PLUS_QC_STOCK_DATE_START}' AND '${E3PLUS_QC_STOCK_DATE_END}')
				GROUP BY ga.id
		UNION ALL
			SELECT
				0 AS beginQty,
				0 AS beginAmount,
				0 AS puQty,
				0 AS puAmount,
				0 AS costAmount,
				0 AS saleQty,
				0 AS saleAmount1,
				0 AS saleAmount2,
				0 AS profitLossQty,
				0 AS profitLossAmount,
				SUM(sslw.change_qty) AS returnQty,
				SUM(sslw.change_qty*sslw.unit_cost) AS returnAmount,
				0 AS exchangeQty,
				0 AS exchangeAmount,
				0 AS transferQty,
				0 AS transferAmount,
				0 AS proxySaleReturnQty,
				0 AS proxySaleReturnAmount,
				0 AS endQty,
				0 AS endAmount,
				ga.id AS seasonId,	
				ga.code AS seasonCode,
				ga.name AS seasonName
			FROM stk_stock_logic_workflow sslw
				LEFT JOIN trade_sale_return_bill tsrb ON sslw.bill_no = tsrb.bill_no
				LEFT JOIN bas_legal_person blp ON sslw.owner_id = blp.id
				LEFT JOIN bas_legal_person_company blpc ON blp.code = blpc.legal_person_code
				LEFT JOIN bas_accounting_company bac ON bac.legal_person_company_id = blpc.id
				LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
				LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
				LEFT JOIN gds_attrvalue ga ON ga.id = ggba.field_4
			WHERE 1=1
				AND sslw.stock_type = 1
				AND sslw.qty_type = 1
				AND sslw.bill_name IN ('1D')
				AND bac.code = '00000001'
				AND tsrb.sale_method = 'S'
				AND (ggba.field_10 LIKE '${E3PLUS_QC_ART_NO}')
				AND (ggba.field_22 IN ('${E3PLUS_QC_GOODS_TYPE}'))
				AND (DATE_FORMAT(sslw.stock_date,'%Y-%m-%d') BETWEEN '${E3PLUS_QC_STOCK_DATE_START}' AND '${E3PLUS_QC_STOCK_DATE_END}')
			GROUP BY ga.id
		UNION ALL
			SELECT
				0 AS beginQty,
				0 AS beginAmount,
				0 AS puQty,
				0 AS puAmount,
				0 AS costAmount,
				0 AS saleQty,
				0 AS saleAmount1,
				0 AS saleAmount2,
				0 AS profitLossQty,
				0 AS profitLossAmount,
				0 AS returnQty,
				0 AS returnAmount,
				SUM(sslw.change_qty) AS exchangeQty,
				SUM(sslw.change_qty*sslw.unit_cost) AS exchangeAmount,
				0 AS transferQty,
				0 AS transferAmount,
				0 AS proxySaleReturnQty,
				0 AS proxySaleReturnAmount,
				0 AS endQty,
				0 AS endAmount,
				ga.id AS seasonId,	
				ga.code AS seasonCode,
				ga.name AS seasonName
			FROM stk_stock_logic_workflow sslw	
				LEFT JOIN trade_sale_return_bill tsrb ON sslw.bill_no = tsrb.bill_no
				LEFT JOIN bas_legal_person blp ON sslw.owner_id = blp.id
				LEFT JOIN bas_legal_person_company blpc ON blp.code = blpc.legal_person_code
				LEFT JOIN bas_accounting_company bac ON bac.legal_person_company_id = blpc.id
				LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
				LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
				LEFT JOIN gds_attrvalue ga ON ga.id = ggba.field_4
			WHERE 1=1
				AND sslw.stock_type = 1
				AND sslw.qty_type = 1
				AND sslw.bill_name IN ('1D')
				AND bac.code = '00000001'
				AND tsrb.sale_method = 'C'
				AND (ggba.field_10 LIKE '${E3PLUS_QC_ART_NO}')
				AND (ggba.field_22 IN ('${E3PLUS_QC_GOODS_TYPE}'))
				AND (DATE_FORMAT(sslw.stock_date,'%Y-%m-%d') BETWEEN '${E3PLUS_QC_STOCK_DATE_START}' AND '${E3PLUS_QC_STOCK_DATE_END}')
			GROUP BY ga.id	
		UNION ALL
			SELECT
				0 AS beginQty,
				0 AS beginAmount,
				0 AS puQty,
				0 AS puAmount,
				0 AS costAmount,
				0 AS saleQty,
				0 AS saleAmount1,
				0 AS saleAmount2,
				0 AS profitLossQty,
				0 AS profitLossAmount,
				0 AS returnQty,
				0 AS returnAmount,
				0 AS exchangeQty,
				0 AS exchangeAmount,
				SUM(sslw.change_qty) AS transferQty,
				SUM(sslw.change_qty*sslw.unit_cost) AS transferAmount,
				0 AS proxySaleReturnQty,
				0 AS proxySaleReturnAmount,
				0 AS endQty,
				0 AS endAmount,
				ga.id AS seasonId,	
				ga.code AS seasonCode,
				ga.name AS seasonName
			FROM stk_stock_logic_workflow sslw
				LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
				LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
				LEFT JOIN bas_stock_organization bso ON bso.id = sslw.stock_organization_id
				LEFT JOIN bas_accounting_company bac ON bac.id = bso.accounting_company_id
				LEFT JOIN gds_attrvalue ga ON ga.id = ggba.field_4
			WHERE 1=1
				AND stock_type = 2
				AND qty_type = 1
				AND bill_name = 89
				AND bac.code = '00000001'
				AND (ggba.field_10 LIKE '${E3PLUS_QC_ART_NO}')
				AND (ggba.field_22 IN ('${E3PLUS_QC_GOODS_TYPE}'))
				AND (DATE_FORMAT(sslw.stock_date,'%Y-%m-%d') BETWEEN '${E3PLUS_QC_STOCK_DATE_START}' AND '${E3PLUS_QC_STOCK_DATE_END}')
			GROUP BY ga.id	
		UNION ALL
			SELECT
				0 AS beginQty,
				0 AS beginAmount,
				0 AS puQty,
				0 AS puAmount,
				0 AS costAmount,
				0 AS saleQty,
				0 AS saleAmount1,
				0 AS saleAmount2,
				0 AS profitLossQty,
				0 AS profitLossAmount,
				0 AS returnQty,
				0 AS returnAmount,
				0 AS exchangeQty,
				0 AS exchangeAmount,
				0 AS transferQty,
				0 AS transferAmount,
				SUM(sslw.change_qty) AS proxySaleReturnQty,
				SUM(sslw.change_qty*sslw.unit_cost) AS proxySaleReturnAmount,
				0 AS endQty,
				0 AS endAmount,
				ga.id AS seasonId,	
				ga.code AS seasonCode,
				ga.name AS seasonName
			FROM stk_stock_logic_workflow sslw
				LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
				LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
				LEFT JOIN bas_stock_organization bso ON bso.id = sslw.stock_organization_id
				LEFT JOIN bas_accounting_company bac ON bac.id = bso.accounting_company_id
				LEFT JOIN gds_attrvalue ga ON ga.id = ggba.field_4
			WHERE 1=1
				AND stock_type = 2
				AND qty_type = 1
				AND bill_name = 99
				AND bac.code = '00000001'
				AND (ggba.field_10 LIKE '${E3PLUS_QC_ART_NO}')
				AND (ggba.field_22 IN ('${E3PLUS_QC_GOODS_TYPE}'))
				AND (DATE_FORMAT(sslw.stock_date,'%Y-%m-%d') BETWEEN '${E3PLUS_QC_STOCK_DATE_START}' AND '${E3PLUS_QC_STOCK_DATE_END}')
			GROUP BY ga.id
		UNION ALL
			SELECT
				0 AS beginQty,
				0 AS beginAmount,
				0 AS puQty,
				0 AS puAmount,
				0 AS costAmount,
				0 AS saleQty,
				0 AS saleAmount1,
				0 AS saleAmount2,
				0 AS profitLossQty,
				0 AS profitLossAmount,
				0 AS returnQty,
				0 AS returnAmount,
				0 AS exchangeQty,
				0 AS exchangeAmount,
				0 AS transferQty,
				0 AS transferAmount,
				0 AS proxySaleReturnQty,
				0 AS proxySaleReturnAmount,
				SUM(sslw.change_qty) AS endQty,
				SUM(sslw.change_qty*sslw.unit_cost) AS endAmount,
				ga.id AS seasonId,	
				ga.code AS seasonCode,
				ga.name AS seasonName
			FROM stk_stock_logic_workflow sslw
				LEFT JOIN bas_legal_person blp ON sslw.owner_id = blp.id
				LEFT JOIN bas_legal_person_company blpc ON blp.code = blpc.legal_person_code
				LEFT JOIN bas_accounting_company bac ON bac.legal_person_company_id = blpc.id
				LEFT JOIN gds_goods gg ON gg.id = sslw.goods_id
				LEFT JOIN gds_goods_base_attribute ggba ON ggba.goods_id = gg.id
				LEFT JOIN gds_attrvalue ga ON ga.id = ggba.field_4
			WHERE 1=1
				AND sslw.stock_type = 1
				AND qty_type = 1
				AND bac.code = '00000001'
				AND (ggba.field_10 LIKE '${E3PLUS_QC_ART_NO}')
				AND (ggba.field_22 IN ('${E3PLUS_QC_GOODS_TYPE}'))
				AND ((DATE_FORMAT(sslw.stock_date,'%Y-%m-%d')) <= '${E3PLUS_QC_STOCK_DATE_END}')
			GROUP BY ga.id
) tt GROUP BY tt.seasonId;