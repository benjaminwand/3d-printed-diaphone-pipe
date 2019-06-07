include <OpenSCAD_support/_extrudes.scad>

// adjust those
pipe_diameter = 60;
pipe_wall_thickness = 2;
tube_diameter = 11;     // air suppy tube, doesn't matter if you use your mouth
rubber_thickness = 1;   // generator rubber

// proportions
min_wall = 1.2 + pipe_diameter * 0.005;
inner_diameter = pipe_diameter * 0.7;
stuck_width = pipe_diameter * 0.15 + 3;
vibration_help = pipe_diameter * 0.01;
screw_place = [pipe_diameter * 0.4, pipe_diameter * 0.9];
wedge_height = min_wall;
fn = round(pipe_diameter );

edge_slit_distance = 4;
inside_space_edge = 
    (pipe_diameter/2 - rubber_thickness - 3.5 * min_wall - inner_diameter/2) 
    > edge_slit_distance 
    ? inner_diameter/2 + min_wall
    : pipe_diameter/2 - rubber_thickness - 2.5 * min_wall - edge_slit_distance;
if (inside_space_edge < 5) echo("this pipe is too thin");

//Pipe part
difference(){
    union(){                        // plus
        rotate_extrude($fn=fn)     // basic shape
            polygon( points=[
                [0, - pipe_diameter - min_wall],
                [pipe_diameter/2 + min_wall, - pipe_diameter - min_wall],
                [pipe_diameter/2 + min_wall, - pipe_diameter - min_wall],
                [pipe_diameter/2 + min_wall, pipe_diameter + stuck_width + 3 * min_wall],
                [pipe_diameter/2, pipe_diameter + stuck_width + 3 * min_wall],
                [pipe_diameter/2, pipe_diameter + 3 * min_wall],
                [pipe_diameter/2 - pipe_wall_thickness, pipe_diameter + 3 * min_wall],
                [pipe_diameter/2 - pipe_wall_thickness, - pipe_diameter/2  - inside_space_edge + min_wall],
                [0, - pipe_diameter/2  - inside_space_edge + min_wall] ] );
        hull(){                     // outer flue
            translate([-pipe_diameter/2, 0, - pipe_diameter + tube_diameter*0.5])
                rotate ([0, 90, 0]) cylinder(0.1, tube_diameter * 0.5 + min_wall, tube_diameter * 0.5 + min_wall, true);
            translate ([0, 0, -pipe_diameter/2])
                rotate([0, 90,0]) rotate([0, 0, -35])
                    rotate_extrude(angle = 70, $fn=fn)     
                        polygon( points=[
            [pipe_diameter/2 - rubber_thickness - 1.5 * min_wall, pipe_diameter/2 - stuck_width * 1.5 + min_wall - 0.01],
            [inside_space_edge - min_wall, pipe_diameter/2 - stuck_width * 1.5 + min_wall- 0.01],
            [inside_space_edge - min_wall, pipe_diameter/2 - stuck_width * 1.5 + min_wall +  0.01],
            [pipe_diameter/2 - rubber_thickness - 1.5 * min_wall, pipe_diameter/2 - stuck_width * 1.5 + min_wall + 0.01]] );
        };
        intersection(){         // connection - pipe - generator
            translate ([pipe_diameter/2 - stuck_width * 1.5- min_wall, - pipe_diameter/2, -pipe_diameter - min_wall])
                cube([pipe_diameter/2, pipe_diameter, pipe_diameter * 2 + 4 * min_wall], false);
            translate ([0,0,  -pipe_diameter - min_wall])
                cylinder (pipe_diameter * 2 + 4 * min_wall, pipe_diameter/2, pipe_diameter/2, false);
        };   
    };
    union(){                        // minus
        hull(){                // inner flue
            translate([-pipe_diameter/2 - 2 * min_wall + stuck_width, 0, - pipe_diameter + tube_diameter * 0.5])
                rotate ([0, 90, 0]) cylinder(0.1, tube_diameter * 0.4, tube_diameter * 0.4, true);
            translate ([0, 0, -pipe_diameter/2])
                rotate([0, 90,0]) rotate([0, 0, -30])
                    rotate_extrude(angle = 60, $fn=fn)     
                        polygon( points=[
                        [pipe_diameter/2 - rubber_thickness - 2.5 * min_wall, pipe_diameter/2 - stuck_width * 1.5 + min_wall -  0.1],
                        [inside_space_edge, pipe_diameter/2 - stuck_width * 1.5 + min_wall- 0.1],
                        [inside_space_edge, pipe_diameter/2 - stuck_width * 1.5 + min_wall +  0.1],
                        [pipe_diameter/2 - rubber_thickness - 2.5 * min_wall, pipe_diameter/2 - stuck_width * 1.5 + min_wall + 0.1]] );
        };
                                // tube stuck thing
        translate([-pipe_diameter/2 - min_wall, 0, - pipe_diameter + tube_diameter*0.5])
            rotate ([0, 90, 0]) cylinder(stuck_width, tube_diameter * 0.5, tube_diameter * 0.5, false);
        hull(){                 // spacer for rubber holder
            for (i = [pipe_diameter/2, -pipe_diameter])
                translate ([pipe_diameter/2 - stuck_width * 1.5 + min_wall, 0, i]) rotate ([0, 90, 0])
                    cylinder (stuck_width * 1.5, pipe_diameter/2 + 1.5* min_wall, pipe_diameter/2 + 1.5 * min_wall, false, $fn = fn);
        };
        hull(){                // spacer for screw mechanics
            for (i = [screw_place[0], - screw_place[0]])
                for (j = [screw_place[1], - screw_place[1]])
                translate ([pipe_diameter/2 - stuck_width* 1.5 + min_wall, i, j]) rotate ([0, 90, 0])
                    cylinder (stuck_width * 1.5, 5, 5, false, $fn = fn/3);      
        };   
        hull(){                 // making hole in the connector between pipe and generator
            translate ([pipe_diameter/2 - stuck_width * 1.5 - min_wall, 0, pipe_diameter/2]) rotate ([0, 90, 0])
                cylinder (min_wall + 2, pipe_diameter/2- rubber_thickness - 2.5 * min_wall, pipe_diameter/2- rubber_thickness - 2.5 * min_wall, false, $fn = fn);        
            translate ([pipe_diameter/2 - stuck_width * 1.5 - min_wall - 0.5, 0, -pipe_diameter/2]) rotate ([0, 90, 0])
                cylinder (min_wall + 2, pipe_diameter/2- rubber_thickness - 2.5 * min_wall, pipe_diameter/2- rubber_thickness - 2.5 * min_wall, false, $fn = fn);
        };  
        for (i = [screw_place[0], - screw_place[0]])       // M4 screw holes
            for (j = [screw_place[1], - screw_place[1]])
            translate ([pipe_diameter/2 - stuck_width* 1.5, i, j]) rotate ([0, -90, 0])
            M4_spacer();
        hull(){      // m4 spacers in the bottom of the pipe
            translate ([pipe_diameter/2 - stuck_width* 1.5, screw_place[0], - screw_place[1]]) rotate ([0, -90, 0])
            cylinder( stuck_width, 4.1, 4.2, false, $fn = 6);
            translate ([pipe_diameter/2 - stuck_width* 1.5, screw_place[0], - screw_place[1] - stuck_width]) rotate ([0, -90, 0])
            cylinder( stuck_width, 4.1, 4.2, false, $fn = 6);   
        };
        hull(){
            translate ([pipe_diameter/2 - stuck_width* 1.5, -screw_place[0], - screw_place[1]]) rotate ([0, -90, 0])
            cylinder( stuck_width, 4.1, 4.2, false, $fn = 6);
            translate ([pipe_diameter/2 - stuck_width* 1.5, -screw_place[0], - screw_place[1] - stuck_width]) rotate ([0, -90, 0])
            cylinder( stuck_width, 4.1, 4.2, false, $fn = 6);   
        };
    };
};



