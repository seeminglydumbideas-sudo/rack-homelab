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
use <cooling_wall.scad>
use <cooling_wall.scad>

module square_profile(w, d, h) {
    color("DimGray")
    cube([w, d, h]);
}

module mitered_vertical_post(h, s) {
    color("DimGray")
    rotate([90, 0, 90])
    linear_extrude(height=s)
    polygon([[0,0], [s,s], [s, h-s], [0, h]]);
}

module mitered_bottom_traverse(d, s) {
    color("DimGray")
    rotate([90, 0, 90])
    linear_extrude(height=s)
    polygon([[0,0], [d, 0], [d-s, s], [s, s]]);
}

module commercial_rack_rail(u_count) {
    rail_h = u_count * U;
    color("#1a1a1a") { // Darker color to match black commercial rails
        difference() {
            // Profilé L basique
            cube([commercial_rail_front, commercial_rail_side, rail_h]);
            translate([commercial_rail_thickness, commercial_rail_thickness, -1])
                cube([commercial_rail_front, commercial_rail_side, rail_h + 2]);
                
            // Trous EIA-310 sur la face avant
            for (u = [0 : U : rail_h - U/2]) {
                translate([commercial_rail_front/2, -1, u + 6.35])
                    rotate([-90, 0, 0]) cylinder(r=3, h=commercial_rail_side+2, $fn=16);
                translate([commercial_rail_front/2, -1, u + 22.225])
                    rotate([-90, 0, 0]) cylinder(r=3, h=commercial_rail_side+2, $fn=16);
                translate([commercial_rail_front/2, -1, u + 38.1])
                    rotate([-90, 0, 0]) cylinder(r=3, h=commercial_rail_side+2, $fn=16);
            }
            
            // 8 trous de montage sur la face latérale (long side)
            // Diamètre 0.25" = 6.35mm, Rayon = 3.175mm
            for (i = [0 : 7]) {
                // Répartition uniforme sur la hauteur
                hole_z = (rail_h / 8) * i + (rail_h / 16); 
                translate([-1, commercial_rail_side/2, hole_z])
                    rotate([0, 90, 0]) cylinder(r=3.175, h=commercial_rail_front+2, $fn=16);
            }
        }
    }
}

module side_frame(is_left) {
    h = rack_height;
    s = metal_profile_size;
    d = rack_depth;
    
    // Montant vertical avant (Mitered)
    mitered_vertical_post(h, s);
        
    // Montant vertical arrière (Mitered)
    translate([0, d, 0])
        mirror([0, 1, 0])
        mitered_vertical_post(h, s);
        
    // Traverse horizontale basse (Mitered)
    mitered_bottom_traverse(d, s);
        
    // Traverse horizontale haute (Mitered)
    translate([0, 0, h])
        mirror([0, 0, 1])
        mitered_bottom_traverse(d, s);
}

