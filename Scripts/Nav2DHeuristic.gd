# Nav2DHeuristic.gd
# heuristic Nav2D optimizer
tool
extends Navigation2D

export(int)               var agent_radius
export(NavigationPolygon) var current_navigation_polygon

enum SMOOTH {ROUND = Geometry.JOIN_ROUND, MITER = Geometry.JOIN_MITER, SQUARE = Geometry.JOIN_SQUARE}
export(SMOOTH) var smooth_type = SMOOTH.ROUND

export(bool) var do = false setget do
func do(b):
	print("Called")
	offset()
	
export(bool) var reset = false setget reset
func reset(b):
	$NavigationPolygonInstance.navpoly = current_navigation_polygon

func offset():
	var nav_polygon = NavigationPolygon.new()
	nav_polygon.resource_name = "Optimized_NP"
	
	for i in range(current_navigation_polygon.get_outline_count()):
		var current_outline = current_navigation_polygon.get_outline(i)
		var scale = agent_radius
		
		if(not Geometry.is_polygon_clockwise(current_outline)):
			scale = -agent_radius
		
		var ret  = Geometry.offset_polygon_2d(current_outline,scale,smooth_type)
		var base = ret.pop_front()
		
		for item in ret:
			base = Geometry.merge_polygons_2d(base, item)
		
		nav_polygon.add_outline(base)
	nav_polygon.make_polygons_from_outlines()
	$NavigationPolygonInstance.navpoly = nav_polygon
