/*
 * Opis: Struktura do działań modulo
 * Ustaw modulo w ostatniej linii. Jeśli modulo nie jest C, usuń pierwszy wiersz i zadeklaruj mod.
 */
template<int mod>
struct modular {
	int val;
	modular() { val = 0; }
	modular(C ll& v) {
		val = int((-mod <= v && v < mod) ? (int) v : v % mod);
		if(val < 0) val += mod;
	}
	int to_int() { return val; }
	friend ostream& operator<<(ostream &os, C modular &a) {
#ifdef DEBUG
		constexpr int mx = 1024;
		for(int y = 1; y <= mx; ++y)
			if(a * y <= mx)
				return os << (a * y).val << '/' << y;
			else if(mod - a * y <= mx)
				return os << '-' << (mod - a * y).val << '/' << y;
#endif
		return os << a.val;
	}
	friend istream& operator>>(istream &is, modular &a) {
		return is >> a.val;
	}
	friend bool operator==(C modular &a, C modular &b) {
		return a.val == b.val;
	}
	friend bool operator!=(C modular &a, C modular &b) {
		return !(a == b);
	}
	friend bool operator<(C modular &a, C modular &b) {
		return a.val < b.val;
	}
	friend bool operator<=(C modular &a, C modular &b) {
		return a.val <= b.val;
	}
	modular operator-() C { return modular(-val); }
	modular& operator+=(C modular &m) {
		if((val += m.val) >= mod) val -= mod;
		return *this;
	}
	modular& operator-=(C modular &m) {
		if((val -= m.val) < 0) val += mod;
		return *this;
	}
	modular& operator*=(C modular &m) {
		val = int((ll) val * m.val % mod);
		return *this;
	}
	friend modular qpow(modular a, ll n) {
		if(n == 0) return 1;
		if(n % 2 == 1) return qpow(a, n - 1) * a;
		return qpow(a * a, n / 2);
	}
	friend modular inv(C modular &a) {
		assert(a != 0); return qpow(a, mod - 2);
	}
	modular& operator/=(C modular &m) {
		return (*this) *= inv(m);
	}
	modular operator++(int) {
		modular res = (*this);
		(*this) += 1;
		return res;
	}
	friend modular operator+(modular a, C modular &b) { return a += b; }
	friend modular operator-(modular a, C modular &b) { return a -= b; }
	friend modular operator*(modular a, C modular &b) { return a *= b; }
	friend modular operator/(modular a, C modular &b) { return a /= b; }
};
using mint = modular<int(1e9 + 7)>;
// using mint = modular<998244353>;
struct BinomCoeff {
	V<mint> fac, rev;
	BinomCoeff(int n) {
		fac = rev = V<mint>(n + 1, 1);
		FOR(i, 1, n) fac[i] = fac[i - 1] * i;
		rev[n] = 1 / fac[n];
		for(int i = n; i >= 1; i--)
			rev[i - 1] = rev[i] * i;
	}
	mint operator()(int n, int k) {
		return fac[n] * rev[n - k] * rev[k];
	}
};
