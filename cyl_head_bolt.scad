// Norm Nuts and Bolts - a OpenSCAD library
// Copyright (C) 2012  Johannes Kneer

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


// MAIN LIBRARY MODULES AND FUNCTIONS

include <data-access.scad>;                // database lookup functions
include <data-metric_cyl_head_bolts.scad>; // database 


// =============================
// -- through hole for screws --
// -----------------------------

module hole_through(

	name = "M3",  // name of screw family (i.e. M4, M5, etc)
	l    = 50.0,  // length of main bolt
	cld  =  0.2,  // dia clearance for the bolt
	h    =  0.0,  // height of bolt-head
	hcld =  1.0)  // dia clearances for the head
{ // -----------------------------------------------

	df = _get_fam(name);
	orad        = df[_NB_F_OUTER_DIA]/2;
	head_height = df[_NB_F_HEAD_HEIGHT];
	head_rad    = df[_NB_F_HEAD_DIA]/2;
	union() {
		translate([0, 0, -l/2-h]) cylinder(r=(orad+cld/2), h=l,  center=true);
		if (h>0)
			translate([0,0,-h/2]) cylinder(r=(head_rad+hcld/2),h=h, center=true);
	}
}
// -- end of hole_through module
// -----------------------------



// =============================
// -- threaded hole           --
// -----------------------------

module hole_threaded(

	name   = "M3",  // name of screw family (i.e. M3, M4, M42, ...)
	l      = 25.0,  // length/depth of hole 
	thread = "no",  // option wheter or not to model the thread
			//   -> no:      hole has inner thread diameter (default)
                        //   -> modeled: actual thread is in the model
        cltd   =  0.0)  // dia clearance to add for thread=no
{ // -----------------------------------------------

	df = _get_fam(name);
	orad        = df[_NB_F_OUTER_DIA]/2;
	lead	    = df[_NB_F_LEAD];
	
	irad = orad-lead;

	
	if (thread=="modeled") {
		translate([0,0,-l]) thread(orad, l, lead);
	} else {
		translate([0,0,-l/2]) cylinder(r=irad+cltd/2,h=l,center=true);
	}
}
// -- end of hole_threaded module
// -----------------------------



// ====================================
// -- nutcatch parallel to bolt axis --
// ------------------------------------

module nutcatch_parallel(

	name   = "M3",  // name of screw family (i.e. M3, M4, ...)
	l      =  5.0,  // length/depth of hole
	clk    =  0.0)  // clearance aditional to nominal key width
{ // -----------------------------------------------

	df     = _get_fam(name);
	nutkey = df[_NB_F_NUT_KEY];

	translate([0,0,-l/2]) hexaprism(ri=nutkey/2+clk/2, h=l);
}
// -- end of nutcatch_parallel module
// -----------------------------



// ========================================
// -- nutcatch cut sideways towards hole --
// ----------------------------------------

module nutcatch_sidecut(

	name   = "M3",  // name of screw family (i.e. M3, M4, ...) 
	l      = 50.0,  // length of slot
	clk    =  0.0,  // key width clearance
	clh    =  0.0,  // height clearance
	clsl   =  0.1)  // slot width clearance
{ // -----------------------------------------------

	df = _get_fam(name);
	nutkey = df[_NB_F_NUT_KEY];
	nutheight = df[_NB_F_NUT_HEIGHT];
	
	cl = l - _calc_HexInscToSubscRadius(nutkey/2);
	union() {
		translate([l/2, 0, -(nutheight+clh)/2])
			cube([l, nutkey+clsl, nutheight+clh], center=true);
		translate([0,0, -(nutheight+clh)/2]) hexaprism(ri=(nutkey+clk)/2, h=nutheight+clh);
	}
}
// -- end of nutcatch_sidecut module
// -----------------------------



// =============================
// -- screw                   --
// -----------------------------
// default is not modelling the thread (for the small screws there is not real use
// to model them)
// Beware that for a diameter only certain screw lengths do actually exist!

