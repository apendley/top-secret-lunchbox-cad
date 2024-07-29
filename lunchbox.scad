/* [STL export] */

// What would you like to see?
enclosure_parts = 1;//[1:Box + Cover, 2:Box only, 3: Cover only]

/* [Debug] */
draw_speaker_mount=false;
draw_storage_box=false;
draw_led_mount=false;
panelize_box=false;

/* [Hidden] */

// Size of your printer's nozzle in mm
nozzle_size = 0.2; //[0:0.05:2]

// Number of walls the print should have
number_of_walls = 10;

// Tolerance (use 0.2 for FDM)
tolerance = 0.2; // [0.1:0.1:0.4]

// Interior dimension X in mm
interior_width = 156.0; //[0:0.05:200.0]

// Interior dimension Y in mm
interior_length = 110.0; //[0:0.05:200.0]

// Interior dimension Z in mm
interior_height = panelize_box ? 2.0 : 50.0;

// interior corner radius in mm
radius = 5.0;

/* [Hidden] */

// Number of walls the hook should have
hook_walls = 6;

// What fraction of the flat X side should the hook take up? (0 for no hook)
x_hook_fraction = 0.8; // [0:0.1:1.0]

// What fraction of the left/right hooks should have a slot behind them? (0 for no slot)
x_slot_fraction = 0.8; // [0:0.1:2]

// What fraction of the flat Y side should the hook take up? (0 for no hook)
y_hook_fraction = 0.8; // [0:0.1:1.0]

// What fraction of the top/bottom hooks should have a slot behind them? (0 for no slot)
y_slot_fraction = 0.8; // [0:0.1:2]

/* [Hidden] */
$fn=100;

wall_thickness = nozzle_size * number_of_walls;

// Outer dimensions
exterior_width = interior_width + 2 * wall_thickness;
exterior_length = interior_length + 2 * wall_thickness;
exterior_height = interior_height + 2 * wall_thickness;

echo("EXTERIOR WIDTH:", exterior_width);
echo("EXTERIOR LENGTH:", exterior_length);
echo("EXTERIOR HEIGHT:", exterior_height);

hook_thickness = hook_walls * nozzle_size;

y_hook_length = (exterior_length - 2 * radius) * y_hook_fraction;
x_hook_length = (exterior_width - 2 * radius) * x_hook_fraction;

// Seven seg
seven_seg_width = 50.6;
seven_seg_height = 19.4;
seven_seg_x =  14  - seven_seg_width/2;
seven_seg_y = -38 - seven_seg_height/2;

// OLED display
oled_x_pos = -35;
oled_y_pos = -38;

// Arcade button
arcade_button_x = oled_x_pos;
arcade_button_y = interior_length/3.5;

// Power/programming USB input
usb_panel_diameter = 15.5;
power_usb_x = (-interior_width + usb_panel_diameter)/2 + 6;
power_usb_y = -interior_length/3;

// Power switch
power_switch_diameter = 11.8;
power_switch_x = arcade_button_x;
power_switch_y = -5;

// Serial port
headphone_hole_diameter = 8.5;
serial_port_x = power_usb_x;
serial_port_y = interior_length/3;

// Thru hole leds
thru_hole_led_diameter = 5.4;
switchboard_led_mount_inner_height = 1.6;

// Speaker
speaker_x_pos = power_usb_x;
speaker_y_pos = 0;

// Switchboard port positioning
switchboard_ports_base_x = 14.0;
switchboard_ports_base_y = 16;
switchboard_ports_space_x = 15;
switchboard_ports_space_y = 15;
switchboard_led_offset = 12;

// Storage space for switchboard cables
storage_width = 29.0;
storage_length = 86.0;
storage_offset_from_edge = 4;
storage_x = interior_width/2 - storage_width - storage_offset_from_edge;
storage_y = -storage_length/2;

// 
// Modules
// 

module box_interior() {
    offset(r=radius) {
        square([interior_width-2*radius, interior_length-2*radius], center=true);
    }
}

module box_exterior() {
    offset(r=wall_thickness) {
        box_interior();
    }
}

// Only need this for the keypad, cuz I don't feel like rewriting it
module rounded_rect(x, y, l, w, diameter, z=wall_thickness) {
    minkowski() {
        translate([x + diameter / 2 , y + diameter / 2, -z])
        cube([l - diameter, w - diameter, 10]);
        cylinder(d=diameter, h=10, $fn=100);
    }
}

