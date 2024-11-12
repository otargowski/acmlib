/*
 * Opis: O(m \log n), dla korzenia i listy krawędzi skierowanych ważonych
 * zwraca najtańszy podzbiór $n-1$ krawędzi taki, że
 * z korzenia istnieje ścieżka do każdego innego wierzchołka, lub $-1$ gdy nie ma.
 * Zwraca (koszt, ojciec każdego wierzchołka w zwróconym drzewie).
 */
struct RollbackUF {
	V<int> e; V<pii> st;
	RollbackUF(int n) : e(n, -1) {}
	int size(int x) { return -e[find(x)]; }
	int find(int x) { return e[x] < 0 ? x : find(e[x]); }
	int time() { return ssize(st); }
	void rollback(int t) {
		for(int i = time(); i --> t;)
			e[st[i].first] = st[i].second;
		st.resize(t);
	}
	bool join(int a, int b) {
		a = find(a), b = find(b);
		if(a == b) return false;
		if(e[a] > e[b]) swap(a, b);
		st.push_back({a, e[a]});
		st.push_back({b, e[b]});
		e[a] += e[b]; e[b] = a;
		return true;
	}
};
struct Edge { int a, b; ll w; };
struct Node {
	Edge key;
	Node *l = 0, *r = 0;
	ll delta = 0;
	void prop() {
		key.w += delta;
		if(l) l->delta += delta;
		if(r) r->delta += delta;
		delta = 0;
	}
};
Node* merge(Node *a, Node *b) {
	if(!a || !b) return a ?: b;
	a->prop(), b->prop();
	if(a->key.w > b->key.w) swap(a, b);
	swap(a->l, (a->r = merge(b, a->r)));
	return a;
}
pair<ll, V<int>> directed_mst(int n, int r, V<Edge> &g) {
	RollbackUF uf(n);
	V<Node*> heap(n);
	V<Node> pool(ssize(g));
	REP(i, ssize(g)) {
		Edge e = g[i];
		heap[e.b] = merge(heap[e.b], &(pool[i] = Node{e}));
	}
	ll res = 0;
	V<int> seen(n, -1), path(n), par(n);
	seen[r] = r;
	V<Edge> Q(n), in(n, {-1, -1, 0}), comp;
	deque<tuple<int, int, V<Edge>>> cycs;
	REP(s, n) {
		int u = s, qi = 0, w;
		while(seen[u] < 0) {
			Node *&hu = heap[u];
			if(!hu) return {-1, {}};
			hu->prop();
			Edge e = hu->key;
			hu->delta -= e.w; hu->prop(); hu = merge(hu->l, hu->r);
			Q[qi] = e, path[qi++] = u, seen[u] = s;
			res += e.w, u = uf.find(e.a);
			if(seen[u] == s) { /// found cycle, contract
				Node *c = 0;
	 			int end = qi, time = uf.time();
				do c = merge(c, heap[w = path[--qi]]);
				while(uf.join(u, w));
				u = uf.find(u), heap[u] = c, seen[u] = -1;
				cycs.push_front({u, time, {&Q[qi], &Q[end]}});
			}
		}
		REP(i,qi) in[uf.find(Q[i].b)] = Q[i];
	}
	for(auto [u, t, c] : cycs) { // restore sol (optional)
		uf.rollback(t);
		Edge inu = in[u];
		for(auto e : c) in[uf.find(e.b)] = e;
		in[uf.find(inu.b)] = inu;
	}
	REP(i, n) par[i] = in[i].a;
	return {res, par};
}
