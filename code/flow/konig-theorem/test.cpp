#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

template<typename T>
bool contains(const V<T>& v, T x) {
	return find(all(v), x) != v.end();
}

bool is_edge_coverable(int n, const V<pii>& edges) {
	V<int> vis(n, 1);
	for (auto [a, b] : edges)
		vis[a] = vis[b] = 0;
	return n == 0 or *max_element(all(vis)) == 0;
}

bool is_edge_cover(int n, const V<pii>& edges, const V<pii>& edge_cover) {
	auto doubled_edges = edges;
	for (auto [a, b] : edges)
		doubled_edges.eb(b, a);
	for (auto e : edge_cover)
		if (not contains(doubled_edges, e))
			return false;

	V<int> vis(n, 1);
	for (auto [a, b] : edge_cover)
		vis[a] = vis[b] = 0;
	return n == 0 or *max_element(all(vis)) == 0;
}

int brute_edge_cover(int n, const V<pii>& edges) {
	int ans = ssize(edges);
	REP(mask, 1 << ssize(edges)) {
		V<pii> edge_cover;
		REP(i, ssize(edges))
			if ((mask >> i) & 1)
				edge_cover.eb(edges[i]);
		if (is_edge_cover(n, edges, edge_cover))
			ans = min(ans, __builtin_popcount(mask));
	}
	return ans;
}

bool is_independent_set(int n, const V<pii>& edges, const V<int> independent_set) {
	assert(independent_set.empty() or *min_element(all(independent_set)) >= 0);
	assert(independent_set.empty() or *max_element(all(independent_set)) < n);
	for (auto [a, b] : edges)
		if (contains(independent_set, a) and contains(independent_set, b))
			return false;
	return true;
}

int brute_independent_set(int n, const V<pii>& edges) {
	int ans = 0;
	REP(mask, 1 << n) {
		V<int> independent_set;
		REP(i, n)
			if ((mask >> i) & 1)
				independent_set.eb(i);
		if (is_independent_set(n, edges, independent_set))
			ans = max(ans, __builtin_popcount(mask));
	}
	return ans;
}

bool is_vertex_cover(int n, const V<pii>& edges, const V<int> vertex_cover) {
	assert(vertex_cover.empty() or *min_element(all(vertex_cover)) >= 0);
	assert(vertex_cover.empty() or *max_element(all(vertex_cover)) < n);
	for (auto [a, b] : edges)
		if (not contains(vertex_cover, a) and not contains(vertex_cover, b))
			return false;
	return true;
}

int brute_vertex_cover(int n, const V<pii>& edges) {
	int ans = ssize(edges);
	REP(mask, 1 << n) {
		V<int> vertex_cover;
		REP(i, n)
			if ((mask >> i) & 1)
				vertex_cover.eb(i);
		if (is_vertex_cover(n, edges, vertex_cover))
			ans = min(ans, __builtin_popcount(mask));
	}
	return ans;
}

void test() {
	const int max_side = 7;
	const int max_edges = 15;

	int n0 = rd(0, max_side), n1 = rd(0, max_side);
	int n = n0 + n1;
	V<int> which_group(n0 + n1);
	REP(i, n1)
		which_group[i] = 1;
	shuffle(all(which_group), rng);
	array<V<int>, 2> in_group;
	REP(v, n)
		in_group[which_group[v]].eb(v);

	int m = min(max_edges, rd(0, n0 * n1));
	V<pii> edges(m);
	for(auto &[v, u] : edges) {
		v = in_group[0][rd(0, n0 - 1)];
		u = in_group[1][rd(0, n1 - 1)];
		if(rd(0, 1))
			swap(v, u);
	}
	debug(n, edges);

	V<V<int>> graph(n);
	for(auto [v, u] : edges) {
		graph[v].eb(u);
		graph[u].eb(v);
	}

	{ // min_edge_cover
		auto edge_cover = get_min_edge_cover(graph);
		debug(edge_cover);
		if (is_edge_coverable(n, edges)) {
			assert(ssize(edge_cover) == brute_edge_cover(n, edges));
			assert(is_edge_cover(n, edges, edge_cover));
		}
	}

	{ // max_independent_set
		auto independent_set = get_max_independent_set(graph);
		debug(independent_set);
		assert(ssize(independent_set) == brute_independent_set(n, edges));
		assert(is_independent_set(n, edges, independent_set));
	}

	{ // min_vertex_cover
		auto vertex_cover = get_min_vertex_cover(graph);
		debug(vertex_cover);
		assert(ssize(vertex_cover) == brute_vertex_cover(n, edges));
		assert(is_vertex_cover(n, edges, vertex_cover));
	}
}