module seven_segment_cutout() {
    screwDiameter = 2.4;
    xScrewOffset = -3.2;
    yTopScrewOffset = 2.0;
    yBottomScrewOffset = 2.0;

    color("Green") {
        translate([seven_seg_x, seven_seg_y, -wall_thickness/2]) {
            cube([seven_seg_width, seven_seg_height, wall_thickness*2]);
        }

        // top left
        translate([seven_seg_x - xScrewOffset, seven_seg_y - yBottomScrewOffset, -wall_thickness/2]) {
            cylinder(d=screwDiameter, wall_thickness*2, $fn=50);
        }

        // top right
        translate([seven_seg_x + seven_seg_width + xScrewOffset, seven_seg_y - yBottomScrewOffset, -wall_thickness/2]) {
            cylinder(d=screwDiameter, wall_thickness*2, $fn=50);
        }

        // top left
        translate([seven_seg_x - xScrewOffset, seven_seg_y + seven_seg_height + yTopScrewOffset, -wall_thickness/2]) {
            cylinder(d=screwDiameter, wall_thickness*2, $fn=50);
        }

        // top right
        translate([seven_seg_x + seven_seg_width + xScrewOffset, seven_seg_y + seven_seg_height + yTopScrewOffset, -wall_thickness/2]) {
            cylinder(d=screwDiameter, wall_thickness*2, $fn=50);
        }
    }    
}

module arcade_button_hole() {
    height = 10;
    diameter = 30;
    tolerance = 0.2;

    notchWidth = 3.0;
    notchLength = 6.4;

    translate([0, 0, -(height - wall_thickness)/2]) rotate([0, 0, 0]) {
        color("Red") {
            cylinder(h=height, d=diameter+tolerance, center=false);
        }

        translate([-notchLength/2, diameter/2 -notchWidth/2, ]) rotate([0, 0, 0]) {
            color("Blue") {
                cube([notchLength, notchWidth, height]);
            }
        }

        translate([-notchLength/2, -diameter/2 -notchWidth/2, ]) rotate([0, 0, 0]) {
            color("Blue") {
                cube([notchLength, notchWidth, height]);
            }
        }
    }
}

module usb_panel_hole(x, y) {
    usb_hole_height = 10;

    translate([x, y, -usb_hole_height/2]) {
        color("red")
        cylinder(usb_hole_height, d=usb_panel_diameter, center=false);
    }    
}

module power_switch_hole() {
    power_switch_hole_height = 10;

    translate([power_switch_x, power_switch_y, -power_switch_hole_height/2]) {
        color("red")
        cylinder(power_switch_hole_height, d=power_switch_diameter, center=false);
    }
}

module headphone_jack_hole(x, y) {
   headphone_jack_height = 20;

    translate([x, y, -headphone_jack_height/2 + wall_thickness])
    color([0.3, 0.3, 0.3])
    cylinder(headphone_jack_height, d=headphone_hole_diameter, center=false);    
}

module serial_port_hole() {
    headphone_jack_hole(serial_port_x, serial_port_y);
}

module switchboard_led_mount() {
    color("gray")
    import("parts/thru_hole_led_mount.stl");
}

module switchboard_led_mounts() {
    translate([switchboard_ports_base_x + switchboard_ports_space_x/2 + switchboard_led_offset, switchboard_ports_base_y, wall_thickness])
    switchboard_led_mount();

    translate([switchboard_ports_base_x - switchboard_ports_space_x/2 - switchboard_led_offset, switchboard_ports_base_y, wall_thickness])
    switchboard_led_mount();    
}

module switchboard_led_mount_extrusions() {
    translate([switchboard_ports_base_x + switchboard_ports_space_x/2 + switchboard_led_offset, switchboard_ports_base_y, wall_thickness])    
    import("parts/thru_hole_led_mount_extrusions.stl");   

    translate([switchboard_ports_base_x - switchboard_ports_space_x/2 - switchboard_led_offset, switchboard_ports_base_y, wall_thickness])    
    import("parts/thru_hole_led_mount_extrusions.stl");
}


module thru_hole_led_cutout(x, y) {
    translate([x, y, -0.01]) {
        color("blue")
        cylinder(switchboard_led_mount_inner_height + wall_thickness + 1.02, d=thru_hole_led_diameter, center=false);        
    }
}

