WIDTH="2400" # Taille max en pixels

# Pour chaque image sélectionnée
for FILE in "$@"; do
		
   	# On récupère la largeur et la hauteur en pixels de l'image cible
	IMG_WIDTH="$(/usr/bin/sips -g pixelWidth "$FILE" | awk '/pixelWidth/ {print $2}')"
   	IMG_HEIGHT="$(/usr/bin/sips -g pixelHeight "$FILE" | awk '/pixelHeight/ {print $2}')"

	# Si la largeur de l'image cible est supérieure à la taille max (-gt = greater than) 
	# Et si la largeur est inférieure à 2 fois la hauteur (donc image non panormaique)
	if [ $IMG_WIDTH -gt $WIDTH -a $IMG_WIDTH -lt $((2*$IMG_HEIGHT)) ]; then

      	echo "Converting ${FILE} (original size $IMG_WIDTH x $IMG_HEIGHT px)…"
	
        # On récupère la date de création de l'image cible
	    TARGET="$(/usr/bin/GetFileInfo -d "$FILE")"

        # On redimensionne l'image cible
	    /usr/bin/sips --resampleWidth $WIDTH "$FILE" > /dev/null 2>&1  # Masquer la sortie de sips 

        # On définit les dates de création et de modification de l'image cible par les valeurs récupérées de $target
	    /usr/bin/SetFile -m "$TARGET" -d "$TARGET" "$FILE"
	fi


	# Si la hauteur de l'image cible est supérieure à la taille max (-gt = greater than) 
	# Et si la hauteur est inférieure à 2 fois la largeur (donc image non panormaique verticale)
	if [ $IMG_HEIGHT -gt $WIDTH -a $IMG_HEIGHT -lt $((2*$IMG_WIDTH)) ]; then

      	echo "Converting ${FILE} (original size $IMG_WIDTH x $IMG_HEIGHT px)…"
	
        # On récupère la date de création de l'image cible
	    TARGET="$(/usr/bin/GetFileInfo -d "$FILE")"

        # On redimensionne l'image cible
	    /usr/bin/sips --resampleHeight $WIDTH "$FILE" > /dev/null 2>&1  # Masquer la sortie de sips 

        # On définit les dates de création et de modification de l'image cible par les valeurs récupérées de $target
	    /usr/bin/SetFile -m "$TARGET" -d "$TARGET" "$FILE"

	fi

done

# Notification sonore quand le traitement est terminé
/usr/bin/afplay "/System/Library/Sounds/Glass.aiff"
