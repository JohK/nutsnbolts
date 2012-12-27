// norm bolt and nuts package

include <norm_nb-cyl_head_bolt.scad>;
//include <norm_nb-base.scad>;

// example nut catches and holes

difference() {
	translate([-15, -15, 0]) cube([80, 30, 50]);
	rotate([180,0,0]) nut_catch_normal("M5");
	translate([0, 0, 50]) hole_through(name="M5", l=50+5, cl=0.1, h=10, hcl=0.4);
	translate([55, 0, 7.5]) nut_catch_sidecut("M8", 100);
	translate([55, 0, 50]) hole_through(name="M8", l=50+5, cl=0.1, h=10, hcl=0.4);
}



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

//echo(_get_fam("M8"));
//echo(_get_screw("M5x8"));
//echo(_get_screw_fam("M5x8"));

