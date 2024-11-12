#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

#define ST first
#define ND second

void test() {
	V<pii> f;
	auto eval = [&](pii p, int x) { return p.ST * x + p.ND; };
	auto get = [&](int x) {
		int ret = -1e9;
		for(pii &p : f) ret = max(ret, eval(p, x));
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
