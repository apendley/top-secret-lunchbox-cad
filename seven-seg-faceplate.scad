/* [Hidden] */
$fn = 100;

// Seven seg
seven_seg_width = 50.6;
seven_seg_length = 19.4;
seven_seg_x = -seven_seg_width/2;
seven_seg_y = -seven_seg_length/2;

panel_width = seven_seg_width + 4;
panel_length = seven_seg_length + 10;
panel_thickness = 1.0;


module panel() {
    translate([-panel_width/2, -panel_length/2, 0])
    cube([panel_width, panel_length, panel_thickness]);
}

module seven_segment_cutout() {
    screwDiameter = 2.4;
    xScrewOffset = -3.2;
    yTopScrewOffset = 2.0;
    yBottomScrewOffset = 2.0;
    h_overlap = 1.0;
    v_overlap = 2.0;

    color("Green") {
        translate([seven_seg_x + h_overlap/2, seven_seg_y + v_overlap/2, -panel_thickness/2]) {
            cube([seven_seg_width - h_overlap, seven_seg_length - v_overlap, panel_thickness*2]);
        }

        // top left
        translate([seven_seg_x - xScrewOffset, seven_seg_y - yBottomScrewOffset, -panel_thickness/2]) {
            cylinder(d=screwDiameter, panel_thickness*2, $fn=50);
        }

        // top right
        translate([seven_seg_x + seven_seg_width + xScrewOffset, seven_seg_y - yBottomScrewOffset, -panel_thickness/2]) {
            cylinder(d=screwDiameter, panel_thickness*2, $fn=50);
        }

        // top left
        translate([seven_seg_x - xScrewOffset, seven_seg_y + seven_seg_length + yTopScrewOffset, -panel_thickness/2]) {
            cylinder(d=screwDiameter, panel_thickness*2, $fn=50);
        }

        // top right
        translate([seven_seg_x + seven_seg_width + xScrewOffset, seven_seg_y + seven_seg_length + yTopScrewOffset, -panel_thickness/2]) {
            cylinder(d=screwDiameter, panel_thickness*2, $fn=50);
        }
    }    
}

difference()
{
    panel();
    seven_segment_cutout();

}
