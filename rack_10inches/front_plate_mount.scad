include <constants.scad>

// Téton supérieur avec ergot pour insertion en biais
module top_peg_with_hook() {
    union() {
        // 1. Le corps du téton (demi-cylindre supérieur)
        difference() {
            // Cylindre pointant vers X négatif (longueur 5mm)
            rotate([0, -90, 0])
                cylinder(r=2.8, h=5, $fn=32);
                
            // On coupe la partie inférieure (Z < 0)
            translate([-6, -3, -3])
                cube([7, 6, 3]);
        }
        
        // 2. L'ergot d'accroche (Hook)
        // Le mur du profilé acier fait 2mm d'épaisseur. 
        // On laisse 2.4mm de dégagement, donc l'ergot commence à X = -2.4 et va jusqu'à -5.
        // Il monte jusqu'à Z = 5 pour bien accrocher derrière le trou (qui s'arrête à Z=3).
        hull() {
            // Base de l'ergot (qui fusionne avec le demi-cylindre)
            translate([-5, -2.8, 0]) 
                cube([2.6, 5.6, 2.8]);
                
            // Sommet de l'ergot (biseauté côté insertion vers X=-5)
            // La face arrière (X=-2.4) reste droite (verticale) pour verrouiller la pièce
            translate([-3.9, -2.8, 4.5]) 
                cube([1.5, 5.6, 0.5]);
        }
    }
}

// Pièce de montage gauche (L-bracket avec tétons)
module front_plate_mount_left(units=1) {
    // Hauteur ajustée pour être à fleur du sommet du téton le plus haut.
    // Le téton haut est à (units-1)*U + 38.1, son rayon est de 2.8.
    h_top = (units - 1) * U + 38.1 + 2.8;
    
    // Raccourcissement du bas au maximum : on commence exactement au bas du téton inférieur.
    // Le centre du téton est à 6.35, son rayon est 2.8.
    z_bottom = 6.35 - 2.8; // 3.55
    
    color("Orange")
    difference() {
        // --- Corps plein de la pièce ---
        union() {
            // Position en Y du centre du téton (moitié du profilé)
            y_peg = metal_profile_size / 2;
            
            // On centre la colonne (largeur 8) sur le téton (y_peg)
            // On s'assure qu'elle ne touche pas le panneau (y_spine doit être >= 3)
            y_spine = max(3, y_peg - 4);
            
            // 1. Colonne vertébrale (contre le châssis)
            // Épaisseur de 4mm. En Y, s'adapte dynamiquement à la taille du profilé.
            translate([0, y_spine, z_bottom])
                cube([4, 8, h_top - z_bottom]);
                
            // 2. Bras de fixation pour chaque trou (Bossages)
            // Au lieu d'un bloc massif, on crée un bras arrondi uniquement là où se trouve la vis.
            for (i = [0 : units - 1]) {
                screw_z = i * U + 22.725;
                // hull() crée une transition douce et solide entre la colonne et le cylindre
                hull() {
                    // Base du bras sur la colonne (utilise le même positionnement Y que la colonne)
                    translate([0, y_spine, screw_z - 8])
                        cube([4, 8, 16]);
                        
                    // Bossage cylindrique (arrondi) autour de la vis
                    // Centre en X=13, Z=screw_z. Commence à Y=3 (appui du panneau), profondeur 10.
                    // Rayon de 6mm pour bien enrober l'insert (r=3.5), laissant 2.5mm de paroi.
                    translate([13, 3, screw_z])
                        rotate([-90, 0, 0])
                        cylinder(r=6, h=10, $fn=32);
                }
            }
                
            // Téton du bas (forme conique pour effet snap-fit)
            translate([0, metal_profile_size/2, 6.35])
                rotate([0, -90, 0]) cylinder(r1=2.8, r2=1.5, h=3, $fn=32);
                
            // Téton du haut (demi-cercle avec ergot)
            // Le trou du haut d'un U est à 38.1mm
            translate([0, metal_profile_size/2, (units-1)*U + 38.1])
                top_peg_with_hook();
        }
        
        // --- Trous à creuser ---
        // Emplacement pour un insert fileté M5 posé à chaud (Heat-set insert)
        // Diamètre typique d'un insert M5 : ~7.0mm (r=3.5)
        for (i = [0 : units - 1]) {
            translate([13, 8, i * U + 22.725])
                rotate([90, 0, 0])
                cylinder(r=3.5, h=20, center=true, $fn=32);
        }
    }
}

// Pièce de montage droite (Miroir de la gauche)
module front_plate_mount_right(units=1) {
    // On utilise la fonction miroir sur l'axe X pour créer la pièce droite
    mirror([1, 0, 0])
        front_plate_mount_left(units);
}

// Affichage de test si on ouvre juste ce fichier
// front_plate_mount_left(1);
