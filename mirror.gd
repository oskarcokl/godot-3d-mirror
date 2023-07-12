extends Node3D

@onready var player = get_tree().get_root().get_node("Main/Player")
@onready var sub_viewport = $MirrorMesh/SubViewport
@onready var mirror_camera = $MirrorMesh/SubViewport/Camera3D
@onready var mirror_mesh: MeshInstance3D = $MirrorMesh

func _ready():
    sub_viewport.size = Vector2(2000, 1000)


func _process(_delta):
    var vertices = mirror_mesh.mesh.get_faces()

    var mdt = MeshDataTool.new()
    var arr_mesh = ArrayMesh.new()
    arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mirror_mesh.mesh.get_mesh_arrays())
    mdt.create_from_surface(arr_mesh, 0)

    var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
    var standard_material = StandardMaterial3D.new()
    standard_material.vertex_color_use_as_albedo = true

    immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, standard_material)
    immediate_mesh.surface_set_color(Color.RED)

    for i in range(mdt.get_face_count()):
        # offset by 3
        var face_index = i * 3

        var a: Vector3 = vertices[face_index]
        var b: Vector3 = vertices[face_index + 1]
        var c: Vector3 = vertices[face_index + 2]

        var center_of_face = (a + b + c) / 3.0

        print(center_of_face)
        immediate_mesh.surface_add_vertex(center_of_face)
        immediate_mesh.surface_add_vertex((mdt.get_face_normal(i))+ center_of_face)

    immediate_mesh.surface_end()
    var debug_mesh: MeshInstance3D = MeshInstance3D.new()
    debug_mesh.mesh = immediate_mesh
    mirror_mesh.add_child(debug_mesh)


func update_cam(player_cam_transform):
    print(player.position.distance_to(get_parent().get_parent().position))
    global_transform = player_cam_transform
    global_position.x += 10