difference(){           // inner wall of generator
    difference(){    
        hull(){
            translate ([pipe_diameter/2 - stuck_width * 1.5 + min_wall , 0, pipe_diameter/2]) rotate ([0, 90, 0])
                cylinder (stuck_width* 1.5 + vibration_help, pipe_diameter/2 - rubber_thickness - 1.5 * min_wall, inside_space_edge, false, $fn = fn);
            translate ([pipe_diameter/2 - stuck_width * 1.5 + min_wall , 0, -pipe_diameter/2]) rotate ([0, 90, 0])
                cylinder (stuck_width* 1.5 + vibration_help, pipe_diameter/2 - rubber_thickness - 1.5 * min_wall, inside_space_edge, false, $fn = fn);
        };
        in_wedge();
    };
    difference(){
        hull(){
            translate ([pipe_diameter/2 - stuck_width * 1.5 + min_wall -1, 0, pipe_diameter/2]) rotate ([0, 90, 0])
                cylinder (stuck_width * 1.5 + 2+ vibration_help, pipe_diameter/2- rubber_thickness - 2.5 * min_wall, inside_space_edge - min_wall, false, $fn = fn);        
            translate ([pipe_diameter/2 - stuck_width * 1.5 + min_wall -1, 0, -pipe_diameter/2]) rotate ([0, 90, 0])
                cylinder (stuck_width * 1.5 + 2+ vibration_help, pipe_diameter/2- rubber_thickness - 2.5 * min_wall, inside_space_edge - min_wall, false, $fn = fn);
        };    
    out_wedge();
    };
};

