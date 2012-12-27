// norm bolt and nuts package

include <norm_nb-cyl_head_bolt.scad>;
//include <norm_nb-base.scad>;

// holes
//cube([60, 20, 10]);




// example nuts and screws

$fn=60;
translate([0,50, 0]) screw("M20x100", thread="modeled");
translate([0,50,-120]) nut("M20");

translate([30,50,0]) screw("M12x60");
translate([30,50,-80]) nut("M12");

translate([50,50,0]) screw("M5x20");
translate([50,50,-30]) nut("M5");

//key("M5");




// example db lookups

echo(_get_fam("M8"));
echo(_get_screw("M5x8"));
echo(_get_screw_fam("M5x8"));

