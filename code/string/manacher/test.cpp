#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	int n = rd(1, 10);
	V<int> in(n);
	for(int &x : in)
		x = rd(0, 1);

	array<V<int>, 2> radius = {V<int>(n - 1), V<int>(n)};
	REP(l, n)
		FOR(r, l, n - 1) {
			V<int> s;
			FOR(i, l, r)
				s.eb(in[i]);
			V<int> cp = s;
			reverse(all(cp));
			if(cp != s)
				continue;

			int mid = (l + r) / 2, len = r - l + 1;
			radius[len % 2][mid] = max(radius[len % 2][mid], len / 2);
		}
	assert(radius == manacher(in));
}
