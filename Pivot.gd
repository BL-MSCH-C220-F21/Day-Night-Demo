extends Spatial

export var hour_seconds = 1.0
export var current_time = false

var color_interval = 1.0
var energy_interval = 1.0
var color_time = 0
var energy_time = 0

var colors = [
	Color8(77,171,247)
	,Color8(255,243,191)
	,Color8(247,103,7)
	,Color8(112,72,232)
	,Color8(52,58,64)
]
var energies = [
	1.0
	,2.0
	,1.0
	,0.8
	,0.8
]


func _ready():
	if current_time:
		current()
	else:
		color_interval = 24.0 / colors.size()
		$Sun.light_color = colors[color_time]
		energy_interval = 24.0 / energies.size()
		$Sun.light_energy = energies[energy_time]
		$Tween_Color.interpolate_property($Sun, "light_color", colors[color_time], colors[wrapi(color_time+1,0,colors.size())], hour_seconds*color_interval, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween_Color.start()
		$Tween_Energy.interpolate_property($Sun, "light_energy", energies[energy_time], energies[wrapi(energy_time+1,0,energies.size())], hour_seconds*color_interval, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween_Energy.start()
		$Tween_Rotation.interpolate_property(self, "rotation_degrees:x", 0, 360, hour_seconds*24, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween_Rotation.start()

func _on_Tween_Color_tween_all_completed():
	color_time = wrapi(color_time + 1, 0, colors.size())
	$Tween_Color.interpolate_property($Sun, "light_color", colors[color_time], colors[wrapi(color_time+1,0,colors.size())], hour_seconds*color_interval, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween_Color.start()


func _on_Tween_Energy_tween_all_completed():
	energy_time = wrapi(energy_time + 1, 0, colors.size())
	$Tween_Energy.interpolate_property($Sun, "light_energy", energies[energy_time], energies[wrapi(energy_time+1,0,energies.size())], hour_seconds*color_interval, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween_Energy.start()


func _on_Tween_Rotation_tween_all_completed():
	$Tween_Rotation.interpolate_property(self, "rotation_degrees:x", 0, 360, hour_seconds*24, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween_Rotation.start()

	

func current():
	var t = OS.get_time()
	var h = wrapf((float(t.hour) + float(t.minute)/60.0) - 6.0, 0.0, 24.0)
	rotation_degrees.x = h/24.0 * 360
	var c = h/24.1 * colors.size()
	var color = colors[floor(c)].linear_interpolate(colors[ceil(c)],c)
	$Sun.light_color = color
	$Timer.start()

func _on_Timer_timeout():
	current()
