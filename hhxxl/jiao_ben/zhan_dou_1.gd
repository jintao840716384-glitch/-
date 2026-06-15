extends Node2D

# 战斗1测试场景脚本
# 当前阶段只做战斗进出闭环：
# 1. 显示当前战斗 ID
# 2. 模拟胜利：返回探索1，并清除对应明雷点
# 3. 模拟失败：返回世界1锁妖塔前，并清掉探索返回位置

@onready var xin_xi_label: Label = $UI/xin_xi_label

@onready var gong_ji_button: Button = $UI/zhi_ling_panel/gong_ji_button
@onready var sheng_li_button: Button = $UI/zhi_ling_panel/sheng_li_button
@onready var shi_bai_button: Button = $UI/zhi_ling_panel/shi_bai_button


func _ready() -> void:
	xin_xi_label.text = "当前战斗ID：%s" % GameState.current_encounter_id

	print("进入战斗1")
	print("当前战斗ID：", GameState.current_encounter_id)

	gong_ji_button.pressed.connect(_on_gong_ji_button_pressed)
	sheng_li_button.pressed.connect(_on_sheng_li_button_pressed)
	shi_bai_button.pressed.connect(_on_shi_bai_button_pressed)


func _on_gong_ji_button_pressed() -> void:
	print("点击攻击：当前还只是测试按钮")


func _on_sheng_li_button_pressed() -> void:
	print("模拟胜利")

	# 胜利后清除这个明雷点
	GameState.mark_encounter_cleared(GameState.current_encounter_id)

	# 返回探索地图
	var target_scene := GameState.return_explore_scene_path

	if target_scene == "":
		target_scene = GameState.explore_scene_path

	var error := get_tree().change_scene_to_file(target_scene)

	if error != OK:
		push_error("战斗胜利后返回探索失败，检查路径：" + target_scene)


func _on_shi_bai_button_pressed() -> void:
	print("模拟失败")

	# 战败不清除明雷
	# 但必须清掉探索返回位置，避免下次进探索时又回到明雷触发点
	GameState.has_return_explore_position = false
	GameState.return_explore_position = Vector2.ZERO
	GameState.return_explore_scene_path = ""

	# 战败后返回世界1锁妖塔前
	GameState.has_return_world_position = true

	var error := get_tree().change_scene_to_file(GameState.world_scene_path)

	if error != OK:
		push_error("战斗失败后返回世界1失败，检查路径：" + GameState.world_scene_path)
