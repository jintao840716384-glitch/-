extends Area2D

# 明雷触发点脚本
# 挂在 ming_lei_chu_fa_dian.tscn 的 Area2D 根节点上
# 作用：
# 1. 检测玩家靠近
# 2. 记录当前要进入哪场战斗
# 3. 记录战斗结束后返回探索地图的位置
# 4. 切换到战斗场景

# 这场明雷对应的战斗 ID
# 把明雷触发点拖进探索地图后，在右边检查器里改这个值
@export var encounter_id := "ta_1_jing_ying_1"

# 是否自动触发
# true = 玩家碰到就进入战斗
# false = 后面可以改成按 E 交互触发
@export var auto_trigger := true

# 防止重复触发
var yi_jing_chu_fa := false


func _ready() -> void:
	# 如果这场明雷已经被打赢过，就直接移除
	if GameState.is_encounter_cleared(encounter_id):
		queue_free()
		return

	# 连接 Area2D 的身体进入信号
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	# 如果不是自动触发，就不处理
	if not auto_trigger:
		return

	# 如果已经触发过，就不重复执行
	if yi_jing_chu_fa:
		return

	# 只允许玩家触发
	if body.name != "wan_jiao":
		return

	# 标记已经触发
	yi_jing_chu_fa = true

	# 记录当前战斗 ID
	GameState.current_encounter_id = encounter_id

	# 记录当前探索场景路径
	var current_scene := get_tree().current_scene

	if current_scene != null and current_scene.scene_file_path != "":
		GameState.return_explore_scene_path = current_scene.scene_file_path
	else:
		GameState.return_explore_scene_path = GameState.explore_scene_path

	# 记录战斗结束后，玩家返回探索地图的位置
	GameState.return_explore_position = body.global_position
	GameState.has_return_explore_position = true

	# 延迟切换到战斗场景
	# 不能在 body_entered 物理回调里直接切场景，否则 Godot 会报红字
	call_deferred("_qie_huan_dao_zhan_dou")


func _qie_huan_dao_zhan_dou() -> void:
	# 切换到战斗1场景
	var error := get_tree().change_scene_to_file(GameState.battle_scene_path)

	if error != OK:
		push_error("进入战斗场景失败，检查路径：" + GameState.battle_scene_path)
