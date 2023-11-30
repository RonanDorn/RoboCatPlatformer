extends ParallaxBackground

func _process(delta):
	scroll_offset.x += -40 * delta
	scroll_offset.y += 10 * delta
