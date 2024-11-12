#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	auto eval = [&](C V<int>& a, int x) {
		int ret = 0, p = 1;
		REP(i, ssize(a)) {
			ret = add(ret, mul(a[i], p));
			p = mul(p, x);
		}
		return ret;
	};
	C int z = rd(0, 1) ? 5 : mod - 1;
	C int n = rd(0, 30);
	C int x = rd(0, 2 * n);
	V<int> a(n);
	REP(i, n)
		a[i] = rd(0, z);
	V<int> y(n);
	REP(i, n)
		y[i] = eval(a, i);
	debug(a, x, y, eval(a, x));
	assert(lagrange_consecutive(y, x) == eval(a, x));
}
