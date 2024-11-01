class_name LockLerp
extends CameraControllerBase

@export var lead_speed: float = 7.0  # Speed at which the camera moves toward the direction of input
@export var catchup_delay_duration: float = 0.5  # Delay before camera starts catching up to the target
@export var catchup_speed: float = 2.0  # Speed at which the camera catches up when the player stops
@export var leash_distance: float = 5.0  # Maximum allowed distance between the vessel and the camera center

var last_input_time: float = 0.0

func _ready() -> void:
	super()
	# Set the initial position above the target
	position = target.position + Vector3(0, dist_above_target, 0)
	# Set the rotation to look directly down
	rotation_degrees = Vector3(-90, 0, 0)

func _process(delta: float) -> void:
	#if !current:
	#    return

	# Draw the camera logic if enabled
	if draw_camera_logic:
		draw_logic()

	var tpos = target.global_position
	var cpos = global_position

	# Update last input time if there is player input
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		last_input_time = Time.get_ticks_msec() / 1000.0

	# Lead the camera towards the target position based on player input
	if tpos.distance_to(cpos) > leash_distance:
		global_position.x = lerp(global_position.x, tpos.x, lead_speed * delta)
		global_position.z = lerp(global_position.z, tpos.z, lead_speed * delta)

	# If the player stops, after the delay, catch up to the target at catchup_speed
	if (Time.get_ticks_msec() / 1000.0) - last_input_time > catchup_delay_duration:
		global_position.x = lerp(global_position.x, tpos.x, catchup_speed * delta)
		global_position.z = lerp(global_position.z, tpos.z, catchup_speed * delta)

	# Keep the crosshair stationary in the center of the screen
	global_position.y = tpos.y + dist_above_target

	# Update the vessel to move towards the current center of the camera
	target.global_position.x = lerp(target.global_position.x, global_position.x, lead_speed * delta)
	target.global_position.z = lerp(target.global_position.z, global_position.z, lead_speed * delta)

	super(delta)

func draw_logic() -> void:
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)

	# Draw horizontal line (make it larger)
	immediate_mesh.surface_add_vertex(Vector3(-2.5, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(2.5, 0, 0))

	# Draw vertical line (make it larger)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -2.5))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 2.5))

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	mesh_instance.material_override = material
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
