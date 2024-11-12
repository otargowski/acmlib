#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"
auto&operator<<(ostream&o,tuple<auto,auto,auto>t){return o<<"("<<get<0>(t)<<", "<<get<1>(t)<<", "<<get<2>(t)<<")";}

void test() {
	int limit = rd(0, 1e3);
	auto vec = pythagorean_triples(limit);
	debug(limit, vec);

	for (auto [a, b, c] : vec)
		assert(ll(a) * a + ll(b) * b == ll(c) * c);

	set<tuple<int, int, int>> s;
	auto add = [&](int a, int b, int c) {
		assert(s.find({a, b, c}) == s.end());
		s.emplace(a, b, c);
	};
	for (auto [a, b, c] : vec) {
		add(a, b, c);
		add(b, a, c);
	}
	FOR(a, 1, limit) {
		FOR(b, 1, limit) {
			int c = int(sqrt(ll(a) * a + ll(b) * b));
			if (c > limit)
				break;
			if (ll(a) * a + ll(b) * b != ll(c) * c)
				continue;
			if (gcd(gcd(a, b), c) != 1)
				continue;
			assert(s.find({a, b, c}) != s.end());
		}
	}
}
