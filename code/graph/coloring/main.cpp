/*
 * Opis: O(nm), wyznacza kolorowanie grafu planaranego.
 *   \texttt{coloring(graph)} zwraca 5-kolorowanie grafu
 *   \texttt{coloring(graph, 4)} zwraca 4-kolorowanie grafu,
 *   jeżeli w każdym momencie procesu usuwania wierzchołka o najmniejszym stopniu jego stopień jest nie większy niż 4
 */
V<int> coloring(C V<V<int>>& graph, C int limit = 5) {
	C int n = ssize(graph);
	if (!n) return {};
	function<V<int>(V<bool>)> solve = [&](C V<bool>& active) {
		if (not *max_element(all(active)))
			return V (n, -1);
		pii best = {n, -1};
		REP(i, n) {
			if (not active[i])
				continue;
			int cnt = 0;
			for (int e : graph[i])
				cnt += active[e];
			best = min(best, {cnt, i});
		}
		C int id = best.se;
		auto cp = active;
		cp[id] = false;
		auto col = solve(cp);
		V<bool> used(limit);
		for (int e : graph[id])
			if (active[e])
				used[col[e]] = true;
		REP(i, limit)
			if (not used[i]) {
				col[id] = i;
				return col;
			}
		for (int e0 : graph[id]) {
			for (int e1 : graph[id]) {
				if (e0 >= e1)
					continue;
				V<bool> vis(n);
				function<void(int, int, int)> dfs = [&](int v, int c0, int c1) {
					vis[v] = true;
					for (int e : graph[v])
						if (not vis[e] and (col[e] == c0 or col[e] == c1))
							dfs(e, c0, c1);
				};
				C int c0 = col[e0], c1 = col[e1];
				dfs(e0, c0, c1);
				if (vis[e1])
					continue;
				REP(i, n)
					if (vis[i])
						col[i] = col[i] == c0 ? c1 : c0;
				col[id] = c0;
				return col;
			}
		}
		assert(false);
	};
	return solve(V (n, true));
}
