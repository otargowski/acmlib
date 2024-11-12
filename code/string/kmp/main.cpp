/*
 * Opis: O(n),
 *   zachodzi [0, pi[i]) = (i - pi[i], i].
 *   \texttt{get\_kmp(\{0,1,0,0,1,0,1,0,0,1\}) == \{0,0,1,1,2,3,2,3,4,5\}},
 *   \texttt{get\_borders(\{0,1,0,0,1,0,1,0,0,1\}) == \{2,5,10\}}.
 */
// BEGIN HASH
vi get_kmp(vi str) {
	int len = ssize(str);
	vi ret(len);
	for(int i = 1; i < len; i++) {
		int pos = ret[i - 1];
		while(pos and str[i] != str[pos])
			pos = ret[pos - 1];
		ret[i] = pos + (str[i] == str[pos]);
	}
	return ret;
} // END HASH
vi get_borders(vi str) {
	vi kmp = get_kmp(str), ret;
	int len = ssize(str);
	while(len) {
		ret.eb(len);
		len = kmp[len - 1];
	}
	return vi(rall(ret));
}
