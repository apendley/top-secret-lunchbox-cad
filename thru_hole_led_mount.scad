/* [Options] */
draw_panel_extrusions = false;

/* [Hidden] */
$fn=100;

wall_thickness = 2.0;
extrusion_length = 10;

num_slots = 5;
slot_length = 5.4;
slot_width = 1.4;
slot_space = 15;
total_slots_length = (num_slots * slot_length) + ((num_slots - 1) * (slot_space - slot_length));

screw_hole_diameter = 2.8;

plank_width = 10;
plank_length = total_slots_length + 5;

module slots() {
	for (n = [0:num_slots - 1]) {
		x_pos = 0;
		y_pos = (n * slot_space) - (total_slots_length - slot_length)/2;
		z_pos = 0;

		translate([x_pos, y_pos, z_pos])
		// rotate([0, 0, 90])
		cube([slot_width, slot_length, 10], center=true);
	}
}

module plank() {
	translate([-plank_width/2, -plank_length/2, 0])
	cube([plank_width, plank_length, wall_thickness]);
}

module screw_holes() {
	y_offset = slot_space * 0.5;

	for (n = [3, 1, -1, -3]) {
		color("red")
		translate([0, y_offset * n, -(extrusion_length - wall_thickness)/2])
		cylinder(extrusion_length, d=screw_hole_diameter, center=false);
		
	}
}

if (draw_panel_extrusions) {
	screw_holes();
} else {
	difference()
	{
		plank();
		slots();
		screw_holes();
	}
}