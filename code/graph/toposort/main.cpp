/*
 * Opis: O(n),
 *   \texttt{get\_toposort\_order(g)} zwraca listę wierzchołków takich,
 *   że krawędzie są od wierzchołków wcześniejszych w liście do późniejszych.
 *   \texttt{get\_new\_vertex\_id\_from\_order(order)} zwraca odwrotność tej permutacji,
 *    tzn. dla każdego wierzchołka trzyma jego nowy numer, aby po przenumerowaniu grafu istniały krawędzie tylko do wierzchołków o większych numerach.
 *   \texttt{permute(elems, new\_id)} zwraca przepermutowaną tablicę elems według nowych numerów wierzchołków
 *   (przydatne jak się trzyma informacje o wierzchołkach, a chce się zrobić przenumerowanie topologiczne).
 *   \texttt{renumerate\_vertices(...)} zwraca nowy graf, w którym wierzchołki są przenumerowane.
 *   Nowy graf: \texttt{renumerate\_vertices(graph, get\_new\_vertex\_id\_from\_order(get\_toposort\_order(graph)))}.
 */
// BEGIN HASH
vi get_toposort_order(V<vi> graph) {
	int n = ssize(graph);
	vi indeg(n);
	REP(v, n)
		for(int u : graph[v])
			++indeg[u];
	vi que;
	REP(v, n)
		if(indeg[v] == 0)
			que.eb(v);
	vi ret;
	while(not que.empty()) {
		int v = que.back();
		que.pop_back();
		ret.eb(v);
		for(int u : graph[v])
			if(--indeg[u] == 0)
				que.eb(u);
	}
	return ret;
} // END HASH
vi get_new_vertex_id_from_order(vi order) {
	vi ret(ssize(order), -1);
	REP(v, ssize(order))
		ret[order[v]] = v;
	return ret;
}
template<class T>
V<T> permute(V<T> elems, vi new_id) {
	V<T> ret(ssize(elems));
	REP(v, ssize(elems))
		ret[new_id[v]] = elems[v];
	return ret;
}
V<vi> renumerate_vertices(V<vi> graph, vi new_id) {
	int n = ssize(graph);
	V<vi> ret(n);
	REP(v, n)
		for(int u : graph[v])
			ret[new_id[v]].eb(new_id[u]);
	REP(v, n)
		for(int u : ret[v])
			assert(v < u);
	return ret;
}
