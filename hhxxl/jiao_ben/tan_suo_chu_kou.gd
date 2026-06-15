extends Area2D

# 探索出口脚本
# 挂在探索1里的出口 Area2D 上
# 作用：玩家碰到出口后，返回世界1
# 注意：不能在 body_entered 物理回调里直接切场景
# 所以这里用 call_deferred 延迟切换，避免 Godot 报红字警告

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

	# 延迟返回世界1
	# 不能在 body_entered 物理回调里直接切场景，否则会出现红字警告
	call_deferred("_qie_huan_dao_shi_jie")


func _qie_huan_dao_shi_jie() -> void:
	# 切换回世界1场景
	var error := get_tree().change_scene_to_file(GameState.world_scene_path)

	if error != OK:
		push_error("返回世界1失败，检查路径：" + GameState.world_scene_path)
