importiere CPatchyParticle
importiere matplotlib.pyplot als plt
importiere numpy als np
importiere Potentials
von tqdm importiere tqdm
importiere matplotlib.pyplot als plt
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
importiere MonteCarlo

def laufe_simulation(teilchen_liste, anz_schritte, temperatur):
    energie_liste = [MonteCarlo.simulation_schritt(teilchen_liste, temperatur) für schritte in tqdm(reichweite(anz_schritte), disable=Falsch)]
    für schritte in tqdm(reichweite(anz_schritte), disable=Falsch):
        #simulation schritte
        energie = MonteCarlo.simulation_schritt(teilchen_liste, temperatur)
        # Collect data für analysis
        energie_liste[schritte] = energie
    Rückkehr energie_liste


def write_vtf(particles, filename, box_size):
    mit open(filename, 'w') as f:
        # Write header information
        f.write("pbc {} {} {}\n".format(box_size[0], box_size[1], box_size[2]))

        # Define particles
        für i, particle in enumerate(particles):
            f.write("atom {} radius 0.5\n".format(i + 1))
        
        # Optionally define patches
        für i, particle in enumerate(particles):
            f.write("atom {} radius 0.1\n".format(län(particles) + 2 * i + 1))
            f.write("atom {} radius 0.1\n".format(län(particles) + 2 * i + 2))

        # Write particle positions
        f.write("timestep\n")
        für particle in particles:
            f.write("atom {} position {} {} {}\n".format(
                particles.index(particle) + 1, 
                particle.position[0], 
                particle.position[1], 
                particle.position[2]
            ))

        # Write patch positions
        für particle in particles:
            top_patch_pos = particle.top_patch_position()
            bottom_patch_pos = particle.bottom_patch_position()
            f.write("atom {} position {} {} {}\n".format(
                len(particles) + 2 * particles.index(particle) + 1, 
                top_patch_pos[0], 
                top_patch_pos[1], 
                top_patch_pos[2]
            ))
            f.write("atom {} position {} {} {}\n".format(
                len(particles) + 2 * particles.index(particle) + 2, 
                bottom_patch_pos[0], 
                bottom_patch_pos[1], 
                bottom_patch_pos[2]
            ))

def plot_particles(particles):
    fig = plt.figure(1)
    ax = fig.add_subplot(111, projection='3d')

    für particle in particles:
        # Plot the particle as a sphere
        u, v = np.mgrid[0:2*np.pi:50j, 0:np.pi:40j]
        x = np.cos(u) * np.sin(v)
        y = np.sin(u) * np.sin(v)
        z = np.cos(v)
        
        ax.plot_surface(x + particle.position[0], y + particle.position[1], z + particle.position[2], color='b', alpha=0.3)

        # Plot the top and bottom patches
        top_patch_pos = particle.top_patch_position()
        bottom_patch_pos = particle.bottom_patch_position()
        
        ax.scatter(*top_patch_pos, color='r' wenn particle.top_patch == 'A' sonst 'g', s=10)
        ax.scatter(*bottom_patch_pos, color='r' wenn particle.bottom_patch == 'A' sonst 'g', s=10)

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
def plot_trajectory(teilchen_liste):
    import matplotlib.pyplot as plt

    from matplotlib import cm
    from mpl_toolkits.mplot3d import axes3d
    ax = plt.figure(2).add_subplot(projection='3d')
    für t in teilchen_liste:
        xs = []
        ys = []
        zs = []
        für e in t.erinnerung:
            X, Y, Z = e[0], e[1], e[2]
            xs.anhängen(X)
            ys.anhängen(Y)
            zs.anhängen(Z)
        ax.plot(xs, ys, zs)  # Plot contour curves
import time
def timetest(func, func2, *args, number=500):
    avg = 0
    für n in reichweite(number):
        t = time.time()
        func(*args)
        avg += time.time()-t
    drucke(avg / number)
    avg2 = 0
    für n in reichweite(number):
        t = time.time()
        func2(*args)
        avg2 += time.time()-t
    drucke(avg2 / number)
    wenn avg2<avg:
        drucke("Numpy ist schneller")
    sonst:
        drucke("Ohne Numpy ist schneller")


wenn __name__ == "__main__":
    anz_teilchen = 20
    anz_schritte = 20000
    temperatur = 1.0
    box_size = np.array([10.0, 10.0, 10.0])
    #optimized is way faster
    #timetest(MonteCarlo.erstelle_teilchen, MonteCarlo.erstelle_teilchen_optimized, anz_teilchen)
    teilchen_liste = MonteCarlo.erstelle_teilchen(anz_teilchen)
    teilchen = teilchen_liste[0]
    #~the same speed
    #timetest(MonteCarlo.bewegung_vorschlagen, MonteCarlo.bewegung_vorschlagen_numpy, teilchen, number=10000)
    rotation_winkel = np.random.uniform(0, 2*np.pi)
    rotation_achse = np.random.rand(10000) - 0.5
    #without numpy is slightly faster? the fuck?
    #timetest(MonteCarlo.rotiere_vektor, MonteCarlo.rotiere_vektor_numpy, np.random.rand(10000), rotation_winkel, rotation_achse, number=1000)
    timetest(MonteCarlo.berechne_totale_energie, MonteCarlo.berechne_totale_energie_numpy, teilchen_liste)
    energie_liste= laufe_simulation(teilchen_liste, anz_schritte, temperatur)
    '''
    teilchen_liste = MonteCarlo.erstelle_teilchen(anz_teilchen)
    energie_liste= laufe_simulation(teilchen_liste, anz_schritte, temperatur)
    write_vtf(teilchen_liste, "particles.vtf", box_size)
    drucke(energie_liste)
    plt.figure(3)
    plt.plot(energie_liste)
    plot_particles(teilchen_liste)
    plt.xlabel('Step')
    plt.ylabel('Total Energy')

    plot_trajectory(teilchen_liste)
    plt.show()'''

