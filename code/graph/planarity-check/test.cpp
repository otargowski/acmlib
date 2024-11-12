#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

bool is_planar_brute(int n, V<pii> edges) {
	REP(mask, 1 << ssize(edges)) {
		vi lead(n);
		iota(all(lead), 0);
		function<int (int)> find = [&](int v) {
			return v == lead[v] ? v : lead[v] = find(lead[v]);
		};
		REP(i, ssize(edges))
			if((mask >> i) & 1)
				lead[find(edges[i].fi)] = find(edges[i].se);

		vi leads;
		REP(v, n)
			if(lead[v] == v)
				leads.eb(v);
		set<pii> new_edges;
		for(auto [v, u] : edges) {
			v = find(v);
			u = find(u);
			if(v != u)
				new_edges.emplace(min(v, u), max(v, u));
		}
		debug(mask);
		debug(leads);
		debug(new_edges);

		V<vi> graph(n);
		for(auto [v, u] : new_edges) {
			graph[v].eb(u);
			graph[u].eb(v);
		}

		V<bool> vis(n);
		vi component;
		function<void (int)> dfs = [&](int v) {
			component.eb(v);
			vis[v] = true;
			for(int u : graph[v])
				if(not vis[u])
					dfs(u);
		};

		REP(start, n)
			if(not vis[start]) {
				component.clear();
				dfs(start);

				if(ssize(component) != 5 and ssize(component) != 6)
					continue;
				int m = 0;
				for(int v : component)
					m += ssize(graph[v]);
				m /= 2;
				if(ssize(component) == 5) {
					if(m == 10)
						return false;
					continue;
				}
				if(m < 9)
					continue;
				sort(all(component));
				do {
					auto is_k33 = [&] {
						for(int v : {component[0], component[1], component[2]})
							for(int u : {component[3], component[4], component[5]}) {
								bool is_edge = false;
								for(auto [a, b] : new_edges)
									if(min(v, u) == min(a, b) and max(v, u) == max(a, b))
										is_edge = true;
								if(not is_edge)
									return false;
							}
						return true;
					};
					if(is_k33())
						return false;
				} while(next_permutation(all(component)));
			}
	}
	return true;
}

void test() {
	int n = rd(1, 15);
	int m = rd(0, min(13, n * (n - 1) / 2));
	set<pii> edges_set;
	while(ssize(edges_set) < m) {
		int v = rd(0, n - 1);
		int u = rd(0, n - 1);
		if(v < u)
			edges_set.emplace(v, u);
	}
	debug(edges_set);

	V<vi> graph(n);
	for(auto [v, u] : edges_set) {
		graph[v].eb(u);
		graph[u].eb(v);
	}
	debug(graph);
	bool ans_main = is_planar(graph);
	debug(ans_main);
	bool ans_brut = is_planar_brute(n, V<pii>(all(edges_set)));
	debug(ans_brut);
	assert(ans_main == ans_brut);
}
