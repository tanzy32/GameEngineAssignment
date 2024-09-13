extends AudioStreamPlayer

const background_music = preload("res://assets/audio/music/Scene - The Long Journey (piano v2).ogg")


func _play_music(music: AudioStream, volume = -5, bus = "Music"):
	if stream == music:
		stream = music
		volume_db = volume
		bus = "Music"
		play()
	
	#stream = music
	#volume_db = volume
	#play()

func play_bgm():
	_play_music(background_music)
	
func stop_bgm():
	stop()  # Stop playback of the current stream



