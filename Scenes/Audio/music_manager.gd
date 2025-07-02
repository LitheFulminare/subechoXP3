extends AudioStreamPlayer

enum songs
{
	no_song,
	main_theme,
	level1,
}

const main_theme: AudioStream  = preload("res://Audio/Soundtracks/Main Theme/Abyssal Cleaner Theme.ogg")

const shop_song: AudioStream = preload("res://Audio/Soundtracks/Shop/Shop.ogg")

const level1: AudioStream = preload("res://Audio/Soundtracks/Level 1/Level 1.ogg")
const level2: AudioStream = preload("res://Audio/Soundtracks/Level 2/Level_2.ogg")

var level_songs: Array[AudioStream] = [level1, level2]

var current_song: songs = songs.no_song
var queued_song: AudioStream

# this is used to loop the song without cutting the last note and letting it ring
@export var timer: Timer
@export var secondary_audio_player: AudioStreamPlayer

var is_playing_music: bool = false

func play_music(music: AudioStream, audio_player: AudioStreamPlayer = self, volume = 0.0) -> void:
	audio_player.volume_db = volume
	
	if audio_player.stream == music:
		return
	
	audio_player.stream = music
	audio_player.play()

# principal calls this and plays the intro again if it's playing the loop
func play_main_theme():
	play_music(main_theme)
	
func play_level_1():
	play_music(level1)
	
func play_level_2():
	play_music(level2)

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
	
	if queued_song == null:
		return
		
	play_music(queued_song)

func transition_to_song(new_song: AudioStream, duration: float = 0.15) -> void:
	var tween: Tween = get_tree().create_tween()
	
	# if "Music Player" node is playing
	if playing:
		tween.tween_property(self, "volume_db", -80, duration)
		play_music(new_song, secondary_audio_player)
		
		await tween.finished
		stop()
	
	# if "Secondary Music Player" node is playing
	else:
		tween.tween_property(secondary_audio_player, "volume_db", -80, duration)
		play_music(new_song, self)
		
		await tween.finished
		secondary_audio_player.stop()

func change_level_song() -> void:
	if Global.current_room - 1 < MusicManager.level_songs.size():
		transition_to_song(level_songs[Global.current_room-1])
		#stop_playing_with_fadeout(1)
		#queued_song = level_songs[Global.current_room-1]
