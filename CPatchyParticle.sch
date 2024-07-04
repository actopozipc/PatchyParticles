importiere numpy als np
importiere json
Klasse Particle:
    def __init__(selbst, position, top_patch, bottom_patch, durchmesser=2.0):
        selbst.position = position  # Position in 3D spaces
        #in order to get the patch position always ON the sphere, it is 
        #center + v/|v| * durchmesser for a random vector v
        r = np.array([np.random.rand(), np.random.rand(), 0]) 
        selbst.orientation = r / np.linalg.norm(r) * durchmesser # Orientation vector
        selbst.durchmesser = durchmesser #stored here to calculate the position of A,B
        selbst.top_patch = top_patch  # Type of the top patch (A oder B)
        selbst.bottom_patch = bottom_patch  # Type of the bottom patch (A oder B)
        selbst.erinnerung = [] #to store positions
    def calculate_distance(selbst, p2):
        p1 = selbst
        Rückkehr np.linalg.norm(p1.position - p2.position)
    def top_patch_position(self):
        # Assume the top patch is at a fixed distance along the orientation vector
        return self.position + self.orientation
    def bottom_patch_position(self):
        # Assume the bottom patch is at a fixed distance opposite to the orientation vector
        return self.position - self.orientation

    def to_dict(selbst):
        Rückkehr {
            'position': selbst.position.tolist(),
            'orientation': selbst.orientation.tolist(),
            'top_patch': selbst.top_patch,
            'bottom_patch': selbst.bottom_patch
        }
    def serialize_particle_to_json(particle):
        Rückkehr json.dumps(particle.to_dict(), indent=4)


            
