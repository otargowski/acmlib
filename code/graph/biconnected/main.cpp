/*
 * Opis: O(n+m), dwuspójne składowe, mosty oraz punkty artykulacji.
 * po skonstruowaniu, \texttt{bicon} = zbiór list id krawędzi, \texttt{bridges} = lista id krawędzi będącymi mostami,
 * \texttt{arti\_points} = lista wierzchołków będącymi punktami artykulacji.
 * Tablice są nieposortowane. Wspiera multikrawędzie i wiele spójnych, ale nie pętle.
 */
struct Low {
	V<V<int>> graph;
	V<int> low, pre;
	V<pii> edges;
	V<V<int>> bicon;
	V<int> bicon_stack, arti_points, bridges;
	int gtime = 0;
	void dfs(int v, int p) {
		low[v] = pre[v] = gtime++;
		bool considered_parent = false;
		int son_count = 0;
		bool is_arti = false;
		for(int e : graph[v]) {
			int u = edges[e].fi ^ edges[e].se ^ v;
			if(u == p and not considered_parent)
				considered_parent = true;
			else if(pre[u] == -1) {
				bicon_stack.eb(e);
				dfs(u, v);
				low[v] = min(low[v], low[u]);
				if(low[u] >= pre[v]) {
					bicon.eb();
					do {
						bicon.back().eb(bicon_stack.back());
						bicon_stack.pop_back();
					} while(bicon.back().back() != e);
				}
				++son_count;
				if(p != -1 and low[u] >= pre[v])
					is_arti = true;
				if(low[u] > pre[v])
					bridges.eb(e);
			}
			else if(pre[v] > pre[u]) {
				low[v] = min(low[v], pre[u]);
				bicon_stack.eb(e);
			}
		}
		if(p == -1 and son_count > 1)
			is_arti = true;
		if(is_arti)
			arti_points.eb(v);
	}
	Low(int n, V<pii> _edges) : graph(n), low(n), pre(n, -1), edges(_edges) {
		REP(i, ssize(edges)) {
			auto [v, u] = edges[i];
#ifdef LOCAL
			assert(v != u);
#endif
			graph[v].eb(i);
			graph[u].eb(i);
		}
		REP(v, n)
			if(pre[v] == -1)
				dfs(v, -1);
	}
};
