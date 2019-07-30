include <OpenSCAD_support/_extrudes.scad>

// adjust those
pipe_diam = 60;
pipe_wall_thick = 2.5;
tube_diam = 11;                     // air suppy tube, doesn't matter if you use your mouth
rubber_thick = 1;                   // generator rubber

// proportions
height = sqrt(2) * pipe_diam;
min_wall = 1.2 + pipe_diam * 0.005;
inner_diam = pipe_diam - 2 * pipe_wall_thick;
stuck_width = pipe_diam * 0.15 + 3;
vib_help = pipe_diam * 0.01;            // vibration
screw_place = [ pipe_diam/3.5 + min_wall * 5, 
                height/3 + min_wall * 5 + rubber_thick ];
wedge_height = 0;                       // make sure the air can get through
screw_spacer = min_wall + 2;            // change this when adapting for different screws!!
fn = round(pipe_diam/2 + 30);
edge_slit_distance = pipe_diam/12;  
screw_length = 2 * min_wall + 1.5 * stuck_width + 3;
echo("your screws need to be at least" , screw_length , "mm long");
inner_height = sqrt(3) * height/4 + min_wall * 7 + rubber_thick;

//rotate([0, -90, 0])
union() {                               // pipe part
difference(){
    union(){                            // plus
        difference(){                   // basic shape
            rotate_extrude($fn=fn)
                polygon( points=[
                    [0, - height/2 - min_wall],
                    [pipe_diam/2 + min_wall, - height/2 - min_wall],
                    [pipe_diam/2 + min_wall, inner_height + stuck_width],
                    [pipe_diam/2, inner_height + stuck_width],
                    [pipe_diam/2, inner_height],
                    [inner_diam/2, inner_height],
                    [pipe_diam/2, 0],
                    [0, 0] ] );
            ellipse();                  // curved floor      
        };
        intersection(){                 // octagonal shape on back for print
            translate([0, 0, -height/2 - min_wall]) rotate([0, 0, 135])
                cube ([pipe_diam, pipe_diam, inner_height + min_wall + height/2 + stuck_width], false);
            difference(){
                rotate([0, 0, 22.5]) translate([0, 0, -height/2 -min_wall])
                    cylinder_outer( inner_height + min_wall + height/2 + stuck_width, 
                        pipe_diam/2 + min_wall, 8);
                translate([0, 0, -height/2])
                    cylinder (inner_height + min_wall + height/2 + stuck_width, pipe_diam/2, 
                        pipe_diam/2 + 0.01, false, $fn = fn);
            };
        };
        intersection(){                 // outer loft (but flat)
            hull(){        
                translate([-pipe_diam/2, - pipe_diam/2, - height/2 - min_wall])
                    cube ([0.01, pipe_diam, tube_diam + 2*min_wall], false);        
                translate([-pipe_diam/2 - min_wall + stuck_width, - pipe_diam/2, 
                    - height/2 - min_wall])
                    cube ([0.01, pipe_diam, tube_diam + 2*min_wall], false);
                intersection(){
                    translate([pipe_diam/4, - pipe_diam/2, - height/2 - min_wall])
                        cube ([0.01, pipe_diam, pipe_diam], false);
                    out_wedge();
                };     
            };
            cylinder(height + 2* min_wall, pipe_diam/2, pipe_diam/2, true);
        }; 
        difference(){
            intersection(){             // connection - pipe - generator
                translate ([pipe_diam/4 - min_wall, - pipe_diam/2, -height/2 - min_wall])
                    cube([pipe_diam/2, pipe_diam, inner_height + min_wall + height/2], false);
                translate ([0, 0, - height/2 - min_wall])
                    cylinder (inner_height + min_wall + height/2, pipe_diam/2, pipe_diam/2, false);
            };   
            ellipse();                  // making a hole into it       
        };   
    };
    union(){                            // minus
        hull(){                         // inner flue
            translate([-pipe_diam/2 - 2 * min_wall + stuck_width, 0, - height/2 + tube_diam * 0.5])
                rotate ([0, 90, 0]) cylinder(0.1, tube_diam * 0.4, tube_diam * 0.4, true);
            translate([0.1, 0, 0])
                intersection(){
                    in_wedge();
                    translate ([pipe_diam/4, - pipe_diam/2, -height/2 - min_wall])
                        cube([0.01, pipe_diam, height + min_wall], false);
                    ellipse();             
            };
        };
                                        // tube stuck thing
        translate([-pipe_diam/2 - min_wall - 0.01, 0, - height/2 + tube_diam*0.5])
            rotate ([0, 90, 0]) cylinder(stuck_width, tube_diam * 0.5, tube_diam * 0.5, false);       
                                        // spacer for generator
        translate([pipe_diam/4, - pipe_diam, - 2* height + inner_height - min_wall]) 
            cube([pipe_diam/2, 2* pipe_diam, 2* height]);  
                                        // screw holes
        for (i = [screw_place[0], - screw_place[0]])    
            for (j = [screw_place[1], - screw_place[1]])
                translate ([pipe_diam/4 - min_wall, i, j]) rotate ([0, -90, 0])
                    M3_spacer();
        for (i= [-screw_place[0], screw_place[0]])   // nut spacers in the bottom of the pipe
        hull(){                    
            translate ([pipe_diam/4 - min_wall, i, - screw_place[1]])
                rotate ([0, -90, 0]) cylinder( stuck_width, 3.1, 3.3, false, $fn = 6);
            translate ([pipe_diam/4 - min_wall, i, - screw_place[1] - stuck_width]) 
                rotate ([0, -90, 0]) cylinder( stuck_width, 3.5, 3.9, false, $fn = 6);   
        };
    };
};

difference(){                           // inner wall of generator
    difference(){    
        hull(){      
           intersection(){ 
                translate ([pipe_diam/4, - pipe_diam/2, - height/2 - min_wall])
                    cube([0.01, pipe_diam, height + min_wall], false);
                ellipse(xy = pipe_diam + 2 * min_wall, z = height + 2 * min_wall);
            }; 
            translate([pipe_diam/4 + 1.5 * stuck_width + vib_help, 0, 0]) 
                v_ellipse(
                xy = sqrt(3/4) * pipe_diam - edge_slit_distance *2, 
                z = sqrt(3/4) * height - edge_slit_distance *2);
        };
        in_wedge();
    };
    difference(){
        hull(){  
            translate ([ - 0.1, 0, 0])
            intersection(){ 
                translate ([pipe_diam/4, - pipe_diam/2, - height/2 - min_wall])
                    cube([0.01, pipe_diam, height + min_wall], false);
                ellipse();
            }; 
            translate([pipe_diam/4 + 1.5 * stuck_width + vib_help + 0.1, 0, 0]) 
                v_ellipse(
                xy = sqrt(3/4) * pipe_diam - edge_slit_distance *2 - min_wall*2, 
                z = sqrt(3/4) * height - edge_slit_distance *2 - min_wall*2);
        };   
        out_wedge();
    };
};
difference(){                           // outer wall generator
    hull(){      
        intersection(){ 
            translate ([pipe_diam/4, - pipe_diam, - height/2 - min_wall])
                cube([0.01, pipe_diam * 2, height + min_wall], false);
            ellipse(xy = pipe_diam + 2 * min_wall, z = height + 2 * min_wall);
        }; 
        translate ([stuck_width * 1.5, 0, 0])intersection(){    
            translate ([pipe_diam/4, - pipe_diam, - height/2 - min_wall])
                cube([0.01, pipe_diam * 2, height + min_wall], false);
            ellipse(xy = pipe_diam + 2 * min_wall, z = height + 2 * min_wall);
        }; 
    };
    hull(){  
        translate ([ - 0.1, 0, 0])intersection(){ 
            translate ([pipe_diam/4, - pipe_diam, - height/2 - min_wall])
                cube([0.01, pipe_diam * 2, height + min_wall], false);
            ellipse();
        }; 
        translate ([stuck_width * 1.5 + 0.1, 0, 0])intersection(){    
            translate ([pipe_diam/4, - pipe_diam, - height/2 - min_wall])
                cube([0.01, pipe_diam * 2, height + min_wall], false);
            ellipse();
        }; 
    };
};
};

