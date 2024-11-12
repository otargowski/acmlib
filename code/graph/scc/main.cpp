/*
 * Opis: konstruktor O(n), get\_compressed O(n \log n).
 *   \texttt{group[v]} to numer silnie spójnej wierzchołka $v$,
 *   \texttt{order} to toposort, w którym krawędzie idą w lewo (z lewej są liście),
 *   \texttt{get\_compressed()} zwraca graf silnie spójnych,
 *   \texttt{get\_compressed(false)} nie usuwa multikrawędzi.
 */
struct SCC {
	int n;
	V<vi> &graph;
	int group_cnt = 0;
	vi group;
	V<vi> rev_graph;
	vi order;
	void order_dfs(int v) {
		group[v] = 1;
		for(int u : rev_graph[v])
			if(group[u] == 0)
				order_dfs(u);
		order.eb(v);
	}
	void group_dfs(int v, int color) {
		group[v] = color;
		for(int u : graph[v])
			if(group[u] == -1)
				group_dfs(u, color);
	}
	SCC(V<vi> &_graph) : graph(_graph) {
		n = ssize(graph);
		rev_graph.resize(n);
		REP(v, n)
			for(int u : graph[v])
				rev_graph[u].eb(v);
		group.resize(n);
		REP(v, n)
			if(group[v] == 0)
				order_dfs(v);
		reverse(all(order));
		debug(order);
		group.assign(n, -1);
		for(int v : order)
			if(group[v] == -1)
				group_dfs(v, group_cnt++);
	}
	V<vi> get_compressed(bool delete_same = true) {
		V<vi> ans(group_cnt);
		REP(v, n)
			for(int u : graph[v])
				if(group[v] != group[u])
					ans[group[v]].eb(group[u]);
		if(not delete_same)
			return ans;
		REP(v, group_cnt) {
			sort(all(ans[v]));
			ans[v].erase(unique(all(ans[v])), ans[v].end());
		}
		return ans;
	}
};
