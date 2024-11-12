/*
 * Opis: O(n), wyznaczanie cykli w grafie. Zakłada że jest nieskierowany graf bez pętelek i multikrawędzi,
 *   każda krawędź leży na co najwyżej jednym cyklu prostym (silniejsze założenie, niż o wierzchołkach).
 *   \texttt{cactus\_cycles(graph)} zwraca taką listę cykli, że istnieje krawędź między $i$-tym, a $(i+1) \text{mod} \text{ssize(cycle)}$-tym wierzchołkiem.
 */
V<V<int>> cactus_cycles(V<V<int>> graph) {
	V<int> state(ssize(graph), 0), stack;
	V<V<int>> ret;
	function<void (int, int)> dfs = [&](int v, int p) {
		if(state[v] == 2) {
			ret.eb(stack.rbegin(), find(rall(stack), v) + 1);
			return;
		}
		stack.eb(v);
		state[v] = 2;
		for(int u : graph[v])
			if(u != p and state[u] != 1)
				dfs(u, v);
		state[v] = 1;
		stack.pop_back();
	};
	REP(i, ssize(graph))
		if (!state[i])
			dfs(i, -1);
	return ret;
}
