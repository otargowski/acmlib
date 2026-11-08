#import "template.typ": section-header, subsection-header

#section-header("Równości")
$x = (-b plus.minus sqrt(b^2 - 4a c)) / (2a)$,
Wierzchołek paraboli $= (-b / (2a), -Delta / (4a))$,
$a x + b y = e and c x + d y = f ==> x = (e d - b f) / (a d - b c) and y = (a f - e c) / (a d - b c)$.

#section-header("Pitagoras")
Trójki $(a, b, c)$, takie że $a^2 + b^2 = c^2$:
Jest $a = k dot (m^2 - n^2), wide b = k dot (2m n), wide c = k dot (m^2 + n^2)$,
gdzie $m > n > 0$, $k > 0$, $m bot n$, oraz albo $m$ albo $n$ jest parzyste.

#section-header("Generowanie względnie pierwszych par")
Dwa drzewa, zaczynając od $(2, 1)$ (parzysta-nieparzysta) oraz $(3, 1)$ (nieparzysta-nieparzysta), rozgałęzienia są do $(2m - n, m)$, $(2m + n, m)$ oraz $(m + 2n, n)$.

#section-header("Liczby pierwsze")
$p = 962592769$ to liczba na NTT, czyli $2^21 divides p - 1$. Do hashowania:
970592641 (31-bit), 31443539979727 (45-bit), 3006703054056749 (52-bit).
Jest 78498 pierwszych $<= 1 thin 000 thin 000$.
Generatorów jest $phi(phi(p^a))$, czyli dla $p > 2$ zawsze istnieje.

#section-header("Liczby antypierwsze")
#align(center)[
  #set text(size: 0.88em)
  #table(
    columns: 8,
    stroke: none,
    table.hline(),
    [$lim$], [$10^2$], [$10^3$], [$10^4$], [$10^5$], [$10^6$], [$10^7$], [$10^8$],
    table.hline(),
    [$n$], [60], [840], [7560], [83160], [720720], [8648640], [73513440],
    table.hline(),
    [$d(n)$], [12], [32], [64], [128], [240], [448], [768],
    table.hline()
  )
  #v(-2pt)
  #table(
    columns: 4,
    stroke: none,
    table.hline(),
    [$lim$], [$10^9$], [$10^12$], [$10^15$],
    table.hline(),
    [$n$], [735134400], [963761198400], [866421317361600],
    table.hline(),
    [$d(n)$], [1344], [6720], [26880],
    table.hline()
  )
  #v(-2pt)
  #table(
    columns: 2,
    stroke: none,
    table.hline(),
    [$lim$], [$10^18$],
    table.hline(),
    [$n$], [897612484786617600],
    table.hline(),
    [$d(n)$], [103680],
    table.hline()
  )
]

#section-header("Dzielniki")
$sum_(d divides n) d = cal(O)(n log log n)$

#section-header("Lemat Burnside'a")
Liczba takich samych obiektów z dokładnością do symetrii wynosi
$ 1 / (|G|) sum_(g in G) |X^g|, $
gdzie $G$ to zbiór symetrii (ruchów) oraz $X^g$ to punkty (obiekty) stałe symetrii $g$.

#section-header("Silnia")
#align(center)[
  #set text(size: 0.82em)
  #table(
    columns: 11,
    stroke: none,
    table.hline(),
    [$n$], [1], [2], [3], [4], [5], [6], [7], [8], [9], [10],
    table.hline(),
    [$n!$], [1], [2], [6], [24], [120], [720], [5040], [40320], [362880], [3628800],
    table.hline()
  )
  #v(-2pt)
  #table(
    columns: 8,
    stroke: none,
    table.hline(),
    [$n$], [11], [12], [13], [14], [15], [16], [17],
    table.hline(),
    [$n!$], [4.0e7], [4.8e8], [6.2e9], [8.7e10], [1.3e12], [2.1e13], [3.6e14],
    table.hline()
  )
  #v(-2pt)
  #table(
    columns: 9,
    stroke: none,
    table.hline(),
    [$n$], [20], [25], [30], [40], [50], [100], [150], [171],
    table.hline(),
    [$n!$], [2e18], [2e25], [3e32], [8e47], [3e64], [9e157], [6e262], text(size: 0.8em)[>DBL_MAX],
    table.hline()
  )
]

