extends Node

# 玩家状态数据
# 这个脚本负责保存玩家当前真实数据
# 不负责 UI
# 不负责战斗流程
# 不负责地图移动


# =========================
# 基础身份
# =========================

# 角色名称
var player_name := "角色名称"

# 当前境界显示名
# 后面会改成由道行自动计算
var realm_name := "筑基巅峰"


# =========================
# 境界 / 经验
# =========================

# 道行：境界进度
# 功法注入修为后，会同比增加道行
var dao_xing := 8000

# 修为：可支配经验池
# 杀敌、事件、道具等获得修为
# 修为本身不直接提升属性
var xiu_wei := 300


# =========================
# 三主属性
# =========================

# 体魄：影响气血、物理基础、物理减伤
var ti_po := 100

# 真元根基：影响法力上限、金木水火土基础
var zhen_yuan_gen_ji := 50

# 神识：影响状态命中、状态抵抗、炼制相关
var shen_shi := 50


# =========================
# 当前资源
# =========================

# 当前气血
# 当前先手动设置，后面会根据最大气血初始化
var qi_xue := 1000

# 当前法力
var fa_li := 500


# =========================
# 固定战斗修正
# =========================

# 暴击率，百分比
var bao_ji := 5.0

# 暴击伤害，理解为额外爆伤百分比
# 50 = 暴击时额外 +50%
var bao_shang := 50.0

# 速度，跑条用
var su_du := 100

# 法力回复
# 1 = 每次行动开始恢复最大法力 1%
var fa_li_hui_fu := 1.0

# 状态命中修正
# 0 = 不额外增加状态命中
var zhuang_tai_ming_zhong := 0.0

# 状态抵抗修正
# 0 = 不额外增加状态抵抗
var zhuang_tai_di_kang := 0.0


func get_snapshot() -> Dictionary:
	# 获取最终属性快照
	# UI、战斗以后都应该读这个
	return AttributeCalculator.build_player_snapshot(self)


func get_status_left_text() -> String:
	# 状态页左侧文本
	var s := get_snapshot()

	var text := ""
	text += "角色名称\n"
	text += "\n"
	text += "境界：%s\n" % s["realm_name"]
	text += "道行：%d\n" % s["dao_xing"]
	text += "\n"
	text += "气血：%d / %d\n" % [s["qi_xue"], s["max_qi_xue"]]
	text += "法力：%d / %d\n" % [s["fa_li"], s["max_fa_li"]]
	text += "修为：%d\n" % s["xiu_wei"]
	text += "\n"
	text += "体魄：%d\n" % int(s["ti_po"])
	text += "真元：%d\n" % int(s["zhen_yuan_gen_ji"])
	text += "神识：%d\n" % int(s["shen_shi"])

	return text


func get_status_middle_text() -> String:
	# 状态页中间文本：物理 / 五行基础和抗性
	var s := get_snapshot()

	var text := ""
	text += "物理：%d\n" % int(s["wu_li_base"])
	text += "金：%d\n" % int(s["jin_base"])
	text += "木：%d\n" % int(s["mu_base"])
	text += "水：%d\n" % int(s["shui_base"])
	text += "火：%d\n" % int(s["huo_base"])
	text += "土：%d\n" % int(s["tu_base"])
	text += "\n"

	text += "物抗：%s减伤\n" % AttributeCalculator.format_percent(s["wu_kang"])
	text += "金抗：%s减伤\n" % AttributeCalculator.format_percent(s["jin_kang"])
	text += "木抗：%s减伤\n" % AttributeCalculator.format_percent(s["mu_kang"])
	text += "水抗：%s减伤\n" % AttributeCalculator.format_percent(s["shui_kang"])
	text += "火抗：%s减伤\n" % AttributeCalculator.format_percent(s["huo_kang"])
	text += "土抗：%s减伤\n" % AttributeCalculator.format_percent(s["tu_kang"])

	return text


func get_status_right_text() -> String:
	# 状态页右侧文本：战斗修正
	var s := get_snapshot()

	var text := ""
	text += "暴击：%s\n" % AttributeCalculator.format_percent(s["bao_ji"])
	text += "爆伤：%s\n" % AttributeCalculator.format_percent(s["bao_shang"])
	text += "速度：%d\n" % int(s["su_du"])
	text += "法力回复：%s\n" % AttributeCalculator.format_percent(s["fa_li_hui_fu"])
	text += "状态命中：%s\n" % AttributeCalculator.format_percent(s["zhuang_tai_ming_zhong"])
	text += "状态抵抗：%s\n" % AttributeCalculator.format_percent(s["zhuang_tai_di_kang"])
	text += "\n"
	text += "炼制成功：%s\n" % AttributeCalculator.format_percent(s["lian_zhi_cheng_gong"])
	text += "炼制品质：%s\n" % AttributeCalculator.format_percent(s["lian_zhi_pin_zhi"])

	return text
