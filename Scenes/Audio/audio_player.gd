extends AudioStreamPlayer

const main_theme_intro = preload("res://Audio/Soundtracks/Main Theme/Abyssal Cleaner Theme - intro.ogg")
const main_theme_loop = preload("res://Audio/Soundtracks/Main Theme/Abyssal Cleaner Theme - loop.ogg")

const level1_intro: AudioStream = preload("res://Audio/Soundtracks/Level 1/Level 1 - intro.ogg")
const level1_loop: AudioStream = preload("res://Audio/Soundtracks/Level 1/Level 1 - loop.ogg")

var current_song: AudioStream

# this is used to loop the song without cutting the last note and letting it ring
@export var timer: Timer
@onready var secondary_audio_player = $"Secondary Audio Player"

var is_playing_music: bool = false

func _ready() -> void:
	if !timer.timeout.is_connected(play_seamless_music):
		timer.timeout.connect(play_seamless_music)

func play_seamless_music() -> void:
	play_music(current_song)

func loop_seamlessly(music_with_tail: AudioStream) -> void:
	timer.wait_time = stream.get_length()
	timer.start()
	
	current_song = music_with_tail

func play_music(music: AudioStream, volume = 0.0) -> void:
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_main_theme():
	play_music(main_theme_intro)
	loop_seamlessly(main_theme_loop)
	
func play_level_1():
	play_music(level1_intro)
	loop_seamlessly(level1_loop)

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
