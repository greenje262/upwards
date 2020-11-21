extends Spatial

const BLOCK = preload("res://Block.tscn")

onready var player = $Player
onready var story = $ScriptHolder/Viewport/Control/Panel/Label
onready var script_pos = 0
onready var top = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	story.text = GameScript.game_script[script_pos]

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if top == true:
		if player.translation.y < 55:
			get_tree().quit()

func _physics_process(delta):
	if get_node_or_null("blocktrigger"):
		if player.translation.y > 9:
			var block = BLOCK.instance()
			add_child(block)
			block.translation = $blocktrigger.translation
			$blocktrigger.queue_free()
	
	if player.translation.y > 13.5:
		if script_pos < 42:
			player.translation.y = player.translation.y - 4.6
			script_pos += 1
			story.text = GameScript.game_script[script_pos]
		else:
			if player.translation.y < 15:
				player.translation = player.translation + Vector3(12, 59.8, 0)
				top = true
				yield(get_tree().create_timer(2), "timeout")
				$BGM/BGMTween.interpolate_property($BGM, "unit_db", 0, -80, 3, Tween.TRANS_LINEAR)
				$BGM/BGMTween.start()
				$Wind.play(0)
				yield(get_tree().create_timer(3), "timeout")
				$BGM.stop()
