// adjust those
pipe_diameter = 25 ;
pipe_wall_thickness = 2;
tube_diameter = 11;     // air suppy tube, doesn't matter if you use your mouth
rubber_thickness = 1;

// proportions
min_wall = 1.2 + pipe_diameter * 0.005;
inner_diameter = pipe_diameter * 0.5;
stuck_width = pipe_diameter * 0.15 + 4;
vibration_help = pipe_diameter * 0.01;
fn = round(pipe_diameter *2);

// inner part
//translate([0, 0, 2 * stuck_width + 2 * tube_diameter])
//rotate([180, 0, 45])
difference(){
    union(){
        rotate_extrude($fn=fn) polygon          // basic shape
            (points=[
                [pipe_diameter/2 - rubber_thickness - 1.5 * min_wall, vibration_help],
                [pipe_diameter/2 - rubber_thickness - 1.5 * min_wall, stuck_width + tube_diameter/2],
                [pipe_diameter/2 + min_wall, stuck_width + 2 * tube_diameter],
                [pipe_diameter/2 + min_wall, 2 * stuck_width + 2 * tube_diameter],
                [pipe_diameter/2, 2 * stuck_width + 2 * tube_diameter],
                [pipe_diameter/2, stuck_width + 2 * tube_diameter],
                [pipe_diameter/2 - pipe_wall_thickness, stuck_width + 2 * tube_diameter],
                [inner_diameter/2, stuck_width + tube_diameter/2],
                [inner_diameter/2, 0],
                [inner_diameter/2 + min_wall, 0],
                [inner_diameter/2 + min_wall, stuck_width + tube_diameter/2],
                [pipe_diameter/2 - pipe_wall_thickness + min_wall, stuck_width + 2 * tube_diameter -min_wall],
                [pipe_diameter/2 - rubber_thickness - 2.5 * min_wall, stuck_width + tube_diameter/2],
                [pipe_diameter/2 - rubber_thickness - 2.5 * min_wall, vibration_help]
                ]);
        difference(){                           // air supply cylinder
            translate ([0, 0, stuck_width + tube_diameter + min_wall])
                rotate ([0, 90, 0])
                    cylinder 
                        (pipe_diameter/2 + min_wall + stuck_width, 
                        tube_diameter/2 + min_wall, tube_diameter/2 + min_wall, $fn=fn/2);
            rotate_extrude($fn=fn) polygon
                (points=[
                    [pipe_diameter/2 - rubber_thickness - 2.5 * min_wall, stuck_width],
                    [pipe_diameter/2 + min_wall/2, stuck_width + 2 * tube_diameter],
                    [0, stuck_width + 2 * tube_diameter],
                    [0, 0]
                    ]);
        }            
    }
    difference(){
        union(){                                // cut-outs air supply cylinder
            translate ([pipe_diameter/2 + min_wall/2, 0, stuck_width + tube_diameter + min_wall])
                rotate ([0, 90, 0])
                    cylinder 
                        (inner_diameter/2 + min_wall + stuck_width, 
                        tube_diameter/2, tube_diameter/2, $fn=fn/2);
             translate ([0, 0, stuck_width + tube_diameter + min_wall])
                rotate ([0, 90, 0])
                    cylinder 
                        (pipe_diameter, tube_diameter*0.4, tube_diameter*0.4, $fn=fn/2);
             translate ([0, 0, stuck_width + tube_diameter + min_wall])
                rotate ([0, 90, 0])
                    cylinder 
                        (pipe_diameter/2 - min_wall/2, tube_diameter, tube_diameter*0.4, $fn=fn/2);
        }
        rotate_extrude($fn=fn) polygon
            (points=[
                [inner_diameter/2 + min_wall, 0],      
                [inner_diameter/2 + min_wall, stuck_width + tube_diameter/2],
                [pipe_diameter/2 - pipe_wall_thickness + min_wall, stuck_width + 2 * tube_diameter -min_wall],
                [0, stuck_width + 2 * tube_diameter],
                [0, 0]
                ]);
    }
}


/*
// outer part
translate([0, pipe_diameter, 0])
union(){
    difference(){
        cylinder(stuck_width, pipe_diameter/2 + min_wall, pipe_diameter/2 + min_wall, false, $fn=fn);
        translate([0, 0, -0.5])
            cylinder(stuck_width +1, pipe_diameter/2, pipe_diameter/2, false, $fn=fn);
    };
    difference(){
        cylinder(stuck_width, pipe_diameter/2 - rubber_thickness, pipe_diameter/2 - rubber_thickness, false, $fn=fn);
        translate([0, 0, -0.5])
            cylinder(stuck_width +1, pipe_diameter/2 - rubber_thickness -min_wall, pipe_diameter/2 - rubber_thickness - min_wall, false, $fn=fn);
    }
}
*/