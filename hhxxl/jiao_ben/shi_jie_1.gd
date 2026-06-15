extends Node2D

# 世界1场景脚本
# 负责：从探索1返回时，把玩家放回锁妖塔入口旁边
# 不再负责按 E 进入探索

# 玩家节点
@onready var player: CharacterBody2D = $wan_jiao


func _ready() -> void:
	# 如果是从探索1返回世界1，就把玩家放到记录好的返回点
	if GameState.has_return_world_position:
		player.global_position = GameState.return_world_position
		GameState.has_return_world_position = false
