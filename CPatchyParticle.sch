importiere numpy als np

Klasse Particle:
    def __init__(selbst, position, orientation, top_patch, bottom_patch, durchmesser=1.0):
        selbst.position = position  # Position in 3D space
        selbst.orientation = orientation  # Orientation vector
        selbst.durchmesser = durchmesser #stored here to calculate the position of A,B
        selbst.top_patch = top_patch  # Type of the top patch (A oder B)
        selbst.bottom_patch = bottom_patch  # Type of the bottom patch (A oder B)

    def calculate_distance(selbst, p2):
        p1 = selbst
        Rückkehr np.linalg.norm(p1.position - p2.position)
    def calculate_distance_between_two_patches(selbst, p2):
        p1 = selbst
        Rückkehr np.linalg.norm(p1.orientation - p2.orientation)


            
