/*
 * Opis: O(\log n), indeksowane od 0,
 *   \texttt{update(pos, val)} dodaje \texttt{val} do elementu \texttt{pos},
 *   \texttt{query(pos)} zwraca sumę $[0, pos]$.
 */
struct Fenwick {
	vector<ll> s;
	Fenwick(int n) : s(n) {}
	void update(int pos, ll val) {
		for(; pos < ssize(s); pos |= pos + 1)
			s[pos] += val;
	}
	ll query(int pos) {
		ll ret = 0;
		for(pos++; pos > 0; pos &= pos - 1)
			ret += s[pos - 1];
		return ret;
	}
	ll query(int l, int r) {
		return query(r) - query(l - 1);
	}
};