module screw(

	name   = "M5x20",  // name of screw (i.e. M3x12, M4x25, ...)
	thread =    "no")  // option wheter or not to model the thread
                           //   -> no:      bolt has has outer thread diameter (default)
			   //   -> modeled: actual thread in model
{ // -----------------------------------------------

	ds = _get_screw(name);
	df = _get_screw_fam(name);
	length      = ds[_NB_S_LENGTH];
	nlength		= ds[_NB_S_NOTHREAD_LENGTH];
	tlength     = length-nlength;
	lead		    = df[_NB_F_LEAD];
	orad        = df[_NB_F_OUTER_DIA]/2;
	head_height = df[_NB_F_HEAD_HEIGHT];
	head_rad    = df[_NB_F_HEAD_DIA]/2;

	key_width = df[_NB_F_KEY];
	key_depth = df[_NB_F_KEY_DEPTH];

	if (thread=="modeled") {
		if(nlength>0) {  // if part of the bolt has no thread
			translate([0,0,-nlength/2+lead/2]) cylinder(r = orad, h = nlength-lead, center=true);
			translate([0,0,-nlength+lead/2]) cylinder(r2=orad, r1=orad-lead, h=lead, center=true);
			translate([0,0,-nlength-tlength+lead/2]) thread(orad, tlength+lead, lead);

		} else { // all of the bolt is threaded
			translate([0,0,-tlength]) thread(orad, tlength, lead);
	  	}

	} else { // thread is not modeled
		translate([0,0,-length/2]) cylinder(r = orad, h = length, center=true);
	}

	difference() {
		translate([0,0,head_height/2]) cylinder(r=head_rad, h=head_height, center=true);
		translate([0,0,head_height]) key_slot(k=key_width, l=key_depth);
	}

}
// -- end of screw module
// -----------------------------



// =============================
// -- nut                     --
// -----------------------------

module nut(

	name =    "M3",  // name of screw (i.e. M3x12, M4x25, ...)
	thread =  "no")  // option wheter or not to model the thread
                         //   -> no:      nut has has inner thread diameter (default)
			 //   -> modeled: actual thread in model
{ // -----------------------------------------------

	df = _get_fam(name);
	nutkey = df[_NB_F_NUT_KEY];
	nutheight = df[_NB_F_NUT_HEIGHT];
	orad = df[_NB_F_OUTER_DIA]/2;
	lead = df[_NB_F_LEAD];
	irad = orad-lead;

	e = _calc_HexInscToSubscRadius(nutkey/2);
	translate([0,0,-nutheight/2]) {
		difference() {
			hexaprism(ri=nutkey/2, h=nutheight);
			cylinder(r=irad, h=nutheight+0.1, center=true);
			if (thread=="modeled") {
				translate([0,0,-nutheight/2]) thread(orad, nutheight, lead);
				translate([0,0,-nutheight/2]) cylinder(r1=orad, r2=irad, h=lead, center=true);
				translate([0,0,nutheight/2]) cylinder(r2=orad, r1=irad, h=lead, center=true);
			}
		}
	}
}
// -- end of nut module
// -----------------------------



// =============================
// -- allen key_slot          --
// -----------------------------

module key_slot(
// if name is given (i.e. key("M5")) the measures will be looked up
// in the database, otherwise key and depth have to be set to the
// key width and the depth of the keyhole in the screw head

	name =   "none",  // name of screw family (i.e. M3, M4, ...)
	k    =      5.0,  // key slot width, used if no name is given
	l    =	    2.0,  // length/depth of key slot, used if no name is given
	clk  =      0.0,  // clearance for key 
	cll  =      0.0)  // clearance for length/depth
{ // -----------------------------------------------

	if (name!="none")
		assign(df = _get_fam(name), 
		       k = df[_NB_F_KEY],
		       l = df[_NB_F_KEY_DEPTH]);
	
	translate([0,0,-(l+cll)/2]) hexaprism(ri=(k+clk)/2, h=(l+cll));
}
// -- end of key_slot module
// -----------------------------



// =============================
// -- thread module           -- 
// -----------------------------

