#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	int n = rd(1, 30);
	int r = rd(1, 26);
	V<int> s(n);
	for (auto& x : s)
		x = rd(0, r - 1);

	V<int> sa = suffix_array(s, r);
	V<int> lcp = get_lcp(s, sa);

	V<pair<V<int>,int>> v(n + 1);
	REP(i,n+1)
		v[i] = {V(s.begin() + i, s.end()), i};
	sort(all(v));

	REP(i,n+1)
		assert(sa[i] == v[i].se);

	auto common = [&](C V<int>& a, C V<int>& b) {
		int d = min(ssize(a), ssize(b));
		REP(i,d)
			if (a[i] != b[i])
				return i;
		return d;
	};
	REP(i,n)
		assert(lcp[i] == common(v[i].fi, v[i + 1].fi));
}
