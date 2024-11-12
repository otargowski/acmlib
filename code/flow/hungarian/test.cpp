#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	int test_type = (rd(0, 100) > 0 ? 0 : 1);
	int max_n = (test_type == 0 ? 7 : 100);
	int n0 = rd(1, max_n);
	int n1 = rd(1, max_n);
	if(n0 > n1)
		swap(n0, n1);
	int max_weight = (rd(0, 1) ? 10 : int(1e9));
	V<vi> weight(n0, vi(n1));
	REP(i, n0)
		REP(j, n1)
			weight[i][j] = rd(-max_weight, max_weight);

	auto [ans, match] = hungarian(weight);
	V<bool> used_in_m(n1, false);
	for(int i : match) {
		assert(not used_in_m[i]);
		used_in_m[i] = true;
	}
	ll ans_check = 0;
	REP(i, n0)
		ans_check += weight[i][match[i]];
	assert(ans == ans_check);

	if(test_type == 0) {
		ll ans_brute = ll(1e18);
		vi perm(n1);
		iota(all(perm), 0);
		do {
			vi brute_match = perm;
			brute_match.resize(n0);
			ll ans_local = 0;
			REP(i, n0)
				ans_local += weight[i][brute_match[i]];
			ans_brute = min(ans_brute, ans_local);
		} while(next_permutation(all(perm)));
		assert(ans == ans_brute);
	}
}
