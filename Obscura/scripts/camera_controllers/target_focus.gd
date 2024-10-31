class_name PositionLockLerpSmoothingCamera
extends CameraControllerBase

@export var lead_speed: float = 7.0  # Speed at which the camera moves toward the direction of input
@export var catchup_delay_duration: float = 0.5  # Delay before camera starts catching up to the target
@export var catchup_speed: float = 2.0  # Speed at which the camera catches up when the player stops
@export var leash_distance: float = 5.0  # Maximum allowed distance between the vessel and the camera center

var last_input_time: float = 0.0

func _ready() -> void:
	super()
	position = target.position  # Start with the camera centered on the target

func _process(delta: float) -> void:
	if !current:
		return
	var tpos = target.global_position
	var cpos = global_position

	# Update last input time if there is player input
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
		last_input_time = Time.get_ticks_msec() / 1000.0

	# Calculate the distance between the camera and the target
	var distance_to_target = tpos.distance_to(Vector3(cpos.x, tpos.y, cpos.z))

	# If the target is moving, lead the camera at lead_speed
	if distance_to_target > leash_distance:
		global_position.x = lerp(global_position.x, tpos.x, lead_speed * delta)
		global_position.z = lerp(global_position.z, tpos.z, lead_speed * delta)
	elif (Time.get_ticks_msec() / 1000.0) - last_input_time > catchup_delay_duration:
		# If the player stops, after the delay, catch up to the target at catchup_speed
		global_position.x = lerp(global_position.x, tpos.x, catchup_speed * delta)
		global_position.z = lerp(global_position.z, tpos.z, catchup_speed * delta)

	# Draw the crosshair if enabled
	if draw_camera_logic:
		draw_crosshair()

	super(delta)

func draw_crosshair() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	# Set material properties for the crosshair
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	# Begin drawing the crosshair
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Set crosshair boundaries for a 5 by 5 unit cross
	var left: float = -2.5
	var right: float = 2.5
	var top: float = -2.5
	var bottom: float = 2.5

	# Draw horizontal line
	immediate_mesh.surface_add_vertex(Vector3(left, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, 0))

	# Draw vertical line
	immediate_mesh.surface_add_vertex(Vector3(0, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, bottom))

	immediate_mesh.surface_end()

	# Add the crosshair mesh to the camera
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
