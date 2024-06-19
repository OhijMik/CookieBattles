extends Node2D


func _on_start_button_pressed():
	global.game_state = "prepare"
	global.cookie_list = []
	global.milk_list = []
	global.gold = 400
	global.round = 1
	global.paused = false
	get_tree().change_scene_to_file("res://Main_Scenes/game_scene.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_help_button_pressed():
	get_tree().change_scene_to_file("res://Main_Scenes/help.tscn")
