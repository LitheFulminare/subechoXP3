extends AudioStreamPlayer

const main_theme = preload("res://Audio/Soundtracks/Abyssal Cleaner Theme.ogg")

const level1_intro: AudioStream = preload("res://Audio/Soundtracks/Level 1 - intro.ogg")
const level1_loop: AudioStream = preload("res://Audio/Soundtracks/Level 1 - loop.ogg")

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
	play_music(main_theme)
	
func play_level_1():
	play_music(level1_intro)
	## USE A TIMER INSTEAD
	#maybe this is the solution -> stream.get_length()
	finished.connect(play_level_1_with_tail)

func play_level_1_with_tail():
	play_music(level1_loop)

func stop_playing_with_fadeout(fadeout_time: float = 1):
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
