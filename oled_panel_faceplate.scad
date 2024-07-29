
/* [Options] */

draw_panel=1;//[0:No, 1:Yes]
draw_faceplate=0;//[0:No, 1:Yes]
draw_oled_extrusions=0;//[0:No, 1:Yes]

/* [Hidden] */
$fn = 100;

panel_width = 34;
panel_length = 32;
panel_thickness = 2.0;

extrude_height = 6;

screw_diameter = 2.4;
oled_screw_hole_spacing_x = 23.6;
oled_screw_hole_spacing_y = 23.0;

oled_screen_width = 27.6;
oled_screen_length = 19.6;
oled_screen_x_offset = 0;
oled_screen_y_offset = 0;

faceplate_width = panel_width - 4.0;
faceplate_length = panel_length - 4.0;
faceplate_cutout_width = oled_screen_width - 4.0;
faceplate_cutout_length = 12.0;
faceplate_cutout_y_offset = -8;
faceplate_thickness = 1.0; 

module screw_hole_cutouts() {
    screw_hole_x_offset = oled_screw_hole_spacing_x/2;
    screw_hole_y_offset = oled_screw_hole_spacing_y/2;
    screw_hole_bottom_y_offset = 0.4;

    color("red") {
        translate([screw_hole_x_offset, screw_hole_y_offset + screw_hole_bottom_y_offset, -extrude_height/2]) 
        cylinder(h=extrude_height, d = screw_diameter);

        translate([-screw_hole_x_offset, screw_hole_y_offset + screw_hole_bottom_y_offset, -extrude_height/2]) 
        cylinder(h=extrude_height, d = screw_diameter);    

        translate([-screw_hole_x_offset, -screw_hole_y_offset, -extrude_height/2]) 
        cylinder(h=extrude_height, d = screw_diameter);        

        translate([screw_hole_x_offset, -screw_hole_y_offset, -extrude_height/2]) 
        cylinder(h=extrude_height, d = screw_diameter);
    }    
}

module oled_display_cutouts() {
    notch_width = 16.0;
    notch_length = 3.0;
    notch_y_offset = 0.01;

    // screen cutout
    translate([-oled_screen_width/2 + oled_screen_x_offset, -oled_screen_length/2 + oled_screen_y_offset, -extrude_height/2]) 
    color("purple")
    cube([oled_screen_width, oled_screen_length, extrude_height]);

    // notch for screen ribbon cable
    translate([-notch_width/2 + oled_screen_x_offset, oled_screen_length/2 + oled_screen_y_offset - notch_y_offset, -extrude_height/2])     
    color("green")
    cube([notch_width, notch_length, extrude_height]);

    screw_hole_cutouts();
}

module faceplate_cutouts() {
    translate([-faceplate_cutout_width/2, faceplate_cutout_y_offset, -extrude_height/2])     
    color("purple")
    cube([faceplate_cutout_width, faceplate_cutout_length, extrude_height]);    

    screw_hole_cutouts();
}

module panel() {
    translate([-panel_width/2, -panel_length/2, 0])
    cube([panel_width, panel_length, panel_thickness]);
}

module faceplate() {
    color("gray") {
        translate([-faceplate_width/2, -faceplate_length/2, -panel_thickness + faceplate_thickness])
        cube([faceplate_width, faceplate_length, faceplate_thickness]);
    }
}

if (draw_oled_extrusions == 1) {
    oled_display_cutouts();
} 
else {
    if (draw_panel == 1) {
        difference()
        {
            panel();
            oled_display_cutouts();
        }
    }

    if (draw_faceplate == 1) {
        difference() {
            faceplate();
            faceplate_cutouts();
        }
    }

    if (draw_oled_extrusions == 1) {
        oled_display_cutouts();
    }
}