difference(){           // outer wall of generator
    hull(){
    for (i = [pipe_diameter/2, -pipe_diameter/2])
        translate ([pipe_diameter/2 - stuck_width * 1.5 + min_wall, 0, i]) rotate ([0, 90, 0])
            cylinder (stuck_width * 1.5, pipe_diameter/2 - rubber_thickness - 1.5 * min_wall, pipe_diameter/2 - rubber_thickness - 1.5 * min_wall, false, $fn = fn);
    };
    hull(){
    for (i = [pipe_diameter/2, -pipe_diameter/2])
        translate ([pipe_diameter/2 - stuck_width * 1.5 + min_wall -1, 0, i]) rotate ([0, 90, 0])
            cylinder (stuck_width * 1.5 + 2, pipe_diameter/2- rubber_thickness - 2.5 * min_wall, pipe_diameter/2 - rubber_thickness - 2.5 * min_wall, false, $fn = fn);
    };    
};


difference(){               // outer rubber holder
    union(){
        hull(){
            for (i = [pipe_diameter/2, -pipe_diameter/2])
                translate ([pipe_diameter/2 - stuck_width + min_wall, 0, i]) rotate ([0, 90, 0])
                    cylinder (stuck_width, pipe_diameter/2 + min_wall, pipe_diameter/2 + min_wall, false, $fn = fn);
        };
        hull(){
            for (i = [screw_place[0], - screw_place[0]])
                for (j = [screw_place[1], - screw_place[1]])
                translate ([pipe_diameter/2 , i, j]) rotate ([0, 90, 0])
                    cylinder (min_wall, 4, 4, false, $fn = fn/3);
        translate ([0, 0, pipe_diameter/2]) sphere (1);
        translate ([0, 0, - pipe_diameter/2]) sphere (1);                
        };    
    };    
    union(){
        hull(){
        for (i = [pipe_diameter/2, -pipe_diameter/2])
            translate ([- pipe_diameter/2 , 0, i]) rotate ([0, 90, 0])
                cylinder (pipe_diameter, pipe_diameter/2, pipe_diameter/2, false, $fn = fn);
        };
        hull(){
        for (i = [pipe_diameter/2, -pipe_diameter/2])
            translate ([pipe_diameter/2 - stuck_width + min_wall -1, 0, i]) rotate ([0, 90, 0])
                cylinder (stuck_width + 2, pipe_diameter/2 - min_wall/2, pipe_diameter/2 - min_wall/2, false, $fn = fn);
        };             
        for (i = [screw_place[0], - screw_place[0]])
            for (j = [screw_place[1], - screw_place[1]])
            translate ([pipe_diameter/2 - stuck_width/2 + min_wall, i, j]) rotate ([0, 90, 0])
            cylinder( stuck_width * 2, 2.1, 2.1, true, $fn = 15);
    };
};

difference(){           // inner ruber holder
    hull(){
    for (i = [pipe_diameter/2, -pipe_diameter/2])
        translate ([pipe_diameter/2 - stuck_width + 2* min_wall, 0, i]) rotate ([0, 90, 0])
            cylinder (stuck_width -min_wall, pipe_diameter/2 - rubber_thickness, pipe_diameter/2 - rubber_thickness, false, $fn = fn);
    };
    hull(){
    for (i = [pipe_diameter/2, -pipe_diameter/2])
        translate ([pipe_diameter/2 - stuck_width + 2* min_wall -1, 0, i]) rotate ([0, 90, 0])
            cylinder (stuck_width + 2, pipe_diameter/2- rubber_thickness -min_wall, pipe_diameter/2 - rubber_thickness -min_wall, false, $fn = fn);
    };    
};
/*
in_wedge();
out_wedge();
*/
module in_wedge() {
    //color("blue") 
    xz_extrude_poly(
    [[pipe_diameter/2 + min_wall  + vibration_help, -pipe_diameter/2 - inside_space_edge], 
    [pipe_diameter/2 + min_wall  + vibration_help, -pipe_diameter], 
    [0, -pipe_diameter],
    [0, -pipe_diameter/2 - inside_space_edge],
    [0, -pipe_diameter/2 - inside_space_edge + wedge_height]
    ], pipe_diameter, true);
};

module out_wedge() {
    //color("red") 
    xz_extrude_poly(
    [[pipe_diameter/2 + min_wall + vibration_help, -pipe_diameter/2 - inside_space_edge], 
    [pipe_diameter/2 + min_wall  + vibration_help, -pipe_diameter], 
    [0, -pipe_diameter],    
    [0, -pipe_diameter/2 - inside_space_edge],
    [0, -pipe_diameter/2 - inside_space_edge + wedge_height + min_wall],
    [pipe_diameter/2 + min_wall + vibration_help, -pipe_diameter/2 - inside_space_edge + min_wall]
    ], pipe_diameter, true);
};

module M4_spacer() {
    union(){
        cylinder( stuck_width, 4.1, 4.2, false, $fn = 6);
        translate([0, 0, -4.9])cylinder( stuck_width * 2, 2.1, 2.1, true, $fn = 15);
    };
};

/*

todo:
* richtiges flue loft machen mit polyhedron
oder unterseite von 'inner wall of generator' anpassen
*/