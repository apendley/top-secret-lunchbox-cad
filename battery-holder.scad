/* [Hidden] */

battery_length = 70.0;
battery_diameter = 18.2;

/* [STL export] */

// Which one would you like to see?
part = 0;//[0:Both - side by side, 1:Both - closed box, 2:Box only, 3: Top only]

// Draw the battery?
draw_battery=0;//[0: No, 1: Yes]

/* [Hidden] */

// Size of your printer's nozzle in mm
nozzle_size = 0.2; //[0:0.05:2]

// Number of walls the print should have
number_of_walls = 10;

// Tolerance (use 0.2 for FDM)
tolerance = 0.2; // [0.1:0.1:0.4]

// Interior dimension X in mm
interior_width = battery_length + 2; //[0:0.05:200.0]

// Interior dimension Y in mm
interior_length = battery_diameter + 3.0; //[0:0.05:200.0]

// Interior dimension Z in mm
interior_height = battery_diameter + 3.0; //[0:0.05:200.0]

// interior corner radius in mm
radius = 0.0;

/* [Hidden] */

// Number of walls the hook should have
hook_walls = 6;

// What fraction of the flat X side should the hook take up? (0 for no hook)
x_hook_fraction = 0.4; // [0:0.1:1.0]

// What fraction of the left/right hooks should have a slot behind them? (0 for no slot)
x_slot_fraction = 0.8; // [0:0.1:2]

// What fraction of the flat Y side should the hook take up? (0 for no hook)
y_hook_fraction = 0.0; // [0:0.1:1.0]

// What fraction of the top/bottom hooks should have a slot behind them? (0 for no slot)
y_slot_fraction = 0.8; // [0:0.1:2]

/* [Hidden] */
$fn=100;

wall_thickness = nozzle_size * number_of_walls;

// Outer dimensions
exterior_width = interior_width + 2 * wall_thickness;
exterior_length = interior_length + 2 * wall_thickness;
exterior_height = interior_height + 2 * wall_thickness;

hook_thickness = hook_walls * nozzle_size;

top_cover_wall_thickness = hook_thickness + wall_thickness;

y_hook_length = (exterior_length - 2 * radius) * y_hook_fraction;
x_hook_length = (exterior_width - 2 * radius) * x_hook_fraction;

battery_x = 0;
battery_y = 0;

module battery(c = "blue") {
    
    translate([battery_x, battery_y, wall_thickness + battery_diameter/2]) rotate([0, 90, 0]) {
        color(c)
        cylinder(h=battery_length, d=battery_diameter, center=true);
    }
}

module battery_cable_hole() {
    battery_cable_radius = 1.2;
    battery_cable_width = 8.0;
    battery_cable_height = 6.0;
    battery_cable_hole_length = 10;

    battery_cable_x = (interior_width - battery_cable_hole_length + wall_thickness)/2;
    battery_cable_z = battery_cable_height/2 + battery_diameter - 3.0;

    color("Red") {
        translate([battery_cable_x, 0, battery_cable_z]) rotate([90, 0, 90]) 
        linear_extrude(battery_cable_hole_length) {
            rounded_rect(battery_cable_radius, battery_cable_width, battery_cable_height, center=true);
        }
    }
}


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

module rounded_rect(r, w, l, center=true) {
    offset(r=r) {
        square([w-2*r, l-2*r], center=center);
    }    
}

module bottom_box() {
    difference() {
        // Solid box
        linear_extrude(exterior_height - wall_thickness) {
            box_exterior();
        }
        
        // Hollow out
        translate([0, 0, wall_thickness]) linear_extrude(exterior_height) {
            box_interior();
        }

        // Left/right slots
        left_slot();
        rotate([180,180,0]) left_slot();

        // Front/back slots
        front_slot();
        rotate([180,180,0]) front_slot();

        battery_cable_hole();
    }

    // Left/Right hook
    left_hook();
    rotate([180,180,0]) left_hook();

    // Front/Back hook
    front_hook();
    rotate([180,180,0]) front_hook();
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

module battery_standoffs() {
    standoff_width = 5;
    standoff_length = interior_length - wall_thickness*4 - tolerance;
    standoff_height = 4.6;

    difference()
    {
        color("red")
        translate([-standoff_width/2, -standoff_length/2, wall_thickness])
        cube([standoff_width, standoff_length, standoff_height]);

        translate([0, 0, top_cover_wall_thickness - tolerance*2])
        battery("purple");
    }
}

module top_cover() {
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

    battery_standoffs();
}

module print_part() {
    if (part == 0) {
        both_side_by_side();
    } 
    else if (part == 1) {
        both_closed();
    }    
    else if (part == 2) {
        bottom_box();

        if (draw_battery) {
            battery();
        }        
    } 
    else if (part == 3) {
        top_cover();

        if (draw_battery) {
            translate([0, 0, top_cover_wall_thickness - tolerance])
            battery();
        }                
    }
}

module both_side_by_side() {
    translate([0, -(exterior_length/2 + wall_thickness), 0]) {
        bottom_box();

        if (draw_battery) {
            battery();
        }                

    }

    translate([0, +(exterior_length/2 + wall_thickness), 0]) 
    top_cover();
}

module both_closed() {
    translate([0, 0, 0]) {
        bottom_box();

        if (draw_battery) {
            battery();
        }
    }

    translate([0, 0, exterior_height]) mirror([0, 0, 1]) {
        top_cover();
    }
}

print_part();