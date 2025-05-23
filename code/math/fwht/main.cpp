/*
 * Opis: O(n \log n),
 *   $n$ musi być potęgą dwójki,
 *   \texttt{fwht\_or(a)[i] = suma(j będące podmaską i) a[j]},
 *   \texttt{ifwht\_or(fwht\_or(a)) == a},
 *   \texttt{convolution\_or(a, b)[i] = suma(j | k == i) a[j] * b[k]},
 *   \texttt{fwht\_and(a)[i] = suma(j będące nadmaską i) a[j]},
 *   \texttt{ifwht\_and(fwht\_and(a)) == a},
 *   \texttt{convolution\_and(a, b)[i] = suma(j \& k == i) a[j] * b[k]},
 *   \texttt{fwht\_xor(a)[i] = suma(j oraz i mają parzyście wspólnie zapalonych bitów) a[j] - suma(j oraz i mają nieparzyście) a[j]},
 *   \texttt{ifwht\_xor(fwht\_xor(a)) == a},
 *   \texttt{convolution\_xor(a, b)[i] = suma(j \^ k == i) a[j] * b[k]}.
 */
// BEGIN HASH
vi fwht_or(vi a) {
	int n = ssize(a);
	assert((n & (n - 1)) == 0);
	for(int s = 1; 2 * s <= n; s *= 2)
		for(int l = 0; l < n; l += 2 * s)
			for(int i = l; i < l + s; ++i)
				a[i + s] += a[i];
	return a;
}
vi ifwht_or(vi a) {
	int n = ssize(a);
	assert((n & (n - 1)) == 0);
	for(int s = n / 2; s >= 1; s /= 2)
		for(int l = 0; l < n; l += 2 * s)
			for(int i = l; i < l + s; ++i)
				a[i + s] -= a[i];
	return a;
}
vi convolution_or(vi a, vi b) {
	int n = ssize(a);
	assert((n & (n - 1)) == 0 and ssize(b) == n);
	a = fwht_or(a);
	b = fwht_or(b);
	REP(i, n)
		a[i] *= b[i];
	return ifwht_or(a);
} // END HASH
// BEGIN HASH
vi fwht_and(vi a) {
	int n = ssize(a);
	assert((n & (n - 1)) == 0);
	for(int s = 1; 2 * s <= n; s *= 2)
		for(int l = 0; l < n; l += 2 * s)
			for(int i = l; i < l + s; ++i)
				a[i] += a[i + s];
	return a;
}
vi ifwht_and(vi a) {
	int n = ssize(a);
	assert((n & (n - 1)) == 0);
	for(int s = n / 2; s >= 1; s /= 2)
		for(int l = 0; l < n; l += 2 * s)
			for(int i = l; i < l + s; ++i)
				a[i] -= a[i + s];
	return a;
}
vi convolution_and(vi a, vi b) {
	int n = ssize(a);
	assert((n & (n - 1)) == 0 and ssize(b) == n);
	a = fwht_and(a);
	b = fwht_and(b);
	REP(i, n)
		a[i] *= b[i];
	return ifwht_and(a);
} // END HASH
// BEGIN HASH
vi fwht_xor(vi a) {
	int n = ssize(a);
	assert((n & (n - 1)) == 0);
	for(int s = 1; 2 * s <= n; s *= 2)
		for(int l = 0; l < n; l += 2 * s)
			for(int i = l; i < l + s; ++i) {
				int t = a[i + s];
				a[i + s] = a[i] - t;
				a[i] += t;
			}
	return a;
}
vi ifwht_xor(vi a) {
	int n = ssize(a);
	assert((n & (n - 1)) == 0);
	for(int s = n / 2; s >= 1; s /= 2)
		for(int l = 0; l < n; l += 2 * s)
			for(int i = l; i < l + s; ++i) {
				int t = a[i + s];
				a[i + s] = (a[i] - t) / 2;
				a[i] = (a[i] + t) / 2;
			}
	return a;
}
vi convolution_xor(vi a, vi b) {
	int n = ssize(a);
	assert((n & (n - 1)) == 0 and ssize(b) == n);
	a = fwht_xor(a);
	b = fwht_xor(b);
	REP(i, n)
		a[i] *= b[i];
	return ifwht_xor(a);
} // END HASH
