extends CharacterBody2D

# 玩家移动速度
const SPEED := 180.0

# 动画节点
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# 动画名称：必须和你 SpriteFrames 里的动画名完全一致
const ANIM_IDLE_DOWN := "xia_dai_ji"
const ANIM_IDLE_UP := "shang_dai_ji"
const ANIM_IDLE_SIDE := "che_dai_ji"

const ANIM_WALK_DOWN := "xia_zou"
const ANIM_WALK_UP := "shang_zou"
const ANIM_WALK_SIDE := "che_zou"

# 记录角色最后朝向
# 默认朝下，也就是小人正面看向屏幕
var last_direction := Vector2.DOWN


func _ready() -> void:
	# 进入场景后，默认播放向下待机动画
	anim.play(ANIM_IDLE_DOWN)


func _physics_process(_delta: float) -> void:
	# 读取上下左右输入
	# ui_left / ui_right / ui_up / ui_down 是 Godot 默认输入动作
	var input_direction := Input.get_vector("zuo", "you", "shang", "xia")

	# 设置移动速度
	velocity = input_direction * SPEED

	# 执行移动
	move_and_slide()

	# 根据是否移动，切换行走或待机动画
	if input_direction != Vector2.ZERO:
		_update_walk_animation(input_direction)
	else:
		_update_idle_animation()


func _update_walk_animation(direction: Vector2) -> void:
	# 横向移动优先播放侧面动画
	if abs(direction.x) > abs(direction.y):
		anim.play(ANIM_WALK_SIDE)

		if direction.x > 0:
			# 向右：正常显示侧面图
			anim.flip_h = false
			last_direction = Vector2.RIGHT
		else:
			# 向左：水平翻转侧面图
			anim.flip_h = true
			last_direction = Vector2.LEFT

	else:
		# 竖向移动播放上 / 下动画
		anim.flip_h = false

		if direction.y > 0:
			anim.play(ANIM_WALK_DOWN)
			last_direction = Vector2.DOWN
		else:
			anim.play(ANIM_WALK_UP)
			last_direction = Vector2.UP


func _update_idle_animation() -> void:
	# 停止移动后，根据最后朝向播放对应待机动画
	if last_direction == Vector2.DOWN:
		anim.flip_h = false
		anim.play(ANIM_IDLE_DOWN)

	elif last_direction == Vector2.UP:
		anim.flip_h = false
		anim.play(ANIM_IDLE_UP)

	elif last_direction == Vector2.RIGHT:
		anim.flip_h = false
		anim.play(ANIM_IDLE_SIDE)

	elif last_direction == Vector2.LEFT:
		anim.flip_h = true
		anim.play(ANIM_IDLE_SIDE)
