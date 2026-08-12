/* [Visualisation] */
// Décalage pour éclater les pièces de montage (en mm)
exploded_view_offset = 30; // [0:1:100]

/* [Affichage] */
afficher_chassis_metal = true;
afficher_grille_ventilation = true;
afficher_habillage_bois = true;
afficher_panneaux_avant = true;
afficher_pieces_montage = true;

/* [Caché] */
include <constants.scad>
use <front_plate.scad>
use <front_plate_mount.scad>
use <cooling_wall.scad>

module square_profile(w, d, h) {
    color("DimGray")
    cube([w, d, h]);
}

module vertical_rack_rail(h, hole_face_x) {
    // La planche du bas est posée sur les traverses à ground_clearance
    start_z = ground_clearance + metal_profile_size + wood_thickness_bottom;
    
    difference() {
        square_profile(metal_profile_size, metal_profile_size, h);
        
        // Creuser l'intérieur pour faire un tube d'épaisseur 2mm
        translate([2, 2, -1])
            cube([metal_profile_size - 4, metal_profile_size - 4, h + 2]);
        
        // Trous EIA-310 sur la face spécifiée (r=3mm pour M6)
        // 1U = 44.45mm, trous à 6.35mm, 22.225mm, 38.1mm
        // On commence à partir de start_z, et on arrête avant de toucher la traverse du haut
        // Le trou le plus haut d'un U est à u + 38.1mm.
        for (u = [start_z : U : h - metal_profile_size - 38.1]) {
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
    h = rack_height;
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
h_total = rack_height;
start_z = ground_clearance + metal_profile_size + wood_thickness_bottom;

if (afficher_chassis_metal) {
    // --- Cadre Métallique Principal ---
    // Côté Gauche
    side_frame(is_left=true);
    
    // Côté Droit
    // L'espace intérieur doit accueillir le panneau (panel_width) + 2 marges (panel_margin).
    translate([metal_profile_size + panel_width + panel_margin * 2, 0, 0])
        side_frame(is_left=false);
        
    // --- Traverses de jonction (basses) ---
    // Traverse avant
    translate([metal_profile_size, 0, ground_clearance])
        square_profile(panel_width + panel_margin * 2, metal_profile_size, metal_profile_size);
        
    // Traverse arrière
    translate([metal_profile_size, rack_depth - metal_profile_size, ground_clearance])
        square_profile(panel_width + panel_margin * 2, metal_profile_size, metal_profile_size);
        
    // --- Traverses de jonction (en haut) ---
    // À 5cm du devant (50mm)
    translate([metal_profile_size, 50, h_total - metal_profile_size])
        square_profile(panel_width + panel_margin * 2, metal_profile_size, metal_profile_size);
        
        // À 5cm de l'arrière (50mm + épaisseur profilé)
    translate([metal_profile_size, rack_depth - 50 - metal_profile_size, h_total - metal_profile_size])
        square_profile(panel_width + panel_margin * 2, metal_profile_size, metal_profile_size);
}

if (afficher_grille_ventilation) {
    // --- Fausse paroi en grillage (Côté gauche) ---
    cooling_mesh_wall();
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
            wood_thickness_top
        ]);
        
    // Panneau latéral droit
    // Inséré dans la "fenêtre" du cadre avec la même taille et le même gap (10mm) que la grille gauche
    // Calcul des dimensions exactes :
    gap = 10;
    panel_y = metal_profile_size + gap;
    panel_z = ground_clearance + gap;
    panel_w = (rack_depth - 2 * metal_profile_size) - 2 * gap;
    panel_h = (h_total - metal_profile_size - ground_clearance) - 2 * gap;
    // Centrage du panneau de 18mm d'épaisseur dans le profilé de 15mm :
    panel_x_offset = (metal_profile_size - wood_thickness_side) / 2;
    
    color("#3E2723")
    translate([metal_profile_size + panel_width + panel_margin*2 + panel_x_offset, panel_y, panel_z])
        cube([wood_thickness_side, panel_w, panel_h]);
        
    // Planche sur les traverses du bas (base massive)
    // Largeur identique aux front panels (panel_width), centrée
    color("#3E2723")
    translate([metal_profile_size + panel_margin, 0, ground_clearance + metal_profile_size])
        cube([panel_width, rack_depth, wood_thickness_bottom]);
}
}

// Affichage principal
rack_chassis();

// ==========================================
// BOM (Bill of Materials) - Découpes Acier
// ==========================================
// Ces lignes s'imprimeront dans la console d'OpenSCAD à chaque rendu
h_total = rack_height; // Hauteur totale accessible globalement
cross_side = rack_depth - 2*metal_profile_size;
cross_front = panel_width + panel_margin*2;

mesh_gap = 10;
mesh_frame = 10;
mesh_h = (h_total - metal_profile_size - ground_clearance) - 2 * mesh_gap;
mesh_w = (rack_depth - 2 * metal_profile_size) - 2 * mesh_gap - 2 * mesh_frame;

echo("");
echo("=========================================");
echo("LISTE DES DECOUPES - PROFILES ACIER");
echo("=========================================");
echo(str("Profile carre ", metal_profile_size, "x", metal_profile_size, " mm (Structure Principale) :"));
echo(str("  - 4x Montants verticaux : ", h_total, " mm"));
echo(str("  - 4x Traverses laterales (profondeur) : ", cross_side, " mm"));
echo(str("  - 4x Traverses frontales/arriere (largeur) : ", cross_front, " mm"));
echo(str("    -> Total lineaire estime : ", (4*h_total + 4*cross_side + 4*cross_front)/1000, " metres"));
echo("");
echo(str("Profile carre ", mesh_frame, "x", mesh_frame, " mm (Cadre Grille Ventilation) :"));
echo(str("  - 2x Montants verticaux : ", mesh_h, " mm"));
echo(str("  - 2x Traverses horizontales : ", mesh_w, " mm"));
echo(str("    -> Total lineaire estime : ", (2*mesh_h + 2*mesh_w)/1000, " metres"));
echo("=========================================");
echo("");
