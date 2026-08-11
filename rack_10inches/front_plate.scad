include <constants.scad>
use <../stackable-3d-prints/raspi_4b.scad>

module basic_front_plate(units=1) {
    h = units * U - 1; // Un peu moins que U pour le jeu
    w = panel_width; // Largeur de façade de 10 pouces (254mm)
    thickness = 3;
    hole_spacing = panel_width - 18; // ~236mm d'entraxe pour les trous
    
    color("DimGray")
    difference() {
        // Le cube est centré en X et Y, on ajuste sa position lors de l'appel
        cube([w, thickness, h], center=true);
        
        // Trous de fixation gauche/droite
        for (i = [0 : U : h - U/2]) {
            translate([-hole_spacing/2, 0, -h/2 + U/2 + i])
                rotate([90, 0, 0])
                cylinder(r=3, h=thickness*3, center=true, $fn=16);
                
            translate([hole_spacing/2, 0, -h/2 + U/2 + i])
                rotate([90, 0, 0])
                cylinder(r=3, h=thickness*3, center=true, $fn=16);
        }
    }
}

// Exemple de façade 2U avec un Raspberry Pi
module raspi_front_plate() {
    difference() {
        basic_front_plate(units=2);
        
        // Ouvertures pour les ports RJ45/USB du Raspberry Pi
        // Le RPi sera monté avec les ports vers l'avant.
        // On creuse une fenêtre pour laisser passer les ports.
        // (Dimensions indicatives à ajuster selon le modèle exact)
        translate([-30, 0, -10])
            cube([60, 10, 20], center=true);
    }
    
    // Le Raspberry Pi monté derrière la façade
    // On le tourne pour que l'Ethernet pointe vers l'avant
    translate([-30, 45, -10])
        rotate([0, 0, -90])
        raspi_4b();
}
