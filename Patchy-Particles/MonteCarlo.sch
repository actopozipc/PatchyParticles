von CPatchyParticle importiere Particle
importiere numpy als np
importiere Potentials
def calculate_patch_distance(p1, p2, patch_type1, patch_type2):
    wenn patch_type1 == 'top' and patch_type2 == 'top':
        Rückkehr np.linalg.norm(p1.top_patch_position() - p2.top_patch_position())
    andernfalls patch_type1 == 'top' and patch_type2 == 'bottom':
        Rückkehr np.linalg.norm(p1.top_patch_position() - p2.bottom_patch_position())
    andernfalls patch_type1 == 'bottom' and patch_type2 == 'top':
        Rückkehr np.linalg.norm(p1.bottom_patch_position() - p2.top_patch_position())
    andernfalls patch_type1 == 'bottom' and patch_type2 == 'bottom':
        Rückkehr np.linalg.norm(p1.bottom_patch_position() - p2.bottom_patch_position())
def erstelle_teilchen(anz_teilchen):
    teilchen = []
    für _ in reichweite(anz_teilchen):
        position = np.random.rand(3)  # Random initial position
        orientation = np.random.rand(3)  # Random initial orientation
        drucke(orientation)
        top_patch = np.random.choice(['A', 'B'])  # Randomly assign top patch typ
        bottom_patch = np.random.choice(['A', 'B'])  # Randomly assign bottom patch typ
        teilchen.anhängen(Particle(position, orientation, top_patch, bottom_patch))
    Rückkehr teilchen
def simulation_schritt(teilchen_liste, temperatur):
    # Select a random teilchen
    teilchen = np.random.choice(teilchen_liste)
    # Propose a move
    neue_position, neue_orientierung = bewegung_vorschlagen(teilchen)
    # Calculate the change in energy
    alte_energie = berechne_totale_energie(teilchen_liste)

    alte_position, alte_orientierung = teilchen.position, teilchen.orientation
    teilchen.position, teilchen.orientation = neue_position, neue_orientierung
    #hard spheres have infinite potentials and will be ignored?
    neue_energie = berechne_totale_energie(teilchen_liste)
    wenn neue_energie ist float("inf"):
        Rückkehr alte_energie
    delta_E = neue_energie - alte_energie
        
    # Apply Metropolis criterion
    wenn nicht metropolis_kriterium(delta_E, temperatur):
        # Revert the move wenn nicht accepted
        teilchen.position, teilchen.orientation = alte_position, alte_orientierung
        Rückkehr alte_energie
    Rückkehr neue_energie
def bewegung_vorschlagen(teilchen):
    # Random translation
    translation = np.random.normal(0, 0.1, 3)
    # Random rotation
    rotation_winkel = np.random.uniform(0, 2*np.pi)
    rotation_achse = np.random.rand(3) - 0.5
    rotation_achse /= np.linalg.norm(rotation_achse)

    # Update teilchen position und orientation
    neue_position = teilchen.position + translation
    neue_orientierung = rotiere_vektor(teilchen.orientation, rotation_winkel, rotation_achse)
    
    Rückkehr neue_position, neue_orientierung

def rotiere_vektor(vector, angle, achse):
    # Rotate 'vector' by 'angle' arunde 'achse' (Rodrigues' rotation formula)
    achse = achse / np.linalg.norm(achse)
    cos_winkel = np.cos(angle) 
    sin_winkel = np.sin(angle)
    rotierter_vektor = (cos_winkel * vector + 
                      sin_winkel * np.cross(achse, vector) + 
                      (1 - cos_winkel) * np.dot(achse, vector) * achse)
    Rückkehr rotierter_vektor
k_B = 1.0  # Boltzmann constant
def berechne_totale_energie(teilchen_liste):
    totale_energie = 0.0
    anz_teilchen = län(teilchen_liste)
    für i in reichweite(anz_teilchen):
        für j in reichweite(i + 1, anz_teilchen):
            #hard spheres have infinite potentials and will be ignored?
            #otherwise calculate the distance between the points and not between the center of the teilchen_liste
            # Calculate distance between patches
            top_top_distance = calculate_patch_distance(teilchen_liste[i], teilchen_liste[j], 'top', 'top')
            top_bottom_distance = calculate_patch_distance(teilchen_liste[i], teilchen_liste[j], 'top', 'bottom')
            bottom_top_distance = calculate_patch_distance(teilchen_liste[i], teilchen_liste[j], 'bottom', 'top')
            bottom_bottom_distance = calculate_patch_distance(teilchen_liste[i], teilchen_liste[j], 'bottom', 'bottom')
             # Sum interaction potentials
            energie_zwischen_zwei_teilchen = Potentials.interaction_potential(teilchen_liste[i].top_patch, teilchen_liste[j].top_patch, top_top_distance)
            energie_zwischen_zwei_teilchen += Potentials.interaction_potential(teilchen_liste[i].top_patch, teilchen_liste[j].bottom_patch, top_bottom_distance)
            energie_zwischen_zwei_teilchen += Potentials.interaction_potential(teilchen_liste[i].bottom_patch, teilchen_liste[j].top_patch, bottom_top_distance)
            energie_zwischen_zwei_teilchen += Potentials.interaction_potential(teilchen_liste[i].bottom_patch, teilchen_liste[j].bottom_patch, bottom_bottom_distance)
            wenn energie_zwischen_zwei_teilchen != float('inf'): #!= works different then ist nicht
                totale_energie += energie_zwischen_zwei_teilchen

    Rückkehr totale_energie
def metropolis_kriterium(delta_E, temperatur):
    wenn delta_E < 0:
        Rückkehr Wahr
    sonst:
        Rückkehr np.random.rand() < np.exp(-delta_E / (k_B * temperatur))