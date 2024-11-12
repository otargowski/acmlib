#include "../point/before_bits.cpp"
#include <bits/stdc++.h>
using namespace std;
ostream& operator<<(ostream &o, __int128 x) {
	return o << (long long)(x);
}
#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"
#include "../convex-hull/main.cpp"
#include "../../math/bignum/main.cpp"

using Frac = pair<Num, Num>;
using PInt = pii;
using PFrac = pair<Frac, Frac>;
using HalfplanePInt = pair<PInt, PInt>; // (punkt p, V pq)

ll crossPInt(PInt l, PInt r) {
	return l.fi * ll(r.se) - l.se * ll(r.fi);
}

Frac to_frac(int x) {
	return {x, 1};
}
PFrac to_pfrac(PInt p) {
	return {to_frac(p.fi), to_frac(p.se)};
}
Frac mul(int x, Frac y) {
	return {y.fi * x, y.se};
}
Frac add(Frac l, Frac r) {
	return {l.fi * r.se + l.se * r.fi, l.se * r.se};
}
PFrac add_pfrac(PFrac l, PFrac r) {
	return {add(l.fi, r.fi), add(l.se, r.se)};
}
Frac neg(Frac x) {
	return {-x.fi, x.se};
}
PFrac sub_pfrac(PFrac l, PFrac r) {
	return {add(l.fi, neg(r.fi)), add(l.se, neg(r.se))};
}
Frac mul_frac(Frac l, Frac r) {
	return {l.fi * r.fi, l.se * r.se};
}
PFrac mul_pfrac(PFrac l, Frac r) {
	return {mul_frac(l.fi, r), mul_frac(l.se, r)};
}
Frac crossPFrac(PFrac l, PFrac r) {
	return add(mul_frac(l.fi, r.se), neg(mul_frac(l.se, r.fi)));
}

bool is_outside(HalfplanePInt hi, PFrac p) {
	// return cross(hi.se, p - hi.fi) < 0;
	PFrac l = to_pfrac(hi.se);
	PFrac r = sub_pfrac(p, to_pfrac(hi.fi));
	Frac prod = crossPFrac(l, r);
	return prod.fi.sign * prod.se.sign < 0;
}

D num_to_d(Num n) {
	D d = 0;
	for(int x : V(rall(n.x)))
		d = n.base * d + x;
	d *= n.sign;
	return d;
}
D to_d(Frac f) {
	return num_to_d(f.fi) / num_to_d(f.se);
}
P to_p(PFrac f) {
	return {to_d(f.fi), to_d(f.se)};
}

PInt sub_PInt(PInt l, PInt r) {
	return {l.fi - r.fi, l.se - r.se};
}

V<P> brute_halfplane(V<HalfplanePInt> h) {
	V<P> potential;
	for(HalfplanePInt s : h)
		for(HalfplanePInt t : h)
			if(crossPInt(s.se, t.se) != 0) {
				Frac alpha = {crossPInt(sub_PInt(t.fi, s.fi), t.se),
					crossPInt(s.se, t.se)
				};
				PFrac inte = add_pfrac(to_pfrac(s.fi), mul_pfrac(to_pfrac(s.se), alpha));

				bool is_good = true;
				for(HalfplanePInt hi : h)
					if(is_outside(hi, inte)) {
						is_good = false;
						break;
					}
				if(is_good)
					potential.eb(to_p(inte));
			}

	V<P> got_hull = hull(potential);
	return got_hull;
}

void test() {
	const int n = rd(0, 10);
	V<Halfplane> in;
	V<HalfplanePInt> inPInt;
	for(int i = 0; i < 4; ++i) {
		constexpr D inf = 1e5;
		array box = {P(-inf, -inf), P(inf, -inf), P(inf, inf), P(-inf, inf)};
		array boxPInt = {PInt(-inf, -inf), PInt(inf, -inf), PInt(inf, inf), PInt(-inf, inf)};
		in.eb(box[i], box[(i + 1) % 4]);
		inPInt.eb(boxPInt[i], sub_PInt(boxPInt[(i + 1) % 4], boxPInt[i]));
	}
	const int lg = rd(0, 30);
	const int mx = 1 << lg;
	auto get_random_p = [&] {
		return PInt(rd(-mx, mx), rd(-mx, mx));
	};
	REP(i, n) {
		PInt a, b;
		while(true) {
			a = get_random_p();
			b = get_random_p();
			if(a != b)
				break;
		}
		in.eb(P(a.fi, a.se), P(b.fi, b.se));
		inPInt.eb(a, sub_PInt(b, a));
	}
	debug(in);
	auto ans_main = halfplane_intersection(in);
	auto ans_brute = brute_halfplane(inPInt);
	debug(ans_main, ans_brute);
	sort(all(ans_main));
	sort(all(ans_brute));
	ans_brute.erase(unique(all(ans_brute), [&](P l, P r) { return equal(l, r); }), ans_brute.end());
	assert(ssize(ans_main) == ssize(ans_brute));
	REP(i, ssize(ans_main))
		assert(equal(ans_main[i], ans_brute[i]));
}
