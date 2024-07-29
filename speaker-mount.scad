$fn = 100;

panel_width = 50;
panel_length = 50;
panel_thickness = 2.0;

tolerance = 0.4;

speaker_diameter = 20;
speaker_circle_distance = 4.8;
speaker_thickness = 2.4;
speaker_mount_circle_distance = speaker_circle_distance;
speaker_mount_wall_thickness = 1.0;

tab_width = 6;
tab_length = 6;
tab_hole_diameter = 3.0;
tab_hole_offset = speaker_diameter/2 + speaker_circle_distance + tolerance + tab_length/2;
tab_hole_height = 10;
tab_height = 2;

module panel() {
    translate([-panel_width/2, -panel_length/2, 0])
    cube([panel_width, panel_length, panel_thickness]);
}

module speaker() {
    rotate([0, 0, 0])
    translate([0, 0, panel_thickness + 0.2])
    color("red", 1)
    import("parts/3923 Mini Oval Speaker.stl");
}

module speaker_mount_holes() {
    translate([0, tab_hole_offset, -tab_hole_height/2])
    color("blue")
    cylinder(h = tab_hole_height, d = tab_hole_diameter);

    translate([0, -tab_hole_offset, -tab_hole_height/2])
    color("blue")
    cylinder(h = tab_hole_height, d = tab_hole_diameter);        
}

module speaker_mount() {
    difference()
    {
        color("purple")
        hull() {
            translate([0, speaker_mount_circle_distance, panel_thickness])
            cylinder(h = speaker_thickness + panel_thickness + speaker_mount_wall_thickness, d = speaker_diameter + (speaker_mount_wall_thickness*2) + tolerance);

            translate([0, -speaker_mount_circle_distance, panel_thickness])
            cylinder(h = speaker_thickness + panel_thickness + speaker_mount_wall_thickness, d = speaker_diameter + (speaker_mount_wall_thickness*2) + tolerance);
        }


    color("purple")
        hull() {
            translate([0, speaker_mount_circle_distance, panel_thickness - 0.01])
            cylinder(h = speaker_thickness + panel_thickness, d = speaker_diameter + tolerance);

            translate([0, -speaker_mount_circle_distance, panel_thickness - 0.01])
            cylinder(h = speaker_thickness + panel_thickness, d = speaker_diameter + tolerance);
        }

        color("orange")
        translate([0, 0, panel_thickness + 0.01])
        cylinder(h = speaker_thickness + panel_thickness + speaker_mount_wall_thickness, d = 16);

        {
            wire_cutout_width = 10;
            wire_cutout_length = 20;

            translate([-wire_cutout_width/2, 0, 4])
            color("orange")
            cube([wire_cutout_width, wire_cutout_length, 6]);
        }
    }

    difference()
    {
        translate([-tab_width/2, speaker_diameter/2 + speaker_circle_distance + tolerance, panel_thickness])
        color("green")
        cube([tab_width, tab_length, tab_height]);

        speaker_mount_holes();
    }

    difference()
    {
        translate([-tab_width/2, -speaker_diameter/2 - speaker_circle_distance - tab_length - tolerance, panel_thickness])
        color("green")
        cube([tab_width, tab_length, tab_height]);

        speaker_mount_holes();
    }
}

// difference()
// {
//     panel();
//     speaker_mount_holes();
// }


speaker_mount();
// speaker();

// speaker_mount_holes();