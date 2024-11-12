/*
 * Opis: O(n),
 *   \texttt{sieve(n)} przetwarza liczby do $n$ włącznie,
 *   \texttt{comp[i]} oznacza czy $i$ jest złożone,
 *   \texttt{primes} zawiera wszystkie liczby pierwsze \texttt{<= n},
 *   \texttt{prime\_div[i]} zawiera najmniejszy dzielnik pierwszy $i$,
 *   na CF dla $n = 1e8$ działa w 1.2s.
 */
V<bool> comp;
vi primes, prime_div;
void sieve(int n) {
	primes.clear();
	comp.resize(n + 1);
	prime_div.resize(n + 1);
	FOR(i, 2, n) {
		if (!comp[i]) primes.eb(i), prime_div[i] = i;
		for (int p : primes) {
			int x = i * p;
			if (x > n) break;
			comp[x] = true;
			prime_div[x] = p;
			if (i % p == 0) break;
		}
	}
}
