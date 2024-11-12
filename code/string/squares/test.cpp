#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

V<pii> ranges_of_values(vi in) {
	if(in.empty())
		return {};
	V<pii> ret = {{in[0], in[0]}};
	FOR(i, 1, ssize(in) - 1)
		if(in[i] == in[i - 1] + 1)
			ret.back().se += 1;
		else
			ret.eb(in[i], in[i]);
	return ret;
}

V<tuple<int, int, int>> brute_squares(vi str) {
	int n = ssize(str);
	V<tuple<int, int, int>> ret;
	FOR(len, 1, n / 2) {
		vi good_starts;
		REP(start, n - 2 * len + 1) {
			vi substr;
			REP(i, 2 * len)
				substr.eb(str[i + start]);
			bool valid = true;
			REP(i, len)
				if(substr[i] != substr[i + len])
					valid = false;
			if(valid)
				good_starts.eb(start);
		}
		for(auto [l, r] : ranges_of_values(good_starts))
			ret.eb(l, r, len);
	}
	return ret;
}

void test() {
	static bool was_maxtest = false;
	int n = was_maxtest ? rd(1, 10) : int(1e5);
	vi s;
	REP(i, n)
		s.eb(rd(0, 2));
	debug(n, s);

	auto wzorc = squares(s);
	if(was_maxtest) {
		auto brute = brute_squares(s);
		sort(all(brute));
		sort(all(wzorc));
		assert(brute == wzorc);
	}
	was_maxtest = true;
}
