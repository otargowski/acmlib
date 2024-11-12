/*
 * Opis: O(n + alpha),
 * $sa$ zawiera posortowane suffixy, zawiera pusty suffix,
 * $lcp[i]$ to $lcp$ suffixu $sa[i]$ i $sa[i + 1]$,
 * Dla \texttt{s = aabaaab}, \texttt{sa=\{7,3,4,0,5,1,6,2\},lcp=\{0,2,3,1,2,0,1\}}
 */
// BEGIN HASH
void induced_sort(C vi &vec, int alpha, vi &sa,
		C V<bool> &sl, C vi &lms_idx) {
	vi l(alpha), r(alpha);
	for (int c : vec) {
		if (c + 1 < alpha)
			++l[c + 1];
		++r[c];
	}
	partial_sum(all(l), l.begin());
	partial_sum(all(r), r.begin());
	fill(all(sa), -1);
	for (int i = ssize(lms_idx) - 1; i >= 0; --i)
		sa[--r[vec[lms_idx[i]]]] = lms_idx[i];
	for (int i : sa)
		if (i >= 1 and sl[i - 1])
			sa[l[vec[i - 1]]++] = i - 1;
	fill(all(r), 0);
	for (int c : vec)
		++r[c];
	partial_sum(all(r), r.begin());
	for (int k = ssize(sa) - 1, i = sa[k]; k >= 1; --k, i = sa[k])
		if (i >= 1 and not sl[i - 1])
			sa[--r[vec[i - 1]]] = i - 1;
}
vi sa_is(C vi &vec, int alpha) {
	C int n = ssize(vec);
	vi sa(n), lms_idx;
	V<bool> sl(n);
	for (int i = n - 2; i >= 0; --i) {
		sl[i] = vec[i] > vec[i + 1] or (vec[i] == vec[i + 1] and sl[i + 1]);
		if (sl[i] and not sl[i + 1])
			lms_idx.eb(i + 1);
	}
	reverse(all(lms_idx));
	induced_sort(vec, alpha, sa, sl, lms_idx);
	vi new_lms_idx(ssize(lms_idx)), lms_vec(ssize(lms_idx));
	for (int i = 0, k = 0; i < n; ++i)
		if (not sl[sa[i]] and sa[i] >= 1 and sl[sa[i] - 1])
			new_lms_idx[k++] = sa[i];
	int cur = sa[n - 1] = 0;
	REP (k, ssize(new_lms_idx) - 1) {
		int i = new_lms_idx[k], j = new_lms_idx[k + 1];
		if (vec[i] != vec[j]) {
			sa[j] = ++cur;
			continue;
		}
		bool flag = false;
		for (int a = i + 1, b = j + 1;; ++a, ++b) {
			if (vec[a] != vec[b]) {
				flag = true;
				break;
			}
			if ((not sl[a] and sl[a - 1]) or (not sl[b] and sl[b - 1])) {
				flag = not (not sl[a] and sl[a - 1] and not sl[b] and sl[b - 1]);
				break;
			}
		}
		sa[j] = (flag ? ++cur : cur);
	}
	REP (i, ssize(lms_idx))
		lms_vec[i] = sa[lms_idx[i]];
	if (cur + 1 < ssize(lms_idx)) {
		vi lms_sa = sa_is(lms_vec, cur + 1);
		REP (i, ssize(lms_idx))
			new_lms_idx[i] = lms_idx[lms_sa[i]];
	}
	induced_sort(vec, alpha, sa, sl, new_lms_idx);
	return sa;
}
vi suffix_array(C vi &s, int alpha) {
	vi vec(ssize(s) + 1);
	REP(i, ssize(s))
		vec[i] = s[i] + 1;
	vi ret = sa_is(vec, alpha + 2);
	return ret;
} // END HASH
vi get_lcp(C vi &s, C vi &sa) {
	int n = ssize(s), k = 0;
	vi lcp(n), rank(n);
	REP (i, n)
		rank[sa[i + 1]] = i;
	for (int i = 0; i < n; i++, k ? k-- : 0) {
		if (rank[i] == n - 1) {
			k = 0;
			continue;
		}
		int j = sa[rank[i] + 2];
		while (i + k < n and j + k < n and s[i + k] == s[j + k])
			k++;
		lcp[rank[i]] = k;
	}
	lcp.pop_back();
	lcp.insert(lcp.begin(), 0);
	return lcp;
}
