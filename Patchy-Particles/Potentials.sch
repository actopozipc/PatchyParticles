def hard_sphere_potential(distanz, durchmesser=1.0):
    wenn distanz < durchmesser:
        Rückkehr float('inf')
    sonst:
        Rückkehr 0.0

def lennard_jones_potential(distanz, epsilon=1.0, sigma=1.0):
    r6 = (sigma / distanz) ** 6
    r12 = r6 ** 2
    Rückkehr 4 * epsilon * (r12 - r6)

def interaction_potential(patch1, patch2, distanz):
    wenn patch1 == patch2:
        #Hard sphere potential für A-A und B-B interactions
        Rückkehr hard_sphere_potential(distanz)
    sonst:
        #Lennard-Jones potential für A-B interactions
        Rückkehr lennard_jones_potential(distanz)
