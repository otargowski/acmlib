/*
 * Opis: Hashowanie z małą stałą. Można zmienić bazę (jeśli serio trzeba).
 * \texttt{openssl prime -generate -bits 60} generuje losową liczbę pierwszą o $60$ bitach ($\le 1.15 \cdot 10^{18} $).
 */
struct Hashing {
	vll ha, pw;
	static constexpr ll mod = (1ll << 61) - 1;
	ll reduce(ll x) { return x >= mod ? x - mod : x; }
	ll mul(ll a, ll b) {
		C auto c = __int128(a) * b;
		return reduce(ll(c & mod) + ll(c >> 61));
	}
	Hashing(C vi &str, C int base = 37) {
		int len = ssize(str);
		ha.resize(len + 1);
		pw.resize(len + 1, 1);
		REP(i, len) {
			ha[i + 1] = reduce(mul(ha[i], base) + str[i] + 1);
			pw[i + 1] = mul(pw[i], base);
		}
	}
	ll operator()(int l, int r) {
		return reduce(ha[r + 1] - mul(ha[l], pw[r - l + 1]) + mod);
	}
};
