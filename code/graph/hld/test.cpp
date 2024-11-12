#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

struct Test {
	V<V<int>> graph;
	V<ll> sums;
	HLD hld;

	Test(int n, V<V<int>> _graph) : graph(_graph), sums(n), hld(n, graph) {}

	void add(int v, int u, ll val) {
		auto path = hld.get_path(v, u);
		for(auto &p : path) {
			assert(p.fi <= p.se);
			for(int j = p.fi; j <= p.se; j++)
				sums[j] += val;
		}
	}

	ll query(int v, int u) {
		 ll ret = 0;
		 auto path = hld.get_path(v, u);
		 for(auto &p : path) {
			assert(p.fi <= p.se);
			for(int j = p.fi; j <= p.se; j++)
				ret += sums[j];
		 }
		 return ret;
	}
};

struct Brute {
	V<V<int>> graph;
	V<ll> sums;

	bool found;
	ll dfs(int v, int u, ll val, int p = -1) {
		if(p == -1) found = false;
		if(v == u) {
			found = true;
			sums[v] += val;
			return sums[v];
		}

		for(int x : graph[v]) if(x != p) {
			ll ret = dfs(x, u, val, v);
			if(found) {
				sums[v] += val;
				return ret + sums[v];
			}
		}

		return 0;
	}

	void add(int v, int u, ll val) {
		dfs(v, u, val);
	}

	ll query(int v, int u) {
		return dfs(v, u, 0);
	}

	Brute(int n, V<V<int>> _graph) : graph(_graph), sums(n) {}
};

void test() {
	int N = 100;
	int n = rd(1, N);
	int q = rd(1, N);

	V<V<int>> graph(n);
	REP(i, n - 1) {
		int v = i + 1;
		int p = rd(0, v - 1);
		graph[v].eb(p);
		graph[p].eb(v);
	}

	Test hld(n, graph);
	Brute brut(n, graph);

	REP(i, q)
		if(rd(0, 1)) {
			int v = rd(0, n - 1), u = rd(0, n - 1), val = rd(1, 100);
			hld.add(v, u, val);
			brut.add(v, u, val);
		}
		else {
			int v = rd(0, n - 1), u = rd(0, n - 1);
			assert(hld.query(v, u) == brut.query(v, u));
		}
}
