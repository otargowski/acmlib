/*
 * Opis: Generatorka wielokątów niekoniecznie-wypukłych.
 * Zwraca wielokąt o $n$ punktach w zakresie $[-\texttt{r}, \texttt{r}]$,
 * który nie zawiera jakiejkolwiek trójki współliniowych punktów.
 * Ciągnie do $\sim 80$. Dla $n < 3$ zwraca zdegenerowane.
 */
#include "../point/main.cpp"
#include "../intersect-lines/main.cpp"
#include "../../headers/gen.cpp"
V<P> gen_polygon(int n, int r) {
	V<P> t;
	while (ssize(t) < n) {
		P p(rd(-r, r), rd(-r, r));
		if ([&]() {
			REP (i, ssize(t))
				REP (j, i)
					if (dir(t[i], t[j], p) == 0)
						return false;
			return find(all(t), p) == t.end();
		}())
			t.eb(p);
	}
	bool go = true;
	while (go) {
		go = false;
		REP (i, n)
			REP (j, i - 1)
				if ((i + 1) % n != j && ssize(intersect_segments(t[i], t[(i + 1) % n], t[j], t[j + 1]))) {
					swap(t[(i + rd(0, 1)) % n], t[(j + rd(0, 1)) % n]);
					go = true;
				}
	}
	return t;
}
