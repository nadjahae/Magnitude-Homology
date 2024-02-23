#!/usr/bin/env sage

# input: list
# output: list without duplicates, same order
def removeduplicates (x):
    removed = []
    for i in x:
        if i in removed:
            pass
        else:
            removed.append(i)
    return removed

# input: k,l integers
# output: list with all unordered partitions of n with precisely k summands
def partitions (k,l):
    par = []
    if (k > l or k<0 or l<0)  :
        return par
    elif (k == 0):
        if (l == 0):
            par.append([0])
            return par
        else:
            return par
    elif (l == 0):
        return par
    elif (k == 1):
        par.append([l])
        return par
    else:
        for i in range(1,l):
            prev = partitions(k-1, l-i)
            for j in prev:
                j.insert(0, i)
                par.append(j)
        par = removeduplicates(par)
        return par

#returns all the vertices in the graph G that have exact distance dist from center
def graph_ball (G, center, dist):
    ball=[]
    for vertex in range(G.order()):
        if dist == G.distance(center, vertex):
            ball.append(vertex)
    return ball

#returns all generators of MC_k,l(G) that start with the vertex x_0 and correspond to the given partition
def build_generator (G, x0, partition):
    generators = []
    length = len(partition)
    if length == 1:
        d = partition[0]
        if d == 0:
            generators.append(x0)
        else:
            x1vars = graph_ball(G, x0, d)
            for x1 in x1vars:
                generators.append([x0, x1])
    else:
        x1vars = graph_ball(G, x0, partition[0])
        parminuslead = partition[1:length]
        for x1 in x1vars:
            gen_i = build_generator(G, x1, parminuslead)
            for following in gen_i:
                following.insert(0, x0)
                generators.append(following)
    return generators

#returns all generators of MC_k,l(G)
def genMC (G,k,l):
    generators = []
    n = G.order()
    pars = partitions(k, l)
    
    for par in pars:
        for i in range(n):
            i_generators = build_generator(G,i,par)
            for j in i_generators:
                generators.append(j)
    return generators

#returns the rank of MC_k,l(G)
def rankMC (G, k, l):
    return len(genMC(G, k, l))

#returns the matrix corresponding to the differential map MC_k,l(G) -> MC_k-1,l(G)
def differential (G, k, l):
    rows = rankMC(G, k-1, l)
    cols = rankMC(G, k, l)

    diff = matrix(ZZ, rows, cols, sparse=True)

    gen_domain = genMC(G, k, l)
    gen_codomain = genMC(G, k-1, l)

    for gen in gen_domain:
        col = gen_domain.index(gen)
        for i in range(1,k):
            copygen = gen.copy()
            copygen.pop(i)
            if copygen in gen_codomain:
                row = gen_codomain.index(copygen)
                diff[row, col] = (-1)**i
    return diff

#returns the chain complex MC_\ast,l(G)
def lchain_complex (G, l):
    data = dict()
    for k in range(l+2):
        data[k] = differential(G, k, l)
    return ChainComplex(data, degree=-1, base_ring=ZZ)

#returns a table of the ranks of the magnitude homology groups MH_k,l(G) for k=0,....,k_max and l=0,...,l_max
def table_hom_ranks (G, k_max, l_max):
    rows=[]
    row0 = [i for i in range(k_max+2)]
    row0.insert(0,0)
    rows.append(row0)
    for i in range(1,l_max+2):
        current_row = []
        Magnitude_chain_complex = lchain_complex(G, i-1)
        for j in range(k_max+1):
            current_row.append(Magnitude_chain_complex.betti(j))
        current_row.insert(0,i-1)
        rows.append(current_row)
    return table(rows = rows, header_row = True, header_column=True)

t = table_hom_ranks(graphs.CycleGraph(3),7,7)

print("The ranks of the magnitude homology groups of the hree-ycle graph are: \n")

print(t)

print(latex(t))