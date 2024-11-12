/*
 * Opis: O(\log(\min(a, b))), dla danego $(a, b)$ znajduje
 *   takie $(gcd(a, b), x, y)$, że $ax + by = gcd(a, b)$.
 *  \texttt{auto [gcd, x, y] = extended\_gcd(a, b);}
 */
tuple<ll, ll, ll> extended_gcd(ll a, ll b) {
	if(a == 0)
		return {b, 0, 1};
	auto [gcd, x, y] = extended_gcd(b % a, a);
	return {gcd, y - x * (b / a), x};
}
