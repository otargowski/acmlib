/*
 * Opis: O(idk), działa 1s dla n=155 na najgorszych przypadkach
 * (losowe grafy p=.90). Działa szybciej dla grafów rzadkich.
 * Zwraca listę wierzchołków w jakiejś max klice. Pętelki niedozwolone.
 */
constexpr int max_n = 500;
vi get_max_clique(V<bitset<max_n>> e) {
	double limit = 0.025, pk = 0;
	V<pii> v;
	V<vi> c(ssize(e) + 1);
	vi qmax, q, S(ssize(c)), old(S);
	REP(i, ssize(e)) v.eb(0, i);
	auto init = [&](V<pii>& r) {
		for (auto& vv : r) for (auto j : r) vv.fi += e[vv.se][j.se];
		sort(rall(r));
		int mxD = r[0].fi;
		REP(i, ssize(r)) r[i].fi = min(i, mxD) + 1;
	};
	function<void (V<pii>&, int)> expand = [&](V<pii>& R, int lev) {
		S[lev] += S[lev - 1] - old[lev];
		old[lev] = S[lev - 1];
		while (ssize(R)) {
			if (ssize(q) + R.back().fi <= ssize(qmax)) return;
			q.eb(R.back().se);
			V<pii> T;
			for(auto [_, vv] : R) if (e[R.back().se][vv]) T.eb(0, vv);
			if (ssize(T)) {
				if (S[lev]++ / ++pk < limit) init(T);
				int j = 0, mxk = 1, mnk = max(ssize(qmax) - ssize(q) + 1, 1);
				c[1] = c[2] = {};
				for (auto [_, v] : T) {
					int k = 1;
					while (any_of(all(c[k]), [&](int i) { return e[v][i]; })) k++;
					if (k > mxk) c[(mxk = k) + 1] = {};
					if (k < mnk) T[j++].se = v;
					c[k].eb(v);
				}
				if (j > 0) T[j - 1].fi = 0;
				FOR(k, mnk, mxk) for (int i : c[k]) T[j++] = {k, i};
				expand(T, lev + 1);
			} else if (ssize(q) > ssize(qmax)) qmax = q;
			q.pop_back(), R.pop_back();
		}
	};
	init(v), expand(v, 1); return qmax;
}
