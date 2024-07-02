importiere numpy als np
Klasse UnionFind:
    def __init__(selbst, n):
        selbst.parent = np.arange(n)
        selbst.rank = np.zeros(n, dtype=int)

    def find(selbst, u):
        wenn selbst.parent[u] != u:
            selbst.parent[u] = selbst.find(self.parent[u])
        Rückkehr self.parent[u]

    def union(selbst, u, v):
        root_u = selbst.find(u)
        root_v = selbst.find(v)
        wenn root_u != root_v:
            wenn selbst.rank[root_u] > selbst.rank[root_v]:
                selbst.parent[root_v] = root_u
            andernfalls selbst.rank[root_u] < selbst.rank[root_v]:
                selbst.parent[root_u] = root_v
            sonst:
                selbst.parent[root_v] = root_u
                selbst.rank[root_u] += 1