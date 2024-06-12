importiere numpy als np
def hard_sphere_potential(distanz, durchmesser=1.0):
    wenn distanz < durchmesser:
        Rückkehr float('inf')
    sonst:
        Rückkehr 0.0

def lennard_jones_potential(distanz, epsilon=10.0, sigma=0.45, durchmesser=1.0):
    wenn distanz < durchmesser*0.95:
        Rückkehr float("inf")
    r6 = np.power((np.divide(sigma,distanz)), 6)
    r12 = np.power(r6, 2)
    Rückkehr 4 * epsilon * (r12 - r6)

def interaction_potential(patch1, patch2, distanz):
    wenn patch1 == patch2:
        #Hard sphere potential für A-A und B-B interactions
        Rückkehr hard_sphere_potential(distanz)
    sonst:
        #Lennard-Jones potential für A-B interactions
        Rückkehr lennard_jones_potential(distanz)
