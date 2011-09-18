twelve_v=[-3,0,14];
mains=[35,0,14];
screw_holes=[0,13.5,-13.5];
clamp_holes=[0,-13,9];
right=[0,21,0];
top=[0,0,25];
foot_height=13.5;


module cable_clamp(tx=9)
{
	difference()
	{
		union()
		{
			translate([0,0,-1])
				cube([tx,10,21], center=true);
			translate([0,-4.5,6.5])
				cube([tx,4,7], center=true);
		}
		translate([0,-4.5,-12])
				cube([1.5,30,30], center=true);
	}
}

module ps_cover()
{

	difference()
	{
		union()
		{
			difference()
			{
				cube([120,42,54], center=true);
				translate([0,5,-5])
					cube([116,48,60], center=true);
				translate([0,47,5])
					rotate([30,0,0])
						cube([130,60,120], center=true);
			}

			difference()
			{
				translate([0,-12,-(27+foot_height/2)])
					difference()
					{
						cube([120,18,foot_height], center=true);
						translate([0,8,0])
							rotate([-20,0,0])
								cube([130,10,2*foot_height], center=true);
					}
				translate([0,-9.5,-(27+foot_height/2)])
					cube([116,19,foot_height], center=true);
				translate([0,-16,-(27+foot_height/2)])
					difference()
					{
						cube([100,10,foot_height], center=true);
						translate([50,0,0])
							rotate([0,-20,0])
								cube([10,20,2*foot_height], center=true);
						translate([-50,0,0])
							rotate([0,20,0])
								cube([10,20,2*foot_height], center=true);
					}
			}

			translate(twelve_v-right+[0,8,2])
				cable_clamp(tx=12);
			translate(mains-right+[0,8,2])
				cable_clamp(tx=16);
			translate(screw_holes+[62,0,0])
				rotate([0,90,0])
					cylinder(h=4,r1=7,r2=3.5,center=true,$fn=25);
			translate(screw_holes-[62,0,0])
				rotate([0,-90,0])
					cylinder(h=4,r1=7,r2=3.5,center=true,$fn=25);
		}

		translate(twelve_v)
			cube([4,148,7], center=true);
		
		translate(mains)
			rotate([90,0,0])
				cylinder(h=200,r=3.5,center=true,$fn=15);
		
		translate(screw_holes)
			rotate([0,90,0])
				cylinder(h=200,r=2.5,center=true,$fn=15);

		translate(clamp_holes)
			rotate([0,90,0])
				cylinder(h=200,r=2,center=true,$fn=15);

		translate(clamp_holes + [80,0,0])
			rotate([0,90,0])
				cylinder(h=50,r=3,center=true,$fn=15);
	}
}

module ps_foot()
{
	difference()
	{
		cylinder(h=foot_height,r1=7,r2=4.5,center=true,$fn=20);
		cylinder(h=foot_height,r=1.8,center=true,$fn=20);
		translate([0,0,foot_height/2-3.5/2])
			cylinder(h=foot_height-10,r=3,center=true,$fn=20);
	}
}


ps_cover();
translate([-10, 10, 20.25]) rotate([180, 0, 0]) ps_foot();
translate([10, 10, 20.25]) rotate([180, 0, 0]) ps_foot();


