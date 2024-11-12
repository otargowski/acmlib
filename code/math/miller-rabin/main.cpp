/*
 * Opis: O(\log^2 n) test pierwszości Millera-Rabina,
 *   działa dla long longów.
 */
ll llmul(ll a, ll b, ll m) {
	return ll(__int128_t(a) * b % m);
}
ll llpowi(ll a, ll n, ll m) {
	for (ll ret = 1;; n /= 2) {
		if (n == 0)
			return ret;
		if (n % 2)
			ret = llmul(ret, a, m);
		a = llmul(a, a, m);
	}
}
bool miller_rabin(ll n) {
	if(n < 2) return false;
	int r = 0;
	ll d = n - 1;
	while(d % 2 == 0)
		d /= 2, r++;
	for(int a : {2, 325, 9375, 28178, 450775, 9780504, 1795265022}) {
		if (a % n == 0) continue;
		ll x = llpowi(a, d, n);
		if(x == 1 || x == n - 1)
			continue;
		bool composite = true;
		REP(i, r - 1) {
			x = llmul(x, x, n);
			if(x == n - 1) {
				composite = false;
				break;
			}
		}
		if(composite) return false;
	}
	return true;
}
