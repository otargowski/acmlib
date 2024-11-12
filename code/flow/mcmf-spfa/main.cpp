/*
 * Opis: O(idk), Min-cost max-flow z SPFA.
 *   Można przepisać funkcję get\_flowing() z Dinic'a.
 */
struct MCMF {
	struct Edge {
		int v, u, flow, cap;
		ll cost;
		friend ostream& operator<<(ostream &os, Edge &e) {
			return os << V<ll>{e.v, e.u, e.flow, e.cap, e.cost};
		}
	};
	int n;
	C ll inf_LL = 1e18;
	C int inf_int = 1e9;
	V<V<int>> graph;
	V<Edge> edges;
	MCMF(int N) : n(N), graph(n) {}
	void add_edge(int v, int u, int cap, ll cost) {
		int e = ssize(edges);
		graph[v].eb(e);
		graph[u].eb(e + 1);
		edges.eb(v, u, 0, cap, cost);
		edges.eb(u, v, 0, 0, -cost);
	}
	pair<int, ll> augment(int source, int sink) {
		V<ll> dist(n, inf_LL);
		V<int> from(n, -1);
		dist[source] = 0;
		deque<int> que = {source};
		V<bool> inside(n);
		inside[source] = true;
		while(ssize(que)) {
			int v = que.front();
			inside[v] = false;
			que.pop_front();
			for(int i : graph[v]) {
				Edge &e = edges[i];
				if(e.flow != e.cap and dist[e.u] > dist[v] + e.cost) {
					dist[e.u] = dist[v] + e.cost;
					from[e.u] = i;
					if(not inside[e.u]) {
						inside[e.u] = true;
						que.eb(e.u);
					}
				}
			}
		}
		if(from[sink] == -1)
			return {0, 0};
		int flow = inf_int, e = from[sink];
		while(e != -1) {
			flow = min(flow, edges[e].cap - edges[e].flow);
			e = from[edges[e].v];
		}
		e = from[sink];
		while(e != -1) {
			edges[e].flow += flow;
			edges[e ^ 1].flow -= flow;
			e = from[edges[e].v];
		}
		return {flow, flow * dist[sink]};
	}
	pair<int, ll> operator()(int source, int sink) {
		int flow = 0;
		ll cost = 0;
		pair<int, ll> got;
		do {
			got = augment(source, sink);
			flow += got.fi;
			cost += got.se;
		} while(got.fi);
		return {flow, cost};
	}
};
