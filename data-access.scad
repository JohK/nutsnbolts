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


// DATABASE ACCESS FUNCTIONS AND CONSTANTS



// == CONSTANTS == 

// screw table access keys
_NB_S_DESC            = 0;
_NB_S_FAMKEY			 = 1;
_NB_S_LENGTH          = 2;
_NB_S_NOTHREAD_LENGTH = 3;

_NB_F_DESC			 = 0;
_NB_F_OUTER_DIA       = 1;
_NB_F_INNER_DIA       = 2;
_NB_F_LEAD            = 3; 
_NB_F_KEY             = 4;
_NB_F_KEY_DEPTH       = 5;
_NB_F_HEAD_HEIGHT     = 6;
_NB_F_HEAD_DIA        = 7;
_NB_F_NUT_KEY         = 8;
_NB_F_NUT_HEIGHT      = 9;


// == FUNCTIONS ==

// _get_screw("descriptor")   with descriptor = M8x25
//   find the line for a general object in the data matrix

function _get_screw(n) = data_screw[search([n], data_screw)[0]];
function _get_screw_fam(n) = data_screw_fam[search([_get_screw(n)[_NB_S_FAMKEY]], data_screw_fam)[0]];

function _get_fam(n) = data_screw_fam[search([n], data_screw_fam)[0]];


// _get_XXXXX("descriptor") functions
// find a single property in the database

function _get_desc(n)        = _get_screw(n)[_NB_S_DESC];
function _get_famkey(n)         = _get_screw(n)[_NB_S_FAMKEY];
function _get_length(n)      = _get_screw(n)[_NB_S_LENGTH];
function _get_nt_length(n)   = _get_screw(n)[_NB_S_NOTHREAD_LENGTH];

function _get_outer_dia(n)   = _get_screw_fam(n)[_NB_F_OUTER_DIA];
function _get_inner_dia(n)   = _get_screw_fam(n)[_NB_F_INNER_DIA];
function _get_lead(n)        = _get_screw_fam(n)[_NB_F_LEAD];
function _get_head_height(n) = _get_screw_fam(n)[_NB_F_HEAD_HEIGHT];
function _get_head_dia(n)    = _get_screw_fam(n)[_NB_F_HEAD_DIA];
function _get_nut_key(n)     = _get_screw_fam(n)[_NB_F_NUT_KEY];
function _get_nut_height(n)  = _get_screw_fam(n)[_NB_F_NUT_HEIGHT];


