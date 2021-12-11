//
// 2D Koch Snowflake Ornament
// Christopher Bero <bigbero@gmail.com>
//

level = 5; // Levels of recursion
l = 30; // Base length
base = [[0, 0], [l/2, sin(60)*l], [l, 0]];

// Returns point that is "frac" fraction from p1 to p2
function point_between(frac, p1, p2) = [
	( ((frac) * (p2.x - p1.x)) + p1.x ), 
	( ((frac) * (p2.y - p1.y)) + p1.y )];

// Returns point that is 1/3rd distance from p1 to p2
function pt_1_third(p1, p2) = point_between((1/3), p1, p2);

// Returns point that is 2/3rd distance from p1 to p2
function pt_2_third(p1, p2) = point_between((2/3), p1, p2);

// Returns point that is 1/2 distance from p1 to p2
function pt_1_half(p1, p2) = point_between((1/2), p1, p2);

// Returns slope between p1 and p2
function slope(p1, p2) = (p2.y - p1.y) / (p2.x - p1.x);

// Returns the perpendicular slope of m
function perp_slope(m) = ( (-1) * (1/m) );

// Returns the distance between p1 and p2
function dist(p1, p2) = sqrt( (p2.x - p1.x)^2 + (p2.y - p1.y)^2 );

// Returns 1 or -1 to solve for convex
function edge_decider(p1, p2) = ( (p2.y - p1.y) >= 0 ? 
	p2.y == p1.y && (p2.x - p1.x) >= 0 ?
		1 : 
		-1 :
	1 );

// Returns a list of vectors with the koch curve inside
function koch_curve(p1, p2) = [
  p1,
	pt_1_third(p1, p2),
	[(pt_1_half(p1, p2).x) + edge_decider(p1, p2) * ( (tan(60) * dist(pt_1_third(p1, p2), pt_1_half(p1, p2))) * sqrt(1/(1 + (perp_slope(slope(p1, p2))^2))) ),
	slope(p1, p2) == 0 ?
		(pt_1_half(p1, p2).y) + edge_decider(p1, p2) * (tan(60) * dist(pt_1_third(p1, p2), pt_1_half(p1, p2)) ) : 
		(pt_1_half(p1, p2).y) + edge_decider(p1, p2) * ( (perp_slope(slope(p1, p2))) * (tan(60) * dist(pt_1_third(p1, p2), pt_1_half(p1, p2))) * sqrt(1/(1+((perp_slope(slope(p1, p2)))^2))) )],
	pt_2_third(p1, p2)
];

// Feed one line segment into koch_curve at a time
function parse_pts(pts, i) = i == (len(pts) - 1) ? 
	koch_curve(pts[i], pts[0]) :
	concat(koch_curve(pts[i], pts[i+1]), parse_pts(pts, i+1));

function recurse(n, pts) = n == 0 ? 
	parse_pts(pts, 0) : 
	parse_pts(recurse(n-1, pts), 0);

module assembly() {
	r = recurse(level, base);
	
	echo("New base: ", r);
	linear_extrude(2)
		polygon(r);
}

assembly();



