
/* [Options] */
draw_panel_extrusions = false;

/* [Hidden] */
$fn=100;

interior_width = 29.0;
interior_length = 86.0;
interior_height = 15.0;

wall_thickness = 2.0;

exterior_width = interior_width + 2 * wall_thickness;
exterior_length = interior_length + 2 * wall_thickness;
exterior_height = interior_height + 2 * wall_thickness;


tab_length = 8;

screw_hole_diameter = 3.2;
screw_hole_edge_offset = 4.0;

module main_box() {
	difference() {
		cube([exterior_width, exterior_length, exterior_height]);

		translate([wall_thickness, wall_thickness, -0.01])
		cube([interior_width, interior_length, interior_height]);
	}

	// top tab
	translate([0, -tab_length, 0])
	{
		cube([exterior_width, tab_length, wall_thickness]);
	}

	// bottom tab
	translate([0, interior_length + wall_thickness*2, 0])
	{
		cube([exterior_width, tab_length, wall_thickness]);	
	}
}

module screw_holes(extruded=false) {
	// top left
	translate([screw_hole_diameter/2 + screw_hole_edge_offset, -tab_length/2, 0])
	color("red")
	cylinder(h=10, d=screw_hole_diameter, center=true);

	// top right
	translate([exterior_width - screw_hole_diameter/2 - screw_hole_edge_offset, -tab_length/2, 0])
	color("red")
	cylinder(h=10, d=screw_hole_diameter, center=true);	

	// bottom left
	translate([screw_hole_diameter/2 + screw_hole_edge_offset, exterior_length + tab_length/2, 0])
	color("red")
	cylinder(h=10, d=screw_hole_diameter, center=true);

	// bottom right
	translate([exterior_width - screw_hole_diameter/2 - screw_hole_edge_offset, exterior_length + tab_length/2, 0])
	color("red")
	cylinder(h=10, d=screw_hole_diameter, center=true);		
}

translate([-exterior_width/2, -exterior_length/2, 0])
{
	if (draw_panel_extrusions) {
		screw_holes();		
	} else {
		difference() 
		{
			main_box();
			screw_holes();
		}		
	}
}