module rack_chassis() {
// ==========================================
// ASSEMBLAGE PRINCIPAL
// ==========================================

// Variables globales utiles pour l'assemblage
h_total = rack_height;
start_z = ground_clearance + metal_profile_size + wood_thickness_bottom;

// Nouvelle largeur interne totale du cadre
inner_frame_w = panel_width + panel_margin * 2 + frame_gap * 2;

if (afficher_chassis_metal) {
    // --- Cadre Métallique Principal ---
    // Côté Gauche
    side_frame(is_left=true);
    
    // Côté Droit
    translate([metal_profile_size + inner_frame_w, 0, 0])
        side_frame(is_left=false);
        
    // --- Traverses de jonction (basses) ---
    // Traverse avant
    translate([metal_profile_size, 0, ground_clearance])
        square_profile(inner_frame_w, metal_profile_size, metal_profile_size);
        
    // Traverse arrière
    translate([metal_profile_size, rack_depth - metal_profile_size, ground_clearance])
        square_profile(inner_frame_w, metal_profile_size, metal_profile_size);
        
    // --- Traverses de jonction (en haut) ---
    // Centrée sur les plaques de montage avant
    front_top_y = metal_profile_size + rail_depth_margin + (mounting_plate_depth - metal_profile_size)/2;
    translate([metal_profile_size, front_top_y, h_total - metal_profile_size])
        square_profile(inner_frame_w, metal_profile_size, metal_profile_size);
        
    // Centrée sur les plaques de montage arrière
    rear_top_y = rack_depth - metal_profile_size - rail_depth_margin - mounting_plate_depth + (mounting_plate_depth - metal_profile_size)/2;
    translate([metal_profile_size, rear_top_y, h_total - metal_profile_size])
        square_profile(inner_frame_w, metal_profile_size, metal_profile_size);
}

if (afficher_grille_ventilation) {
    // --- Fausse paroi en grillage (Côté gauche) ---
    cooling_mesh_wall();
}

if (afficher_panneaux_avant) {
    // --- Front panel fictif (1er U) ---
    translate([metal_profile_size + frame_gap + panel_margin + panel_width / 2, metal_profile_size + rail_depth_margin - 1.5, start_z + U/2])
        basic_front_plate(units=1);
        
    // --- Front panel fictif (2ème U) ---
    translate([metal_profile_size + frame_gap + panel_margin + panel_width / 2, metal_profile_size + rail_depth_margin - 1.5, start_z + U + U/2])
        basic_front_plate(units=1);
        
    // --- Rear panel fictif (1er U) ---
    translate([metal_profile_size + frame_gap + panel_margin + panel_width / 2, rack_depth - metal_profile_size - rail_depth_margin + 1.5, start_z + U/2])
        rotate([0, 0, 180]) basic_front_plate(units=1);
        
    // --- Rear panel fictif (2ème U) ---
    translate([metal_profile_size + frame_gap + panel_margin + panel_width / 2, rack_depth - metal_profile_size - rail_depth_margin + 1.5, start_z + U + U/2])
        rotate([0, 0, 180]) basic_front_plate(units=1);
}

module steel_binding_bar(p1, p2, d=3) {
    color("DimGray")
    hull() {
        translate(p1) sphere(d=d, $fn=16);
        translate(p2) sphere(d=d, $fn=16);
    }
}

module rail_mounting_plate(h) {
    // Une plaque métallique simple de 4mm d'épaisseur
    // Fer plat de 25mm de large
    color("Silver")
    difference() {
        cube([mounting_plate_thickness, mounting_plate_depth, h]);
        
        // Encoche pour la traverse métallique du haut
        translate([-1, (mounting_plate_depth - metal_profile_size)/2, h - metal_profile_size])
            cube([mounting_plate_thickness + 2, metal_profile_size, metal_profile_size + 1]);
    }
}

if (afficher_pieces_montage) {
    // --- Commercial Rack Rails (8U) ---
    rail_start_z = start_z;
    
    // --- Barres de renfort en acier (3mm) au bas des plaques ---
    binding_z = start_z + 30; // 3cm du bas
    
    // Front Left (de poteau avant gauche vers plaque avant gauche)
    steel_binding_bar(
        [metal_profile_size, metal_profile_size, binding_z], 
        [metal_profile_size + frame_gap - mounting_plate_thickness, metal_profile_size + rail_depth_margin, binding_z]
    );
    // Front Right (de poteau avant droit vers plaque avant droite)
    steel_binding_bar(
        [metal_profile_size + inner_frame_w, metal_profile_size, binding_z], 
        [metal_profile_size + frame_gap + panel_width + panel_margin*2 + mounting_plate_thickness, metal_profile_size + rail_depth_margin, binding_z]
    );
    // Rear Left (de poteau arrière gauche vers plaque arrière gauche)
    steel_binding_bar(
        [metal_profile_size, rack_depth - metal_profile_size, binding_z], 
        [metal_profile_size + frame_gap - mounting_plate_thickness, rack_depth - metal_profile_size - rail_depth_margin, binding_z]
    );
    // Rear Right (de poteau arrière droit vers plaque arrière droite)
    steel_binding_bar(
        [metal_profile_size + inner_frame_w, rack_depth - metal_profile_size, binding_z], 
        [metal_profile_size + frame_gap + panel_width + panel_margin*2 + mounting_plate_thickness, rack_depth - metal_profile_size - rail_depth_margin, binding_z]
    );

    // Plaques de fixation métalliques (1mm) individuelles (étendues jusqu'aux traverses du haut)
    plate_h = h_total - start_z;
    
    // Front Left Plate
    translate([metal_profile_size + frame_gap - mounting_plate_thickness, metal_profile_size + rail_depth_margin, start_z])
        rail_mounting_plate(plate_h);
        
    // Front Right Plate
    translate([metal_profile_size + frame_gap + panel_width + panel_margin*2, metal_profile_size + rail_depth_margin, start_z])
        rail_mounting_plate(plate_h);
        
    // Rear Left Plate
    translate([metal_profile_size + frame_gap - mounting_plate_thickness, rack_depth - metal_profile_size - rail_depth_margin, start_z])
        scale([1, -1, 1]) rail_mounting_plate(plate_h);
        
    // Rear Right Plate
    translate([metal_profile_size + frame_gap + panel_width + panel_margin*2, rack_depth - metal_profile_size - rail_depth_margin, start_z])
        scale([1, -1, 1]) rail_mounting_plate(plate_h);
    
    // Front Left Rails
    translate([metal_profile_size + frame_gap, metal_profile_size + rail_depth_margin, rail_start_z])
        commercial_rack_rail(8);
    translate([metal_profile_size + frame_gap, metal_profile_size + rail_depth_margin, rail_start_z + 8*U])
        commercial_rack_rail(8);
        
    // Front Right Rails
    translate([metal_profile_size + frame_gap + panel_width + panel_margin*2, metal_profile_size + rail_depth_margin, rail_start_z])
        scale([-1, 1, 1]) commercial_rack_rail(8);
    translate([metal_profile_size + frame_gap + panel_width + panel_margin*2, metal_profile_size + rail_depth_margin, rail_start_z + 8*U])
        scale([-1, 1, 1]) commercial_rack_rail(8);

    // Rear Left Rails
    translate([metal_profile_size + frame_gap, rack_depth - metal_profile_size - rail_depth_margin, rail_start_z])
        scale([1, -1, 1]) commercial_rack_rail(8);
    translate([metal_profile_size + frame_gap, rack_depth - metal_profile_size - rail_depth_margin, rail_start_z + 8*U])
        scale([1, -1, 1]) commercial_rack_rail(8);
        
    // Rear Right Rails
    translate([metal_profile_size + frame_gap + panel_width + panel_margin*2, rack_depth - metal_profile_size - rail_depth_margin, rail_start_z])
        scale([-1, -1, 1]) commercial_rack_rail(8);
    translate([metal_profile_size + frame_gap + panel_width + panel_margin*2, rack_depth - metal_profile_size - rail_depth_margin, rail_start_z + 8*U])
        scale([-1, -1, 1]) commercial_rack_rail(8);
}

if (afficher_habillage_bois) {
    // --- Habillage Bois ---
    // Planche supérieure (Toit)
    color("#3E2723") // Brun sombre
    translate([-wood_overhang, -wood_overhang, h_total])
        cube([
            (metal_profile_size*2 + inner_frame_w) + wood_overhang*2, 
            rack_depth + wood_overhang*2, 
            wood_thickness_top
        ]);
        
    // Panneau latéral droit
    gap = 10;
    panel_y = metal_profile_size + gap;
    panel_z = ground_clearance + gap;
    panel_w = (rack_depth - 2 * metal_profile_size) - 2 * gap;
    panel_h = (h_total - metal_profile_size - ground_clearance) - 2 * gap;
    panel_x_offset = (metal_profile_size - wood_thickness_side) / 2;
    
    color("#3E2723")
    translate([metal_profile_size + inner_frame_w + panel_x_offset, panel_y, panel_z])
        cube([wood_thickness_side, panel_w, panel_h]);
        
    // Planche sur les traverses du bas (base massive)
    color("#3E2723")
    translate([metal_profile_size, 0, ground_clearance + metal_profile_size])
        cube([inner_frame_w, rack_depth, wood_thickness_bottom]);
}
}

