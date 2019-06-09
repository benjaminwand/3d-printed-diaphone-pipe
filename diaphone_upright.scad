include <OpenSCAD_support/_extrudes.scad>

// adjust those
pipe_diam = 60;
pipe_wall_thick = 2;
tube_diam = 11;     // air suppy tube, doesn't matter if you use your mouth
rubber_thick = 1;   // generator rubber

// proportions
min_wall = 1.2 + pipe_diam * 0.005;
inner_diam = pipe_diam * 0.7;
stuck_width = pipe_diam * 0.15 + 3;
vib_help = pipe_diam * 0.01;            // vibration
screw_place = 
    [(pipe_diam/2 + min_wall+1.6)/sqrt(2), pipe_diam/2 + (pipe_diam/2 + min_wall+1.6)/sqrt(2)];
wedge_height = 0;
fn = round(pipe_diam + 10);

edge_slit_distance = 4;
inside_space_edge = 
    (pipe_diam/2 - rubber_thick - 3.5 * min_wall - inner_diam/2) 
    > edge_slit_distance 
    ? inner_diam/2 + min_wall
    : pipe_diam/2 - rubber_thick - 2.5 * min_wall - edge_slit_distance;
if (inside_space_edge < 5) echo("this pipe is too thin");
    
screw_length = 2 * min_wall + 1.5 * stuck_width + 3;
echo("your screws need to be" , screw_length , "mm long");
           
