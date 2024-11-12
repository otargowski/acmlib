#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	V<pii> f;
	auto eval = [&](pii p, int x) { return p.fi * x + p.se; };
	auto get = [&](int x) {
		int ret = -1e9;
		for(pii &p : f) chmax(ret, eval(p, x));
		return ret;
	};

	LineContainer lc;

	int n = rd(1, 1000);
	REP(i, n) {
		if(i == 0 || rd(0, 1)) {
			int a = rd(-100, 100);
			int b = rd(-1000, 1000);
			f.eb(a, b);
			lc.add(a, b);
		}
		else {
			int x = rd(-1000, 1000);
			assert(get(x) == lc.query(x));
		}
	}
}
