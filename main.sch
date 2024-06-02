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

wenn __name__ == "__main__":
    anz_teilchen = 10
    anz_schritte = 1000
    temperatur = 1.0

    teilchen_liste = MonteCarlo.erstelle_teilchen(anz_teilchen)
    energie_liste = laufe_simulation(teilchen_liste, anz_schritte, temperatur)
    plt.plot(energie_liste)
    plt.xlabel('Step')
    plt.ylabel('Total Energy')
    plt.show()

