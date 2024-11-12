/*
 * Opis: O(n + matching(n, m)) wyznaczanie w grafie dwudzielnym kolejno minimalnego pokrycia krawędziowego (PK), maksymalnego zbioru niezależnych wierzchołków (NW), minimalnego pokrycia wierzchołkowego (PW) korzystając z maksymalnego zbioru niezależnych krawędzi (NK) (tak zwany matching). Z tw. Koniga zachodzi |NK|=n-|PK|=n-|NW|=|PW|.
 */
#include "../matching/main.cpp"
// BEGIN HASH
V<pii> get_min_edge_cover(V<V<int>> graph) {
	V<int> match = Matching(graph)().se;
	V<pii> ret;
	REP(v, ssize(match))
		if(match[v] != -1 and v < match[v])
			ret.eb(v, match[v]);
		else if(match[v] == -1 and not graph[v].empty())
			ret.eb(v, graph[v].front());
	return ret;
} // END HASH
// BEGIN HASH
array<V<int>, 2> get_coloring(V<V<int>> graph) {
	int n = ssize(graph);
	V<int> match = Matching(graph)().se;
	V<int> color(n, -1);
	function<void (int)> dfs = [&](int v) {
		color[v] = 0;
		for(int u : graph[v])
			if(color[u] == -1) {
				color[u] = true;
				dfs(match[u]);
			}
	};
	REP(v, n)
		if(match[v] == -1)
			dfs(v);
	REP(v, n)
		if(color[v] == -1)
			dfs(v);
	array<V<int>, 2> groups;
	REP(v, n)
		groups[color[v]].eb(v);
	return groups;
}
V<int> get_max_independent_set(V<V<int>> graph) {
	return get_coloring(graph)[0];
}
V<int> get_min_vertex_cover(V<V<int>> graph) {
	return get_coloring(graph)[1];
} // END HASH
