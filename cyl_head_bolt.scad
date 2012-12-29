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



// -----------------------------
// -- through hole for screws --
// -----------------------------
// 
// hole_through(name="M3", l=50, cld=0.2, h=0, hcld=1)
//   name: name of screw family (i.e. M4, M5, etc)
//   l:    length of main bolt
//   cld:  dia clearance for the bolt
//   h:    height of bolt-head
//   hcld: dia clearances for the head
// -----------------------------
// defaults for clearances set to typical values (in mech. eng.)

module hole_through(name="M5", l=50, cld=0.2, h=0, hcld=1) {
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
// -- threaded hole           --
// -----------------------------
//
// hole_threaded(name="M3", l=25, thread="no", cltr=0)
//   name:   name of screw family (i.e. M3, M4, M42, ...)
//   l:      length/depth of hole
//   thread: option wheter or not to model the thread
//     -> no: (default)  hole has inner thread diameter
//	   -> modeled:       actual thread in model
//   cltd: dia clearance to add for thread=no
// -----------------------------
// threads usually not modeled as not useful in 3d printing or CAD
// (at least for typical screw sizes)

module hole_threaded(name="M3", l=25, thread="no", cltr=0) {
	df = _get_fam(name);
	irad        = df[_NB_F_INNER_DIA]/2;
	orad        = df[_NB_F_OUTER_DIA]/2;

	translate([0,0,-l/2]) cylinder(h=l, r=orad+cltr/2);
	// thread: no      -> inner dia
	//         modeled -> thread

	if (thread=="modeled") echo("modeled thread is currently not supported");
}
// -- end of hole_threaded module



// ------------------------------------
// -- nutcatch parallel to bolt axis --
// ------------------------------------
//
// nutcatch_parallel(name="M3", l=5, clk=0)
//   name: name of screw family (i.e. M3, M4, ...)
//   l:    length/depth of nutcatch hole 
//   clk:  clearance aditional to nominal key width
// -----------------------------
// hexagonal nutcatch parallel to bolt axis

module nutcatch_parallel(name="M3", l=5, clk=0) {
	df = _get_fam(name);
	nutkey = df[_NB_F_NUT_KEY];

	translate([0,0,-l/2]) hexaprism(ri=nutkey/2, h=l);
}
// -- end of nutcatch_parallel module



// ----------------------------------------
// -- nutcatch cut sideways towards hole --
// ----------------------------------------
//
// nutcatch_sidecut(name="M3", l=50, clh=0.1, clk=0, clsl=0.1)
//   name: name of screw family (i.e. M3, M4, ...)
//   l:    length of slot
//   clh:  height clearance
//   clk:  key width clearance
//   clsl: slot width clearance
// -----------------------------

module nutcatch_sidecut(name="M3", l=50, clk=0, clh=0, clsl=0.1) {
	df = _get_fam(name);
	nutkey = df[_NB_F_NUT_KEY];
	nutheight = df[_NB_F_NUT_HEIGHT];
	
	cl = l - _calc_HexInscToSubscRadius(nutkey/2);
	union() {
		translate([l/2, 0, -(nutheight+clh)/2])
			cube([l, nutkey+clk, nutheight+clh], center=true);
		translate([0,0, -(nutheight+clh)/2]) hexaprism(ri=(nutkey+clk)/2, h=nutheight+clh);
	}
}
// -- end of nutcatch_sidecut module



// -----------------------------
// -- screw                   --
// -----------------------------
//
// screw(name="M3x12", thread="no")
//   name:   name of screw (i.e. M3x12, M4x25, ...)
//   thread: option wheter or not to model the thread
//     -> no: (default)  bolthas has outer thread diameter
//	   -> modeled:       actual thread in model
// -----------------------------
// default is not modelling the thread (for the small screws there is not real use
// to model them)
// Beware that for a diameter only certain screw lengths do actually exist!

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
		translate([0,0,head_height]) key_slot(k=key_width, l=key_depth);
	}

	if (thread=="modeled") echo("modeled thread is currently not supported");	
}
// -- end of screw module


// -----------------------------
// -- nut                     --
// -----------------------------
//
// nut(name="M3", thread="no")
//   name:   name of screw family (i.e. M3, M4, ...)
//   thread: option wheter or not to model the thread
//     -> no: (default)  bolthas has outer thread diameter
//	   -> modeled:       actual thread in model
// -----------------------------

module nut(name="M3", thread="no") {
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
// -- end of nut module



// -----------------------------
// -- allen key_slot          --
// -----------------------------
//
// key_slot(name="none", k=5, l=2, clk=0, cll=0)
//   name: name of screw family (i.e. M3, M4, ...)
//   k:    key slot width, used if no name is given
//   l:    length/depth of key slot, used if no name is given
//   clk:  clearance for key
//   cll:  clearance for length/depth
// -----------------------------
// if name is given (i.e. key("M5")) the measures will be looked up
// in the database, otherwise key and depth have to be set to the
// key width and the depth of the keyhole in the screw head

module key_slot(name="none", k=5, l=2, clk=0, cll=0) {

	if	(name!="none")
		assign(df = _get_fam(name), 
		       k = df[_NB_F_KEY],
		       l = df[_NB_F_KEY_DEPTH]);
	
	translate([0,0,-(l+cll)/2]) hexaprism(ri=(k+clk)/2, h=(l+cll));
}
// -- end of key_slot module



// -------------------------------------------
// -- 2d shape: hexagon by inscribed circle --
// -------------------------------------------
//
// hexagon(ri=1)
//   ri: radius of inscibed circle
// -----------------------------
// the radius of inscribed circle corresponds to the
// half of the key width

module hexagon(ri=1) {
	ra = ri*2/sqrt(3);
	circle(r = ra, $fn=6, center=true);
}
// -- end of hexagon



// ------------------------------------------
// -- 3d shape: hexaprism by inscr. circle --
// ------------------------------------------
//
// hexaprism(ri=1, h=1)
//   ri: radius of inscribed circle
//   h:  height of hexaprism
// -----------------------------

module hexaprism(ri=1, h=1) {
	ra = ri*2/sqrt(3);
	cylinder(r = ra, h=h, $fn=6, center=true);
}
// -- end of hexaprism



// ===========================
// helper functions

// calculate the subscribing radius from the inscribing radius
// for a hexagon
// key width (i.e. allen keys) correspont to the inner radius
// but we draw the hexagon using the outer radius
function _calc_HexInscToSubscRadius(ri) = ri*2/sqrt(3);
