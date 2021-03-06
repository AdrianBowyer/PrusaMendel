// PRUSA Mendel  
// Bushings
// GNU GPL v2
// Josef Pra
// josefprusa@me.com
// prusadjs.cz
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel

// Print them in PLA and glue them to place
// if they are too tight, define bigger rodsize
// or you can try to sand a bt off


// TYPE Can generate three versions
// 1 - regular old ones
// 2 - helical ones
// 3 - holders for brass or any other bought bushings

// Modified by Adrian to put 4 on a raft - they print better, and you don't want 12 at once as
// that makes arranging the STLs on the bed more complicated.  23 May 2011

include <configuration.scad>

rodsize = bushing_rodsize;
outerDiameter = bushing_outerDiameter;
lenght = bushing_lenght;
type = bushing_type;


module bushing_core_straight(){
union(){
	rotate(a=[0,0,45])
	difference(){
		union(){
			//outer ring
			difference(){
				union(){
					cylinder(h = lenght, r=outerDiameter/2); //1mm lemovn
					//cylinder(h = 1, r=outerDiameter/2+2);
				}
				translate(v=[0,0,-1]) cylinder(h = lenght+2, r=(outerDiameter/2)-2);
			}

			//nipples inside touching the rod
			difference(){
				union(){
					translate(v=[0,0,lenght/2]) cube(size = [outerDiameter-1,2,lenght], center = true);
					translate(v=[0,0,lenght/2]) cube(size = [2,outerDiameter-1,lenght], center = true);
				}
				translate(v=[0,0,-1]) cylinder(h = lenght+2, r=rodsize/2, $fn=20);
			}
		}
		//opening cutout
		translate(v=[(outerDiameter/2)+1,(outerDiameter/2)+1,(lenght)/2]) cube(size = [outerDiameter,outerDiameter,lenght+2], center = true);
		
		}
	}
}
module bushing_core_holder(){
union(){
	rotate(a=[0,0,45])
	difference(){
		union(){
			//outer ring
			difference(){
				union(){
					cylinder(h = lenght, r=outerDiameter/2); //1mm lemovn
					//cylinder(h = 1, r=outerDiameter/2+2);
				}
				translate(v=[0,0,-1]) cylinder(h = lenght+2, r=(rodsize/2));
			}
		}
		//opening cutout
		translate(v=[(outerDiameter/2)+1,(outerDiameter/2)+1,(lenght)/2]) cube(size = [outerDiameter,outerDiameter,lenght+2], center = true);
		
		}
	}
}

module bushing_core_helical(){
	difference(){
		rotate(a=[0,0,44]) translate(v=[0,0,(lenght)/2]) linear_extrude(center = true, height = lenght, twist = 90,convexity = 20) projection(cut = true) bushing_core_straight();
		translate(v=[0,-2.3,0]) rotate(a=[0,0,45]) translate(v=[(outerDiameter/2)+1,(outerDiameter/2)+1,(lenght)/2]) cube(size = [outerDiameter,outerDiameter,lenght+2], center = true);
		// hack for easier cleanup
		translate(v=[0,0,-0.5]) cylinder(h = 1, r=rodsize/2+1, $fn=20);
	}
}

module bushing(){
	difference(){
		translate(v=[0,-outerDiameter/4,lenght/2]) cube(size = [outerDiameter, outerDiameter/2,lenght], center = true);
		translate(v=[0,0,-1]) cylinder(h = lenght+2, r=(outerDiameter/2)-2);//
	}
	if(type == 1){
		bushing_core_straight();
	}
	if(type == 2){
		bushing_core_helical();
	}
	if(type == 3){
		bushing_core_holder();
	}
}

// A single bushing.

// bushing();


// Four bushings on a break-away tab.  Makes them stick to
// the print bed better.

union()
{
	for(x=[0:1])
		translate([19*x,0,0])
		{
			rotate([0,0,180])
			bushing();
			translate([0,20,0])
			bushing();
		}
	translate([-10,-7,0])
	cube([38,34,0.4]);
}