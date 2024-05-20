extends Node3D

@export var Player_scene_host: PackedScene
@export var Player_scene_client: PackedScene

func _on_host_pressed():
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(135, 5)
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(_add_player_host)
	_add_player_host()


func _on_join_pressed():
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client("127.0.0.1", 135)
	multiplayer.multiplayer_peer = client_peer
	multiplayer.peer_connected.connect(_add_player_client)
	_add_player_client()
	$CanvasLayer.hide()


func _add_player_host(id = 1):
	var player = Player_scene_host.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func _add_player_client(id = 1):
	var player = Player_scene_client.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
