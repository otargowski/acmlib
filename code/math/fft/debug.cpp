#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

V</*ll*/double> get_poly() {
	/*
	int n = rd(1, 1e3);
	vll A(n);
	REP(i, n) A[i] = rd(0, 1e9);
	return A;
	*/

	int n; cin >> n;
	V<double> A(n);
	REP(i, n) cin >> A[i];
	return A;
}

int mod = 1e9 + 7;
vll mul(vll A, vll B) {
	vll res(ssize(A) + ssize(B) - 1);
	REP(i, ssize(A)) REP(j, ssize(B))
		res[i + j] = (res[i + j] + A[i] * B[j]) % mod;
	return res;
}

void test() {
	/*
	vll A = get_poly(), B = get_poly();
	debug(A, B);
	debug(mul(A, B));
	debug(conv_mod(A, B, mod));
	return mul(A, B) != conv_mod(A, B, mod);
	*/

	V<double> A = get_poly(), B = get_poly();
	debug(A, B);
	debug(conv(A, B));
}
