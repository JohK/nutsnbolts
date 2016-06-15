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


// MATERIALS

// all materials take a no-parameter that should be used to document
// the exact material in code, the number is not yet used in the code 



module stainless(no="1.4301") {
	color([0.45, 0.43, 0.5]) children([0:$children-1]);
}

module steel(no) {
	color([0.65, 0.67, 0.72]) children([0:$children-1]);
}

module iron(no="ST37") {
	color([0.36, 0.33, 0.33]) children([0:$children-1]);
}

// additional colors
CL_ZINC = [0.4, 0.4, 0.4];
