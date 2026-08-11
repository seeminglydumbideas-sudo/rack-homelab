use <raspi_3b.scad>
use <raspi_4b.scad>
use <gmktec.scad>
use <raspi-ssd.scad>


// Base plate used by all supports and the roof
module support_base(d=12, cutout_w=0, cutout_d=0) {
    thickness = 6;
    peg_d = d - 6;
    hole_d = peg_d + 0.6;
    col_dist = 150/2 - d/2 - 1; // 68mm
    
    difference() {
        // Main support plate (hull of the 4 column bases)
        hull() {
            for (dx = [-1, 1], dy = [-1, 1]) {
                translate([dx * col_dist, dy * col_dist, -thickness/2])
                    cylinder(h=thickness, d=d, center=true, $fn=32);
            }
        }
        
        // Optional central cutout to save material and increase airflow
        if (cutout_w > 0 && cutout_d > 0) {
            translate([0, 0, -thickness/2])
                hull() {
                    for (dx = [-1, 1], dy = [-1, 1]) {
                        translate([dx * (cutout_w/2 - 5), dy * (cutout_d/2 - 5), 0])
                            cylinder(h=thickness+2, r=5, center=true, $fn=32);
                    }
                }
        }
        
        // 4 holes for stacking pegs
        for (dx = [-1, 1], dy = [-1, 1]) {
            translate([dx * col_dist, dy * col_dist, -thickness/2])
                cylinder(h=thickness+1, d=hole_d, center=true, $fn=32);
        }
    }
}

module support(h=50, d=12, cutout_w=0, cutout_d=0) {
    thickness = 6;
    peg_d = d - 6;
    peg_h = thickness - 0.5;
    col_dist = 150/2 - d/2 - 1; // 68mm
    
    support_base(d=d, cutout_w=cutout_w, cutout_d=cutout_d);
    
    // 4 stackable columns with curved reinforcing gussets (nervures)
    color("silver")
    for (dx = [-1, 1], dy = [-1, 1]) {
        translate([dx * col_dist, dy * col_dist, 0]) {
            // Main column body
            cylinder(h=h, d=d, $fn=32);
            // Stacking peg on top
            translate([0, 0, h])
                cylinder(h=peg_h, d=peg_d, $fn=32);
                
            // Curved reinforcing fins
            fin_l = 35; // Length of the fin along the edge
            fin_h = min(h - 5, 150); // Height of the fin against the column
            fin_t = 4; // Thickness of the fin
            
            // Offset to prevent the fin corners from sticking out of the round cylinder
            fin_offset = d/2 - 1;
            
            // X-direction fin
            rotate([0, 0, (dx == 1) ? 180 : 0])
            rotate([90, 0, 0])
            translate([0, 0, -fin_t/2])
            linear_extrude(fin_t) {
                union() {
                    square([fin_offset, fin_h]);
                    translate([fin_offset, 0, 0]) {
                        difference() {
                            square([fin_l, fin_h]);
                            translate([fin_l, fin_h, 0])
                                scale([fin_l, fin_h]) circle(r=1, $fn=64);
                        }
                    }
                }
            }
            
            // Y-direction fin
            rotate([0, 0, (dy == 1) ? -90 : 90])
            rotate([90, 0, 0])
            translate([0, 0, -fin_t/2])
            linear_extrude(fin_t) {
                union() {
                    square([fin_offset, fin_h]);
                    translate([fin_offset, 0, 0]) {
                        difference() {
                            square([fin_l, fin_h]);
                            translate([fin_l, fin_h, 0])
                                scale([fin_l, fin_h]) circle(r=1, $fn=64);
                        }
                    }
                }
            }
        }
    }
}

// Standoffs for Raspberry Pi PCB mounting holes
// h: height of the standoff from the support plate
module raspi_standoffs(h=10) {
    dy = 49/2;
    dx1 = -85/2 + 3.5;
    dx2 = dx1 + 58;
    
    color("darkgray")
    for (x = [dx1, dx2]) {
        for (y = [-dy, dy]) {
            translate([x, y, 0]) {
                difference() {
                    // Standoff column (d=6)
                    cylinder(h=h, d=6, $fn=32);
                    // Screw hole (d=2.5) for self-tapping M2.5
                    translate([0, 0, -1])
                        cylinder(h=h+2, d=2.5, $fn=32);
                }
            }
        }
    }
}

