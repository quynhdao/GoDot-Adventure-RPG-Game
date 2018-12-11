extends Node2D

var doorOpenable = false
var playerPosReseted  = false
var player
var openDoor

func _ready():
	var sound = global.find_node_by_name(get_tree().get_root(), "Sound")
	openDoor = sound.get_node("OpenDoor")
	

func _process(delta):
	if !playerPosReseted:
		reset_player_pos(global.current_area) #Main.areaName

func _input(event):
	if(doorOpenable && !global.player.isInteracting):
		if event.is_action_pressed("interact"):
			doorOpenable = false
			openDoor.play()
			global.player.temp_disable()
			$DoorArea/DoorTimer.start()
			
# Resets players position according to the coordinates that are saved in global variables.
#set init pos if null
func reset_player_pos(var current_scene):
	if current_scene == "area1":
		# For playing the door close sound after exiting house to area1.
		if global.house1Exited:
			get_tree().get_root().get_node("Main/Sound/CloseDoor").play() #
			global.house1Exited = false
		if global.area1Position == Vector2():
			if global.last_area == "area2":
				global.area1Position = Vector2(700, -120)
			else:
				global.area1Position = Vector2(210, 380)
		global.player.position = global.area1Position
		
	elif current_scene == "area2":
		if global.area2Position == Vector2():
			if global.last_area:
				if global.last_area == "area1":
					global.area2Position = Vector2(-480, 410)
				if global.last_area == "area3":
					global.area2Position = Vector2(-333, -500)
				else:
					global.area2Position = Vector2(-480, 410)
		global.player.position = global.area2Position
		
	elif current_scene == "area3":
		if global.area3Position == Vector2():
			if global.last_area == "area2":
				global.area3Position = Vector2(790, 37)
			if global.last_area == "secretArea":
				global.area3Position = Vector2(-775, -780)
			else:
				global.area3Position = Vector2(790, 37)
		global.player.position = global.area3Position
		#Remove the tree blocking the secret way.
		if global.area1Switch:
			get_tree().get_root().get_node("Main/Area/area/walls").set_cell(-19,-5,4)
			
	elif current_scene == "secretArea":
		if global.secretAreaPosition == Vector2():
			global.secretAreaPosition = Vector2(480, 400)
		global.player.position = global.secretAreaPosition
		
	elif current_scene == "house1":
		get_tree().get_root().get_node("Main/Sound/CloseDoor").play()
		if global.house1Position == Vector2():
			global.house1Position = Vector2(864, 135)
		global.player.position = global.house1Position
			
	playerPosReseted = true
	global.playerPosSet = true
	
# Normal movement between areas. Move automatically to next scene after a brief delay.
func _on_MoveArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body != null:
		if body.get_name() == "player":
			$MoveArea/MoveTimer.start()
			get_tree().get_root().get_node("Main/Sound/WalkingOnLeaves").play()
			global.player.temp_disable()

func _on_MoveArea2_body_shape_entered(body_id, body, body_shape, area_shape):
	if body != null:
		if body.get_name() == "player":
			$MoveArea2/MoveTimer2.start()
			get_tree().get_root().get_node("Main/Sound/WalkingOnLeaves").play()
			global.player.temp_disable()

func _on_DoorArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body != null:
		if body.get_name() == "player":
			doorOpenable = true

func _on_DoorArea_body_shape_exited(body_id, body, body_shape, area_shape):
	if body != null:
		if body.get_name() == "player":
			doorOpenable = false