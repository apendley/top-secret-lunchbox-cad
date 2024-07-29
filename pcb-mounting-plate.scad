/* [Export] */

grid_size=0; //[0:3x3 inches,1:6x3 inches,2:6x6 inches]

/* [Hidden] */

$fn = 50;

grid_width = grid_size == 0 ? 76.2 : 152.4;
grid_length = grid_size == 2 ? 152.4 : 76.2;
grid_thickness = 2.0;

heat_sink_diameter = 4.;
heat_sink_height = 5.6;

screw_mount_diameter = 9.5;
screw_mount_height = heat_sink_height;

screw_hole_edge_offset = 7.5;
screw_hole_cylinder_height = screw_mount_height + grid_thickness + 0;


module panel() {
	translate([-grid_width/2, -grid_length/2, 0]) {
		cube([grid_width, grid_length, grid_thickness]);
	}
}

module screw_hole() {
	translate([0, 0, grid_thickness]) {
		color("red")
		cylinder(screw_hole_cylinder_height, d=heat_sink_diameter, center=false);
	}
}

module screw_mount() {
	translate([0, 0, grid_thickness]) {
		color("blue")
		cylinder(screw_mount_height, d=screw_mount_diameter, center=false);
	}	
}

module screw_mounts() {
	translate([-grid_width/2 + screw_hole_edge_offset, grid_length/2 - screw_hole_edge_offset, 0])
		screw_mount();

	translate([grid_width/2 - screw_hole_edge_offset, grid_length/2 - screw_hole_edge_offset, 0])
		screw_mount();

	translate([grid_width/2 - screw_hole_edge_offset, -grid_length/2 + screw_hole_edge_offset, 0])
		screw_mount();

	translate([-grid_width/2 + screw_hole_edge_offset, -grid_length/2 + screw_hole_edge_offset, 0])
		screw_mount();	
}

module screw_holes() {
	translate([-grid_width/2 + screw_hole_edge_offset, grid_length/2 - screw_hole_edge_offset, 0])
		screw_hole();

	translate([grid_width/2 - screw_hole_edge_offset, grid_length/2 - screw_hole_edge_offset, 0])
		screw_hole();

	translate([grid_width/2 - screw_hole_edge_offset, -grid_length/2 + screw_hole_edge_offset, 0])
		screw_hole();

	translate([-grid_width/2 + screw_hole_edge_offset, -grid_length/2 + screw_hole_edge_offset, 0])
		screw_hole();		
}



difference()
{
	panel();
	screw_holes();
}

difference() 
{
	screw_mounts();
	screw_holes();
}

