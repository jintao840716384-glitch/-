extends Control

# 发给总 UI 的信号：确认
signal que_ren

# 发给总 UI 的信号：取消
signal qu_xiao


# 绑定 UI 节点，路径必须和你的节点树一致
@onready var wen_an: Label = $di_kuang/wen_an
@onready var que_ding: Button = $di_kuang/que_ding
@onready var qu_xiao_button: Button = $di_kuang/qu_xiao


func _ready() -> void:
	# 默认隐藏，只有总 UI 调用时才显示
	visible = false

	# 设置两个按钮文字
	que_ding.text = "确定"
	qu_xiao_button.text = "取消"

	# 鼠标点击确定
	que_ding.pressed.connect(_on_que_ding_pressed)

	# 鼠标点击取消
	qu_xiao_button.pressed.connect(_on_qu_xiao_pressed)


func da_kai(text: String) -> void:
	# 设置弹窗文案，比如“确定进入？”、“确定离开？”
	wen_an.text = text

	# 显示 UI
	visible = true

	# 默认让确定按钮获得焦点
	que_ding.grab_focus()


func guan_bi() -> void:
	# 关闭 UI
	visible = false


func _input(event: InputEvent) -> void:
	# UI 没显示时，不处理键盘
	if not visible:
		return

	# 弹窗显示时，再按一次探索键，相当于确定
	if event.is_action_pressed("tan_suo"):
		get_viewport().set_input_as_handled()
		_on_que_ding_pressed()

	# 弹窗显示时，按 ESC，相当于取消
	elif event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_qu_xiao_pressed()


func _on_que_ding_pressed() -> void:
	que_ren.emit()


func _on_qu_xiao_pressed() -> void:
	qu_xiao.emit()
