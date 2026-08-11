
module gmktec_nuc_g3() {
    translate([0,0,24.5]) {
        // Base volume (rounded corners, r=10)
        color("darkgray")
        hull() {
            translate([107/2 - 10, 115/2 - 10, 0]) cylinder(h=45, r=10, center=true, $fn=64);
            translate([-107/2 + 10, 115/2 - 10, 0]) cylinder(h=45, r=10, center=true, $fn=64);
            translate([107/2 - 10, -115/2 + 10, 0]) cylinder(h=45, r=10, center=true, $fn=64);
            translate([-107/2 + 10, -115/2 + 10, 0]) cylinder(h=45, r=10, center=true, $fn=64);
        }

        // Power button (Front panel, derived from SVG)
        color("green")
        translate([-107/2 - 1, 31.18, 1.76])
            rotate([0, 90, 0])
            cylinder(h=2, d=12, center=true, $fn=32);

        // Front USB Port 1 (derived from SVG)
        color("blue")
        translate([-107/2 - 0.5, 4.81, 1.54])
            cube([1, 12.77, 5.61], center=true);

        // Front USB Port 2 (derived from SVG)
        color("blue")
        translate([-107/2 - 0.5, -15.12, 1.54])
            cube([1, 12.77, 5.61], center=true);

        // Back Panel I/O (derived from SVG)
        
        // HDMI 1 (Left)
        color("black")
        translate([107/2 + 0.5, -36.49, 4.41])
            cube([1, 16.10, 6.00], center=true);

        // 2x USB
        color("blue")
        translate([107/2 + 0.5, -15.31, 1.66])
            cube([1, 13.54, 14.58], center=true);

        // Ethernet
        color("gray")
        translate([107/2 + 0.5, 3.84, 2.36])
            cube([1, 15.33, 9.84], center=true);

        // HDMI 2 (Right)
        color("black")
        translate([107/2 + 0.5, 23.69, 4.41])
            cube([1, 16.10, 6.00], center=true);

        // Audio Jack
        color("black")
        translate([107/2 + 0.5, 23.67, -5.14])
            rotate([0, 90, 0])
            cylinder(h=1, d=5.12, center=true, $fn=32);

        // DC Power
        color("black")
        translate([107/2 + 0.5, 40.25, 3.88])
            rotate([0, 90, 0])
            cylinder(h=1, d=6.15, center=true, $fn=32);

        // 4x Bottom Foam Pads
        // d=12mm, 4mm from edge to edge of pad (10mm from edge to center)
        color("darkgray")
        for (dx = [-1, 1], dy = [-1, 1]) {
            translate([dx * (107/2 - 10), dy * (115/2 - 10), -45/2 - 1])
                cylinder(h=2, d=12, center=true, $fn=32);
        }
    }
}


gmktec_nuc_g3();