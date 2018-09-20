import itertools
def uniform(G):
    """Produce a supergraph of G with uniform degree.
    
    Parameters
    ----------
    G : graph
        An arbitrary graph.
    
    Returns
    -------
    H:graph
        A uniform-degree-graph.
    --------

    Examples
    --------
    Input an arbitray graph
    
    >>> G=Graph([(0,2),(2,1),(1,3),(3,4),(4,2)])
    >>> uniform(G)
    Graph[(0, 2), (0, 5), (0, 6), (0, 10), (0, 15), (0, 20), (0, 25), (1, 2), (1, 3), (1, 7), (1, 11), (1, 16), (1, 21), (1, 26), (2, 4), (2, 12), \
    (2, 17), (2, 22), (2, 27), (3, 4), (3, 8), (3, 13), (3, 18), (3, 23), (3, 28), (4, 9), (4, 14), (4, 19), (4, 24), (4, 29), (5, 6), (5, 7), (5, 8),\
    (5, 27), (5, 28), (5, 29), (6, 7), (6, 8), (6, 9), (6, 28), (6, 29), (7, 8), (7, 9), (7, 10), (7, 29), (8, 9), (8, 10), (8, 11), (9, 10), (9, 11), \
    (9, 12), (10, 11), (10, 12), (10, 13), (11, 12), (11, 13), (11, 14), (12, 13), (12, 14), (12, 15), (13, 14), (13, 15), (13, 16), (14, 15), (14, 16), \
    (14, 17), (15, 16), (15, 17), (15, 18), (16, 17), (16, 18), (16, 19), (17, 18), (17, 19), (17, 20), (18, 19), (18, 20), (18, 21), (19, 20), (19, 21), \
    (19, 22), (20, 21), (20, 22), (20, 23), (21, 22), (21, 23), (21, 24), (22, 23), (22, 24), (22, 25), (23, 24), (23, 25), (23, 26), (24, 25), (24, 26), \
    (24, 27), (25, 26), (25, 27), (25, 28), (26, 27), (26, 28), (26, 29), (27, 28), (27, 29), (28, 29)]
    """
    
    def newV(H):
        """Add a new vertex to the graph H."""
        size=len(H.vertices())
        while size in H.vertices():
            size +=1
        return size

    def fill_up(maxDeg, H):
        """Add leaves to H until each vertex has degree maxDeg.
        
        Parameters
        ----------
        maxDeg : int
            an int >= 1
        H : graph
            a graph

        Returns
        -------
        H
            A graph which all vertices have degree maxDeg

        Examples
        --------
        Input a graph H, and the maxDeg desired. The maxDeg will the the degree of all vertices of the output uniform-degree-graph
        >>> maxDeg=7 H=Graph([(0,2),(2,1),(1,3),(3,4),(4,2)])
        >>> fill_up(7,Graph([(0,2),(2,1),(1,3),(3,4),(4,2)]))
        Graph[(0, 2), (0, 5), (0, 6), (0, 10), (0, 15), (0, 20), (0, 25), (1, 2), (1, 3), (1, 7), (1, 11), (1, 16), (1, 21), (1, 26), (2, 4),\
        (2, 12), (2, 17), (2, 22), (2, 27), (3, 4), (3, 8), (3, 13), (3, 18), (3, 23), (3, 28), (4, 9), (4, 14), (4, 19), (4, 24), (4, 29)]
        """
        for i in range(maxDeg):
            ListY=[y for y in H.vertices() if H.degree(y) == i]
            for y in ListY:
                H.add_edge(newV(H),y)
        return H

    def check(maxDeg, H):
        """Check if we have added enough vertices of degree one, if not, we add more new vertices"""
        ListZ=[z for z in H.vertices() if H.degree(z) == 1]
        while len(ListZ) < maxDeg:
            tempVert = newV(H)
            for i in range(maxDeg):
                H.add_edge(newV(H),tempVert)
            ListZ=[z for z in H.vertices() if H.degree(z) == 1]
        return H

    def connect_leaf(H,ListZ):
        """Connect all vertices of degree one to a circle"""
        for z in ListZ:
            temp = ListZ.index(z)
            if (temp < len(ListZ)-1):
                H.add_edge(z,ListZ[temp+1])
            else:
                H.add_edge(z,ListZ[0])
        return H
    
    def connect_leaf_n(H,n,ListZ):
        """Connect each vertex on the circle to its previous and next (maxDeg-1)/2 ones"""
        for z in ListZ:
            for i in range(2,n+1):
                temp = ListZ.index(z)
                node1 = (temp+i)%len(ListZ)
                node2 = temp-i
                if node2<0:
                    node2 = len(ListZ)+node2
                H.add_edge(z,ListZ[node1])
                H.add_edge(z,ListZ[node2])
        return H
    
    #Complete the graph
    maxDeg = max(G.degree_sequence())
    n = (maxDeg-1)/2
    G = fill_up(maxDeg,G)
    G = check(maxDeg,G)
    ListZ = [z for z in G.vertices() if G.degree(z) == 1]
    G = connect_leaf(G,ListZ)
    G = connect_leaf_n(G,n,ListZ)
    
    return G