module thru_hole_led_cutouts() {
    // LEDs for switchboard ports
    for (column = [-1, 1]) {
        for (row = [0 : 4]) {
            xx = switchboard_ports_base_x + (column * switchboard_ports_space_x/2) + (column * switchboard_led_offset);
            yy = switchboard_ports_base_y - (switchboard_ports_space_y*2) + (row * switchboard_ports_space_y);
            thru_hole_led_cutout(xx, yy);
        }
    }    
}

module speaker_mount_holes() {
    translate([speaker_x_pos, speaker_y_pos, 0])
    import("parts/speaker-mount-holes.stl");

    grill_hole_diameter = 1.6;

    // "grill"
    for (n = [4, 3, 2, 1, 0, -1, -2, -3, -4]) {
        translate([speaker_x_pos, speaker_y_pos + n * 3, -0.01])
        cylinder(h=10, d=grill_hole_diameter);        
    }

    for (n = [3.5, 2.5, 1.5, 0.5, -0.5, -1.5, -2.5, -3.5]) {
        translate([speaker_x_pos - 3, speaker_y_pos + n * 3, -0.01])
        cylinder(h=10, d=grill_hole_diameter - 0.4);

        translate([speaker_x_pos + 3, speaker_y_pos + n * 3, -0.01])
        cylinder(h=10, d=grill_hole_diameter - 0.4);        
    }    


    for (n = [3, 2, 1, 0, -1, -2, -3]) {
        translate([speaker_x_pos - 6, speaker_y_pos + n * 3, -0.01])
        cylinder(h=10, d=grill_hole_diameter - 0.8);

        translate([speaker_x_pos + 6, speaker_y_pos + n * 3, -0.01])
        cylinder(h=10, d=grill_hole_diameter - 0.8);        
    }        
}

module speaker_mount() {
    translate([speaker_x_pos, speaker_y_pos, 0])
    import("parts/speaker-mount.stl");
}

module switchboard_port_holes() {
    // This one's just for debugging
    // headphone_jack_hole(switchboard_ports_base_x, switchboard_ports_base_y);

    for (column = [-1, 1]) {
        for (row = [0 : 4]) {
            xx = switchboard_ports_base_x + (column * switchboard_ports_space_x/2);
            yy = switchboard_ports_base_y - (switchboard_ports_space_y*2) + (row * switchboard_ports_space_y);
            headphone_jack_hole(xx, yy);
        }
    }
}

module oled_holes() {
    translate([oled_x_pos, oled_y_pos, 0])
    rotate([0, 0, 0])
    import("parts/oled_extrusions.stl");    
}

module storage_box(extruded=false) {
    translate([storage_x + storage_width/2, storage_y + storage_length/2, wall_thickness])
    {
        color("green")
        import("parts/storage_box.stl");    

        if (extruded) {
            // translate([storage_x, storage_y, -0.01])
            color("blue")
            import("parts/storage_box_extruded.stl");        
        }
    }
}

module storage_holes() {
    storage_cutout_depth = 10;

    translate([storage_x, storage_y, -0.01])
    color("red")
    cube([storage_width, storage_length, storage_cutout_depth]);
}

module enclosure_box() {
    difference() 
    {
        // Solid box
        linear_extrude(exterior_height - wall_thickness) {
            box_exterior();
        }
        
        // Hollow out
        translate([0, 0, wall_thickness]) linear_extrude(exterior_height) {
            box_interior();
        }

        // Left/right slots
        if (!panelize_box) {
            left_slot();
            rotate([180,180,0]) left_slot();

            // Front/back slots
            front_slot();
            rotate([180,180,0]) front_slot();
        }

        seven_segment_cutout();

        translate([arcade_button_x, arcade_button_y, 0]) {
            arcade_button_hole();
        }

        usb_panel_hole(power_usb_x, power_usb_y);
        power_switch_hole();
        serial_port_hole();
        switchboard_port_holes();
        switchboard_led_mount_extrusions();
        thru_hole_led_cutouts();
        speaker_mount_holes();
        oled_holes();
        storage_holes();
        storage_box(extruded=true);
    }

    // Left/Right hook
    if (!panelize_box) {
        left_hook();
        rotate([180,180,0]) left_hook();

        // Front/Back hook
        front_hook();
        rotate([180,180,0]) front_hook();
    }

    // debugging
    if (draw_speaker_mount) {
        speaker_mount();
    }

    if (draw_storage_box) {
        storage_box();
    }

    if (draw_led_mount) {
        switchboard_led_mounts();
    }

}

module left_hook() {
    translate([(exterior_width - 2 * wall_thickness)/2, -y_hook_length / 2, exterior_height - wall_thickness]) 
    rotate([0,90,90]) {
        base_hook(y_hook_length);
    }
}

