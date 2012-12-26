
// base functions and modules for the norm-boltnnuts package




// get_line("descriptor")
//   find the line for a certain bolt in the data matrix
function get_line(n) = data[search([n], data)[0]];

// example ------------------------------
// data = [	["M5x8", 5, 8, 1, 4.2],
//			["M5x20", 5, 20, 1, 4.2],
//			["M5x25", 5, 25, 1, 4.2] ];
// line = get_line("M5x20")