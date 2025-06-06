#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	int n = rd(1, 20);
	int m = rd(0, n * n);
	V<V<pii>> graph(n);
	while(m --> 0)
		graph[rd(0, n - 1)].eb(rd(0, n - 1), rd(-2 * n, 2 * n));
	debug(graph);

	auto [is_cycle, cycle] = negative_cycle(graph);
	debug(is_cycle, cycle);

	auto is_cycle_floyd_warshall = [&] {
		constexpr int inf = int(1e9);
		V dist(n, vi(n, inf));
		REP(v, n)
			dist[v][v] = 0;
		REP(v, n)
			for(auto [u, w] : graph[v])
				chmin(dist[v][u], w);
		REP(k, n)
			REP(i, n)
				REP(j, n) {
					chmin(dist[i][j], dist[i][k] + dist[k][j]);
					chmax(dist[i][j], -inf);
				}
		REP(v, n)
			if(dist[v][v] < 0)
				return true;
		return false;
	};
	assert(is_cycle == is_cycle_floyd_warshall());
	if(not is_cycle)
		return;

	int sum_on_cycle = 0;
	REP(i, ssize(cycle)) {
		int v = cycle[i];
		int u = cycle[(i + 1) % ssize(cycle)];
		bool found = false;
		int found_w;
		for(auto [uu, w] : graph[v])
			if(uu == u) {
				if(not found) {
					found_w = w;
					found = true;
				}
				else
					chmin(found_w, w);
			}
		assert(found);
		sum_on_cycle += found_w;
	}
	assert(sum_on_cycle < 0);

	sort(all(cycle));
	REP(i, ssize(cycle) - 1)
		assert(cycle[i] != cycle[i + 1]);
}
