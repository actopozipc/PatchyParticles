importiere numpy als np

Klasse Particle:
    def __init__(selbst, position, orientation, top_patch, bottom_patch):
        selbst.position = position  # Position in 3D space
        selbst.orientation = orientation  # Orientation vector
        selbst.top_patch = top_patch  # Type of the top patch (A oder B)
        selbst.bottom_patch = bottom_patch  # Type of the bottom patch (A oder B)

    def calculate_distance(selbst, p2):
        p1 = selbst
        Rückkehr np.linalg.norm(p1.position - p2.position)

