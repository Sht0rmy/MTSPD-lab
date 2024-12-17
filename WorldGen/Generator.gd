extends Node2D
class_name Generator

@export var noise: FastNoiseLite
var grid: Grid

# Constructor Injection: The Grid is injected through the constructor
func _init(grid: Grid):
    self.grid = grid

# Generate the main progression for the region, now separated into individual methods.
func generate_progression(source: Region, start: Vector2, settings: GenerationSettings):
    var size: int = randi_range(source.size_range.x, source.size_range.y)
    
    place_progression_rooms(source, start, settings, size)
    place_optional_rooms(source, start, settings, size)
    place_environment_tiles(source, start, settings, size)
    
    grid.display()

# Place progression rooms
func place_progression_rooms(source: Region, start: Vector2, settings: GenerationSettings, size: int):
    var progression_length = settings.progression_rooms.size()
    for i in range(progression_length):
        var x = start.x + randi_range(-settings.progression_width, settings.progression_width)
        var y = calculate_progression_y(source, i, settings, size)
        grid.add_tile(settings.progression_rooms[i], x, y)

# Place optional rooms with a chance based on their weight
func place_optional_rooms(source: Region, start: Vector2, settings: GenerationSettings, size: int):
    for i in range(settings.optional_rooms.size()):
        if randf() < float(settings.optional_rooms[i].weight) / settings.optional_rooms.size():
            var x = start.x + randi_range(-settings.progression_width, settings.progression_width)
            var y = start.y + settings.progression_direction * randi_range(settings.progression_margin, size - settings.progression_margin)
            grid.add_tile(settings.optional_rooms[i], x, y)

# Place environment tiles in empty spaces
func place_environment_tiles(source: Region, start: Vector2, settings: GenerationSettings, size: int):
    for x in range(-size, size):
        for y in range(-size, size):
            x += start.x
            y += start.y
            grid.add_tile(settings.environment_tiles[randi() % settings.environment_tiles.size()], x, y)

# Calculate the Y position for progression rooms
func calculate_progression_y(source: Region, i: int, settings: GenerationSettings, size: int) -> int:
    var y_min: int = settings.progression_direction * (i * size / settings.progression_rooms.size() + settings.progression_margin)
    var y_max: int = settings.progression_direction * ((i + 1) * size / settings.progression_rooms.size() - settings.progression_margin)
    return randi_range(y_min, y_max)
