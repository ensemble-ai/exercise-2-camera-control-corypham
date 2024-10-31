class_name FrameBoundAutoScrollCamera
extends CameraControllerBase

@export var top_left: Vector2  # Top left corner of the frame border box
@export var bottom_right: Vector2  # Bottom right corner of the frame border box
@export var autoscroll_speed: Vector3 = Vector3(1.0, 0.0, 1.0)  # Reduced scroll speed for smoother experience

func _ready() -> void:
	super()
	position = target.position  # Start with the camera centered on the target

func _process(delta: float) -> void:
	if !current:
		return
	
	# Autoscroll logic
	global_position.x += autoscroll_speed.x * delta
	global_position.z += autoscroll_speed.z * delta

	# Move the target along with the camera scroll speed
	target.global_position.x += autoscroll_speed.x * delta
	target.global_position.z += autoscroll_speed.z * delta

	var tpos = target.global_position
	var cpos = global_position

	# Ensure the target stays within the bounding box and push forward if needed
	# Allow the player to move within the frame, but push if they reach the left boundary

	# Left boundary check
	if tpos.x < cpos.x + top_left.x:
		target.global_position.x = lerp(target.global_position.x, cpos.x + top_left.x, 0.1)

	# Right boundary check - allow player to move freely until hitting the right boundary
	if tpos.x > cpos.x + bottom_right.x:
		target.global_position.x = lerp(target.global_position.x, cpos.x + bottom_right.x, 0.1)

	# Top boundary check - allow player to move freely within the frame
	if tpos.z < cpos.z + top_left.y:
		target.global_position.z = lerp(target.global_position.z, cpos.z + top_left.y, 0.1)

	# Bottom boundary check - allow player to move freely within the frame
	if tpos.z > cpos.z + bottom_right.y:
		target.global_position.z = lerp(target.global_position.z, cpos.z + bottom_right.y, 0.1)

	# Draw the frame box if enabled
	if draw_camera_logic:
		draw_logic()

	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	# Set material properties for the frame lines
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	# Begin drawing the frame border box
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	var top_left_vec = Vector3(top_left.x, 0, top_left.y)
	var top_right_vec = Vector3(bottom_right.x, 0, top_left.y)
	var bottom_left_vec = Vector3(top_left.x, 0, bottom_right.y)
	var bottom_right_vec = Vector3(bottom_right.x, 0, bottom_right.y)

	# Draw top border
	immediate_mesh.surface_add_vertex(top_left_vec)
	immediate_mesh.surface_add_vertex(top_right_vec)

	# Draw right border
	immediate_mesh.surface_add_vertex(top_right_vec)
	immediate_mesh.surface_add_vertex(bottom_right_vec)

	# Draw bottom border
	immediate_mesh.surface_add_vertex(bottom_right_vec)
	immediate_mesh.surface_add_vertex(bottom_left_vec)

	# Draw left border
	immediate_mesh.surface_add_vertex(bottom_left_vec)
	immediate_mesh.surface_add_vertex(top_left_vec)

	immediate_mesh.surface_end()

	# Add the frame mesh to the camera
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