#section-header("Symbol Newtona")
$binom(n, k) = (n!) / (k! (n-k)!) = (n underline(k)) / (k!)$,
$binom(n, k) = binom(n-1, k-1) + binom(n-1, k) = binom(n-1, k-1) + binom(n-2, k-1) + dots + binom(k-1, k-1)$,
$(x+y)^n = sum_(k=0)^n binom(n, k) x^k y^(n-k)$,
$sum_(i=0)^k binom(n+i, i) = binom(n+k+1, k)$,
$(-1)^i binom(x, i) = binom(i - 1 - x, i)$,
$sum_(i=0)^k binom(n, i) binom(m, k - i) = binom(n + m, k)$,
$binom(n, k) binom(k, i) = binom(n, i) binom(n - i, k - i)$.

#section-header("Wzorki na pewne ciągi")
#subsection-header("Nieporządek")
Liczba takich permutacji, że $p_i != i$ (żadna liczba nie wraca na tą samą pozycję):
$ D(n) = (n-1)(D(n-1)+D(n-2)) = n D(n-1)+(-1)^n = floor((n!) / e) $

#subsection-header("Liczba podziałów")
Liczba sposobów zapisania $n$ jako sumę posortowanych liczb dodatnich:
$p(0) = 1, wide p(n) = sum_(k in ZZ backslash {0}) (-1)^(k+1) p(n - k(3k-1) / 2)$,
szacujemy $p(n) tilde 0.145 / n dot exp(2.56 sqrt(n))$.
#align(center)[
  #set text(size: 0.82em)
  #table(
    columns: 14,
    stroke: none,
    table.hline(),
    [$n$], [0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [20], [50], [100],
    table.hline(),
    [$p(n)$], [1], [1], [2], [3], [5], [7], [11], [15], [22], [30], [627], [$tilde$2e5], [$tilde$2e8],
    table.hline()
  )
]

#subsection-header("Liczby Eulera pierwszego rzędu")
Liczba permutacji $pi in S_n$ gdzie $k$ elementów jest większych niż poprzedni: $k$ razy $pi(j) > pi(j+1)$, $k+1$ razy $pi(j) >= j$, $k$ razy $pi(j) > j$.
Zachodzi:
$E(n,k) = (n-k)E(n-1,k-1) + (k+1)E(n-1,k)$,
$E(n,0) = E(n,n-1) = 1$,
$E(n,k) = sum_(j=0)^k (-1)^j binom(n+1, j) (k+1-j)^n$.

#subsection-header("Stirling pierwszego rzędu")
Liczba permutacji długości $n$ mające $k$ cykli:
$c(n,k) = c(n-1,k-1) + (n-1) c(n-1,k), wide c(0,0) = 1$,
$sum_(k=0)^n c(n,k)x^k = x(x+1) dots (x+n-1)$.
Małe wartości:
$c(8,k) = 8, 0, 5040, 13068, 13132, 6769, 1960, 322, 28, 1$,
$c(n,2) = 0, 0, 1, 3, 11, 50, 274, 1764, 13068, 109584, dots$.

#subsection-header("Stirling drugiego rzędu")
Liczba podziałów zbioru rozmiaru $n$ na $k$ bloków:
$S(n,k) = S(n-1,k-1) + k S(n-1,k)$,
$S(n,1) = S(n,n) = 1$,
$S(n,k) = 1 / (k!) sum_(j=0)^k (-1)^(k-j) binom(k, j) j^n$.

#subsection-header("Liczby Catalana")
$C_n = 1 / (n+1) binom(2n, n) = binom(2n, n) - binom(2n, n+1) = ((2n)!) / ((n+1)! n!)$,
$C_0 = 1, wide C_(n+1) = (2(2n+1)) / (n+2) C_n, wide C_(n+1) = sum C_i C_(n-i)$,
$C_n = 1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, dots$.

Równoważne:
ścieżki na planszy $n times n$,
nawiasowania po $n$ (),
liczba drzew binarnych z $n+1$ liściami (0 lub 2 syny),
skierowanych drzew z $n+1$ wierzchołkami,
triangulacje $(n+2)$-kąta,
permutacji $[n]$ bez 3-wyrazowego rosnącego podciągu?

#subsection-header("Formuła Cayley'a")
Liczba różnych drzew (z dokładnością do numerowania wierzchołków) wynosi $n^(n-2)$.
Liczba sposobów by zespójnić $k$ spójnych o rozmiarach $s_1, s_2, dots, s_k$ wynosi $s_1 dot s_2 dot dots dot s_k dot n^(k-2)$.

