extends Node

# 属性计算器
# 这个脚本只负责根据基础数据计算最终属性
# 不保存玩家长期数据
# 不负责 UI
# 不负责战斗流程


# 百分比派生的通用长尾公式
# 作用：
# 属性越高，收益越高，但越接近上限越难继续提升
func _calc_long_tail_percent(value: float, reference_value: float, max_percent: float) -> float:
	if value <= 0:
		return 0.0

	var growth_factor := pow(value / reference_value, 0.4)
	var result := max_percent * growth_factor / (1.0 + growth_factor)

	return result


func build_player_snapshot(player_state: Node) -> Dictionary:
	# 根据 PlayerState 的基础数据，生成一份“最终属性快照”
	# 菜单、战斗、状态页以后都应该读这个快照

	var ti_po: float = player_state.ti_po
	var zhen_yuan_gen_ji: float = player_state.zhen_yuan_gen_ji
	var shen_shi: float = player_state.shen_shi

	# 基础派生
	var max_qi_xue := int(ti_po * 10.0)
	var max_fa_li := int(zhen_yuan_gen_ji * 10.0)

	# 攻击基础
	var wu_li_base := ti_po
	var jin_base := zhen_yuan_gen_ji
	var mu_base := zhen_yuan_gen_ji
	var shui_base := zhen_yuan_gen_ji
	var huo_base := zhen_yuan_gen_ji
	var tu_base := zhen_yuan_gen_ji

	# 减伤与抗性
	# 这里先用原型公式，后面可以统一调整
	var wu_kang := _calc_long_tail_percent(wu_li_base, 100.0, 85.0)
	var jin_kang := _calc_long_tail_percent(jin_base, 100.0, 50.0)
	var mu_kang := _calc_long_tail_percent(mu_base, 100.0, 50.0)
	var shui_kang := _calc_long_tail_percent(shui_base, 100.0, 50.0)
	var huo_kang := _calc_long_tail_percent(huo_base, 100.0, 50.0)
	var tu_kang := _calc_long_tail_percent(tu_base, 100.0, 50.0)

	# 神识派生
	var lian_zhi_cheng_gong := _calc_long_tail_percent(shen_shi, 100.0, 30.0)
	var lian_zhi_pin_zhi := _calc_long_tail_percent(shen_shi, 100.0, 20.0)

	# 状态命中 / 状态抵抗
	# 当前先使用 PlayerState 里的固定修正值
	# 后面可以把神识自然派生也加进来
	var zhuang_tai_ming_zhong := player_state.zhuang_tai_ming_zhong
	var zhuang_tai_di_kang := player_state.zhuang_tai_di_kang

	# 当前气血 / 法力不能超过上限
	var current_qi_xue = clamp(player_state.qi_xue, 0, max_qi_xue)
	var current_fa_li = clamp(player_state.fa_li, 0, max_fa_li)

	return {
		"player_name": player_state.player_name,
		"realm_name": player_state.realm_name,
		"dao_xing": player_state.dao_xing,
		"xiu_wei": player_state.xiu_wei,

		"qi_xue": current_qi_xue,
		"max_qi_xue": max_qi_xue,
		"fa_li": current_fa_li,
		"max_fa_li": max_fa_li,

		"ti_po": ti_po,
		"zhen_yuan_gen_ji": zhen_yuan_gen_ji,
		"shen_shi": shen_shi,

		"wu_li_base": wu_li_base,
		"jin_base": jin_base,
		"mu_base": mu_base,
		"shui_base": shui_base,
		"huo_base": huo_base,
		"tu_base": tu_base,

		"wu_kang": wu_kang,
		"jin_kang": jin_kang,
		"mu_kang": mu_kang,
		"shui_kang": shui_kang,
		"huo_kang": huo_kang,
		"tu_kang": tu_kang,

		"bao_ji": player_state.bao_ji,
		"bao_shang": player_state.bao_shang,
		"su_du": player_state.su_du,
		"fa_li_hui_fu": player_state.fa_li_hui_fu,

		"zhuang_tai_ming_zhong": zhuang_tai_ming_zhong,
		"zhuang_tai_di_kang": zhuang_tai_di_kang,

		"lian_zhi_cheng_gong": lian_zhi_cheng_gong,
		"lian_zhi_pin_zhi": lian_zhi_pin_zhi
	}


func format_percent(value: float) -> String:
	# 把小数百分比格式化为玩家能看的文本
	return "%.1f%%" % value
