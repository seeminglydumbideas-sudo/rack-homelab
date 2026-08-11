


// ref :
// - https://www.raspberrypi-spy.co.uk/2012/03/mechanical-data-dimensions/
// - https://www.raspberrypi-spy.co.uk/wp-content/uploads/2012/03/Raspberry-Pi-3B-V1.2-Mechanical-1.png
module raspi_4b() {
    difference() {
        // PCB
        cube([85,56,1.1], center=true);        
        // PCB holes
        dy=49/2;
        dx1=-85/2+3.5;
        dx2=dx1+58;
        translate([dx1,dy,0])
            cylinder(h=8,d=2.75,center=true);
        translate([dx2,dy,0])
            cylinder(h=8,d=2.75,center=true);
        translate([dx1,-dy,0])
            cylinder(h=8,d=2.75,center=true);
        translate([dx2,-dy,0])
            cylinder(h=8,d=2.75,center=true);
    }    
    // Ethernet port
    // Center is 47.0mm from the bottom edge, length is ~21.3mm, width ~16mm, height ~13.5mm.
    // Port typically overhangs PCB edge by ~1.5mm
    color("silver")
    translate([85/2 - 21.3/2 + 1.5, -56/2 + 47.0, 1.1/2 + 13.5/2])
        cube([21.3, 16, 13.5], center=true);

    // USB port 1 (USB 3.0)
    // Center is 29.0mm from the bottom edge, length is ~17.5mm, width ~14.5mm, height ~16mm
    color("silver")
    translate([85/2 - 17.5/2 + 1.5, -56/2 + 29.0, 1.1/2 + 16/2])
        cube([17.5, 14.5, 16], center=true);

    // USB port 2 (USB 2.0)
    // Center is 10.25mm from the bottom edge
    color("silver")
    translate([85/2 - 17.5/2 + 1.5, -56/2 + 10.25, 1.1/2 + 16/2])
        cube([17.5, 14.5, 16], center=true);

    // Power plug (USB-C)
    // Center is 10.6mm from the SD-card edge (left edge)
    color("silver")
    translate([-85/2 + 10.6, -56/2 + 7.5/2 - 1.0, 1.1/2 + 3.2/2])
        cube([9.0, 7.5, 3.2], center=true);

    // Micro HDMI port 0
    // Center is 26.0mm from the SD-card edge (left edge)
    color("silver")
    translate([-85/2 + 26.0, -56/2 + 7.5/2 - 1.0, 1.1/2 + 3.0/2])
        cube([6.4, 7.5, 3.0], center=true);

    // Micro HDMI port 1
    // Center is 39.5mm from the SD-card edge (left edge)
    color("silver")
    translate([-85/2 + 39.5, -56/2 + 7.5/2 - 1.0, 1.1/2 + 3.0/2])
        cube([6.4, 7.5, 3.0], center=true);

    // 3.5mm Audio/Video Jack
    // Center is 54.0mm from the SD-card edge (left edge)
    color("black")
    translate([-85/2 + 54.0, -56/2 + 14.0/2 - 2.0, 1.1/2 + 6.0/2])
        cube([7.0, 14.0, 6.0], center=true);

    // MicroSD slot
    // Underside of PCB, centered on Y-axis, extending past left edge
    color("darkgray")
    translate([-85/2 + 11.5/2 - 1.5, 0, -1.1/2 - 1.5/2])
        cube([11.5, 12.0, 1.5], center=true);
}


raspi_4b();