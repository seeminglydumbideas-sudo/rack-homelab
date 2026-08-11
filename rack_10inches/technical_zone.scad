include <constants.scad>

module power_strip() {
    color("White")
    cube([300, 50, 40]);
    // Câble d'alimentation
    color("Black")
    translate([0, 25, 20])
        rotate([0, -90, 0])
        cylinder(r=4, h=50, $fn=16);
}

module usb_charger_8port() {
    color("DarkSlateGray")
    cube([120, 80, 30]);
    // Ports USB (indicatifs)
    color("Silver")
    for (i = [10 : 15 : 110]) {
        translate([i, 5, 30])
            cube([10, 4, 2]);
    }
}

module power_supply_brick() {
    color("Black")
    cube([100, 50, 30]);
}

module technical_zone_layout() {
    // Placés derrière la fausse paroi (depth = device_zone_depth to rack_depth)
    
    // Multiprise fixée verticalement sur le côté gauche
    translate([metal_angle_size + 10, device_zone_depth + 10, U*2])
        rotate([0, 0, 90])
        power_strip();
        
    // Chargeur USB 8 ports fixé sur la fausse paroi
    translate([rack_hole_spacing/2, device_zone_depth + 30, U*10])
        rotate([90, 0, 0])
        usb_charger_8port();
        
    // Blocs d'alimentation GMKTec/SSD
    translate([rack_hole_spacing/2, device_zone_depth + 30, U*15])
        rotate([90, 0, 0])
        power_supply_brick();
        
    translate([rack_hole_spacing/2, device_zone_depth + 30, U*17])
        rotate([90, 0, 0])
        power_supply_brick();
}
