#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	int n = rd(1, 20);
	V<V<pii>> graph(n);
	FOR(v, 1, n - 1) {
		int u = rd(0, v - 1);
		int w = rd(1, 10);
		graph[v].eb(u, w);
		graph[u].eb(v, w);
	}
	int root = rd(0, n - 1);
	int v = rd(0, n - 1), u = rd(0, n - 1);
	OperationJumpPtr ptr(graph, root);
	ll main_sum = ptr.path_ans(v, u);
	debug(root, v, u, main_sum);

	ll brute_sum = 0;
	function<bool (int, int)> dfs = [&](int curr, int p) {
		if(curr == u)
			return true;
		for(auto [nxt, w] : graph[curr])
			if(nxt != p) {
				brute_sum += w;
				if(dfs(nxt, curr))
					return true;
				brute_sum -= w;
			}
		return false;
	};
	assert(dfs(v, -1));
	assert(main_sum == brute_sum);
}

