
/* [Hidden] */
$fn=100;

interior_width = 28.6;
interior_length = 85.6;

panel_thickness = 0.8;
text_height = 0.4;
wall_height = 0.4;

module legend() {
    cube([interior_width, interior_length, panel_thickness]);

    translate([0, 0, panel_thickness]) {

        difference()
        {
            color("black") 
            cube([interior_width, interior_length, wall_height]);

            translate([0.5, 0.5, 0.01])
            cube([interior_width - 1.0, interior_length - 1.0, wall_height]);
        }
    }


    icons = [
        "^",
        "`",
        "g",
        "b",
        "d",
        "_",
        "h",
        "i",
        "c",
        "f"
    ];

    for (i = [0:4]) {
        translate([1, interior_length - 11 - i * 18, panel_thickness])
        color("black")
        linear_extrude(text_height)
        text(icons[i], font="Wingdings:style=Regular", size=7);

        translate([interior_width - 11, interior_length - 11 - i * 18, panel_thickness])
        color("black")
        linear_extrude(text_height)
        text(icons[i+5], font="Wingdings:style=Regular", size=7);        
    }
}

translate([-interior_width/2, -interior_length/2, 0])
{ 
    legend();
}




// translate([100, 100, 0])
// color("black")
// linear_extrude(1.0)
// text("abcdefghijklmnopqrstuvwxyz", font="sym:style=Regular", size=7);
// text("ABCDEFGHIJKLMNOPQRSTUVWXYZ", font="sym:style=Regular", size=7);
// text("`1234567890-=~!@#$%^&*()_+", font="sym:style=Regular", size=7);
