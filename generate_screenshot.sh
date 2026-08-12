#!/bin/bash

# Se place automatiquement dans le répertoire du script (racine du projet)
cd "$(dirname "$0")"

# Création du dossier screenshots s'il n'existe pas
mkdir -p screenshots

# Génération d'un timestamp (Format: YYYYMMDD_HHMMSS)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="screenshots/rack_rendered_${TIMESTAMP}.png"

echo "📸 Génération du rendu OpenSCAD en cours..."
echo "Fichier de sortie : $OUTPUT_FILE"

# Commande OpenSCAD via Flatpak avec vos paramètres de caméra
flatpak run org.openscad.OpenSCAD -o "$OUTPUT_FILE" \
  --imgsize=1920,1080 \
  --projection=p \
  --camera=100,250,500,70,0,30,3000 \
  --colorscheme="Tomorrow Night" \
  rack_10inches/rack_assembly.scad

# Vérification du statut de la commande
if [ $? -eq 0 ]; then
    echo "✅ Rendu terminé avec succès !"
else
    echo "❌ Erreur lors de la génération du rendu. Assurez-vous que l'exécutable 'openscad' est bien installé et accessible dans votre PATH."
fi