// Affichage principal
rack_chassis();

// ==========================================
// BOM (Bill of Materials) - Découpes Acier
// ==========================================
h_total = rack_height; 
cross_front = panel_width + panel_margin*2 + frame_gap*2;

mesh_gap = 10;
mesh_frame = 10;
mesh_h = (h_total - metal_profile_size - ground_clearance) - 2 * mesh_gap;
mesh_w = (rack_depth - 2 * metal_profile_size) - 2 * mesh_gap - 2 * mesh_frame;

echo("");
echo("=========================================");
echo("LISTE DES DECOUPES - PROFILES ACIER");
echo("=========================================");
echo(str("Profile carre ", metal_profile_size, "x", metal_profile_size, " mm (Structure Principale) :"));
echo(str("  - 4x Montants verticaux (Coupes biaises 45° haut et bas) : ", h_total, " mm hors tout"));
echo(str("  - 4x Traverses laterales (Coupes biaises 45° avant et arrière) : ", rack_depth, " mm hors tout"));
echo(str("  - 4x Traverses largeur (Coupes droites 90°) : ", cross_front, " mm"));
echo(str("    -> Total lineaire estime : ", (4*h_total + 4*rack_depth + 4*cross_front)/1000, " metres"));
echo("");
echo(str("Profile carre ", mesh_frame, "x", mesh_frame, " mm (Cadre Grille Ventilation) :"));
echo(str("  - 2x Montants verticaux : ", mesh_h, " mm"));
echo(str("  - 2x Traverses horizontales : ", mesh_w, " mm"));
echo(str("    -> Total lineaire estime : ", (2*mesh_h + 2*mesh_w)/1000, " metres"));
echo("=========================================");
echo("");
