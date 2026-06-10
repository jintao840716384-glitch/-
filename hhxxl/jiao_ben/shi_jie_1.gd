extends Node2D

# 一个大世界区块的尺寸
# 512 像素 = 32 个 16x16 瓦片
const CHUNK_SIZE := 512.0

@onready var player: CharacterBody2D = $wan_jiao


func _ready() -> void:
	# 从探索场景返回时，把玩家放回原位置
	if GameState.has_return_world_position:
		player.global_position = GameState.return_world_position
		GameState.has_return_world_position = false


func _unhandled_input(event: InputEvent) -> void:
	# 按探索键，先弹出确认框
	if event.is_action_pressed("tan_suo"):
		get_viewport().set_input_as_handled()

		ZongUI.xian_shi_que_ren(
			"确定进入？",
			Callable(self, "_enter_explore_scene")
		)


func _enter_explore_scene() -> void:
	var pos := player.global_position

	var chunk := Vector2i(
		floori(pos.x / CHUNK_SIZE),
		floori(pos.y / CHUNK_SIZE)
	)

	GameState.current_region_id = "shi_jie_1"
	GameState.current_chunk = chunk
	GameState.return_world_position = pos
	GameState.has_return_world_position = true

	GameState.current_explore_seed = abs(hash("%s:%d:%d" % [
		GameState.current_region_id,
		chunk.x,
		chunk.y
	]))

	print("进入探索")
	print("当前区块：", chunk)
	print("探索种子：", GameState.current_explore_seed)

	var error := get_tree().change_scene_to_file(GameState.explore_scene_path)
	if error != OK:
		push_error("切换探索场景失败，检查路径：" + GameState.explore_scene_path)
