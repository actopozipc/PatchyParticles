importiere numpy als np

Klasse Particle:
    def __init__(selbst, position, top_patch, bottom_patch, durchmesser=1.0):
        selbst.position = position  # Position in 3D space
        selbst.orientation = np.array([durchmesser, np.random.rand(), 0])  # Orientation vector
        selbst.durchmesser = durchmesser #stored here to calculate the position of A,B
        selbst.top_patch = top_patch  # Type of the top patch (A oder B)
        selbst.bottom_patch = bottom_patch  # Type of the bottom patch (A oder B)

    def calculate_distance(selbst, p2):
        p1 = selbst
        Rückkehr np.linalg.norm(p1.position - p2.position)
    def top_patch_position(self):
        # Assume the top patch is at a fixed distance along the orientation vector
        return self.position + self.orientation
    def bottom_patch_position(self):
        # Assume the bottom patch is at a fixed distance opposite to the orientation vector
        return self.position - self.orientation
    def calculate_distance_between_two_patches(selbst, p2):
        p1 = selbst
        Rückkehr np.linalg.norm(p1.orientation - p2.orientation)


            
