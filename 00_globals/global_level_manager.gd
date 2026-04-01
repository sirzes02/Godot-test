extends Node

var current_tilemap_bounds: Array[Vector2]

signal tileMapBoundsChanged(bounds: Array[Vector2])

func changeTileMapBounds(bounds: Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	tileMapBoundsChanged.emit(bounds)
