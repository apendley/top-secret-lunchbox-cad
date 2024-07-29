
side=1;//[0:Top/Bottom,1:Left/Right]

/* [Hidden] */
$fn = 100;

standoff_height = side == 0 ? 3 : 4.8;
standoff_width = 50;
standoff_length = 14.0;

cube([standoff_width, standoff_length, standoff_height]);