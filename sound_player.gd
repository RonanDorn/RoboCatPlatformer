extends Node

@onready var pick_up_coin		 : AudioStreamPlayer = $AudioPlayers/PickUpCoin
@onready var check_point_update	 : AudioStreamPlayer = $AudioPlayers/CheckPointUpdate
@onready var player_dead		 : AudioStreamPlayer = $AudioPlayers/PlayerDead
@onready var music				 : AudioStreamPlayer = $MusicPlayers/Music

func _ready():
	GlobalEvents.coin_picked.connect(coin_sound)
	GlobalEvents.show_checkpoint_label.connect(new_checkpoint_sound)
	GlobalEvents.enter_in_hit_box.connect(player_dead_sound)
	
func coin_sound():
	pick_up_coin.play()

func new_checkpoint_sound():
	check_point_update.play()

func player_dead_sound():
	player_dead.play()