def G_X_n(G):
    """Produce a graph G(X,n) from a graph G.

    Parameters
    ----------
    G : graph
        a uniform degree graph
    
    Returns
    -------
    H
        A G(X,n) graph

    Examples
    --------
    Input a uniform-degree-graph, and it will out put a G(X,n) graph with the input graph embedded in

    >>> G=Graph([(0,1),(1,2),(2,3),(3,0)])
    >>> G_X_n(G)
    Graph[(((1, 2), (1, 4)), ((1, 2), (2, 3))), (((1, 2), (1, 4)), ((1, 2), (3, 4))), (((1, 2), (1, 4)), ((1, 4), (2, 3))), \
    (((1, 2), (1, 4)), ((1, 4), (3, 4))), (((1, 2), (2, 3)), ((1, 2), (3, 4))), (((1, 2), (2, 3)), ((1, 4), (2, 3))), \
    (((1, 2), (2, 3)), ((2, 3), (3, 4))), (((1, 2), (3, 4)), ((1, 4), (3, 4))), (((1, 2), (3, 4)), ((2, 3), (3, 4))), \
    (((1, 4), (2, 3)), ((1, 4), (3, 4))), (((1, 4), (2, 3)), ((2, 3), (3, 4))), (((1, 4), (3, 4)), ((2, 3), (3, 4)))]
    """

    listE = G.degree()
    for i in (0,len(listE)-2):
        v1 = listE[i]
        v2 = listE[i+1]
        if v2 > v1:
            n = v2
        else:
            n = v1
        listL=[]
        X = G.edges(labels=False)
        H=Graph()
        #Make a list of all possible combinations of any two edge sets of G, and use these as the vertex set of H. If two vertices intersect, make an edge between them
        for subset in itertools.combinations(X, n):
            H.add_vertex(subset)
            listL.append(subset)
            H.set_vertex(subset,listL[-1])
            for i in range(len(listL)-1):
                if set(listL[i]) & set(subset) != set([]):
                    H.add_edge(subset,listL[i])
   
    return H