#subsection-header("Twierdzenie Kirchhoffa")
Liczba różnych drzew rozpinających spójnego nieskierowanego grafu $G$ bez pętelek (mogą być multikrawędzie) o $n$ wierzchołkach jest równa $det A_(n-1)$, gdzie $A = D - M$, $D$ to macierz diagonalna mająca na przekątnej stopnie wierzchołków w grafie $G$, $M$ to macierz incydencji grafu $G$, a $A_(n-1)$ to macierz $A$ z usuniętymi ostatnim wierszem oraz ostatnią kolumną.

#section-header("Funkcje tworzące")
$1 / ((1-x)^k) = sum_(n >= 0) binom(k - 1 + n, k - 1) x^n$,
$exp(x) = sum_(n >= 0) x^n / (n!)$,
$-log(1 - x) = sum_(n >= 1) x^n / n$.

#section-header("Funkcje multiplikatywne")
$epsilon(n) = [n = 1]$,
$i d_k (n) = n^k$, $i d = i d_1$, $bb(1) = i d_0$,
$sigma_k (n) = sum_(d divides n) d^k$, $sigma = sigma_1$, $tau = sigma_0$,
$mu(p^k) = [k = 0] - [k = 1]$,
$phi(p^k) = p^k - p^(k - 1)$,
$(f ast g)(n) = sum_(d divides n) f(d)g(n / d)$,
$f ast g = g ast f$,
$f ast (g ast h) = (f ast g) ast h$,
$f ast (g + h) = f ast g + f ast h$,
jak dwie z trzech funkcji $f ast g = h$ są multiplikatywne, to trzecia też,
$f ast bb(1) = g <==> g ast mu = f$,
$f ast epsilon = f$,
$mu ast bb(1) = epsilon$, $[n = 1] = sum_(d divides n) mu(d) = sum_(d=1)^n mu(d)[d divides n]$,
$phi ast bb(1) = i d$,
$i d_k ast bb(1) = sigma_k$, $i d ast bb(1) = sigma$, $bb(1) ast bb(1) = tau$,
$s_f (n) = sum_(i=1)^n f(i)$,
$s_f (n) = (s_(f ast g)(n) - sum_(d=2)^n s_f (floor(n / d)) g(d)) / (g(1))$.

#section-header("Fibonacci")
$F_n = (((1+sqrt(5)) / 2)^n - ((1-sqrt(5)) / 2)^n) / sqrt(5)$,
$F_(n-1) F_(n+1) - F_n^2 = (-1)^n$, $F_(n+k) = F_k F_(n+1) + F_(k-1) F_n$, $F_n divides F_(n k)$, $gcd(F_m, F_n) = F_(gcd(m, n))$

#section-header("Woodbury matrix identity")
Dla $A equiv n times n, C equiv k times k, U equiv n times k, V equiv k times n$
jest $(A+U C V)^(-1) = A^(-1) - A^(-1) U (C^(-1) + V A^(-1) U)^(-1) V A^(-1)$,
przy czym często $C = I d$.
Używane gdy $A^(-1)$ jest już policzone i chcemy policzyć odwrotność lekko zmienionego $A$
poprzez $C^(-1)$ i $V A^(-1) U$.
Często występuje w kombinacji z tożsamością $1 / (1-A) = sum_(i=0)^oo A^i$.

#section-header("Zasada włączeń i wyłączeń")
$X$ -- uniwersum, $A_1, dots, A_n$ -- podzbiory $X$ zwane własnościami
$S_j = sum_(1 <= i_1 <= dots <= i_j <= n) |A_(i_1) inter dots inter A_(i_j)|$
W szczególności $S_0 = |X|$. Niech $D(k)$ oznacza liczbę elementów $X$ mających dokładnie $k$ własności.
$D(k) = sum_(j >= k) binom(j, k) (-1)^(j-k) S_j$
W szczególności $D(0) = sum_(j >= 0) (-1)^j S_j$

#section-header("Karp’s minimum mean-weight cycle algorithm")
$G = (V, E)$ -- directed graph with weight function $w : E -> RR$, $n = |V|$
Assume that every vertex is reachable from $s in V$.
$delta_k (s, v)$ shortest $k$-path from $s$ to $v$ (simple dp).
Minimum mean-weight cycle is:
$ min_(v in V) max_(0 <= k <= n-1) (delta_n (s, v) - delta_k (s, v)) / (n - k) $
