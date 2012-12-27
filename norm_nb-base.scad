
// base functions and modules for the norm-boltnnuts package
// database access mainly

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
_NB_F_HEAD_HEIGHT     = 5;
_NB_F_HEAD_DIA        = 6;


// == FUNCTIONS ==

// _get_screw("descriptor")   with descriptor = M8x25
//   find the line for a general object in the data matrix

function _get_screw(n) = data_screw[search([n], data_screw)[0]];
function _get_screw_fam(n) = data_screw_fam[search([_get_screw(n)[_NB_S_FAMKEY]], data_screw_fam)[0]];

function _get_familydata(n) = data_screw_fam[search([n], data_screw_fam)[0]];


// _get_XXXXX("descriptor") functions
// find a single property in the database

function _get_desc(n)        = _get_screw(n)[_NB_S_DESC];
function _get_fam(n)         = _get_screw(n)[_NB_S_FAMKEY];
function _get_length(n)      = _get_screw(n)[_NB_S_LENGTH];
function _get_nt_length(n)   = _get_screw(n)[_NB_S_NOTHREAD_LENGTH];

function _get_outer_dia(n)   = _get_screw_fam(n)[_NB_F_OUTER_DIA];
function _get_inner_dia(n)   = _get_screw_fam(n)[_NB_F_INNER_DIA];
function _get_lead(n)        = _get_screw_fam(n)[_NB_F_LEAD];
function _get_head_height(n) = _get_screw_fam(n)[_NB_F_HEAD_HEIGHT];
function _get_head_dia(n)    = _get_screw_fam(n)[_NB_F_HEAD_DIA];


