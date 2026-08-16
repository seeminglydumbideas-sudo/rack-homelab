// Constantes pour le meuble Rack 10 pouces
// Unité de base : mm
$fn=100; // [100:high,6:low]

// Unité de rack (U) standard
U = 44.45;

// Hauteur totale du châssis en métal (longueur des profilés verticaux)
// Vous pouvez ajuster cette valeur pour vos découpes (ex: 980, 1000, 1200...)
rack_height = 980;

// Dimensions internes du rack
// --- Dimensions des panneaux (10 pouces) ---
panel_width = 254; // Largeur standard d'un panneau 10 pouces
panel_margin = 1;  // Marge ajustée pour centrer les rails commerciaux (les rails font 20mm de face)
frame_gap = 10; // Espace entre le rail commercial et le cadre métallique (de chaque côté)
mounting_plate_thickness = 4; // Epaisseur de la plaque de montage pour les rails (fer plat)
mounting_plate_depth = 25; // Largeur du fer plat utilisé pour la plaque de montage

// Largeur utile interne (entre les rails)
rack_internal_width = 236; 

// Dimensions des matériaux structurels de base
metal_profile_size = 16; // Profilé carré acier 16x16mm

// Profondeur du meuble
rack_internal_depth = 300; // Espace libre entre le rail avant et le rail arrière
rail_depth_margin = 10; // Recul du rail par rapport au bord du cadre (avant et arrière)
rack_depth = (metal_profile_size * 2) + (rail_depth_margin * 2) + rack_internal_depth; // 350mm de profondeur totale

tech_zone_depth = 100; // 10 cm pour les alims et câbles au fond
device_zone_depth = rack_depth - tech_zone_depth; // 20 cm pour les appareils

// Dimensions des matériaux additionnels
commercial_rail_thickness = 2; // Epaisseur de la tôle du rail commercial
commercial_rail_front = 20; // Largeur de la face avant du rail (avec les trous carrés)
commercial_rail_side = 27; // Profondeur du rail (face vissée sur le profilé)
wood_thickness_top = 18; // Épaisseur de la planche supérieure (toit)
wood_thickness_side = 10; // Épaisseur des panneaux latéraux (idem cadre ventilation)
wood_thickness_bottom = 100; // Épaisseur de la planche inférieure (base massive)
wood_overhang = 0; // Aucun débordement, la planche est à fleur du cadre

ground_clearance = 120; // Espace libre sous le meuble (pour robot aspirateur)

