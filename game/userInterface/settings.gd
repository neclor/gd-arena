extends Control

@onready var master_slider = %MasterHSlider
@onready var music_slider = %MusicHSlider
@onready var sfx_slider = %SfxHSlider
@onready var slider_stream_player = %SliderAudioStreamPlayer

var on_audio_slider = func(value: float, bus: int):
	AudioServer.set_bus_volume_db(bus, value)
	slider_stream_player.bus = AudioServer.get_bus_name(bus)
	slider_stream_player.play()

func _ready():
	master_slider.value_changed.connect(on_audio_slider.bind(0))
	music_slider.value_changed.connect(on_audio_slider.bind(2))
	sfx_slider.value_changed.connect(on_audio_slider.bind(1))
	master_slider.value_changed.emit()
	music_slider.value_changed.emit()
	sfx_slider.value_changed.emit()

