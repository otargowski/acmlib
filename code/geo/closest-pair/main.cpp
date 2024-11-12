/*
 * Opis: O(n \log n), zakłada ssize(in) > 1.
 */
#include "../point/main.cpp"

pair<P, P> closest_pair(V<P> in) {
	set<P> s;
	sort(all(in), [](P a, P b) { return a.y() < b.y(); });
	pair<D, pair<P, P>> ret(1e18, {P(), P()});
	int j = 0;
	for (P p : in) {
		P d(1 + sqrt(ret.fi), 0);
		while (in[j].y() <= p.y() - d.x()) s.erase(in[j++]);
		auto lo = s.lower_bound(p - d), hi = s.upper_bound(p + d);
		for (; lo != hi; ++lo)
			chmin(ret, pair(pow(dist(*lo, p), 2), pair(*lo, p)));
		s.insert(p);
	}
	return ret.se;
}
