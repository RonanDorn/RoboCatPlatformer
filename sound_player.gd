extends Node

@onready var pick_up_coin		 : AudioStreamPlayer = $AudioPlayers/PickUpCoin
@onready var check_point_update	 : AudioStreamPlayer = $AudioPlayers/CheckPointUpdate
@onready var player_dead		 : AudioStreamPlayer = $AudioPlayers/PlayerDead
@onready var cheap_pick_up		 : AudioStreamPlayer = $AudioPlayers/CheapPickUp
@onready var music				 : AudioStreamPlayer = $MusicPlayers/Music

func _ready():
	GlobalEvents.coin_picked.connect(coin_sound)
	GlobalEvents.show_checkpoint_label.connect(new_checkpoint_sound)
	GlobalEvents.player_dead.connect(player_dead_sound)
	GlobalEvents.active_skill.connect(cheap_sound)
	
func coin_sound():
	pick_up_coin.play()

func new_checkpoint_sound():
	check_point_update.play()

func player_dead_sound():
	player_dead.play()

func cheap_sound(_nothing):
	cheap_pick_up.play()
