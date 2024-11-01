class_name PushZone
extends CameraControllerBase

@export var push_ratio: float = 0.5  # Ratio for speedup when near the pushbox border
@export var pushbox_top_left: Vector2  # Top left corner of the push zone border box
@export var pushbox_bottom_right: Vector2  # Bottom right corner of the push zone border box
@export var speedup_zone_top_left: Vector2  # Top left corner of the inner speedup zone
@export var speedup_zone_bottom_right: Vector2  # Bottom right corner of the inner speedup zone

var last_input_time: float = 0.0
var last_direction: Vector2 = Vector2.ZERO  # Store the direction vector of the vessel

func _ready() -> void:
	super()
	position = target.position + Vector3(0, dist_above_target, 0)
	rotation_degrees = Vector3(-90, 0, 0)
	draw_logic()  # Draw the push zone border if needed

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

	# Determine if target is inside the speedup zone, the pushbox, or outside
	var in_speedup_zone = is_point_in_rect(tpos, speedup_zone_top_left, speedup_zone_bottom_right)
	var in_pushbox = is_point_in_rect(tpos, pushbox_top_left, pushbox_bottom_right)

	if in_speedup_zone:
		# If the target is within the speedup zone, the camera should not move
		return
	elif in_pushbox:
		# If the target is in the pushbox but not in the speedup zone, calculate the camera movement
		if is_on_pushbox_border(tpos):
			# If the target is on the pushbox boundary, move with push_ratio in one direction
			var movement = Vector3(
				tpos.x - cpos.x if is_on_vertical_border(tpos) else (tpos.x - cpos.x) * push_ratio,
				0,
				tpos.z - cpos.z if is_on_horizontal_border(tpos) else (tpos.z - cpos.z) * push_ratio
			)
			global_position += movement * delta
		else:
			# Between the speed zone and the boundary, use push_ratio speed
			var movement = (tpos - cpos) * push_ratio
			global_position += movement * delta
	else:
		# If the target is outside the pushbox, move the camera at full speed toward the target
		var movement = tpos - cpos
		global_position += movement * delta

	# Update the vertical position of the camera to stay above the target
	global_position.y = tpos.y + dist_above_target

	super(delta)

func draw_logic() -> void:
	if !draw_camera_logic:
		return

	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)

	# Draw the pushbox (outer boundary)
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_bottom_right.x, 0, pushbox_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(pushbox_top_left.x, 0, pushbox_top_left.y))

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	mesh_instance.material_override = material
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY

# Helper function to determine if a point is within a rectangular boundary
func is_point_in_rect(point: Vector3, top_left: Vector2, bottom_right: Vector2) -> bool:
	return (point.x >= top_left.x and point.x <= bottom_right.x and
			point.z >= top_left.y and point.z <= bottom_right.y)

# Helper function to determine if the target is on the pushbox boundary
func is_on_pushbox_border(point: Vector3) -> bool:
	return (point.x == pushbox_top_left.x or point.x == pushbox_bottom_right.x or
			point.z == pushbox_top_left.y or point.z == pushbox_bottom_right.y)

# Helper function to determine if the target is on a vertical pushbox border
func is_on_vertical_border(point: Vector3) -> bool:
	return (point.x == pushbox_top_left.x or point.x == pushbox_bottom_right.x)

# Helper function to determine if the target is on a horizontal pushbox border
func is_on_horizontal_border(point: Vector3) -> bool:
	return (point.z == pushbox_top_left.y or point.z == pushbox_bottom_right.y)