//translate([ - stuck_width/2, - pipe_diam, min_wall]) rotate([0,90,0])
difference(){                           // inner ruber holder
    translate([ pipe_diam/4 + stuck_width/2, 0, 0])v_ellipse(
        xy = sqrt(3/4) * pipe_diam + min_wall * 8, z = sqrt(3/4) * height + min_wall * 8, xtr = stuck_width);
    translate([ pipe_diam/4 + stuck_width/2 - 0.1, 0, 0])v_ellipse(
        xy = sqrt(3/4) * pipe_diam + min_wall * 6, z = sqrt(3/4) * height + min_wall * 6, xtr = stuck_width + 0.2);  
};

//translate([ - stuck_width/2, pipe_diam + min_wall, min_wall]) rotate([0,90,0])
difference(){                           // outer rubber holder
    union(){
        translate([ pipe_diam/4 + stuck_width/2 - min_wall, 0, 0])v_ellipse(
            xy = sqrt(3/4) * pipe_diam + min_wall * 10 + rubber_thick * 2, 
            z = sqrt(3/4) * height + min_wall * 10 + rubber_thick * 2, 
            xtr = stuck_width + min_wall);
        hull(){                         // ears for screws
            for (i = [screw_place[0], - screw_place[0]])
                for (j = [screw_place[1], - screw_place[1]])
                translate ([pipe_diam/4 + stuck_width * 1.5 - min_wall, i, j]) rotate ([0, 90, 0])
                    cylinder (min_wall, screw_spacer, screw_spacer, false, $fn = fn/2);
        translate ([pipe_diam/4, 0, height/4]) sphere (1);
        translate ([pipe_diam/4, 0, - height/4]) sphere (1);                
        };    
    };    
    union(){           
        v_ellipse(                      // cut-out above 
            xy = sqrt(3/4) * pipe_diam + min_wall * 8 + rubber_thick * 2, 
            z = sqrt(3/4) * height + min_wall * 8 + rubber_thick * 2, 
            xtr = stuck_width * 1.5 + pipe_diam/4 - min_wall);
        v_ellipse(                      // cut-out lower 
            xy = sqrt(3/4) * pipe_diam + min_wall * 8 + rubber_thick, 
            z = sqrt(3/4) * height + min_wall * 8 + rubber_thick, 
            xtr = stuck_width * 1.5 + pipe_diam/4 + min_wall);   
                                        // screw spacers
        for (i = [screw_place[0], - screw_place[0]])    
            for (j = [screw_place[1], - screw_place[1]])
                translate ([pipe_diam/2 - stuck_width/2 + min_wall, i, j]) rotate ([0, 90, 0])
                    cylinder( stuck_width * 2, 1.6, 1.6, true, $fn = 15);
    };
};

