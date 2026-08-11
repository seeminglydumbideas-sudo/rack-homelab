
module raspi_ssd() {
    translate([0,0,37.5]) {
        // Base volume (rounded corners, r=10)
        color("darkgray")
        cube([94,114,69], center=true);

        // Front Panel I/O
        color("green")
        translate([-94/2 - 0.5, 36.43, 12.47])
            rotate([0, 90, 0])
            cylinder(h=1, d=20, center=true, $fn=32);

        // Back Panel I/O
        color("blue")
        translate([94/2 + 0.5, -45.23, 8.76])
            cube([1, 11.91, 13.48], center=true);
            
        color("blue")
        translate([94/2 + 0.5, -29.31, 8.76])
            cube([1, 11.91, 13.48], center=true);

        color("blue")
        translate([94/2 + 0.5, -29.31, -7.44])
            cube([1, 11.91, 7.69], center=true);

        color("blue")
        translate([94/2 + 0.5, -11.96, 7.47])
            cube([1, 14.98, 13.70], center=true);

        // Right Side Panel I/O (Y = -114/2)
        color("red")
        translate([-33.03, -114/2 - 0.5, 2.52])
            cube([9.43, 1, 4.72], center=true);

        color("red")
        translate([-17.97, -114/2 - 0.5, 2.52])
            cube([7.91, 1, 4.72], center=true);

        color("red")
        translate([-4.42, -114/2 - 0.5, 2.52])
            cube([7.91, 1, 4.72], center=true);

        color("red")
        translate([6.84, -114/2 - 0.5, 16.82])
            cube([9.43, 1, 4.72], center=true);

        color("red")
        translate([-11.88, -114/2 - 0.5, 16.82])
            cube([9.43, 1, 4.72], center=true);

        color("red")
        translate([-30.44, -114/2 - 0.5, 22.07])
            rotate([90, 0, 0])
            cylinder(h=1, d=10.34, center=true, $fn=32);

        color("red")
        translate([11.71, -114/2 - 0.5, 3.97])
            rotate([90, 0, 0])
            cylinder(h=1, d=5.78, center=true, $fn=32);

        // 4x Bottom Pads
        // d=20mm, 4mm from edges (14mm to center)
        color("darkgray")
        for (dx = [-1, 1], dy = [-1, 1]) {
            translate([dx * (94/2 - 14), dy * (114/2 - 14), -69/2 - 1.5])
                cylinder(h=3, d=20, center=true, $fn=32);
        }
    }
}

module raspi_ssd_2() {
    translate([0,0,20.5]) {
        // Base volume (rounded corners, r=10)
        color("darkgray")
        cube([63,95,41], center=true);
    }

    // Z-height of the Raspberry Pi PCB inside the case
    // Adjust this value to move all the ports up or down
    pi_z = 18;
    
    // Back Panel I/O (X = 63/2)
    // Power (USB-C)
    color("silver")
    translate([63/2 + 0.5, -31.9, pi_z + 2.15])
        cube([1, 9.0, 3.2], center=true);

    // Micro HDMI 0
    color("silver")
    translate([63/2 + 0.5, -16.5, pi_z + 2.05])
        cube([1, 6.4, 3.0], center=true);

    // Micro HDMI 1
    color("silver")
    translate([63/2 + 0.5, -3.0, pi_z + 2.05])
        cube([1, 6.4, 3.0], center=true);

    // 3.5mm Audio
    color("black")
    translate([63/2 + 0.5, 11.5, pi_z + 3.55])
        cube([1, 7.0, 6.0], center=true);

    // Right Side Panel I/O (Y = 95/2)
    // Ethernet
    color("silver")
    translate([-19.0, 95/2 + 0.5, pi_z + 7.3])
        cube([16.0, 1, 13.5], center=true);

    // USB 1
    color("silver")
    translate([-1.0, 95/2 + 0.5, pi_z + 8.55])
        cube([14.5, 1, 16.0], center=true);

    // USB 2
    color("silver")
    translate([17.75, 95/2 + 0.5, pi_z + 8.55])
        cube([14.5, 1, 16.0], center=true);

    // Left Side Panel I/O (Y = -95/2)
    // MicroSD
    color("darkgray")
    translate([0, -95/2 - 0.5, pi_z - 1.3])
        cube([12.0, 1, 1.5], center=true);
}


raspi_ssd_2();
