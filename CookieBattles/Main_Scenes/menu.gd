extends Node2D


func _on_start_button_pressed():
	global.game_state = "prepare"
	get_tree().change_scene_to_file("res://Main_Scenes/game_scene.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
