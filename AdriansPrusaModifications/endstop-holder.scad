// PRUSA Mendel  
// Endstop holder
// Used to attach endstops to 8mm rods
// GNU GPL v2
// Josef Průša
// josefprusa@me.com
// prusadjs.cz
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel

// Modified by Adrian to include support for sub-min microswitches and to make PCB mounts too. 15 May 2011

include <configuration.scad>

/**
 *@name Endstop holder
 *@using 1 m3x20
 *@using 1 m3nut
 *@using 2 m3washer
 */
module endstop(){
outer_diameter = m8_diameter/2+3.3;
screw_hole_spacing = 9.5; // Set to 20 to get standard design
opening_size = m8_diameter-1.5; //openingsize
switch_screw_hole_radius = 1.3; // Set to m3_diameter/2 to get standard design
pcb_mount=false; // Set false for endstop
translate([-outer_diameter, -outer_diameter, -5]) 
difference(){

	union(){


		translate([outer_diameter, outer_diameter, 0]) cylinder(h =10, r = outer_diameter, $fn = 20);
		translate([outer_diameter, 0, 0]) cube([15.5,outer_diameter*2,10]);
		if(!pcb_mount)
			translate([-42,0, 0]) cube([50, 4, 10]);
	}

	// Chop the end just after the hole

	translate([-(56+screw_hole_spacing+ switch_screw_hole_radius), -10, -10]) 
		cube([50, 50, 50]);

	translate([9, outer_diameter-opening_size/2, 0]) cube([18,opening_size,20]);
	translate([outer_diameter, outer_diameter, 0]) cylinder(h =20, r = m8_diameter/2, $fn = 18);
	translate([17, 17, 5]) rotate([90, 0, 0]) cylinder(h =20, r = m3_diameter/2, $fn = 10);
	translate([-4, 17, 5]) rotate([90, 0, 0]) cylinder(h =20, r = switch_screw_hole_radius, $fn = 10);
	translate([-(4+screw_hole_spacing), 17, 5]) rotate([90, 0, 0]) cylinder(h =20, r = switch_screw_hole_radius, $fn = 10);
}
}
endstop();

