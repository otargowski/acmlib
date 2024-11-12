/*
 * Opis: Konwersja różnych postaci prostej.
 */
#include "../point/main.cpp"
struct Line {
	D a, b, c;
	// postac ogolna ax + by + c = 0
	Line(D _a, D _b, D _c) : a(_a), b(_b), c(_c) {}
	tuple<D, D, D> get_tuple() { return {a, b, c}; }
	// postac kierunkowa ax + b = y
	Line(D _a, D _b) : a(_a), b(-1), c(_b) {}
	pair<D, D> get_dir() { return {- a / b, - c / b}; }
	// prosta pq
	Line(P p, P q) {
		assert(not equal(p, q));
		if(not equal(p.x(), q.x())) {
			a = (q.y() - p.y()) / (p.x() - q.x());
			b = 1, c = -(a * p.x() + b * p.y());
		}
		else a = 1, b = 0, c = -p.x();
	}
	pair<P, P> get_pts() {
		if(!equal(b, 0)) return { P(0, - c / b), P(1, - (a + c) / b) };
		return { P(- c / a, 0), P(- c / a, 1) };
	}
	D directed_dist(P p) {
		return (a * p.x() + b * p.y() + c) / sqrt(a * a + b * b);
	}
	D dist(P p) {
		return abs(directed_dist(p));
	}
};