def bijection(G,f1,f2,S):
    """Extend the partial automorphism between two poor subgraphs of G to the full automorphism of G.
    
    Parameters
    ----------
    G : graph
        A G(X,n) graph
    f1 : list
        A poor subgraph of G (Poor subgraph means if we take any two vertices x,y in graph G, they have one element in X \
        in common at most, and every element in X belongs to two vertices of the subgraph.)
    f2 : list
        Another poor subgraph of G, such that there exists an isomorphism between f1 and f2
    S : list
        The automorphism between f1 and f2

    Returns
    -------
    final_list
        The full automorphsim of graph G in the form of list.
    
    Examples
    --------
    Input any two poor subgraph of G and the isomorphism between them, this function will extend that partial \
    automorphism to a full automorphism of G
    
    >>> G=Graph([(((1, 2), (1, 4)), ((1, 2), (2, 3))), (((1, 2), (1, 4)), ((1, 2), (3, 4))), (((1, 2), (1, 4)), ((1, 4), (2, 3))), \
    (((1, 2), (1, 4)), ((1, 4), (3, 4))), (((1, 2), (2, 3)), ((1, 2), (3, 4))), (((1, 2), (2, 3)), ((1, 4), (2, 3))),\
    (((1, 2), (2, 3)), ((2, 3), (3, 4))), (((1, 2), (3, 4)), ((1, 4), (3, 4))), (((1, 2), (3, 4)), ((2, 3), (3, 4))), \
    (((1, 4), (2, 3)), ((1, 4), (3, 4))), (((1, 4), (2, 3)), ((2, 3), (3, 4))), (((1, 4), (3, 4)), ((2, 3), (3, 4)))])
        f1=[[1,2],[1,3]]
        f2=[[2,4],[3,4]]
        S=[({1,2},{2,4}),({1,3},{3,4})]
    >>> automorphism(Graph([(((1, 2), (1, 4)), ((1, 2), (2, 3))), (((1, 2), (1, 4)), ((1, 2), (3, 4))), \
    (((1, 2), (1, 4)), ((1, 4), (2, 3))), (((1, 2), (1, 4)), ((1, 4), (3, 4))), (((1, 2), (2, 3)), ((1, 2), (3, 4))), \
    (((1, 2), (2, 3)), ((1, 4), (2, 3))), (((1, 2), (2, 3)), ((2, 3), (3, 4))), (((1, 2), (3, 4)), ((1, 4), (3, 4))),\
    (((1, 2), (3, 4)), ((2, 3), (3, 4))), (((1, 4), (2, 3)), ((1, 4), (3, 4))), (((1, 4), (2, 3)), ((2, 3), (3, 4))), \
    (((1, 4), (3, 4)), ((2, 3), (3, 4)))]),[[1,2],[1,3]],[[2,4],[3,4]],[({1,2},{2,4}),({1,3},{3,4})])
    [(2, 2), (2, 2), (3, 3), (3, 3), (4, 1), (1, 4), (5, 5), (5, 5), (6, 6), (6, 6)]
    """
    X = G.edges(labels=False)
    
    final_list = []
    #Pick two groups in S and compare, send the element that appears twice in the first group to the element that appears twice in the second group; send the element that appears once in the first group to the element that appears once in the second group
    for pair in S:
        dom1 = pair[0]
        range1 = pair[1]
        S1 = list(S)
        S1.remove(pair)
        for pair2 in S1:
            dom2 = pair2[0]
            range2 = pair2[1]
            n_dom = [value for value in dom1 if value in dom2]
            n_range = [value for value in range1 if value in range2]
            other_dom = [value for value in dom1 if value not in dom2]
            other_range = [value for value in range1 if value not in range2]
            #If the automorphism is already added, it won't be added again
            for i,pair3 in enumerate(final_list):
                (x, y) = pair3
                if x in n_dom + n_range or y in n_dom + n_range:
                    del final_list[i]
            for j,elem in enumerate(n_dom):
                final_list.append((elem, n_range[j]))
                final_list.append((n_range[j], elem))
            #Send the element in S but not in the first group to the element in S but not in the second group
            for other in other_dom:
                for other2 in other_range:
                    flat_final = [value for pair in final_list for value in pair]
                    if other not in flat_final and other2 not in flat_final:
                        final_list.append((other, other2))
                        final_list.append((other2, other))
            #Send elements in X but not in S to each other
            Xdom = [value for value in X if value not in dom1 and value not in dom2]
            Xrange = [value for value in X if value not in range1 and value not in range2]
            for i,elem in enumerate(Xdom):
                final_list = [pair for pair in final_list if elem not in pair and Xrange[i] not in pair]
                
    return list(set(final_list))
