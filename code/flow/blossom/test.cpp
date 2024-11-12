#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

int get_max_matching(int n, V<pii> edges) {
	int answer = 0;
	REP(mask, 1 << ssize(edges)) {
		bool is_valid = true;
		V<bool> is_taken(n, false);
		REP(i, ssize(edges))
			if((mask >> i) & 1) {
				auto [v, u] = edges[i];
				if(is_taken[v] or is_taken[u]) {
					is_valid = false;
					break;
				}
				is_taken[v] = is_taken[u] = true;
			}
		if(is_valid)
			answer = max(answer, __builtin_popcount(mask));
	}
	return answer;
}

bool is_valid_matching(int n, V<pii> edges, V<int> match) {
	REP(v, n)
		if(match[v] != -1) {
			bool found = false;
			for(auto [x, y] : edges)
				if(min(x, y) == min(v, match[v]) and max(x, y) == max(v, match[v])) {
					found = true;
					break;
				}
			if(not found)
				return false;
		}
	return true;
}

void test() {
	int n = rd(2, 14);
	int m = min(15, rd(0, n * n));
	V<pii> edges(m);
	for(auto &[v, u] : edges) {
		while(true) {
			v = rd(0, n - 1);
			u = rd(0, n - 1);
			if(v != u)
				break;
		}
	}

	V<V<int>> graph(n);
	for(auto [v, u] : edges) {
		graph[v].eb(u);
		graph[u].eb(v);
	}

	V match = blossom(graph);
	int match_size = 0;
	for(int x : match)
		match_size += bool(x != -1);
	match_size /= 2;
	debug(n, edges, match_size, get_max_matching(n, edges));
	assert(match_size == get_max_matching(n, edges));
	assert(is_valid_matching(n, edges, match));
}
