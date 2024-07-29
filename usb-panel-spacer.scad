/* [Export] */


/* [Hidden] */
$fn = 150;

wall_thickness = 2.0;
shaft_height = 13.0;

spacer_inner_diameter = 15.5;
spacer_outer_diameter = spacer_inner_diameter + 4.0;

spacer_height = shaft_height - wall_thickness - 4.0;

difference()
{
	cylinder(spacer_height, d=spacer_outer_diameter, center=false);

	translate([0, 0, -1])
	cylinder(spacer_height + 2, d=spacer_inner_diameter, center=false);	
}