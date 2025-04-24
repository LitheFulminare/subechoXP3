extends AudioStreamPlayer

const main_theme = preload("res://Audio/Soundtracks/Abyssal_Cleaner_Theme.ogg")

@onready var secondary_audio_player = $"Secondary Audio Player"

var is_playing : bool = false

func play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_main_theme():
	is_playing = true
	secondary_audio_player.max_polyphony = 2
	play_music(main_theme)
	while is_playing:
		await get_tree().create_timer(22).timeout
		secondary_audio_player.stream = main_theme
		secondary_audio_player.play()

func stop_playing():
	is_playing = false
	secondary_audio_player.max_polyphony = 1
	stop()
