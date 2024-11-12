/*
 * Opis: O(n\^{}\frac{1}{4}),
 * \texttt{factor(n)} zwraca V dzielników pierwszych $n$, niekoniecznie posortowany,
 * \texttt{get\_pairs(n)} zwraca posortowany V par (dzielnik pierwszych, krotność) dla liczby $n$,
 * \texttt{all\_factors(n)} zwraca V wszystkich dzielników $n$, niekoniecznie posortowany,
 * \texttt{factor(12) = \{2, 2, 3\}, factor(545423) = \{53, 41, 251\};},
 * \texttt{get\_pairs(12) = \{(2, 2), (3, 1)\}},
 * \texttt{all\_factors(12) = \{1, 3, 2, 6, 4, 12\}}.
 */
#include "../miller-rabin/main.cpp"
// BEGIN HASH
ll rho_pollard(ll n) {
	if(n % 2 == 0) return 2;
	for(ll i = 1;; i++) {
		auto f = [&](ll x) { return (llmul(x, x, n) + i) % n; };
		ll x = 2, y = f(x), p;
		while((p = __gcd(n - x + y, n)) == 1)
			x = f(x), y = f(f(y));
		if(p != n) return p;
	}
}
V<ll> factor(ll n) {
	if(n == 1) return {};
	if(miller_rabin(n)) return {n};
	ll x = rho_pollard(n);
	auto l = factor(x), r = factor(n / x);
	l.insert(l.end(), r.begin(), r.end());
	return l;
} // END HASH
V<pair<ll, int>> get_pairs(ll n) {
	auto v = factor(n);
	sort(v.begin(), v.end());
	V<pair<ll, int>> ret;
	REP(i, ssize(v)) {
		int x = i + 1;
		while (x < ssize(v) and v[x] == v[i])
			++x;
		ret.eb(v[i], x - i);
		i = x - 1;
	}
	return ret;
}
V<ll> all_factors(ll n) {
	auto v = get_pairs(n);
	V<ll> ret;
	function<void(ll,int)> gen = [&](ll val, int p) {
		if (p == ssize(v)) {
			ret.eb(val);
			return;
		}
		auto [x, cnt] = v[p];
		gen(val, p + 1);
		REP(i, cnt) {
			val *= x;
			gen(val, p + 1);
		}
	};
	gen(1, 0);
	return ret;
}
