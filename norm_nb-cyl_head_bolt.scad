
// parameters to all modules
// 1. t = [iso|imperial] : type which standard
// 2. size : nominal diameter (5 for M5, nut or bolt)
// 3. l: length/depth
// 4. cl: additional clearance

// all shapes are positives with their origin in the hole center


use <norm_nb-base.scad>

hole_through(head=5);

echo(get_data("M5x20"));

function get_data(n) = data[search([n],data)[0]];

// though hole for screws
// head: sink in the screw head (for allen head screws)
module hole_through(type="iso", size=5, length=20, clearance="none", head="none") {
	union() {
		translate([0, 0, -length/2-head]) cylinder(r=size/2, h=length,  center=true);
		if (head!="none")
			translate([0,0,-head/2]) cylinder(r=size,h=head, center=true);
	}
}


// thread = modelled: actual thread in model
//        = no:       diameter of model is inner diameter for self cutting screws
module hole_threaded(thread=no) {


	if (thread=="modelled") echo("Modelled thread is currently not supported");
}

// simple heaxagonal nut catch
module nut_catch_normal() {
}

// side cut to a hole
module nut_catch_cutthrough() {
}