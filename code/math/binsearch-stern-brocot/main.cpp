/*
 * Opis: O(\log max\_val), szuka największego \texttt{a/b}, że \texttt{is\_ok(a/b)} oraz \texttt{0 <= a,b <= max\_value}.
 * Zakłada, że \texttt{is\_ok(0) == true}.
 */
using Frac = pair<ll, ll>;
Frac my_max(Frac l, Frac r) {
	return l.fi * __int128_t(r.se) > r.fi * __int128_t(l.se) ? l : r;
}
Frac binsearch(ll max_value, function<bool (Frac)> is_ok) {
	assert(is_ok(pair(0, 1)) == true);
	Frac left = {0, 1}, right = {1, 0}, best_found = left;
	int current_dir = 0;
	while(max(left.fi, left.se) <= max_value) {
		best_found = my_max(best_found, left);
		auto get_frac = [&](ll mul) {
			ll mull = current_dir ? 1 : mul;
			ll mulr = current_dir ? mul : 1;
			return pair(left.fi * mull + right.fi * mulr, left.se * mull + right.se * mulr);
		};
		auto is_good_mul = [&](ll mul) {
			Frac mid = get_frac(mul);
			return is_ok(mid) == current_dir and max(mid.fi, mid.se) <= max_value;
		};
		ll power = 1;
		for(; is_good_mul(power); power *= 2) {}
		ll bl = power / 2 + 1, br = power;
		while(bl != br) {
			ll bm = (bl + br) / 2;
			if(not is_good_mul(bm))
				br = bm;
			else
				bl = bm + 1;
		}
		tie(left, right) = pair(get_frac(bl - 1), get_frac(bl));
		if(current_dir == 0)
			swap(left, right);
		current_dir ^= 1;
	}
	return best_found;
}
