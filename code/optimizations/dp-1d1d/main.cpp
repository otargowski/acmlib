/*
 * Opis: O(n\log n),
 *   $n>0$ długość paska,
 *   \texttt{cost(i, j)} koszt odcinka $[i, j]$
 *   Dla $a \leq b \leq c \leq d$ \texttt{cost} ma spełniać $cost(a, c) + cost(b, d) \leq cost(a, d) + cost(b, c)$.
 *   Dzieli pasek $[0, n)$ na odcinki $[0, cuts[0]], ..., (cuts[i-1], cuts[i]]$,
 *   gdzie \texttt{cuts.back() == n - 1}, aby sumaryczny koszt wszystkich odcinków był minimalny.
 *   \texttt{cuts} to prawe końce tych odcinków.
 *   Zwraca \texttt{(opt\_cost, cuts)}.
 *   Aby maksymalizować koszt zamienić nierówności tam, gdzie wskazane.
 *   Aby uzyskać O(n), należy przepisać overtake w oparciu o dodatkowe założenia,
 *   aby chodził w O(1).
 */
pair<ll, vi> dp_1d1d(int n, function<ll (int, int)> cost) {
	V<pair<ll, int>> dp(n);
	vi lf(n + 2), rg(n + 2), dead(n);
	V<vi> events(n + 1);
	int beg = n, end = n + 1;
	rg[beg] = end; lf[end] = beg;
	auto score = [&](int i, int j) {
		return dp[j].fi + cost(j + 1, i);
	};
	auto overtake = [&](int a, int b, int mn) {
		int bp = mn - 1, bk = n;
		while (bk - bp > 1) {
			int bs = (bp + bk) / 2;
			if (score(bs, a) <= score(bs, b)) // tu >=
				bk = bs;
			else
				bp = bs;
		}
		return bk;
	};
	auto add = [&](int i, int mn) {
		if (lf[i] == beg)
			return;
		events[overtake(i, lf[i], mn)].eb(i);
	};
	REP (i, n) {
		dp[i] = {cost(0, i), -1};
		REP (j, ssize(events[i])) {
			int x = events[i][j];
			if (dead[x])
				continue;
			dead[lf[x]] = 1; lf[x] = lf[lf[x]];
			rg[lf[x]] = x; add(x, i);
		}
		if (rg[beg] != end)
			chmin(dp[i], pair(score(i, rg[beg]), rg[beg])); // tu max
		lf[i] = lf[end]; rg[i] = end;
		rg[lf[i]] = i; lf[rg[i]] = i;
		add(i, i + 1);
	}
	vi cuts;
	for (int p = n - 1; p != -1; p = dp[p].se)
		cuts.eb(p);
	reverse(all(cuts));
	return pair(dp[n - 1].fi, cuts);
}
