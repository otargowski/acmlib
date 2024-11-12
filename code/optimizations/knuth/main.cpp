/*
 * Opis: O(n^2), dla tablicy $cost(i,j)$ wylicza $dp(i,j) = min_{i\leq k<j}\; dp(i,k) + dp(k+1,j) + cost(i,j)$.
 *   Działa tylko wtedy, gdy $opt(i,j-1)\le opt(i,j)\le opt(i+1,j)$,
 *   a jest to zawsze spełnione, gdy $cost(b,c)\le cost(a,d)$ oraz $cost(a,c) + cost(b,d)\le cost(a,d) + cost(b,c)$ dla $a\le b\le c\le d$.
 */
ll knuth_optimization(V<V<ll>> cost) {
	int n = ssize(cost);
	V dp(n, V<ll>(n, numeric_limits<ll>::max()));
	V opt(n, V<int>(n));
	REP(i, n) {
		opt[i][i] = i;
		dp[i][i] = cost[i][i];
	}
	for(int i = n - 2; i >= 0; --i)
		FOR(j, i + 1, n - 1)
			FOR(k, opt[i][j - 1], min(j - 1, opt[i + 1][j]))
				if(dp[i][j] >= dp[i][k] + dp[k + 1][j] + cost[i][j]) {
					opt[i][j] = k;
					dp[i][j] = dp[i][k] + dp[k + 1][j] + cost[i][j];
				}
	return dp[0][n - 1];
}