rotate([0, -90, 0])
union() {                                   //Pipe part
difference(){
    union(){                                // plus
        difference(){                       // basic shape
            rotate_extrude($fn=fn)
                polygon( points=[
                    [0, - pipe_diam - min_wall],
                    [pipe_diam/2 + min_wall, - pipe_diam - min_wall],
                    [pipe_diam/2 + min_wall, - pipe_diam - min_wall],
                    [pipe_diam/2 + min_wall, pipe_diam + stuck_width + 3 * min_wall],
                    [pipe_diam/2, pipe_diam + stuck_width + 3 * min_wall],
                    [pipe_diam/2, pipe_diam + 3 * min_wall],
                    [pipe_diam/2 - pipe_wall_thick, pipe_diam + 3 * min_wall],
                    [pipe_diam/2 - pipe_wall_thick, -pipe_diam/2],
                    [0, -pipe_diam/2] ] );
            translate([0, 0, -pipe_diam/2])     // curved floor
                sphere (pipe_diam/2 - pipe_wall_thick, $fn=fn);         
        };
        intersection(){                     // octagon on back for print
            translate([0, 0, -pipe_diam - min_wall]) rotate([0, 0, 135])
                cube ([ pipe_diam, pipe_diam, 2 * pipe_diam + 4 * min_wall + stuck_width], false);
            difference(){
                rotate([0, 0, 22.5]) translate([0, 0, -pipe_diam -min_wall])
                    cylinder_outer(2 * pipe_diam + 4 * min_wall + stuck_width, pipe_diam/2 + min_wall, 8);
                translate([0, 0, -pipe_diam])
                    cylinder (2 * pipe_diam + 4 * min_wall + stuck_width, pipe_diam/2, pipe_diam/2 + 0.01, false, $fn = fn);
            };
        };
        intersection(){                    // outer loft (but flat)
            hull(){
                translate([-pipe_diam/2, - pipe_diam/2, - pipe_diam + tube_diam*0.5 - tube_diam/2 - min_wall])
                        cube ([0.01, pipe_diam, tube_diam + 2*min_wall], false);        
                translate([-pipe_diam/2 - min_wall + stuck_width, - pipe_diam/2, - pipe_diam + tube_diam*0.5 - tube_diam/2 - min_wall])
                    cube ([0.01, pipe_diam, tube_diam + 2*min_wall], false);
                intersection(){
                    translate([pipe_diam/2 - 1.5 * stuck_width + min_wall, - pipe_diam/2, - pipe_diam + tube_diam*0.5 - tube_diam/2 - min_wall])
                        cube ([0.01, pipe_diam, pipe_diam], false);
                    out_wedge();
                };     
            };
            cylinder(2 * pipe_diam, pipe_diam/2, pipe_diam/2, true);
        }; 
        difference(){
            intersection(){         // connection - pipe - generator
                translate ([pipe_diam/2 - stuck_width * 1.5, - pipe_diam/2, -pipe_diam - min_wall])
                    cube([pipe_diam/2, pipe_diam, pipe_diam * 2 + 4 * min_wall], false);
                translate ([0,0,  -pipe_diam - min_wall])
                    cylinder (pipe_diam * 2 + 4 * min_wall, pipe_diam/2, pipe_diam/2, false);
            };   
            hull(){                 // making hole in the connector between pipe and generator
                translate ([pipe_diam/2 - stuck_width * 1.5 - min_wall + 0.5, 0, pipe_diam/2]) 
                    rotate ([0, 90, 0])
                        cylinder (min_wall + 2, pipe_diam/2- rubber_thick - 3 * min_wall, pipe_diam/2- rubber_thick - 3 * min_wall, false, $fn = fn);        
                translate ([pipe_diam/2 - stuck_width * 1.5 - min_wall + 0.5, 0, -pipe_diam/2]) 
                    rotate ([0, 90, 0])
                        cylinder (min_wall + 2, pipe_diam/2- rubber_thick - 3 * min_wall, pipe_diam/2- rubber_thick - 3 * min_wall, false, $fn = fn);
            };         
        };   
    };
    union(){                        // minus
        hull(){                // inner flue
            translate([-pipe_diam/2 - 2 * min_wall + stuck_width, 0, - pipe_diam + tube_diam * 0.5])
                rotate ([0, 90, 0]) cylinder(0.1, tube_diam * 0.4, tube_diam * 0.4, true);
            translate([0.01, 0, 0])
                intersection(){
                    in_wedge();
                    translate([pipe_diam/2 - 1.5 * stuck_width + min_wall,0, -pipe_diam/2]) rotate([0, 90, 0])
                   cylinder(0.01, pipe_diam/2- rubber_thick - 2.5 * min_wall, pipe_diam/2- rubber_thick - 2.5 * min_wall, true, $fn = fn);
            };
        };
                                // tube stuck thing
        translate([-pipe_diam/2 - min_wall - 0.01, 0, - pipe_diam + tube_diam*0.5])
            rotate ([0, 90, 0]) cylinder(stuck_width, tube_diam * 0.5, tube_diam * 0.5, false);
        hull(){                 // spacer for rubber holder
            for (i = [pipe_diam/2, -pipe_diam])
                translate ([pipe_diam/2 - stuck_width * 1.5 + min_wall, 0, i]) rotate ([0, 90, 0])
                    cylinder (stuck_width * 1.5, pipe_diam/2 + 1.5* min_wall, pipe_diam/2 + 1.5 * min_wall, false, $fn = fn);
        };
        hull(){                // spacer for screw mechanics
            for (i = [screw_place[0], - screw_place[0]])
                for (j = [screw_place[1], - screw_place[1]])
                translate ([pipe_diam/2 - stuck_width* 1.5 + min_wall, i, j]) rotate ([0, 90, 0])
                    cylinder (stuck_width * 1.5, 5, 5, false, $fn = fn/3);      
        };   
        for (i = [screw_place[0], - screw_place[0]])       // M3 screw holes
            for (j = [screw_place[1], - screw_place[1]])
            translate ([pipe_diam/2 - stuck_width* 1.5, i, j]) rotate ([0, -90, 0])
            M3_spacer();
        hull(){      // m3 spacers in the bottom of the pipe
            translate ([pipe_diam/2 - stuck_width* 1.5, screw_place[0], - screw_place[1]]) rotate ([0, -90, 0])
            cylinder( stuck_width, 3.1, 3.3, false, $fn = 6);
            translate ([pipe_diam/2 - stuck_width* 1.5, screw_place[0], - screw_place[1] - stuck_width]) rotate ([0, -90, 0])
            cylinder( stuck_width, 3.1, 3.3, false, $fn = 6);   
        };
        hull(){
            translate ([pipe_diam/2 - stuck_width* 1.5, -screw_place[0], - screw_place[1]]) rotate ([0, -90, 0])
            cylinder( stuck_width, 3.1, 3.3, false, $fn = 6);
            translate ([pipe_diam/2 - stuck_width* 1.5, -screw_place[0], - screw_place[1] - stuck_width]) rotate ([0, -90, 0])
            cylinder( stuck_width, 3.1, 3.3, false, $fn = 6);   
        };
    };
};

difference(){           // inner wall of generator
    difference(){    
        hull(){
            translate ([pipe_diam/2 - stuck_width * 1.5, 0, pipe_diam/2]) rotate ([0, 90, 0])
                cylinder (stuck_width* 1.5 + vib_help + min_wall, pipe_diam/2 - rubber_thick - 1.5 * min_wall, inside_space_edge, false, $fn = fn);
            translate ([pipe_diam/2 - stuck_width * 1.5, 0, -pipe_diam/2]) rotate ([0, 90, 0])
                cylinder (stuck_width* 1.5 + vib_help + min_wall, pipe_diam/2 - rubber_thick - 1.5 * min_wall, inside_space_edge, false, $fn = fn);
        };
        in_wedge();
    };
    difference(){
        hull(){
            translate ([pipe_diam/2 - stuck_width * 1.5 -1, 0, pipe_diam/2]) rotate ([0, 90, 0])
                cylinder (stuck_width * 1.5 + 2+ vib_help + min_wall, pipe_diam/2- rubber_thick - 3 * min_wall, inside_space_edge - min_wall, false, $fn = fn);        
            translate ([pipe_diam/2 - stuck_width * 1.5 -1, 0, -pipe_diam/2]) rotate ([0, 90, 0])
                cylinder (stuck_width * 1.5 + 2+ vib_help + min_wall, pipe_diam/2- rubber_thick - 3 * min_wall, inside_space_edge - min_wall, false, $fn = fn);
        };    
    out_wedge();
    };
};

difference(){           // outer wall of generator
    hull(){
    for (i = [pipe_diam/2, -pipe_diam/2])
        translate ([pipe_diam/2 - stuck_width * 1.5 + min_wall, 0, i]) rotate ([0, 90, 0])
            cylinder (stuck_width * 1.5, pipe_diam/2 - rubber_thick - 1.5 * min_wall, pipe_diam/2 - rubber_thick - 1.5 * min_wall, false, $fn = fn);
    };
    hull(){
    for (i = [pipe_diam/2, -pipe_diam/2])
        translate ([pipe_diam/2 - stuck_width * 1.5 + min_wall -1, 0, i]) rotate ([0, 90, 0])
            cylinder (stuck_width * 1.5 + 2, pipe_diam/2- rubber_thick - 2.5 * min_wall, pipe_diam/2 - rubber_thick - 2.5 * min_wall, false, $fn = fn);
    };    
};
};

