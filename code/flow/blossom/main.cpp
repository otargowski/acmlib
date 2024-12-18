/*
 * Opis: Jeden rabin powie O(nm), drugi rabin powie, że to nawet nie jest O(n^3).
 *   W grafie nie może być pętelek.
 *   Funkcja zwraca match'a, tzn \texttt{match[v] == -1} albo z kim jest sparowany $v$.
 *   Rozmiar matchingu to $\frac{1}{2}\sum_v \texttt{int(match[v] != -1)}$.
 */
vi blossom(V<vi> graph) {
	int n = ssize(graph), timer = -1;
	REP(v, n)
		for(int u : graph[v])
			assert(v != u);
	vi match(n, -1), label(n), parent(n), orig(n), aux(n, -1), q;
	auto lca = [&](int x, int y) {
		for(++timer; ; swap(x, y)) {
			if(x == -1)
				continue;
			if(aux[x] == timer)
				return x;
			aux[x] = timer;
			x = (match[x] == -1 ? -1 : orig[parent[match[x]]]);
		}
	};
	auto blossom = [&](int v, int w, int a) {
		while(orig[v] != a) {
			parent[v] = w;
			w = match[v];
			if(label[w] == 1) {
				label[w] = 0;
				q.eb(w);
			}
			orig[v] = orig[w] = a;
			v = parent[w];
		}
	};
	auto augment = [&](int v) {
		while(v != -1) {
			int pv = parent[v], nv = match[pv];
			match[v] = pv;
			match[pv] = v;
			v = nv;
		}
	};
	auto bfs = [&](int root) {
		fill(all(label), -1);
		iota(all(orig), 0);
		label[root] = 0;
		q = {root};
		REP(i, ssize(q)) {
			int v = q[i];
			for(int x : graph[v])
				if(label[x] == -1) {
					label[x] = 1;
					parent[x] = v;
					if(match[x] == -1) {
						augment(x);
						return 1;
					}
					label[match[x]] = 0;
					q.eb(match[x]);
				}
				else if(label[x] == 0 and orig[v] != orig[x]) {
					int a = lca(orig[v], orig[x]);
					blossom(x, v, a);
					blossom(v, x, a);
				}
		}
		return 0;
	};
	REP(i, n)
		if(match[i] == -1)
			bfs(i);
	return match;
}
