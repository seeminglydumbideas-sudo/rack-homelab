include <constants.scad>

module square_profile_mesh(w, d, h) {
    color("DimGray")
    cube([w, d, h]);
}

// ==========================================
// Paroi latérale gauche en grillage pour ventilateurs
// ==========================================
module cooling_mesh_wall() {
    // Épaisseur du sous-cadre du grillage (profilés acier plus fins, ex: 10x10mm)
    frame = 10;
    
    // Positionnement dans la "fenêtre" du cadre gauche (qui fait 15x15 d'épaisseur)
    x_offset = (metal_profile_size - frame) / 2; // Centré dans l'épaisseur de 15mm
    
    // Espace libre tout autour du sous-cadre
    gap = 10;
    
    // Profondeur disponible (entre le montant avant et arrière, moins les espaces)
    w = (rack_depth - 2 * metal_profile_size) - 2 * gap; 
    
    // Hauteur disponible (démarre de ground_clearance jusqu'à la barre supérieure, moins les espaces)
    h_total = rack_height;
    h = (h_total - metal_profile_size - ground_clearance) - 2 * gap;
    
    translate([x_offset, metal_profile_size + gap, ground_clearance + gap]) {
        // --- Cadre du grillage ---
        // Montants verticaux
        square_profile_mesh(frame, frame, h);
        translate([0, w - frame, 0]) square_profile_mesh(frame, frame, h);
        
        // Traverses horizontales
        translate([0, frame, 0]) square_profile_mesh(frame, w - 2*frame, frame);
        translate([0, frame, h - frame]) square_profile_mesh(frame, w - 2*frame, frame);
        
        // --- Le grillage ---
        // Représenté par un plan semi-transparent pour ne pas alourdir la 3D
        color([0.2, 0.2, 0.2, 0.5])
        translate([frame/2 - 1, frame, frame])
            cube([2, w - 2*frame, h - 2*frame]);
            
        // --- Ventilateurs (simulation 120mm) ---
        fan_size = 120;
        fan_thick = 25;
        num_fans = 4; // On place 4 ventilateurs espacés
        spacing_z = (h - 2*frame - num_fans*fan_size) / (num_fans + 1);
        
        // On retire le ventilateur le plus bas en commençant la boucle à 1 au lieu de 0
        for(i = [1 : num_fans - 1]) {
            fan_z = frame + spacing_z + i*(fan_size + spacing_z);
            // On centre les ventilateurs en Y (profondeur)
            fan_y = (w - fan_size) / 2;
            
            // Fixés côté intérieur du grillage (ils débordent dans le rack)
            color("Black")
            translate([frame/2 + 1, fan_y, fan_z])
                difference() {
                    // Corps du ventilateur
                    cube([fan_thick, fan_size, fan_size]);
                    // Trou circulaire du rotor
                    translate([-1, fan_size/2, fan_size/2])
                        rotate([0, 90, 0])
                        cylinder(r=fan_size/2 - 3, h=fan_thick + 2, $fn=32);
                }
        }
    }
}

// Affichage de test si on ouvre juste ce fichier
// cooling_mesh_wall();
