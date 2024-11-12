/*
 * Opis: O(n^2 + n\cdot dinic(n, m)), zwraca min cięcie między każdą parą wierzchołków w nieskierowanym ważonym grafie o nieujemnych wagach.
 *   \texttt{gomory\_hu(n, edges)[s][t] == min cut (s, t)}
 */
#include "../dinic/main.cpp"
pair<Dinic::T, V<bool>> get_min_cut(Dinic &dinic, int s, int t) {
	for(Dinic::Edge &e : dinic.edges)
		e.flow = 0;
	Dinic::T flow = dinic(s, t);
	V<bool> cut(dinic.n);
	REP(v, dinic.n)
		cut[v] = bool(dinic.dist[v]);
	return {flow, cut};
}
V<V<Dinic::T>> get_gomory_hu(int n, V<tuple<int, int, Dinic::T>> edges) {
	Dinic dinic(n);
	for(auto [v, u, cap] : edges) {
		dinic.add_edge(v, u, cap);
		dinic.add_edge(u, v, cap);
	}
	using T = Dinic::T;
	V<V<pair<int, T>>> tree(n);
	vi par(n, 0);
	FOR(v, 1, n - 1) {
		auto [flow, cut] = get_min_cut(dinic, v, par[v]);
		FOR(u, v + 1, n - 1)
			if(cut[u] == cut[v] and par[u] == par[v])
				par[u] = v;
		tree[v].eb(par[v], flow);
		tree[par[v]].eb(v, flow);
	}
	T inf = numeric_limits<T>::max();
	V ret(n, V(n, inf));
	REP(source, n) {
		function<void (int, int, T)> dfs = [&](int v, int p, T mn) {
			ret[source][v] = mn;
			for(auto [u, flow] : tree[v])
				if(u != p)
					dfs(u, v, min(mn, flow));
		};
		dfs(source, -1, inf);
	}
	return ret;
}
