#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	assert(dominator_tree(V<vi>{{1,2},{3},{4},{4},{5},{}},0) == (V<vi>{{1,4,2},{3},{},{},{5},{}}));
	int n = rd(1, 20);
	int m = rd(n - 1, n * (n - 1) / 2);
	set<pii> edges;
	FOR(v, 1, n - 1)
		edges.emplace(rd(0, v - 1), v);
	while(ssize(edges) < m) {
		int v = rd(0, n - 1);
		int u = rd(0, n - 1);
		if(v < u)
			edges.emplace(v, u);
	}
	debug(edges);

	V<vi> graph(n);
	for(auto [v, u] : edges) {
		graph[v].eb(u);
		graph[u].eb(v);
	}
	int root = rd(0, n - 1);
	REP(v, n)
		shuffle(all(graph[v]), rng);
	vi order(n, -1);
	function<void (int)> dag_dfs = [&](int v) {
		static int gtime = 0;
		order[v] = gtime++;
		for(int u : graph[v])
			if(order[u] == -1)
				dag_dfs(u);
	};
	dag_dfs(root);
	V<vi> dag(n);
	REP(v, n)
		for(int u : graph[v])
			if(order[v] < order[u])
				dag[v].eb(u);
	debug(root, dag);

	V<vi> sons = dominator_tree(dag, root);
	debug(sons);
	vi parent(n, -1), depth(n);
	function<void (int)> dfs_sons = [&](int v) {
		for(int u : sons[v]) {
			parent[u] = v;
			depth[u] = depth[v] + 1;
			dfs_sons(u);
		}
	};
	dfs_sons(root);
	debug(parent, depth);
	REP(v, n)
		if(v != root)
			assert(parent[v] != -1);
	assert(parent[root] == -1);

	REP(v, n)
		if(v != root) {
			pii smallest = {-1, -1};
			REP(u, n)
				if(u != v) {
					V<bool> visited(n, false);
					function<bool (int)> dfs = [&](int w) {
						if(w == v)
							return true;
						visited[w] = true;
						for(int g : dag[w])
							if(not visited[g] and w != u)
								if(dfs(g))
									return true;
						return false;
					};
					bool is_dominating = not dfs(root);
					debug(v, u, is_dominating);
					if(is_dominating)
						smallest = max(smallest, pair(depth[u], u));
				}
			debug(v, smallest);
			assert(smallest.se != -1);
			assert(parent[v] == smallest.se);
		}
}