// Holds a device in place with 4 corner brackets
// w: device width (X), d: device depth (Y)
// h: bracket height, t: bracket thickness, leg: length of the L shape
// tol: tolerance gap between device and bracket
// r: corner radius of the device (0 for sharp corners)
module device_holder(w, d, h=5, t=4, leg=10, tol=0.5, r=0) {
    for (dx = [-1, 1], dy = [-1, 1]) {
        scale([dx, dy, 1]) {
            if (r > 0) {
                // Curved bracket for rounded corners
                translate([w/2 - r, d/2 - r, 0]) {
                    difference() {
                        cylinder(h=h, r=r + tol + t, $fn=64);
                        translate([0,0,-1]) cylinder(h=h+2, r=r + tol, $fn=64);
                        // Keep only 1st quadrant (X>0, Y>0)
                        translate([-(r+tol+t+1), -(r+tol+t+1), -1])
                            cube([(r+tol+t+1)*2, r+tol+t+1, h+2]);
                        translate([-(r+tol+t+1), -(r+tol+t+1), -1])
                            cube([r+tol+t+1, (r+tol+t+1)*2, h+2]);
                    }
                    // Straight extensions
                    if (leg > 0) {
                        translate([-leg, r + tol, 0])
                            cube([leg, t, h]);
                        translate([r + tol, -leg, 0])
                            cube([t, leg, h]);
                    }
                }
            } else {
                // L-bracket for sharp corners
                translate([w/2 + tol, d/2 + tol, 0]) {
                    // X-leg
                    translate([-leg, 0, 0])
                        cube([leg + t, t, h]);
                    // Y-leg
                    translate([0, -leg, 0])
                        cube([t, leg + t, h]);
                }
            }
        }
    }
}

module support_raspi() {
    difference() {
        // Central cutout safely avoids the standoffs
        support(h=35, cutout_w=30, cutout_d=30);
        
        // Extra cutouts on the sides and corners to save maximum material
        // We cut only the 6mm plate (Z from -7 to 1) to avoid touching columns
        for (pos = [
            [0, 48, 90, 22],   // Top hole
            [0, -48, 90, 22],  // Bottom hole
            [54, 0, 14, 60],   // Right hole
            [-54, 0, 14, 60]   // Left hole
        ]) {
            translate([pos[0], pos[1], -3])
                hull() {
                    for (dx = [-1, 1], dy = [-1, 1]) {
                        translate([dx * (pos[2]/2 - 4), dy * (pos[3]/2 - 4), 0])
                            cylinder(h=8, r=4, center=true, $fn=32);
                    }
                }
        }
    }
    // The Pi is placed at Z=10, PCB is 1.1mm thick (bottom is at 9.45)
    raspi_standoffs(h=9.45);
}
module support_nucg3() {
    // Cutout safely avoids the bottom pads at +/- 43.5, +/- 47.5
    support(h=60, cutout_w=65, cutout_d=75);
    // gmktec base is 107x115. Pads are 4mm from edge, so use leg=3 to avoid collision.
    // Pads are 2mm high, so h=8 ensures a good 6mm grip on the case body.
    color("gray")
    device_holder(w=107, d=115, h=8, leg=3, r=10);
}
module support_raspi_ssd1() {
    // Cutout safely avoids the bottom pads
    support(h=85, cutout_w=45, cutout_d=65);
    // raspi_ssd base is 94x114. Pads are 4mm from edge, so use leg=3.
    // Pads are 3mm high, so h=12 ensures a solid 9mm grip on the case body.
    color("gray")
    device_holder(w=94, d=114, h=12, leg=3);
}
module support_raspi_ssd2() {
    difference() {
        // Cutout safely avoids the brackets at +/- 47.5, +/- 31.5
        support(h=55, cutout_w=70, cutout_d=40);
        
        // Extra side cutouts for skeletonization
        for (pos = [
            [0, 50, 90, 24],   // Top hole
            [0, -50, 90, 24],  // Bottom hole
            [57, 0, 8, 80],    // Right hole
            [-57, 0, 8, 80]    // Left hole
        ]) {
            translate([pos[0], pos[1], -3])
                hull() {
                    for (dx = [-1, 1], dy = [-1, 1]) {
                        translate([dx * (pos[2]/2 - 4), dy * (pos[3]/2 - 4), 0])
                            cylinder(h=8, r=4, center=true, $fn=32);
                    }
                }
        }
    }
    // rotated 90 deg, so width is 95 and depth is 63
    color("gray")
    device_holder(w=95, d=63);
}

module support_roof() {
    // The roof is simply a base plate with holes, but no columns.
    // It sits perfectly on top of the last module's pegs, capping the tower.
    support_base();
}

translate([0,-400,0]) {
    support_roof();
}

translate([0,-200,0]) {
    translate([0,0,10])
        raspi_3b();
    support_raspi();
}

translate([0,0,0]) {
    translate([0,0,10])
        raspi_4b();
    support_raspi();
}

translate([0,200,0]) {
    gmktec_nuc_g3();  
    support_nucg3();
}  
    
translate([0,400,0]) {
    raspi_ssd();
    support_raspi_ssd1();
}

translate([0,600,0]) {
    rotate([0, 0, -90])
        raspi_ssd_2();
    support_raspi_ssd2();
}