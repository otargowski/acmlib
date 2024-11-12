/*
 * Opis: O(\log a), liczy $\sum_{i=0}^{n-1} \left\lfloor \frac{a\cdot i + b}{c} \right\rfloor$.
 * Działa dla $0 \leq a, b < c$ oraz $1\leq c, n \leq 10^9$.
 * Dla innych $n, a, b, c$ trzeba uważać lub użyć \texttt{\_\_int128}.
 */
ll floor_sum(ll n, ll a, ll b, ll c) {
	ll ans = 0;
	if (a >= c) {
		ans += (n - 1) * n * (a / c) / 2;
		a %= c;
	}
	if (b >= c) {
		ans += n * (b / c);
		b %= c;
	}
	ll d = (a * (n - 1) + b) / c;
	if (d == 0) return ans;
	ans += d * (n - 1) - floor_sum(d, c, c - b - 1, a);
	return ans;
}
