/*
 * Opis: O(nm) stwierdzanie istnienia i wyznaczanie ujemnego cyklu.
 *   \texttt{cycle} spełnia \texttt{cycle[i]->cycle[(i+1)\%ssize(cycle)]}.
 *   Żeby wyznaczyć krawędzie na cyklu, wystarczy wybierać najtańszą krawędź między wierzchołkami.
 */
template</*integral*/class I>
pair<bool, vi> negative_cycle(V<V<pair<int, I>>> graph) {
	int n = ssize(graph);
	V<I> dist(n);
	vi from(n, -1);
	int v_on_cycle = -1;
	REP(iter, n) {
		v_on_cycle = -1;
		REP(v, n)
			for(auto [u, w] : graph[v])
				if(dist[u] > dist[v] + w) {
					dist[u] = dist[v] + w;
					from[u] = v;
					v_on_cycle = u;
				}
	}
	if(v_on_cycle == -1)
		return {false, {}};
	REP(iter, n)
		v_on_cycle = from[v_on_cycle];
	vi cycle = {v_on_cycle};
	for(int v = from[v_on_cycle]; v != v_on_cycle; v = from[v])
		cycle.eb(v);
	reverse(all(cycle));
	return {true, cycle};
}
