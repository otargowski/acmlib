#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	int n = rd(1, 30);
	int r = rd(1, 26);
	vi s(n);
	for (auto& x : s)
		x = rd(0, r - 1);

	int m = rd(1, n + 1);
	vi t;
	if(m <= n and rd(0, 1)) {
		int l = rd(0, n - m);
		REP(i, m)
			t.eb(s[l + i]);
	}
	else {
		t.resize(m);
		for (auto& x : t)
			x = rd(0, r - 1);
	}

	auto [sa, _] = suffix_array(s);

	auto get_t_lcp = [&](int i) -> int {
		REP(k, ssize(t))
			if(i + k >= n)
				return k;
			else if(s[i + k] != t[k])
				return k;
		return ssize(t);
	};

	vi good_positions;
	REP(i, ssize(sa))
		if(get_t_lcp(sa[i]) == ssize(t))
			good_positions.eb(i);
	debug(n, s, t, sa, good_positions);
	REP(i, ssize(good_positions) - 1)
		assert(good_positions[i] + 1 == good_positions[i + 1]);

	auto [found_l, found_r] = get_substring_sa_range(s, sa, t);
	debug(found_l, found_r);
	if(good_positions.empty())
		assert(found_l == -1 and found_r == -1);
	else
		assert(found_l == good_positions.front() and found_r == good_positions.back());
}
