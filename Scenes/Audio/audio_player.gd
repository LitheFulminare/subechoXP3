extends AudioStreamPlayer

const main_theme = preload("res://Audio/Soundtracks/Abyssal_Cleaner_Theme.ogg")

@onready var secondary_audio_player = $"Secondary Audio Player"

var is_playing_music: bool = false

func play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_main_theme():
	is_playing_music = true
	secondary_audio_player.max_polyphony = 2
	play_music(main_theme)
	while is_playing:
		await get_tree().create_timer(22).timeout
		secondary_audio_player.stream = main_theme
		secondary_audio_player.play()

func stop_playing_with_fadeout(fadeout_time : float = 1):
	is_playing_music = false
	# resets max polyphony to the normal value
	secondary_audio_player.max_polyphony = 1
	
	# create tween for the volume
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -60, fadeout_time)
	#tween.tween_property(secondary_audio_player, "volume_db", 0, fadeout_time)
	await tween.finished
	
	# after the tween it stops the music and sets the volume back to normal
	stop()
	volume_db = 0
	#secondary_audio_player.stop()
