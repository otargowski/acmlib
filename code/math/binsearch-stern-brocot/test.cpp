#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	ll max_value = rd(0, 1) ? ll(1e1) : rd(0, 1) ? ll(4e2) : ll(1e18);
	long double ld = uniform_real_distribution<long double>(0, max_value + 1)(rng);
	debug(max_value, ld);
	auto is_good = [&](pair<ll, ll> p) {
		assert(p.se > 0);
		assert(p.fi >= 0);
		return p.fi / (long double)(p.se) <= ld;
	};
	pair<ll, ll> found = binsearch(max_value, is_good);

	if(max_value == ll(1e18))
		return;

	V<pair<ll, ll>> possible;
	FOR(a, 0, max_value)
		FOR(b, 1, max_value)
			if(is_good(pair(a, b)) and __gcd(a, b) == 1)
				possible.eb(pair(a, b));
	sort(all(possible), [&](pair<ll, ll> l, pair<ll, ll> r) {
		return l.fi / (long double)(l.se) < r.fi / (long double)(r.se);
	});
	pair<ll, ll> best = possible.back();
	debug(best, found);
	assert(best == found);
	assert(__gcd(found.fi, found.se) == 1);
	assert(found.fi >= 0 and found.se > 0);
}
