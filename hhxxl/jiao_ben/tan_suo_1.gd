extends Node2D

# 探索1场景脚本
# 负责：
# 1. 进入探索时打印当前信息
# 2. 正常进入探索时，把玩家放到探索出生点
# 3. 从战斗胜利返回探索时，把玩家放回战斗前的位置
# 4. 离开探索由 tan_suo_chu_kou.gd 负责

@onready var player: CharacterBody2D = $wan_jiao

# 探索地图默认出生点
@onready var chu_sheng_dian: Marker2D = $tan_suo_chu_sheng_dian


func _ready() -> void:
	print("已经进入探索1")
	print("当前世界：", GameState.current_region_id)
	print("当前区块：", GameState.current_chunk)
	print("探索种子：", GameState.current_explore_seed)

	# 如果是从战斗胜利返回探索1，就放回战斗前的位置
	if GameState.has_return_explore_position:
		player.global_position = GameState.return_explore_position
		GameState.has_return_explore_position = false
	else:
		# 如果是从世界1正常进入探索1，就放到探索出生点
		player.global_position = chu_sheng_dian.global_position