module ellipse(xy = pipe_diam, z = height) resize (newsize=[xy, xy , z]) sphere(r=10, $fn=fn);

module v_ellipse(xy = sqrt(pipe_diam*pipe_diam*3/4), z = sqrt(height*height*3/4), xtr = 0.01) 
    rotate ([0, 90, 0])
        linear_extrude (xtr)   
            resize (newsize=[z, xy]) circle(r=10, $fn=fn);

module in_wedge() {
    //color("blue") 
    xz_extrude_poly(
    [[pipe_diam * 0.5 + 3* min_wall, - sqrt(3/4) * height/2 + edge_slit_distance],
    [pipe_diam * 0.5 + 3* min_wall, -height/2], 
    [0, -height/2],
    [0, - sqrt(3/4) * height/2 + edge_slit_distance + wedge_height]
    ], pipe_diam * 2, true);
};

module out_wedge() {
    //color("red") 
    xz_extrude_poly(
    [[pipe_diam * 0.5 + 3* min_wall, - sqrt(3/4) * height/2 + edge_slit_distance + min_wall],
    [pipe_diam * 0.5 + 3* min_wall, -height/2], 
    [0, -height/2],    
    [0, - sqrt(3/4) * height/2 + edge_slit_distance + wedge_height + min_wall]
    ], pipe_diam * 2, true);
};

module cylinder_outer(height,radius,fn){  	//from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/undersized_circular_objects
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module M3_spacer() {
    union(){
        cylinder( stuck_width, 3.1, 3.3, false, $fn = 6);
        translate([0, 0, -4.9])cylinder( 2 * stuck_width, 1.6, 1.6, true, $fn = 15);
    };
}

/*
todo:

* schrauben größe flexibel machen
** bis pipe_diam 30: M2.5
** bis pipe_diam 85: M3
** bis pipe_diam 130: M4
** größer pipe_diam 130: M5
*/