extends CanvasLayer

# 总 UI 管理脚本
# 只负责打开/关闭 UI，接收 UI 信号，然后执行外部传进来的回调
# 不亲自处理世界逻辑，不亲自处理探索逻辑

# 加载通用确认弹窗场景
const UI_1_SCENE: PackedScene = preload("res://chang_jing/ui_1.tscn")

# 当前确认弹窗实例
var ui_1: Control

# 确认后要执行的函数
var que_ren_callback: Callable = Callable()

# 取消后要执行的函数
var qu_xiao_callback: Callable = Callable()


func _ready() -> void:
	# 让总 UI 即使游戏暂停也能处理输入
	process_mode = Node.PROCESS_MODE_ALWAYS

	# UI 层级放高，保证显示在地图上面
	layer = 100

	# 创建 ui_1 弹窗实例
	ui_1 = UI_1_SCENE.instantiate()

	# 弹窗在暂停状态下也要能处理输入
	ui_1.process_mode = Node.PROCESS_MODE_ALWAYS

	# 加到总 UI 下面
	add_child(ui_1)

	# 默认隐藏
	ui_1.visible = false

	# 连接 ui_1 发出的确认/取消信号
	ui_1.que_ren.connect(_on_que_ren)
	ui_1.qu_xiao.connect(_on_qu_xiao)


func xian_shi_que_ren(text: String, on_confirm: Callable, on_cancel: Callable = Callable()) -> void:
	# 如果已经有弹窗打开，就不重复打开
	if ui_1.visible:
		return

	# 记录确认/取消之后要执行的函数
	que_ren_callback = on_confirm
	qu_xiao_callback = on_cancel

	# 暂停游戏，避免玩家在弹窗打开时继续移动
	get_tree().paused = true

	# 打开弹窗
	ui_1.da_kai(text)


func yin_cang_que_ren() -> void:
	# 关闭弹窗
	ui_1.guan_bi()

	# 取消暂停
	get_tree().paused = false

	# 清空回调，避免旧逻辑残留
	que_ren_callback = Callable()
	qu_xiao_callback = Callable()


func shi_fou_da_kai() -> bool:
	# 给其他脚本判断：当前有没有弹窗打开
	return ui_1 != null and ui_1.visible


func _on_que_ren() -> void:
	# 先保存确认回调
	var callback := que_ren_callback

	# 先关闭弹窗并取消暂停
	yin_cang_que_ren()

	# 再执行确认逻辑
	if callback.is_valid():
		callback.call()


func _on_qu_xiao() -> void:
	# 先保存取消回调
	var callback := qu_xiao_callback

	# 先关闭弹窗并取消暂停
	yin_cang_que_ren()

	# 如果有取消逻辑，就执行；没有就什么都不做
	if callback.is_valid():
		callback.call()
