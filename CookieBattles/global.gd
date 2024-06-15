extends Node2D

var is_dragging = false
var game_state = "prepare"		# prepare, battle, conclusion

var cookie_list = []
var milk_list = []

var gold = 100
var round = 1

var paused = false