translate([ - stuck_width/2, pipe_diam + min_wall, 0]) rotate([0,90,0])
union(){
difference(){               // outer rubber holder
    union(){
        hull(){
            for (i = [pipe_diam/2, -pipe_diam/2])
                translate ([pipe_diam/2 - stuck_width + min_wall, 0, i]) rotate ([0, 90, 0])
                    cylinder (stuck_width, pipe_diam/2 + min_wall, pipe_diam/2 + min_wall, false, $fn = fn);
        };
        hull(){
            for (i = [screw_place[0], - screw_place[0]])
                for (j = [screw_place[1], - screw_place[1]])
                translate ([pipe_diam/2 , i, j]) rotate ([0, 90, 0])
                    cylinder (min_wall, 3.5, 3.5, false, $fn = fn/2);
        translate ([0, 0, pipe_diam/2]) sphere (1);
        translate ([0, 0, - pipe_diam/2]) sphere (1);                
        };    
    };    
    union(){
        hull(){
        for (i = [pipe_diam/2, -pipe_diam/2])
            translate ([- pipe_diam/2 , 0, i]) rotate ([0, 90, 0])
                cylinder (pipe_diam, pipe_diam/2, pipe_diam/2, false, $fn = fn);
        };
        hull(){
        for (i = [pipe_diam/2, -pipe_diam/2])
            translate ([pipe_diam/2 - stuck_width + min_wall -1, 0, i]) rotate ([0, 90, 0])
                cylinder (stuck_width + 2, pipe_diam/2 - min_wall/2, pipe_diam/2 - min_wall/2, false, $fn = fn);
        };             
        for (i = [screw_place[0], - screw_place[0]])
            for (j = [screw_place[1], - screw_place[1]])
            translate ([pipe_diam/2 - stuck_width/2 + min_wall, i, j]) rotate ([0, 90, 0])
            cylinder( stuck_width * 2, 1.6, 1.6, true, $fn = 15);
    };
};

difference(){           // inner ruber holder
    hull(){
    for (i = [pipe_diam/2, -pipe_diam/2])
        translate ([pipe_diam/2 - stuck_width + 2* min_wall, 0, i]) rotate ([0, 90, 0])
            cylinder (stuck_width -min_wall, pipe_diam/2 - rubber_thick, pipe_diam/2 - rubber_thick, false, $fn = fn);
    };
    hull(){
    for (i = [pipe_diam/2, -pipe_diam/2])
        translate ([pipe_diam/2 - stuck_width + 2* min_wall -1, 0, i]) rotate ([0, 90, 0])
            cylinder (stuck_width + 2, pipe_diam/2- rubber_thick -min_wall, pipe_diam/2 - rubber_thick -min_wall, false, $fn = fn);
    };    
};
};

module in_wedge() {
    //color("blue") 
    xz_extrude_poly(
    [[pipe_diam/2 + min_wall  + vib_help, -pipe_diam/2 - inside_space_edge], 
    [pipe_diam/2 + min_wall  + vib_help, -pipe_diam], 
    [0, -pipe_diam],
    [0, -pipe_diam/2 - inside_space_edge],
    [0, -pipe_diam/2 - inside_space_edge + wedge_height]
    ], pipe_diam, true);
};

module out_wedge() {
    //color("red") 
    xz_extrude_poly(
    [[pipe_diam/2 + min_wall + vib_help, -pipe_diam/2 - inside_space_edge], 
    [pipe_diam/2 + min_wall  + vib_help, -pipe_diam], 
    [0, -pipe_diam],    
    [0, -pipe_diam/2 - inside_space_edge],
    [0, -pipe_diam/2 - inside_space_edge + wedge_height + min_wall],
    [pipe_diam/2 + min_wall + vib_help, -pipe_diam/2 - inside_space_edge + min_wall]
    ], pipe_diam, true);
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
* muttern-löcher flacher machen
* refactorn (mehr for-i-hull)
* Parameter für Höhe einführen
* schrauben größe flexibel machen
** bis pipe_diam 30: M2.5
** bis pipe_diam 40: M3
** bis pipe_diam 80: M4
** größer pipe_diam 80: M5
* für sehr große pfeifen (200): generator wieder an pfeife kleben
*/