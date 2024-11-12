/*
 * Opis: O(n + matching(n, m)) wyznaczanie w grafie dwudzielnym kolejno minimalnego pokrycia krawędziowego (PK), maksymalnego zbioru niezależnych wierzchołków (NW), minimalnego pokrycia wierzchołkowego (PW) korzystając z maksymalnego zbioru niezależnych krawędzi (NK) (tak zwany matching). Z tw. Koniga zachodzi |NK|=n-|PK|=n-|NW|=|PW|.
 */
#include "../matching/main.cpp"
// BEGIN HASH
V<pii> get_min_edge_cover(V<vi> graph) {
	vi match = Matching(graph)().se;
	V<pii> ret;
	REP(v, ssize(match))
		if(match[v] != -1 and v < match[v])
			ret.eb(v, match[v]);
		else if(match[v] == -1 and not graph[v].empty())
			ret.eb(v, graph[v].front());
	return ret;
} // END HASH
// BEGIN HASH
array<vi, 2> get_coloring(V<vi> graph) {
	int n = ssize(graph);
	vi match = Matching(graph)().se;
	vi color(n, -1);
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
	array<vi, 2> groups;
	REP(v, n)
		groups[color[v]].eb(v);
	return groups;
}
vi get_max_independent_set(V<vi> graph) {
	return get_coloring(graph)[0];
}
vi get_min_vertex_cover(V<vi> graph) {
	return get_coloring(graph)[1];
} // END HASH
