
// parameters to all modules
// 2. size : nominal diameter (5 for M5, nut or bolt)
// 3. l: length/depth
// 4. cl: additional clearance

// all shapes are positives with their origin in the hole center


include <norm_nb-base.scad>;                       // database lookup functions
include <norm_nb_data-metric_cyl_head_bolts.scad>; // database 


//hole_through(head=5);

//echo(_get_screw("M5x10"));

//echo(search(["M5x5"], data_screw));

//echo(data_screw);


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
module hole_threaded(thread="no") {


	if (thread=="modeled") echo("modeled thread is currently not supported");
}

// simple heaxagonal nut catch
module nut_catch_normal() {
}

// side cut to a hole
module nut_catch_sidecut() {
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
	
	//radius of inscribing circle
	e = nutkey/sqrt(3);
	difference() {
		cylinder(r=e, h=nutheight, $fn=6, center=true);
		cylinder(r=dia/2, h=nutheight+0.1, center=true);
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
	
	//radius of inscribing circle
	e = key/sqrt(3);
	translate([0,0,-depth/2]) cylinder(r=e, h=depth, $fn=6, center=true);
}
