importiere CPatchyParticle
importiere matplotlib.pyplot als plt
importiere numpy als np
importiere Potentials
von tqdm importiere tqdm

importiere MonteCarlo
def laufe_simulation(teilchen_liste, anz_schritte, temperatur):
    energie_liste = []
    für schritte in tqdm(reichweite(anz_schritte), disable=Wahr):
        #simulation schritte
        energie = MonteCarlo.simulation_schritt(teilchen_liste, temperatur)
        # Collect data für analysis
        energie_liste.anhängen(energie)
    Rückkehr energie_liste
importiere matplotlib.pyplot als plt
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

# Function to plot a sphere
def plot_sphere(ax, center, radius, color):
    u = np.linspace(0, 2 * np.pi, 20)
    v = np.linspace(0, np.pi, 20)
    x = center[0] + radius * np.outer(np.cos(u), np.sin(v))
    y = center[1] + radius * np.outer(np.sin(u), np.sin(v))
    z = center[2] + radius * np.outer(np.ones(np.size(u)), np.cos(v))
    ax.plot_surface(x, y, z, color=color, alpha=0.5)

# Function to plot a patch
def plot_patch(ax, center, orientation, radius, patch_radius, color):
    patch_center = center + radius * orientation
    ax.scatter(*patch_center, color=color, s=patch_radius*100)

# Visualize the particles
def visualize_particles(particles):
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    für particle in particles:
        plot_sphere(ax, particle.position, radius=0.5, color='lightblue')

        wenn particle.top_patch == 'A':
            top_patch_color = 'red'
        sonst:
            top_patch_color = 'blue'

        wenn particle.bottom_patch == 'A':
            bottom_patch_color = 'red'
        sonst:
            bottom_patch_color = 'blue'

        plot_patch(ax, particle.position, particle.orientation, radius=0.5, patch_radius=0.1, color=top_patch_color)
        plot_patch(ax, particle.position, -particle.orientation, radius=0.5, patch_radius=0.1, color=bottom_patch_color)

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    plt.show()



wenn __name__ == "__main__":
    anz_teilchen = 3
    anz_schritte = 1000
    temperatur = 1.0

    teilchen_liste = MonteCarlo.erstelle_teilchen(anz_teilchen)
    energie_liste = laufe_simulation(teilchen_liste, anz_schritte, temperatur)
    visualize_particles(teilchen_liste)
    plt.plot(energie_liste)
    plt.xlabel('Step')
    plt.ylabel('Total Energy')
    plt.show()