module front_hook() {
    translate([-x_hook_length/2, -exterior_length/2 + wall_thickness, exterior_height - wall_thickness]) 
    rotate([90, 90, 90]) {
        base_hook(x_hook_length);
    }
}

module base_hook(hook_length) {
    difference(){
        linear_extrude(hook_length){
            polygon(points=[[0,0],[2*hook_thickness,0],[hook_thickness,hook_thickness]]);
        }
        translate([hook_thickness, hook_thickness, 0]) rotate([45,0,0]) cube(2*hook_thickness, center=true);
        translate([hook_thickness, hook_thickness, hook_length]) rotate([45,0,0]) cube(2*hook_thickness, center=true);        
    }
}

module left_slot() {
    x_slot_fraction = y_hook_length * x_slot_fraction;
    epsilon=2; // ensure it definitely protrudes

    translate([exterior_width / 2 + epsilon + wall_thickness/2, -x_slot_fraction / 2, exterior_height - wall_thickness/2]) 
    rotate([0,90,90]) {
        cube([wall_thickness, wall_thickness+epsilon, x_slot_fraction]);
    }
}

module front_slot() {
    y_slot_fraction = x_hook_length * y_slot_fraction;

    epsilon=2; // ensure it definitely protrudes
    translate([-y_slot_fraction / 2, -exterior_length / 2 - epsilon - wall_thickness/2, exterior_height - wall_thickness/2]) 
    rotate([90,90,90]) {
        cube([wall_thickness, wall_thickness+epsilon, y_slot_fraction]);
    }
}

module right_groove() {
    translate([-tolerance/2 + (exterior_width-2*wall_thickness) / 2,-y_hook_length/2,wall_thickness+hook_thickness*2]) rotate([0,90,90]) linear_extrude(y_hook_length) {
        base_groove();
    }
}

module front_groove() {
    translate([-x_hook_length/2, -exterior_length/2 + wall_thickness+tolerance/2, wall_thickness + hook_thickness*2]) rotate([90,90,90]) linear_extrude(x_hook_length){
        base_groove();
    }
}

module base_groove() {
    polygon(points=[[0,0],[0, -1], [2*hook_thickness, -1],[2*hook_thickness,0],[hook_thickness,hook_thickness]]);
}

module pcb_mounting_plate() {
    translate([0, -13, 0]) rotate([0, 0, 0]) {
        color("red")
        import("parts/pcb-mounting-plate-6x3.stl");
    }    
}

module battery_holder_box() {
    battery_holder_x = -interior_width/2 + 112.0;
    battery_holder_y = interior_length/2 - 17.0;

    translate([battery_holder_x, battery_holder_y, 0]) rotate([0, 0, 180]) {
        color("red")
        import("parts/battery-holder-box.stl");
    }        
}

module enclosure_cover() {
   // Top face
    difference(){
        linear_extrude(wall_thickness) {
            box_exterior();
        }
    }
    
    difference(){
        // Wall of top cover
        inset = wall_thickness + tolerance/2;
        linear_extrude(wall_thickness+hook_thickness*2){
            offset(r=-inset) {
                box_exterior();
            }
        }
        
        // Hollow out
        translate([0,0,wall_thickness]) linear_extrude(exterior_height){
            offset(r=-wall_thickness*2) {
                offset(r=-inset) {
                    box_exterior();
                }
            }
        }
        
        right_groove();
        rotate([180,180,0]) right_groove();
        front_groove();
        rotate([180,180,0])  front_groove();
    }

    // TODO: Just draw the screw mounts, instead of importing this whole piece of geometry.
    pcb_mounting_plate();
    battery_holder_box();
}

module show_enclosure() {
    if (enclosure_parts == 1) {
        both_closed();
    }    
    else if (enclosure_parts == 2) {
        enclosure_box();
    } 
    else if (enclosure_parts == 3) {
        translate([0, 0, 0]) rotate([180, 0, 0])
        enclosure_cover();
    }
}

module both_side_by_side() {
    translate([0, -(exterior_length/2 + wall_thickness), 0]) enclosure_box();
    translate([0, +(exterior_length/2 + wall_thickness), 0]) enclosure_cover();
}

module both_closed() {
    translate([0, 0, 0]) enclosure_box();

    translate([0, 0, exterior_height]) rotate([180, 0, 0]) {
        enclosure_cover();
    }
}

show_enclosure();