module thread(
// the thread is extruded with a twisted linear extrusion 

	orad,  // outer diameter of thread 
	tl,    // thread length
	p)     // lead of thread
{ // -----------------------------------------------

// radius' for the spiral
r = [orad-0/18*p, orad-1/18*p, orad-2/18*p, orad-3/18*p, orad-4/18*p, orad-5/18*p,
     orad-6/18*p, orad-7/18*p, orad-8/18*p, orad-9/18*p, orad-10/18*p, orad-11/18*p,
     orad-12/18*p, orad-13/18*p, orad-14/18*p, orad-15/18*p, orad-16/18*p, orad-17/18*p,
     orad-p];

// extrude 2d shape with twist
translate([0,0,tl/2])
//difference() {
linear_extrude(height = tl, convexity = 10, twist = -360.0*tl/p, center = true)
	// mirrored spiral (2d poly) -> triangular thread when extruded
	polygon([[ r[ 0]*cos(  0), r[ 0]*sin(  0)], [r[ 1]*cos( 10), r[ 1]*sin( 10)],
		 [ r[ 2]*cos( 20), r[ 2]*sin( 20)], [r[ 3]*cos( 30), r[ 3]*sin( 30)],
		 [ r[ 4]*cos( 40), r[ 4]*sin( 40)], [r[ 5]*cos( 50), r[ 5]*sin( 50)],
	     	 [ r[ 6]*cos( 60), r[ 6]*sin( 60)], [r[ 7]*cos( 70), r[ 7]*sin( 70)],
		 [ r[ 8]*cos( 80), r[ 8]*sin( 80)], [r[ 9]*cos( 90), r[ 9]*sin( 90)],
		 [ r[10]*cos(100), r[10]*sin(100)], [r[11]*cos(110), r[11]*sin(110)],
		 [ r[12]*cos(120), r[12]*sin(120)], [r[13]*cos(130), r[13]*sin(130)],
		 [ r[14]*cos(140), r[14]*sin(140)], [r[15]*cos(150), r[15]*sin(150)],
		 [ r[16]*cos(160), r[16]*sin(160)], [r[17]*cos(170), r[17]*sin(170)],
		 [ r[18]*cos(180), r[18]*sin(180)], [r[17]*cos(190), r[17]*sin(190)],
		 [ r[16]*cos(200), r[16]*sin(200)], [r[15]*cos(210), r[15]*sin(210)],
		 [ r[14]*cos(220), r[14]*sin(220)], [r[13]*cos(230), r[13]*sin(230)],
		 [ r[12]*cos(240), r[12]*sin(240)], [r[11]*cos(250), r[11]*sin(250)],
		 [ r[10]*cos(260), r[10]*sin(260)], [r[ 9]*cos(270), r[ 9]*sin(270)],
		 [ r[ 8]*cos(280), r[ 8]*sin(280)], [r[ 7]*cos(290), r[ 7]*sin(290)],
		 [ r[ 6]*cos(300), r[ 6]*sin(300)], [r[ 5]*cos(310), r[ 5]*sin(310)],
		 [ r[ 4]*cos(320), r[ 4]*sin(320)], [r[ 3]*cos(330), r[ 3]*sin(330)],
		 [ r[ 2]*cos(340), r[ 2]*sin(340)], [r[ 1]*cos(350), r[ 1]*sin(350)]
                ]);
}
// -----------------------------



// ===========================================
// -- 2d shape: hexagon by inscribed circle --
// -------------------------------------------

module hexagon(
// the radius of inscribed circle corresponds to the
// half of the key width

	ri =  1.0)   // inner radius of hexagon
{ // -----------------------------------------------

	ra = ri*2/sqrt(3);
	circle(r = ra, $fn=6, center=true);
}
// -- end of hexagon
// -----------------------------



// ==========================================
// -- 3d shape: hexaprism by inscr. circle --
// ------------------------------------------

module hexaprism(

	ri =  1.0,  // radius of inscribed circle
	h  =  1.0)  // height of hexaprism
{ // -----------------------------------------------

	ra = ri*2/sqrt(3);
	cylinder(r = ra, h=h, $fn=6, center=true);
}
// -- end of hexaprism
// -----------------------------



// ===========================
// helper functions

// calculate the subscribing radius from the inscribing radius
// for a hexagon
// key width (i.e. allen keys) correspont to the inner radius
// but we draw the hexagon using the outer radius
function _calc_HexInscToSubscRadius(ri) = ri*2/sqrt(3);
