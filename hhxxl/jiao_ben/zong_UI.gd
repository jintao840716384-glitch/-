extends CanvasLayer

# 加载你的弹窗 UI 场景，不是脚本
const TAN_SUO_UI_SCENE: PackedScene = preload("res://chang_jing/ui_1.tscn")

# 当前弹窗 UI 实例
var tan_suo_ui: Control

# 确认后要执行的函数
var que_ren_callback: Callable = Callable()

# 取消后要执行的函数
var qu_xiao_callback: Callable = Callable()


func _ready() -> void:
	# UI 层级放高一点，保证压在地图上面
	layer = 100

	# 创建弹窗 UI 实例
	tan_suo_ui = TAN_SUO_UI_SCENE.instantiate()

	# 加到总 UI 下面
	add_child(tan_suo_ui)

	# 先隐藏
	tan_suo_ui.visible = false

	# 接收弹窗自己的确认 / 取消信号
	tan_suo_ui.que_ren.connect(_on_que_ren)
	tan_suo_ui.qu_xiao.connect(_on_qu_xiao)


func xian_shi_que_ren(text: String, on_confirm: Callable, on_cancel: Callable = Callable()) -> void:
	# 如果已经有弹窗打开，就不重复打开
	if tan_suo_ui.visible:
		return

	# 保存确认 / 取消之后要执行的函数
	que_ren_callback = on_confirm
	qu_xiao_callback = on_cancel

	# 打开弹窗，并设置文案
	tan_suo_ui.da_kai(text)


func yin_cang_que_ren() -> void:
	# 关闭弹窗
	tan_suo_ui.guan_bi()

	# 清空回调，避免旧逻辑残留
	que_ren_callback = Callable()
	qu_xiao_callback = Callable()


func shi_fou_da_kai() -> bool:
	# 给其他脚本判断：当前有没有弹窗打开
	return tan_suo_ui != null and tan_suo_ui.visible


func _on_que_ren() -> void:
	# 先保存回调
	var callback := que_ren_callback

	# 再关闭弹窗
	yin_cang_que_ren()

	# 执行确认逻辑
	if callback.is_valid():
		callback.call()


func _on_qu_xiao() -> void:
	# 先保存取消回调
	var callback := qu_xiao_callback

	# 再关闭弹窗
	yin_cang_que_ren()

	# 如果有取消逻辑，就执行；没有就什么都不做
	if callback.is_valid():
		callback.call()
