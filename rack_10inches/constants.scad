// Constantes pour le meuble Rack 10 pouces
// Unité de base : mm
$fn=100; // [100:high,6:low]

// Unité de rack (U) standard
U = 44.45;

// Hauteur totale du châssis en métal (longueur des profilés verticaux)
// Vous pouvez ajuster cette valeur pour vos découpes (ex: 980, 1000, 1200...)
rack_height = 980;

// Dimensions internes du rack
// Largeur de la façade (10 pouces)
panel_width = 254; 
panel_margin = 4; // Marge entre le panneau et le profilé

// Largeur utile interne (entre les rails)
rack_internal_width = 236; 

// Profondeur du meuble
rack_depth = 300; // 30 cm de profondeur totale
tech_zone_depth = 100; // 10 cm pour les alims et câbles au fond
device_zone_depth = rack_depth - tech_zone_depth; // 20 cm pour les appareils

// Dimensions des matériaux
metal_profile_size = 15; // Profilé carré acier 15x15mm
wood_thickness_top = 18; // Épaisseur de la planche supérieure (toit)
wood_thickness_side = 10; // Épaisseur des panneaux latéraux (idem cadre ventilation)
wood_thickness_bottom = 100; // Épaisseur de la planche inférieure (base massive)
wood_overhang = 0; // Aucun débordement, la planche est à fleur du cadre

ground_clearance = 120; // Espace libre sous le meuble (pour robot aspirateur)

