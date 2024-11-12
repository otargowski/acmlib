/*
 * Opis: O(r^2 \cdot (init + n \cdot add)), where r is max independent set.
 * Find largest subset S of [n] such that S is independent in both
 * matroid A and B, given by their oracles, see example implementations below.
 * Returns V V such that V[i] = 1 iff i-th element is included in found set;
 * Zabrane z https://github.com/KacperTopolski/kactl/tree/main
 * Zmienne w matroidach ustawiamy ręcznie aby "zainicjalizować" tylko jeśli mają
 * komentarz co znaczą. W przeciwnym wypadku intersectMatroids zrobi robotę wołając init.
 */

// BEGIN HASH
template<class T, class U>
V<bool> intersectMatroids(T& A, U& B, int n) {
	V<bool> ans(n);
	bool ok = 1;
// NOTE: for weighted matroid intersection find
// shortest augmenting paths first by weight change,
// then by length using Bellman-Ford,

	// Speedup trick (only for unweighted):
	A.init(ans); B.init(ans);
	REP(i, n)
		if (A.canAdd(i) && B.canAdd(i))
			ans[i] = 1, A.init(ans), B.init(ans);
	//End of speedup

	while (ok) {
		V<vi> G(n);
		V<bool> good(n);
		queue<int> que;
		vi prev(n, -1);
		A.init(ans); B.init(ans); ok = 0;
		REP(i, n) if (!ans[i]) {
			if (A.canAdd(i)) que.emplace(i), prev[i]=-2;
			good[i] = B.canAdd(i);
		}

		REP(i, n) if (ans[i]) {
			ans[i] = 0;
			A.init(ans); B.init(ans);
			REP(j, n) if (i != j && !ans[j]) {
				if (A.canAdd(j)) G[i].eb(j); //-cost[j]
				if (B.canAdd(j)) G[j].eb(i); // cost[i]
			}
			ans[i] = 1;
		}

		while (!que.empty()) {
			int i = que.front();
			que.pop();
			if (good[i]) { // best found (unweighted = shortest path)
				ans[i] = 1;
				while (prev[i] >= 0) { // alternate matching
					ans[i = prev[i]] = 0;
					ans[i = prev[i]] = 1;
				}
				ok = 1; break;
			}
			for(auto j: G[i]) if (prev[j] == -1)
				que.emplace(j), prev[j] = i;
		}
	}
	return ans;
} // END HASH
// Matroid where each element has color
// and set is independent iff for each color c
// #{elements of color c} <= maxAllowed[c].
struct LimOracle {
	vi color; // color[i] = color of i-th element
	vi maxAllowed; // Limits for colors
	vi tmp;
	// Init oracle for independent set S; O(n)
	void init(V<bool>& S) {
		tmp = maxAllowed;
		REP(i, ssize(S)) tmp[color[i]] -= S[i];
	}
	// Check if S+{k} is independent; time: O(1)
	bool canAdd(int k) { return tmp[color[k]] > 0;}
};
// Graphic matroid - each element is edge,
// set is independent iff subgraph is acyclic.
struct GraphOracle {
	V<pii> elems; // Ground set: graph edges
	int n; // Number of vertices, indexed [0;n-1]
	vi par;
	int find(int i) {
		return par[i] == -1 ? i : par[i] = find(par[i]);
	}
	// Init oracle for independent set S; ~O(n)
	void init(V<bool>& S) {
		par.assign(n, -1);
		REP(i, ssize(S)) if (S[i])
			par[find(elems[i].fi)] = find(elems[i].se);
	}
	// Check if S+{k} is independent; time: ~O(1)
	bool canAdd(int k) {
		return find(elems[k].fi) != find(elems[k].se);
	}
};
// Co-graphic matroid - each element is edge,
// set is independent iff after removing edges
// from graph number of connected components
// doesn't change.
struct CographOracle {
	V<pii> elems; // Ground set: graph edges
	int n; // Number of vertices, indexed [0;n-1]
	V<vi> G;
	vi pre, low;
	int cnt;

	int dfs(int v, int p) {
		pre[v] = low[v] = ++cnt;
		for(auto e: G[v]) if (e != p)
			low[v] = min(low[v], pre[e] ?: dfs(e,v));
		return low[v];
	}
	// Init oracle for independent set S; O(n)
	void init(V<bool>& S) {
		G.assign(n, {});
		pre.assign(n, 0);
		low.resize(n);
		cnt = 0;
		REP(i,ssize(S)) if (!S[i]) {
			pii e = elems[i];
			G[e.fi].eb(e.se);
			G[e.se].eb(e.fi);
		}
		REP(v, n) if (!pre[v]) dfs(v, -1);
	}
	// Check if S+{k} is independent; time: O(1)
	bool canAdd(int k) {
		pii e = elems[k];
		return max(pre[e.fi], pre[e.se]) != max(low[e.fi], low[e.se]);
	}
};
// Matroid equivalent to linear space with XOR
struct XorOracle {
	vll elems; // Ground set: numbers
	vll base;
	// Init for independent set S; O(n+r^2)
	void init(V<bool>& S) {
		base.assign(63, 0);
		REP(i, ssize(S)) if (S[i]) {
			ll e = elems[i];
			REP(j, ssize(base)) if ((e >> j) & 1) {
				if (!base[j]) {
					base[j] = e;
					break;
				}
				e ^= base[j];
			}
		}
	}
	// Check if S+{k} is independent; time: O(r)
	bool canAdd(int k) {
		ll e = elems[k];
		REP(i, ssize(base)) if ((e >> i) & 1) {
			if (!base[i]) return 1;
			e ^= base[i];
		}
		return 0;
	}
};
