/*
 * Opis: O(n + m), ścieżka eulera. Zwraca tupla (exists, ids, vertices).
 * W \texttt{exists} jest informacja czy jest ścieżka/cykl eulera,
 * \texttt{ids} zawiera id kolejnych krawędzi,
 * \texttt{vertices} zawiera listę wierzchołków na tej ścieżce.
 * Dla cyklu, \texttt{vertices[0] == vertices[m]}.
 */
tuple<bool, vi, vi> eulerian_path(int n, C V<pii> &edges, bool directed) {
	vi in(n);
	V<vi> adj(n);
	int start = 0;
	REP(i, ssize(edges)) {
		auto [a, b] = edges[i];
		start = a;
		++in[b];
		adj[a].eb(i);
		if (not directed)
			adj[b].eb(i);
	}
	int cnt_in = 0, cnt_out = 0;
	REP(i, n) {
		if (directed) {
			if (abs(ssize(adj[i]) - in[i]) > 1)
				return {};
			if (in[i] < ssize(adj[i]))
				start = i, ++cnt_in;
			else
				cnt_out += in[i] > ssize(adj[i]);
		}
		else if (ssize(adj[i]) % 2)
			start = i, ++cnt_in;
	}
	vi ids, vertices;
	V<bool> used(ssize(edges));
	function<void (int)> dfs = [&](int v) {
		while (ssize(adj[v])) {
			int id = adj[v].back(), u = v ^ edges[id].fi ^ edges[id].se;
			adj[v].pop_back();
			if (used[id]) continue;
			used[id] = true;
			dfs(u);
			ids.eb(id);
		}
	};
	dfs(start);
	if (cnt_in + cnt_out > 2 or not all_of(all(used), identity{}))
		return {};
	reverse(all(ids));
	if (ssize(ids))
		vertices = {start};
	for (int id : ids)
		vertices.eb(vertices.back() ^ edges[id].fi ^ edges[id].se);
	return {true, ids, vertices};
}
