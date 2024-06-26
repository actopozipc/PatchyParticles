importiere CPatchyParticle
importiere matplotlib.pyplot als plt
importiere numpy als np
importiere Potentials
importiere tqdm
importiere matplotlib.pyplot als plt
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.art3d import Poly3DCollection 
importiere MonteCarlo
importiere matplotlib.pyplot als plt

importiere matplotlib.cm als cm
def laufe_simulation(teilchen_liste, anz_schritte, temperatur, box_size):
    energie_liste = [MonteCarlo.simulation_schritt(teilchen_liste, temperatur, box_size) für schritte in tqdm.tqdm(reichweite(anz_schritte), disable=Falsch)]
    Rückkehr energie_liste


def write_vtf(teilchen_liste, filename, box_size):
    mit open(filename, 'w') as f:
        # Write header information
        f.write("pbc {} {} {}\n".format(box_size[0], box_size[1], box_size[2]))

        # Define teilchen_liste
        für i, teilchen in enumerate(teilchen_liste):
            f.write("atom {} radius 0.5\n".format(i + 1))
        
        # Optionally define patches
        für i, teilchen in enumerate(teilchen_liste):
            f.write("atom {} radius 0.1\n".format(län(teilchen_liste) + 2 * i + 1))
            f.write("atom {} radius 0.1\n".format(län(teilchen_liste) + 2 * i + 2))

        # Write teilchen positions
        f.write("timestep\n")
        für teilchen in teilchen_liste:
            f.write("atom {} position {} {} {}\n".format(
                teilchen_liste.index(teilchen) + 1, 
                teilchen.position[0], 
                teilchen.position[1], 
                teilchen.position[2]
            ))

        # Write patch positions
        für teilchen in teilchen_liste:
            top_patch_pos = teilchen.top_patch_position()
            bottom_patch_pos = teilchen.bottom_patch_position()
            f.write("atom {} position {} {} {}\n".format(
                len(teilchen_liste) + 2 * teilchen_liste.index(teilchen) + 1, 
                top_patch_pos[0], 
                top_patch_pos[1], 
                top_patch_pos[2]
            ))
            f.write("atom {} position {} {} {}\n".format(
                len(teilchen_liste) + 2 * teilchen_liste.index(teilchen) + 2, 
                bottom_patch_pos[0], 
                bottom_patch_pos[1], 
                bottom_patch_pos[2]
            ))

def plot_teilchen_liste(teilchen_liste):
    fig = plt.figure(1)
    ax = fig.add_subplot(111, projection='3d')

    für teilchen in teilchen_liste:
        drucke(teilchen)
        # Plot the teilchen as a sphere
        u, v = np.mgrid[0:2*np.pi:50j, 0:np.pi:40j] #this is like super correct dont change it anymore pls
        x = np.cos(u) * np.sin(v)
        y = np.sin(u) * np.sin(v)
        z = np.cos(v)
        
        ax.plot_surface(x + teilchen.position[0], y + teilchen.position[1], z + teilchen.position[2], color='b', alpha=0.1)
        u, v = np.mgrid[0:2*np.pi:3j, 0:np.pi:2j] #this is like super correct dont change it anymore pls
        x = np.cos(u) * np.sin(v)
        y = np.sin(u) * np.sin(v)
        z = np.cos(v)
        # Plot the top and bottom patches
        top_patch_pos = teilchen.top_patch_position()
        bottom_patch_pos = teilchen.bottom_patch_position()
        
        ax.plot_surface(x+top_patch_pos[0], y+top_patch_pos[1],z+top_patch_pos[2], color='r' wenn teilchen.top_patch == 'A' sonst 'g', alpha=0.3)
        ax.plot_surface(x+bottom_patch_pos[0], y+bottom_patch_pos[1],z+bottom_patch_pos[2], color='r' wenn teilchen.top_patch == 'A' sonst 'g', alpha=0.3)

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
def plot_trajectory(teilchen_liste):
 
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


def do_they_kiss(teilchen_liste):
    kiss = Falsch
    für t in reichweite(0,län(teilchen_liste)-1):
        teilchen = teilchen_liste[t]
        für t2 in reichweite(1,län(teilchen_liste)):

            teilchen2 = teilchen_liste[t+1]
            wenn np.all(teilchen.top_patch_position() == teilchen2.bottom_patch_position()):
                drucke(teilchen.top_patch_position())
                drucke(teilchen2.bottom_patch_position())
                kiss = Wahr
                drucke("top bottom")
            sonst:
                wenn np.all(teilchen.top_patch_position() == teilchen2.top_patch_position()):
                    drucke(teilchen.top_patch)
                    drucke(teilchen.top_patch_position())
                    drucke(teilchen2.top_patch)
                    drucke(teilchen2.top_patch_position())
                    drucke("top top")
                    kiss = Wahr
                sonst:
                    wenn np.all(teilchen.bottom_patch_position() == teilchen2.bottom_patch_position()):
                        kiss = Wahr
                        drucke("bottom bottom")
        drucke(kiss)
        kiss = Falsch

wenn __name__ == "__main__":
    anz_teilchen = 10
    anz_schritte = 2000
    temperatur = 1.0
    box_size = np.array([10.0, 10.0, 10.0])

    teilchen_liste = MonteCarlo.erstelle_teilchen(anz_teilchen, box=box_size)
    
    energie_liste= laufe_simulation(teilchen_liste, anz_schritte, temperatur, box_size)
    do_they_kiss(teilchen_liste)
    write_vtf(teilchen_liste, "teilchen_liste.vtf", box_size)
    plt.figure(3)
    plt.plot(energie_liste)
    plot_teilchen_liste(teilchen_liste)
    plt.xlabel('Step')
    plt.ylabel('Total Energy')

    plot_trajectory(teilchen_liste)
    plt.show()

