extends CanvasLayer

signal start_game

var lives = 3
var life_images = []  # Lista para almacenar las imágenes de las vidas

func _ready():
	pass

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	
	show_message("Game Over")
	await $MessageTimer.timeout
	$MessageLabel.text = "Dodge the\nCreeps"
	$MessageLabel.show()
	await get_tree().create_timer(1).timeout
	$StartButton.show()

func update_score(score):
	if lives==0:
		score=0
	$ScoreLabel.text = str(score)

func lose_life():
	lives -= 1
	if lives >= 0:
		if life_images[lives] != null:
			life_images[lives].queue_free()  # Eliminar la imagen de la vida perdida
			life_images.erase(lives)  # Eliminar la referencia de la lista
		if lives > 0:
			return true
		else:
			show_game_over()
			return false

func _on_StartButton_pressed():
	lives = 3
	life_images = [] 
	for i in range(lives):
		var life_sprite = TextureRect.new()
		life_sprite.texture = preload("res://pac man/pac man life counter.png")
		life_sprite.position = Vector2(10 + i * (life_sprite.texture.get_width() + 5), 10)
		add_child(life_sprite)
		life_images.append(life_sprite)
	
	$StartButton.hide()
	start_game.emit()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()
