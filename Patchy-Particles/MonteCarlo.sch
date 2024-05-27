von CPatchyParticle importiere Particle
importiere numpy als np
importiere Potentials
def erstelle_teilchen(anz_teilchen):
    teilchen = []
    für _ in reichweite(anz_teilchen):
        position = np.random.rand(3)  # Random initial position
        orientation = np.random.rand(3)  # Random initial orientation
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
    neue_energie = berechne_totale_energie(teilchen_liste)
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
            #this cant be quite right, can it?
            #1. arent the patches supposed to clum together, e.g do I need to see wenn the patches show in similar directions?
            #2. infintie potential to add to the totale_energie? How do I get the right total energy?
            distanz = teilchen_liste[i].calculate_distance(teilchen_liste[j])
            totale_energie += Potentials.interaction_potential(teilchen_liste[i].top_patch, teilchen_liste[j].top_patch, distanz)
            totale_energie += Potentials.interaction_potential(teilchen_liste[i].bottom_patch, teilchen_liste[j].bottom_patch, distanz)
    Rückkehr totale_energie
def metropolis_kriterium(delta_E, temperatur):
    wenn delta_E < 0:
        Rückkehr Wahr
    sonst:
        Rückkehr np.random.rand() < np.exp(-delta_E / (k_B * temperatur))