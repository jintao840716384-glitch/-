extends Control

# 通用确认弹窗脚本
# 这个脚本只负责 ui_1 场景自己的显示、隐藏、按钮点击和键盘确认/取消
# 不负责进入探索、不负责返回世界、不负责切换场景

# 发给总 UI 的信号：玩家点了确定
signal que_ren

# 发给总 UI 的信号：玩家点了取消
signal qu_xiao


# 弹窗底框
@onready var di_kuang: Panel = $di_kuang

# 弹窗文案
@onready var wen_an: Label = $di_kuang/wen_an

# 确定按钮
@onready var que_ding: Button = $di_kuang/que_ding

# 取消按钮
@onready var qu_xiao_button: Button = $di_kuang/qu_xiao


func _ready() -> void:
	# 默认隐藏，只有总 UI 调用时才显示
	visible = false

	# 设置按钮文字
	que_ding.text = "确定"
	qu_xiao_button.text = "取消"

	# 鼠标点击确定
	que_ding.pressed.connect(_on_que_ding_pressed)

	# 鼠标点击取消
	qu_xiao_button.pressed.connect(_on_qu_xiao_pressed)


func da_kai(text: String) -> void:
	# 设置弹窗文案
	wen_an.text = text

	# 显示弹窗
	visible = true

	# 把弹窗移动到屏幕中间
	_ju_zhong_xian_shi()

	# 默认让确定按钮获得焦点
	# 这样玩家可以用键盘确认
	que_ding.grab_focus()


func guan_bi() -> void:
	# 关闭弹窗
	visible = false


func _ju_zhong_xian_shi() -> void:
	# 获取当前窗口大小
	var screen_size := get_viewport_rect().size

	# 获取底框大小
	var panel_size := di_kuang.size

	# 让底框居中
	di_kuang.position = (screen_size - panel_size) / 2.0


func _input(event: InputEvent) -> void:
	# 弹窗没打开时，不处理输入
	if not visible:
		return

	# 弹窗打开后，再按一次探索键，相当于确定
	if event.is_action_pressed("tan_suo"):
		get_viewport().set_input_as_handled()
		_on_que_ding_pressed()

	# 弹窗打开后，按 ESC，相当于取消
	elif event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_qu_xiao_pressed()


func _on_que_ding_pressed() -> void:
	# 通知总 UI：玩家确认了
	que_ren.emit()


func _on_qu_xiao_pressed() -> void:
	# 通知总 UI：玩家取消了
	qu_xiao.emit()
