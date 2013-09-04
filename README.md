nutsnbolts
==========

A OpenSCAD library that allows for simple creation of nuts and bolts and respective nut catches and screw holes.

![Screenshot of examples.scad output](http://i.imgur.com/f0snG.png)

The Library is based iso metric standard screws with hexagon socket head cap and respective nuts (see DIN 912 or DIN EN ISO 4762 for reference). The library allows for easy access to parts and holes of true measures like so: `screw("M5x10")`. For holes and catches all measures can be adjusted by setting additional clearances.
The origin for all parts created in this lib lies on the axis of the hole or screw. For screws on the underside of the head, for holes at top and for catches at the bottom.

And yes this lib can model *threads* on the screws. Beware that this is slow and may create improper stl files. The default is not to create a thread and instead have the outer diameter for bolts or the inner diameter for threaded holes and nuts.


Usage Example
=============
The main file is *cyl_head_bolt.scad*, have a look in there for available modules and parameters (commented).
For more usage examples have a look into *examples.scad*.


### Holes and Nutcatches
The package includes threaded and through holes to screw the bolts in or push them through.
Also nutcatches cut sideways into a body and a catch just parallel to the through-hole axis are available.
	
	difference() {
		translate([-15, -15, 0]) cube([80, 30, 50]);
		rotate([180,0,0]) nutcatch_parallel("M5", l=5);
		translate([0, 0, 50]) hole_through(name="M5", l=50+5, cl=0.1, h=10, hcl=0.4);
		translate([55, 0, 9]) nutcatch_sidecut("M8", l=100, clk=0.1, clh=0.1, clsl=0.1);
	}

![Screenshot of the resulting model](http://i.imgur.com/8pFyggB.png)

### Screws and Nuts
	include <cyl_head_bolt.scad>;

	screw("M20x100", thread="modeled"); // screw M20x100 with thread
	nut("M20", thread="modeled");       // corresponding nut with thread
			    
	screw("M3x12");                     // screw M3x12

![Screenshot 1 of screw("M20x100", thread="modeled");](http://i.imgur.com/tIFTW.png)
![Screenshot 2 of screw("M20x100", thread="modeled");](http://i.imgur.com/AfHBo.png)



### Materials and Colors


	include <materials.scad>;  // this allows you to write stuff like this:
	stainless(no="1.4301") nut("M3");

	// which colors the parts in the corresponding color and documents the
	// intended material. The material number isn't used for anything and can be
	// skipped. Sensible defaults are set for stainless/steel/iron.




