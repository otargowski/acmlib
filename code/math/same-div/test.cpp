#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	auto brute_floor = [&](ll n) -> V<pair<ll, ll>> {
		V<pair<ll, ll>> v;
		for (ll i = 1; i <= n; ++i) {
			ll x = i + 1;
			while (x <= n and n / x == n / i)
				++x;
			v.eb(i, x - 1);
			i = x - 1;
		}
		return v;
	};

	auto brute_ceil = [&](ll n) -> V<pair<ll, ll>> {
		V<pair<ll, ll>> v;
		for (ll i = n; i >= 1; --i) {
			ll x = i - 1;
			while (x >= 1 and (n + x - 1) / x == (n + i - 1) / i)
				--x;
			v.eb(x + 1, i);
			i = x + 1;
		}
		return v;
	};

	C int max_n = rd(0, 1) ? 1e2 : 1e5;
	{ // test same_floor
		int n = rd(1, max_n);
		auto v = same_floor(n);
		auto vbrute = brute_floor(n);
		assert(v == vbrute);
	}

	{ // test same_ceil
		int n = rd(1, max_n);
		auto v = same_ceil(n);
		auto vbrute = brute_ceil(n);
		assert(v == vbrute);
	}
}
