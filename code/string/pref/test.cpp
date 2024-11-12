#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

V<int> brute_pref(V<int> str) {
	int n = ssize(str);
	V<int> ret(n);
	REP(i, n) {
		int len = 0;
		while(i + len < n and str[i + len] == str[len])
			++len;
		ret[i] = len;
	}
	return ret;
}

void test() {
	int n = rd(1, 10);
	V<int> s;
	REP(i, n)
		s.eb(rd(0, 2));
	assert(brute_pref(s) == pref(s));
}
