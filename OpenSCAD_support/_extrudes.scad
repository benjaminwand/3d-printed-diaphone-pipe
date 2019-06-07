// examples
/*
my_points = [[1, 2], [5, 2], [3, 8]];
my_extrude = 3;

color("yellow") xy_extrude_poly(my_points, my_extrude, false);
color("red") xz_extrude_poly(my_points, my_extrude, false);
color("blue") yz_extrude_poly(my_points, my_extrude, false);
*/

module xy_extrude(height, center, convexity, twist, slices, scale) {
	linear_extrude(height = height, center = center, convexity = convexity, twist = twist, slices = slices, scale = scale)
	children();
};

module xz_extrude(height, center, convexity, twist, slices, scale) {
	rotate([90, 0, 0])
	mirror([0, 0, 1])
	linear_extrude(height = height, center = center, convexity = convexity, twist = twist, slices = slices, scale = scale)
	children();
};

module yz_extrude(height, center, convexity, twist, slices, scale) {
	rotate([90, 0, 90])
	linear_extrude(height = height, center = center, convexity = convexity, twist = twist, slices = slices, scale = scale)
	children();
};

module xy_extrude_poly(points, height, center = true) {
	xy_extrude(height = height, center = center)
		polygon(points = points); 
};

module xz_extrude_poly(points, height, center = true) {
	xz_extrude(height = height, center = center)
		polygon(points = points); 
};

module yz_extrude_poly(points, height, center = true) {
	yz_extrude(height = height, center = center)
		polygon(points = points); 
};
