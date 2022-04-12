SELECT
bb.`code` AS '客户编号',
bb.name AS '客户名称' ,
bb.seasonName AS '季节',
bb.plannedOrderAmount AS '计划订货额度',
bb.actualAmount AS '实际订货金额',
ROUND(bb.actualAmount/bb.plannedOrderAmount) AS '订货完成率',
bb.plannedExchangeAmount AS '订货预计换货出货金额',
bb.plannedSaleAmount AS '订货预计现金出货金额',
bb.clearedRebateAmount AS '上一季度优惠补贴清算应补/退金额',
bb.startDate AS '无发票优惠补贴累加金额开始日期',
bb.endDate AS '无发票优惠补贴累加金额结束日期',
bb.adjustedRebateAmount AS '无发票优惠补贴累加金额',
bb.settleRatioType AS '市场发展基金预计百分比',
bb.plannedRebateAmount AS '市场发展基金预计金额',
bb.settleRatioType AS '零售发展基金预计百分比',
bb.plannedRebateAmount AS '零售发展基金预计金额',
bb.adjusted_rebate_amount AS '本季优惠补贴合计金额',
bb.ratio AS '优惠补贴合计占现金出货金额的比率',
bb.rate AS '分配率(1-RATE)',
bb.billStatus AS '单据状态',
bb.modify_time AS '审核时间'
FROM (
SELECT
bs.`code`,
bs.name,
sd.id AS season_id,
sd.`name` AS seasonName,
cr.planned_order_amount AS plannedOrderAmount,
(SELECT sum(dl.price * dl.qty) AS amount FROM drp_requistion_bill dr left join drp_requistion_bill_line dl on dr.id=dl.bill_id where dr.accounting_company_id=(SELECT bb.accounting_company_id FROM bas_customer bb where bb.id=cr.customer_id limit 1)) AS actualAmount,
cr.planned_exchange_amount AS plannedExchangeAmount,
cr.planned_sale_amount AS plannedSaleAmount,
cr.cleared_rebate_amount AS clearedRebateAmount,
(SELECT ccr.adjusted_date_FROM FROM crd_rebate_requisition ccr where ccr.id=cr.id and ccr.bill_status='03' and ccr.adjusted_is_invoice='0' limit 1) AS startDate,
(SELECT ccr.adjusted_date_to FROM crd_rebate_requisition ccr where ccr.id=cr.id and ccr.bill_status='03' and ccr.adjusted_is_invoice='0' limit 1) AS endDate,
(SELECT ccr.adjusted_rebate_amount FROM crd_rebate_requisition ccr where ccr.id=cr.id and ccr.bill_status='03' and ccr.adjusted_is_invoice='0' limit 1) AS adjustedRebateAmount,
(SELECT rrl.settle_ratio_type FROM crd_rebate_requisition ccr left join crd_rebate_requisition_line rrl on ccr.id=rrl.bill_id where ccr.id=cr.id and ccr.bill_status='03' and rrl.rebate_base_type='01'  limit 1) AS settleRatioType,
(SELECT rrl.planned_rebate_amount FROM crd_rebate_requisition ccr left join crd_rebate_requisition_line rrl on ccr.id=rrl.bill_id where ccr.id=cr.id and ccr.bill_status='03' and rrl.rebate_base_type='01'  limit 1) AS plannedRebateAmount,
(SELECT rrl.settle_ratio_type FROM crd_rebate_requisition ccr left join crd_rebate_requisition_line rrl on ccr.id=rrl.bill_id where ccr.id=cr.id and ccr.bill_status='03' and rrl.rebate_base_type='02'  limit 1) AS settleRatioType2,
(SELECT rrl.planned_rebate_amount FROM crd_rebate_requisition ccr left join crd_rebate_requisition_line rrl on ccr.id=rrl.bill_id where ccr.id=cr.id and ccr.bill_status='03' and rrl.rebate_base_type='02'  limit 1) AS plannedRebateAmount2,
cr.adjusted_rebate_amount,
ROUND((cr.adjusted_rebate_amount/cr.planned_sale_amount)) AS ratio,
(1-ROUND((cr.adjusted_rebate_amount/cr.planned_sale_amount))) AS rate,
(case when cr.bill_status='01'
	then '初始'
	when cr.bill_status='02'
	then '提交'
	when cr.bill_status='03'
	then '审核'
end) AS billStatus,
cr.modify_time
FROM bas_customer bs
left join crd_rebate_requisition cr on bs.id=cr.customer_id
# left join crd_season_dictionary sd on cr.season_dictionary_id=sd.id
left join crd_season_dictionary sd on cr.season_dictionary_id=sd.id
where 1=1
AND (bs.id IN (0) OR 1=1 ) -- 客户
AND (sd.id IN (202201) ) -- 季节
and
(case when ('@AREA_ID')=0
			then 1=1
			else
			bs.id IN (SELECT bbc.customer_id FROM bas_customer_area bbc WHERE (bbc.area_id IN (0) OR 1=1 ) )
end)
and
(case when ('@PROVINCE_ID')=0
			then 1=1
			else
			bs.id IN (SELECT bbc.customer_id FROM bas_customer_area bbc WHERE (bbc.area_id IN (0) OR 1=1 ) )
end)
-- AND bs.id IN (SELECT bbc.customer_id FROM bas_customer_area bbc WHERE (bbc.area_id IN (0) OR 1=1 ) )
-- AND bs.id IN (SELECT bbc.customer_id FROM bas_customer_area bbc WHERE (bbc.area_id IN (0) OR 1=1 ) )
order by bs.`code` asc
) AS bb