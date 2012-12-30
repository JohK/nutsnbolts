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


// This OpenSCAD File shows all screws and nuts,
// only run this on recent decent hardware or you will wait...

include <cyl_head_bolt.scad>;
include <materials.scad>;

$fn=15;


scri = [   [0:8],     [9:17],   [18:26],   [27:35],   [36:45],   [46:56],
         [57:69],    [70:83],   [84:98],  [99:114], [115:133], [134:153],
        [154:171], [172:188], [189:203], [204:222], [223:239], [240:255],
        [256:270]];


for (j= [0:25]) {
	assign(diao = _get_screw_fam(data_screw[scri[j][0]][_NB_S_DESC])[_NB_F_OUTER_DIA],
								dia = 0)
	translate([0,j*2*diao,0])
for (i = scri[j]) {
	echo(data_screw[i][2]);	

	assign(name = data_screw[i][_NB_S_DESC],
           fam = data_screw[i][_NB_S_FAMKEY],
	       len = data_screw[i][_NB_S_LENGTH],
	       dia = _get_screw_fam(data_screw[i][_NB_S_DESC])[_NB_F_OUTER_DIA]) {

		echo(name, fam, len, dia, i*2*dia-2*dia*scri[j][0]);
		translate([i*2*dia-2*dia*scri[j][0], 0, 0]) {
			stainless() screw(name);//, thread="modeled");
			translate([0,0,-5/4*len]) stainless() nut(fam);//, thread="modeled");
		}
		
	}

}

}
