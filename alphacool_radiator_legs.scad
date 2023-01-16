$fn=50;

// set this to true to generate a double sided leg
export_double_sided_leg=false;

// total height of this thing. This can be arbitrarily long - screws will be
// sunk in based on the screw length definition, but you'll need a screwdriver
// long enough screwdriver narrower than the screw head to reach the screw.
leg_height=40;

// screw length without thread and head
// 26 works fine for the 30mm screws included with the radiator -
// assuming you used the 35mm screws for fan mounting.
screw_height=26;

// the remaining settings should only be relevant when using screws other than
// M3, or trying to adjust it to a non-alphacool radiator, or a radiator with
// fans other than 14cm

// diameter with a bit of tolerance. 3.4 gives a nice fit for M3 screws
screw_diameter=3.4;
// 7.8 should be a good fit for M3 screws
screw_head_diameter=7.8;
// length of the small wall piece facing the sides. Technically also the
// beginnings of the longer wall, but there it's swallowed by the wall anyway.
outside_wall_length=25;
// offset of the center of the screw hole from the sides of the leg
// 5 works well to have a slight rim around the head of a M3 screw
// while not overlapping with radiator finns
hole_offset=5;
// distance between the two mounting holes. 135-136 seems to be
// the right distance for 140mm fan mounts.
hole_distance=136;
// thickness of the wall connecting the two corners
wall_width=3;
// the radious of the round cutout of the side triangles. 22 pretty much matches
// the shroud of alphacool radiators
inner_cutout_r=22;
// spacing when exporting a double sided leg
double_leg_hole_distance=14;

// this builds supports for one corner with a wall section to the
// middle of the radiator
module fan_corner_support(){
  difference(){
    linear_extrude(height=leg_height){
      polygon(points=[[0,0],[outside_wall_length,0],[0,outside_wall_length]], paths=[[0,1,2]],convexity=10);
      square(size=[hole_distance/2,wall_width], center=false);
    }
    translate([hole_offset, hole_offset, 0]){
      cylinder(r=screw_diameter/2,h=screw_height);
      translate([0,0,screw_height]){
        cylinder(r=screw_head_diameter/2,leg_height-screw_height);
      }
    }
    translate([outside_wall_length,outside_wall_length,0]){
      cylinder(r=inner_cutout_r,h=leg_height);
    }
  }
}

// this just mirrors and moves a second corner support, generating a full
// leg mountable on two corners with a thin wall, suitable for the legs
// left and right of the radiator
module fan_side_support(){
  fan_corner_support();

  translate([hole_distance,0,0]){
    mirror([1,0,0]){fan_corner_support();}
  }
}

fan_side_support();
if (export_double_sided_leg){
  translate([0,(double_leg_hole_distance-screw_diameter-hole_offset)*-1,0]){
    linear_extrude(height=leg_height){
      square(size=[hole_distance, double_leg_hole_distance-screw_diameter-hole_offset], center=false);
    }
    mirror([0,1,0]){fan_side_support();}
  }
}
