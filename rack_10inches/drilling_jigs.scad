include <constants.scad>

// Tolérance pour glisser sur le tube acier
play = 0.4; // 0.4mm de marge totale (0.2 par côté) pour glisser facilement sans forcer
inner_w = metal_profile_size + play;
inner_d = metal_profile_size + play;

wall_thick = 4; // Épaisseur de la face de perçage (suffisante pour bien guider le foret)
side_thick = 3; // Épaisseur des pattes latérales du U

drill_radius = 3.0; // Pour un foret métal de 6mm

// Forme de base (U-channel) qui vient épouser le profilé carré
module u_channel_profile() {
    difference() {
        // Bloc extérieur
        square([inner_w + 2*side_thick, inner_d + wall_thick]);
        // Creux intérieur pour le profilé acier
        translate([side_thick, wall_thick])
            square([inner_w, inner_d + 1]); 
    }
}

// ==========================================
// Gabarit 1 : DÉMARREUR
// À poser en butée sur la traverse horizontale en acier.
// Il donne automatiquement la hauteur parfaite pour les 2 premiers trous,
// en prenant en compte l'épaisseur de la planche en bois.
// ==========================================
module starter_jig() {
    // Hauteur du premier trou par rapport à la traverse acier
    h1 = wood_thickness_bottom + 6.35;
    h2 = h1 + 15.875;
    
    height = h2 + 10; // On ajoute 10mm de marge au-dessus
    
    color("Cyan")
    difference() {
        linear_extrude(height) u_channel_profile();
            
        // Trou 1
        translate([side_thick + inner_w/2, 0, h1])
            rotate([-90, 0, 0])
            cylinder(r=drill_radius, h=wall_thick*3, center=true, $fn=32);
            
        // Trou 2
        translate([side_thick + inner_w/2, 0, h2])
            rotate([-90, 0, 0])
            cylinder(r=drill_radius, h=wall_thick*3, center=true, $fn=32);
            
        // Gravure "1"
        translate([side_thick + inner_w/2, 1, h1/2])
            rotate([90, 0, 0])
            linear_extrude(2)
            text("1", size=6, halign="center", valign="center");
    }
}

// ==========================================
// Gabarit 2 : EXTENSION
// À brancher dans les 2 trous précédents via ses tétons.
// Permet de percer les 3 trous suivants avec l'espacement parfait EIA-310.
// (Il suffit de le décaler de 2 trous en 2 trous pour faire toute la hauteur).
// ==========================================
module extension_jig() {
    z_offset = 10; // Marge en bas pour solidifier les tétons
    
    // Distances standard EIA-310 : 15.875, 15.875, 12.7
    // Tétons insérés dans les trous 0 et 1 (espacés de 15.875)
    t0 = 0;
    t1 = 15.875;
    
    // Nouveaux trous à percer
    t2 = t1 + 15.875; // 31.75
    t3 = t2 + 12.7;   // 44.45
    t4 = t3 + 15.875; // 60.325
    
    height = t4 + z_offset + 10; 
    
    color("LimeGreen")
    union() {
        difference() {
            // Corps
            linear_extrude(height) u_channel_profile();
                
            // Trous de perçage
            for (z = [t2, t3, t4]) {
                translate([side_thick + inner_w/2, 0, z + z_offset])
                    rotate([-90, 0, 0])
                    cylinder(r=drill_radius, h=wall_thick*3, center=true, $fn=32);
            }
            
            // Gravure "2"
            translate([side_thick + inner_w/2, 1, z_offset + t2/2])
                rotate([90, 0, 0])
                linear_extrude(2)
                text("2", size=6, halign="center", valign="center");
        }
        
        // Tétons de centrage (rentrent dans les trous de 6mm du châssis)
        // Coniques pour une insertion facile et sans jeu (r base = 2.8, r pointe = 2.0)
        for (z = [t0, t1]) {
            translate([side_thick + inner_w/2, wall_thick, z + z_offset])
                rotate([-90, 0, 0])
                cylinder(r1=2.8, r2=2.0, h=4, $fn=32);
        }
    }
}

// Affichage par défaut pour générer les STL
translate([-20, 0, 0]) starter_jig();
translate([20, 0, 0]) extension_jig();
