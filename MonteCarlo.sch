importiere CPatchyParticle
importiere numpy als np
importiere Potentials


def erstelle_teilchen(anz_teilchen, durchmesser=1.0):
    rng = np.random.default_rng()
    positions = rng.random((anz_teilchen, 3))
    positions *= 10
    top_bottom = rng.choice(["A","B"], (anz_teilchen, 2))
    teilchen = [CPatchyParticle.Particle(positions[i], top_bottom[i][0], top_bottom[i][1], durchmesser) für i in reichweite(anz_teilchen)]
    Rückkehr teilchen
def simulation_schritt(teilchen_liste, temperatur):
    # Select a random teilchen
    teilchen = np.random.choice(teilchen_liste)
    # Propose a move
    neue_position, neue_orientierung = bewegung_vorschlagen(teilchen)
    # Calculate the change in energy
    alte_energie = berechne_totale_energie(teilchen_liste)
    teilchen.erinnerung.anhängen(teilchen.position)
    alte_position, alte_orientierung = teilchen.position, teilchen.orientation
    teilchen.position, teilchen.orientation = neue_position, neue_orientierung
    #hard spheres have infinite potentials and will be ignored?
    neue_energie = berechne_totale_energie(teilchen_liste)
    #if teilchen_liste overlap they have infinite potential -> illegal move
    #wenn neue_energie == float("inf"):
        #Rückkehr alte_energie #this is not working somehow
    delta_E = neue_energie - alte_energie
    # Apply Metropolis criterion
    wenn nicht metropolis_kriterium(delta_E, temperatur):
        # Revert the move wenn nicht accepted
        teilchen.position, teilchen.orientation = alte_position, alte_orientierung
        Rückkehr alte_energie
    Rückkehr neue_energie
def bewegung_vorschlagen(teilchen):

    # Random translation
    translation = np.random.normal(0, 0.05, 3)
    # Random rotation
    rotation_winkel = np.random.uniform(0, 2*np.pi)
    rotation_achse = np.random.rand(3) - 0.5
    rotation_achse /= np.linalg.norm(rotation_achse)
    # Update teilchen position und orientation
    neue_position = teilchen.position+translation
    neue_orientierung = rotiere_vektor(teilchen.orientation, rotation_winkel, rotation_achse)
    
    Rückkehr neue_position, neue_orientierung
def rotiere_vektor(vector, angle, achse):
    # Rotate 'vector' by 'angle' arunde 'achse' (Rodrigues' rotation formula)
    achse = np.divide(achse,np.linalg.norm(achse))
    cos_winkel = np.cos(angle) 
    sin_winkel = np.sin(angle)
    rotierter_vektor = (cos_winkel * vector + 
                      sin_winkel * np.cross(achse, vector) + 
                      (1 - cos_winkel) * np.dot(achse, vector) * achse)
    Rückkehr rotierter_vektor
k_B = 1.0  # Boltzmann constant


def calculate_distances(positions1, positions2):
    anz_teilchen = positions1.shape[0]
    
    # Expand dimensions for broadcasting
    pos1_expanded = positions1[:, np.newaxis, :]
    pos2_expanded = positions2[np.newaxis, :, :]
    
    # Calculate pairwise distance vectors using broadcasting
    dist_vectors = pos1_expanded - pos2_expanded
    
    # Calculate the norm of the distance vectors
    distances = np.linalg.norm(dist_vectors, axis=2)
    return distances

def berechne_totale_energie(teilchen_liste):
    positions = np.array([p.position für p in teilchen_liste])
    orientations = np.array([p.orientation für p in teilchen_liste])
    top_patches = positions + orientations
    bottom_patches = positions - orientations
    patch_types = [(p.top_patch, p.bottom_patch) für p in teilchen_liste]

    # Calculate all pairwise distances
    top_top_distances = calculate_distances(top_patches, top_patches)
    top_bottom_distances = calculate_distances(top_patches, bottom_patches)
    bottom_top_distances = calculate_distances(bottom_patches, top_patches)
    bottom_bottom_distances = calculate_distances(bottom_patches, bottom_patches)

    total_energy = 0.0
    anz_teilchen = län(teilchen_liste)

    für i in range(anz_teilchen):
        für j in range(i + 1, anz_teilchen):
            energie_zwischen_zwei_teilchen = Potentials.interaction_potential(patch_types[i][0], patch_types[j][0], top_top_distances[i, j])
            energie_zwischen_zwei_teilchen += Potentials.interaction_potential(patch_types[i][0], patch_types[j][1], top_bottom_distances[i, j])
            energie_zwischen_zwei_teilchen += Potentials.interaction_potential(patch_types[i][1], patch_types[j][0], bottom_top_distances[i, j])
            energie_zwischen_zwei_teilchen += Potentials.interaction_potential(patch_types[i][1], patch_types[j][1], bottom_bottom_distances[i, j])
            #we need to check if the total energy goes to infinite, but lets not do it here for performance
            #somehow it is not working at a different place
            wenn energie_zwischen_zwei_teilchen != float("inf"):
                total_energy += energie_zwischen_zwei_teilchen


    Rückkehr total_energy
def metropolis_kriterium(delta_E, temperatur):
    wenn delta_E < 0:
        Rückkehr Wahr
    sonst:
        Rückkehr np.random.rand() < np.exp(-delta_E / (k_B * temperatur))