/*
 * Opis: O(szybko) ale istnieją przykłady O(n^2), przyjmuje graf nieskierowany bez pętelek i multikrawędzi.
 */

bool is_planar(V<vi> graph) {
	int n = ssize(graph), m = 0;
	REP(v, n)
		m += ssize(graph[v]);
	m /= 2;
	if(n <= 3) return true;
	if(m > 3 * n - 6) return false;
	V<vi> up(n), dn(n);
	vi low(n, -1), pre(n);
	REP(start, n)
		if(low[start] == -1) {
			V<pii> e_up;
			int tm = 0;
			function<void (int, int)> dfs_low = [&](int v, int p) {
				low[v] = pre[v] = tm++;
				for(int u : graph[v])
					if(u != p and low[u] == -1) {
						dn[v].eb(u);
						dfs_low(u, v);
						low[v] = min(low[v], low[u]);
					}
					else if(u != p and pre[u] < pre[v]) {
						up[v].eb(ssize(e_up));
						e_up.eb(v, u);
						low[v] = min(low[v], pre[u]);
					}
			};
			dfs_low(start, -1);
			V<pair<int, bool>> dsu(ssize(e_up));
			REP(v, ssize(dsu)) dsu[v].fi = v;
			function<pair<int, bool> (int)> find = [&](int v) {
				if(dsu[v].fi == v)
					return pair(v, false);
				auto [u, ub] = find(dsu[v].fi);
				return dsu[v] = pair(u, ub ^ dsu[v].se);
			};
			auto onion = [&](int x, int y, bool flip) {
				auto [v, vb] = find(x);
				auto [u, ub] = find(y);
				if(v == u)
					return not (vb ^ ub ^ flip);
				dsu[v] = {u, vb ^ ub ^ flip};
				return true;
			};
			auto interlace = [&](C vi &ids, int lo) {
				vi ans;
				for(int e : ids)
					if(pre[e_up[e].se] > lo)
						ans.eb(e);
				return ans;
			};
			auto add_fu = [&](C vi &a, C vi &b) {
				FOR(k, 1, ssize(a) - 1)
					if(not onion(a[k - 1], a[k], 0))
						return false;
				FOR(k, 1, ssize(b) - 1)
					if(not onion(b[k - 1], b[k], 0))
						return false;
				return a.empty() or b.empty() or onion(a[0], b[0], 1);
			};
			function<bool (int, int)> dfs_planar = [&](int v, int p) {
				for(int u : dn[v])
					if(not dfs_planar(u, v))
						return false;
				REP(i, ssize(dn[v])) {
					FOR(j, i + 1, ssize(dn[v]) - 1)
						if(not add_fu(interlace(up[dn[v][i]], low[dn[v][j]]),
									  interlace(up[dn[v][j]], low[dn[v][i]])))
							return false;
					for(int j : up[v]) {
						if(e_up[j].fi != v)
							continue;
						if(not add_fu(interlace(up[dn[v][i]], pre[e_up[j].se]),
									  interlace({j}, low[dn[v][i]])))
							return false;
					}
				}
				for(int u : dn[v]) {
					for(int idx : up[u])
						if(pre[e_up[idx].se] < pre[p])
							up[v].eb(idx);
					exchange(up[u], {});
				}
				return true;
			};
			if(not dfs_planar(start, -1))
				return false;
		}
	return true;
}
