# Magnitude Homology

This code was produced as part of our Master's Thesis about magnitude homology. The main part of the thesis is based on the paper 'Categorifying the Magnitude of a Graph' by R. Hepworth and S. Willerton. It can be 
accessed [here](https://www.intlpress.com/site/pub/files/_fulltext/journals/hha/2017/0019/0002/HHA-2017-0019-0002-a003.pdf).
Magnitude homology is a homology theory of graphs that categorifies the magnitude of graphs, which is a cardinality-like invariant. 
In an attempt to reproduce the tables in the aforementioned paper, the following code was developed.
The code was written in SageMath to make use of the already implemented chain complex. The SageMath documentation can be found under https://doc.sagemath.org/html/en/index.html. In particular, we want to refer to the documentation 
of the chain complex module, which can be found [here](https://doc.sagemath.org/html/en/reference/homology/sage/homology/chain_complex.html#sage.homology.chain_complex.ChainComplex). 
Our code can produce the magnitude chain complex of a graph and in particular can be used to print tables of the ranks of the magnitude homology groups of graphs.


The two main functions the code provides are `lchain_complex(G,l)` and `table_hom_ranks(G, k_max, l_max)`.

## The function `lchain_complex(G,l)`
The function `lchain_complex(G, l)` takes as inputs a graph $G$ and an integer $l \geq 0$. It returns the magnitude chain complex $\mathrm{MC}_{\ast,l}(G)$.

### Examples:
```
sage: G=graphs.CycleGraph(4)
sage: MC=lchain_complex(G,2)
sage: MC
Chain complex with at most 2 nonzero terms over Integer Ring
sage: MC.free_module(2)
Ambient free module of rank 16 over the principal ideal domain Integer Ring
sage: MC.free_module(1)
Ambient free module of rank 4 over the principal ideal domain Integer Ring
sage: MC.differential(2)
[ 0 -1  0 -1  0  0  0  0  0  0  0  0  0  0  0  0]
[ 0  0  0  0  0 -1  0 -1  0  0  0  0  0  0  0  0]
[ 0  0  0  0  0  0  0  0 -1  0 -1  0  0  0  0  0]
[ 0  0  0  0  0  0  0  0  0  0  0  0 -1  0 -1  0]
sage: [MC.betti(i) for i in range(3)]
[0, 0, 12]
sage: MC.homology()
{1: 0, 2: Z^12}
```

## The function `table_hom_ranks(G,k_max,l_max)`
The function `table_hom_ranks(G,k_max,l_max)` takes as inputs a graph $G$, and two integers $l_{\mathrm{max}}, k_{\mathrm{max}} \geq 0$. It returns a table consisting of the ranks of the magnitude homology
$`\mathrm{MH}_{k,l}(G)$ for $k = 0,...,k_{max}$ and $l=0,...,l_{max}`$.

### Examples:
```
sage: P = graphs.PetersenGraph()
sage: t=table_hom_ranks(P,6,6)
sage: t
  0 | 0    1    2     3     4      5      6
+---+----+----+-----+-----+------+------+----+
  0 | 10   0    0     0     0      0      0
  1 | 0    30   0     0     0      0      0
  2 | 0    0    30    0     0      0      0
  3 | 0    0    120   30    0      0      0
  4 | 0    0    0     480   30     0      0
  5 | 0    0    0     0     840    30     0
  6 | 0    0    0     0     1440   1200   30
```
