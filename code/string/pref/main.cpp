/*
 * Opis: O(n), zwraca tablicę prefixo prefixową $[0, pref[i]) = [i, i + pref[i])$.
 */
vi pref(vi str) {
	int n = ssize(str);
	vi ret(n);
	ret[0] = n;
	int i = 1, m = 0;
	while(i < n) {
		while(m + i < n and str[m + i] == str[m])
			m++;
		ret[i++] = m;
		m = max(0, m - 1);
		for(int j = 1; ret[j] < m; m--)
			ret[i++] = ret[j++];
	}
	return ret;
}
