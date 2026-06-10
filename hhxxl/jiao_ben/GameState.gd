extends Node

# 当前大区域，现阶段固定为东胜神州
var current_region_id := "shi_jie_1"

# 当前大世界区块坐标
var current_chunk: Vector2i = Vector2i.ZERO

# 当前探索地图种子
var current_explore_seed: int = 0

# 从探索地图返回大世界时的位置
var return_world_position: Vector2 = Vector2.ZERO
var has_return_world_position := false


# 场景路径，后面按你的实际路径改
var world_scene_path := "res://chang_jing/shi_jie_1.tscn"
var explore_scene_path := "res://chang_jing/tan_suo_1.tscn"
