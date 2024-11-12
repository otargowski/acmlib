#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	{ // factor test
		auto f = [&](ll n) {
			vll v;
			for (ll d = 2; d * d <= n; ++d) {
				while (n % d == 0) {
					n /= d;
					v.eb(d);
				}
			}
			if (n > 1) v.eb(n);
			return v;
		};
		ll mn = (1ll << 40);
		ll n = rd_ll(1, mn);
		auto vrho = factor(n);
		sort(all(vrho));
		auto vbrute = f(n);
		sort(all(vbrute));
		assert(vrho == vbrute);
	}
	{ // get_pairs test
		auto f = [&](ll n) {
			V<pair<ll, int>> v;
			for (ll d = 2; d * d <= n; ++d) {
				int cnt = 0;
				if (n % d == 0) {
					while (n % d == 0) {
						n /= d;
						++cnt;
					}
					v.eb(d, cnt);
				}
			}
			if (n > 1) v.eb(n, 1);
			return v;
		};
		ll mn = (1ll << 40);
		ll n = rd_ll(1, mn);
		auto vrho = get_pairs(n);
		auto vbrute = f(n);
		assert(vrho == vbrute);
	}
	{ // all_factors test
		auto f = [&](ll n) {
			vll v;
			for (ll d = 1; d * d <= n; ++d) {
				if (n % d == 0) {
					v.eb(d);
					if (d != n / d)
						v.eb(n / d);
				}
			}
			return v;
		};
		ll mn = (1ll << 40);
		ll n = rd_ll(1, mn);
		auto vrho = all_factors(n);
		sort(all(vrho));
		auto vbrute = f(n);
		sort(all(vbrute));
		assert(vrho == vbrute);
	}
}
