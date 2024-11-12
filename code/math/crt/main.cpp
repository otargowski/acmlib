/*
 * Opis: O(\log n),
 *   \texttt{crt(a, m, b, n)} zwraca takie $x$, że $x \bmod m = a$ oraz $x \bmod n = b$,
 *   $m$ oraz $n$ nie muszą być wzlędnie pierwsze, ale może nie być wtedy rozwiązania
 *   (assert wywali, ale można zmienić na return -1).
 */
#include "../extended-gcd/main.cpp"
ll crt(ll a, ll m, ll b, ll n) {
	if(n > m) swap(a, b), swap(m, n);
	auto [d, x, y] = extended_gcd(m, n);
	assert((a - b) % d == 0);
	ll ret = (b - a) % n * x % n / d * m + a;
	return ret < 0 ? ret + m * n / d : ret;
}
