
// base functions and modules for the norm-boltnnuts package




// _get_screw("descriptor")   with descriptor = M8x25
//   find the line for a general object in the data matrix
function _get_screw(n) = data_screw[search([n], data_screw)[0]];

// _get_thread("descriptor")  with descriptor = M8
//   find the line for a certain object in the data matric
function _get_thread(n) = data_thread_head[search([n], data_thread_head)[0]];

// example ------------------------------
// data_screw = [	["M5x8", 5, 8, 1, 4.2],
//				    ["M5x20", 5, 20, 1, 4.2],
//				    ["M5x25", 5, 25, 1, 4.2] ];
// line = _get_screw("M5x20")