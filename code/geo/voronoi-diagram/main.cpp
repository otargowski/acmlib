/*
 * Opis: O(n \log n), dla każdego punktu zwraca odpowiadającą
 * mu ścianę będącą otoczką wypukłą.
 * Suma otoczek w całości zawiera kwadrat (-mx, mx) -- (mx, mx),
 * ale może zawierać więcej. Współrzędne ścian mogą być kilka
 * rządów wielkości większe niż te na wejściu.
 * Max abs wartości współrzędnych to 3e8.
 */
#include "../delaunay-triangulation/main.cpp"
#include "../convex-hull/main.cpp"
using Frac = pair<__int128_t, __int128_t>;
D to_d(Frac f) { return D(f.fi) / D(f.se); }
Frac create_frac(__int128_t a, __int128_t b) {
	assert(b != 0);
	if(b < 0) a *= -1, b *= -1;
	__int128_t d = __gcd(a, b);
	return {a / d, b / d};
}
using P128 = pair<Frac, Frac>;
ll sq(int x) { return x * ll(x); }
__int128_t dist128(PI p) { return sq(p.fi) + sq(p.se); }
pair<Frac, Frac> calc_mid(PI a, PI b, PI c) {
	__int128_t ux = dist128(a) * (b.se - c.se)
		+ dist128(b) * (c.se - a.se) 
		+ dist128(c) * (a.se - b.se),
		uy = dist128(a) * (c.fi - b.fi)
		+ dist128(b) * (a.fi - c.fi)
		+ dist128(c) * (b.fi - a.fi),
		d = 2 * (a.fi * ll(b.se - c.se)
		+ b.fi * ll(c.se - a.se)
		+ c.fi * ll(a.se - b.se));
	return {create_frac(ux, d), create_frac(uy, d)};
}
V<V<P>> voronoi_faces(V<PI> in, const int max_xy = int(3e8)) {
	int n = ssize(in);
	map<PI, int> id_of_in;
	REP(i, n)
		id_of_in[in[i]] = i;
	for(int sx : {-1, 1})
		for(int sy : {-1, 1}) {
			int mx = 3 * max_xy + 100;
			in.eb(mx * sx, mx * sy);
		}
	V<PI> triangles = triangulate(in);
	debug(triangles);
	assert(not triangles.empty());
	int tn = ssize(triangles) / 3;
	V<P128> mids(tn);
	map<pair<PI, PI>, V<P128>> on_sides;
	REP(i, tn) {
		array<PI, 3> ps = {triangles[3 * i], triangles[3 * i + 1], triangles[3 * i + 2]};
		mids[i] = calc_mid(ps[0], ps[1], ps[2]);
		REP(j, 3) {
			PI a = ps[j], b = ps[(j + 1) % 3];
			on_sides[pair(min(a, b), max(a, b))].eb(mids[i]);
		}
	}
	V<V<P128>> faces128(n);
	for(auto [edge, sides] : on_sides)
		if(ssize(sides) == 2)
			for(PI e : {edge.fi, edge.se})
				if(id_of_in.find(e) != id_of_in.end())
					for(auto m : sides)
						faces128[id_of_in[e]].eb(m);
	V<V<P>> faces(n);
	REP(i, ssize(faces128)) {
		auto &f = faces128[i];
		sort(all(f));
		f.erase(unique(all(f)), f.end());
		for(auto [x, y] : f)
			faces[i].eb(to_d(x), to_d(y));
		faces[i] = hull(faces[i]);
	}
	return faces;
}
