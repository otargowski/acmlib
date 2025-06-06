/*
 * Opis: O(V E + |flow| E \log V), Min-cost max-flow.
 *   Można przepisać funkcję get\_flowing() z Dinic'a.
 *   Kiedy wie się coś więcej o początkowym grafie np. że jest DAG-iem lub że ma tylko nieujemne wagi krawędzi, można napisać własne calc\_init\_dist by usunąć $V E$ ze złożoności.
 *   Jeżeli $E = O(V^2)$, to może być lepiej napisać samemu kwadratową dijkstrę.
 */
struct MCMF {
	struct Edge {
		int v, u, flow, cap;
		ll cost;
		friend ostream& operator<<(ostream &os, Edge &e) {
			return os << vll{e.v, e.u, e.flow, e.cap, e.cost};
		}
	};
	int n;
	C ll inf_LL = 1e18;
	C int inf_int = 1e9;
	V<vi> graph;
	V<Edge> edges;
	vll init_dist;
	MCMF(int N) : n(N), graph(n), init_dist(n) {}
	void add_edge(int v, int u, int cap, ll cost) {
		int e = ssize(edges);
		graph[v].eb(e);
		graph[u].eb(e + 1);
		edges.eb(v, u, 0, cap, cost);
		edges.eb(u, v, 0, 0, -cost);
	}
	void calc_init_dist(int source) {
		fill(all(init_dist), inf_LL);
		V<bool> inside(n);
		inside[source] = true;
		deque<int> que = {source};
		init_dist[source] = 0;
		while (ssize(que)) {
			int v = que.front();
			que.pop_front();
			inside[v] = false;
			for (int i : graph[v]) {
				Edge &e = edges[i];
				if (e.flow < e.cap and init_dist[v] + e.cost < init_dist[e.u]) {
					init_dist[e.u] = init_dist[v] + e.cost;
					if (not inside[e.u]) {
						inside[e.u] = true;
						que.eb(e.u);
					}
				}
			}
		}
	}
	pair<int, ll> augment(int source, int sink) {
		V<bool> vis(n);
		vi from(n, -1);
		vll dist(n, inf_LL);
		priority_queue<pair<ll, int>, V<pair<ll, int>>, greater<>> que;
		que.emplace(0, source);
		dist[source] = 0;
		while(ssize(que)) {
			auto [d, v] = que.top();
			que.pop();
			if (vis[v]) continue;
			vis[v] = true;
			for (int i : graph[v]) {
				Edge &e = edges[i];
				ll new_dist = d + e.cost + init_dist[v];
				if (not vis[e.u] and e.flow != e.cap and new_dist < dist[e.u]) {
					dist[e.u] = new_dist;
					from[e.u] = i;
					que.emplace(new_dist - init_dist[e.u], e.u);
				}
			}
		}
		if (not vis[sink])
			return {0, 0};
		int flow = inf_int, e = from[sink];
		while(e != -1) {
			chmin(flow, edges[e].cap - edges[e].flow);
			e = from[edges[e].v];
		}
		e = from[sink];
		while(e != -1) {
			edges[e].flow += flow;
			edges[e ^ 1].flow -= flow;
			e = from[edges[e].v];
		}
		init_dist.swap(dist);
		return {flow, flow * init_dist[sink]};
	}
	pair<int, ll> operator()(int source, int sink) {
		calc_init_dist(source);
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
