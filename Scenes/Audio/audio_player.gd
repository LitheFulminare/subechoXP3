extends AudioStreamPlayer

const main_theme = preload("res://Audio/Soundtracks/Abyssal_Cleaner_Theme.ogg")

func play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_main_theme():
	play_music(main_theme)
