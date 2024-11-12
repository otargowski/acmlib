#include "../point/before_bits.cpp"
#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

void test() {
	P p0(rd(-10, 10), rd(-10, 10));
	P p1(rd(-10, 10), rd(-10, 10));
	D r0 = rd(0, 10);
	D r1 = rd(0, 10);
	bool inside = rd(0, 1);
	debug(p0, p1, r0, r1, inside);

	V got = circle_tangents(p0, r0, p1, r1, inside);
	debug(got);

	int sgn = sign(dist(p0, p1) - (inside ? r0 + r1 : abs(r0 - r1)));
	debug(sgn);
	if(equal(p0, p1))
		assert(got.empty());
	else
		assert(ssize(got) == 1 + sgn);

	if(ssize(got) == 1) {
		assert(equal(got[0].fi, got[0].se));
		assert(dir(p0, p1, got[0].fi) == 0 and 
				equal(dist(p0, got[0].fi), r0) and 
				equal(dist(p1, got[0].fi), r1));
	}
	else if(ssize(got) == 2) {
		for(int d : {0, 1}) {
			assert(equal(dist(p0, got[d].fi), r0));
			assert(equal(dist(p1, got[d].se), r1));
			assert(equal(dot(p0 - got[d].fi, got[d].fi - got[d].se), 0));
			assert(equal(dot(p1 - got[d].se, got[d].fi - got[d].se), 0));
		}

		if(equal(r0, 0))
			assert(equal(got[0].fi, got[1].fi));
		if(equal(r1, 0))
			assert(equal(got[0].se, got[1].se));
	}
}
