extends Node

# 全局运行数据
# 只记录当前运行状态，不负责 UI，不负责移动，不负责战斗计算

# 当前所在世界 ID
var current_region_id := "shi_jie_1"

# 当前大世界区块坐标
# 现在区块系统暂时不用，但先留着
var current_chunk: Vector2i = Vector2i.ZERO

# 当前探索地图种子
var current_explore_seed: int = 0


# =========================
# 世界 / 探索场景路径
# =========================

# 世界1场景路径
var world_scene_path := "res://chang_jing/shi_jie_1.tscn"

# 探索1场景路径
var explore_scene_path := "res://chang_jing/tan_suo_1.tscn"

# 战斗1场景路径
var battle_scene_path := "res://chang_jing/zhan_dou_1.tscn"


# =========================
# 探索返回世界
# =========================

# 从探索地图返回世界1时的位置
var return_world_position: Vector2 = Vector2.ZERO

# 是否需要返回到记录的大世界位置
var has_return_world_position := false


# =========================
# 战斗返回探索
# =========================

# 当前即将进入的战斗 ID
# 例如：ta_1_jing_ying_1
var current_encounter_id := ""

# 从战斗返回探索地图时，要回到哪个探索场景
var return_explore_scene_path := ""

# 从战斗返回探索地图时，玩家要站在哪里
var return_explore_position: Vector2 = Vector2.ZERO

# 是否需要返回到记录的探索位置
var has_return_explore_position := false


# =========================
# 已清除明雷记录
# =========================

# 已经打赢过的明雷战斗
# key 是 encounter_id，value 固定为 true
var cleared_encounter_ids := {}


func mark_encounter_cleared(encounter_id: String) -> void:
	# 标记某个明雷战斗已经被清除
	if encounter_id == "":
		return

	cleared_encounter_ids[encounter_id] = true


func is_encounter_cleared(encounter_id: String) -> bool:
	# 查询某个明雷战斗是否已经被清除
	if encounter_id == "":
		return false

	return cleared_encounter_ids.has(encounter_id)
