#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

bool is_border(vi s, int len) {
	if(len >= ssize(s))
		return false;
	if(len == 0)
		return true;
	return V(s.begin(), s.begin() + len) == V(s.begin() + ssize(s) - len, s.end());
}

void test() {
	int n = rd(1, 20);
	vi s;
	REP(i, n)
		s.eb(rd(0, 2));

	V kmp = get_kmp(s);
	REP(i, n) {
		int found_len = 0;
		for(int len = i; len >= 0; --len)
			if(is_border(V(s.begin(), s.begin() + i + 1), len)) {
				found_len = len;
				break;
			}
		assert(kmp[i] == found_len);
	}
	vi borders;
	FOR(len, 1, n)
		if(len == n or is_border(s, len))
			borders.eb(len);
	assert(borders == get_borders(s));
}
