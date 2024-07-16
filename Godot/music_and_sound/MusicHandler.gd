extends AudioStreamPlayer

# Add MusicHandler.tscn as a singleton in the project settings and call on it from anywhere like this:
# MusicHandler.play_music_track(MusicHandler.MUSIC_TRACK.example_music_track_1)

# For music files, .wav is best for short sound effects and .ogg is best for longer music. See here:
# https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_audio_samples.html

# if the music should start at for example 0.2 seconds instead of 0.0 seconds this is an easy way to clip sound files:
# https://audiotrimmer.com/

# Looping music configuration are set by just double clicking the music files.


enum MUSIC_TRACK {
    sleuth
}

var music_tracks = {
    MUSIC_TRACK.sleuth: preload("res://music_and_sound/music/Sleuth Theme.mp3"),
}

func play_music_track(music_track):
    stream = music_tracks[music_track]
    play()



# Fade volume can for example be used if music should fade out when switching scenes
func fade_volume(to, time_in_seconds):
    var tween = create_tween()
    tween.set_trans(Tween.TRANS_LINEAR)
    tween.tween_method(set_volume, get_volume(), to, time_in_seconds)


func set_volume(new_volume): # 0.0 - 1.0 where 0.5 = default volume, 0.0 = muted and 1.0 = double default volume.

    # Directly changing dB on an AudioStreamPlayer gives some strange results when changing volume.
    # Using linear_to_db() instead makes it sound as expected because then it gives a linear volume change.
    # linear_to_db() uses a volume parameter between 0.0 - 1.0 where 1.0 is default volume and 0.0 is muted.
    #
    # However... it would be nice if the default volume was in the middle of a volume slider and you could also linearly increase the volume.
    # +10dB would be perceived as double volume so then the input parameters to linear_to_db() would have to be between 0.0 and 3.16.
    # Add some math to convert things so 0.5 becomes default. 0.0 becomes -100% and 1.0 becomes +100%

    if new_volume == 0.5:
        new_volume = 1.0
    elif new_volume > 0.5:
        var percent = (new_volume/0.5) - 1.0
        new_volume = 1.0 + ((db_to_linear(10.0) - 1.0) * percent)
    elif new_volume < 0.5:
        new_volume *= 2.0

    volume_db = linear_to_db(new_volume)


func get_volume():
    var linear_volume = db_to_linear(volume_db)
    if linear_volume == 1.0:
        return 0.5
    elif linear_volume > 1.0:
        var percent = ((linear_volume - 1.0)) / (db_to_linear(10.0) - 1.0)
        return 0.5 + (0.5 * percent)
    elif linear_volume < 1.0:
        return linear_volume * 0.5


# TEST
#func _physics_process(delta):
#    if Input.is_action_just_pressed("1"):
#        play_music_track(MUSIC_TRACK.example_music_track_1)
#    elif Input.is_action_just_pressed("2"):
#        play_music_track(MUSIC_TRACK.example_music_track_2)

#    elif Input.is_action_just_pressed("3"):
#        set_volume(0.5) # 0.0-1.0
#    elif Input.is_action_just_pressed("5"):
#        print(get_volume())

#    elif Input.is_action_just_pressed("6"):
#        fade_volume(0.0, 1.0)





