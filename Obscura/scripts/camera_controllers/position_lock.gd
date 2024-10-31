class_name PositionLockCamera
extends CameraControllerBase

func _ready() -> void:
	super()
	# Set the initial position above the target
	position = target.position + Vector3(0, dist_above_target, 0)
	# Set the rotation to look directly down
	rotation_degrees = Vector3(-90, 0, 0)

func _process(delta: float) -> void:
	#if !current:
		#return
	if draw_camera_logic:
		draw_logic()

	var tpos = target.global_position

	# Update the position to be above the target
	global_position = tpos + Vector3(0, dist_above_target, 0)

	super(delta)

func draw_logic() -> void:
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)

	#Draw horizontal line (make it larger)
	immediate_mesh.surface_add_vertex(Vector3(-5, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(5, 0, 0))

	#Draw vertical line (make it larger)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -5))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 5))

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	mesh_instance.material_override = material
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

#	Mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
