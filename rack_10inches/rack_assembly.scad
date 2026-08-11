/* [Visualisation] */
// Décalage pour éclater les pièces de montage (en mm)
exploded_view_offset = 30; // [0:1:100]

/* [Affichage] */
afficher_chassis_metal = true;
afficher_habillage_bois = true;
afficher_panneaux_avant = true;
afficher_pieces_montage = true;

/* [Caché] */
include <constants.scad>
use <front_plate.scad>
use <front_plate_mount.scad>

module square_profile(w, d, h) {
    color("DimGray")
    cube([w, d, h]);
}

module vertical_rack_rail(h, hole_face_x) {
    // La planche du bas est posée sur les traverses à 150mm, épaisseur traverse = metal_profile_size, épaisseur planche = wood_thickness
    start_z = 150 + metal_profile_size + wood_thickness;
    
    difference() {
        square_profile(metal_profile_size, metal_profile_size, h);
        
        // Creuser l'intérieur pour faire un tube d'épaisseur 2mm
        translate([2, 2, -1])
            cube([metal_profile_size - 4, metal_profile_size - 4, h + 2]);
        
        // Trous EIA-310 sur la face spécifiée (r=3mm pour M6)
        // 1U = 44.45mm, trous à 6.35mm, 22.225mm, 38.1mm
        // On commence à partir de start_z
        for (u = [start_z : U : h - U]) {
            translate([hole_face_x, metal_profile_size/2, u + 6.35])
                rotate([0, 90, 0]) cylinder(r=3, h=5, center=true, $fn=16);
            translate([hole_face_x, metal_profile_size/2, u + 22.225])
                rotate([0, 90, 0]) cylinder(r=3, h=5, center=true, $fn=16);
            translate([hole_face_x, metal_profile_size/2, u + 38.1])
                rotate([0, 90, 0]) cylinder(r=3, h=5, center=true, $fn=16);
        }
    }
}

module side_frame(is_left) {
    h = total_U * U;
    // Si cadre gauche, les trous sont sur la face droite (x=20)
    // Si cadre droit, les trous sont sur la face gauche (x=0)
    hole_face_x = is_left ? metal_profile_size : 0;
    
    // Montant vertical avant
    translate([0, 0, 0])
        vertical_rack_rail(h, hole_face_x);
        
    // Montant vertical arrière
    translate([0, rack_depth - metal_profile_size, 0])
        vertical_rack_rail(h, hole_face_x);
        
    // Traverse horizontale basse (entre les montants)
    translate([0, metal_profile_size, 0])
        square_profile(metal_profile_size, rack_depth - 2*metal_profile_size, metal_profile_size);
        
    // Traverse horizontale haute (entre les montants)
    translate([0, metal_profile_size, h - metal_profile_size])
        square_profile(metal_profile_size, rack_depth - 2*metal_profile_size, metal_profile_size);
}

module rack_chassis() {
// ==========================================
// ASSEMBLAGE PRINCIPAL
// ==========================================

// Variables globales utiles pour l'assemblage
h_total = total_U * U;
start_z = 150 + metal_profile_size + wood_thickness;

if (afficher_chassis_metal) {
    // --- Cadre Métallique Principal ---
    // Côté Gauche
    side_frame(is_left=true);
    
    // Côté Droit
    // L'espace intérieur doit accueillir le panneau (panel_width) + 2 marges (panel_margin).
    translate([metal_profile_size + panel_width + panel_margin * 2, 0, 0])
        side_frame(is_left=false);
        
    // --- Traverses de jonction (à 15cm du sol) ---
    // Traverse avant
    translate([metal_profile_size, 0, 150])
        square_profile(panel_width + panel_margin * 2, metal_profile_size, metal_profile_size);
        
    // Traverse arrière
    translate([metal_profile_size, rack_depth - metal_profile_size, 150])
        square_profile(panel_width + panel_margin * 2, metal_profile_size, metal_profile_size);
        
    // --- Traverses de jonction (en haut) ---
    // À 5cm du devant (50mm)
    translate([metal_profile_size, 50, h_total - metal_profile_size])
        square_profile(panel_width + panel_margin * 2, metal_profile_size, metal_profile_size);
        
    // À 5cm de l'arrière (50mm + épaisseur profilé)
    translate([metal_profile_size, rack_depth - 50 - metal_profile_size, h_total - metal_profile_size])
        square_profile(panel_width + panel_margin * 2, metal_profile_size, metal_profile_size);
}

if (afficher_panneaux_avant) {
    // --- Front panel fictif (1U) ---
    // On l'aligne parfaitement sur le premier emplacement (1U) au-dessus de la planche
    translate([metal_profile_size + panel_margin + panel_width / 2, 1.5, start_z + U / 2])
        basic_front_plate(units=1);
}

if (afficher_pieces_montage) {
    // --- Pièces de montage 3D (Brackets) ---
    // On utilise exploded_view_offset pour les "sortir" du châssis vers le centre
    translate([metal_profile_size + exploded_view_offset, 0, start_z])
        front_plate_mount_left(units=1);
        
    translate([metal_profile_size + panel_width + panel_margin * 2 - exploded_view_offset, 0, start_z])
        front_plate_mount_right(units=1);
}

if (afficher_habillage_bois) {
    // --- Habillage Bois ---
    // Planche supérieure (Toit)
    // Elle déborde légèrement du cadre métallique (wood_overhang)
    color("#3E2723") // Brun sombre (Dark Brown)
    translate([-wood_overhang, -wood_overhang, h_total])
        cube([
            (metal_profile_size*2 + panel_width + panel_margin*2) + wood_overhang*2, 
            rack_depth + wood_overhang*2, 
            wood_thickness
        ]);
        
    // Planche sur les traverses du bas
    // Largeur identique aux front panels (panel_width), centrée
    color("#3E2723")
    translate([metal_profile_size + panel_margin, 0, 150 + metal_profile_size])
        cube([panel_width, rack_depth, wood_thickness]);
}
}

// Affichage principal
rack_chassis();
