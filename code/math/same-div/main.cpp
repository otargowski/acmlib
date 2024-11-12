/*
 * Opis: O(\sqrt{n}), wyznacza przedziały o takiej samej wartości $\lfloor n / x\rfloor$ lub $\lceil n / x\rceil$.
 *  \texttt{same\_floor(8) = \{(1, 1), (2, 2), (3, 4), (5, 8)\}},
 *  \texttt{same\_ceil(8) = \{(8, 8), (4, 7), (3, 3), (2, 2), (1, 1)\}},
 *  na konteście raczej checemy przepisać tylko pętlę i od razu wykonywać obliczenia na parze (l, r) zamiast grupować wszyskie przedziały w vectorze.
 *  Dla $n$ będącego intem można zmienić wszystkie ll na int, w celu zbicia stałej.
 */
// BEGIN HASH
vector<pair<ll, ll>> same_floor(ll n) {
	vector<pair<ll, ll>> v;
	for (ll l = 1, r; l <= n; l = r + 1) {
		r = n / (n / l);
		v.emplace_back(l, r);
	}
	return v;
} // END HASH
// BEGIN HASH
vector<pair<ll, ll>> same_ceil(ll n) {
	vector<pair<ll, ll>> v;
	for (ll r = n, l; r >= 1; r = l - 1) {
		l = (n + r - 1) / r;
		l = (n + l - 1) / l;
		v.emplace_back(l, r);
	}
	return v;
} // END HASH
