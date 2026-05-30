extends CanvasLayer

@onready var animplayer: AnimationPlayer = $AnimationPlayer

func fade_in():
	show()
	animplayer.play("fade_in")
	
func fade_out():
	animplayer.play("fade_out")
