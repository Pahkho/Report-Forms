
SELECT dl_name as NAME
		,sum(qcsl) as qcsl, sum(qcje)qcje
		,sum(jhsl)jhsl, sum(jhje)jhje
		,sum(xssl)xssl, sum(xsje)xsje
		,sum(yksl)yksl, sum(ykje)ykje
		,sum(thsl)thsl, sum(thje)thje
		,sum(hhsl)hhsl, sum(hhje)hhje
		,sum(dxdbsl)dxdbsl, sum(dxdbje)dxdbje
		,sum(dxthsl)dxthsl, sum(dxthje)dxthje
		,sum(qmsl)qmsl, sum(qmje)qmje
/*
'1经销库存' AS NAME
    ,sum(qcsl)qcsl, sum(qcje)qcje
    ,sum(jhsl)jhsl, sum(jhje)jhje
		,sum(xssl)xssl, sum(xsje)xsje
		,sum(yksl)yksl, sum(ykje)ykje
		,sum(thsl)thsl, sum(thje)thje
		,sum(hhsl)hhsl, sum(hhje)hhje
		,sum(dxdbsl)dxdbsl, sum(dxdbje)dxdbje
		,sum(dxthsl)dxthsl, sum(dxthje)dxthje
    ,sum(qmsl)qmsl, sum(qmje)qmje
*/
FROM (
    select vsku.dl_name
        ,0 qcsl, 0 qcje
        ,SUM(CASE WHEN sslw.bill_name IN ('67','68','98','94') THEN sslw.change_qty ELSE 0 END) JHSL #67 采购单,68 采购退单,94 受托代销单,98 受托代销退单
        ,SUM(CASE WHEN sslw.bill_name IN ('1W') THEN sslw.change_qty*mpc.price ELSE 0 END) JHJE #PROD完工结转单,成本更新单-在库
        ,SUM(CASE WHEN sslw.bill_name IN ('71') AND sslw.bill_type IN ('21','22','23') AND sales_method='S' THEN sslw.change_qty * -1 ELSE 0 END) XSSL #71销售单, 销售方式S    21订货会销售   22标准销售   23其它物品销售
        ,SUM(CASE WHEN sslw.bill_name IN ('71') AND sslw.bill_type IN ('21','22','23') AND sales_method='S' THEN sslw.change_qty * mpc.price * -1 ELSE 0 END) AS XSJE
        ,SUM(CASE WHEN sslw.bill_name IN ('1D') THEN  sslw.change_qty ELSE 0 END) YKSL #1D逻辑库存调整单
        ,SUM(CASE WHEN sslw.bill_name IN ('1D') THEN  sslw.change_qty * mpc.price ELSE 0 END) YKJE
        ,SUM(CASE WHEN sslw.bill_name IN ('77') AND sslw.bill_type IN ('37') THEN sslw.change_qty ELSE  0 END) THSL #37    标准销售退
        ,SUM(CASE WHEN sslw.bill_name IN ('77') AND sslw.bill_type IN ('37') THEN sslw.change_qty * mpc.price ELSE 0 END) THJE
        ,SUM(CASE WHEN sslw.bill_name IN ('71') AND sslw.bill_type IN ('21','22','23') AND sales_method='C' THEN sslw.change_qty * -1 ELSE 0 END) HHSL  #71销售单, 销售方式C    21订货会销售   22标准销售   23其它物品销售
        ,SUM(CASE WHEN sslw.bill_name IN ('71') AND sslw.bill_type IN ('21','22','23') AND sales_method='C' THEN sslw.change_qty * mpc.price * -1 ELSE 0 END) HHJE
        ,SUM(CASE WHEN sslw.bill_name IN ('86','89') THEN sslw.change_qty * -1 ELSE  0 END) DXDBSL #86调拨出库单#RPOD-AND sslw.bill_type IN ('1E')     89委托代销单
        ,SUM(CASE WHEN sslw.bill_name IN ('86','89') THEN sslw.change_qty * mpc.price * -1 ELSE 0 END) DXDBJE
        ,SUM(CASE WHEN sslw.bill_name IN ('85','99') THEN sslw.change_qty ELSE  0 END) DXTHSL  #85调拨入库单#RPOD-AND sslw.bill_type IN ('1R')     99委托代销退单
        ,SUM(CASE WHEN sslw.bill_name IN ('85','99') THEN sslw.change_qty * mpc.price ELSE 0 END) DXTHJE
        ,0 qmsl, 0 qmje
    from stk_stock_logic_workflow sslw
    #LEFT JOIN v_fin_cst_pac_item_costs cbb ON sslw.stock_organization_id=cbb.stock_organization_id AND sslw.stock_date BETWEEN cbb.period_start_date AND cbb.period_end_date AND sslw.goods_id=cbb.goods_id  #V_PAC成本
    LEFT JOIN fin_cst_pac_item_costs_summary cbb ON sslw.stock_organization_id=cbb.summary_org_id AND sslw.stock_date BETWEEN cbb.period_start_date AND cbb.period_end_date AND sslw.goods_id = cbb.summary_item_id  #PAC_SUMMARY成本
		left join bas_stock_organization org on sslw.stock_organization_id=org.id
		left join v_sku vsku on vsku.sku_id=sslw.sku_id
		left join mkt_price_control mpc on sslw.goods_id=mpc.goods_id and mpc.price_id=1
    WHERE 1=1
        AND (DATE_FORMAT(sslw.stock_date,'%Y-%m') BETWEEN '@CREATE_TIME_START' AND '@CREATE_TIME_END')
        #AND date(sslw.stock_date)>='2022-2-1'
        #AND date(sslw.stock_date)<='2022-2-28'
        AND sslw.qty_type = '1' #在库
        AND org.code='00000001'
		group by vsku.dl_name
union all
    select vsku.dl_name, SUM(a.begin_qty)qcsl, sum(a.begin_qty*mpc.price)qcje
        ,0 jhsl, 0 jhje, 0 xssl, 0 xsje, 0 yksl, 0 ykje, 0 thsl, 0 thje, 0 hhsl, 0 hhje, 0 dxdbsl, 0 dxdbje, 0 dxthsl, 0 dxthje
        , SUM(a.end_qty)qmsl, sum(a.end_qty*mpc.price)qmje
    from fin_stock_period_summary a
		left join bas_stock_organization org on a.stock_organization_id=org.id
    #left join v_fin_cst_pac_item_costs b on a.stock_organization_id=b.stock_organization_id AND a.period_code=b.period_code AND a.goods_id=b.goods_id
    left join fin_cst_pac_item_costs_summary b on a.stock_organization_id=b.summary_org_id AND a.period_code=b.period_code AND a.goods_id=b.summary_item_id
		left join v_sku vsku on vsku.sku_id=a.sku_id
		left join mkt_price_control mpc on a.goods_id=mpc.goods_id and mpc.price_id=1
    where 1=1
        and a.period_code=CONCAT(YEAR ('@CREATE_TIME_START-01'),'-',MONTH ('@CREATE_TIME_START-01'))
        #and a.period_code='2022-3'
        AND org.code='00000001'
    group by vsku.dl_name
union all
    #sum(actual_cost) jhje 4.2改0，零售价不算调整
    select vsku.dl_name, 0 qcsl, 0 qcje, 0 jhsl, 0 jhje, 0 xssl, 0 xsje, 0 yksl, 0 ykje, 0 thsl, 0 thje, 0 hhsl, 0 hhje, 0 dxdbsl, 0 dxdbje, 0 dxthsl, 0 dxthje, 0 qmsl, 0 qmje
    from fin_cst_txn_cost_details a
    left join bas_stock_organization org on a.stock_organization_id=org.id
		left join v_sku vsku on vsku.sku_id=a.sku_id
		left join mkt_price_control mpc on a.goods_id=mpc.goods_id and mpc.price_id=1
    where bill_name IN ('5B','1W')
        AND (DATE_FORMAT(a.stock_date,'%Y-%m') BETWEEN '@CREATE_TIME_START' AND '@CREATE_TIME_END')
        #and date(stock_date)>='2022-2-1'
        #and date(stock_date)<='2022-2-28'
        AND org.code='00000001'
		group by vsku.dl_name
) AS JX
group by dl_name
order by dl_name