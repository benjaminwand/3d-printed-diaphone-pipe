
module M3_spacer() {
    union(){
        cylinder(  5, 3, 3.2, false, $fn = 6);
        translate([0, 0, -4.9])cylinder(  10, 1.6, 1.6, true, $fn = 15);
    };
}

/*
difference(){
    cube([9,9,6],true);
    M3_spacer ();
}
*/

//M3_spacer();