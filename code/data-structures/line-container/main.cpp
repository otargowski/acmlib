/*
 * Opis: O(\log n) set dla funkcji liniowych,
 *   \texttt{add(a, b)} dodaje funkcję $y = ax + b$
 *   \texttt{query(x)} zwraca największe $y$ w punkcie $x$.
 */
struct Line {
	mutable ll a, b, p;
	ll eval(ll x) C { return a * x + b; }
	bool operator<(C Line & o) C { return a < o.a; }
	bool operator<(ll x) C { return p < x; }
};
struct LineContainer : multiset<Line, less<>> {
	// jak double to inf = 1 / .0, div(a, b) = a / b
	C ll inf = LLONG_MAX;
	ll div(ll a, ll b) { return a / b - ((a ^ b) < 0 && a % b); }
	bool intersect(iterator x, iterator y) {
		if(y == end()) { x->p = inf; return false; }
		if(x->a == y->a) x->p = x->b > y->b ? inf : -inf;
		else x->p = div(y->b - x->b, x->a - y->a);
		return x->p >= y->p;
	}
	void add(ll a, ll b) {
		auto z = insert({a, b, 0}), y = z++, x = y;
		while(intersect(y, z)) z = erase(z);
		if(x != begin() && intersect(--x, y))
			intersect(x, erase(y));
		while((y = x) != begin() && (--x)->p >= y->p)
			intersect(x, erase(y));
	}
	ll query(ll x) {
		assert(!empty());
		return lower_bound(x)->eval(x);
	}
};
