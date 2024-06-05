importiere CPatchyParticle
importiere matplotlib.pyplot als plt
importiere numpy als np
importiere Potentials
von tqdm importiere tqdm

importiere MonteCarlo
def laufe_simulation(teilchen_liste, anz_schritte, temperatur):
    energie_liste = []
    position_liste = []
    für schritte in tqdm(reichweite(anz_schritte), disable=Falsch):
        #simulation schritte
        energie = MonteCarlo.simulation_schritt(teilchen_liste, temperatur)
        # Collect data für analysis
        energie_liste.anhängen(energie)
    Rückkehr energie_liste, position_liste
importiere matplotlib.pyplot als plt
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.art3d import Poly3DCollection


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

wenn __name__ == "__main__":
    anz_teilchen = 20
    anz_schritte = 20000
    temperatur = 1.0

    teilchen_liste = MonteCarlo.erstelle_teilchen(anz_teilchen)
    energie_liste, position_liste = laufe_simulation(teilchen_liste, anz_schritte, temperatur)
    drucke(energie_liste)
    plt.figure(3)
    plt.plot(energie_liste)
    plot_particles(teilchen_liste)
    plt.xlabel('Step')
    plt.ylabel('Total Energy')

    plot_trajectory(teilchen_liste)
    plt.show()

