/*
 * Opis: O(n \log n),
 *   \texttt{conv\_mod(a, b)} zwraca iloczyn wielomianów modulo, ma większą dokładność niż zwykłe fft.
 */
#include "../fft/main.cpp"
V<int> conv_mod(V<int> a, V<int> b, int M) {
	if(a.empty() or b.empty()) return {};
	V<int> res(ssize(a) + ssize(b) - 1);
	C int CUTOFF = 125;
	if (min(ssize(a), ssize(b)) <= CUTOFF) {
		if (ssize(a) > ssize(b))
			swap(a, b);
		REP (i, ssize(a))
			REP (j, ssize(b))
				res[i + j] = int((res[i + j] + ll(a[i]) * b[j]) % M);
		return res;
	}
	int B = 32 - __builtin_clz(ssize(res)), n = 1 << B;
	int cut = int(sqrt(M));
	V<Complex> L(n), R(n), outl(n), outs(n);
	REP(i, ssize(a)) L[i] = Complex((int) a[i] / cut, (int) a[i] % cut);
	REP(i, ssize(b)) R[i] = Complex((int) b[i] / cut, (int) b[i] % cut);
	fft(L), fft(R);
	REP(i, n) {
		int j = -i & (n - 1);
		outl[j] = (L[i] + conj(L[j])) * R[i] / (2.0 * n);
		outs[j] = (L[i] - conj(L[j])) * R[i] / (2.0 * n) / 1i;
	}
	fft(outl), fft(outs);
	REP(i, ssize(res)) {
		ll av = ll(real(outl[i]) + 0.5), cv = ll(imag(outs[i]) + 0.5);
		ll bv = ll(imag(outl[i]) + 0.5) + ll(real(outs[i]) + 0.5);
		res[i] = int(((av % M * cut + bv) % M * cut + cv) % M);
	}
	return res;
}
