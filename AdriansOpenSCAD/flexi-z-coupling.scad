

screwsize=3;
pi = 3.1415926;

// Make a cuboid with a 45 degree top for vertical slots etc

module cen_hat(size)
{
	translate([0, 0, size.x/sqrt(2)])
		union()
		{
			rotate([0, 45, 0])
				cube([size.x, size.y, 5*max(size.x, max(size.y, size.z))], center=true);
			rotate([0, -45, 0])
				cube([size.x, size.y, 5*max(size.x, max(size.y, size.z))], center=true);
		}
}

module hat_cube(size = [1,1,1], center = false)
{
	difference()
	{
		cube(size, center);
		if(center)
			translate([0, 0, size.z/2])
				cen_hat(size);
		else
			translate([size.x/2, size.y/2, size.z])
				cen_hat(size);
	}
}

// Make a RepRap teardrop with its axis along Z
// If truncated is true, chop the apex; if not, come to a point

// I stole this function from Erik...

// If teardrop_angle is negative, this just gives an ordinary cylinder.  If it is zero or positive, the 
// teardrop is rotated through that angle.  Other arguments are as for the standard cylinder function.

module teardrop_internal(r=1.5, h=20, teardrop_angle=-1, truncateMM=0.5)
{
	if(teardrop_angle < 0)
		cylinder(r=r, h=h, center=false, $fn=max(2*r, 10));
	 else
		rotate([0, 0, teardrop_angle])
			union()
			{
				if(truncateMM > 0)
				{
					intersection()
					{
						translate([truncateMM,0,h/2]) 
							scale([1,1,h])
								cube([r*2.8275,r*2,1],center=true);
						scale([1,1,h]) 
								rotate([0,0,3*45])
									cube([r,r,1]);
					}
				} else
				{
					scale([1,1,h])
						rotate([0,0,3*45])
							cube([r,r,1]);
				}
				cylinder(r=r, h = h, center=false, $fn=max(2*r, 10));
		}
}

module teardrop(r=1.5, h=20, center=false, teardrop_angle=-1, truncateMM=0.5)
{
	if(center)
		translate([0, 0, -h/2])
			teardrop_internal(r=r, h=h, teardrop_angle=teardrop_angle, truncateMM=truncateMM);
	else
		teardrop_internal(r=r, h=h, teardrop_angle=teardrop_angle, truncateMM=truncateMM);
}



module tooth_gap(height = 10, number_of_teeth = 11, inner_radius = 10, dr = 3,  angle=7)
{
	linear_extrude(height = 2*height, center = true, convexity = 10, twist = 0)
		polygon( points = [
			[pi*inner_radius/(2*number_of_teeth), 0],
			[-pi*inner_radius/(2*number_of_teeth), 0],
			[-2*dr *sin(angle) - pi*inner_radius/(2*number_of_teeth), 2*dr],
			[2*dr *sin(angle) + pi*inner_radius/(2*number_of_teeth), 2*dr],
		], convexity = 3);
}

module trapezium(s=[1,2,3], center = false, angle = 10)
{
	difference()
	{
		cube([s.x + 1.1*s.z*tan(angle), s.y + 1.1*s.z*tan(angle), s.z], center=true);
		translate([s.x/2 + s.x/(2*cos(angle)),0,0])
			rotate([0,-angle,0])
				cube([s.x,3*s.y,3*s.z], center=true);
		translate([-s.x/2 - s.x/(2*cos(angle)),0,0])
			rotate([0,angle,0])
				cube([s.x,3*s.y,3*s.z], center=true);
		/*translate([0, s.y/2 + s.y/(2*cos(angle)),0])
			rotate([angle,0,0])
				cube([3*s.x,s.y,3*s.z], center=true);
		translate([0, -s.y/2 - s.y/(2*cos(angle)),0])
			rotate([-angle,0,0])
				cube([3*s.x,s.y,3*s.z], center=true);*/
	}
}


module key(height = 10,  inner_radius = 10, outer_radius = 12, angle=15)
{
	union()
	{
		trapezium([2*inner_radius, 2*outer_radius, height], center = true, angle = angle);
		rotate([0,0,90])
			trapezium([2*inner_radius, 2*outer_radius, height], center = true, angle = angle);
		//rotate([0,0,45])
			//trapezium([(5*inner_radius + 3*outer_radius)/4, (5*inner_radius + 3*outer_radius)/4, height], center = true, angle = angle);
	}
}

module flexi_male(hub_height=7.5, hub_radius = 9.5, shaft_radius = 2.5, height =13, inner_radius = 4.5, outer_radius = 6.5, angle=40)
{
	difference()
	{
		union()
		{
			translate([0,0,height/2])
				rotate([0,180,0])
					key(height =height, inner_radius = inner_radius, 
						outer_radius = outer_radius, angle=angle);
			translate([0,0,-hub_height/2])
				cylinder(h = hub_height, r = hub_radius,center=true,$fn=20);
		}
		
		cylinder(h = 30, r = shaft_radius, center=true,$fn=20);
		
		translate([shaft_radius + 2, 0, -hub_height/2])
			hat_cube([2.7,5.5,hub_height], center=true);
		translate([0,0,-hub_height/2])
			rotate([0,90,0])
				if(hub_radius >= outer_radius)
					teardrop(h = 2*hub_radius, r = screwsize/2, center=false, teardrop_angle=0, truncateMM=0.5);
				else
					rotate([0,0,180])
						teardrop(h = 2*hub_radius, r = screwsize/2, center=false, teardrop_angle=0, truncateMM=0.5);
	}
}

module flexi_female(hub_height=7.5, hub_radius = 9.5, shaft_radius = 2.5, height =13, inner_radius = 4.5, outer_radius = 6.5, angle=40)
{
	difference()
	{
		difference()
		{
			translate([0,0,-hub_height])
				cylinder(h = hub_height+height-0.25, r = hub_radius,$fn=20);
			translate([0,0,height/2])
					key(height =height, inner_radius = inner_radius, 
						outer_radius = outer_radius, angle=angle);
		}
		
		cylinder(h = 30, r = shaft_radius, center=true,$fn=20);
		
		translate([shaft_radius + 2, 0, -hub_height/2])
			hat_cube([2.7,5.5,hub_height], center=true);
		translate([0,0,-hub_height/2])
			rotate([0,90,0])
				if(hub_radius >= outer_radius)
					teardrop(h = 2*hub_radius, r = screwsize/2, center=false, teardrop_angle=0, truncateMM=0.5);
				else
					rotate([0,0,180])
						teardrop(h = 2*hub_radius, r = screwsize/2, center=false, teardrop_angle=0, truncateMM=0.5);
	}
}

module insert(height=10, inner_radius=2.5, outer_radius=4)
{
	difference()
	{
		cylinder(h = height, r = outer_radius,center=true,$fn=20);
		cylinder(h = height+3, r = inner_radius,center=true,$fn=20);
	}
}


//translate([0,0,30])
//rotate([0,180,0])
flexi_male(hub_height=10, hub_radius = 15, shaft_radius = 2.5, height =8, inner_radius = 3.5, outer_radius = 8, angle=15);

//flexi_female(hub_height=10, hub_radius = 15, shaft_radius = 4, height =10, inner_radius = 6, outer_radius = 9.5, angle=15);


//insert(height=10, inner_radius=2.5, outer_radius=4);


//trapezium();


