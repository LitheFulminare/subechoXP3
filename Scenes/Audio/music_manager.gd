extends AudioStreamPlayer

enum songs
{
	no_song,
	main_theme,
	level1,
}

const main_theme: AudioStream  = preload("res://Audio/Soundtracks/Main Theme/Abyssal Cleaner Theme.ogg")

const level1: AudioStream = preload("res://Audio/Soundtracks/Level 1/Level 1.ogg")

var current_song: songs = songs.no_song
var queued_song: Callable

# this is used to loop the song without cutting the last note and letting it ring
@export var timer: Timer
@onready var secondary_audio_player = $"Secondary Audio Player"

var is_playing_music: bool = false

func play_music(music: AudioStream, volume = 0.0) -> void:
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

# principal calls this and plays the intro again if it's playing the loop
func play_main_theme():
	play_music(main_theme)
	
func play_level_1():
	play_music(level1)

func stop_playing_with_fadeout(fadeout_time: float = 1):
	is_playing_music = false
	# resets max polyphony to the normal value
	secondary_audio_player.max_polyphony = 1
	
	# create tween for the volume of both main and secondary Audio Players
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -60, fadeout_time)
	await tween.finished
	
	# after the tween it stops the music and sets the volume back to normal
	stop()
	secondary_audio_player.stop()
	stream = null
	secondary_audio_player.stream = null
	volume_db = 0
	secondary_audio_player.volume_db = 0
	
	queued_song.call()
