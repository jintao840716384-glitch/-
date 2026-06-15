extends Area2D

# 锁妖塔入口脚本
# 挂在世界1里的锁妖塔入口 Area2D 上
# 作用：
# 1. 玩家碰到入口后，进入探索1
# 2. 记录玩家从探索1返回世界1时的位置
# 3. 清理旧的战斗返回位置，避免上一次战斗位置残留


# 防止重复触发
var yi_jing_chu_fa := false


func _ready() -> void:
	# 连接 Area2D 的身体进入信号
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	# 如果已经触发过，就不重复执行
	if yi_jing_chu_fa:
		return

	# 只允许玩家触发
	if body.name != "wan_jiao":
		return

	# 标记已经触发
	yi_jing_chu_fa = true

	# 找到世界1里的锁妖塔返回点
	var fan_hui_dian := get_node_or_null("../suo_yao_ta_fan_hui_dian") as Marker2D

	# 如果有返回点，就记录返回点位置
	if fan_hui_dian != null:
		GameState.return_world_position = fan_hui_dian.global_position
	else:
		# 如果忘了放返回点，就临时放到入口下方
		GameState.return_world_position = global_position + Vector2(0, 64)

	# 标记：下次回到世界1时，需要把玩家放到返回点
	GameState.has_return_world_position = true

	# 清理旧的战斗返回探索位置
	# 防止上次战斗失败后，再次进入探索时直接回到明雷点附近
	GameState.has_return_explore_position = false
	GameState.return_explore_position = Vector2.ZERO
	GameState.return_explore_scene_path = ""

	# 延迟切换到探索1
	# 不能在 body_entered 物理回调里直接切场景，否则 Godot 会报红字
	call_deferred("_qie_huan_dao_tan_suo")


func _qie_huan_dao_tan_suo() -> void:
	# 切换到探索1场景
	var error := get_tree().change_scene_to_file(GameState.explore_scene_path)

	if error != OK:
		push_error("进入探索1失败，检查路径：" + GameState.explore_scene_path)
