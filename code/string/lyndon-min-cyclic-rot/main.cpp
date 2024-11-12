/*
 * Opis: O(n), wyznaczanie faktoryzacji Lyndona oraz (przy jej pomocy) minimalnego suffixu oraz minimalnego przesunięcia cyklicznego.
 * Ta faktoryzacja to unikalny podział słowa $s$ na $w_1w_2\ldots w_k$, że $w_1\ge w_2\ge \ldots \ge w_k$
 * oraz $w_i$ jest ściśle mniejsze od każdego jego suffixu.
 * \texttt{duval("abacaba") == \{\{0, 3\}, \{4, 5\}, \{6, 6\}\}},
 * \texttt{min\_suffix("abacab") == "ab"},
 * \texttt{min\_cyclic\_shift("abacaba") == "aabacab"}.
 */
V<pair<int, int>> duval(V<int> s) {
	int n = ssize(s), i = 0;
	V<pair<int, int>> ret;
	while(i < n) {
		int j = i + 1, k = i;
		while(j < n and s[k] <= s[j]) {
			k = (s[k] < s[j] ? i : k + 1);
			++j;
		}
		while(i <= k) {
			ret.emplace_back(i, i + j - k - 1);
			i += j - k;
		}
	}
	return ret;
}
V<int> min_suffix(V<int> s) {
	return {s.begin() + duval(s).back().first, s.end()};
}
V<int> min_cyclic_shift(V<int> s) {
	int n = ssize(s);
	REP(i, n)
		s.emplace_back(s[i]);
	for(auto [l, r] : duval(s))
		if(n <= r) {
			return {s.begin() + l, s.begin() + l + n};
		}
	assert(false);
}
