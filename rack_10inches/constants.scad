// Constantes pour le meuble Rack 10 pouces
// Unité de base : mm

// Unité de rack (U) standard
U = 44.45;

// Nombre d'unités (U) pour la hauteur interne
total_U = 22; // ~1 mètre

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
wood_thickness = 18; // Épaisseur des planches en bois
wood_overhang = 0; // Aucun débordement, la planche est à fleur du cadre
