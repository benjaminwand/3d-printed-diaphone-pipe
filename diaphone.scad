// adjust those
pipe_diameter = 25.1;
tube_diameter = 11;     // air suppy tube, doesn't matter if you use your mouth
rubber_thickness = 1;

// probably don't change those
min_wall = 1.2;

// proportions
inner_diameter = pipe_diameter * 1.25;
stuck_width = 3 + pipe_diameter*0.15;


// inner part
difference(){
    union(){
        rotate_extrude($fn=50) polygon
            (points=[
                [0, 0],
                [inner_diameter/2 + min_wall,0],
                [inner_diameter/2 + min_wall, stuck_width + min_wall*4 + tube_diameter],
                [pipe_diameter/2 + min_wall, stuck_width*2 + min_wall*4 + tube_diameter],
                [0, stuck_width + min_wall*10 + tube_diameter]]);
        translate ([0, 0, stuck_width + min_wall*2 + tube_diameter/2+ rubber_thickness])
            rotate ([0, 90, 0])
                cylinder 
                    (inner_diameter/2 + min_wall + stuck_width, 
                    tube_diameter/2 + min_wall, tube_diameter/2 + min_wall);
    };
     union(){
        rotate_extrude($fn=50) polygon
            (points=[
                [0, -1],
                [inner_diameter/2, -1],
                [inner_diameter/2, stuck_width + min_wall*3 + tube_diameter],
                [pipe_diameter/2, stuck_width + min_wall*3 + tube_diameter],
                [pipe_diameter/2, stuck_width*2 + min_wall*4 + tube_diameter +1],
                [0, stuck_width + min_wall*10 + tube_diameter +1]]);
        translate ([inner_diameter/2 + min_wall, 0, stuck_width + min_wall*2 + tube_diameter/2 + rubber_thickness])
            rotate ([0, 90, 0])
                cylinder 
                    (inner_diameter/2 + min_wall + stuck_width, 
                    tube_diameter/2, tube_diameter/2);
         translate ([0, 0, stuck_width + min_wall*2 + tube_diameter/2 + rubber_thickness])
            rotate ([0, 90, 0])
                cylinder 
                    (inner_diameter/2 + min_wall + stuck_width, 
                    tube_diameter*0.4, tube_diameter*0.4);
    };   
}

// outer part
rotate_extrude($fn=50) polygon
    (points=[
        [inner_diameter/2, -rubber_thickness - min_wall],
        [inner_diameter/2 + min_wall*2 + rubber_thickness, -rubber_thickness - min_wall],
        [inner_diameter/2 + min_wall*2 + rubber_thickness, stuck_width],
        [inner_diameter/2 + min_wall + rubber_thickness, stuck_width],
        [inner_diameter/2 + min_wall + rubber_thickness, -rubber_thickness],
        [inner_diameter/2, -rubber_thickness]]);  
