


include <norm_nb-base.scad>;                       // database lookup functions
include <norm_nb_data-metric_cyl_head_bolts.scad>; // database 



// though hole for screws
// head: sink in the screw head (for allen head screws)
module hole_through(name="M5", l=50, cl=0, h=0, hcl=0) {
	df = _get_fam(name);
	orad        = df[_NB_F_OUTER_DIA]/2;
	head_height = df[_NB_F_HEAD_HEIGHT];
	head_rad    = df[_NB_F_HEAD_DIA]/2;
	union() {
		translate([0, 0, -l/2-h]) cylinder(r=(orad+cl/2), h=l,  center=true);
		if (h>0)
			translate([0,0,-h/2]) cylinder(r=(head_rad+hcl/2),h=h, center=true);
	}
}


// thread = modeled: actual thread in model
//        = no:       diameter of model is inner diameter for self cutting screws
module hole_threaded(thread="no") {


	if (thread=="modeled") echo("modeled thread is currently not supported");
}

// simple heaxagonal nut catch
module nut_catch_normal(name="none") {
	hull() nut(name);
}

// side cut to a hole
module nut_catch_sidecut(name = "none", depth=50) {
	df = _get_fam(name);
	nutkey = df[_NB_F_NUT_KEY];
	nutheight = df[_NB_F_NUT_HEIGHT];
	
	cl = depth - _calc_HexInscToSubscRadius(nutkey/2);
	union() {
		translate([cl/2, 0, -nutheight/2])
			cube([cl, nutkey, nutheight], center=true);
		translate([0,0, -nutheight/2]) hexaprism(ri=nutkey/2, h=nutheight);
	}
}

module screw(name="M5x20", thread="no") {
	ds = _get_screw(name);
	df = _get_screw_fam(name);
	length      = ds[_NB_S_LENGTH];
	//tlength     = length-d[_NB_S_NOTHREAD_LENGTH];
	orad        = df[_NB_F_OUTER_DIA]/2;
	//irad        = df[_NB_F_INNER_DIA]/2;
	head_height = df[_NB_F_HEAD_HEIGHT];
	head_rad    = df[_NB_F_HEAD_DIA]/2;

	key_width = df[_NB_F_KEY];
	key_depth = df[_NB_F_KEY_DEPTH];

	translate([0,0,-length/2]) cylinder(r = orad, h = length, center=true);
	difference() {
		translate([0,0,head_height/2]) cylinder(r=head_rad, h=head_height, center=true);
		translate([0,0,head_height]) key_slot(key=key_width, depth=key_depth);
	}

	if (thread=="modeled") echo("modeled thread is currently not supported");	
}

// nut
module nut(name="M5", thread="none") {
	df = _get_fam(name);
	nutkey = df[_NB_F_NUT_KEY];
	nutheight = df[_NB_F_NUT_HEIGHT];
	dia = df[_NB_F_OUTER_DIA];
	

	e = _calc_HexInscToSubscRadius(nutkey/2);
	translate([0,0,-nutheight/2]) {
		difference() {
			hexaprism(ri=nutkey/2, h=nutheight);
			cylinder(r=dia/2, h=nutheight+0.1, center=true);
		}
	}

	if (thread=="modeled") echo("modeled thread is currently not supported");
}


// key_slot
// if name is given (i.e. key("M5")) the measures will be looked up
// in the database, otherwise key and depth have to be set to the
// key width and the depth of the keyhole in the screw head
module key_slot(name="none", key=5, depth=2) {

	if	(name!="none")
		assign(df = _get_fam(name), 
		       key = df[_NB_F_KEY],
		       depth = df[_NB_F_KEY_DEPTH]);
	
	translate([0,0,-depth/2]) hexaprism(ri=key/2, h=depth);
}


module hexagon(ri=1) {

	// calculate the subscribing radius from the inscribing radius
	// for a hexagon
	// key width (i.e. allen keys) correspont to the inner radius
	// but we draw the hexagon using the outer radius
	ra = ri*2/sqrt(3);
	circle(r = ra, $fn=6, center=true);
}

module hexaprism(ri=1, h=1) {
	ra = ri*2/sqrt(3);
	cylinder(r = ra, h=h, $fn=6, center=true);
}

// calculate the subscribing radius from the inscribing radius
// for a hexagon
// key width (i.e. allen keys) correspont to the inner radius
// but we draw the hexagon using the outer radius
function _calc_HexInscToSubscRadius(ri) = ri*2/sqrt(3);
