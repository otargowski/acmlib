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
	int n0 = rd(0, 7), n1 = rd(0, 7);
	int n = n0 + n1;
	V<int> which_group(n0 + n1);
	REP(i, n1)
		which_group[i] = 1;
	shuffle(all(which_group), rng);
	array<V<int>, 2> in_group;
	REP(v, n)
		in_group[which_group[v]].eb(v);

	int m = min(15, rd(0, n0 * n1));
	V<pii> edges(m);
	for(auto &[v, u] : edges) {
		v = in_group[0][rd(0, n0 - 1)];
		u = in_group[1][rd(0, n1 - 1)];
		if(rd(0, 1))
			swap(v, u);
	}

	V<V<int>> graph(n);
	for(auto [v, u] : edges) {
		graph[v].eb(u);
		graph[u].eb(v);
	}

	auto [match_size, match] = Matching(graph)();
	debug(n, edges, match_size, get_max_matching(n, edges));
	assert(match_size == get_max_matching(n, edges));
	assert(is_valid_matching(n, edges, match));
}
