# Extend-Partial-Automorphism-to-Full-Automorphism
This package contains three functions:
  The first one is called uniform(G), where G is any arbitrary graph. It will output an uniform-degree-graph which have your original input G embedded. 
  The second one is called  G_X_n(G), where G is an uniform-degree-graph. It will output a graph in G(X,n) form (a special type of intersection graph) with your original input G embedded.
  The third one is called bijection(G,f1,f2,S), where G is a G(X,n) graph, f1 and f2 are two poor subgraphs of G, and S is the automorphosm between f1 and f2. Please make sure your input graph G has each of its vertex as the edge set of a uniform-degree graph. The docstring gives an example of this. 
To understant the mathematical terms used in this package, please refer to Milliet's paper "Extending partial ismorphisms of finite graphs" at (http://math.univ-lyon1.fr/~milliet/grapheanglais.pdf)
