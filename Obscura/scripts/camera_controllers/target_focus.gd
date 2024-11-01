class_name TargetFocus
extends CameraControllerBase

@export var lead_speed: float = 10.0  # Speed at which the camera moves toward the direction of input, faster than vessel speed
@export var catchup_delay_duration: float = 0.5  # Time delay before the camera starts catching up to the target
@export var catchup_speed: float = 2.0  # Speed at which the camera catches up when the player stops
@export var leash_distance: float = 5.0  # Maximum allowed distance between the vessel and the center of the camera

var last_input_time: float = 0.0
var last_direction: Vector2 = Vector2.ZERO  # Store the direction vector of the vessel
var crosshair_offset: Vector2 = Vector2.ZERO  # Offset of the crosshair from the center
var crosshair_instance: MeshInstance3D  # Reference to the crosshair mesh instance

func _ready() -> void:
	super()
	position = target.position + Vector3(0, dist_above_target, 0)
	rotation_degrees = Vector3(-90, 0, 0)

func _process(delta: float) -> void:

	#if !current:
	#    return
	
	# Draw the camera logic if enabled
	if draw_camera_logic:
		draw_logic()

	var tpos = target.global_position
	var cpos = global_position

	# Determine player input direction
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	# Normalize the direction vector to handle multiple keys pressed simultaneously
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		last_input_time = Time.get_ticks_msec() / 1000.0
		last_direction = direction

	# Update crosshair offset based on player input
	crosshair_offset += direction * lead_speed * delta

	# Keep the crosshair within a 10x10 box
	crosshair_offset.x = clamp(crosshair_offset.x, -1.0, 1.)
	crosshair_offset.y = clamp(crosshair_offset.y, -1.0, 1.0)

	# Move the camera based on crosshair offset
	global_position.x = tpos.x + crosshair_offset.x
	global_position.z = tpos.z + crosshair_offset.y

	# If the player stops moving, catch up to the target after the specified delay
	if (Time.get_ticks_msec() / 1000.0) - last_input_time > catchup_delay_duration:
		crosshair_offset = crosshair_offset.lerp(Vector2.ZERO, catchup_speed * delta)

	# Ensure the vessel follows the camera position
	target.global_position.x = lerp(target.global_position.x, global_position.x, catchup_speed * delta)
	target.global_position.z = lerp(target.global_position.z, global_position.z, catchup_speed * delta)

	# Keep the camera centered above the vessel
	global_position.y = tpos.y + dist_above_target

	super(delta)

func draw_logic() -> void:
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)

	# Draw a larger cross (5 by 5 units)
	immediate_mesh.surface_add_vertex(Vector3(-2.5, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(2.5, 0, 0))
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
