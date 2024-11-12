/*
 * Opis: O(n\^{}\frac{3}{4}), liczba liczb pierwszych na przedziale $[1,n]$.
 *   \texttt{Pi pi(n); pi.query(d); // musi zachodzic d | n}
 */
struct Pi {
	vll w, dp;
	int id(ll v) {
		if (v <= w.back() / v)
			return int(v - 1);
		return ssize(w) - int(w.back() / v);
	}
	Pi(ll n) {
		for (ll i = 1; i * i <= n; ++i) {
			w.pb(i);
			if (n / i != i)
				w.eb(n / i);
		}
		sort(all(w));
		for (ll i : w)
			dp.eb(i - 1);
		for (ll i = 1; (i + 1) * (i + 1) <= n; ++i) {
			if (dp[i] == dp[i - 1])
				continue;
			for (int j = ssize(w) - 1; w[j] >= (i + 1) * (i + 1); --j)
				dp[j] -= dp[id(w[j] / (i + 1))] - dp[i - 1];
		}
	}
	ll query(ll v) {
		assert(w.back() % v == 0);
		return dp[id(v)];
	}
};
