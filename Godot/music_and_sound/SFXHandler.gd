extends Node2D

# Add SFXhandler.tscn as a singleton in the project settings and call on it from anywhere like this:
# SFXHandler.play_sound_effect(SFXHandler.SOUND_EFFECT.example_sound_effect_1)

# For music files, .wav is best for short sound effects and .ogg is best for longer music. See here:
# # https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_audio_samples.html

# if the sound effect should start at for example 0.2 seconds instead of 0.0 seconds this is an easy way to clip sound files:
# https://audiotrimmer.com/

# Why multiple AudioStreamPlayers instead of one?
# To be able to play multiple/overlapping sound effects at once.
# Otherwise if the stream/type of sound effect is changed, the currently playing one will be stopped or
# if the pitch is changed it also changes on what's currently playing etc.
# If more AudioStreamPlayers are needed, just add another.
# Only changing "max polyphony" on the AudioStreamPlayer does not solve the usecases above
# but set it to 10 on each anyway so it can still overlap the same sound effect.


@onready var audio_stream_players = [$AudioStreamPlayer, $AudioStreamPlayer2, $AudioStreamPlayer3, $AudioStreamPlayer4, $AudioStreamPlayer5]
var current_audio_stream_player_index = 0

enum SOUND_EFFECT {
    example_sound_effect_1,
    example_sound_effect_2,
    type1,
    type2,
    type3,
    type4,
    type5,
    type6,
    typewriter_bell,
    curious,
    eureka,
}

var sound_effects = {
    SOUND_EFFECT.example_sound_effect_1: preload("res://music_and_sound/sound_effects/example_sound_effect_1.mp3"),
    SOUND_EFFECT.example_sound_effect_2: preload("res://music_and_sound/sound_effects/example_sound_effect_2.mp3"),
    SOUND_EFFECT.type1: preload("res://music_and_sound/sound_effects/typewriter_sounds/type1.wav"),
    SOUND_EFFECT.type2: preload("res://music_and_sound/sound_effects/typewriter_sounds/type2.wav"),
    SOUND_EFFECT.type3: preload("res://music_and_sound/sound_effects/typewriter_sounds/type3.wav"),
    SOUND_EFFECT.type4: preload("res://music_and_sound/sound_effects/typewriter_sounds/type4.wav"),
    SOUND_EFFECT.type5: preload("res://music_and_sound/sound_effects/typewriter_sounds/type5.wav"),
    SOUND_EFFECT.type6: preload("res://music_and_sound/sound_effects/typewriter_sounds/type6.wav"),
    SOUND_EFFECT.typewriter_bell: preload("res://music_and_sound/sound_effects/typewriter_sounds/bell.wav"),
    SOUND_EFFECT.curious: preload("res://music_and_sound/sound_effects/Curious.mp3"),
    SOUND_EFFECT.eureka: preload("res://music_and_sound/sound_effects/Eureka.mp3"),
}

func play_sound_effect(sound_effect, pitch = 1.0, from = 0.0):
    var current_stream = audio_stream_players[current_audio_stream_player_index].stream
    var new_stream = sound_effects[sound_effect]
    var current_pitch = audio_stream_players[current_audio_stream_player_index].pitch_scale
    var new_pitch = pitch
    if current_stream != new_stream or current_pitch != new_pitch:
        set_new_active_audio_stream_player(new_stream, new_pitch)

    audio_stream_players[current_audio_stream_player_index].play(from)


func set_new_active_audio_stream_player(stream, pitch):
    if current_audio_stream_player_index == audio_stream_players.size() - 1:
        current_audio_stream_player_index = 0
    else:
        current_audio_stream_player_index += 1

    audio_stream_players[current_audio_stream_player_index].stream = stream
    audio_stream_players[current_audio_stream_player_index].pitch_scale = pitch


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

    for audio_stream_player in audio_stream_players:
        audio_stream_player.volume_db = linear_to_db(new_volume)


func get_volume():
    var linear_volume = db_to_linear(audio_stream_players[0].volume_db)
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
#        var random_sound_effect = [SOUND_EFFECT.example_sound_effect_1, SOUND_EFFECT.example_sound_effect_2][randi_range(0, 1)]
#        var random_pitch = randf_range(0.5, 1.5)
#        play_sound_effect(random_sound_effect, random_pitch)
