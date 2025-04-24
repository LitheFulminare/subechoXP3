extends AudioStreamPlayer

const main_theme = preload("res://Audio/Soundtracks/Abyssal Cleaner Theme.ogg")

# this is used to loop the song without cutting the last note and letting it ring
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
	
	# the file lasts almost 30 sec but the actual song lasts only 22 sec=
	# this loops the song while letting the last note ring 
	while is_playing_music:
		await get_tree().create_timer(22).timeout
		
		# maybe there's a better solution, but if I don't check is_playing_music
		# again it might cause an unwanted loop if the bool becomes false after
		# starting the timer
		if !is_playing_music:
			return
			
		secondary_audio_player.stream = main_theme
		secondary_audio_player.play()

func stop_playing_with_fadeout(fadeout_time : float = 1):
	is_playing_music = false
	# resets max polyphony to the normal value
	secondary_audio_player.max_polyphony = 1
	
	# create tween for the volume of both main and secondary Audio Players
	var tween1 = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween1.tween_property(self, "volume_db", -60, fadeout_time)
	tween2.tween_property(secondary_audio_player, "volume_db", -60, fadeout_time)
	# I don't know why, but I'm pretty sure I have to await both tweens even though
	# their duration is the same
	await tween1.finished
	await tween2.finished
	
	# after the tween it stops the music and sets the volume back to normal
	stop()
	secondary_audio_player.stop()
	stream = null
	secondary_audio_player.stream = null
	volume_db = 0
	secondary_audio_player.volume_db = 0
