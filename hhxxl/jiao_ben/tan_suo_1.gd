extends Control

signal yao_qiu_tan_suo

@onready var qu_kuai_label: Label = $xin_xi_mian_ban/qu_kuai_label
@onready var ling_qi_label: Label = $xin_xi_mian_ban/ling_qi_label
@onready var zi_yuan_label: Label = $xin_xi_mian_ban/zi_yuan_label
@onready var di_ren_label: Label = $xin_xi_mian_ban/di_ren_label
@onready var tan_suo_button: Button = $xin_xi_mian_ban/tan_suo_button
@onready var que_ren_tan_suo: ConfirmationDialog = $que_ren_tan_suo


func _ready() -> void:
	tan_suo_button.text = "进入探索"

	que_ren_tan_suo.title = "确认"
	que_ren_tan_suo.dialog_text = "确定进入当前区块探索？"
	que_ren_tan_suo.get_ok_button().text = "确定"
	que_ren_tan_suo.get_cancel_button().text = "取消"

	tan_suo_button.pressed.connect(_on_tan_suo_button_pressed)
	que_ren_tan_suo.confirmed.connect(_on_que_ren_tan_suo_confirmed)


func shua_xin_qu_kuai_xin_xi(chunk: Vector2i) -> void:
	qu_kuai_label.text = "当前区块：%d, %d" % [chunk.x, chunk.y]
	ling_qi_label.text = "灵气：暂未生成"
	zi_yuan_label.text = "资源：暂未生成"
	di_ren_label.text = "敌人：暂未生成"


func _on_tan_suo_button_pressed() -> void:
	que_ren_tan_suo.popup_centered(Vector2i(420, 160))


func _on_que_ren_tan_suo_confirmed() -> void:
	yao_qiu_tan_suo.emit()
