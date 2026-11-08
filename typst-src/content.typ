#import "template.typ": my-chapter, code-entry

#my-chapter("Headers")

#code-entry(
  name: ".vimrc",
  hash: none,
  includes: (),
  opis: none,
  lang: "raw",
  code: "\" JEZELI NEOVIM TO NIE .vimrc A .config/nvim/init.vim\nset ts=4 sw=4 et nu rnu cul scs ic udf so=3 mouse= hls gcr=a:b\ncolorscheme slate\n\" NIE POTRZEBNE JAK NEOVIM:\nfiletype indent on\nsy on\nca Hash w !cpp -dD -P -fpreprocessed \\| tr -d '[:space:]' \\| md5sum \\| cut -c-6",
)

#code-entry(
  name: ".bashrc",
  hash: none,
  includes: (),
  opis: none,
  lang: "sh",
  code: "export FLAGS=\"-Wall -Wextra -Wshadow -Wconversion -Wformat=2 -Wlogical-op -Wfloat-equal -D_GLIBCXX_DEBUG -DDEBUG -DLOCAL -fsanitize=address,undefined -std=c++23 -Og -ggdb3\"\nexport FFLAGS=\"-ggdb3 -O3 -std=c++23 -static -DLOCAL\"\nc(){ g++ $1.cpp $FLAGS -o $@; }\ncf(){ g++ $1.cpp $FFLAGS -o $@; }\nalias mv=\"mv -i\"\nalias cp=\"cp -i\"\nalias gdb=\"ASAN_OPTIONS=detect_leaks=0 gdb -q\"",
)

#code-entry(
  name: "headers",
  hash: "11b3e7",
  includes: (),
  opis: none,
  lang: "cpp",
  code: "/*\n * Opis: Główny nagłówek\n */\n#ifndef LOCAL\n#pragma GCC optimize(\"O3\")\n#endif\n#include <bits/stdc++.h>\n#define FOR(i,p,k) for(int i=(p); i<=(k); ++i)\n#define RFOR(i,p,k) for(int i=(p); i>=(k); --i)\n#define REP(i,k) FOR(i,0,(k)-1)\n#define all(x) (x).begin(), (x).end()\n#define ssize(x) int((x).size())\n#define fi first\n#define se second\n#define V vector\n#define pb push_back\n#define eb emplace_back\n#define C const\n#define pn printf(\"\\n\")\nusing namespace std;\ntypedef long long ll;\ntypedef V <int> vi;\ntypedef C int ci;\ntypedef C ll cll;\ntypedef pair <int, int> pii;\nint I(){\n    int z;\n    scanf(\"%d\", &z);\n    return z;\n}\nvoid ans(){\n}\nint main(){\n    int tt=1;\n    while (tt--) ans();\n}",
)

#code-entry(
  name: "gen.cpp",
  hash: "d474b5",
  includes: (),
  opis: none,
  lang: "cpp",
  code: "/*\n * Opis: Dodatek do generatorki\n */\nmt19937 rng(random_device{}());\nint rd(int l, int r) {\n\treturn uniform_int_distribution<int>(l, r)(rng);\n}",
)

#code-entry(
  name: "freopen.cpp",
  hash: "eb0c77",
  includes: (),
  opis: none,
  lang: "cpp",
  code: "/*\n * Opis: Kod do IO z/do plików\n */\n#define PATH \"fillme\"\n\tassert(strcmp(PATH, \"fillme\") != 0);\n#ifndef LOCAL\n\tfreopen(PATH \".in\", \"r\", stdin);\n\tfreopen(PATH \".out\", \"w\", stdout);\n#endif",
)

#code-entry(
  name: "memoryusage.cpp",
  hash: "305c6a",
  includes: (),
  opis: none,
  lang: "cpp",
  code: "/*\n * Opis: Trzeba wywołać pod koniec main'a. Uwzględnia również \\texttt{unused capacity} pochodzące np. z \\texttt{std::vector::reserve}.\n */\n\n#ifdef LOCAL\nsystem(\"grep VmPeak /proc/$PPID/status >&2\");\n#endif",
)

#code-entry(
  name: "memoryusage.sh",
  hash: none,
  includes: (),
  opis: none,
  lang: "sh",
  code: "command time -f %MKB ./main < t.in > m.out",
)

#my-chapter("Wzorki")

#include "wzorki.typ"

#my-chapter("Matma")

#code-entry(
  name: "berlekamp-massey",
  hash: "0b7946",
  includes: ("simple-modulo",),
  opis: [$cal(O)(n^2 log  k)$, `BerlekampMassey<mod> bm(x)` zgaduje rekurencję ciągu $x$, `bm.get(k)` zwraca $k$-ty wyraz ciągu $x$ (index 0)],
  lang: "cpp",
  code: "struct BerlekampMassey {\n\tint n;\n\tvi x, c;\n\tBerlekampMassey(C vi &_x) : x(_x) {\n\t\tauto B = c = {1};\n\t\tint b = 1, m = 0;\n\t\tREP(i, ssize(x)) {\n\t\t\tm++; int d = x[i];\n\t\t\tFOR(j, 1, ssize(c) - 1)\n\t\t\t\td = add(d, mul(c[j], x[i - j]));\n\t\t\tif(d == 0) continue;\n\t\t\tauto _B = c;\n\t\t\tc.resize(max(ssize(c), m + ssize(B)));\n\t\t\tint coef = mul(d, inv(b));\n\t\t\tFOR(j, m, m + ssize(B) - 1)\n\t\t\t\tc[j] = sub(c[j], mul(coef, B[j - m]));\n\t\t\tif(ssize(_B) < m + ssize(B)) { B = _B; b = d; m = 0; }\n\t\t}\n\t\tc.erase(c.begin());\n\t\tfor(int &t : c) t = sub(0, t);\n\t\tn = ssize(c);\n\t}\n\tvi combine(vi a, vi b) {\n\t\tvi ret(n * 2 + 1);\n\t\tREP(i, n + 1) REP(j, n + 1)\n\t\t\tret[i + j] = add(ret[i + j], mul(a[i], b[j]));\n\t\tfor(int i = 2 * n; i > n; i--) REP(j, n)\n\t\t\tret[i - j - 1] = add(ret[i - j - 1], mul(ret[i], c[j]));\n\t\treturn ret;\n\t}\n\tint get(ll k) {\n\t\tif (!n) return 0;\n\t\tvi r(n + 1), pw(n + 1);\n\t\tr[0] = pw[1] = 1;\n\t\tfor(k++; k; k /= 2) {\n\t\t\tif(k % 2) r = combine(r, pw);\n\t\t\tpw = combine(pw, pw);\n\t\t}\n\t\tint ret = 0;\n\t\tREP(i, n) ret = add(ret, mul(r[i + 1], x[i]));\n\t\treturn ret;\n\t}\n};",
)

#code-entry(
  name: "bignum",
  hash: "140b6c",
  includes: (),
  opis: [Podstawa wynosi $10^9$. Mnożenie, dzielenie, nwd oraz modulo jest kwadratowe, wersje `operatorX(Num, int)` liniowe. Podstawę można zmieniać (ma zachodzić `base == 10\^{`digits_per_elem}).],
  lang: "cpp",
  code: "// BEGIN HASH dcf8cf\nstruct Num {\n\tstatic constexpr int digits_per_elem = 9, base = int(1e9);\n\tint sign = 0;\n\tvi x;\n\tNum& shorten() {\n\t\twhile(ssize(x) and x.back() == 0)\n\t\t\tx.pop_back();\n\t\tfor(int a : x)\n\t\t\tassert(0 <= a and a < base);\n\t\tif(x.empty())\n\t\t\tsign = 0;\n\t\treturn *this;\n\t}\n\tNum(string s) {\n\t\tsign = ssize(s) and s[0] == '-' ? s.erase(s.begin()), -1 : 1;\n\t\tfor(int i = ssize(s); i > 0; i -= digits_per_elem)\n\t\t\tif(i < digits_per_elem)\n\t\t\t\tx.eb(stoi(s.substr(0, i)));\n\t\t\telse\n\t\t\t\tx.eb(stoi(s.substr(i - digits_per_elem, digits_per_elem)));\n\t\tshorten();\n\t}\n\tNum() {}\n\tNum(ll s) : Num(to_string(s)) {}\n}; // END HASH\n// BEGIN HASH f6944d\nstring to_string(C Num& n) {\n\tstringstream s;\n\ts << (n.sign == -1 ? \"-\" : \"\") << (ssize(n.x) ? n.x.back() : 0);\n\tfor(int i = ssize(n.x) - 2; i >= 0; --i)\n\t\ts << setfill('0') << setw(n.digits_per_elem) << n.x[i];\n\treturn s.str();\n}\nostream& operator<<(ostream &o, C Num& n) {\n\treturn o << to_string(n).c_str();\n} // END HASH\n// BEGIN HASH 2c9227\nauto operator<=>(C Num& a, C Num& b) {\n\tif(a.sign != b.sign or ssize(a.x) != ssize(b.x))\n\t\treturn ssize(a.x) * a.sign <=> ssize(b.x) * b.sign;\n\tfor(int i = ssize(a.x) - 1; i >= 0; --i)\n\t\tif(a.x[i] != b.x[i])\n\t\t\treturn a.x[i] * a.sign <=> b.x[i] * b.sign;\n\treturn strong_ordering::equal;\n}\nbool operator==(C Num& a, C Num& b) {\n\treturn a.x == b.x and a.sign == b.sign;\n} // END HASH\n// BEGIN HASH 57d66a\nNum abs(Num n) { n.sign &= 1; return n; }\nNum operator+(Num a, Num b) {\n\tint mode = a.sign * b.sign >= 0 ? a.sign |= b.sign, 1 : abs(b) > abs(a) ? swap(a, b), -1 : -1, carry = 0;\n\tfor(int i = 0; i < max(ssize((mode == 1 ? a : b).x), ssize(b.x)) or carry; ++i) {\n\t\tif(mode == 1 and i == ssize(a.x))\n\t\t\ta.x.eb(0);\n\t\ta.x[i] += mode * (carry + (i < ssize(b.x) ? b.x[i] : 0));\n\t\tcarry = a.x[i] >= a.base or a.x[i] < 0;\n\t\ta.x[i] -= mode * carry * a.base;\n\t}\n\treturn a.shorten();\n} // END HASH\nNum operator-(Num a) { a.sign *= -1; return a; }\nNum operator-(Num a, Num b) { return a + -b; }\n// BEGIN HASH 32f87a\nNum operator*(Num a, int b) {\n\tassert(abs(b) < a.base);\n\tint carry = 0;\n\tfor(int i = 0; i < ssize(a.x) or carry; ++i) {\n\t\tif(i == ssize(a.x))\n\t\t\ta.x.eb(0);\n\t\tll cur = a.x[i] * ll(abs(b)) + carry;\n\t\ta.x[i] = int(cur % a.base);\n\t\tcarry = int(cur / a.base);\n\t}\n\tif(b < 0)\n\t\ta.sign *= -1;\n\treturn a.shorten();\n} // END HASH\n// BEGIN HASH ca88a0\nNum operator*(C Num& a, C Num& b) {\n\tNum c;\n\tc.x.resize(ssize(a.x) + ssize(b.x));\n\tREP(i, ssize(a.x))\n\t\tfor(int j = 0, carry = 0; j < ssize(b.x) or carry; ++j) {\n\t\t\tll cur = c.x[i + j] + a.x[i] * ll(j < ssize(b.x) ? b.x[j] : 0) + carry;\n\t\t\tc.x[i + j] = int(cur % a.base);\n\t\t\tcarry = int(cur / a.base);\n\t\t}\n\tc.sign = a.sign * b.sign;\n\treturn c.shorten();\n} // END HASH\n// BEGIN HASH 520797\nNum operator/(Num a, int b) {\n\tassert(b != 0 and abs(b) < a.base);\n\tint carry = 0;\n\tfor(int i = ssize(a.x) - 1; i >= 0; --i) {\n\t\tll cur = a.x[i] + carry * ll(a.base);\n\t\ta.x[i] = int(cur / abs(b));\n\t\tcarry = int(cur % abs(b));\n\t}\n\tif(b < 0)\n\t\ta.sign *= -1;\n\treturn a.shorten();\n} // END HASH\n// BEGIN HASH c2ef8e\n// zwraca a * pow(a.base, b)\nNum shift(Num a, int b) {\n\tV v(b, 0);\n\ta.x.insert(a.x.begin(), v.begin(), v.end());\n\treturn a.shorten();\n}\nNum operator/(Num a, Num b) {\n\tassert(ssize(b.x));\n\tint s = a.sign * b.sign;\n\tNum c;\n\ta = abs(a);\n\tb = abs(b);\n\tfor(int i = ssize(a.x) - ssize(b.x); i >= 0; --i) {\n\t\tif (a < shift(b, i)) continue;\n\t\tint l = 0, r = a.base - 1;\n\t\twhile (l < r) {\n\t\t\tint m = (l + r + 1) / 2;\n\t\t\tif (shift(b * m, i) <= a)\n\t\t\t\tl = m;\n\t\t\telse\n\t\t\t\tr = m - 1;\n\t\t}\n\t\tc = c + shift(l, i);\n\t\ta = a - shift(b * l, i);\n\t}\n\tc.sign = s;\n\treturn c.shorten();\n} // END HASH\n// BEGIN HASH cb30ff\ntemplate<typename T>\nNum operator%(C Num& a, C T& b) { return a - ((a / b) * b); }\nNum nwd(C Num& a, C Num& b) { return b == Num() ? a : nwd(b, a % b); }\n// END HASH",
)

#code-entry(
  name: "binsearch-stern-brocot",
  hash: "3dce62",
  includes: (),
  opis: [$cal(O)(log  "ma" "x_val")$, szuka największego `a/b`, że `is_ok(a/b)` oraz `0 <= a,b <= max_value`. Zakłada, że `is_ok(0) == true`.],
  lang: "cpp",
  code: "using Frac = pair<ll, ll>;\nFrac my_max(Frac l, Frac r) {\n\treturn l.fi * __int128_t(r.se) > r.fi * __int128_t(l.se) ? l : r;\n}\nFrac binsearch(ll max_value, function<bool (Frac)> is_ok) {\n\tassert(is_ok(pair(0, 1)) == true);\n\tFrac left = {0, 1}, right = {1, 0}, best_found = left;\n\tint current_dir = 0;\n\twhile(max(left.fi, left.se) <= max_value) {\n\t\tbest_found = my_max(best_found, left);\n\t\tauto get_frac = [&](ll mul) {\n\t\t\tll mull = current_dir ? 1 : mul;\n\t\t\tll mulr = current_dir ? mul : 1;\n\t\t\treturn pair(left.fi * mull + right.fi * mulr, left.se * mull + right.se * mulr);\n\t\t};\n\t\tauto is_good_mul = [&](ll mul) {\n\t\t\tFrac mid = get_frac(mul);\n\t\t\treturn is_ok(mid) == current_dir and max(mid.fi, mid.se) <= max_value;\n\t\t};\n\t\tll power = 1;\n\t\tfor(; is_good_mul(power); power *= 2) {}\n\t\tll bl = power / 2 + 1, br = power;\n\t\twhile(bl != br) {\n\t\t\tll bm = (bl + br) / 2;\n\t\t\tif(not is_good_mul(bm))\n\t\t\t\tbr = bm;\n\t\t\telse\n\t\t\t\tbl = bm + 1;\n\t\t}\n\t\ttie(left, right) = pair(get_frac(bl - 1), get_frac(bl));\n\t\tif(current_dir == 0)\n\t\t\tswap(left, right);\n\t\tcurrent_dir ^= 1;\n\t}\n\treturn best_found;\n}",
)

#code-entry(
  name: "crt",
  hash: "e3fa03",
  includes: ("extended-gcd",),
  opis: [$cal(O)(log  n)$, `crt(a, m, b, n)` zwraca takie $x$, że $x mod  m = a$ oraz $x mod  n = b$, $m$ oraz $n$ nie muszą być wzlędnie pierwsze, ale może nie być wtedy rozwiązania (assert wywali, ale można zmienić na return -1).],
  lang: "cpp",
  code: "ll crt(ll a, ll m, ll b, ll n) {\n\tif(n > m) swap(a, b), swap(m, n);\n\tauto [d, x, y] = extended_gcd(m, n);\n\tassert((a - b) % d == 0);\n\tll ret = (b - a) % n * x % n / d * m + a;\n\treturn ret < 0 ? ret + m * n / d : ret;\n}",
)

#code-entry(
  name: "determinant",
  hash: "448aca",
  includes: ("matrix-header",),
  opis: [$cal(O)(n^3)$, wyznacznik macierzy (modulo lub double)],
  lang: "cpp",
  code: "T determinant(V<V<T>>& a) {\n\tint n = ssize(a);\n\tT res = 1;\n\tREP(i, n) {\n\t\tint b = i;\n\t\tFOR(j, i + 1, n - 1)\n\t\t\tif(abs(a[j][i]) > abs(a[b][i]))\n\t\t\t\tb = j;\n\t\tif(i != b)\n\t\t\tswap(a[i], a[b]), res = sub(0, res);\n\t\tres = mul(res, a[i][i]);\n\t\tif (equal(res, 0))\n\t\t\treturn 0;\n\t\tFOR(j, i + 1, n - 1) {\n\t\t\tT v = divide(a[j][i], a[i][i]);\n\t\t\tif (not equal(v, 0))\n\t\t\t\tFOR(k, i + 1, n - 1)\n\t\t\t\t\ta[j][k] = sub(a[j][k], mul(v, a[i][k]));\n\t\t}\n\t}\n\treturn res;\n}",
)

#code-entry(
  name: "discrete-log",
  hash: "466b80",
  includes: ("simple-modulo",),
  opis: [$cal(O)(sqrt(m) log  n)$ czasowo, $cal(O)(sqrt(n))$ pamięciowo, dla liczby pierwszej $mod$ oraz $a, b cancel(divides)  mod$ znajdzie $e$ takie że $a^e "equiv" b mod {mod}$. Jak zwróci $-1$ to nie istnieje.],
  lang: "cpp",
  code: "int discrete_log(int a, int b) {\n\tint n = int(sqrt(mod)) + 1;\n\tint an = 1;\n\tREP(i, n)\n\t\tan = mul(an, a);\n\tunordered_map<int, int> vals;\n\tint cur = b;\n\tFOR(q, 0, n) {\n\t\tvals[cur] = q;\n\t\tcur = mul(cur, a);\n\t}\n\tcur = 1;\n\tFOR(p, 1, n) {\n\t\tcur = mul(cur, an);\n\t\tif(vals.count(cur)) {\n\t\t\tint ans = n * p - vals[cur];\n\t\t\treturn ans;\n\t\t}\n\t}\n\treturn -1;\n}",
)

#code-entry(
  name: "discrete-root",
  hash: "7a0737",
  includes: ("primitive-root", "discrete-log",),
  opis: [Dla pierwszego $mod$ oraz $a bot  mod, k$ znajduje $b$ takie, że $b^k = a$ (pierwiastek k-tego stopnia z $a$). Jak zwróci -1 to nie istnieje.],
  lang: "cpp",
  code: "int discrete_root(int a, int k) {\n\tint g = primitive_root();\n\tint y = discrete_log(powi(g, k), a);\n\tif(y == -1)\n\t\treturn -1;\n\treturn powi(g, y);\n}",
)

#code-entry(
  name: "extended-gcd",
  hash: "c499ae",
  includes: (),
  opis: [$cal(O)(log (min (a, b)))$, dla danego $(a, b)$ znajduje takie $(gcd(a, b), x, y)$, że $a x + b y = gcd(a, b)$. `auto [gcd, x, y] = extended_gcd(a, b);`],
  lang: "cpp",
  code: "tuple<ll, ll, ll> extended_gcd(ll a, ll b) {\n\tif(a == 0)\n\t\treturn {b, 0, 1};\n\tauto [gcd, x, y] = extended_gcd(b % a, a);\n\treturn {gcd, y - x * (b / a), x};\n}",
)

#code-entry(
  name: "fft-mod",
  hash: "a03d84",
  includes: ("fft",),
  opis: [$cal(O)(n log  n)$, `conv_mod(a, b)` zwraca iloczyn wielomianów modulo, ma większą dokładność niż zwykłe fft.],
  lang: "cpp",
  code: "vi conv_mod(vi a, vi b, int M) {\n\tif(a.empty() or b.empty()) return {};\n\tvi res(ssize(a) + ssize(b) - 1);\n\tC int CUTOFF = 125;\n\tif (min(ssize(a), ssize(b)) <= CUTOFF) {\n\t\tif (ssize(a) > ssize(b))\n\t\t\tswap(a, b);\n\t\tREP (i, ssize(a))\n\t\t\tREP (j, ssize(b))\n\t\t\t\tres[i + j] = int((res[i + j] + ll(a[i]) * b[j]) % M);\n\t\treturn res;\n\t}\n\tint B = 32 - __builtin_clz(ssize(res)), n = 1 << B;\n\tint cut = int(sqrt(M));\n\tV<Complex> L(n), R(n), outl(n), outs(n);\n\tREP(i, ssize(a)) L[i] = Complex((int) a[i] / cut, (int) a[i] % cut);\n\tREP(i, ssize(b)) R[i] = Complex((int) b[i] / cut, (int) b[i] % cut);\n\tfft(L), fft(R);\n\tREP(i, n) {\n\t\tint j = -i & (n - 1);\n\t\toutl[j] = (L[i] + conj(L[j])) * R[i] / (2.0 * n);\n\t\touts[j] = (L[i] - conj(L[j])) * R[i] / (2.0 * n) / 1i;\n\t}\n\tfft(outl), fft(outs);\n\tREP(i, ssize(res)) {\n\t\tll av = ll(real(outl[i]) + 0.5), cv = ll(imag(outs[i]) + 0.5);\n\t\tll bv = ll(imag(outl[i]) + 0.5) + ll(real(outs[i]) + 0.5);\n\t\tres[i] = int(((av % M * cut + bv) % M * cut + cv) % M);\n\t}\n\treturn res;\n}",
)

#code-entry(
  name: "fft",
  hash: "b0cf54",
  includes: (),
  opis: [$cal(O)("nlog"  n)$, `conv(a, b)` to iloczyn wielomianów.],
  lang: "cpp",
  code: "// BEGIN HASH 8b009c\nusing Complex = complex<double>;\nvoid fft(V<Complex> &a) {\n\tint n = ssize(a), L = 31 - __builtin_clz(n);\n\tstatic V<complex<long double>> R(2, 1);\n\tstatic V<Complex> rt(2, 1);\n\tfor(static int k = 2; k < n; k *= 2) {\n\t\tR.resize(n), rt.resize(n);\n\t\tauto x = polar(1.0L, acosl(-1) / k);\n\t\tFOR(i, k, 2 * k - 1)\n\t\t\trt[i] = R[i] = i & 1 ? R[i / 2] * x : R[i / 2];\n\t}\n\tvi rev(n);\n\tREP(i, n) rev[i] = (rev[i / 2] | (i & 1) << L) / 2;\n\tREP(i, n) if(i < rev[i]) swap(a[i], a[rev[i]]);\n\tfor(int k = 1; k < n; k *= 2) {\n\t\tfor(int i = 0; i < n; i += 2 * k) REP(j, k) {\n\t\t\tComplex z = rt[j + k] * a[i + j + k]; // mozna zoptowac rozpisujac\n\t\t\ta[i + j + k] = a[i + j] - z;\n\t\t\ta[i + j] += z;\n\t\t}\n\t}\n} // END HASH\nV<double> conv(V<double> &a, V<double> &b) {\n\tif(a.empty() || b.empty()) return {};\n\tV<double> res(ssize(a) + ssize(b) - 1);\n\tint L = 32 - __builtin_clz(ssize(res)), n = (1 << L);\n\tV<Complex> in(n), out(n);\n\tcopy(all(a), in.begin());\n\tREP(i, ssize(b)) in[i].imag(b[i]);\n\tfft(in);\n\tfor(auto &x : in) x *= x;\n\tREP(i, n) out[i] = in[-i & (n - 1)] - conj(in[i]);\n\tfft(out);\n\tREP(i, ssize(res)) res[i] = imag(out[i]) / (4 * n);\n\treturn res;\n}",
)

#code-entry(
  name: "floor-sum",
  hash: "b06d8c",
  includes: (),
  opis: [$cal(O)(log  a)$, liczy $sum _{i=0}^{n-1} <="ftfloor"( ("adot"  i + b)/(c) )$. Działa dla $0 <=q a, b < c$ oraz $1<=q c, n <=q 10^9$. Dla innych $n, a, b, c$ trzeba uważać lub użyć `__int128`.],
  lang: "cpp",
  code: "ll floor_sum(ll n, ll a, ll b, ll c) {\n\tll ans = 0;\n\tif (a >= c) {\n\t\tans += (n - 1) * n * (a / c) / 2;\n\t\ta %= c;\n\t}\n\tif (b >= c) {\n\t\tans += n * (b / c);\n\t\tb %= c;\n\t}\n\tll d = (a * (n - 1) + b) / c;\n\tif (d == 0) return ans;\n\tans += d * (n - 1) - floor_sum(d, c, c - b - 1, a);\n\treturn ans;\n}",
)

#code-entry(
  name: "fwht",
  hash: "c01d10",
  includes: (),
  opis: [$cal(O)(n log  n)$, $n$ musi być potęgą dwójki, `fwht_or(a)[i] = suma(j będące podmaską i) a[j]`, `ifwht_or(fwht_or(a)) == a`, `convolution_or(a, b)[i] = suma(j | k == i) a[j] * b[k]`, `fwht_and(a)[i] = suma(j będące nadmaską i) a[j]`, `ifwht_and(fwht_and(a)) == a`, `convolution_and(a, b)[i] = suma(j \& k == i) a[j] * b[k]`, `fwht_xor(a)[i] = suma(j oraz i mają parzyście wspólnie zapalonych bitów) a[j] - suma(j oraz i mają nieparzyście) a[j]`, `ifwht_xor(fwht_xor(a)) == a`, `convolution_xor(a, b)[i] = suma(j \^ k == i) a[j] * b[k]`.],
  lang: "cpp",
  code: "// BEGIN HASH f58aba\nvi fwht_or(vi a) {\n\tint n = ssize(a);\n\tassert((n & (n - 1)) == 0);\n\tfor(int s = 1; 2 * s <= n; s *= 2)\n\t\tfor(int l = 0; l < n; l += 2 * s)\n\t\t\tfor(int i = l; i < l + s; ++i)\n\t\t\t\ta[i + s] += a[i];\n\treturn a;\n}\nvi ifwht_or(vi a) {\n\tint n = ssize(a);\n\tassert((n & (n - 1)) == 0);\n\tfor(int s = n / 2; s >= 1; s /= 2)\n\t\tfor(int l = 0; l < n; l += 2 * s)\n\t\t\tfor(int i = l; i < l + s; ++i)\n\t\t\t\ta[i + s] -= a[i];\n\treturn a;\n}\nvi convolution_or(vi a, vi b) {\n\tint n = ssize(a);\n\tassert((n & (n - 1)) == 0 and ssize(b) == n);\n\ta = fwht_or(a);\n\tb = fwht_or(b);\n\tREP(i, n)\n\t\ta[i] *= b[i];\n\treturn ifwht_or(a);\n} // END HASH\n// BEGIN HASH 4bbc88\nvi fwht_and(vi a) {\n\tint n = ssize(a);\n\tassert((n & (n - 1)) == 0);\n\tfor(int s = 1; 2 * s <= n; s *= 2)\n\t\tfor(int l = 0; l < n; l += 2 * s)\n\t\t\tfor(int i = l; i < l + s; ++i)\n\t\t\t\ta[i] += a[i + s];\n\treturn a;\n}\nvi ifwht_and(vi a) {\n\tint n = ssize(a);\n\tassert((n & (n - 1)) == 0);\n\tfor(int s = n / 2; s >= 1; s /= 2)\n\t\tfor(int l = 0; l < n; l += 2 * s)\n\t\t\tfor(int i = l; i < l + s; ++i)\n\t\t\t\ta[i] -= a[i + s];\n\treturn a;\n}\nvi convolution_and(vi a, vi b) {\n\tint n = ssize(a);\n\tassert((n & (n - 1)) == 0 and ssize(b) == n);\n\ta = fwht_and(a);\n\tb = fwht_and(b);\n\tREP(i, n)\n\t\ta[i] *= b[i];\n\treturn ifwht_and(a);\n} // END HASH\n// BEGIN HASH 6606b1\nvi fwht_xor(vi a) {\n\tint n = ssize(a);\n\tassert((n & (n - 1)) == 0);\n\tfor(int s = 1; 2 * s <= n; s *= 2)\n\t\tfor(int l = 0; l < n; l += 2 * s)\n\t\t\tfor(int i = l; i < l + s; ++i) {\n\t\t\t\tint t = a[i + s];\n\t\t\t\ta[i + s] = a[i] - t;\n\t\t\t\ta[i] += t;\n\t\t\t}\n\treturn a;\n}\nvi ifwht_xor(vi a) {\n\tint n = ssize(a);\n\tassert((n & (n - 1)) == 0);\n\tfor(int s = n / 2; s >= 1; s /= 2)\n\t\tfor(int l = 0; l < n; l += 2 * s)\n\t\t\tfor(int i = l; i < l + s; ++i) {\n\t\t\t\tint t = a[i + s];\n\t\t\t\ta[i + s] = (a[i] - t) / 2;\n\t\t\t\ta[i] = (a[i] + t) / 2;\n\t\t\t}\n\treturn a;\n}\nvi convolution_xor(vi a, vi b) {\n\tint n = ssize(a);\n\tassert((n & (n - 1)) == 0 and ssize(b) == n);\n\ta = fwht_xor(a);\n\tb = fwht_xor(b);\n\tREP(i, n)\n\t\ta[i] *= b[i];\n\treturn ifwht_xor(a);\n} // END HASH",
)

#code-entry(
  name: "gauss",
  hash: "482bf4",
  includes: ("matrix-header",),
  opis: [$cal(O)("nm"(n+m))$, Wrzucam $n$ vectorów `{wsp_x0, wsp_x1, ..., wsp_xm - 1, suma\`}, gauss wtedy zwraca liczbę rozwiązań (0, 1 albo 2 (tzn. nieskończoność)) oraz jedno poprawne rozwiązanie (o ile istnieje). Przykład `gauss({2, -1, 1, 7\`, {1, 1, 1, 1}, {0, 1, -1, 6.5})} zwraca `(1, {6.75, 0.375, -6.125\`)}.],
  lang: "cpp",
  code: "pair<int, V<T>> gauss(V<V<T>> a) {\n\tint n = ssize(a); // liczba wierszy\n\tint m = ssize(a[0]) - 1; // liczba zmiennych\n\tvi where(m, -1); // w ktorym wierszu jest zdefiniowana i-ta zmienna\n\tfor(int col = 0, row = 0; col < m and row < n; ++col) {\n\t\tint sel = row;\n\t\tfor(int y = row; y < n; ++y)\n\t\t\tif(abs(a[y][col]) > abs(a[sel][col]))\n\t\t\t\tsel = y;\n\t\tif(equal(a[sel][col], 0))\n\t\t\tcontinue;\n\t\tfor(int x = col; x <= m; ++x)\n\t\t\tswap(a[sel][x], a[row][x]);\n\t\t// teraz sel jest nieaktualne\n\t\twhere[col] = row;\n\t\tfor(int y = 0; y < n; ++y)\n\t\t\tif(y != row) {\n\t\t\t\tT wspolczynnik = divide(a[y][col], a[row][col]);\n\t\t\t\tfor(int x = col; x <= m; ++x)\n\t\t\t\t\ta[y][x] = sub(a[y][x], mul(wspolczynnik, a[row][x]));\n\t\t\t}\n\t\t++row;\n\t}\n\tV<T> answer(m);\n\tfor(int col = 0; col < m; ++col)\n\t\tif(where[col] != -1)\n\t\t\tanswer[col] = divide(a[where[col]][m], a[where[col]][col]);\n\tfor(int row = 0; row < n; ++row) {\n\t\tT got = 0;\n\t\tfor(int col = 0; col < m; ++col)\n\t\t\tgot = add(got, mul(answer[col], a[row][col]));\n\t\tif(not equal(got, a[row][m]))\n\t\t\treturn {0, answer};\n\t}\n\tfor(int col = 0; col < m; ++col)\n\t\tif(where[col] == -1)\n\t\t\treturn {2, answer};\n\treturn {1, answer};\n}",
)

#code-entry(
  name: "integral",
  hash: "fad4ef",
  includes: (),
  opis: [$cal(O)("idk")$, zwraca całkę f na [l, r].],
  lang: "cpp",
  code: "using D = long double;\nD simpson(function<D (D)> f, D l, D r) {\n\treturn (f(l) + 4 * f((l + r) / 2) + f(r)) * (r - l) / 6;\n}\nD integrate(function<D (D)> f, D l, D r, D s, D eps) {\n\tD m = (l + r) / 2;\n\tD sl = simpson(f, l, m), sr = simpson(f, m, r), s2 = sl + sr;\n\tif(abs(s2 - s) < 15 * eps or r - l < 1e-10)\n\t\treturn s2 + (s2 - s) / 15;\n\treturn integrate(f, l, m, sl, eps / 2)\n\t\t+ integrate(f, m, r, sr, eps / 2);\n}\nD integrate(function<D (D)> f, D l, D r) {\n\treturn integrate(f, l, r, simpson(f, l, r), 1e-8);\n}",
)

#code-entry(
  name: "lagrange-consecutive",
  hash: "04d4e8",
  includes: ("simple-modulo",),
  opis: [$cal(O)(n)$, przyjmuje wartości wielomianu w punktach $0,1,dots ,n-1$ i wylicza jego wartość w $x$. lagrange_consecutive({2, 3, 4}, 3) == 5],
  lang: "cpp",
  code: "int lagrange_consecutive(vi y, int x) {\n\tint n = ssize(y), fac = 1, pref = 1, suff = 1, ret = 0;\n\tFOR(i, 1, n) fac = mul(fac, i);\n\tfac = inv(fac);\n\tREP(i, n) {\n\t\tfac = mul(fac, n - i);\n\t\ty[i] = mul(y[i], mul(pref, fac));\n\t\ty[n - 1 - i] = mul(y[n - 1 - i], mul(suff, mul(i % 2 ? mod - 1 : 1, fac)));\n\t\tpref = mul(pref, sub(x, i));\n\t\tsuff = mul(suff, sub(x, n - 1 - i));\n\t}\n\tREP(i, n) ret = add(ret, y[i]);\n\treturn ret;\n}",
)

#code-entry(
  name: "matrix-header",
  hash: "954c9d",
  includes: (),
  opis: [Funkcje pomocnicze do algorytmów macierzowych.],
  lang: "cpp",
  code: "#if 1\n#ifdef CHANGABLE_MOD\nint mod = 998'244'353;\n#else\nconstexpr int mod = 998'244'353;\n#endif\n// BEGIN HASH 38b0c9\nbool equal(int a, int b) {\n\treturn a == b;\n}\nint mul(int a, int b) {\n\treturn int(a * ll(b) % mod);\n}\nint add(int a, int b) {\n\ta += b;\n\treturn a >= mod ? a - mod : a;\n}\nint powi(int a, int b) {\n\tfor(int ret = 1;; b /= 2) {\n\t\tif(b == 0)\n\t\t\treturn ret;\n\t\tif(b & 1)\n\t\t\tret = mul(ret, a);\n\t\ta = mul(a, a);\n\t}\n}\nint inv(int x) {\n\treturn powi(x, mod - 2);\n}\nint divide(int a, int b) {\n\treturn mul(a, inv(b));\n}\nint sub(int a, int b) {\n\treturn add(a, mod - b);\n}\nusing T = int;\n// END HASH\n#else\n// BEGIN HASH a32baf\nconstexpr double eps = 1e-9;\nbool equal(double a, double b) {\n\treturn abs(a - b) < eps;\n}\n#define OP(name, op) double name(double a, double b) { return a op b; }\nOP(mul, *)\nOP(add, +)\nOP(divide, /)\nOP(sub, -)\nusing T = double;\n// END HASH\n#endif",
)

#code-entry(
  name: "matrix-inverse",
  hash: "86d4aa",
  includes: ("matrix-header",),
  opis: [$cal(O)(n^3)$, odwrotność macierzy (modulo lub double). Zwraca rząd macierzy. Dla odwracalnych macierzy (rząd = n) w $a$ znajdzie się jej odwrotność.],
  lang: "cpp",
  code: "int inverse(V<V<T>>& a) {\n\tint n = ssize(a);\n\tvi col(n);\n\tV h(n, V<T>(n));\n\tREP(i, n)\n\t\th[i][i] = 1, col[i] = i;\n\tREP(i, n) {\n\t\tint r = i, c = i;\n\t\tFOR(j, i, n - 1) FOR(k, i, n - 1)\n\t\t\tif(abs(a[j][k]) > abs(a[r][c]))\n\t\t\t\tr = j, c = k;\n\t\tif (equal(a[r][c], 0))\n\t\t\treturn i;\n\t\ta[i].swap(a[r]);\n\t\th[i].swap(h[r]);\n\t\tREP(j, n)\n\t\t\tswap(a[j][i], a[j][c]), swap(h[j][i], h[j][c]);\n\t\tswap(col[i], col[c]);\n\t\tT v = a[i][i];\n\t\tFOR(j, i + 1, n - 1) {\n\t\t\tT f = divide(a[j][i], v);\n\t\t\ta[j][i] = 0;\n\t\t\tFOR(k, i + 1, n - 1)\n\t\t\t\ta[j][k] = sub(a[j][k], mul(f, a[i][k]));\n\t\t\tREP(k, n)\n\t\t\t\th[j][k] = sub(h[j][k], mul(f, h[i][k]));\n\t\t}\n\t\tFOR(j, i + 1, n - 1)\n\t\t\ta[i][j] = divide(a[i][j], v);\n\t\tREP(j, n)\n\t\t\th[i][j] = divide(h[i][j], v);\n\t\ta[i][i] = 1;\n\t}\n\tfor(int i = n - 1; i > 0; --i) REP(j, i) {\n\t\tT v = a[j][i];\n\t\tREP(k, n)\n\t\t\th[j][k] = sub(h[j][k], mul(v, h[i][k]));\n\t}\n\tREP(i, n)\n\t\tREP(j, n)\n\t\t\ta[col[i]][col[j]] = h[i][j];\n\treturn n;\n}",
)

#code-entry(
  name: "miller-rabin",
  hash: "ae0853",
  includes: (),
  opis: [$cal(O)(log ^2 n)$ test pierwszości Millera-Rabina, działa dla long longów.],
  lang: "cpp",
  code: "ll llmul(ll a, ll b, ll m) {\n\treturn ll(__int128_t(a) * b % m);\n}\nll llpowi(ll a, ll n, ll m) {\n\tfor (ll ret = 1;; n /= 2) {\n\t\tif (n == 0)\n\t\t\treturn ret;\n\t\tif (n % 2)\n\t\t\tret = llmul(ret, a, m);\n\t\ta = llmul(a, a, m);\n\t}\n}\nbool miller_rabin(ll n) {\n\tif(n < 2) return false;\n\tint r = 0;\n\tll d = n - 1;\n\twhile(d % 2 == 0)\n\t\td /= 2, r++;\n\tfor(int a : {2, 325, 9375, 28178, 450775, 9780504, 1795265022}) {\n\t\tif (a % n == 0) continue;\n\t\tll x = llpowi(a, d, n);\n\t\tif(x == 1 || x == n - 1)\n\t\t\tcontinue;\n\t\tbool composite = true;\n\t\tREP(i, r - 1) {\n\t\t\tx = llmul(x, x, n);\n\t\t\tif(x == n - 1) {\n\t\t\t\tcomposite = false;\n\t\t\t\tbreak;\n\t\t\t}\n\t\t}\n\t\tif(composite) return false;\n\t}\n\treturn true;\n}",
)

#code-entry(
  name: "multiplicative",
  hash: "3070a7",
  includes: ("sieve",),
  opis: [$cal(O)(n)$, `mobius(n)` oblicza funkcję M\"obiusa na [0..n], `totient(n)` oblicza funkcję Eulera na [0..n], wartości w $0$ niezdefiniowane.],
  lang: "cpp",
  code: "// BEGIN HASH 882c54\nvi mobius(int n) {\n\tsieve(n);\n\tvi ans(n + 1, 0);\n\tif (n) ans[1] = 1;\n\tFOR(i, 2, n) {\n\t\tint p = prime_div[i];\n\t\tif (i / p % p) ans[i] = -ans[i / p];\n\t}\n\treturn ans;\n} // END HASH\n// BEGIN HASH e94976\nvi totient(int n) {\n\tsieve(n);\n\tvi ans(n + 1, 1);\n\tFOR(i, 2, n) {\n\t\tint p = prime_div[i];\n\t\tans[i] = ans[i / p] * (p - bool(i / p % p));\n\t}\n\treturn ans;\n} // END HASH",
)

#code-entry(
  name: "ntt",
  hash: "0a21fe",
  includes: ("simple-modulo",),
  opis: [$cal(O)("nlog"  n)$ mnożenie wielomianów mod $998244353$.],
  lang: "cpp",
  code: "// BEGIN HASH bcb639\nusing vi = vi;\nconstexpr int root = 3;\nvoid ntt(vi& a, int n, bool inverse = false) {\n\tassert((n & (n - 1)) == 0);\n\ta.resize(n);\n\tvi b(n);\n\tfor(int w = n / 2; w; w /= 2, swap(a, b)) {\n\t\tint r = powi(root, (mod - 1) / n * w), m = 1;\n\t\tfor(int i = 0; i < n; i += w * 2, m = mul(m, r)) REP(j, w) {\n\t\t\tint u = a[i + j], v = mul(a[i + j + w], m);\n\t\t\tb[i / 2 + j] = add(u, v);\n\t\t\tb[i / 2 + j + n / 2] = sub(u, v);\n\t\t}\n\t}\n\tif(inverse) {\n\t\treverse(a.begin() + 1, a.end());\n\t\tint invn = inv(n);\n\t\tfor(int& e : a) e = mul(e, invn);\n\t}\n} // END HASH\nvi conv(vi a, vi b) {\n\tif(a.empty() or b.empty()) return {};\n\tint l = ssize(a) + ssize(b) - 1, sz = 1 << __lg(2 * l - 1);\n\tntt(a, sz), ntt(b, sz);\n\tREP(i, sz) a[i] = mul(a[i], b[i]);\n\tntt(a, sz, true), a.resize(l);\n\treturn a;\n}",
)

#code-entry(
  name: "pell",
  hash: "9071bf",
  includes: (),
  opis: [$cal(O)(log  n)$, `pell(n)` oblicza rozwiązanie fundamentalne $x^2-"ny"^2=1$, zwraca $(0, 0)$ jeżeli nie istnieje ($n$ jest kwadratem lub wynik przekracza ll), `all_pell(n, limit)` wyznacza wszystkie rozwiązania $x^2-"ny"^2=1$ z $x<= `"limit"`$, w razie potrzeby można przepisać na pythona lub użyć bignumów.],
  lang: "cpp",
  code: "pair<ll, ll> pell(ll n) {\n\tll s = ll(sqrtl(n));\n\tif (s * s == n) return {0, 0};\n\tll m = 0, d = 1, a = s;\n\t__int128 num1 = 1, num2 = a, den1 = 0, den2 = 1;\n\twhile (num2 * num2 - n * den2 * den2 != 1) {\n\t\tm = d * a - m;\n\t\td = (n - m * m) / d;\n\t\ta = (s + m) / d;\n\t\tif (num2 > (1ll << 62) / a) return {0, 0};\n\t\ttie(num1, num2) = pair(num2, a * num2 + num1);\n\t\ttie(den1, den2) = pair(den2, a * den2 + den1);\n\t}\n\treturn {num2, den2};\n}\nV<pair<ll, ll>> all_pell(ll n, ll limit) {\n\tauto [x0, y0] = pell(n);\n\tif (!x0) return {};\n\tV<pair<ll, ll>> ret;\n\t__int128 x = x0, y = y0;\n\twhile (x <= limit) {\n\t\tret.eb(x, y);\n\t\tif (y0 * y > (1ll << 62) / n) break;\n\t\ttie(x, y) = pair(x0 * x + n * y0 * y, x0 * y + y0 * x);\n\t}\n\treturn ret;\n}",
)

#code-entry(
  name: "pi",
  hash: "f777db",
  includes: (),
  opis: [$cal(O)(n\^{}(3)/(4))$, liczba liczb pierwszych na przedziale $[1,n]$. `Pi pi(n); pi.query(d); // musi zachodzic d | n`],
  lang: "cpp",
  code: "struct Pi {\n\tvll w, dp;\n\tint id(ll v) {\n\t\tif (v <= w.back() / v)\n\t\t\treturn int(v - 1);\n\t\treturn ssize(w) - int(w.back() / v);\n\t}\n\tPi(ll n) {\n\t\tfor (ll i = 1; i * i <= n; ++i) {\n\t\t\tw.pb(i);\n\t\t\tif (n / i != i)\n\t\t\t\tw.eb(n / i);\n\t\t}\n\t\tsort(all(w));\n\t\tfor (ll i : w)\n\t\t\tdp.eb(i - 1);\n\t\tfor (ll i = 1; (i + 1) * (i + 1) <= n; ++i) {\n\t\t\tif (dp[i] == dp[i - 1])\n\t\t\t\tcontinue;\n\t\t\tfor (int j = ssize(w) - 1; w[j] >= (i + 1) * (i + 1); --j)\n\t\t\t\tdp[j] -= dp[id(w[j] / (i + 1))] - dp[i - 1];\n\t\t}\n\t}\n\tll query(ll v) {\n\t\tassert(w.back() % v == 0);\n\t\treturn dp[id(v)];\n\t}\n};",
)

#code-entry(
  name: "polynomial",
  hash: "8a2d5d",
  includes: ("ntt",),
  opis: [Operacje na wielomianach mod $998244353$, deriv, integr $cal(O)(n)$, powi_deg $cal(O)(n dot  deg)$, sqrt, inv, log, exp, powi, div $cal(O)(n log  n)$, powi_slow, eval, inter $cal(O)(n log  ^2 n)$ Ogólnie to przepisujemy co chcemy. Funkcje oznaczone jako KONIECZNE są wymagane. Funkcje oznaczone WYMAGA ABC wymagają wcześniejszego przepisania ABC. `deriv(a)` zwraca $a'$, `integr(a)` zwraca $integral  a$, `powi(_deg_slow)(a, k, n)` zwraca $a^k (mod  x^n)$, `sqrt(a, n)` zwraca $a^{}(1)/(2) (mod  x^n)$, `inv(a, n)` zwraca $a^{-1} (mod  x^n)$, `log(a, n)` zwraca $ln(a) (mod  x^n)$, `exp(a, n)` zwraca $exp(a) (mod  x^n)$, `div(a, b)` zwraca $(q, r)$ takie, że $a = q b + r$, `eval(a, x)` zwraca $y$ taki, że $a("x_i") = "y_i"$, `inter(x, y)` zwraca $a$ taki, że $a("x_i") = "y_i"$.],
  lang: "cpp",
  code: "// BEGIN HASH f824a3\nvi mod_xn(C vi& a, int n) { // KONIECZNE\n\treturn vi(a.begin(), a.begin() + min(n, ssize(a)));\n}\nvoid sub(vi& a, C vi& b) { // KONIECZNE\n\ta.resize(max(ssize(a), ssize(b)));\n\tREP(i, ssize(b)) a[i] = sub(a[i], b[i]);\n} // END HASH\n// BEGIN HASH 2c8fbb\nvi deriv(vi a) {\n\tREP(i, ssize(a)) a[i] = mul(a[i], i);\n\tif(ssize(a)) a.erase(a.begin());\n\treturn a;\n}\nvi integr(vi a) {\n\tint n = ssize(a);\n\ta.insert(a.begin(), 0);\n\tstatic vi f{1};\n\tFOR(i, ssize(f), n) f.eb(mul(f[i - 1], i));\n\tint r = inv(f[n]);\n\tfor(int i = n; i > 0; --i)\n\t\ta[i] = mul(a[i], mul(r, f[i - 1])), r = mul(r, i);\n\treturn a;\n} // END HASH\n// BEGIN HASH d6d6d4\nvi powi_deg(C vi& a, int k, int n) {\n\tassert(ssize(a) and a[0] != 0);\n\tvi v(n), f(n, 1);\n\tv[0] = powi(a[0], k);\n\tREP(i, n - 1) f[i + 1] = mul(f[i], n - i);\n\tint r = inv(mul(f[n - 1], a[0]));\n\tFOR(i, 1, n - 1) {\n\t\tFOR(j, 1, min(ssize(a) - 1, i)) {\n\t\t\tv[i] = add(v[i], mul(a[j], mul(v[i - j], sub(mul(k, j), i - j))));\n\t\t}\n\t\tv[i] = mul(v[i], mul(r, f[n - i]));\n\t\tr = mul(r, i);\n\t}\n\treturn v;\n} // END HASH\n// BEGIN HASH 57a01a\nvi powi_slow(C vi &a, int k, int n) {\n\tvi v{1}, b = mod_xn(a, n);\n\tint x = 1; while(x < n) x *= 2;\n\twhile(k) {\n\t\tntt(b, 2 * x);\n\t\tif(k & 1) {\n\t\t\tntt(v, 2 * x);\n\t\t\tREP(i, 2 * x) v[i] = mul(v[i], b[i]);\n\t\t\tntt(v, 2 * x, true);\n\t\t\tv.resize(x);\n\t\t}\n\t\tREP(i, 2 * x) b[i] = mul(b[i], b[i]);\n\t\tntt(b, 2 * x, true);\n\t\tb.resize(x);\n\t\tk /= 2;\n\t}\n\treturn mod_xn(v, n);\n} // END HASH\n// BEGIN HASH 504d4e\nvi sqrt(C vi& a, int n) {\n\tauto at = [&](int i) { if(i < ssize(a)) return a[i]; else return 0; };\n\tassert(ssize(a) and a[0] == 1);\n\tC int inv2 = inv(2);\n\tvi v{1}, f{1}, g{1};\n\tfor(int x = 1; x < n; x *= 2) {\n\t\tvi z = v;\n\t\tntt(z, x);\n\t\tvi b = g;\n\t\tREP(i, x) b[i] = mul(b[i], z[i]);\n\t\tntt(b, x, true);\n\t\tREP(i, x / 2) b[i] = 0;\n\t\tntt(b, x);\n\t\tREP(i, x) b[i] = mul(b[i], g[i]);\n\t\tntt(b, x, true);\n\t\tREP(i, x / 2) f.eb(sub(0, b[i + x / 2]));\n\t\tREP(i, x) z[i] = mul(z[i], z[i]);\n\t\tntt(z, x, true);\n\t\tvi c(2 * x);\n\t\tREP(i, x) c[i + x] = sub(add(at(i), at(i + x)), z[i]);\n\t\tntt(c, 2 * x);\n\t\tg = f;\n\t\tntt(g, 2 * x);\n\t\tREP(i, 2 * x) c[i] = mul(c[i], g[i]);\n\t\tntt(c, 2 * x, true);\n\t\tREP(i, x) v.eb(mul(c[i + x], inv2));\n\t}\n\treturn mod_xn(v, n);\n} // END HASH\n// BEGIN HASH 02cc82\nvi inv(C vi& a, int n) {\n\tassert(ssize(a) and a[0] != 0);\n\tvi v{inv(a[0])};\n\tfor(int x = 1; x < n; x *= 2) {\n\t\tvi f = mod_xn(a, 2 * x), g = v;\n\t\tntt(g, 2 * x);\n\t\tREP(k, 2) {\n\t\t\tntt(f, 2 * x);\n\t\t\tREP(i, 2 * x) f[i] = mul(f[i], g[i]);\n\t\t\tntt(f, 2 * x, true);\n\t\t\tREP(i, x) f[i] = 0;\n\t\t}\n\t\tsub(v, f);\n\t}\n\treturn mod_xn(v, n);\n} // END HASH\n// BEGIN HASH 6635b5\nvi log(C vi& a, int n) { // WYMAGA deriv, integr, inv\n\tassert(ssize(a) and a[0] == 1);\n\treturn integr(mod_xn(conv(deriv(mod_xn(a, n)), inv(a, n)), n - 1));\n} // END HASH\n// BEGIN HASH 7b9b7f\nvi exp(C vi& a, int n) { // WYMAGA deriv, integr\n\tassert(a.empty() or a[0] == 0);\n\tvi v{1}, f{1}, g, h{0}, s;\n\tfor(int x = 1; x < n; x *= 2) {\n\t\tg = v;\n\t\tREP(k, 2) {\n\t\t\tntt(g, (2 - k) * x);\n\t\t\tif(!k) s = g;\n\t\t\tREP(i, x) g[i] = mul(g[(2 - k) * i], h[i]);\n\t\t\tntt(g, x, true);\n\t\t\tREP(i, x / 2) g[i] = 0;\n\t\t}\n\t\tsub(f, g);\n\t\tvi b = deriv(mod_xn(a, x));\n\t\tntt(b, x);\n\t\tREP(i, x) b[i] = mul(s[2 * i], b[i]);\n\t\tntt(b, x, true);\n\t\tvi c = deriv(v);\n\t\tsub(c, b);\n\t\trotate(all(c) - 1, c.end());\n\t\tntt(c, 2 * x);\n\t\th = f;\n\t\tntt(h, 2 * x);\n\t\tREP(i, 2 * x) c[i] = mul(c[i], h[i]);\n\t\tntt(c, 2 * x, true);\n\t\tc.resize(x);\n\t\tvi t(x - 1);\n\t\tc.insert(c.begin(), t.begin(), t.end());\n\t\tvi d = mod_xn(a, 2 * x);\n\t\tsub(d, integr(c));\n\t\td.erase(d.begin(), d.begin() + x);\n\t\tntt(d, 2 * x);\n\t\tREP(i, 2 * x) d[i] = mul(d[i], s[i]);\n\t\tntt(d, 2 * x, true);\n\t\tREP(i, x) v.eb(d[i]);\n\t}\n\treturn mod_xn(v, n);\n} // END HASH\n// BEGIN HASH 802699\nvi powi(C vi& a, int k, int n) { // WYMAGA log, exp\n\tvi v = mod_xn(a, n);\n\tint cnt = 0;\n\twhile(cnt < ssize(v) and !v[cnt])\n\t\t++cnt;\n\tif(ll(cnt) * k >= n)\n\t\treturn {};\n\tv.erase(v.begin(), v.begin() + cnt);\n\tif(v.empty())\n\t\treturn k ? vi{} : vi{1};\n\tint powi0 = powi(v[0], k);\n\tint inv0 = inv(v[0]);\n\tfor(int& e : v) e = mul(e, inv0);\n\tv = log(v, n - cnt * k);\n\tfor(int& e : v) e = mul(e, k);\n\tv = exp(v, n - cnt * k);\n\tfor(int& e : v) e = mul(e, powi0);\n\tvi t(cnt * k, 0);\n\tv.insert(v.begin(), t.begin(), t.end());\n\treturn v;\n} // END HASH\n// BEGIN HASH 748a86\npair<vi, vi> div_slow(vi a, C vi& b) {\n\tvi x;\n\twhile(ssize(a) >= ssize(b)) {\n\t\tx.eb(mul(a.back(), inv(b.back())));\n\t\tif(x.back() != 0)\n\t\t\tREP(i, ssize(b))\n\t\t\t\ta.end()[-i - 1] = sub(a.end()[-i - 1], mul(x.back(), b.end()[-i - 1]));\n\t\ta.pop_back();\n\t}\n\treverse(all(x));\n\treturn {x, a};\n}\npair<vi, vi> div(vi a, C vi& b) { // WYMAGA inv, div_slow\n\tC int d = ssize(a) - ssize(b) + 1;\n\tif (d <= 0)\n\t\treturn {{}, a};\n\tif (min(d, ssize(b)) < 250)\n\t\treturn div_slow(a, b);\n\tvi x = mod_xn(conv(mod_xn({a.rbegin(), a.rend()}, d), inv({b.rbegin(), b.rend()}, d)), d);\n\treverse(all(x));\n\tsub(a, conv(x, b));\n\treturn {x, mod_xn(a, ssize(b))};\n} // END HASH\n// BEGIN HASH 6a6b92\nvi build(V<vi> &tree, int v, auto l, auto r) {\n\tif (r - l == 1) {\n\t\treturn tree[v] = vi{sub(0, *l), 1};\n\t} else {\n\t\tauto M = l + (r - l) / 2;\n\t\treturn tree[v] = conv(build(tree, 2 * v, l, M), build(tree, 2 * v + 1, M, r));\n\t}\n} // END HASH\n// BEGIN HASH c3c4fc\nint eval_single(C vi& a, int x) {\n\tint y = 0;\n\tRFOR(i, ssize(a)-1, 0) {\n\t\ty = mul(y, x);\n\t\ty = add(y, a[i]);\n\t}\n\treturn y;\n}\nvi eval_helper(C vi& a, V<vi>& tree, int v, auto l, auto r) {\n\tif (r - l == 1) {\n\t\treturn {eval_single(a, *l)};\n\t} else {\n\t\tauto m = l + (r - l) / 2;\n\t\tvi A = eval_helper(div(a, tree[2 * v]).se, tree, 2 * v, l, m);\n\t\tvi B = eval_helper(div(a, tree[2 * v + 1]).se, tree, 2 * v + 1, m, r);\n\t\tA.insert(A.end(), B.begin(), B.end());\n\t\treturn A;\n\t}\n}\nvi eval(C vi& a, C vi& x) { // WYMAGA div, eval_single, build, eval_helper\n\tif (x.empty())\n\t\treturn {};\n\tV<vi> tree(4 * ssize(x));\n\tbuild(tree, 1, begin(x), end(x));\n\treturn eval_helper(a, tree, 1, begin(x), end(x));\n} // END HASH\n// BEGIN HASH 87c63d\nvi inter_helper(C vi& a, V<vi>& tree, int v, auto l, auto r, auto ly, auto ry) {\n\tif (r - l == 1) {\n\t\treturn {mul(*ly, inv(a[0]))};\n\t}\n\telse {\n\t\tauto m = l + (r - l) / 2;\n\t\tauto my = ly + (ry - ly) / 2;\n\t\tvi A = inter_helper(div(a, tree[2 * v]).se, tree, 2 * v, l, m, ly, my);\n\t\tvi B = inter_helper(div(a, tree[2 * v + 1]).se, tree, 2 * v + 1, m, r, my, ry);\n\t\tvi L = conv(A, tree[2 * v + 1]);\n\t\tvi R = conv(B, tree[2 * v]);\n\t\tREP(i, ssize(R))\n\t\t\tL[i] = add(L[i], R[i]);\n\t\treturn L;\n\t}\n}\nvi inter(C vi& x, C vi& y) { // WYMAGA deriv, div, build, inter_helper\n\tassert(ssize(x) == ssize(y));\n\tif (x.empty())\n\t\treturn {};\n\tV<vi> tree(4 * ssize(x));\n\treturn inter_helper(deriv(build(tree, 1, begin(x), end(x))), tree, 1, begin(x), end(x), begin(y), end(y));\n} // END HASH",
)

#code-entry(
  name: "power-sum",
  hash: "32d0ba",
  includes: ("lagrange-consecutive",),
  opis: [power_monomial_sum $cal(O)(k log  k)$, power_binomial_sum $cal(O)(k)$. power_monomial_sum(a, k, n) liczy $sum _{i=0}^{n-1} a^i dot  i^k$, power_binomial_sum(a, k, n) liczy $sum _{i=0}^{n-1} a^i dot  binom(i , k)$. Działa dla $0 <=q n$ oraz $a != 1$.],
  lang: "cpp",
  code: "// BEGIN HASH 74870f\nint power_monomial_sum(int a, int k, int n) {\n\tif (n == 0) return 0;\n\tint p = 1, b = 1, c = 0, d = a, inva = inv(a);\n\tvi v(k + 1, k == 0);\n\tFOR(i, 1, k) v[i] = add(v[i - 1], mul(p = mul(p, a), powi(i, k)));\n\tBinomCoeff bc(k + 1);\n\tREP(i, k + 1) {\n\t\tc = add(c, mul(bc(k + 1, i), mul(v[k - i], b)));\n\t\tb = mul(b, sub(0, a));\n\t}\n\tc = mul(c, inv(powi(sub(1, a), k + 1)));\n\tREP(i, k + 1) v[i] = mul(sub(v[i], c), d = mul(d, inva));\n\treturn add(c, mul(lagrange_consecutive(v, n - 1), powi(a, n - 1)));\n} // END HASH\n// BEGIN HASH 7f9702\nint power_binomial_sum(int a, int k, int n) {\n\tint p = powi(a, n), inva1 = inv(sub(a, 1)), binom = 1, ans = 0;\n\tBinomCoeff bc(k + 1);\n\tREP(i, k + 1) {\n\t\tans = sub(mul(p, binom), mul(ans, a));\n\t\tif(!i) ans = sub(ans, 1);\n\t\tans = mul(ans, inva1);\n\t\tbinom = mul(binom, mul(n - i, mul(bc.rev[i + 1], bc.fac[i])));\n\t}\n\treturn ans;\n} // END HASH",
)

#code-entry(
  name: "primitive-root",
  hash: "9f409a",
  includes: ("simple-modulo", "rho-pollard",),
  opis: [$cal(O)(log ^2(mod))$, dla pierwszego $mod$ znajduje generator modulo $mod$ (z być może sporą stałą).],
  lang: "cpp",
  code: "int primitive_root() {\n\tif(mod == 2)\n\t\treturn 1;\n\tint q = mod - 1;\n\tvll v = factor(q);\n\tvi fact;\n\tREP(i, ssize(v))\n\t\tif(!i or v[i] != v[i - 1])\n\t\t\tfact.eb(v[i]);\n\twhile(true) {\n\t\tint g = rd(2, q);\n\t\tauto is_good = [&] {\n\t\t\tfor(auto &f : fact)\n\t\t\t\tif(powi(g, q / f) == 1)\n\t\t\t\t\treturn false;\n\t\t\treturn true;\n\t\t};\n\t\tif(is_good())\n\t\t\treturn g;\n\t}\n}",
)

#code-entry(
  name: "pythagorean-triples",
  hash: "a0b5a2",
  includes: (),
  opis: [Wyznacza wszystkie trójki $(a, b, c)$ takie, że $a^2+b^2=c^2$, $gcd(a, b, c) = 1$ oraz $c <=q "limit"$. Zwraca tylko jedną z $(a, b, c)$ oraz $(b, a, c)$.],
  lang: "cpp",
  code: "V<tuple<int, int, int>> pythagorean_triples(int limit) {\n\tV<tuple<int, int, int>> ret;\n\tfunction<void(int, int, int)> gen = [&](int a, int b, int c) {\n\t\tif (c > limit)\n\t\t\treturn;\n\t\tret.eb(a, b, c);\n\t\tREP(i, 3) {\n\t\t\tgen(a + 2 * b + 2 * c, 2 * a + b + 2 * c, 2 * a + 2 * b + 3 * c);\n\t\t\ta = -a;\n\t\t\tif (i) b = -b;\n\t\t}\n\t};\n\tgen(3, 4, 5);\n\treturn ret;\n}",
)

#code-entry(
  name: "rho-pollard",
  hash: "db8f43",
  includes: ("miller-rab",),
  opis: [$cal(O)(n\^{}(1)/(4))$, `factor(n)` zwraca V dzielników pierwszych $n$, niekoniecznie posortowany, `get_pairs(n)` zwraca posortowany V par (dzielnik pierwszych, krotność) dla liczby $n$, `all_factors(n)` zwraca V wszystkich dzielników $n$, niekoniecznie posortowany, `factor(12) = {2, 2, 3\`, factor(545423) = {53, 41, 251};}, `get_pairs(12) = {(2, 2), (3, 1)\`}, `all_factors(12) = {1, 3, 2, 6, 4, 12\`}.],
  lang: "cpp",
  code: "// BEGIN HASH 6d1d12\nll rho_pollard(ll n) {\n\tif(n % 2 == 0) return 2;\n\tfor(ll i = 1;; i++) {\n\t\tauto f = [&](ll x) { return (llmul(x, x, n) + i) % n; };\n\t\tll x = 2, y = f(x), p;\n\t\twhile((p = __gcd(n - x + y, n)) == 1)\n\t\t\tx = f(x), y = f(f(y));\n\t\tif(p != n) return p;\n\t}\n}\nvll factor(ll n) {\n\tif(n == 1) return {};\n\tif(miller_rabin(n)) return {n};\n\tll x = rho_pollard(n);\n\tauto l = factor(x), r = factor(n / x);\n\tl.insert(l.end(), r.begin(), r.end());\n\treturn l;\n} // END HASH\nV<pair<ll, int>> get_pairs(ll n) {\n\tauto v = factor(n);\n\tsort(all(v));\n\tV<pair<ll, int>> ret;\n\tREP(i, ssize(v)) {\n\t\tint x = i + 1;\n\t\twhile (x < ssize(v) and v[x] == v[i])\n\t\t\t++x;\n\t\tret.eb(v[i], x - i);\n\t\ti = x - 1;\n\t}\n\treturn ret;\n}\nvll all_factors(ll n) {\n\tauto v = get_pairs(n);\n\tvll ret;\n\tfunction<void(ll,int)> gen = [&](ll val, int p) {\n\t\tif (p == ssize(v)) {\n\t\t\tret.eb(val);\n\t\t\treturn;\n\t\t}\n\t\tauto [x, cnt] = v[p];\n\t\tgen(val, p + 1);\n\t\tREP(i, cnt) {\n\t\t\tval *= x;\n\t\t\tgen(val, p + 1);\n\t\t}\n\t};\n\tgen(1, 0);\n\treturn ret;\n}",
)

#code-entry(
  name: "same-div",
  hash: "94bc3b",
  includes: (),
  opis: [$cal(O)(sqrt(n))$, wyznacza przedziały o takiej samej wartości $floor( n / x)$ lub $ceil( n / x)$. `same_floor(8) = {(1, 1), (2, 2), (3, 4), (5, 8)\`}, `same_ceil(8) = {(8, 8), (4, 7), (3, 3), (2, 2), (1, 1)\`}, na konteście raczej checemy przepisać tylko pętlę i od razu wykonywać obliczenia na parze (l, r) zamiast grupować wszyskie przedziały w vectorze. Dla $n$ będącego intem można zmienić wszystkie ll na int, w celu zbicia stałej.],
  lang: "cpp",
  code: "// BEGIN HASH 0022a0\nV<pair<ll, ll>> same_floor(ll n) {\n\tV<pair<ll, ll>> v;\n\tfor (ll l = 1, r; l <= n; l = r + 1) {\n\t\tr = n / (n / l);\n\t\tv.eb(l, r);\n\t}\n\treturn v;\n} // END HASH\n// BEGIN HASH 766533\nV<pair<ll, ll>> same_ceil(ll n) {\n\tV<pair<ll, ll>> v;\n\tfor (ll r = n, l; r >= 1; r = l - 1) {\n\t\tl = (n + r - 1) / r;\n\t\tl = (n + l - 1) / l;\n\t\tv.eb(l, r);\n\t}\n\treturn v;\n} // END HASH",
)

#code-entry(
  name: "sieve",
  hash: "a101b7",
  includes: (),
  opis: [$cal(O)(n)$, `sieve(n)` przetwarza liczby do $n$ włącznie, `comp[i]` oznacza czy $i$ jest złożone, `primes` zawiera wszystkie liczby pierwsze `<= n`, `prime_div[i]` zawiera najmniejszy dzielnik pierwszy $i$, na CF dla $n = 10^8$ działa w 1.2s.],
  lang: "cpp",
  code: "V<bool> comp;\nvi primes, prime_div;\nvoid sieve(int n) {\n\tprimes.clear();\n\tcomp.resize(n + 1);\n\tprime_div.resize(n + 1);\n\tFOR(i, 2, n) {\n\t\tif (!comp[i]) primes.eb(i), prime_div[i] = i;\n\t\tfor (int p : primes) {\n\t\t\tint x = i * p;\n\t\t\tif (x > n) break;\n\t\t\tcomp[x] = true;\n\t\t\tprime_div[x] = p;\n\t\t\tif (i % p == 0) break;\n\t\t}\n\t}\n}",
)

#code-entry(
  name: "simple-modulo",
  hash: "03c593",
  includes: (),
  opis: [podstawowe operacje na modulo, pamiętać o constexpr.],
  lang: "cpp",
  code: "// BEGIN HASH 6b9273\n#ifdef CHANGABLE_MOD\nint mod = 998'244'353;\n#else\nconstexpr int mod = 998'244'353;\n#endif\nint add(int a, int b) {\n\ta += b;\n\treturn a >= mod ? a - mod : a;\n}\nint sub(int a, int b) {\n\treturn add(a, mod - b);\n}\nint mul(int a, int b) {\n\treturn int(a * ll(b) % mod);\n}\nint powi(int a, int b) {\n\tfor(int ret = 1;; b /= 2) {\n\t\tif(b == 0)\n\t\t\treturn ret;\n\t\tif(b & 1)\n\t\t\tret = mul(ret, a);\n\t\ta = mul(a, a);\n\t}\n}\nint inv(int x) {\n\treturn powi(x, mod - 2);\n} // END HASH\nstruct BinomCoeff {\n\tvi fac, rev;\n\tBinomCoeff(int n) {\n\t\tfac = rev = V(n + 1, 1);\n\t\tFOR(i, 1, n) fac[i] = mul(fac[i - 1], i);\n\t\trev[n] = inv(fac[n]);\n\t\tfor(int i = n; i > 0; --i)\n\t\t\trev[i - 1] = mul(rev[i], i);\n\t}\n\tint operator()(int n, int k) {\n\t\treturn mul(fac[n], mul(rev[n - k], rev[k]));\n\t}\n};",
)

#code-entry(
  name: "simplex",
  hash: "37993a",
  includes: (),
  opis: [$cal(O)("szybko")$, `Simplex(n, m)` tworzy lpsolver z $n$ zmiennymi oraz $m$ ograniczeniami, rozwiązuje $"ma" x  c x$ przy $A x <=q b$.],
  lang: "cpp",
  code: "#define FIND(n, expr) [&] { REP(i, n) if(expr) return i; return -1; }()\nstruct Simplex {\n\tusing T = double;\n\tC T eps = 1e-9, inf = 1/.0;\n\tint n, m;\n\tvi N, B;\n\tV<V<T>> A;\n\tV<T> b, c;\n\tT res = 0;\n\tSimplex(int vars, int eqs)\n\t\t: n(vars), m(eqs), N(n), B(m), A(m, V<T>(n)), b(m), c(n) {\n\t\tREP(i, n) N[i] = i;\n\t\tREP(i, m) B[i] = n + i;\n\t}\n\tvoid pivot(int eq, int var) {\n\t\tT coef = 1 / A[eq][var], k;\n\t\tREP(i, n)\n\t\t\tif(abs(A[eq][i]) > eps) A[eq][i] *= coef;\n\t\tA[eq][var] *= coef, b[eq] *= coef;\n\t\tREP(r, m) if(r != eq && abs(A[r][var]) > eps) {\n\t\t\tk = -A[r][var], A[r][var] = 0;\n\t\t\tREP(i, n) A[r][i] += k * A[eq][i];\n\t\t\tb[r] += k * b[eq];\n\t\t}\n\t\tk = c[var], c[var] = 0;\n\t\tREP(i, n) c[i] -= k * A[eq][i];\n\t\tres += k * b[eq];\n\t\tswap(B[eq], N[var]);\n\t}\n\tbool solve() {\n\t\tint eq, var;\n\t\twhile(true) {\n\t\t\tif((eq = FIND(m, b[i] < -eps)) == -1) break;\n\t\t\tif((var = FIND(n, A[eq][i] < -eps)) == -1) {\n\t\t\t\tres = -inf; // no solution\n\t\t\t\treturn false;\n\t\t\t}\n\t\t\tpivot(eq, var);\n\t\t}\n\t\twhile(true) {\n\t\t\tif((var = FIND(n, c[i] > eps)) == -1) break;\n\t\t\teq = -1;\n\t\t\tREP(i, m) if(A[i][var] > eps\n\t\t\t\t&& (eq == -1 || b[i] / A[i][var] < b[eq] / A[eq][var]))\n\t\t\t\teq = i;\n\t\t\tif(eq == -1) {\n\t\t\t\tres = inf; // unbound\n\t\t\t\treturn false;\n\t\t\t}\n\t\t\tpivot(eq, var);\n\t\t}\n\t\treturn true;\n\t}\n\tV<T> get_vars() {\n\t\tV<T> vars(n);\n\t\tREP(i, m)\n\t\t\tif(B[i] < n) vars[B[i]] = b[i];\n\t\treturn vars;\n\t}\n};",
)

#code-entry(
  name: "tonelli-shanks",
  hash: "4e1b15",
  includes: (),
  opis: [$cal(O)(log ^2(p))$), dla pierwszego $p$ oraz $0 <= a <= p - 1$ znajduje takie $x$, że $x^2 "equiv" a mod {p}$ lub $-1$ jeżeli takie $x$ nie istnieje, można przepisać by działało dla ll],
  lang: "cpp",
  code: "int mul(int a, int b, int p) {\n\treturn int(a * ll(b) % p);\n}\nint powi(int a, int b, int p) {\n\tfor (int ret = 1;; b /= 2) {\n\t\tif (!b) return ret;\n\t\tif (b & 1) ret = mul(ret, a, p);\n\t\ta = mul(a, a, p);\n\t}\n}\nint tonelli_shanks(int a, int p) {\n\tif (a == 0) return 0;\n\tif (p == 2) return 1;\n\tif (powi(a, p / 2, p) != 1) return -1;\n\tint q = p - 1, s = 0, z = 2;\n\twhile (q % 2 == 0) q /= 2, ++s;\n\twhile (powi(z, p / 2, p) == 1) ++z;\n\tint c = powi(z, q, p), t = powi(a, q, p);\n\tint r = powi(a, q / 2 + 1, p);\n\twhile (t != 1) {\n\t\tint i = 0, x = t;\n\t\twhile (x != 1) x = mul(x, x, p), ++i;\n\t\tc = powi(c, 1 << (s - i - 1), p); // 1ll dla ll\n\t\tr = mul(r, c, p), c = mul(c, c, p);\n\t\tt = mul(t, c, p), s = i;\n\t}\n\treturn r;\n}",
)

#code-entry(
  name: "xor-base",
  hash: "788707",
  includes: (),
  opis: [$cal(O)("nB"+B^2)$ dla $B="bits"$, dla $S$ wyznacza minimalny zbiór $B$ taki, że każdy element $S$ można zapisać jako xor jakiegoś podzbioru $B$.],
  lang: "cpp",
  code: "int highest_bit(int ai) {\n\treturn ai == 0 ? 0 : __lg(ai) + 1;\n}\nconstexpr int bits = 30;\nvi xor_base(vi elems) {\n\tV<vi> at_bit(bits + 1);\n\tfor(int ai : elems)\n\t\tat_bit[highest_bit(ai)].eb(ai);\n\tfor(int b = bits; b >= 1; --b)\n\t\twhile(ssize(at_bit[b]) > 1) {\n\t\t\tint ai = at_bit[b].back();\n\t\t\tat_bit[b].pop_back();\n\t\t\tai ^= at_bit[b].back();\n\t\t\tat_bit[highest_bit(ai)].eb(ai);\n\t\t}\n\tat_bit.erase(at_bit.begin());\n\tREP(b0, bits - 1)\n\t\tfor(int a0 : at_bit[b0])\n\t\t\tFOR(b1, b0 + 1, bits - 1)\n\t\t\t\tfor(int &a1 : at_bit[b1])\n\t\t\t\t\tif((a1 >> b0) & 1)\n\t\t\t\t\t\ta1 ^= a0;\n\tvi ret;\n\tfor(auto &v : at_bit) {\n\t\tassert(ssize(v) <= 1);\n\t\tfor(int ai : v)\n\t\t\tret.eb(ai);\n\t}\n\treturn ret;\n}",
)

#my-chapter("Struktury danych")

#code-entry(
  name: "associative-queue",
  hash: "dd244e",
  includes: (),
  opis: [Kolejka wspierająca dowolną operację łączną, $cal(O)(1)$ zamortyzowany. Konstruktor przyjmuje dwuargumentową funkcję oraz jej element neutralny. Dla minów jest `AssocQueue<int> q([](int a, int b){ return min(a, b); \`, numeric_limits<int>::max());}],
  lang: "cpp",
  code: "template<typename T>\nstruct AssocQueue {\n\tusing fn = function<T(T, T)>;\n\tfn f;\n\tV<pair<T, T>> s1, s2; // {x, f(pref)}\n\tAssocQueue(fn _f, T e = T()) : f(_f), s1({{e, e}}), s2({{e, e}}) {}\n\tvoid mv() {\n\t\tif (ssize(s2) == 1)\n\t\t\twhile (ssize(s1) > 1) {\n\t\t\t\ts2.eb(s1.back().fi, f(s1.back().fi, s2.back().se));\n\t\t\t\ts1.pop_back();\n\t\t\t}\n\t}\n\tvoid emplace(T x) {\n\t\ts1.eb(x, f(s1.back().se, x));\n\t}\n\tvoid pop() {\n\t\tmv();\n\t\ts2.pop_back();\n\t}\n\tT calc() {\n\t\treturn f(s2.back().se, s1.back().se);\n\t}\n\tT front() {\n\t\tmv();\n\t\treturn s2.back().fi;\n\t}\n\tint size() {\n\t\treturn ssize(s1) + ssize(s2) - 2;\n\t}\n\tvoid clear() {\n\t\ts1.resize(1);\n\t\ts2.resize(1);\n\t}\n};",
)

#code-entry(
  name: "fenwick-tree-2d",
  hash: "fefc31",
  includes: ("fenwick-tree",),
  opis: [$cal(O)(log ^2 n)$, pamięć $cal(O)(n log  n)$, 2D offline, wywołujemy `preprocess(x, y)` na pozycjach, które chcemy updateować, później `init()`. `update(x, y, val)` dodaje `val` do $[x, y]$, `query(x, y)` zwraca sumę na prostokącie $(0, 0) - (x, y)$.],
  lang: "cpp",
  code: "struct Fenwick2d {\n\tV<vi> ys;\n\tV<Fenwick> ft;\n\tFenwick2d(int limx) : ys(limx) {}\n\tvoid preprocess(int x, int y) {\n\t\tfor(; x < ssize(ys); x |= x + 1)\n\t\t\tys[x].pb(y);\n\t}\n\tvoid init() {\n\t\tfor(auto &v : ys) {\n\t\t\tsort(all(v));\n\t\t\tft.eb(ssize(v));\n\t\t}\n\t}\n\tint ind(int x, int y) {\n\t\tauto it = lower_bound(all(ys[x]), y);\n\t\treturn int(distance(ys[x].begin(), it));\n\t}\n\tvoid update(int x, int y, ll val) {\n\t\tfor(; x < ssize(ys); x |= x + 1)\n\t\t\tft[x].update(ind(x, y), val);\n\t}\n\tll query(int x, int y) {\n\t\tll sum = 0;\n\t\tfor(x++; x > 0; x &= x - 1)\n\t\t\tsum += ft[x - 1].query(ind(x - 1, y + 1) - 1);\n\t\treturn sum;\n\t}\n};",
)

#code-entry(
  name: "fenwick-tree",
  hash: "7cfd2b",
  includes: (),
  opis: [$cal(O)(log  n)$, indeksowane od 0, `update(pos, val)` dodaje `val` do elementu `pos`, `query(pos)` zwraca sumę $[0, "pos"]$.],
  lang: "cpp",
  code: "struct Fenwick {\n\tvll s;\n\tFenwick(int n) : s(n) {}\n\tvoid update(int pos, ll val) {\n\t\tfor(; pos < ssize(s); pos |= pos + 1)\n\t\t\ts[pos] += val;\n\t}\n\tll query(int pos) {\n\t\tll ret = 0;\n\t\tfor(pos++; pos > 0; pos &= pos - 1)\n\t\t\tret += s[pos - 1];\n\t\treturn ret;\n\t}\n\tll query(int l, int r) {\n\t\treturn query(r) - query(l - 1);\n\t}\n};",
)

#code-entry(
  name: "find-union",
  hash: "22834c",
  includes: (),
  opis: [$cal(O)(alpha (n))$, mniejszy do wiekszego.],
  lang: "cpp",
  code: "struct FindUnion {\n\tvi rep;\n\tint size(int x) { return -rep[find(x)]; }\n\tint find(int x) {\n\t\treturn rep[x] < 0 ? x : rep[x] = find(rep[x]);\n\t}\n\tbool same_set(int a, int b) { return find(a) == find(b); }\n\tbool join(int a, int b) {\n\t\ta = find(a), b = find(b);\n\t\tif(a == b)\n\t\t\treturn false;\n\t\tif(-rep[a] < -rep[b])\n\t\t\tswap(a, b);\n\t\trep[a] += rep[b];\n\t\trep[b] = a;\n\t\treturn true;\n\t}\n\tFindUnion(int n) : rep(n, -1) {}\n};",
)

#code-entry(
  name: "hash-map",
  hash: "a87164",
  includes: ("<ext/pb_ds/assoc_container.hpp>",),
  opis: [$cal(O)(1)$, trzeba przed includem dać undef `_GLIBCXX_DEBUG`.],
  lang: "cpp",
  code: "using namespace __gnu_pbds;\nstruct chash {\n\tC uint64_t c = ll(2e18 * acosl(-1)) + 69;\n\tC int RANDOM = mt19937(0)();\n\tsize_t operator()(uint64_t x) C {\n\t\treturn __builtin_bswap64((x^RANDOM) * c);\n\t}\n};\ntemplate<class L, class R>\nusing hash_map = gp_hash_table<L, R, chash>;",
)

#code-entry(
  name: "lazy-segment-tree",
  hash: "0ec085",
  includes: (),
  opis: [Drzewo przedział-przedział, w miarę abstrakcyjne. Wystarczy zmienić `Node` i funkcje na nim.],
  lang: "cpp",
  code: "// BEGIN HASH 97486f\nstruct Node {\n\tll sum = 0, lazy = 0;\n\tint sz = 1;\n};\nvoid push_to_sons(Node &n, Node &l, Node &r) {\n\tauto push_to_son = [&](Node &c) {\n\t\tc.sum += n.lazy * c.sz;\n\t\tc.lazy += n.lazy;\n\t};\n\tpush_to_son(l);\n\tpush_to_son(r);\n\tn.lazy = 0;\n}\nNode merge(Node l, Node r) {\n\treturn Node{\n\t\t.sum = l.sum + r.sum,\n\t\t.lazy = 0,\n\t\t.sz = l.sz + r.sz\n\t};\n}\nvoid add_to_base(Node &n, int val) {\n\tn.sum += n.sz * ll(val);\n\tn.lazy += val;\n} // END HASH\n// BEGIN HASH f78ac3\nstruct Tree {\n\tV<Node> tree;\n\tint sz = 1;\n\tTree(int n) {\n\t\twhile(sz < n)\n\t\t\tsz *= 2;\n\t\ttree.resize(sz * 2);\n\t\tfor(int v = sz - 1; v >= 1; v--)\n\t\t\ttree[v] = merge(tree[2 * v], tree[2 * v + 1]);\n\t}\n\tvoid push(int v) {\n\t\tpush_to_sons(tree[v], tree[2 * v], tree[2 * v + 1]);\n\t}\n\tNode get(int l, int r, int v = 1) {\n\t\tif(l == 0 and r == tree[v].sz - 1)\n\t\t\treturn tree[v];\n\t\tpush(v);\n\t\tint m = tree[v].sz / 2;\n\t\tif(r < m)\n\t\t\treturn get(l, r, 2 * v);\n\t\telse if(m <= l)\n\t\t\treturn get(l - m, r - m, 2 * v + 1);\n\t\telse\n\t\t\treturn merge(get(l, m - 1, 2 * v), get(0, r - m, 2 * v + 1));\n\t}\n\tvoid update(int l, int r, int val, int v = 1) {\n\t\tif(l == 0 && r == tree[v].sz - 1) {\n\t\t\tadd_to_base(tree[v], val);\n\t\t\treturn;\n\t\t}\n\t\tpush(v);\n\t\tint m = tree[v].sz / 2;\n\t\tif(r < m)\n\t\t\tupdate(l, r, val, 2 * v);\n\t\telse if(m <= l)\n\t\t\tupdate(l - m, r - m, val, 2 * v + 1);\n\t\telse {\n\t\t\tupdate(l, m - 1, val, 2 * v);\n\t\t\tupdate(0, r - m, val, 2 * v + 1);\n\t\t}\n\t\ttree[v] = merge(tree[2 * v], tree[2 * v + 1]);\n\t}\n}; // END HASH",
)

#code-entry(
  name: "lichao-tree",
  hash: "dec5d3",
  includes: (),
  opis: [Dla funkcji, których pary przecinają się co najwyżej raz, oblicza minimum w punkcie $x$. Podany kod jest dla funkcji liniowych.],
  lang: "cpp",
  code: "struct Function {\n\tint a;\n\tll b;\n\tll operator()(int x) {\n\t\treturn x * ll(a) + b;\n\t}\n\tFunction(int p = 0, ll q = infll) : a(p), b(q) {}\n};\nostream& operator<<(ostream &os, Function f) {\n\treturn os << pair(f.a, f.b);\n}\nstruct LiChaoTree {\n\tint size = 1;\n\tV<Function> tree;\n\tLiChaoTree(int n) {\n\t\twhile(size < n)\n\t\t\tsize *= 2;\n\t\ttree.resize(size << 1);\n\t}\n\tll get_min(int x) {\n\t\tint v = x + size;\n\t\tll ans = infll;\n\t\twhile(v) {\n\t\t\tchmin(ans, tree[v](x));\n\t\t\tv >>= 1;\n\t\t}\n\t\treturn ans;\n\t}\n\tvoid add_func(Function new_func, int v, int l, int r) {\n\t\tint m = (l + r) / 2;\n\t\tbool domin_l = tree[v](l) > new_func(l),\n\t\t\t domin_m = tree[v](m) > new_func(m);\n\t\tif(domin_m)\n\t\t\tswap(tree[v], new_func);\n\t\tif(l == r)\n\t\t\treturn;\n\t\telse if(domin_l == domin_m)\n\t\t\tadd_func(new_func, v << 1 | 1, m + 1, r);\n\t\telse\n\t\t\tadd_func(new_func, v << 1, l, m);\n\t}\n\tvoid add_func(Function new_func) {\n\t\tadd_func(new_func, 1, 0, size - 1);\n\t}\n};",
)

#code-entry(
  name: "line-container",
  hash: "5316a7",
  includes: (),
  opis: [$cal(O)(log  n)$ set dla funkcji liniowych, `add(a, b)` dodaje funkcję $y = a x + b$ `query(x)` zwraca największe $y$ w punkcie $x$.],
  lang: "cpp",
  code: "struct Line {\n\tmutable ll a, b, p;\n\tll eval(ll x) C { return a * x + b; }\n\tbool operator<(C Line & o) C { return a < o.a; }\n\tbool operator<(ll x) C { return p < x; }\n};\nstruct LineContainer : multiset<Line, less<>> {\n\t// jak double to inf = 1 / .0, div(a, b) = a / b\n\tC ll inf = LLONG_MAX;\n\tll div(ll a, ll b) { return a / b - ((a ^ b) < 0 && a % b); }\n\tbool intersect(iterator x, iterator y) {\n\t\tif(y == end()) { x->p = inf; return false; }\n\t\tif(x->a == y->a) x->p = x->b > y->b ? inf : -inf;\n\t\telse x->p = div(y->b - x->b, x->a - y->a);\n\t\treturn x->p >= y->p;\n\t}\n\tvoid add(ll a, ll b) {\n\t\tauto z = insert({a, b, 0}), y = z++, x = y;\n\t\twhile(intersect(y, z)) z = erase(z);\n\t\tif(x != begin() && intersect(--x, y))\n\t\t\tintersect(x, erase(y));\n\t\twhile((y = x) != begin() && (--x)->p >= y->p)\n\t\t\tintersect(x, erase(y));\n\t}\n\tll query(ll x) {\n\t\tassert(!empty());\n\t\treturn lower_bound(x)->eval(x);\n\t}\n};",
)

#code-entry(
  name: "link-cut",
  hash: "d3d041",
  includes: (),
  opis: [$cal(O)(q log  n)$ Link-Cut Tree z wyznaczaniem odległości między wierzchołkami, lca w zakorzenionym drzewie, dodawaniem na ścieżce, dodawaniem na poddrzewie, zwracaniem sumy na ścieżce, zwracaniem sumy na poddrzewie. Przepisać co się chce (logika lazy jest tylko w `AdditionalInfo`, można np. zostawić puste funkcje). Wywołać konstruktor, potem `set_value` na wierzchołkach (aby się ustawiło, że nie-nil to nie-nil) i potem jazda.],
  lang: "cpp",
  code: "struct AdditionalInfo {\n\tusing T = ll;\n\tstatic constexpr T neutral = 0; // Remember that there is a nil vertex!\n\tT node_value = neutral, splay_value = neutral;//, splay_value_reversed = neutral;\n\tT whole_subtree_value = neutral, virtual_value = neutral;\n\tT splay_lazy = neutral; // lazy propagation on paths\n\tT splay_size = 0; // 0 because of nil\n\tT whole_subtree_lazy = neutral, whole_subtree_cancel = neutral; // lazy propagation on subtrees\n\tT whole_subtree_size = 0, virtual_size = 0; // 0 because of nil\n\tvoid set_value(T x) {\n\t\tnode_value = splay_value = whole_subtree_value = x;\n\t\tsplay_size = 1;\n\t\twhole_subtree_size = 1;\n\t}\n\tvoid update_from_sons(AdditionalInfo &l, AdditionalInfo &r) {\n\t\tsplay_value = l.splay_value + node_value + r.splay_value;\n\t\tsplay_size = l.splay_size + 1 + r.splay_size;\n\t\twhole_subtree_value = l.whole_subtree_value + node_value + virtual_value + r.whole_subtree_value;\n\t\twhole_subtree_size = l.whole_subtree_size + 1 + virtual_size + r.whole_subtree_size;\n\t}\n\tvoid change_virtual(AdditionalInfo &virtual_son, int delta) {\n\t\tassert(delta == -1 or delta == 1);\n\t\tvirtual_value += delta * virtual_son.whole_subtree_value;\n\t\twhole_subtree_value += delta * virtual_son.whole_subtree_value;\n\t\tvirtual_size += delta * virtual_son.whole_subtree_size;\n\t\twhole_subtree_size += delta * virtual_son.whole_subtree_size;\n\t}\n\tvoid push_lazy(AdditionalInfo &l, AdditionalInfo &r, bool) {\n\t\tl.add_lazy_in_path(splay_lazy);\n\t\tr.add_lazy_in_path(splay_lazy);\n\t\tsplay_lazy = 0;\n\t}\n\tvoid cancel_subtree_lazy_from_parent(AdditionalInfo &parent) {\n\t\twhole_subtree_cancel = parent.whole_subtree_lazy;\n\t}\n\tvoid pull_lazy_from_parent(AdditionalInfo &parent) {\n\t\tif(splay_size == 0) // nil\n\t\t\treturn;\n\t\tadd_lazy_in_subtree(parent.whole_subtree_lazy - whole_subtree_cancel);\n\t\tcancel_subtree_lazy_from_parent(parent);\n\t}\n\tT get_path_sum() {\n\t\treturn splay_value;\n\t}\n\tT get_subtree_sum() {\n\t\treturn whole_subtree_value;\n\t}\n\tvoid add_lazy_in_path(T x) {\n\t\tsplay_lazy += x;\n\t\tnode_value += x;\n\t\tsplay_value += x * splay_size;\n\t\twhole_subtree_value += x * splay_size;\n\t}\n\tvoid add_lazy_in_subtree(T x) {\n\t\twhole_subtree_lazy += x;\n\t\tnode_value += x;\n\t\tsplay_value += x * splay_size;\n\t\twhole_subtree_value += x * whole_subtree_size;\n\t\tvirtual_value += x * virtual_size;\n\t}\n};\nstruct Splay {\n\tstruct Node {\n\t\tarray<int, 2> child;\n\t\tint parent;\n\t\tint subsize_splay = 1;\n\t\tbool lazy_flip = false;\n\t\tAdditionalInfo info;\n\t};\n\tV<Node> t;\n\tC int nil;\n\tSplay(int n)\n\t: t(n + 1), nil(n) {\n\t\tt[nil].subsize_splay = 0;\n\t\tfor(Node &v : t)\n\t\t\tv.child[0] = v.child[1] = v.parent = nil;\n\t}\n\tvoid apply_lazy_and_push(int v) {\n\t\tauto &[l, r] = t[v].child;\n\t\tif(t[v].lazy_flip) {\n\t\t\tfor(int c : {l, r})\n\t\t\t\tt[c].lazy_flip ^= 1;\n\t\t\tswap(l, r);\n\t\t}\n\t\tt[v].info.push_lazy(t[l].info, t[r].info, t[v].lazy_flip);\n\t\tfor(int c : {l, r})\n\t\t\tif(c != nil)\n\t\t\t\tt[c].info.pull_lazy_from_parent(t[v].info);\n\t\tt[v].lazy_flip = false;\n\t}\n\tvoid update_from_sons(int v) {\n\t\t// assumes that v's info is pushed\n\t\tauto [l, r] = t[v].child;\n\t\tt[v].subsize_splay = t[l].subsize_splay + 1 + t[r].subsize_splay;\n\t\tfor(int c : {l, r})\n\t\t\tapply_lazy_and_push(c);\n\t\tt[v].info.update_from_sons(t[l].info, t[r].info);\n\t}\n\t// After that, v is pushed and updated\n\tvoid splay(int v) {\n\t\tapply_lazy_and_push(v);\n\t\tauto set_child = [&](int x, int c, int d) {\n\t\t\tif(x != nil and d != -1)\n\t\t\t\tt[x].child[d] = c;\n\t\t\tif(c != nil) {\n\t\t\t\tt[c].parent = x;\n\t\t\t\tt[c].info.cancel_subtree_lazy_from_parent(t[x].info);\n\t\t\t}\n\t\t};\n\t\tauto get_dir = [&](int x) -> int {\n\t\t\tint p = t[x].parent;\n\t\t\tif(p == nil or (x != t[p].child[0] and x != t[p].child[1]))\n\t\t\t\treturn -1;\n\t\t\treturn t[p].child[1] == x;\n\t\t};\n\t\tauto rotate = [&](int x, int d) {\n\t\t\tint p = t[x].parent, c = t[x].child[d];\n\t\t\tassert(c != nil);\n\t\t\tset_child(p, c, get_dir(x));\n\t\t\tset_child(x, t[c].child[!d], d);\n\t\t\tset_child(c, x, !d);\n\t\t\tupdate_from_sons(x);\n\t\t\tupdate_from_sons(c);\n\t\t};\n\t\twhile(get_dir(v) != -1) {\n\t\t\tint p = t[v].parent, pp = t[p].parent;\n\t\t\tarray path_up = {v, p, pp, t[pp].parent};\n\t\t\tfor(int i = ssize(path_up) - 1; i >= 0; --i) {\n\t\t\t\tif(i < ssize(path_up) - 1)\n\t\t\t\t\tt[path_up[i]].info.pull_lazy_from_parent(t[path_up[i + 1]].info);\n\t\t\t\tapply_lazy_and_push(path_up[i]);\n\t\t\t}\n\t\t\tint dp = get_dir(v), dpp = get_dir(p);\n\t\t\tif(dpp == -1)\n\t\t\t\trotate(p, dp);\n\t\t\telse if(dp == dpp) {\n\t\t\t\trotate(pp, dpp);\n\t\t\t\trotate(p, dp);\n\t\t\t}\n\t\t\telse {\n\t\t\t\trotate(p, dp);\n\t\t\t\trotate(pp, dpp);\n\t\t\t}\n\t\t}\n\t}\n};\nstruct LinkCut : Splay {\n\tLinkCut(int n) : Splay(n) {}\n\t// Cuts the path from x downward, creates path to root, splays x.\n\tint access(int x) {\n\t\tint v = x, cv = nil;\n\t\tfor(; v != nil; cv = v, v = t[v].parent) {\n\t\t\tsplay(v);\n\t\t\tint &right = t[v].child[1];\n\t\t\tt[v].info.change_virtual(t[right].info, +1);\n\t\t\tright = cv;\n\t\t\tt[right].info.pull_lazy_from_parent(t[v].info);\n\t\t\tt[v].info.change_virtual(t[right].info, -1);\n\t\t\tupdate_from_sons(v);\n\t\t}\n\t\tsplay(x);\n\t\treturn cv;\n\t}\n\t// Changes the root to v.\n\t// Warning: Linking, cutting, getting the distance, etc, changes the root.\n\tvoid reroot(int v) {\n\t\taccess(v);\n\t\tt[v].lazy_flip ^= 1;\n\t\tapply_lazy_and_push(v);\n\t}\n\t// Returns the root of tree containing v.\n\tint get_leader(int v) {\n\t\taccess(v);\n\t\twhile(apply_lazy_and_push(v), t[v].child[0] != nil)\n\t\t\tv = t[v].child[0];\n\t\tsplay(v);\n\t\treturn v;\n\t}\n\tbool is_in_same_tree(int v, int u) {\n\t\treturn get_leader(v) == get_leader(u);\n\t}\n\t// Assumes that v and u aren't in same tree and v != u.\n\t// Adds edge (v, u) to the forest.\n\tvoid link(int v, int u) {\n\t\treroot(v);\n\t\taccess(u);\n\t\tt[u].info.change_virtual(t[v].info, +1);\n\t\tassert(t[v].parent == nil);\n\t\tt[v].parent = u;\n\t\tt[v].info.cancel_subtree_lazy_from_parent(t[u].info);\n\t}\n\t// Assumes that v and u are in same tree and v != u.\n\t// Cuts edge going from v to the subtree where is u\n\t// (in particular, if there is an edge (v, u), it deletes it).\n\t// Returns the cut parent.\n\tint cut(int v, int u) {\n\t\treroot(u);\n\t\taccess(v);\n\t\tint c = t[v].child[0];\n\t\tassert(t[c].parent == v);\n\t\tt[v].child[0] = nil;\n\t\tt[c].parent = nil;\n\t\tt[c].info.cancel_subtree_lazy_from_parent(t[nil].info);\n\t\tupdate_from_sons(v);\n\t\twhile(apply_lazy_and_push(c), t[c].child[1] != nil)\n\t\t\tc = t[c].child[1];\n\t\tsplay(c);\n\t\treturn c;\n\t}\n\t// Assumes that v and u are in same tree.\n\t// Returns their LCA after a reroot operation.\n\tint lca(int root, int v, int u) {\n\t\treroot(root);\n\t\tif(v == u)\n\t\t\treturn v;\n\t\taccess(v);\n\t\treturn access(u);\n\t}\n\t// Assumes that v and u are in same tree.\n\t// Returns their distance (in number of edges).\n\tint dist(int v, int u) {\n\t\treroot(v);\n\t\taccess(u);\n\t\treturn t[t[u].child[0]].subsize_splay;\n\t}\n\t// Assumes that v and u are in same tree.\n\t// Returns the sum of values on the path from v to u.\n\tauto get_path_sum(int v, int u) {\n\t\treroot(v);\n\t\taccess(u);\n\t\treturn t[u].info.get_path_sum();\n\t}\n\t// Assumes that v and u are in same tree.\n\t// Returns the sum of values on the subtree of v in which u isn't present.\n\tauto get_subtree_sum(int v, int u) {\n\t\tu = cut(v, u);\n\t\tauto ret = t[v].info.get_subtree_sum();\n\t\tlink(v, u);\n\t\treturn ret;\n\t}\n\t// Applies function f on vertex v (useful for a single add/set operation)\n\tvoid apply_on_vertex(int v, function<void (AdditionalInfo&)> f) {\n\t\taccess(v);\n\t\tf(t[v].info);\n\t}\n\t// Assumes that v and u are in same tree.\n\t// Adds val to each vertex in path from v to u.\n\tvoid add_on_path(int v, int u, int val) {\n\t\treroot(v);\n\t\taccess(u);\n\t\tt[u].info.add_lazy_in_path(val);\n\t}\n\t// Assumes that v and u are in same tree.\n\t// Adds val to each vertex in subtree of v that doesn't have u.\n\tvoid add_on_subtree(int v, int u, int val) {\n\t\tu = cut(v, u);\n\t\tt[v].info.add_lazy_in_subtree(val);\n\t\tlink(v, u);\n\t}\n};",
)

#code-entry(
  name: "majorized-set",
  hash: "af8039",
  includes: (),
  opis: [$cal(O)(log  n)$, w `s` jest zmajoryzowany set, `insert(p)` wrzuca parę `p` do setu, majoryzuje go (zamortyzowany czas) i zwraca, czy podany element został dodany.],
  lang: "cpp",
  code: "template<typename A, typename B>\nstruct MajorizedSet {\n\tset<pair<A, B>> s;\n\tbool insert(pair<A, B> p) {\n\t\tauto x = s.lower_bound(p);\n\t\tif (x != s.end() && x->second >= p.se)\n\t\t\treturn false;\n\t\twhile (x != s.begin() && (--x)->second <= p.se)\n\t\t\tx = s.erase(x);\n\t\ts.emplace(p);\n\t\treturn true;\n\t}\n};",
)

#code-entry(
  name: "ordered-set",
  hash: "0a779f",
  includes: ("<ext/pb_ds/assoc_container.hpp>", "<ext/pb_ds/tree_policy.hpp>",),
  opis: [`insert(x)` dodaje element $x$ (nie ma emplace), `find_by_order(i)` zwraca iterator do $i$-tego elementu, `order_of_key(x)` zwraca ile jest mniejszych elementów ($x$ nie musi być w secie). Jeśli chcemy multiseta, to używamy par $("val", "id")$.],
  lang: "cpp",
  code: "using namespace __gnu_pbds;\ntemplate<class T> using ordered_set = tree<\n\tT,\n\tnull_type,\n\tless<T>,\n\trb_tree_tag,\n\ttree_order_statistics_node_update\n>;",
)

#code-entry(
  name: "persistent-treap",
  hash: "19b13c",
  includes: (),
  opis: [$cal(O)(log  n)$ Implict Persistent Treap, wszystko indexowane od 0, `insert(i, val)` insertuję na pozycję $i$, kopiowanie struktury działa w $cal(O)(1)$, robimy sobie `V<Treap>` żeby obsługiwać trwałość UPD. uwaga potencjalnie się kwadraci, spytać Bartka kiedy],
  lang: "cpp",
  code: "mt19937 rng_i(0);\nstruct Treap {\n\tstruct Node {\n\t\tint val, prio, sub = 1;\n\t\tNode *l = nullptr, *r = nullptr;\n\t\tNode(int _val) : val(_val), prio(int(rng_i())) {}\n\t\t~Node() { delete l; delete r; }\n\t};\n\tusing pNode = Node*;\n\tpNode root = nullptr;\n\tint get_sub(pNode n) { return n ? n->sub : 0; }\n\tvoid update(pNode n) {\n\t\tif(!n) return;\n\t\tn->sub = get_sub(n->l) + get_sub(n->r) + 1;\n\t}\n\tvoid split(pNode t, int i, pNode &l, pNode &r) {\n\t\tif(!t) l = r = nullptr;\n\t\telse {\n\t\t\tt = new Node(*t);\n\t\t\tif(i <= get_sub(t->l))\n\t\t\t\tsplit(t->l, i, l, t->l), r = t;\n\t\t\telse\n\t\t\t\tsplit(t->r, i - get_sub(t->l) - 1, t->r, r), l = t;\n\t\t}\n\t\tupdate(t);\n\t}\n\tvoid merge(pNode &t, pNode l, pNode r) {\n\t\tif(!l || !r) t = (l ? l : r);\n\t\telse if(l->prio > r->prio) {\n\t\t\tl = new Node(*l);\n\t\t\tmerge(l->r, l->r, r), t = l;\n\t\t}\n\t\telse {\n\t\t\tr = new Node(*r);\n\t\t\tmerge(r->l, l, r->l), t = r;\n\t\t}\n\t\tupdate(t);\n\t}\n\tvoid insert(pNode &t, int i, pNode it) {\n\t\tif(!t) t = it;\n\t\telse if(it->prio > t->prio)\n\t\t\tsplit(t, i, it->l, it->r), t = it;\n\t\telse {\n\t\t\tt = new Node(*t);\n\t\t\tif(i <= get_sub(t->l))\n\t\t\t\tinsert(t->l, i, it);\n\t\t\telse\n\t\t\t\tinsert(t->r, i - get_sub(t->l) - 1, it);\n\t\t}\n\t\tupdate(t);\n\t}\n\tvoid insert(int i, int val) {\n\t\tinsert(root, i, new Node(val));\n\t}\n\tvoid erase(pNode &t, int i) {\n\t\tif(get_sub(t->l) == i)\n\t\t\tmerge(t, t->l, t->r);\n\t\telse {\n\t\t\tt = new Node(*t);\n\t\t\tif(i <= get_sub(t->l))\n\t\t\t\terase(t->l, i);\n\t\t\telse\n\t\t\t\terase(t->r, i - get_sub(t->l) - 1);\n\t\t}\n\t\tupdate(t);\n\t}\n\tvoid erase(int i) {\n\t\tassert(i < get_sub(root));\n\t\terase(root, i);\n\t}\n};",
)

#code-entry(
  name: "range-add",
  hash: "5283bf",
  includes: ("fenwick-tree",),
  opis: [$cal(O)(log  n)$ drzewo przedział-punkt $(+, +)$, wszystko indexowane od 0, `update(l, r, val)` dodaje val na przedziale $[l, r]$, `query(pos)` zwraca wartość elementu $"pos"$.],
  lang: "cpp",
  code: "struct RangeAdd {\n\tFenwick f;\n\tRangeAdd(int n) : f(n) {}\n\tvoid update(int l, int r, ll val) {\n\t\tf.update(l, val);\n\t\tf.update(r + 1, -val);\n\t}\n\tll query(int pos) {\n\t\treturn f.query(pos);\n\t}\n};",
)

#code-entry(
  name: "rmq",
  hash: "724ad6",
  includes: (),
  opis: [$cal(O)(n log  n)$ czasowo i pamięciowo, Range Minimum Query z użyciem sparse table, zapytanie jest w $cal(O)(1)$.],
  lang: "cpp",
  code: "struct RMQ {\n\tV<vi> st;\n\tRMQ(C vi &a) {\n\t\tint n = ssize(a), lg = 0;\n\t\twhile((1 << lg) < n) lg++;\n\t\tst.resize(lg + 1, a);\n\t\tFOR(i, 1, lg) REP(j, n) {\n\t\t\tst[i][j] = st[i - 1][j];\n\t\t\tint q = j + (1 << (i - 1));\n\t\t\tif(q < n) chmin(st[i][j], st[i - 1][q]);\n\t\t}\n\t}\n\tint query(int l, int r) {\n\t\tint q = __lg(r - l + 1), x = r - (1 << q) + 1;\n\t\treturn min(st[q][l], st[q][x]);\n\t}\n};",
)

#code-entry(
  name: "segment-tree",
  hash: "738e4c",
  includes: (),
  opis: [Drzewa punkt-przedział. Pierwsze ustawia w punkcie i podaje max na przedziale. Drugie maxuje elementy na przedziale i podaje wartość w punkcie.],
  lang: "cpp",
  code: "struct Tree_Get_Max {\n\tusing T = int;\n\tT f(T a, T b) { return max(a, b); }\n\tC T zero = 0;\n\tV<T> tree;\n\tint sz = 1;\n\tTree_Get_Max(int n) {\n\t\twhile(sz < n)\n\t\t\tsz *= 2;\n\t\ttree.resize(sz * 2, zero);\n\t}\n\tvoid update(int pos, T val) {\n\t\ttree[pos += sz] = val;\n\t\twhile(pos /= 2)\n\t\t\ttree[pos] = f(tree[pos * 2], tree[pos * 2 + 1]);\n\t}\n\tT get(int l, int r) {\n\t\tl += sz, r += sz;\n\t\tif(l == r)\n\t\t\treturn tree[l];\n\t\tT ret_l = tree[l], ret_r = tree[r];\n\t\twhile(l + 1 < r) {\n\t\t\tif(l % 2 == 0)\n\t\t\t\tret_l = f(ret_l, tree[l + 1]);\n\t\t\tif(r % 2 == 1)\n\t\t\t\tret_r = f(tree[r - 1], ret_r);\n\t\t\tl /= 2, r /= 2;\n\t\t}\n\t\treturn f(ret_l, ret_r);\n\t}\n};\nstruct Tree_Update_Max_On_Interval {\n\tusing T = int;\n\tV<T> tree;\n\tint sz = 1;\n\tTree_Update_Max_On_Interval(int n) {\n\t\twhile(sz < n)\n\t\t\tsz *= 2;\n\t\ttree.resize(sz * 2);\n\t}\n\tT get(int pos) {\n\t\tT ret = tree[pos += sz];\n\t\twhile(pos /= 2)\n\t\t\tchmax(ret, tree[pos]);\n\t\treturn ret;\n\t}\n\tvoid update(int l, int r, T val) {\n\t\tl += sz, r += sz;\n\t\tchmax(tree[l], val);\n\t\tif(l == r)\n\t\t\treturn;\n\t\tchmax(tree[r], val);\n\t\twhile(l + 1 < r) {\n\t\t\tif(l % 2 == 0)\n\t\t\t\tchmax(tree[l + 1], val);\n\t\t\tif(r % 2 == 1)\n\t\t\t\tchmax(tree[r - 1], val);\n\t\t\tl /= 2, r /= 2;\n\t\t}\n\t}\n};",
)

#code-entry(
  name: "treap",
  hash: "f9c1bb",
  includes: (),
  opis: [$cal(O)(log  n)$ Implict Treap, wszystko indexowane od 0, do Node dopisujemy jakie chcemy mieć trzymać dodatkowo dane. Jeśli chcemy robić lazy, to wykonania push należy wstawić tam gdzie oznaczono komentarzem.],
  lang: "cpp",
  code: "namespace Treap {\n\t// BEGIN HASH\n\tmt19937 rng_key(0);\n\tstruct Node {\n\t\tint prio, cnt = 1;\n\t\tNode *l = nullptr, *r = nullptr;\n\t\tNode() : prio(int(rng_key())) {}\n\t\t~Node() { delete l; delete r; }\n\t};\n\tusing pNode = Node*;\n\tint get_cnt(pNode t) { return t ? t->cnt : 0; }\n\tvoid update(pNode t) {\n\t\tif (!t) return;\n\t\t// push(t);\n\t\tt->cnt = get_cnt(t->l) + get_cnt(t->r) + 1;\n\t}\n\tvoid split(pNode t, int i, pNode &l, pNode &r) {\n\t\tif (!t) {\n\t\t\tl = r = nullptr;\n\t\t\treturn;\n\t\t}\n\t\t// push(t);\n\t\tif (i <= get_cnt(t->l))\n\t\t\tsplit(t->l, i, l, t->l), r = t;\n\t\telse\n\t\t\tsplit(t->r, i - get_cnt(t->l) - 1, t->r, r), l = t;\n\t\tupdate(t);\n\t}\n\tvoid merge(pNode &t, pNode l, pNode r) {\n\t\tif (!l or !r) t = l ?: r;\n\t\telse if (l->prio > r->prio) {\n\t\t\t// push(l);\n\t\t\tmerge(l->r, l->r, r), t = l;\n\t\t}\n\t\telse {\n\t\t\t// push(r);\n\t\t\tmerge(r->l, l, r->l), t = r;\n\t\t}\n\t\tupdate(t);\n\t} // END HASH\n\tvoid apply_on_interval(pNode &root, int l, int r, function<void (pNode)> f) {\n\t\tpNode left, mid, right;\n\t\tsplit(root, r + 1, mid, right);\n\t\tsplit(mid, l, left, mid);\n\t\tassert(l <= r and mid);\n\t\tf(mid);\n\t\tmerge(mid, left, mid);\n\t\tmerge(root, mid, right);\n\t}\n}",
)

#my-chapter("Grafy")

#code-entry(
  name: "2sat",
  hash: "8e707e",
  includes: (),
  opis: [$cal(O)(n+m)$, Zwraca poprawne przyporządkowanie zmiennym logicznym dla problemu 2-SAT, albo mówi, że takie nie istnieje. Konstruktor przyjmuje liczbę zmiennych, $tilde$ oznacza negację zmiennej. Po wywołaniu `solve()`, `values[0..n-1]` zawiera wartości rozwiązania.],
  lang: "cpp",
  code: "struct TwoSat {\n\tint n;\n\tV<vi> gr;\n\tvi values;\n\tTwoSat(int _n = 0) : n(_n), gr(2 * n) {}\n\tvoid either(int f, int j) {\n\t\tf = max(2 * f, -1 - 2 * f);\n\t\tj = max(2 * j, -1 - 2 * j);\n\t\tgr[f].eb(j ^ 1);\n\t\tgr[j].eb(f ^ 1);\n\t}\n\tvoid set_value(int x) { either(x, x); }\n\tvoid implication(int f, int j) { either(~f, j); }\n\tint add_var() {\n\t\tgr.eb();\n\t\tgr.eb();\n\t\treturn n++;\n\t}\n\tvoid at_most_one(vi& li) {\n\t\tif(ssize(li) <= 1) return;\n\t\tint cur = ~li[0];\n\t\tFOR(i, 2, ssize(li) - 1) {\n\t\t\tint next = add_var();\n\t\t\teither(cur, ~li[i]);\n\t\t\teither(cur, next);\n\t\t\teither(~li[i], next);\n\t\t\tcur = ~next;\n\t\t}\n\t\teither(cur, ~li[1]);\n\t}\n\tvi val, comp, z;\n\tint t = 0;\n\tint dfs(int i) {\n\t\tint low = val[i] = ++t, x;\n\t\tz.eb(i);\n\t\tfor(auto &e : gr[i]) if(!comp[e])\n\t\t\tchmin(low, val[e] ?: dfs(e));\n\t\tif(low == val[i]) do {\n\t\t\tx = z.back(); z.pop_back();\n\t\t\tcomp[x] = low;\n\t\t\tif (values[x >> 1] == -1)\n\t\t\t\tvalues[x >> 1] = x & 1;\n\t\t} while (x != i);\n\t\treturn val[i] = low;\n\t}\n\tbool solve() {\n\t\tvalues.assign(n, -1);\n\t\tval.assign(2 * n, 0);\n\t\tcomp = val;\n\t\tREP(i, 2 * n) if(!comp[i]) dfs(i);\n\t\tREP(i, n) if(comp[2 * i] == comp[2 * i + 1]) return 0;\n\t\treturn 1;\n\t}\n};",
)

#code-entry(
  name: "biconnected",
  hash: "8cd55a",
  includes: (),
  opis: [$cal(O)(n+m)$, dwuspójne składowe, mosty oraz punkty artykulacji. po skonstruowaniu, `bicon` = zbiór list id krawędzi, `bridges` = lista id krawędzi będącymi mostami, `arti_points` = lista wierzchołków będącymi punktami artykulacji. Tablice są nieposortowane. Wspiera multikrawędzie i wiele spójnych, ale nie pętle.],
  lang: "cpp",
  code: "struct Low {\n\tV<vi> graph;\n\tvi low, pre;\n\tV<pii> edges;\n\tV<vi> bicon;\n\tvi bicon_stack, arti_points, bridges;\n\tint gtime = 0;\n\tvoid dfs(int v, int p) {\n\t\tlow[v] = pre[v] = gtime++;\n\t\tbool considered_parent = false;\n\t\tint son_count = 0;\n\t\tbool is_arti = false;\n\t\tfor(int e : graph[v]) {\n\t\t\tint u = edges[e].fi ^ edges[e].se ^ v;\n\t\t\tif(u == p and not considered_parent)\n\t\t\t\tconsidered_parent = true;\n\t\t\telse if(pre[u] == -1) {\n\t\t\t\tbicon_stack.eb(e);\n\t\t\t\tdfs(u, v);\n\t\t\t\tchmin(low[v], low[u]);\n\t\t\t\tif(low[u] >= pre[v]) {\n\t\t\t\t\tbicon.eb();\n\t\t\t\t\tdo {\n\t\t\t\t\t\tbicon.back().eb(bicon_stack.back());\n\t\t\t\t\t\tbicon_stack.pop_back();\n\t\t\t\t\t} while(bicon.back().back() != e);\n\t\t\t\t}\n\t\t\t\t++son_count;\n\t\t\t\tif(p != -1 and low[u] >= pre[v])\n\t\t\t\t\tis_arti = true;\n\t\t\t\tif(low[u] > pre[v])\n\t\t\t\t\tbridges.eb(e);\n\t\t\t}\n\t\t\telse if(pre[v] > pre[u]) {\n\t\t\t\tchmin(low[v], pre[u]);\n\t\t\t\tbicon_stack.eb(e);\n\t\t\t}\n\t\t}\n\t\tif(p == -1 and son_count > 1)\n\t\t\tis_arti = true;\n\t\tif(is_arti)\n\t\t\tarti_points.eb(v);\n\t}\n\tLow(int n, V<pii> _edges) : graph(n), low(n), pre(n, -1), edges(_edges) {\n\t\tREP(i, ssize(edges)) {\n\t\t\tauto [v, u] = edges[i];\n#ifdef LOCAL\n\t\t\tassert(v != u);\n#endif\n\t\t\tgraph[v].eb(i);\n\t\t\tgraph[u].eb(i);\n\t\t}\n\t\tREP(v, n)\n\t\t\tif(pre[v] == -1)\n\t\t\t\tdfs(v, -1);\n\t}\n};",
)

#code-entry(
  name: "cactus-cycles",
  hash: "c9ef3d",
  includes: (),
  opis: [$cal(O)(n)$, wyznaczanie cykli w grafie. Zakłada że jest nieskierowany graf bez pętelek i multikrawędzi, każda krawędź leży na co najwyżej jednym cyklu prostym (silniejsze założenie, niż o wierzchołkach). `cactus_cycles(graph)` zwraca taką listę cykli, że istnieje krawędź między $i$-tym, a $(i+1) "mod" "ssize(cycle)"$-tym wierzchołkiem.],
  lang: "cpp",
  code: "V<vi> cactus_cycles(V<vi> graph) {\n\tvi state(ssize(graph), 0), stack;\n\tV<vi> ret;\n\tfunction<void (int, int)> dfs = [&](int v, int p) {\n\t\tif(state[v] == 2) {\n\t\t\tret.eb(stack.rbegin(), find(rall(stack), v) + 1);\n\t\t\treturn;\n\t\t}\n\t\tstack.eb(v);\n\t\tstate[v] = 2;\n\t\tfor(int u : graph[v])\n\t\t\tif(u != p and state[u] != 1)\n\t\t\t\tdfs(u, v);\n\t\tstate[v] = 1;\n\t\tstack.pop_back();\n\t};\n\tREP(i, ssize(graph))\n\t\tif (!state[i])\n\t\t\tdfs(i, -1);\n\treturn ret;\n}",
)

#code-entry(
  name: "centro-decomp",
  hash: "dbd3a2",
  includes: (),
  opis: [$cal(O)(n log  n)$, template do Centroid Decomposition Nie używamy podsz, odwi, ani odwi_cnt Konstruktor przyjmuje liczbę wierzchołków i drzewo. Jeśli chcemy mieć rozbudowane krawędzie, to zmienić tam gdzie zaznaczone. Mamy tablicę odwiedzonych z refreshem w $cal(O)(1)$ (używać bez skrępowania). `visit(v)` odznacza v jako odwiedzony. `is_vis(v)` zwraca, czy v jest odwiedzony. `refresh(v)` zamienia niezablokowane wierzchołki na nieodwiedzone. W decomp mamy standardowe wykonanie CD na poziomie spójnej. Tablica `par` mówi kto jest naszym ojcem w drzewie CD. `root` to korzeń drzewa CD.],
  lang: "cpp",
  code: "struct CentroDecomp {\n\tC V<vi> &graph; // tu\n\tvi par, podsz, odwi;\n\tint odwi_cnt = 1;\n\tC int INF = int(1e9);\n\tint root;\n\tvoid refresh() { ++odwi_cnt; }\n\tvoid visit(int v) { chmax(odwi[v], odwi_cnt); }\n\tbool is_vis(int v) { return odwi[v] >= odwi_cnt; }\n\tvoid dfs_podsz(int v) {\n\t\tvisit(v);\n\t\tpodsz[v] = 1;\n\t\tfor (int u : graph[v]) // tu\n\t\t\tif (!is_vis(u)) {\n\t\t\t\tdfs_podsz(u);\n\t\t\t\tpodsz[v] += podsz[u];\n\t\t\t}\n\t}\n\tint centro(int v) {\n\t\trefresh();\n\t\tdfs_podsz(v);\n\t\tint sz = podsz[v] / 2;\n\t\trefresh();\n\t\twhile (true) {\n\t\t\tvisit(v);\n\t\t\tfor (int u : graph[v]) // tu\n\t\t\t\tif (!is_vis(u) && podsz[u] > sz) {\n\t\t\t\t\tv = u;\n\t\t\t\t\tbreak;\n\t\t\t\t}\n\t\t\tif (is_vis(v))\n\t\t\t\treturn v;\n\t\t}\n\t}\n\tvoid decomp(int v) {\n\t\trefresh();\n\t\t// Tu kod. Centroid to v, ktory jest juz dozywotnie odwiedzony.\n\t\t// Koniec kodu.\n\t\trefresh();\n\t\tfor(int u : graph[v]) // tu\n\t\t\tif (!is_vis(u)) {\n\t\t\t\tu = centro(u);\n\t\t\t\tpar[u] = v;\n\t\t\t\todwi[u] = INF;\n\t\t\t\t// Opcjonalnie tutaj przekazujemy info synowi w drzewie CD.\n\t\t\t\tdecomp(u);\n\t\t\t}\n\t}\n\tCentroDecomp(int n, V<vi> &grph) // tu\n\t   \t: graph(grph), par(n, -1), podsz(n), odwi(n) {\n\t\troot = centro(0);\n\t\todwi[root] = INF;\n\t\tdecomp(root);\n\t}\n};",
)

#code-entry(
  name: "coloring",
  hash: "b2d062",
  includes: (),
  opis: [$cal(O)("nm")$, wyznacza kolorowanie grafu planaranego. `coloring(graph)` zwraca 5-kolorowanie grafu `coloring(graph, 4)` zwraca 4-kolorowanie grafu, jeżeli w każdym momencie procesu usuwania wierzchołka o najmniejszym stopniu jego stopień jest nie większy niż 4],
  lang: "cpp",
  code: "vi coloring(C V<vi>& graph, C int limit = 5) {\n\tC int n = ssize(graph);\n\tif (!n) return {};\n\tfunction<vi(V<bool>)> solve = [&](C V<bool>& active) {\n\t\tif (not *max_element(all(active)))\n\t\t\treturn V (n, -1);\n\t\tpii best = {n, -1};\n\t\tREP(i, n) {\n\t\t\tif (not active[i])\n\t\t\t\tcontinue;\n\t\t\tint cnt = 0;\n\t\t\tfor (int e : graph[i])\n\t\t\t\tcnt += active[e];\n\t\t\tchmin(best, pair(cnt, i));\n\t\t}\n\t\tC int id = best.se;\n\t\tauto cp = active;\n\t\tcp[id] = false;\n\t\tauto col = solve(cp);\n\t\tV<bool> used(limit);\n\t\tfor (int e : graph[id])\n\t\t\tif (active[e])\n\t\t\t\tused[col[e]] = true;\n\t\tREP(i, limit)\n\t\t\tif (not used[i]) {\n\t\t\t\tcol[id] = i;\n\t\t\t\treturn col;\n\t\t\t}\n\t\tfor (int e0 : graph[id]) {\n\t\t\tfor (int e1 : graph[id]) {\n\t\t\t\tif (e0 >= e1)\n\t\t\t\t\tcontinue;\n\t\t\t\tV<bool> vis(n);\n\t\t\t\tfunction<void(int, int, int)> dfs = [&](int v, int c0, int c1) {\n\t\t\t\t\tvis[v] = true;\n\t\t\t\t\tfor (int e : graph[v])\n\t\t\t\t\t\tif (not vis[e] and (col[e] == c0 or col[e] == c1))\n\t\t\t\t\t\t\tdfs(e, c0, c1);\n\t\t\t\t};\n\t\t\t\tC int c0 = col[e0], c1 = col[e1];\n\t\t\t\tdfs(e0, c0, c1);\n\t\t\t\tif (vis[e1])\n\t\t\t\t\tcontinue;\n\t\t\t\tREP(i, n)\n\t\t\t\t\tif (vis[i])\n\t\t\t\t\t\tcol[i] = col[i] == c0 ? c1 : c0;\n\t\t\t\tcol[id] = c0;\n\t\t\t\treturn col;\n\t\t\t}\n\t\t}\n\t\tassert(false);\n\t};\n\treturn solve(V (n, true));\n}",
)

#code-entry(
  name: "de-brujin",
  hash: "e577d2",
  includes: ("eulerian-path",),
  opis: [$cal(O)(k^n)$, ciag/cykl de Brujina słów długości $n$ nad alfabetem ${0, 1, ..., k - 1}$. Jeżeli `is_path` to zwraca ciąg, wpp. zwraca cykl.],
  lang: "cpp",
  code: "vi de_brujin(int k, int n, bool is_path) {\n\tif (n == 1) {\n\t\tvi v(k);\n\t\tiota(all(v), 0);\n\t\treturn v;\n\t}\n\tif (k == 1)\n\t\treturn V (n, 0);\n\tint N = 1;\n\tREP(i, n - 1)\n\t\tN *= k;\n\tV<pii> edges;\n\tREP(i, N)\n\t\tREP(j, k)\n\t\t\tedges.eb(i, i * k % N + j);\n\tvi path = get<2>(eulerian_path(N, edges, true));\n\tpath.pop_back();\n\tfor(auto& e : path)\n\t\te = e % k;\n\tif (is_path)\n\t\tREP(i, n - 1)\n\t\t\tpath.eb(path[i]);\n\treturn path;\n}",
)

#code-entry(
  name: "directed-mst",
  hash: "bdca76",
  includes: (),
  opis: [$cal(O)(m log  n)$, dla korzenia i listy krawędzi skierowanych ważonych zwraca najtańszy podzbiór $n-1$ krawędzi taki, że z korzenia istnieje ścieżka do każdego innego wierzchołka, lub $-1$ gdy nie ma. Zwraca (koszt, ojciec każdego wierzchołka w zwróconym drzewie).],
  lang: "cpp",
  code: "struct RollbackUF {\n\tvi e; V<pii> st;\n\tRollbackUF(int n) : e(n, -1) {}\n\tint size(int x) { return -e[find(x)]; }\n\tint find(int x) { return e[x] < 0 ? x : find(e[x]); }\n\tint time() { return ssize(st); }\n\tvoid rollback(int t) {\n\t\tfor(int i = time(); i --> t;)\n\t\t\te[st[i].fi] = st[i].se;\n\t\tst.resize(t);\n\t}\n\tbool join(int a, int b) {\n\t\ta = find(a), b = find(b);\n\t\tif(a == b) return false;\n\t\tif(e[a] > e[b]) swap(a, b);\n\t\tst.pb({a, e[a]});\n\t\tst.pb({b, e[b]});\n\t\te[a] += e[b]; e[b] = a;\n\t\treturn true;\n\t}\n};\nstruct Edge { int a, b; ll w; };\nstruct Node {\n\tEdge key;\n\tNode *l = 0, *r = 0;\n\tll delta = 0;\n\tvoid prop() {\n\t\tkey.w += delta;\n\t\tif(l) l->delta += delta;\n\t\tif(r) r->delta += delta;\n\t\tdelta = 0;\n\t}\n};\nNode* merge(Node *a, Node *b) {\n\tif(!a || !b) return a ?: b;\n\ta->prop(), b->prop();\n\tif(a->key.w > b->key.w) swap(a, b);\n\tswap(a->l, (a->r = merge(b, a->r)));\n\treturn a;\n}\npair<ll, vi> directed_mst(int n, int r, V<Edge> &g) {\n\tRollbackUF uf(n);\n\tV<Node*> heap(n);\n\tV<Node> pool(ssize(g));\n\tREP(i, ssize(g)) {\n\t\tEdge e = g[i];\n\t\theap[e.b] = merge(heap[e.b], &(pool[i] = Node{e}));\n\t}\n\tll res = 0;\n\tvi seen(n, -1), path(n), par(n);\n\tseen[r] = r;\n\tV<Edge> Q(n), in(n, {-1, -1, 0}), comp;\n\tdeque<tuple<int, int, V<Edge>>> cycs;\n\tREP(s, n) {\n\t\tint u = s, qi = 0, w;\n\t\twhile(seen[u] < 0) {\n\t\t\tNode *&hu = heap[u];\n\t\t\tif(!hu) return {-1, {}};\n\t\t\thu->prop();\n\t\t\tEdge e = hu->key;\n\t\t\thu->delta -= e.w; hu->prop(); hu = merge(hu->l, hu->r);\n\t\t\tQ[qi] = e, path[qi++] = u, seen[u] = s;\n\t\t\tres += e.w, u = uf.find(e.a);\n\t\t\tif(seen[u] == s) {\n\t\t\t\tNode *c = 0;\n\t \t\t\tint end = qi, time = uf.time();\n\t\t\t\tdo c = merge(c, heap[w = path[--qi]]);\n\t\t\t\twhile(uf.join(u, w));\n\t\t\t\tu = uf.find(u), heap[u] = c, seen[u] = -1;\n\t\t\t\tcycs.push_front({u, time, {&Q[qi], &Q[end]}});\n\t\t\t}\n\t\t}\n\t\tREP(i,qi) in[uf.find(Q[i].b)] = Q[i];\n\t}\n\tfor(auto [u, t, c] : cycs) { // restore sol (optional)\n\t\tuf.rollback(t);\n\t\tEdge inu = in[u];\n\t\tfor(auto e : c) in[uf.find(e.b)] = e;\n\t\tin[uf.find(inu.b)] = inu;\n\t}\n\tREP(i, n) par[i] = in[i].a;\n\treturn {res, par};\n}",
)

#code-entry(
  name: "dominator-tree",
  hash: "f79d15",
  includes: (),
  opis: [$cal(O)(m alpha (n))$, dla spójnego DAGu o jednym korzeniu root wyznacza listę synów w dominator tree (które jest drzewem, gdzie ojciec wierzchołka v to najbliższy wierzchołek, którego usunięcie powoduje, że już nie ma ścieżki od korzenia do v). `dominator_tree({{1,2\`,{3},{4},{4},{5}},0) == {{1,4,2},{3},{},{},{5},{}}}}],
  lang: "cpp",
  code: "V<vi> dominator_tree(V<vi> dag, int root) {\n\tint n = ssize(dag);\n\tV<vi> t(n), rg(n), bucket(n);\n\tvi id(n, -1), sdom = id, par = id, idom = id, dsu = id, label = id, rev = id;\n\tfunction<int (int, int)> find = [&](int v, int x) {\n\t\tif(v == dsu[v]) return x ? -1 : v;\n\t\tint u = find(dsu[v], x + 1);\n\t\tif(u < 0) return v;\n\t\tif(sdom[label[dsu[v]]] < sdom[label[v]]) label[v] = label[dsu[v]];\n\t\tdsu[v] = u;\n\t\treturn x ? u : label[v];\n\t};\n\tint gtime = 0;\n\tfunction<void (int)> dfs = [&](int u) {\n\t\trev[gtime] = u;\n\t\tlabel[gtime] = sdom[gtime] = dsu[gtime] = id[u] = gtime;\n\t\tgtime++;\n\t\tfor(int w : dag[u]) {\n\t\t\tif(id[w] == -1) dfs(w), par[id[w]] = id[u];\n\t\t\trg[id[w]].eb(id[u]);\n\t\t}\n\t};\n\tdfs(root);\n\tfor(int i = n - 1; i >= 0; i--) {\n\t\tfor(int u : rg[i]) chmin(sdom[i], sdom[find(u, 0)]);\n\t\tif(i > 0) bucket[sdom[i]].pb(i);\n\t\tfor(int w : bucket[i]) {\n\t\t\tint v = find(w, 0);\n\t\t\tidom[w] = (sdom[v] == sdom[w] ? sdom[w] : v);\n\t\t}\n\t\tif(i > 0) dsu[i] = par[i];\n\t}\n\tFOR(i, 1, n - 1) {\n\t\tif(idom[i] != sdom[i]) idom[i] = idom[idom[i]];\n\t\tt[rev[idom[i]]].eb(rev[i]);\n\t}\n\treturn t;\n}",
)

#code-entry(
  name: "dynamic-connectivity",
  hash: "fd42a9",
  includes: (),
  opis: [$cal(O)("qlog" ^2 n)$ offline, zaczyna z pustym grafem, dla danego zapytania stwierdza czy wierzchołki sa w jednej spójnej. Multikrawędzie oraz pętelki działają.],
  lang: "cpp",
  code: "enum Event_type { Add, Remove, Query };\nV<bool> dynamic_connectivity(int n, V<tuple<int, int, Event_type>> events) {\n\tV<pii> queries;\n\tfor(auto &[v, u, t] : events) {\n\t\tif(v > u)\n\t\t\tswap(v, u);\n\t\tif(t == Query)\n\t\t\tqueries.eb(v, u);\n\t}\n\tint leaves = 1;\n\twhile(leaves < ssize(queries))\n\t\tleaves *= 2;\n\tV<V<pii>> edges_to_add(2 * leaves);\n\tmap<pii, deque<int>> edge_longevity;\n\tint query_i = 0;\n\tauto add = [&](int l, int r, pii e) {\n\t\tif(l > r)\n\t\t\treturn;\n\t\tdebug(l, r, e);\n\t\tl += leaves;\n\t\tr += leaves;\n\t\twhile(l <= r) {\n\t\t\tif(l % 2 == 1)\n\t\t\t\tedges_to_add[l++].eb(e);\n\t\t\tif(r % 2 == 0)\n\t\t\t\tedges_to_add[r--].eb(e);\n\t\t\tl /= 2;\n\t\t\tr /= 2;\n\t\t}\n\t};\n\tfor(C auto &[v, u, t] : events) {\n\t\tauto &que = edge_longevity[pair(v, u)];\n\t\tif(t == Add)\n\t\t\tque.eb(query_i);\n\t\telse if(t == Remove) {\n\t\t\tif(que.empty())\n\t\t\t\tcontinue;\n\t\t\tif(ssize(que) == 1)\n\t\t\t\tadd(que.back(), query_i - 1, pair(v, u));\n\t\t\tque.pop_back();\n\t\t}\n\t\telse\n\t\t\t++query_i;\n\t}\n\tfor(C auto &[e, que] : edge_longevity)\n\t\tif(not que.empty())\n\t\t\tadd(que.front(), query_i - 1, e);\n\tV<bool> ret(ssize(queries));\n\tvi lead(n), leadsz(n, 1);\n\tiota(all(lead), 0);\n\tfunction<int (int)> find = [&](int i) {\n\t\treturn i == lead[i] ? i : find(lead[i]);\n\t};\n\tfunction<void (int)> dfs = [&](int v) {\n\t\tV<tuple<int, int, int, int>> rollback;\n\t\tfor(auto [e0, e1] : edges_to_add[v]) {\n\t\t\te0 = find(e0);\n\t\t\te1 = find(e1);\n\t\t\tif(e0 == e1)\n\t\t\t\tcontinue;\n\t\t\tif(leadsz[e0] > leadsz[e1])\n\t\t\t\tswap(e0, e1);\n\t\t\trollback.eb(e0, lead[e0], e1, leadsz[e1]);\n\t\t\tleadsz[e1] += leadsz[e0];\n\t\t\tlead[e0] = e1;\n\t\t}\n\t\tif(v >= leaves) {\n\t\t\tint i = v - leaves;\n\t\t\tassert(i < leaves);\n\t\t\tif(i < ssize(queries))\n\t\t\t\tret[i] = find(queries[i].fi) == find(queries[i].se);\n\t\t}\n\t\telse {\n\t\t\tdfs(2 * v);\n\t\t\tdfs(2 * v + 1);\n\t\t}\n\t\treverse(all(rollback));\n\t\tfor(auto [i, val, j, sz] : rollback) {\n\t\t\tlead[i] = val;\n\t\t\tleadsz[j] = sz;\n\t\t}\n\t};\n\tdfs(1);\n\treturn ret;\n}",
)

#code-entry(
  name: "eulerian-path",
  hash: "d0a611",
  includes: (),
  opis: [$cal(O)(n + m)$, ścieżka eulera. Zwraca tupla (exists, ids, vertices). W `exists` jest informacja czy jest ścieżka/cykl eulera, `ids` zawiera id kolejnych krawędzi, `vertices` zawiera listę wierzchołków na tej ścieżce. Dla cyklu, `vertices[0] == vertices[m]`.],
  lang: "cpp",
  code: "tuple<bool, vi, vi> eulerian_path(int n, C V<pii> &edges, bool directed) {\n\tvi in(n);\n\tV<vi> adj(n);\n\tint start = 0;\n\tREP(i, ssize(edges)) {\n\t\tauto [a, b] = edges[i];\n\t\tstart = a;\n\t\t++in[b];\n\t\tadj[a].eb(i);\n\t\tif (not directed)\n\t\t\tadj[b].eb(i);\n\t}\n\tint cnt_in = 0, cnt_out = 0;\n\tREP(i, n) {\n\t\tif (directed) {\n\t\t\tif (abs(ssize(adj[i]) - in[i]) > 1)\n\t\t\t\treturn {};\n\t\t\tif (in[i] < ssize(adj[i]))\n\t\t\t\tstart = i, ++cnt_in;\n\t\t\telse\n\t\t\t\tcnt_out += in[i] > ssize(adj[i]);\n\t\t}\n\t\telse if (ssize(adj[i]) % 2)\n\t\t\tstart = i, ++cnt_in;\n\t}\n\tvi ids, vertices;\n\tV<bool> used(ssize(edges));\n\tfunction<void (int)> dfs = [&](int v) {\n\t\twhile (ssize(adj[v])) {\n\t\t\tint id = adj[v].back(), u = v ^ edges[id].fi ^ edges[id].se;\n\t\t\tadj[v].pop_back();\n\t\t\tif (used[id]) continue;\n\t\t\tused[id] = true;\n\t\t\tdfs(u);\n\t\t\tids.eb(id);\n\t\t}\n\t};\n\tdfs(start);\n\tif (cnt_in + cnt_out > 2 or not all_of(all(used), identity{}))\n\t\treturn {};\n\treverse(all(ids));\n\tif (ssize(ids))\n\t\tvertices = {start};\n\tfor (int id : ids)\n\t\tvertices.eb(vertices.back() ^ edges[id].fi ^ edges[id].se);\n\treturn {true, ids, vertices};\n}",
)

#code-entry(
  name: "hld",
  hash: "642525",
  includes: (),
  opis: [$cal(O)(q log  n)$ Heavy-Light Decomposition. `get_vertex(v)` zwraca pozycję odpowiadającą wierzchołkowi. `get_path(v, u)` zwraca przedziały do obsługiwania drzewem przedziałowym. `get_path(v, u)` jeśli robisz operacje na wierzchołkach. `get_path(v, u, false)` jeśli na krawędziach (nie zawiera lca). `get_subtree(v)` zwraca przedział preorderów odpowiadający podrzewu v.],
  lang: "cpp",
  code: "struct HLD {\n// BEGIN HASH 0d65c4\n\tV<vi> &adj;\n\tvi sz, pre, pos, nxt, par;\n\tint t = 0;\n\tvoid init(int v, int p = -1) {\n\t\tpar[v] = p;\n\t\tsz[v] = 1;\n\t\tif(ssize(adj[v]) > 1 && adj[v][0] == p)\n\t\t\tswap(adj[v][0], adj[v][1]);\n\t\tfor(int &u : adj[v]) if(u != par[v]) {\n\t\t\tinit(u, v);\n\t\t\tsz[v] += sz[u];\n\t\t\tif(sz[u] > sz[adj[v][0]])\n\t\t\t\tswap(u, adj[v][0]);\n\t\t}\n\t}\n\tvoid set_paths(int v) {\n\t\tpre[v] = t++;\n\t\tfor(int &u : adj[v]) if(u != par[v]) {\n\t\t\tnxt[u] = (u == adj[v][0] ? nxt[v] : u);\n\t\t\tset_paths(u);\n\t\t}\n\t\tpos[v] = t;\n\t}\n\tHLD(int n, V<vi> &_adj)\n\t\t: adj(_adj), sz(n), pre(n), pos(n), nxt(n), par(n) {\n\t\tinit(0), set_paths(0);\n\t} // END HASH\n\tint lca(int v, int u) {\n\t\twhile(nxt[v] != nxt[u]) {\n\t\t\tif(pre[v] < pre[u])\n\t\t\t\tswap(v, u);\n\t\t\tv = par[nxt[v]];\n\t\t}\n\t\treturn (pre[v] < pre[u] ? v : u);\n\t}\n\tV<pii> path_up(int v, int u) {\n\t\tV<pii> ret;\n\t\twhile(nxt[v] != nxt[u]) {\n\t\t\tret.eb(pre[nxt[v]], pre[v]);\n\t\t\tv = par[nxt[v]];\n\t\t}\n\t\tif(pre[u] != pre[v]) ret.eb(pre[u] + 1, pre[v]);\n\t\treturn ret;\n\t}\n\tint get_vertex(int v) { return pre[v]; }\n\tV<pii> get_path(int v, int u, bool add_lca = true) {\n\t\tint w = lca(v, u);\n\t\tauto ret = path_up(v, w);\n\t\tauto path_u = path_up(u, w);\n\t\tif(add_lca) ret.eb(pre[w], pre[w]);\n\t\tret.insert(ret.end(), path_u.begin(), path_u.end());\n\t\treturn ret;\n\t}\n\tpii get_subtree(int v) { return {pre[v], pos[v] - 1}; }\n};",
)

#code-entry(
  name: "hld-online-bottom-up",
  hash: "dc8d43",
  includes: ("hld",),
  opis: [$cal(O)(q log ^2 n)$, rozwala zadania, gdzie wynik to dp bottom-up na drzewie i zmienia się wartość wierzchołka/krawędzi. To zakłada, że da się tak uogólnić tego bottom-up'a, że da się trzymać fragmenty drzewa z "dwoma dziurami" i doczepiać jak LEGO dwa takie fragmenty do siebie.],
  lang: "cpp",
  code: "// Information about a single vertex (e.g. color).\n// A component contains answers for vertices, not edges.\nusing Value_v = int;\n// Probably you want: some information about the up vertex, the down vertex,\n// answer for whole component, answer containing up, answer containing down,\n// answer containing both up and down.\nstruct DpTwoEnds;\n// Merge two disjoint-vertex paths. Assume that there is an edge\n// between \"up\" vertex of d and \"down\" vertex od u.\nDpTwoEnds merge(DpTwoEnds u, DpTwoEnds d);\n// DpOneEnd Contains information about a component after forgetting the \"down\" vertex.\n// Probably you want: answer for whole component, informations about top vertices.\n// It needs a default constructor.\nstruct DpOneEnd;\n// Merge two parallel components. They are vertex-disjoint. They do not contain the\n// parent (it will be included in the next function).\nDpOneEnd merge(DpOneEnd a, DpOneEnd b);\n// Assuming that DpOneEnd contain all components of the light sons of the parent,\n// merge those components once with the parent. It has to support passing the\n// default/neutral value of DpOneEnd -- it means that the vertex doesn't have light sons.\nDpTwoEnds merge(DpOneEnd sons, Value_v value_parent);\n// From a path that remembers \"up\" and \"down\" vertices, forget the \"down\" one.\nDpOneEnd two_to_one(DpTwoEnds two);\ntemplate<class T> struct Tree {\n\tint leaves = 1;\n\tV<T> tree;\n\tTree(int n = 0) {\n\t\twhile(leaves < n)\n\t\t\tleaves *= 2;\n\t\ttree.resize(2 * leaves);\n\t}\n\tvoid set(int i, T t) {\n\t\ttree[i += leaves] = t;\n\t\twhile(i /= 2)\n\t\t\ttree[i] = merge(tree[2 * i], tree[2 * i + 1]);\n\t}\n\tT get() { return tree[1]; }\n};\nstruct DpDynamicBottomUp {\n\tint n;\n\tHLD hld;\n\tV<Tree<DpOneEnd>> tree_sons;\n\tV<Tree<DpTwoEnds>> tree_path;\n\tV<Value_v> current_values;\n\tvi which_on_path, which_light_son;\n\tDpDynamicBottomUp(V<vi> graph, V<Value_v> initial_values)\n\t\t: n(ssize(graph)), hld(n, graph), tree_sons(n), tree_path(n), current_values(initial_values), which_on_path(n, -1), which_light_son(n, -1) {\n\t\tfunction<void (int, int*)> dfs = [&](int v, int *on_heavy_cnt) {\n\t\t\tint light_sons_cnt = 0, tmp = 0;\n\t\t\twhich_on_path[v] = (*(on_heavy_cnt = on_heavy_cnt ?: &tmp))++;\n\t\t\tfor(int u : hld.adj[v])\n\t\t\t\tif(u != hld.par[v])\n\t\t\t\t\tdfs(u, hld.nxt[u] == u ? which_light_son[u] = light_sons_cnt++, nullptr : on_heavy_cnt);\n\t\t\ttree_sons[v] = Tree<DpOneEnd>(light_sons_cnt);\n\t\t\ttree_path[v] = Tree<DpTwoEnds>(tmp);\n\t\t};\n\t\tdfs(0, 0);\n\t\tREP(v, n)\n\t\t\tset(v, initial_values[v]);\n\t}\n\tvoid set(int v, int value_vertex) {\n\t\tcurrent_values[v] = value_vertex;\n\t\twhile(true) {\n\t\t\ttree_path[hld.nxt[v]].set(which_on_path[v], merge(tree_sons[v].get(), current_values[v]));\n\t\t\tv = hld.nxt[v];\n\t\t\tif(hld.par[v] == -1)\n\t\t\t\tbreak;\n\t\t\ttree_sons[hld.par[v]].set(which_light_son[v], two_to_one(tree_path[hld.nxt[v]].get()));\n\t\t\tv = hld.par[v];\n\t\t}\n\t}\n\tDpTwoEnds get() { return tree_path[0].get(); }\n};",
)

#code-entry(
  name: "jump-ptr",
  hash: "86ffd1",
  includes: (),
  opis: [$cal(O)((n+q) log  n)$, `jump_up(v, k)` zwraca wierzchołek o $k$ krawędzi wyżej niż $v$ lub $-1$. `OperationJumpPtr` może otrzymać wynik na ścieżce. Wynik na ścieżce do góry wymaga łączności, wynik dowolnej ścieżki jest poprawny, gdy jest odwrotność wyniku lub przemienna.],
  lang: "cpp",
  code: "// BEGIN HASH a0bbb0\nstruct SimpleJumpPtr {\n\tint bits;\n\tV<vi> graph, jmp;\n\tvi par, dep;\n\tvoid par_dfs(int v) {\n\t\tfor(int u : graph[v])\n\t\t\tif(u != par[v]) {\n\t\t\t\tpar[u] = v;\n\t\t\t\tdep[u] = dep[v] + 1;\n\t\t\t\tpar_dfs(u);\n\t\t\t}\n\t}\n\tSimpleJumpPtr(V<vi> g = {}, int root = 0) : graph(g) {\n\t\tint n = ssize(graph);\n\t\tbits = __lg(max(1, n)) + 1;\n\t\tdep.resize(n);\n\t\tpar.resize(n, -1);\n\t\tif(n > 0)\n\t\t\tpar_dfs(root);\n\t\tjmp.resize(bits, vi(n, -1));\n\t\tjmp[0] = par;\n\t\tFOR(b, 1, bits - 1)\n\t\t\tREP(v, n)\n\t\t\t\tif(jmp[b - 1][v] != -1)\n\t\t\t\t\tjmp[b][v] = jmp[b - 1][jmp[b - 1][v]];\n\t\tdebug(graph, jmp);\n\t}\n\tint jump_up(int v, int h) {\n\t\tfor(int b = 0; (1 << b) <= h; ++b)\n\t\t\tif((h >> b) & 1)\n\t\t\t\tv = jmp[b][v];\n\t\treturn v;\n\t}\n\tint lca(int v, int u) {\n\t\tif(dep[v] < dep[u])\n\t\t\tswap(v, u);\n\t\tv = jump_up(v, dep[v] - dep[u]);\n\t\tif(v == u)\n\t\t\treturn v;\n\t\tfor(int b = bits - 1; b >= 0; b--) {\n\t\t\tif(jmp[b][v] != jmp[b][u]) {\n\t\t\t\tv = jmp[b][v];\n\t\t\t\tu = jmp[b][u];\n\t\t\t}\n\t\t}\n\t\treturn par[v];\n\t}\n}; // END HASH\nusing PathAns = ll;\nPathAns merge(PathAns down, PathAns up) {\n\treturn down + up;\n}\nstruct OperationJumpPtr {\n\tSimpleJumpPtr ptr;\n\tV<V<PathAns>> ans_jmp;\n\tOperationJumpPtr(V<V<pii>> g, int root = 0) {\n\t\tdebug(g, root);\n\t\tint n = ssize(g);\n\t\tV<vi> unweighted_g(n);\n\t\tREP(v, n)\n\t\t\tfor(auto [u, w] : g[v]) {\n\t\t\t\t(void) w;\n\t\t\t\tunweighted_g[v].eb(u);\n\t\t\t}\n\t\tptr = SimpleJumpPtr(unweighted_g, root);\n\t\tans_jmp.resize(ptr.bits, V<PathAns>(n));\n\t\tREP(v, n)\n\t\t\tfor(auto [u, w] : g[v])\n\t\t\t\tif(u == ptr.par[v])\n\t\t\t\t\tans_jmp[0][v] = PathAns(w);\n\t\tFOR(b, 1, ptr.bits - 1)\n\t\t\tREP(v, n)\n\t\t\t\tif(ptr.jmp[b - 1][v] != -1 and ptr.jmp[b - 1][ptr.jmp[b - 1][v]] != -1)\n\t\t\t\t\tans_jmp[b][v] = merge(ans_jmp[b - 1][v], ans_jmp[b - 1][ptr.jmp[b - 1][v]]);\n\t}\n\tPathAns path_ans_up(int v, int h) {\n\t\tPathAns ret = PathAns();\n\t\tfor(int b = ptr.bits - 1; b >= 0; b--)\n\t\t\tif((h >> b) & 1) {\n\t\t\t\tret = merge(ret, ans_jmp[b][v]);\n\t\t\t\tv = ptr.jmp[b][v];\n\t\t\t}\n\t\treturn ret;\n\t}\n\tPathAns path_ans(int v, int u) { // discards order of edges on path\n\t\tint l = ptr.lca(v, u);\n\t\treturn merge(\n\t\t\tpath_ans_up(v, ptr.dep[v] - ptr.dep[l]),\n\t\t\tpath_ans_up(u, ptr.dep[u] - ptr.dep[l])\n\t\t);\n\t}\n};",
)

#code-entry(
  name: "max-clique",
  hash: "064cbc",
  includes: (),
  opis: [$cal(O)("idk")$, działa 1s dla n=155 na najgorszych przypadkach (losowe grafy p=.90). Działa szybciej dla grafów rzadkich. Zwraca listę wierzchołków w jakiejś max klice. Pętelki niedozwolone.],
  lang: "cpp",
  code: "constexpr int max_n = 500;\nvi get_max_clique(V<bitset<max_n>> e) {\n\tdouble limit = 0.025, pk = 0;\n\tV<pii> v;\n\tV<vi> c(ssize(e) + 1);\n\tvi qmax, q, S(ssize(c)), old(S);\n\tREP(i, ssize(e)) v.eb(0, i);\n\tauto init = [&](V<pii>& r) {\n\t\tfor (auto& vv : r) for (auto j : r) vv.fi += e[vv.se][j.se];\n\t\tsort(rall(r));\n\t\tint mxD = r[0].fi;\n\t\tREP(i, ssize(r)) r[i].fi = min(i, mxD) + 1;\n\t};\n\tfunction<void (V<pii>&, int)> expand = [&](V<pii>& R, int lev) {\n\t\tS[lev] += S[lev - 1] - old[lev];\n\t\told[lev] = S[lev - 1];\n\t\twhile (ssize(R)) {\n\t\t\tif (ssize(q) + R.back().fi <= ssize(qmax)) return;\n\t\t\tq.eb(R.back().se);\n\t\t\tV<pii> T;\n\t\t\tfor(auto [_, vv] : R) if (e[R.back().se][vv]) T.eb(0, vv);\n\t\t\tif (ssize(T)) {\n\t\t\t\tif (S[lev]++ / ++pk < limit) init(T);\n\t\t\t\tint j = 0, mxk = 1, mnk = max(ssize(qmax) - ssize(q) + 1, 1);\n\t\t\t\tc[1] = c[2] = {};\n\t\t\t\tfor (auto [_, v] : T) {\n\t\t\t\t\tint k = 1;\n\t\t\t\t\twhile (any_of(all(c[k]), [&](int i) { return e[v][i]; })) k++;\n\t\t\t\t\tif (k > mxk) c[(mxk = k) + 1] = {};\n\t\t\t\t\tif (k < mnk) T[j++].se = v;\n\t\t\t\t\tc[k].eb(v);\n\t\t\t\t}\n\t\t\t\tif (j > 0) T[j - 1].fi = 0;\n\t\t\t\tFOR(k, mnk, mxk) for (int i : c[k]) T[j++] = {k, i};\n\t\t\t\texpand(T, lev + 1);\n\t\t\t} else if (ssize(q) > ssize(qmax)) qmax = q;\n\t\t\tq.pop_back(), R.pop_back();\n\t\t}\n\t};\n\tinit(v), expand(v, 1); return qmax;\n}",
)

#code-entry(
  name: "negative-cycle",
  hash: "0ff517",
  includes: (),
  opis: [$cal(O)("nm")$ stwierdzanie istnienia i wyznaczanie ujemnego cyklu. `cycle` spełnia `cycle[i]->cycle[(i+1)\%ssize(cycle)]`. Żeby wyznaczyć krawędzie na cyklu, wystarczy wybierać najtańszą krawędź między wierzchołkami.],
  lang: "cpp",
  code: "template<class I>\npair<bool, vi> negative_cycle(V<V<pair<int, I>>> graph) {\n\tint n = ssize(graph);\n\tV<I> dist(n);\n\tvi from(n, -1);\n\tint v_on_cycle = -1;\n\tREP(iter, n) {\n\t\tv_on_cycle = -1;\n\t\tREP(v, n)\n\t\t\tfor(auto [u, w] : graph[v])\n\t\t\t\tif(dist[u] > dist[v] + w) {\n\t\t\t\t\tdist[u] = dist[v] + w;\n\t\t\t\t\tfrom[u] = v;\n\t\t\t\t\tv_on_cycle = u;\n\t\t\t\t}\n\t}\n\tif(v_on_cycle == -1)\n\t\treturn {false, {}};\n\tREP(iter, n)\n\t\tv_on_cycle = from[v_on_cycle];\n\tvi cycle = {v_on_cycle};\n\tfor(int v = from[v_on_cycle]; v != v_on_cycle; v = from[v])\n\t\tcycle.eb(v);\n\treverse(all(cycle));\n\treturn {true, cycle};\n}",
)

#code-entry(
  name: "planar-graph-faces",
  hash: "2ba436",
  includes: (),
  opis: [$cal(O)("mlog"  m)$, zakłada, że każdy punkt ma podane współrzędne, punkty są parami różne oraz krawędzie są nieprzecinającymi się odcinkami. Zwraca wszystkie ściany (wewnętrzne posortowane clockwise, zewnętrzne cc). WAŻNE czasem trzeba złączyć wszystkie ściany zewnętrzne (których może być kilka, gdy jest wiele spójnych) w jedną ścianę. Zewnętrzne ściany mogą wyglądać jak kaktusy, a wewnętrzne zawsze są niezdegenerowanym wielokątem.],
  lang: "cpp",
  code: "struct Edge {\n\tint e, from, to;\n\t// face is on the right of \"from -> to\"\n};\nostream& operator<<(ostream &o, Edge e) {\n\treturn o << V{e.e, e.from, e.to};\n}\nstruct Face {\n\tbool is_outside;\n\tV<Edge> sorted_edges;\n\t// edges are sorted clockwise for inside and cc for outside faces\n};\nostream& operator<<(ostream &o, Face f) {\n\treturn o << pair(f.is_outside, f.sorted_edges);\n}\nV<Face> split_planar_to_faces(V<pii> coord, V<pii> edges) {\n\tint n = ssize(coord);\n\tint E = ssize(edges);\n\tV<vi> graph(n);\n\tREP(e, E) {\n\t\tauto [v, u] = edges[e];\n\t\tgraph[v].eb(e);\n\t\tgraph[u].eb(e);\n\t}\n\tvi lead(2 * E);\n\tiota(all(lead), 0);\n\tfunction<int (int)> find = [&](int v) {\n\t\treturn lead[v] == v ? v : lead[v] = find(lead[v]);\n\t};\n\tauto side_of_edge = [&](int e, int v, bool outward) {\n\t\treturn 2 * e + ((v != min(edges[e].fi, edges[e].se)) ^ outward);\n\t};\n\tREP(v, n) {\n\t\tV<pair<pii, int>> sorted;\n\t\tfor(int e : graph[v]) {\n\t\t\tauto p = coord[edges[e].fi ^ edges[e].se ^ v];\n\t\t\tauto center = coord[v];\n\t\t\tsorted.eb(pair(p.fi - center.fi, p.se - center.se), e);\n\t\t}\n\t\tsort(all(sorted), [&](pair<pii, int> l0, pair<pii, int> r0) {\n\t\t\tauto l = l0.fi;\n\t\t\tauto r = r0.fi;\n\t\t\tbool half_l = l > pair(0, 0);\n\t\t\tbool half_r = r > pair(0, 0);\n\t\t\tif(half_l != half_r)\n\t\t\t\treturn half_l;\n\t\t\treturn l.fi * ll(r.se) - l.se * ll(r.fi) > 0;\n\t\t});\n\t\tREP(i, ssize(sorted)) {\n\t\t\tint e0 = sorted[i].se;\n\t\t\tint e1 = sorted[(i + 1) % ssize(sorted)].se;\n\t\t\tint side_e0 = side_of_edge(e0, v, true);\n\t\t\tint side_e1 = side_of_edge(e1, v, false);\n\t\t\tlead[find(side_e0)] = find(side_e1);\n\t\t}\n\t}\n\tV<vi> comps(2 * E);\n\tREP(i, 2 * E)\n\t\tcomps[find(i)].eb(i);\n\tV<Face> polygons;\n\tV<V<pii>> outgoing_for_face(n);\n\tREP(leader, 2 * E)\n\t\tif(ssize(comps[leader])) {\n\t\t\tfor(int id : comps[leader]) {\n\t\t\t\tint v = edges[id / 2].fi;\n\t\t\t\tint u = edges[id / 2].se;\n\t\t\t\tif(v > u)\n\t\t\t\t\tswap(v, u);\n\t\t\t\tif(id % 2 == 1)\n\t\t\t\t\tswap(v, u);\n\t\t\t\toutgoing_for_face[v].eb(u, id / 2);\n\t\t\t}\n\t\t\tV<Edge> sorted_edges;\n\t\t\tfunction<void (int)> dfs = [&](int v) {\n\t\t\t\twhile(ssize(outgoing_for_face[v])) {\n\t\t\t\t\tauto [u, e] = outgoing_for_face[v].back();\n\t\t\t\t\toutgoing_for_face[v].pop_back();\n\t\t\t\t\tdfs(u);\n\t\t\t\t\tsorted_edges.eb(e, v, u);\n\t\t\t\t}\n\t\t\t};\n\t\t\tdfs(edges[comps[leader].front() / 2].fi);\n\t\t\treverse(all(sorted_edges));\n\t\t\tll area = 0;\n\t\t\tfor(auto edge : sorted_edges) {\n\t\t\t\tauto l = coord[edge.from];\n\t\t\t\tauto r = coord[edge.to];\n\t\t\t\tarea += l.fi * ll(r.se) - l.se * ll(r.fi);\n\t\t\t}\n\t\t\tpolygons.eb(area >= 0, sorted_edges);\n\t\t}\n\t// Remember that there can be multiple outside faces.\n\treturn polygons;\n}",
)

#code-entry(
  name: "planarity-check",
  hash: "d07281",
  includes: (),
  opis: [$cal(O)("szybko")$ ale istnieją przykłady $cal(O)(n^2)$, przyjmuje graf nieskierowany bez pętelek i multikrawędzi.],
  lang: "cpp",
  code: "bool is_planar(V<vi> graph) {\n\tint n = ssize(graph), m = 0;\n\tREP(v, n)\n\t\tm += ssize(graph[v]);\n\tm /= 2;\n\tif(n <= 3) return true;\n\tif(m > 3 * n - 6) return false;\n\tV<vi> up(n), dn(n);\n\tvi low(n, -1), pre(n);\n\tREP(start, n)\n\t\tif(low[start] == -1) {\n\t\t\tV<pii> e_up;\n\t\t\tint tm = 0;\n\t\t\tfunction<void (int, int)> dfs_low = [&](int v, int p) {\n\t\t\t\tlow[v] = pre[v] = tm++;\n\t\t\t\tfor(int u : graph[v])\n\t\t\t\t\tif(u != p and low[u] == -1) {\n\t\t\t\t\t\tdn[v].eb(u);\n\t\t\t\t\t\tdfs_low(u, v);\n\t\t\t\t\t\tchmin(low[v], low[u]);\n\t\t\t\t\t}\n\t\t\t\t\telse if(u != p and pre[u] < pre[v]) {\n\t\t\t\t\t\tup[v].eb(ssize(e_up));\n\t\t\t\t\t\te_up.eb(v, u);\n\t\t\t\t\t\tchmin(low[v], pre[u]);\n\t\t\t\t\t}\n\t\t\t};\n\t\t\tdfs_low(start, -1);\n\t\t\tV<pair<int, bool>> dsu(ssize(e_up));\n\t\t\tREP(v, ssize(dsu)) dsu[v].fi = v;\n\t\t\tfunction<pair<int, bool> (int)> find = [&](int v) {\n\t\t\t\tif(dsu[v].fi == v)\n\t\t\t\t\treturn pair(v, false);\n\t\t\t\tauto [u, ub] = find(dsu[v].fi);\n\t\t\t\treturn dsu[v] = pair(u, ub ^ dsu[v].se);\n\t\t\t};\n\t\t\tauto onion = [&](int x, int y, bool flip) {\n\t\t\t\tauto [v, vb] = find(x);\n\t\t\t\tauto [u, ub] = find(y);\n\t\t\t\tif(v == u)\n\t\t\t\t\treturn not (vb ^ ub ^ flip);\n\t\t\t\tdsu[v] = {u, vb ^ ub ^ flip};\n\t\t\t\treturn true;\n\t\t\t};\n\t\t\tauto interlace = [&](C vi &ids, int lo) {\n\t\t\t\tvi ans;\n\t\t\t\tfor(int e : ids)\n\t\t\t\t\tif(pre[e_up[e].se] > lo)\n\t\t\t\t\t\tans.eb(e);\n\t\t\t\treturn ans;\n\t\t\t};\n\t\t\tauto add_fu = [&](C vi &a, C vi &b) {\n\t\t\t\tFOR(k, 1, ssize(a) - 1)\n\t\t\t\t\tif(not onion(a[k - 1], a[k], 0))\n\t\t\t\t\t\treturn false;\n\t\t\t\tFOR(k, 1, ssize(b) - 1)\n\t\t\t\t\tif(not onion(b[k - 1], b[k], 0))\n\t\t\t\t\t\treturn false;\n\t\t\t\treturn a.empty() or b.empty() or onion(a[0], b[0], 1);\n\t\t\t};\n\t\t\tfunction<bool (int, int)> dfs_planar = [&](int v, int p) {\n\t\t\t\tfor(int u : dn[v])\n\t\t\t\t\tif(not dfs_planar(u, v))\n\t\t\t\t\t\treturn false;\n\t\t\t\tREP(i, ssize(dn[v])) {\n\t\t\t\t\tFOR(j, i + 1, ssize(dn[v]) - 1)\n\t\t\t\t\t\tif(not add_fu(interlace(up[dn[v][i]], low[dn[v][j]]),\n\t\t\t\t\t\t\t\t\t  interlace(up[dn[v][j]], low[dn[v][i]])))\n\t\t\t\t\t\t\treturn false;\n\t\t\t\t\tfor(int j : up[v]) {\n\t\t\t\t\t\tif(e_up[j].fi != v)\n\t\t\t\t\t\t\tcontinue;\n\t\t\t\t\t\tif(not add_fu(interlace(up[dn[v][i]], pre[e_up[j].se]),\n\t\t\t\t\t\t\t\t\t  interlace({j}, low[dn[v][i]])))\n\t\t\t\t\t\t\treturn false;\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t\tfor(int u : dn[v]) {\n\t\t\t\t\tfor(int idx : up[u])\n\t\t\t\t\t\tif(pre[e_up[idx].se] < pre[p])\n\t\t\t\t\t\t\tup[v].eb(idx);\n\t\t\t\t\texchange(up[u], {});\n\t\t\t\t}\n\t\t\t\treturn true;\n\t\t\t};\n\t\t\tif(not dfs_planar(start, -1))\n\t\t\t\treturn false;\n\t\t}\n\treturn true;\n}",
)

#code-entry(
  name: "scc",
  hash: "c5beb2",
  includes: (),
  opis: [konstruktor $cal(O)(n)$, get_compressed $cal(O)(n log  n)$. `group[v]` to numer silnie spójnej wierzchołka $v$, `order` to toposort, w którym krawędzie idą w lewo (z lewej są liście), `get_compressed()` zwraca graf silnie spójnych, `get_compressed(false)` nie usuwa multikrawędzi.],
  lang: "cpp",
  code: "struct SCC {\n\tint n;\n\tV<vi> &graph;\n\tint group_cnt = 0;\n\tvi group;\n\tV<vi> rev_graph;\n\tvi order;\n\tvoid order_dfs(int v) {\n\t\tgroup[v] = 1;\n\t\tfor(int u : rev_graph[v])\n\t\t\tif(group[u] == 0)\n\t\t\t\torder_dfs(u);\n\t\torder.eb(v);\n\t}\n\tvoid group_dfs(int v, int color) {\n\t\tgroup[v] = color;\n\t\tfor(int u : graph[v])\n\t\t\tif(group[u] == -1)\n\t\t\t\tgroup_dfs(u, color);\n\t}\n\tSCC(V<vi> &_graph) : graph(_graph) {\n\t\tn = ssize(graph);\n\t\trev_graph.resize(n);\n\t\tREP(v, n)\n\t\t\tfor(int u : graph[v])\n\t\t\t\trev_graph[u].eb(v);\n\t\tgroup.resize(n);\n\t\tREP(v, n)\n\t\t\tif(group[v] == 0)\n\t\t\t\torder_dfs(v);\n\t\treverse(all(order));\n\t\tdebug(order);\n\t\tgroup.assign(n, -1);\n\t\tfor(int v : order)\n\t\t\tif(group[v] == -1)\n\t\t\t\tgroup_dfs(v, group_cnt++);\n\t}\n\tV<vi> get_compressed(bool delete_same = true) {\n\t\tV<vi> ans(group_cnt);\n\t\tREP(v, n)\n\t\t\tfor(int u : graph[v])\n\t\t\t\tif(group[v] != group[u])\n\t\t\t\t\tans[group[v]].eb(group[u]);\n\t\tif(not delete_same)\n\t\t\treturn ans;\n\t\tREP(v, group_cnt) {\n\t\t\tsort(all(ans[v]));\n\t\t\tans[v].erase(unique(all(ans[v])), ans[v].end());\n\t\t}\n\t\treturn ans;\n\t}\n};",
)

#code-entry(
  name: "toposort",
  hash: "d0f178",
  includes: (),
  opis: [$cal(O)(n)$, `get_toposort_order(g)` zwraca listę wierzchołków takich, że krawędzie są od wierzchołków wcześniejszych w liście do późniejszych. `get_new_vertex_id_from_order(order)` zwraca odwrotność tej permutacji, tzn. dla każdego wierzchołka trzyma jego nowy numer, aby po przenumerowaniu grafu istniały krawędzie tylko do wierzchołków o większych numerach. `permute(elems, new_id)` zwraca przepermutowaną tablicę elems według nowych numerów wierzchołków (przydatne jak się trzyma informacje o wierzchołkach, a chce się zrobić przenumerowanie topologiczne). `renumerate_vertices(...)` zwraca nowy graf, w którym wierzchołki są przenumerowane. Nowy graf: `renumerate_vertices(graph, get_new_vertex_id_from_order(get_toposort_order(graph)))`.],
  lang: "cpp",
  code: "// BEGIN HASH 11a409\nvi get_toposort_order(V<vi> graph) {\n\tint n = ssize(graph);\n\tvi indeg(n);\n\tREP(v, n)\n\t\tfor(int u : graph[v])\n\t\t\t++indeg[u];\n\tvi que;\n\tREP(v, n)\n\t\tif(indeg[v] == 0)\n\t\t\tque.eb(v);\n\tvi ret;\n\twhile(not que.empty()) {\n\t\tint v = que.back();\n\t\tque.pop_back();\n\t\tret.eb(v);\n\t\tfor(int u : graph[v])\n\t\t\tif(--indeg[u] == 0)\n\t\t\t\tque.eb(u);\n\t}\n\treturn ret;\n} // END HASH\nvi get_new_vertex_id_from_order(vi order) {\n\tvi ret(ssize(order), -1);\n\tREP(v, ssize(order))\n\t\tret[order[v]] = v;\n\treturn ret;\n}\ntemplate<class T>\nV<T> permute(V<T> elems, vi new_id) {\n\tV<T> ret(ssize(elems));\n\tREP(v, ssize(elems))\n\t\tret[new_id[v]] = elems[v];\n\treturn ret;\n}\nV<vi> renumerate_vertices(V<vi> graph, vi new_id) {\n\tint n = ssize(graph);\n\tV<vi> ret(n);\n\tREP(v, n)\n\t\tfor(int u : graph[v])\n\t\t\tret[new_id[v]].eb(new_id[u]);\n\tREP(v, n)\n\t\tfor(int u : ret[v])\n\t\t\tassert(v < u);\n\treturn ret;\n}",
)

#code-entry(
  name: "triangles",
  hash: "5ccda1",
  includes: (),
  opis: [$cal(O)(m sqrt(m))$, liczenie możliwych kształtów podzbiorów trzy- i czterokrawędziowych. Suma zmiennych *3 daje liczbę spójnych 3-elementowych podzbiorów krawędzi, analogicznie suma zmiennych *4.],
  lang: "cpp",
  code: "struct Triangles {\n\tint triangles3 = 0;\n\tll stars3 = 0, paths3 = 0;\n\tll ps4 = 0, rectangles4 = 0, paths4 = 0;\n\t__int128_t ys4 = 0, stars4 = 0;\n\tTriangles(V<vi> &graph) {\n\t\tint n = ssize(graph);\n\t\tV<pii> sorted_deg(n);\n\t\tREP(i, n)\n\t\t\tsorted_deg[i] = {ssize(graph[i]), i};\n\t\tsort(all(sorted_deg));\n\t\tvi id(n);\n\t\tREP(i, n)\n\t\t\tid[sorted_deg[i].se] = i;\n\t\tvi cnt(n);\n\t\tREP(v, n) {\n\t\t\tfor(int u : graph[v]) if(id[v] > id[u])\n\t\t\t\tcnt[u] = 1;\n\t\t\tfor(int u : graph[v]) if(id[v] > id[u]) for(int w : graph[u]) if(id[w] > id[u] and cnt[w]) {\n\t\t\t\t++triangles3;\n\t\t\t\tfor(int x : {v, u, w})\n\t\t\t\t\tps4 += ssize(graph[x]) - 2;\n\t\t\t}\n\t\t\tfor(int u : graph[v]) if(id[v] > id[u])\n\t\t\t\tcnt[u] = 0;\n\t\t\tfor(int u : graph[v]) if(id[v] > id[u]) for(int w : graph[u]) if(id[v] > id[w])\n\t\t\t\trectangles4 += cnt[w]++;\n\t\t\tfor(int u : graph[v]) if(id[v] > id[u]) for(int w : graph[u])\n\t\t\t\tcnt[w] = 0;\n\t\t}\n\t\tpaths3 = -3 * triangles3;\n\t\tREP(v, n) for(int u : graph[v]) if(v < u)\n\t\t\tpaths3 += (ssize(graph[v]) - 1) * ll(ssize(graph[u]) - 1);\n\t\tys4 = -2 * ps4;\n\t\tauto choose2 = [&](int x) { return x * ll(x - 1) / 2; };\n\t\tREP(v, n) for(int u : graph[v])\n\t\t\tys4 += (ssize(graph[v]) - 1) * choose2(ssize(graph[u]) - 1);\n\t\tpaths4 = -(4 * rectangles4 + 2 * ps4 + 3 * triangles3);\n\t\tREP(v, n) {\n\t\t\tint x = 0;\n\t\t\tfor(int u : graph[v]) {\n\t\t\t\tx += ssize(graph[u]) - 1;\n\t\t\t\tpaths4 -= choose2(ssize(graph[u]) - 1);\n\t\t\t}\n\t\t\tpaths4 += choose2(x);\n\t\t}\n\t\tREP(v, n) {\n\t\t\tint s = ssize(graph[v]);\n\t\t\tstars3 += s * ll(s - 1) * ll(s - 2);\n\t\t\tstars4 += s * ll(s - 1) * ll(s - 2) * __int128_t(s - 3);\n\t\t}\n\t\tstars3 /= 6;\n\t\tstars4 /= 24;\n\t}\n};",
)

#my-chapter("Flowy i matchingi")

#code-entry(
  name: "blossom",
  hash: "0c4c58",
  includes: (),
  opis: [Jeden rabin powie $cal(O)("nm")$, drugi rabin powie, że to nawet nie jest $cal(O)(n^3)$. W grafie nie może być pętelek. Funkcja zwraca match'a, tzn `match[v] == -1` albo z kim jest sparowany $v$. Rozmiar matchingu to $(1)/(2)sum "_v" `"int"("match"[v] != -1)`$.],
  lang: "cpp",
  code: "vi blossom(V<vi> graph) {\n\tint n = ssize(graph), timer = -1;\n\tREP(v, n)\n\t\tfor(int u : graph[v])\n\t\t\tassert(v != u);\n\tvi match(n, -1), label(n), parent(n), orig(n), aux(n, -1), q;\n\tauto lca = [&](int x, int y) {\n\t\tfor(++timer; ; swap(x, y)) {\n\t\t\tif(x == -1)\n\t\t\t\tcontinue;\n\t\t\tif(aux[x] == timer)\n\t\t\t\treturn x;\n\t\t\taux[x] = timer;\n\t\t\tx = (match[x] == -1 ? -1 : orig[parent[match[x]]]);\n\t\t}\n\t};\n\tauto blossom = [&](int v, int w, int a) {\n\t\twhile(orig[v] != a) {\n\t\t\tparent[v] = w;\n\t\t\tw = match[v];\n\t\t\tif(label[w] == 1) {\n\t\t\t\tlabel[w] = 0;\n\t\t\t\tq.eb(w);\n\t\t\t}\n\t\t\torig[v] = orig[w] = a;\n\t\t\tv = parent[w];\n\t\t}\n\t};\n\tauto augment = [&](int v) {\n\t\twhile(v != -1) {\n\t\t\tint pv = parent[v], nv = match[pv];\n\t\t\tmatch[v] = pv;\n\t\t\tmatch[pv] = v;\n\t\t\tv = nv;\n\t\t}\n\t};\n\tauto bfs = [&](int root) {\n\t\tfill(all(label), -1);\n\t\tiota(all(orig), 0);\n\t\tlabel[root] = 0;\n\t\tq = {root};\n\t\tREP(i, ssize(q)) {\n\t\t\tint v = q[i];\n\t\t\tfor(int x : graph[v])\n\t\t\t\tif(label[x] == -1) {\n\t\t\t\t\tlabel[x] = 1;\n\t\t\t\t\tparent[x] = v;\n\t\t\t\t\tif(match[x] == -1) {\n\t\t\t\t\t\taugment(x);\n\t\t\t\t\t\treturn 1;\n\t\t\t\t\t}\n\t\t\t\t\tlabel[match[x]] = 0;\n\t\t\t\t\tq.eb(match[x]);\n\t\t\t\t}\n\t\t\t\telse if(label[x] == 0 and orig[v] != orig[x]) {\n\t\t\t\t\tint a = lca(orig[v], orig[x]);\n\t\t\t\t\tblossom(x, v, a);\n\t\t\t\t\tblossom(v, x, a);\n\t\t\t\t}\n\t\t}\n\t\treturn 0;\n\t};\n\tREP(i, n)\n\t\tif(match[i] == -1)\n\t\t\tbfs(i);\n\treturn match;\n}",
)

#code-entry(
  name: "dinic",
  hash: "da1c73",
  includes: (),
  opis: [$cal(O)(V^2 E)$ Dinic bez skalowania. funkcja `get_flowing()` zwraca dla każdej oryginalnej krawędzi ile przez nią leci.],
  lang: "cpp",
  code: "struct Dinic {\n\tusing T = int;\n\tstruct Edge {\n\t\tint v, u;\n\t\tT flow, cap;\n\t};\n\tint n;\n\tV<vi> graph;\n\tV<Edge> edges;\n\tDinic(int N) : n(N), graph(n) {}\n\tvoid add_edge(int v, int u, T cap) {\n\t\tdebug(v, u, cap);\n\t\tint e = ssize(edges);\n\t\tgraph[v].eb(e);\n\t\tgraph[u].eb(e + 1);\n\t\tedges.eb(v, u, 0, cap);\n\t\tedges.eb(u, v, 0, 0);\n\t}\n\tvi dist;\n\tbool bfs(int source, int sink) {\n\t\tdist.assign(n, 0);\n\t\tdist[source] = 1;\n\t\tdeque<int> que = {source};\n\t\twhile(ssize(que) and dist[sink] == 0) {\n\t\t\tint v = que.front();\n\t\t\tque.pop_front();\n\t\t\tfor(int e : graph[v])\n\t\t\t\tif(edges[e].flow != edges[e].cap and dist[edges[e].u] == 0) {\n\t\t\t\t\tdist[edges[e].u] = dist[v] + 1;\n\t\t\t\t\tque.eb(edges[e].u);\n\t\t\t\t}\n\t\t}\n\t\treturn dist[sink] != 0;\n\t}\n\tvi ended_at;\n\tT dfs(int v, int sink, T flow = numeric_limits<T>::max()) {\n\t\tif(flow == 0 or v == sink)\n\t\t\treturn flow;\n\t\tfor(; ended_at[v] != ssize(graph[v]); ++ended_at[v]) {\n\t\t\tEdge &e = edges[graph[v][ended_at[v]]];\n\t\t\tif(dist[v] + 1 == dist[e.u])\n\t\t\t\tif(T pushed = dfs(e.u, sink, min(flow, e.cap - e.flow))) {\n\t\t\t\t\te.flow += pushed;\n\t\t\t\t\tedges[graph[v][ended_at[v]] ^ 1].flow -= pushed;\n\t\t\t\t\treturn pushed;\n\t\t\t\t}\n\t\t}\n\t\treturn 0;\n\t}\n\tT operator()(int source, int sink) {\n\t\tT answer = 0;\n\t\twhile(bfs(source, sink)) {\n\t\t\tended_at.assign(n, 0);\n\t\t\twhile(T pushed = dfs(source, sink))\n\t\t\t\tanswer += pushed;\n\t\t}\n\t\treturn answer;\n\t}\n\tmap<pii, T> get_flowing() {\n\t\tmap<pii, T> ret;\n\t\tREP(v, n)\n\t\t\tfor(int i : graph[v]) {\n\t\t\t\tif(i % 2) // considering only original edges\n\t\t\t\t\tcontinue;\n\t\t\t\tEdge &e = edges[i];\n\t\t\t\tret[pair(v, e.u)] += e.flow;\n\t\t\t}\n\t\treturn ret;\n\t}\n};",
)

#code-entry(
  name: "gomory-hu",
  hash: "8cbc22",
  includes: ("dinic",),
  opis: [$cal(O)(n^2 + "ndot"  "dinic"(n, m))$, zwraca min cięcie między każdą parą wierzchołków w nieskierowanym ważonym grafie o nieujemnych wagach. `gomory_hu(n, edges)[s][t] == min cut (s, t)`],
  lang: "cpp",
  code: "pair<Dinic::T, V<bool>> get_min_cut(Dinic &dinic, int s, int t) {\n\tfor(Dinic::Edge &e : dinic.edges)\n\t\te.flow = 0;\n\tDinic::T flow = dinic(s, t);\n\tV<bool> cut(dinic.n);\n\tREP(v, dinic.n)\n\t\tcut[v] = bool(dinic.dist[v]);\n\treturn {flow, cut};\n}\nV<V<Dinic::T>> get_gomory_hu(int n, V<tuple<int, int, Dinic::T>> edges) {\n\tDinic dinic(n);\n\tfor(auto [v, u, cap] : edges) {\n\t\tdinic.add_edge(v, u, cap);\n\t\tdinic.add_edge(u, v, cap);\n\t}\n\tusing T = Dinic::T;\n\tV<V<pair<int, T>>> tree(n);\n\tvi par(n, 0);\n\tFOR(v, 1, n - 1) {\n\t\tauto [flow, cut] = get_min_cut(dinic, v, par[v]);\n\t\tFOR(u, v + 1, n - 1)\n\t\t\tif(cut[u] == cut[v] and par[u] == par[v])\n\t\t\t\tpar[u] = v;\n\t\ttree[v].eb(par[v], flow);\n\t\ttree[par[v]].eb(v, flow);\n\t}\n\tT inf = numeric_limits<T>::max();\n\tV ret(n, V(n, inf));\n\tREP(source, n) {\n\t\tfunction<void (int, int, T)> dfs = [&](int v, int p, T mn) {\n\t\t\tret[source][v] = mn;\n\t\t\tfor(auto [u, flow] : tree[v])\n\t\t\t\tif(u != p)\n\t\t\t\t\tdfs(u, v, min(mn, flow));\n\t\t};\n\t\tdfs(source, -1, inf);\n\t}\n\treturn ret;\n}",
)

#code-entry(
  name: "hopcroft-karp",
  hash: "489276",
  includes: (),
  opis: [$cal(O)(m sqrt(n))$ Hopcroft-Karp do liczenia matchingu. Przydaje się głównie w aproksymacji, ponieważ po $k$ iteracjach gwarantuje matching o rozmiarze przynajmniej $(k/(k+1)) dot $ best matching. Wierzchołki grafu muszą być podzielone na warstwy $[0, "n_0")$ oraz $["n_0", "n_0"+"n_1")$. Zwraca rozmiar matchingu oraz przypisanie (lub -1, gdy nie jest zmatchowane).],
  lang: "cpp",
  code: "pair<int, vi> hopcroft_karp(V<vi> graph, int n0, int n1) {\n\tassert(n0 + n1 == ssize(graph));\n\tREP(v, n0 + n1)\n\t\tfor(int u : graph[v])\n\t\t\tassert((v < n0) != (u < n0));\n\tvi matched_with(n0 + n1, -1), dist(n0 + 1);\n\tconstexpr int inf = int(1e9);\n\tvi manual_que(n0 + 1);\n\tauto bfs = [&] {\n\t\tint head = 0, tail = -1;\n\t\tfill(all(dist), inf);\n\t\tREP(v, n0)\n\t\t\tif(matched_with[v] == -1) {\n\t\t\t\tdist[1 + v] = 0;\n\t\t\t\tmanual_que[++tail] = v;\n\t\t\t}\n\t\twhile(head <= tail) {\n\t\t\tint v = manual_que[head++];\n\t\t\tif(dist[1 + v] < dist[0])\n\t\t\t\tfor(int u : graph[v])\n\t\t\t\t\tif(dist[1 + matched_with[u]] == inf) {\n\t\t\t\t\t\tdist[1 + matched_with[u]] = dist[1 + v] + 1;\n\t\t\t\t\t\tmanual_que[++tail] = matched_with[u];\n\t\t\t\t\t}\n\t\t}\n\t\treturn dist[0] != inf;\n\t};\n\tfunction<bool (int)> dfs = [&](int v) {\n\t\tif(v == -1)\n\t\t\treturn true;\n\t\tfor(auto u : graph[v])\n\t\t\tif(dist[1 + matched_with[u]] == dist[1 + v] + 1) {\n\t\t\t\tif(dfs(matched_with[u])) {\n\t\t\t\t\tmatched_with[v] = u;\n\t\t\t\t\tmatched_with[u] = v;\n\t\t\t\t\treturn true;\n\t\t\t\t}\n\t\t\t}\n\t\tdist[1 + v] = inf;\n\t\treturn false;\n\t};\n\tint answer = 0;\n\tfor(int iter = 0; bfs(); ++iter)\n\t\tREP(v, n0)\n\t\t\tif(matched_with[v] == -1 and dfs(v))\n\t\t\t\t++answer;\n\treturn {answer, matched_with};\n}",
)

#code-entry(
  name: "hungarian",
  hash: "9a79f8",
  includes: (),
  opis: [$cal(O)("n_0"^2dot  "n_1")$, dla macierzy wag (mogą być ujemne) między dwoma warstami o rozmiarach $"n_0"$ oraz $"n_1"$ ($"n_0" <= "n_1"$) wyznacza minimalną sumę wag skojarzenia pełnego. Zwraca sumę wag oraz matching.],
  lang: "cpp",
  code: "pair<ll, vi> hungarian(V<vi> a) {\n\tif(a.empty())\n\t\treturn {0, {}};\n\tint n0 = ssize(a) + 1, n1 = ssize(a[0]) + 1;\n    assert(n0 <= n1);\n\tvi p(n1), ans(n0 - 1);\n\tvll u(n0), v(n1);\n\tFOR(i, 1, n0 - 1) {\n\t\tp[0] = i;\n\t\tint j0 = 0;\n\t\tvll dist(n1, numeric_limits<ll>::max());\n\t\tvi pre(n1, -1);\n\t\tV<bool> done(n1 + 1);\n\t\tdo {\n\t\t\tdone[j0] = true;\n\t\t\tint i0 = p[j0], j1 = -1;\n\t\t\tll delta = numeric_limits<ll>::max();\n\t\t\tFOR(j, 1, n1 - 1)\n\t\t\t\tif(!done[j]) {\n\t\t\t\t\tauto cur = a[i0 - 1][j - 1] - u[i0] - v[j];\n\t\t\t\t\tif(cur < dist[j])\n\t\t\t\t\t\tdist[j] = cur, pre[j] = j0;\n\t\t\t\t\tif(dist[j] < delta)\n\t\t\t\t\t\tdelta = dist[j], j1 = j;\n\t\t\t\t}\n\t\t\tREP(j, n1) {\n\t\t\t\tif(done[j])\n\t\t\t\t\tu[p[j]] += delta, v[j] -= delta;\n\t\t\t\telse\n\t\t\t\t\tdist[j] -= delta;\n\t\t\t}\n\t\t\tj0 = j1;\n\t\t} while(p[j0]);\n\t\twhile(j0) {\n\t\t\tint j1 = pre[j0];\n\t\t\tp[j0] = p[j1], j0 = j1;\n\t\t}\n\t}\n\tFOR(j, 1, n1 - 1)\n\t\tif(p[j])\n\t\t\tans[p[j] - 1] = j - 1;\n\treturn {-v[0], ans};\n}",
)

#code-entry(
  name: "konig-theorem",
  hash: "c05211",
  includes: ("matching",),
  opis: [$cal(O)(n + "matching"(n, m))$ wyznaczanie w grafie dwudzielnym kolejno minimalnego pokrycia krawędziowego (PK), maksymalnego zbioru niezależnych wierzchołków (NW), minimalnego pokrycia wierzchołkowego (PW) korzystając z maksymalnego zbioru niezależnych krawędzi (NK) (tak zwany matching). Z tw. Koniga zachodzi |NK|=n-|PK|=n-|NW|=|PW|.],
  lang: "cpp",
  code: "// BEGIN HASH 320322\nV<pii> get_min_edge_cover(V<vi> graph) {\n\tvi match = Matching(graph)().se;\n\tV<pii> ret;\n\tREP(v, ssize(match))\n\t\tif(match[v] != -1 and v < match[v])\n\t\t\tret.eb(v, match[v]);\n\t\telse if(match[v] == -1 and not graph[v].empty())\n\t\t\tret.eb(v, graph[v].front());\n\treturn ret;\n} // END HASH\n// BEGIN HASH f215ab\narray<vi, 2> get_coloring(V<vi> graph) {\n\tint n = ssize(graph);\n\tvi match = Matching(graph)().se;\n\tvi color(n, -1);\n\tfunction<void (int)> dfs = [&](int v) {\n\t\tcolor[v] = 0;\n\t\tfor(int u : graph[v])\n\t\t\tif(color[u] == -1) {\n\t\t\t\tcolor[u] = true;\n\t\t\t\tdfs(match[u]);\n\t\t\t}\n\t};\n\tREP(v, n)\n\t\tif(match[v] == -1)\n\t\t\tdfs(v);\n\tREP(v, n)\n\t\tif(color[v] == -1)\n\t\t\tdfs(v);\n\tarray<vi, 2> groups;\n\tREP(v, n)\n\t\tgroups[color[v]].eb(v);\n\treturn groups;\n}\nvi get_max_independent_set(V<vi> graph) {\n\treturn get_coloring(graph)[0];\n}\nvi get_min_vertex_cover(V<vi> graph) {\n\treturn get_coloring(graph)[1];\n} // END HASH",
)

#code-entry(
  name: "matching",
  hash: "d28b80",
  includes: (),
  opis: [Średnio około $cal(O)(n log  n)$, najgorzej $cal(O)(n^2)$. Wierzchołki grafu nie muszą być ładnie podzielone na dwia przedziały, musi być po prostu dwudzielny. Na przykład `auto [match_size, match] = Matching(graph)();`],
  lang: "cpp",
  code: "struct Matching {\n\tV<vi> &adj;\n\tvi mat, vis;\n\tint t = 0, ans = 0;\n\tbool mat_dfs(int v) {\n\t\tvis[v] = t;\n\t\tfor(int u : adj[v])\n\t\t\tif(mat[u] == -1) {\n\t\t\t\tmat[u] = v;\n\t\t\t\tmat[v] = u;\n\t\t\t\treturn true;\n\t\t\t}\n\t\tfor(int u : adj[v])\n\t\t\tif(vis[mat[u]] != t && mat_dfs(mat[u])) {\n\t\t\t\tmat[u] = v;\n\t\t\t\tmat[v] = u;\n\t\t\t\treturn true;\n\t\t\t}\n\t\treturn false;\n\t}\n\tMatching(V<vi> &_adj) : adj(_adj) {\n\t\tmat = vis = vi(ssize(adj), -1);\n\t}\n\tpair<int, vi> operator()() {\n\t\tint d = -1;\n\t\twhile(d != 0) {\n\t\t\td = 0, ++t;\n\t\t\tREP(v, ssize(adj))\n\t\t\t\tif(mat[v] == -1)\n\t\t\t\t\td += mat_dfs(v);\n\t\t\tans += d;\n\t\t}\n\t\treturn {ans, mat};\n\t}\n};",
)

#code-entry(
  name: "mcmf-dijkstra",
  hash: "4d7e5d",
  includes: (),
  opis: [$cal(O)(V dot E + |"flow"| E log  V)$, Min-cost max-flow. Można przepisać funkcję get_flowing() z Dinic'a. Kiedy wie się coś więcej o początkowym grafie np. że jest DAG-iem lub że ma tylko nieujemne wagi krawędzi, można napisać własne calc_init_dist by usunąć $V dot E$ ze złożoności. Jeżeli $E = $cal(O)(V^2)$$, to może być lepiej napisać samemu kwadratową dijkstrę.],
  lang: "cpp",
  code: "struct MCMF {\n\tstruct Edge {\n\t\tint v, u, flow, cap;\n\t\tll cost;\n\t\tfriend ostream& operator<<(ostream &os, Edge &e) {\n\t\t\treturn os << vll{e.v, e.u, e.flow, e.cap, e.cost};\n\t\t}\n\t};\n\tint n;\n\tC ll inf_LL = 1e18;\n\tC int inf_int = 1e9;\n\tV<vi> graph;\n\tV<Edge> edges;\n\tvll init_dist;\n\tMCMF(int N) : n(N), graph(n), init_dist(n) {}\n\tvoid add_edge(int v, int u, int cap, ll cost) {\n\t\tint e = ssize(edges);\n\t\tgraph[v].eb(e);\n\t\tgraph[u].eb(e + 1);\n\t\tedges.eb(v, u, 0, cap, cost);\n\t\tedges.eb(u, v, 0, 0, -cost);\n\t}\n\tvoid calc_init_dist(int source) {\n\t\tfill(all(init_dist), inf_LL);\n\t\tV<bool> inside(n);\n\t\tinside[source] = true;\n\t\tdeque<int> que = {source};\n\t\tinit_dist[source] = 0;\n\t\twhile (ssize(que)) {\n\t\t\tint v = que.front();\n\t\t\tque.pop_front();\n\t\t\tinside[v] = false;\n\t\t\tfor (int i : graph[v]) {\n\t\t\t\tEdge &e = edges[i];\n\t\t\t\tif (e.flow < e.cap and init_dist[v] + e.cost < init_dist[e.u]) {\n\t\t\t\t\tinit_dist[e.u] = init_dist[v] + e.cost;\n\t\t\t\t\tif (not inside[e.u]) {\n\t\t\t\t\t\tinside[e.u] = true;\n\t\t\t\t\t\tque.eb(e.u);\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t}\n\tpair<int, ll> augment(int source, int sink) {\n\t\tV<bool> vis(n);\n\t\tvi from(n, -1);\n\t\tvll dist(n, inf_LL);\n\t\tpriority_queue<pair<ll, int>, V<pair<ll, int>>, greater<>> que;\n\t\tque.emplace(0, source);\n\t\tdist[source] = 0;\n\t\twhile(ssize(que)) {\n\t\t\tauto [d, v] = que.top();\n\t\t\tque.pop();\n\t\t\tif (vis[v]) continue;\n\t\t\tvis[v] = true;\n\t\t\tfor (int i : graph[v]) {\n\t\t\t\tEdge &e = edges[i];\n\t\t\t\tll new_dist = d + e.cost + init_dist[v];\n\t\t\t\tif (not vis[e.u] and e.flow != e.cap and new_dist < dist[e.u]) {\n\t\t\t\t\tdist[e.u] = new_dist;\n\t\t\t\t\tfrom[e.u] = i;\n\t\t\t\t\tque.emplace(new_dist - init_dist[e.u], e.u);\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t\tif (not vis[sink])\n\t\t\treturn {0, 0};\n\t\tint flow = inf_int, e = from[sink];\n\t\twhile(e != -1) {\n\t\t\tchmin(flow, edges[e].cap - edges[e].flow);\n\t\t\te = from[edges[e].v];\n\t\t}\n\t\te = from[sink];\n\t\twhile(e != -1) {\n\t\t\tedges[e].flow += flow;\n\t\t\tedges[e ^ 1].flow -= flow;\n\t\t\te = from[edges[e].v];\n\t\t}\n\t\tinit_dist.swap(dist);\n\t\treturn {flow, flow * init_dist[sink]};\n\t}\n\tpair<int, ll> operator()(int source, int sink) {\n\t\tcalc_init_dist(source);\n\t\tint flow = 0;\n\t\tll cost = 0;\n\t\tpair<int, ll> got;\n\t\tdo {\n\t\t\tgot = augment(source, sink);\n\t\t\tflow += got.fi;\n\t\t\tcost += got.se;\n\t\t} while(got.fi);\n\t\treturn {flow, cost};\n\t}\n};",
)

#code-entry(
  name: "mcmf-spfa",
  hash: "43da52",
  includes: (),
  opis: [$cal(O)("idk")$, Min-cost max-flow z SPFA. Można przepisać funkcję get_flowing() z Dinic'a.],
  lang: "cpp",
  code: "struct MCMF {\n\tstruct Edge {\n\t\tint v, u, flow, cap;\n\t\tll cost;\n\t\tfriend ostream& operator<<(ostream &os, Edge &e) {\n\t\t\treturn os << vll{e.v, e.u, e.flow, e.cap, e.cost};\n\t\t}\n\t};\n\tint n;\n\tC ll inf_LL = 1e18;\n\tC int inf_int = 1e9;\n\tV<vi> graph;\n\tV<Edge> edges;\n\tMCMF(int N) : n(N), graph(n) {}\n\tvoid add_edge(int v, int u, int cap, ll cost) {\n\t\tint e = ssize(edges);\n\t\tgraph[v].eb(e);\n\t\tgraph[u].eb(e + 1);\n\t\tedges.eb(v, u, 0, cap, cost);\n\t\tedges.eb(u, v, 0, 0, -cost);\n\t}\n\tpair<int, ll> augment(int source, int sink) {\n\t\tvll dist(n, inf_LL);\n\t\tvi from(n, -1);\n\t\tdist[source] = 0;\n\t\tdeque<int> que = {source};\n\t\tV<bool> inside(n);\n\t\tinside[source] = true;\n\t\twhile(ssize(que)) {\n\t\t\tint v = que.front();\n\t\t\tinside[v] = false;\n\t\t\tque.pop_front();\n\t\t\tfor(int i : graph[v]) {\n\t\t\t\tEdge &e = edges[i];\n\t\t\t\tif(e.flow != e.cap and dist[e.u] > dist[v] + e.cost) {\n\t\t\t\t\tdist[e.u] = dist[v] + e.cost;\n\t\t\t\t\tfrom[e.u] = i;\n\t\t\t\t\tif(not inside[e.u]) {\n\t\t\t\t\t\tinside[e.u] = true;\n\t\t\t\t\t\tque.eb(e.u);\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t\tif(from[sink] == -1)\n\t\t\treturn {0, 0};\n\t\tint flow = inf_int, e = from[sink];\n\t\twhile(e != -1) {\n\t\t\tchmin(flow, edges[e].cap - edges[e].flow);\n\t\t\te = from[edges[e].v];\n\t\t}\n\t\te = from[sink];\n\t\twhile(e != -1) {\n\t\t\tedges[e].flow += flow;\n\t\t\tedges[e ^ 1].flow -= flow;\n\t\t\te = from[edges[e].v];\n\t\t}\n\t\treturn {flow, flow * dist[sink]};\n\t}\n\tpair<int, ll> operator()(int source, int sink) {\n\t\tint flow = 0;\n\t\tll cost = 0;\n\t\tpair<int, ll> got;\n\t\tdo {\n\t\t\tgot = augment(source, sink);\n\t\t\tflow += got.fi;\n\t\t\tcost += got.se;\n\t\t} while(got.fi);\n\t\treturn {flow, cost};\n\t}\n};",
)

#code-entry(
  name: "weighted-blossom",
  hash: "85551c",
  includes: (),
  opis: [$cal(O)(N^3)$ (but fast in practice) Taken from: https://judge.yosupo.jp/submission/218005 pdfcompile, weighted_matching::init(n), weighted_matching::add_edge(a, b, c) V<pii> temp, weighted_matching::solve(temp).fi],
  lang: "cpp",
  code: "#define pii pii\nnamespace weighted_matching{\nC int INF = (int)1e9 + 7;\nC int MAXN = 1050; //double of possible N\nstruct E{\n\tint x, y, w;\n};\nint n, m;\nE G[MAXN][MAXN];\nint lab[MAXN], match[MAXN], slack[MAXN], st[MAXN], pa[MAXN], flo_from[MAXN][MAXN], S[MAXN], vis[MAXN];\nvi flo[MAXN];\nqueue<int> Q;\nvoid init(int _n) {\n\tn = _n;\n\tfor(int x = 1; x <= n; ++x)\n\t\tfor(int y = 1; y <= n; ++y)\n\t\t\tG[x][y] = E{x, y, 0};\n}\nvoid add_edge(int x, int y, int w) {\n\tG[x][y].w = G[y][x].w = w;\n}\nint e_delta(E e) {\n\treturn lab[e.x] + lab[e.y] - G[e.x][e.y].w * 2;\n}\nvoid update_slack(int u, int x) {\n\tif(!slack[x] || e_delta(G[u][x]) < e_delta(G[slack[x]][x]))\n\t\tslack[x] = u;\n}\nvoid set_slack(int x) {\n\tslack[x] = 0;\n\tfor(int u = 1; u <= n; ++u)\n\t\tif(G[u][x].w > 0 && st[u] != x && S[st[u]] == 0)\n\t\t\tupdate_slack(u, x);\n}\nvoid q_push(int x) {\n\tif(x <= n) Q.push(x);\n\telse for(int i = 0; i < (int)flo[x].size(); ++i)\n\t\tq_push(flo[x][i]);\n}\nvoid set_st(int x, int b) {\n\tst[x] = b;\n\tif(x > n) for(int i = 0; i < (int)flo[x].size(); ++i)\n\t\tset_st(flo[x][i], b);\n}\nint get_pr(int b, int xr) {\n\tint pr = find(all(flo[b]), xr) - flo[b].begin();\n\tif(pr & 1) {\n\t\treverse(flo[b].begin() + 1, flo[b].end());\n\t\treturn (int)flo[b].size() - pr;\n\t}\n\telse return pr;\n}\nvoid set_match(int x, int y) {\n\tmatch[x] = G[x][y].y;\n\tif(x <= n) return;\n\tE e = G[x][y];\n\tint xr = flo_from[x][e.x], pr = get_pr(x, xr);\n\tfor(int i = 0; i < pr; ++i) set_match(flo[x][i], flo[x][i^1]);\n\tset_match(xr, y);\n\trotate(flo[x].begin(), flo[x].begin() + pr, flo[x].end());\n}\nvoid augment(int x, int y) {\n\twhile(1) {\n\t\tint ny = st[match[x]];\n\t\tset_match(x, y);\n\t\tif(!ny) return;\n\t\tset_match(ny, st[pa[ny]]);\n\t\tx = st[pa[ny]], y = ny;\n\t}\n}\nint get_lca(int x, int y) {\n\tstatic int t = 0;\n\tfor(++t; x || y; swap(x, y)) {\n\t\tif(x == 0) continue;\n\t\tif(vis[x] == t) return x;\n\t\tvis[x] = t;\n\t\tx = st[match[x]];\n\t\tif(x) x = st[pa[x]];\n\t}\n\treturn 0;\n}\nvoid add_blossom(int x, int l, int y) {\n\tint b = n + 1;\n\twhile(b <= m && st[b]) ++b;\n\tif(b > m) ++m;\n\tlab[b] = 0, S[b] = 0;\n\tmatch[b] = match[l];\n\tflo[b].clear();\n\tflo[b].pb(l);\n\tfor(int u = x, v; u != l; u = st[pa[v]])\n\t\tflo[b].pb(u), flo[b].pb(v = st[match[u]]), q_push(v);\n\treverse(flo[b].begin() + 1, flo[b].end());\n\tfor(int u = y, v; u != l; u = st[pa[v]])\n\t\tflo[b].pb(u), flo[b].pb(v = st[match[u]]), q_push(v);\n\tset_st(b, b);\n\tfor(int i = 1; i <= m; ++i) G[b][i].w = G[i][b].w = 0;\n\tfor(int i = 1; i <= n; ++i) flo_from[b][i] = 0;\n\tfor(int i = 0; i < (int)flo[b].size(); ++i) {\n\t\tint us = flo[b][i];\n\t\tfor(int u = 1; u <= m; ++u)\n\t\t\tif(G[b][u].w == 0 || e_delta(G[us][u]) < e_delta(G[b][u]))\n\t\t\t\tG[b][u] = G[us][u], G[u][b] = G[u][us];\n\t\tfor(int u = 1; u <= n; ++u)\n\t\t\tif(flo_from[us][u])\n\t\t\t\tflo_from[b][u] = us;\n\t}\n\tset_slack(b);\n}\nvoid expand_blossom(int b) {\n\tfor(int i = 0; i < (int)flo[b].size(); ++i)\n\t\tset_st(flo[b][i], flo[b][i]);\n\tint xr = flo_from[b][G[b][pa[b]].x], pr = get_pr(b, xr);\n\tfor(int i = 0; i < pr; i += 2) {\n\t\tint xs = flo[b][i], xns = flo[b][i + 1];\n\t\tpa[xs] = G[xns][xs].x;\n\t\tS[xs] = 1, S[xns] = 0;\n\t\tslack[xs] = 0, set_slack(xns);\n\t\tq_push(xns);\n\t}\n\tS[xr] = 1, pa[xr] = pa[b];\n\tfor(int i = pr + 1; i < (int)flo[b].size(); ++i) {\n\t\tint xs = flo[b][i];\n\t\tS[xs] = -1, set_slack(xs);\n\t}\n\tst[b] = 0;\n}\nbool on_found_edge(E e) {\n\tint x = st[e.x], y = st[e.y];\n\tif(S[y] == -1) {\n\t\tpa[y] = e.x, S[y] = 1;\n\t\tint ny = st[match[y]];\n\t\tslack[y] = slack[ny] = 0;\n\t\tS[ny] = 0, q_push(ny);\n\t}\n\telse if(S[y] == 0) {\n\t\tint l = get_lca(x, y);\n\t\tif(!l) return augment(x, y), augment(y, x), true;\n\t\telse add_blossom(x, l, y);\n\t}\n\treturn false;\n}\nbool matching() {\n\tfill(S + 1, S + m + 1, -1);\n\tfill(slack + 1, slack + m + 1, 0);\n\tQ = queue<int>();\n\tfor(int x = 1; x <= m; ++x)\n\t\tif(st[x] == x && !match[x]) pa[x] = 0, S[x] = 0, q_push(x);\n\tif(Q.empty()) return false;\n\twhile(1) {\n\t\twhile(Q.size()) {\n\t\t\tint x = Q.front(); Q.pop();\n\t\t\tif(S[st[x]] == 1) continue;\n\t\t\tfor(int y = 1; y <= n; ++y) {\n\t\t\t\tif(G[x][y].w > 0 && st[x] != st[y]) {\n\t\t\t\t\tif(e_delta(G[x][y]) == 0) {\n\t\t\t\t\t\tif(on_found_edge(G[x][y])) return true;\n\t\t\t\t\t}\n\t\t\t\t\telse update_slack(x, st[y]);\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t\tint d = INF;\n\t\tfor(int b = n + 1; b <= m; ++b)\n\t\t\tif(st[b] == b && S[b] == 1) chmin(d, lab[b] / 2);\n\t\tfor(int x = 1; x <= m; ++x)\n\t\t\tif(st[x] == x && slack[x]) {\n\t\t\t\tif(S[x] == -1) chmin(d, e_delta(G[slack[x]][x]));\n\t\t\t\telse if(S[x] == 0) chmin(d, e_delta(G[slack[x]][x]) / 2);\n\t\t\t}\n\t\tfor(int x = 1; x <= n; ++x) {\n\t\t\tif(S[st[x]] == 0) {\n\t\t\t\tif(lab[x] <= d) return 0;\n\t\t\t\tlab[x] -= d;\n\t\t\t}\n\t\t\telse if(S[st[x]] == 1) lab[x] += d;\n\t\t}\n\t\tfor(int b = n + 1; b <= m; ++b)\n\t\t\tif(st[b] == b) {\n\t\t\t\tif(S[st[b]] == 0) lab[b] += d * 2;\n\t\t\t\telse if(S[st[b]] == 1) lab[b] -= d * 2;\n\t\t\t}\n\t\tQ = queue<int>();\n\t\tfor(int x = 1; x <= m; ++x)\n\t\t\tif(st[x] == x && slack[x] && st[slack[x]] != x && e_delta(G[slack[x]][x]) == 0)\n\t\t\t\tif(on_found_edge(G[slack[x]][x])) return true;\n\t\tfor(int b = n + 1; b <= m; ++b)\n\t\t\tif(st[b] == b && S[b] == 1 && lab[b] == 0)\n\t\t\t\texpand_blossom(b);\n\t}\n\treturn false;\n}\npair<ll, int> solve(V<pii> &ans) {\n\tfill(match + 1, match + n + 1, 0);\n\tm = n;\n\tint cnt = 0; ll sum = 0;\n\tfor(int u = 0; u <= n; ++u) st[u] = u, flo[u].clear();\n\tint mx = 0;\n\tfor(int x = 1; x <= n; ++x)\n\t\tfor(int y = 1; y <= n; ++y){\n\t\t\tflo_from[x][y] = (x == y ? x : 0);\n\t\t\tchmax(mx, G[x][y].w);\n\t\t}\n\tfor(int x = 1; x <= n; ++x) lab[x] = mx;\n\twhile(matching()) ++cnt;\n\tfor(int x = 1; x <= n; ++x)\n\t\tif(match[x] && match[x] < x) {\n\t\t\tsum += G[x][match[x]].w;\n\t\t\tans.pb({x, G[x][match[x]].y});\n\t\t}\n\treturn {sum, cnt};\n}\n}",
)

#my-chapter("Geometria")

#code-entry(
  name: "advanced-complex",
  hash: "bcc8b5",
  includes: ("point",),
  opis: [Większość nie działa dla intów.],
  lang: "cpp",
  code: "constexpr D pi = acosl(-1);\n// nachylenie k-> y = kx + m\nD slope(P a, P b) { return tan(arg(b - a)); }\n// rzut p na ab\nP project(P p, P a, P b) {\n\treturn a + (b - a) * dot(p - a, b - a) / norm(a - b);\n}\n// odbicie p wzgledem ab\nP reflect(P p, P a, P b) {\n\treturn a + conj((p - a) / (b - a)) * (b - a);\n}\n// obrot a wzgledem p o theta radianow\nP rotate(P a, P p, D theta) {\n\treturn (a - p) * polar(1.0L, theta) + p;\n}\n// kat ABC, w radianach z przedzialu [0..pi]\nD angle(P a, P b, P c) {\n\treturn abs(remainder(arg(a - b) - arg(c - b), 2.0 * pi));\n}\n// szybkie przeciecie prostych, nie dziala dla rownoleglych\nP intersection(P a, P b, P p, P q) {\n\tD c1 = cross(p - a, b - a), c2 = cross(q - a, b - a);\n\treturn (c1 * q - c2 * p) / (c1 - c2);\n}\n// check czy sa rownolegle\nbool is_parallel(P a, P b, P p, P q) {\n\tP c = (a - b) / (p - q); return equal(c, conj(c));\n}\n// check czy sa prostopadle\nbool is_perpendicular(P a, P b, P p, P q) {\n\tP c = (a - b) / (p - q); return equal(c, -conj(c));\n}\n// zwraca takie q, ze (p, q) jest rownolegle do (a, b)\nP parallel(P a, P b, P p) {\n\treturn p + a - b;\n}\n// zwraca takie q, ze (p, q) jest prostopadle do (a, b)\nP perpendicular(P a, P b, P p) {\n\treturn reflect(p, a, b);\n}\n// przeciecie srodkowych trojkata\nP centro(P a, P b, P c) {\n\treturn (a + b + c) / 3.0L;\n}",
)

#code-entry(
  name: "angle-sort",
  hash: "032856",
  includes: ("point",),
  opis: [$cal(O)(n log  n)$, zwraca wektory P posortowane kątowo zgodnie z ruchem wskazówek zegara od najbliższego kątowo do wektora (0, 1) włącznie. Aby posortować po argumencie (kącie) swapujemy x, y, używamy angle-sort i ponownie swapujemy x, y. Zakłada że nie ma punktu (0, 0) na wejściu.],
  lang: "cpp",
  code: "V<P> angle_sort(V<P> t) {\n\tfor(P p : t) assert(not equal(p, P(0, 0)));\n\tauto it = partition(all(t), [](P a){ return P(0, 0) < a; });\n\tauto cmp = [&](P a, P b) {\n\t\treturn sign(cross(a, b)) == -1;\n\t};\n\tsort(t.begin(), it, cmp);\n\tsort(it, t.end(), cmp);\n\treturn t;\n}",
)

#code-entry(
  name: "angle180-intervals",
  hash: "9e4d50",
  includes: ("angle-sort",),
  opis: [$cal(O)(n)$, ZAKŁADA że punkty są posortowane kątowo. Zwraca $n$ par $[i, r]$, gdzie r jest maksymalnym cyklicznie indeksem, że wszystkie punkty w tym cyklicznym przedziale są ściśle ,,po prawej'' stronie wektora $(0,0)-in[i]$, albo są na tej półprostej.],
  lang: "cpp",
  code: "V<pii> angle180_intervals(V<P> in) {\n\t// in must be sorted by angle\n\tint n = ssize(in);\n\tvi nxt(n);\n\tiota(all(nxt), 1);\n\tint r = nxt[n - 1] = 0;\n\tV<pii> ret(n);\n\tREP(l, n) {\n\t\tif(nxt[r] == l) r = nxt[r];\n\t\tauto good = [&](int i) {\n\t\t\tauto c = cross(in[l], in[i]);\n\t\t\tif(not equal(c, 0)) return c < 0;\n\t\t\tif((P(0, 0) < in[l]) != (P(0, 0) < in[i]))\n\t\t\t\treturn false;\n\t\t\treturn l < i;\n\t\t};\n\t\twhile(nxt[r] != l and good(nxt[r]))\n\t\t\tr = nxt[r];\n\t\tret[l] = {l, r};\n\t}\n\treturn ret;\n}",
)

#code-entry(
  name: "area",
  hash: "7b2943",
  includes: ("point",),
  opis: [Pole wielokąta, niekoniecznie wypukłego. W vectorze muszą być wierzchołki zgodnie z kierunkiem ruchu zegara. Jeśli $D$ jest intem to może się psuć `/ 2`. `area(a, b, c)` zwraca pole trójkąta o takich długościach boku.],
  lang: "cpp",
  code: "D area(V<P> pts) {\n\tint n = ssize(pts);\n\tD ans = 0;\n\tREP(i, n) ans += cross(pts[i], pts[(i + 1) % n]);\n\treturn fabsl(ans / 2);\n}\nD area(D a, D b, D c) {\n\tD p = (a + b + c) / 2;\n\treturn sqrtl(p * (p - a) * (p - b) * (p - c));\n}",
)

#code-entry(
  name: "circle-intersection",
  hash: "eeabd8",
  includes: ("point",),
  opis: [Przecięcia okręgu oraz prostej $a x+b y+c=0$ oraz przecięcia okręgu oraz okręgu. Gdy `ssize(circle_circle(...)) == 3` to jest nieskończenie wiele rozwiązań.],
  lang: "cpp",
  code: "// BEGIN HASH 4774d4\nV<P> circle_line(D r, D a, D b, D c) {\n\tD len_ab = a * a + b * b,\n\t  x0 = -a * c / len_ab,\n\t  y0 = -b * c / len_ab,\n\t  d = r * r - c * c / len_ab,\n\t  mult = sqrt(d / len_ab);\n\tif(sign(d) < 0)\n\t\treturn {};\n\telse if(sign(d) == 0)\n\t\treturn {{x0, y0}};\n\treturn {\n\t\t{x0 + b * mult, y0 - a * mult},\n\t\t{x0 - b * mult, y0 + a * mult}\n\t};\n}\nV<P> circle_line(D x, D y, D r, D a, D b, D c) {\n\tV<P> ret = circle_line(r, a, b, c + (a * x + b * y));\n\tfor(P &p : ret) p = P(p.x() + x, p.y() + y);\n\treturn ret;\n} // END HASH\n// BEGIN HASH c5d0a6\nV<P> circle_circle(D x1, D y1, D r1, D x2, D y2, D r2) {\n\tx2 -= x1;\n\ty2 -= y1;\n\t// now x1 = y1 = 0;\n\tif(sign(x2) == 0 and sign(y2) == 0) {\n\t\tif(equal(r1, r2))\n\t\t\treturn {{0, 0}, {0, 0}, {0, 0}}; // inf points\n\t\telse\n\t\t\treturn {};\n\t}\n\tauto vec = circle_line(r1, -2 * x2, -2 * y2,\n\t\t\tx2 * x2 + y2 * y2 + r1 * r1 - r2 * r2);\n\tfor(P &p : vec)\n\t\tp += P(x1, y1);\n\treturn vec;\n} // END HASH",
)

#code-entry(
  name: "circle-tangents",
  hash: "f03bcb",
  includes: ("point",),
  opis: [$cal(O)(1)$, dla dwóch okręgów zwraca dwie styczne (wewnętrzne lub zewnętrzne, zależnie od wartości inner). Zwraca `1 + sign(dist(p0, p1) - (inside ? r0 + r1 : abs(r0 - r1)))` rozwiązań, albo $0$ gdy $"p1"="p2"$. Działa gdy jakiś promień jest 0 -- przydatne do policzenia stycznej punktu do okręgu.],
  lang: "cpp",
  code: "V<pair<P, P>> circle_tangents(P p1, D r1, P p2, D r2, bool inner) {\n\tif(inner) r2 *= -1;\n\tP d = p2 - p1;\n\tD dr = r1 - r2, d2 = dot(d, d), h2 = d2 - dr * dr;\n\tif(equal(d2, 0) or sign(h2) < 0)\n\t\treturn {};\n\tV<pair<P, P>> ret;\n\tfor(D sign : {-1, 1}) {\n\t\tP v = (d * dr + P(-d.y(), d.x()) * sqrt(max(D(0), h2)) * sign) / d2;\n\t\tret.eb(p1 + v * r1, p2 + v * r2);\n\t}\n\tret.resize(1 + (sign(h2) > 0));\n\treturn ret;\n}",
)

#code-entry(
  name: "closest-pair",
  hash: "16e742",
  includes: ("point",),
  opis: [$cal(O)(n log  n)$, zakłada ssize(in) > 1.],
  lang: "cpp",
  code: "pair<P, P> closest_pair(V<P> in) {\n\tset<P> s;\n\tsort(all(in), [](P a, P b) { return a.y() < b.y(); });\n\tpair<D, pair<P, P>> ret(1e18, {P(), P()});\n\tint j = 0;\n\tfor (P p : in) {\n\t\tP d(1 + sqrt(ret.fi), 0);\n\t\twhile (in[j].y() <= p.y() - d.x()) s.erase(in[j++]);\n\t\tauto lo = s.lower_bound(p - d), hi = s.upper_bound(p + d);\n\t\tfor (; lo != hi; ++lo)\n\t\t\tchmin(ret, pair(pow(dist(*lo, p), 2), pair(*lo, p)));\n\t\ts.insert(p);\n\t}\n\treturn ret.se;\n}",
)

#code-entry(
  name: "convex-gen",
  hash: "7f3cac",
  includes: ("point", "angle-sort", "headers/gen",),
  opis: [Generatorka wielokątów wypukłych. Zwraca wielokąt z co najmniej $n dot  `"PROC"`$ punktami w zakresie $[-`"range"`, `"range"`]$. Jeśli $n$ $(n > 2)$ jest około $`"range"`^{}(2)/(3)$, to powinno chodzić $cal(O)(n log  n)$. Dla większych $n$ może nie dać rady. Ostatni punkt jest zawsze w $(0, 0)$ - można dodać przesunięcie o wektor dla pełnej losowości.],
  lang: "cpp",
  code: "vi num_split(int value, int n) {\n\tvi v(n, value);\n\tREP(i, n - 1)\n\t\tv[i] = rd(0, value);\n\tsort(all(v));\n\tadjacent_difference(all(v), v.begin());\n\treturn v;\n}\nvi capped_zero_split(int cap, int n) {\n\tint m = rd(1, n - 1);\n\tauto lf = num_split(cap, m);\n\tauto rg = num_split(cap, n - m);\n\tfor (int i : rg)\n\t\tlf.eb(-i);\n\treturn lf;\n}\nV<P> gen_convex_polygon(int n, int range, bool strictly_convex = false) {\n\tassert(n > 2);\n\tV<P> t;\n\tC double PROC = 0.9;\n\tdo {\n\t\tt.clear();\n\t\tauto dx = capped_zero_split(range, n);\n\t\tauto dy = capped_zero_split(range, n);\n\t\tshuffle(all(dx), rng);\n\t\tREP (i, n)\n\t\t\tif (dx[i] || dy[i])\n\t\t\t\tt.eb(dx[i], dy[i]);\n\t\tt = angle_sort(t);\n\t\tif (strictly_convex) {\n\t\t\tV<P> nt(1, t[0]);\n\t\t\tFOR (i, 1, ssize(t) - 1) {\n\t\t\t\tif (!sign(cross(t[i], nt.back())))\n\t\t\t\t\tnt.back() += t[i];\n\t\t\t\telse\n\t\t\t\t\tnt.eb(t[i]);\n\t\t\t}\n\t\t\twhile (!nt.empty() && !sign(cross(nt.back(), nt[0]))) {\n\t\t\t\tnt[0] += nt.back();\n\t\t\t\tnt.pop_back();\n\t\t\t}\n\t\t\tt = nt;\n\t\t}\n\t} while (ssize(t) < n * PROC);\n\tpartial_sum(all(t), t.begin());\n\treturn t;\n}",
)

#code-entry(
  name: "convex-hull-online",
  hash: "c74f71",
  includes: (),
  opis: [$cal(O)(log  n)$ na każdą operację dodania, Wyznacza górną otoczkę wypukłą online.],
  lang: "cpp",
  code: "using P = pii;\nll operator*(P l, P r) {\n\treturn l.fi * ll(r.se) - l.se * ll(r.fi);\n}\nP operator-(P l, P r) {\n\treturn {l.fi - r.fi, l.se - r.se};\n}\nint sign(ll x) {\n\treturn x > 0 ? 1 : x < 0 ? -1 : 0;\n}\nint dir(P a, P b, P c) {\n\treturn sign((b - a) * (c - b));\n}\nstruct UpperConvexHull {\n\tset<P> hull;\n\tvoid add_point(P p) {\n\t\tif(hull.empty()) {\n\t\t\thull = {p};\n\t\t\treturn;\n\t\t}\n\t\tauto it = hull.lower_bound(p);\n\t\tif(*hull.begin() < p and p < *prev(hull.end())) {\n\t\t\tassert(it != hull.end() and it != hull.begin());\n\t\t\tif(dir(*prev(it), p, *it) >= 0)\n\t\t\t\treturn;\n\t\t}\n\t\tit = hull.emplace(p).fi;\n\t\tauto have_to_rm = [&](auto iter) {\n\t\t\tif(iter == hull.end() or next(iter) == hull.end() or iter == hull.begin())\n\t\t\t\treturn false;\n\t\t\treturn dir(*prev(iter), *iter, *next(iter)) >= 0;\n\t\t};\n\t\twhile(have_to_rm(next(it)))\n\t\t\tit = prev(hull.erase(next(it)));\n\t\twhile(it != hull.begin() and have_to_rm(prev(it)))\n\t\t\tit = hull.erase(prev(it));\n\t}\n};",
)

#code-entry(
  name: "convex-hull",
  hash: "31845a",
  includes: ("point",),
  opis: [$cal(O)(n log  n)$, `top_bot_hull` zwraca osobno górę i dół, `hull` zwraca punkty na otoczce clockwise gdzie pierwszy jest najbardziej lewym.],
  lang: "cpp",
  code: "array<V<P>, 2> top_bot_hull(V<P> in) {\n\tsort(all(in));\n\tarray<V<P>, 2> ret;\n\tREP(d, 2) {\n\t\tfor(auto p : in) {\n\t\t\twhile(ssize(ret[d]) > 1 and dir(ret[d].end()[-2], ret[d].back(), p) >= 0)\n\t\t\t\tret[d].pop_back();\n\t\t\tret[d].eb(p);\n\t\t}\n\t\treverse(all(in));\n\t}\n\treturn ret;\n}\nV<P> hull(V<P> in) {\n\tif(ssize(in) <= 1) return in;\n\tauto ret = top_bot_hull(in);\n\tREP(d, 2) ret[d].pop_back();\n\tret[0].insert(ret[0].end(), ret[1].begin(), ret[1].end());\n\treturn ret[0];\n}",
)

#code-entry(
  name: "delaunay-triangulation",
  hash: "26839a",
  includes: (),
  opis: [$cal(O)(n log  n)$, zwraca zbiór trójkątów sumujący się do otoczki wypukłej, gdzie każdy trójkąt nie zawiera żadnego innego punktu wewnątrz okręgu opisanego (czyli maksymalizuje minimalny kąt trójkątów). Zakłada brak identycznych punktów. W przypadku współliniowości wszystkich punktów zwraca pusty V. Zwraca V rozmiaru 3X, gdzie wartości 3i, 3i+1, 3i+2 tworzą counter-clockwise trójkąt. Wśród sąsiadów zawsze jest najbliższy wierzchołek. Euclidean min. spanning tree to podzbiór krawędzi.],
  lang: "cpp",
  code: "using PI = pii;\ntypedef struct Quad* Q;\nPI distinct(INT_MAX, INT_MAX);\nll dist2(PI p) {\n\treturn p.fi * ll(p.fi)\n\t\t+ p.se * ll(p.se);\n}\nll operator*(PI a, PI b) {\n\treturn a.fi * ll(b.se)\n\t\t- a.se * ll(b.fi);\n}\nPI operator-(PI a, PI b) {\n\treturn {a.fi - b.fi,\n\t\ta.se - b.se};\n}\nll cross(PI a, PI b, PI c) { return (a - b) * (b - c); }\nstruct Quad {\n\tQ rot, o = nullptr;\n\tPI p = distinct;\n\tbool mark = false;\n\tQuad(Q _rot) : rot(_rot) {}\n\tPI& F() { return r()->p; }\n\tQ& r() { return rot->rot; }\n\tQ prev() { return rot->o->rot; }\n\tQ next() { return r()->prev(); }\n} *H; // it's safe to use in multitests\nV<Q> to_dealloc;\nbool is_p_inside_circle(PI p, PI a, PI b, PI c) {\n\t__int128_t p2 = dist2(p), a2 = dist2(a)-p2,\n\t    b2 = dist2(b)-p2, c2 = dist2(c)-p2;\n\treturn cross(p,a,b) * c2 + cross(p,b,c) * a2 + cross(p,c,a) * b2 > 0;\n}\nQ makeEdge(PI orig, PI dest) {\n\tQ r = H;\n\tif (!r) {\n\t\tr = new Quad(new Quad(new Quad(new Quad(0))));\n\t\tQ del = r;\n\t\tREP(i, 4) {\n\t\t\tto_dealloc.eb(del);\n\t\t\tdel = del->rot;\n\t\t}\n\t}\n\tH = r->o; r->r()->r() = r;\n\tREP(i, 4) {\n\t\tr = r->rot, r->p = distinct;\n\t\tr->o = i & 1 ? r : r->r();\n\t}\n\tr->p = orig; r->F() = dest;\n\treturn r;\n}\nvoid splice(Q a, Q b) {\n\tswap(a->o->rot->o, b->o->rot->o);\n\tswap(a->o, b->o);\n}\nQ connect(Q a, Q b) {\n\tQ q = makeEdge(a->F(), b->p);\n\tsplice(q, a->next());\n\tsplice(q->r(), b);\n\treturn q;\n}\npair<Q, Q> rec(C V<PI>& s) {\n\tif (ssize(s) <= 3) {\n\t\tQ a = makeEdge(s[0], s[1]);\n\t\tQ b = makeEdge(s[1], s.back());\n\t\tif (ssize(s) == 2) return {a, a->r()};\n\t\tsplice(a->r(), b);\n\t\tauto side = cross(s[0], s[1], s[2]);\n\t\tQ c = side ? connect(b, a) : 0;\n\t\treturn {side < 0 ? c->r() : a,\n\t\t\tside < 0 ? c : b->r()};\n\t}\n\tauto valid = [&](Q e, Q base) {\n\t\treturn cross(e->F(), base->F(), base->p) > 0;\n\t};\n\tint half = ssize(s) / 2;\n\tauto [ra, A] = rec({s.begin(), s.end() - half});\n\tauto [B, rb] = rec({ssize(s) - half + s.begin(), s.end()});\n\twhile ((cross(B->p, A->F(), A->p) < 0\n\t\t\t\tand (A = A->next()))\n\t       or (cross(A->p, B->F(), B->p) > 0\n\t\t\t   and (B = B->r()->o))) {}\n\tQ base = connect(B->r(), A);\n\tif (A->p == ra->p) ra = base->r();\n\tif (B->p == rb->p) rb = base;\n\tauto del = [&](Q init, function<Q (Q)> dir) {\n\t\tQ e = dir(init);\n\t\tif (valid(e, base))\n\t\t\twhile (is_p_inside_circle(dir(e)->F(), base->F(), base->p, e->F())) {\n\t\t\t\tQ t = dir(e);\n\t\t\t\tsplice(e, e->prev());\n\t\t\t\tsplice(e->r(), e->r()->prev());\n\t\t\t\te->o = H; H = e; e = t;\n\t\t\t}\n\t\treturn e;\n\t};\n\twhile(true) {\n\t\tQ LC = del(base->r(), [&](Q q) { return q->o; });\n\t\tQ RC = del(base, [&](Q q) { return q->prev(); });\n\t\tif (!valid(LC, base) and !valid(RC, base)) break;\n\t\tif (!valid(LC, base) or (valid(RC, base)\n\t\t\t\t\tand is_p_inside_circle(RC->F(), RC->p, LC->F(), LC->p)))\n\t\t\tbase = connect(RC, base->r());\n\t\telse\n\t\t\tbase = connect(base->r(), LC->r());\n\t}\n\treturn {ra, rb};\n}\nV<PI> triangulate(V<PI> in) {\n\tsort(all(in));\n\tassert(unique(all(in)) == in.end());\n\tif (ssize(in) < 2) return {};\n\tQ e = rec(in).fi;\n\tV<Q> q = {e};\n\tint qi = 0;\n\twhile (cross(e->o->F(), e->F(), e->p) < 0)\n\t\te = e->o;\n\tauto add = [&] {\n\t\tQ c = e;\n\t\tdo {\n\t\t\tc->mark = 1;\n\t\t\tin.eb(c->p);\n\t\t\tq.eb(c->r());\n\t\t\tc = c->next();\n\t\t} while (c != e);\n\t};\n\tadd(); in.clear();\n\twhile (qi < ssize(q))\n\t\tif (!(e = q[qi++])->mark) add();\n\tfor (Q x : to_dealloc) delete x;\n\tto_dealloc.clear();\n\treturn in;\n}",
)

#code-entry(
  name: "furthest-pair",
  hash: "f8538c",
  includes: ("convex-hull",),
  opis: [$cal(O)(n)$ po puszczeniu otoczki, zakłada n >= 2.],
  lang: "cpp",
  code: "pair<P, P> furthest_pair(V<P> in) {\n\tin = hull(in);\n\tint n = ssize(in), j = 1;\n\tpair<D, pair<P, P>> ret;\n\tREP(i, j)\n\t\tfor(;; j = (j + 1) % n) {\n\t\t\tchmax(ret, pair(dist(in[i], in[j]), pair(in[i], in[j])));\n\t\t\tif (sign(cross(in[(j + 1) % n] - in[j], in[i + 1] - in[i])) <= 0)\n\t\t\t\tbreak;\n\t\t}\n\treturn ret.se;\n}",
)

#code-entry(
  name: "geo3d",
  hash: "4d58a5",
  includes: (),
  opis: [Geo3d od Warsaw Eagles.],
  lang: "cpp",
  code: "using LD = long double;\nC LD kEps = 1e-9;\nC LD kPi = acosl(-1);\nLD Sq(LD x) { return x * x; }\nstruct Point {\n\tLD x, y;\n\tPoint() {}\n\tPoint(LD a, LD b) : x(a), y(b) {}\n\tPoint(C Point& a) : Point(a.x, a.y) {}\n\tvoid operator=(C Point &a) { x = a.x; y = a.y; }\n\tPoint operator+(C Point &a) C { Point p(x + a.x, y + a.y); return p; }\n\tPoint operator-(C Point &a) C { Point p(x - a.x, y - a.y); return p; }\n\tPoint operator*(LD a) C { Point p(x * a, y * a); return p; }\n\tPoint operator/(LD a) C { assert(abs(a) > kEps); Point p(x / a, y / a); return p; }\n\tPoint &operator+=(C Point &a) { x += a.x; y += a.y; return *this; }\n\tPoint &operator-=(C Point &a) { x -= a.x; y -= a.y; return *this; }\n\tLD CrossProd(C Point &a) C { return x * a.y - y * a.x; }\n\tLD CrossProd(Point a, Point b) C { a -= *this; b -= *this; return a.CrossProd(b); }\n};\nstruct Line {\n\tPoint p[2];\n\tLine(Point a, Point b) { p[0] = a; p[1] = b; }\n\tPoint &operator[](int a) { return p[a]; }\n};\nstruct P3 {\n\tLD x, y, z;\n\tP3 operator+(P3 a) { P3 p{x + a.x, y + a.y, z + a.z}; return p; }\n\tP3 operator-(P3 a) { P3 p{x - a.x, y - a.y, z - a.z}; return p; }\n\tP3 operator*(LD a) { P3 p{x * a, y * a, z * a}; return p; }\n\tP3 operator/(LD a) { assert(a > kEps); P3 p{x / a, y / a, z / a}; return p; }\n\tP3 &operator+=(P3 a) { x += a.x; y += a.y; z += a.z; return *this; }\n\tP3 &operator-=(P3 a) { x -= a.x; y -= a.y; z -= a.z; return *this; }\n\tP3 &operator*=(LD a) { x *= a; y *= a; z *= a; return *this; }\n\tP3 &operator/=(LD a) { assert(a > kEps); x /= a; y /= a; z /= a; return *this; }\n\tLD &operator[](int a) {\n\t\tif (a == 0) return x;\n\t\tif (a == 1) return y;\n\t\treturn z;\n\t}\n\tbool IsZero() { return abs(x) < kEps && abs(y) < kEps && abs(z) < kEps; }\n\tLD DotProd(P3 a) { return x * a.x + y * a.y + z * a.z; }\n\tLD Norm() { return sqrt(x * x + y * y + z * z); }\n\tLD SqNorm() { return x * x + y * y + z * z; }\n\tvoid NormalizeSelf() { *this /= Norm(); }\n\tP3 Normalize() {\n\t\tP3 res(*this); res.NormalizeSelf();\n\t\treturn res;\n\t}\n\tLD Dis(P3 a) { return (*this - a).Norm(); }\n\tpair<LD, LD> SphericalAngles() {\n\t\treturn {atan2(z, sqrt(x * x + y * y)), atan2(y, x)};\n\t}\n\tLD Area(P3 p) { return Norm() * p.Norm() * sin(Angle(p)) / 2; }\n\tLD Angle(P3 p) {\n\t\tLD a = Norm();\n\t\tLD b = p.Norm();\n\t\tLD c = Dis(p);\n\t\treturn acos((a * a + b * b - c * c) / (2 * a * b));\n\t}\n\tLD Angle(P3 p, P3 q) { return p.Angle(q); }\n\tP3 CrossProd(P3 p) {\n\t\tP3 q(*this);\n\t\treturn {q[1] * p[2] - q[2] * p[1], q[2] * p[0] - q[0] * p[2],\n\t\t\t\t\t\tq[0] * p[1] - q[1] * p[0]};\n\t}\n\tbool LexCmp(P3 &a, C P3 &b) {\n\t\tif (abs(a.x - b.x) > kEps) return a.x < b.x;\n\t\tif (abs(a.y - b.y) > kEps) return a.y < b.y;\n\t\treturn a.z < b.z;\n\t}\n};\nstruct Line3 {\n\tP3 p[2];\n\tP3 &operator[](int a) { return p[a]; }\n\tfriend ostream &operator<<(ostream &out, Line3 m);\n};\nstruct Plane {\n\tP3 p[3];\n\tP3 &operator[](int a) { return p[a]; }\n\tP3 GetNormal() {\n\t\tP3 cross = (p[1] - p[0]).CrossProd(p[2] - p[0]);\n\t\treturn cross.Normalize();\n\t}\n\tvoid GetPlaneEq(LD &a, LD &b, LD &c, LD &d) {\n\t\tP3 normal = GetNormal();\n\t\ta = normal[0];\n\t\tb = normal[1];\n\t\tc = normal[2];\n\t\td = normal.DotProd(p[0]);\n\t\tassert(abs(d - normal.DotProd(p[1])) < kEps);\n\t\tassert(abs(d - normal.DotProd(p[2])) < kEps);\n\t}\n\tV<P3> GetOrthonormalBase() {\n\t\tP3 normal = GetNormal();\n\t\tP3 cand = {-normal.y, normal.x, 0};\n\t\tif (abs(cand.x) < kEps && abs(cand.y) < kEps) {\n\t\t\tcand = {0, -normal.z, normal.y};\n\t\t}\n\t\tcand.NormalizeSelf();\n\t\tP3 third = Plane{P3{0, 0, 0}, normal, cand}.GetNormal();\n\t\tassert(abs(normal.DotProd(cand)) < kEps &&\n\t\t\t\t\t abs(normal.DotProd(third)) < kEps &&\n\t\t\t\t\t abs(cand.DotProd(third)) < kEps);\n\t\treturn {normal, cand, third};\n\t}\n};\nstruct Circle3 {\n\tPlane pl; P3 o; LD r;\n};\nstruct Sphere {\n\tP3 o;\n\tLD r;\n};\n// angle PQR\nLD Angle(P3 P, P3 Q, P3 R) { return (P - Q).Angle(R - Q); }\nP3 ProjPtToLine3(P3 p, Line3 l) { // ok\n\tP3 diff = l[1] - l[0];\n\tdiff.NormalizeSelf();\n\treturn l[0] + diff * (p - l[0]).DotProd(diff);\n}\nLD DisPtLine3(P3 p, Line3 l) { // ok\n\t//\tLD area = Area(p, l[0], l[1]); LD dis1 = 2 * area / l[0].Dis(l[1]);\n\tLD dis2 = p.Dis(ProjPtToLine3(p, l)); // assert(abs(dis1 - dis2) < kEps);\n\treturn dis2;\n}\nLD DisPtPlane(P3 p, Plane pl) {\n\tP3 normal = pl.GetNormal();\n\treturn abs(normal.DotProd(p - pl[0]));\n}\nP3 ProjPtToPlane(P3 p, Plane pl) {\n\tP3 normal = pl.GetNormal();\n\treturn p - normal * normal.DotProd(p - pl[0]);\n}\nbool PtBelongToLine3(P3 p, Line3 l) { return DisPtLine3(p, l) < kEps; }\nbool Lines3Equal(Line3 p, Line3 l) {\n\treturn PtBelongToLine3(p[0], l) && PtBelongToLine3(p[1], l);\n}\nbool PtBelongToPlane(P3 p, Plane pl) { return DisPtPlane(p, pl) < kEps; }\nPoint PlanePtTo2D(Plane pl, P3 p) { // ok\n\tassert(PtBelongToPlane(p, pl));\n\tV<P3> base = pl.GetOrthonormalBase();\n\tP3 control{0, 0, 0};\n\tREP(tr, 3) { control += base[tr] * p.DotProd(base[tr]); }\n\tassert(PtBelongToPlane(pl[0] + base[1], pl));\n\tassert(PtBelongToPlane(pl[0] + base[2], pl));\n\tassert((p - control).IsZero());\n\treturn {p.DotProd(base[1]), p.DotProd(base[2])};\n}\nLine PlaneLineTo2D(Plane pl, Line3 l) {\n\treturn {PlanePtTo2D(pl, l[0]), PlanePtTo2D(pl, l[1])};\n}\nP3 PlanePtTo3D(Plane pl, Point p) { // ok\n\tV<P3> base = pl.GetOrthonormalBase();\n\treturn base[0] * base[0].DotProd(pl[0]) + base[1] * p.x + base[2] * p.y;\n}\nLine3 PlaneLineTo3D(Plane pl, Line l) {\n\treturn {PlanePtTo3D(pl, l[0]), PlanePtTo3D(pl, l[1])};\n}\nLine3 ProjLineToPlane(Line3 l, Plane pl) { // ok\n\treturn {ProjPtToPlane(l[0], pl), ProjPtToPlane(l[1], pl)};\n}\nbool Line3BelongToPlane(Line3 l, Plane pl) {\n\treturn PtBelongToPlane(l[0], pl) && PtBelongToPlane(l[1], pl);\n}\nLD Det(P3 a, P3 b, P3 d) { // ok\n\tP3 pts[3] = {a, b, d};\n\tLD res = 0;\n\tfor (int sign : {-1, 1}) {\n\t\tREP(st_col, 3) {\n\t\t\tint c = st_col;\n\t\t\tLD prod = 1;\n\t\t\tREP(r, 3) {\n\t\t\t\tprod *= pts[r][c];\n\t\t\t\tc = (c + sign + 3) % 3;\n\t\t\t}\n\t\t\tres += sign * prod;\n\t\t}\n\t}\n\treturn res;\n}\nLD Area(P3 p, P3 q, P3 r) {\n\tq -= p; r -= p;\n\treturn q.Area(r);\n}\nV<Point> InterLineLine(Line &a, Line &b) { // working fine\n\tPoint vec_a = a[1] - a[0];\n\tPoint vec_b1 = b[1] - a[0];\n\tPoint vec_b0 = b[0] - a[0];\n\tLD tr_area = vec_b1.CrossProd(vec_b0);\n\tLD quad_area = vec_b1.CrossProd(vec_a) + vec_a.CrossProd(vec_b0);\n\tif (abs(quad_area) < kEps) { // parallel or coinciding\n\t\tif (abs(b[0].CrossProd(b[1], a[0])) < kEps) {\n\t\t\treturn {a[0], a[1]};\n\t\t} else return {};\n\t}\n\treturn {a[0] + vec_a * (tr_area / quad_area)};\n}\nV<P3> InterLineLine(Line3 k, Line3 l) {\n\tif (Lines3Equal(k, l)) return {k[0], k[1]};\n\tif (PtBelongToLine3(l[0], k)) return {l[0]};\n\tPlane pl{l[0], k[0], k[1]};\n\tif (!PtBelongToPlane(l[1], pl)) return {};\n\tLine k2 = PlaneLineTo2D(pl, k);\n\tLine l2 = PlaneLineTo2D(pl, l);\n\tV<Point> inter = InterLineLine(k2, l2);\n\tV<P3> res;\n\tfor (auto P : inter) res.pb(PlanePtTo3D(pl, P));\n\treturn res;\n}\nLD DisLineLine(Line3 l, Line3 k) { // ok\n\tPlane together{l[0], l[1], l[0] + k[1] - k[0]}; // parallel FIXME\n\tLine3 proj = ProjLineToPlane(k, together);\n\tP3 inter = (InterLineLine(l, proj))[0];\n\tP3 on_k_inter = k[0] + inter - proj[0];\n\treturn inter.Dis(on_k_inter);\n}\nPlane ParallelPlane(Plane pl, P3 A) { // plane parallel to pl going through A\n\tP3 diff = A - ProjPtToPlane(A, pl);\n\treturn {pl[0] + diff, pl[1] + diff, pl[2] + diff};\n}\n// image of B in rotation wrt line passing through origin s.t. A1->A2\n// implemented in more general case with similarity instead of rotation\nP3 RotateAccordingly(P3 A1, P3 A2, P3 B1) { // ok\n\tPlane pl{A1, A2, {0, 0, 0}};\n\tPoint A12 = PlanePtTo2D(pl, A1);\n\tPoint A22 = PlanePtTo2D(pl, A2);\n\tcomplex<LD> rat = complex<LD>(A22.x, A22.y) / complex<LD>(A12.x, A12.y);\n\tPlane plb = ParallelPlane(pl, B1);\n\tPoint B2 = PlanePtTo2D(plb, B1);\n\tcomplex<LD> Brot = rat * complex<LD>(B2.x, B2.y);\n\treturn PlanePtTo3D(plb, {Brot.real(), Brot.imag()});\n}\nV<Circle3> InterSpherePlane(Sphere s, Plane pl) { // ok\n\tP3 proj = ProjPtToPlane(s.o, pl);\n\tLD dis = s.o.Dis(proj);\n\tif (dis > s.r + kEps) return {};\n\tif (dis > s.r - kEps) return {{pl, proj, 0}}; // is it best choice?\n\treturn {{pl, proj, sqrt(s.r * s.r - dis * dis)}};\n}\nbool PtBelongToSphere(Sphere s, P3 p) { return abs(s.r - s.o.Dis(p)) < kEps; }\nstruct PointS { // just for conversion purposes, probably toEucl suffices\n\tLD lat, lon;\n\tP3 toEucl() { return P3{cos(lat) * cos(lon), cos(lat) * sin(lon), sin(lat)}; }\n\tPointS(P3 p) {\n\t\tp.NormalizeSelf();\n\t\tlat = asin(p.z);\n\t\tlon = acos(p.y / cos(lat));\n\t}\n};\nLD DistS(P3 a, P3 b) { return atan2l(b.CrossProd(a).Norm(), a.DotProd(b)); }\nstruct CircleS {\n\tP3 o; // center of circle on sphere\n\tLD r; // arc len\n\tLD area() C { return 2 * kPi * (1 - cos(r)); }\n};\nCircleS From3(P3 a, P3 b, P3 c) { // any three different points\n\tint tmp = 1;\n\tif ((a - b).Norm() > (c - b).Norm()) {\n\t\tswap(a, c); tmp = -tmp;\n\t}\n\tif ((b - c).Norm() > (a - c).Norm()) {\n\t\tswap(a, b); tmp = -tmp;\n\t}\n\tP3 v = (c - b).CrossProd(b - a);\n\tv = v * (tmp / v.Norm());\n\treturn CircleS{v, DistS(a, v)};\n}\nCircleS From2(P3 a, P3 b) { // neither the same nor the opposite\n\tP3 mid = (a + b) / 2;\n\tmid = mid / mid.Norm();\n\treturn From3(a, mid, b);\n}\nLD SphAngle(P3 a, P3 b, P3 c) { // angle at A, no two points opposite\n\tLD a2 = b.DotProd(c);\n\tLD b2 = c.DotProd(a);\n\tLD c2 = a.DotProd(b);\n\treturn acos((b2 - a2 * c2) / sqrt((1 - Sq(a2)) * (1 - Sq(c2))));\n}\nLD TriangleArea(P3 a, P3 b, P3 c) { // no two poins opposite\n\tLD a2 = SphAngle(c, a, b);\n\tLD b2 = SphAngle(a, b, c);\n\tLD c2 = SphAngle(b, c, a);\n\treturn a2 + b2 + c2 - kPi;\n}",
)

#code-entry(
  name: "halfplane-intersection",
  hash: "5e7cbf",
  includes: ("point",),
  opis: [$cal(O)(n log  n)$ wyznaczanie punktów na brzegu/otoczce przecięcia podanych półpłaszczyzn. `Halfplane(a, b)` tworzy półpłaszczyznę wzdłuż prostej $a-> b$ z obszarem po lewej stronie wektora $a-> b$. Jeżeli zostało zwróconych mniej, niż trzy punkty, to pole przecięcia jest puste. Na przykład `halfplane_intersection({Halfplane(P(2, 1), P(4, 2)), Halfplane(P(6, 3), P(2, 4)), Halfplane(P(-4, 7), P(4, 2))\`) == {(4, 2), (6, 3), (0, 4.5)}}. Pole przecięcia jest zawsze ograniczone, ponieważ w kodzie są dodawane cztery półpłaszczyzny o współrzędnych w `+/-inf`, ale nie należy na tym polegać przez eps oraz błędy precyzji (najlepiej jest zmniejszyć inf tyle, ile się da).],
  lang: "cpp",
  code: "struct Halfplane {\n\tP p, pq;\n\tD angle;\n\tHalfplane() {}\n\tHalfplane(P a, P b) : p(a), pq(b - a) {\n\t\tangle = atan2l(pq.imag(), pq.real());\n\t}\n};\nostream& operator<<(ostream&o, Halfplane h) {\n\treturn o << '(' << h.p << \", \" << h.pq << \", \" << h.angle << ')';\n}\nbool is_outside(Halfplane hi, P p) {\n\treturn sign(cross(hi.pq, p - hi.p)) == -1;\n}\nP inter(Halfplane s, Halfplane t) {\n\tD alpha = cross(t.p - s.p, t.pq) / cross(s.pq, t.pq);\n\treturn s.p + s.pq * alpha;\n}\nV<P> halfplane_intersection(V<Halfplane> h) {\n\tfor(int i = 0; i < 4; ++i) {\n\t\tconstexpr D inf = 1e9;\n\t\tarray box = {P(-inf, -inf), P(inf, -inf), P(inf, inf), P(-inf, inf)};\n\t\th.eb(box[i], box[(i + 1) % 4]);\n\t}\n\tsort(all(h), [&](Halfplane l, Halfplane r) {\n\t\treturn l.angle < r.angle;\n\t});\n\tdeque<Halfplane> dq;\n\tfor(auto &hi : h) {\n\t\twhile(ssize(dq) >= 2 and is_outside(hi, inter(dq.end()[-1], dq.end()[-2])))\n\t\t\tdq.pop_back();\n\t\twhile(ssize(dq) >= 2 and is_outside(hi, inter(dq[0], dq[1])))\n\t\t\tdq.pop_front();\n\t\tif(ssize(dq) and sign(cross(hi.pq, dq.back().pq)) == 0) {\n\t\t\tif(sign(dot(hi.pq, dq.back().pq)) < 0)\n\t\t\t\treturn {};\n\t\t\tif(is_outside(hi, dq.back().p))\n\t\t\t\tdq.pop_back();\n\t\t\telse\n\t\t\t\tcontinue;\n\t\t}\n\t\tdq.eb(hi);\n\t}\n\twhile(ssize(dq) >= 3 and is_outside(dq[0], inter(dq.end()[-1], dq.end()[-2])))\n\t\tdq.pop_back();\n\twhile(ssize(dq) >= 3 and is_outside(dq.end()[-1], inter(dq[0], dq[1])))\n\t\tdq.pop_front();\n\tV<P> ret;\n\tREP(i, ssize(dq))\n\t\tret.eb(inter(dq[i], dq[(i + 1) % ssize(dq)]));\n\tret.erase(unique(all(ret), [&](P l, P r) { return equal(l, r); }), ret.end());\n\tif(ssize(ret) >= 2 and equal(ret.front(), ret.back()))\n\t\tret.pop_back();\n\tfor(Halfplane hi : h)\n\t\tif(ssize(ret) <= 2 and is_outside(hi, ret[0]))\n\t\t\treturn {};\n\treturn ret;\n}",
)

#code-entry(
  name: "intersect-lines",
  hash: "6a7387",
  includes: ("point",),
  opis: [$cal(O)(1)$ ale intersect_segments ma sporą stałą (ale działa na wszystkich edge-case'ach). Jeżeli intersect_segments zwróci dwa punkty to wszystkie $oo $ rozwiązań są pomiędzy.],
  lang: "cpp",
  code: "// BEGIN HASH 95db50\nP intersect_lines(P a, P b, P c, P d) {\n\tD c1 = cross(c - a, b - a), c2 = cross(d - a, b - a);\n\t// c1 == c2 => równoległe\n\treturn (c1 * d  - c2 * c) / (c1 - c2);\n} // END HASH\n// BEGIN HASH 65e219\nbool on_segment(P a, P b, P p) {\n\treturn equal(cross(a - p, b - p), 0) and sign(dot(a - p, b - p)) <= 0;\n} // END HASH\n// BEGIN HASH 2b171b\nbool is_intersection_segment(P a, P b, P c, P d) {\n\tauto aux = [&](D q, D w, D e, D r) {\n\t\treturn sign(max(q, w) - min(e, r)) >= 0;\n\t};\n\treturn  aux(c.x(), d.x(), a.x(), b.x()) and aux(a.x(), b.x(), c.x(), d.x())\n\t\tand aux(c.y(), d.y(), a.y(), b.y()) and aux(a.y(), b.y(), c.y(), d.y())\n\t\tand dir(a, d, c) * dir(b, d, c) != 1\n\t\tand dir(d, b, a) * dir(c, b, a) != 1;\n} // END HASH\n// BEGIN HASH c969b4\nV<P> intersect_segments(P a, P b, P c, P d) {\n\tD acd = cross(c - a, d - c), bcd = cross(c - b, d - c),\n\t\t   cab = cross(a - c, b - a), dab = cross(a - d, b - a);\n\tif(sign(acd) * sign(bcd) < 0 and sign(cab) * sign(dab) < 0)\n\t\treturn {(a * bcd - b * acd) / (bcd - acd)};\n\tset<P> s;\n\tif(on_segment(c, d, a)) s.emplace(a);\n\tif(on_segment(c, d, b)) s.emplace(b);\n\tif(on_segment(a, b, c)) s.emplace(c);\n\tif(on_segment(a, b, d)) s.emplace(d);\n\treturn {s.begin(), s.end()};\n} // END HASH",
)

#code-entry(
  name: "is-in-hull",
  hash: "5eea9f",
  includes: ("intersect-lines",),
  opis: [$cal(O)(log  n)$, zwraca czy punkt jest wewnątrz otoczki h. Zakłada że punkty są clockwise oraz nie ma trzech współliniowych (działa na convex-hull).],
  lang: "cpp",
  code: "bool is_in_hull(V<P> h, P p, bool can_on_edge) {\n\tif(ssize(h) < 3) return can_on_edge and on_segment(h[0], h.back(), p);\n\tint l = 1, r = ssize(h) - 1;\n\tif(dir(h[0], h[l], p) >= can_on_edge or dir(h[0], h[r], p) <= -can_on_edge)\n\t\treturn false;\n\twhile(r - l > 1) {\n\t\tint m = (l + r) / 2;\n\t\t(dir(h[0], h[m], p) < 0 ? l : r) = m;\n\t}\n\treturn dir(h[l], h[r], p) < can_on_edge;\n}",
)

#code-entry(
  name: "line",
  hash: "033da1",
  includes: ("point",),
  opis: [Konwersja różnych postaci prostej.],
  lang: "cpp",
  code: "struct Line {\n\tD a, b, c;\n\t// postac ogolna ax + by + c = 0\n\tLine(D _a, D _b, D _c) : a(_a), b(_b), c(_c) {}\n\ttuple<D, D, D> get_tuple() { return {a, b, c}; }\n\t// postac kierunkowa ax + b = y\n\tLine(D _a, D _b) : a(_a), b(-1), c(_b) {}\n\tpair<D, D> get_dir() { return {- a / b, - c / b}; }\n\t// prosta pq\n\tLine(P p, P q) {\n\t\tassert(not equal(p, q));\n\t\tif(not equal(p.x(), q.x())) {\n\t\t\ta = (q.y() - p.y()) / (p.x() - q.x());\n\t\t\tb = 1, c = -(a * p.x() + b * p.y());\n\t\t}\n\t\telse a = 1, b = 0, c = -p.x();\n\t}\n\tpair<P, P> get_pts() {\n\t\tif(!equal(b, 0)) return { P(0, - c / b), P(1, - (a + c) / b) };\n\t\treturn { P(- c / a, 0), P(- c / a, 1) };\n\t}\n\tD directed_dist(P p) {\n\t\treturn (a * p.x() + b * p.y() + c) / sqrt(a * a + b * b);\n\t}\n\tD dist(P p) {\n\t\treturn abs(directed_dist(p));\n\t}\n};",
)

#code-entry(
  name: "point",
  hash: "a14c07",
  includes: (),
  opis: [Wrapper na `std::complex`, definy trzeba dać nad bitsami, wtedy istnieje `p.x()` oraz `p.y()`. `abs` długość, `arg` kąt $(-pi , pi ]$ gdzie $(0,1)$ daje $(pi )/(2)$, `polar(len, angle)` tworzy $P$. Istnieją `atan2`, `asin`, `sinh`.],
  lang: "cpp",
  code: "// Before include bits:\n// #define real x\n// #define imag y\nusing D = long double;\nusing P = complex<D>;\nconstexpr D eps = 1e-9;\nbool equal(D a, D b) { return abs(a - b) < eps; }\nbool equal(P a, P b) { return equal(a.x(), b.x()) and equal(a.y(), b.y()); }\nint sign(D a) { return equal(a, 0) ? 0 : a > 0 ? 1 : -1; }\nnamespace std { bool operator<(P a, P b) { return sign(a.x() - b.x()) == 0 ? sign(a.y() - b.y()) < 0 : a.x() < b.x(); } }\n// cross({1, 0}, {0, 1}) = 1\nD cross(P a, P b) { return a.x() * b.y() - a.y() * b.x(); }\nD dot(P a, P b) { return a.x() * b.x() + a.y() * b.y(); }\nD dist(P a, P b) { return abs(a - b); }\nint dir(P a, P b, P c) { return sign(cross(b - a, c - b)); }",
)

#code-entry(
  name: "polygon-gen",
  hash: "4470a8",
  includes: ("point", "intersect-lines", "headers/gen",),
  opis: [Generatorka wielokątów niekoniecznie-wypukłych. Zwraca wielokąt o $n$ punktach w zakresie $[-`r`, `r`]$, który nie zawiera jakiejkolwiek trójki współliniowych punktów. Ciągnie do $tilde 80$. Dla $n < 3$ zwraca zdegenerowane.],
  lang: "cpp",
  code: "V<P> gen_polygon(int n, int r) {\n\tV<P> t;\n\twhile (ssize(t) < n) {\n\t\tP p(rd(-r, r), rd(-r, r));\n\t\tif ([&]() {\n\t\t\tREP (i, ssize(t))\n\t\t\t\tREP (j, i)\n\t\t\t\t\tif (dir(t[i], t[j], p) == 0)\n\t\t\t\t\t\treturn false;\n\t\t\treturn find(all(t), p) == t.end();\n\t\t}())\n\t\t\tt.eb(p);\n\t}\n\tbool go = true;\n\twhile (go) {\n\t\tgo = false;\n\t\tREP (i, n)\n\t\t\tREP (j, i - 1)\n\t\t\t\tif ((i + 1) % n != j && ssize(intersect_segments(t[i], t[(i + 1) % n], t[j], t[j + 1]))) {\n\t\t\t\t\tswap(t[(i + rd(0, 1)) % n], t[(j + rd(0, 1)) % n]);\n\t\t\t\t\tgo = true;\n\t\t\t\t}\n\t}\n\treturn t;\n}",
)

#code-entry(
  name: "polygon-print",
  hash: "de8102",
  includes: ("point",),
  opis: [Należy przekierować stdout do pliku i otworzyć go np. w przeglądarce. `m` zwiększa obrazek, `d` zmniejsza rozmiar napisów/wierzchołków.],
  lang: "cpp",
  code: "void polygon_print(V<P> v, int r = 10) {\n    int m = 350 / r, d = 50;\n    auto ori = v;\n    for (auto &p : v)\n        p = P((p.x() + r * 1.1) * m, (p.y() + r * 1.1) * m);\n    r = int(r * m * 2.5);\n    printf(\"<svg height='%d' width='%d'><rect width='100%%' height='100%%' fill='white' />\", r, r);\n    int n = ssize(v);\n    REP (i, n) {\n        printf(\"<line x1='%Lf' y1='%Lf' x2='%Lf' y2='%Lf' style='stroke:black' />\", v[i].x(), v[i].y(), v[(i + 1) % n].x(), v[(i + 1) % n].y());\n        printf(\"<circle cx='%Lf' cy='%Lf' r='%f' fill='red' />\", v[i].x(), v[i].y(), r / d / 10.0);\n        printf(\"<text x='%Lf' y='%Lf' font-size='%d' fill='violet'>%d (%.1Lf, %.1Lf)</text>\", v[i].x() + 5, v[i].y() - 5, r / d, i + 1, ori[i].x(), ori[i].y());\n    }\n    printf(\"</svg>\\n\");\n}",
)

#code-entry(
  name: "voronoi-diagram",
  hash: "1f8a8f",
  includes: ("delaunay-triangulatio", "convex-hull",),
  opis: [$cal(O)(n log  n)$, dla każdego punktu zwraca odpowiadającą mu ścianę będącą otoczką wypukłą. Suma otoczek w całości zawiera kwadrat (-mx, mx) -- (mx, mx), ale może zawierać więcej. Współrzędne ścian mogą być kilka rządów wielkości większe niż te na wejściu. Max abs wartości współrzędnych to 3e8.],
  lang: "cpp",
  code: "using Frac = pair<__int128_t, __int128_t>;\nD to_d(Frac f) { return D(f.fi) / D(f.se); }\nFrac create_frac(__int128_t a, __int128_t b) {\n\tassert(b != 0);\n\tif(b < 0) a *= -1, b *= -1;\n\t__int128_t d = __gcd(a, b);\n\treturn {a / d, b / d};\n}\nusing P128 = pair<Frac, Frac>;\nll sq(int x) { return x * ll(x); }\n__int128_t dist128(PI p) { return sq(p.fi) + sq(p.se); }\npair<Frac, Frac> calc_mid(PI a, PI b, PI c) {\n\t__int128_t ux = dist128(a) * (b.se - c.se)\n\t\t+ dist128(b) * (c.se - a.se)\n\t\t+ dist128(c) * (a.se - b.se),\n\t\tuy = dist128(a) * (c.fi - b.fi)\n\t\t+ dist128(b) * (a.fi - c.fi)\n\t\t+ dist128(c) * (b.fi - a.fi),\n\t\td = 2 * (a.fi * ll(b.se - c.se)\n\t\t+ b.fi * ll(c.se - a.se)\n\t\t+ c.fi * ll(a.se - b.se));\n\treturn {create_frac(ux, d), create_frac(uy, d)};\n}\nV<V<P>> voronoi_faces(V<PI> in, C int max_xy = int(3e8)) {\n\tint n = ssize(in);\n\tmap<PI, int> id_of_in;\n\tREP(i, n)\n\t\tid_of_in[in[i]] = i;\n\tfor(int sx : {-1, 1})\n\t\tfor(int sy : {-1, 1}) {\n\t\t\tint mx = 3 * max_xy + 100;\n\t\t\tin.eb(mx * sx, mx * sy);\n\t\t}\n\tV<PI> triangles = triangulate(in);\n\tdebug(triangles);\n\tassert(not triangles.empty());\n\tint tn = ssize(triangles) / 3;\n\tV<P128> mids(tn);\n\tmap<pair<PI, PI>, V<P128>> on_sides;\n\tREP(i, tn) {\n\t\tarray<PI, 3> ps = {triangles[3 * i], triangles[3 * i + 1], triangles[3 * i + 2]};\n\t\tmids[i] = calc_mid(ps[0], ps[1], ps[2]);\n\t\tREP(j, 3) {\n\t\t\tPI a = ps[j], b = ps[(j + 1) % 3];\n\t\t\ton_sides[pair(min(a, b), max(a, b))].eb(mids[i]);\n\t\t}\n\t}\n\tV<V<P128>> faces128(n);\n\tfor(auto [edge, sides] : on_sides)\n\t\tif(ssize(sides) == 2)\n\t\t\tfor(PI e : {edge.fi, edge.se})\n\t\t\t\tif(id_of_in.find(e) != id_of_in.end())\n\t\t\t\t\tfor(auto m : sides)\n\t\t\t\t\t\tfaces128[id_of_in[e]].eb(m);\n\tV<V<P>> faces(n);\n\tREP(i, ssize(faces128)) {\n\t\tauto &f = faces128[i];\n\t\tsort(all(f));\n\t\tf.erase(unique(all(f)), f.end());\n\t\tfor(auto [x, y] : f)\n\t\t\tfaces[i].eb(to_d(x), to_d(y));\n\t\tfaces[i] = hull(faces[i]);\n\t}\n\treturn faces;\n}",
)

#my-chapter("Tekstówki")

#code-entry(
  name: "aho-corasick",
  hash: "be512e",
  includes: (),
  opis: [$cal(O)(|s|alpha )$, Konstruktor tworzy sam korzeń w `node[0]`, `add(s)` dodaje słowo, `convert()` zamienia nieodwracalnie trie w automat Aho-Corasick, `link(x)` zwraca suffix link, `go(x, c)` zwraca następnik x przez literę c, najpierw dodajemy słowa, potem robimy convert(), a na koniec używamy $"go"$ i $"link"$.],
  lang: "cpp",
  code: "constexpr int alpha = 26;\nstruct AhoCorasick {\n\tstruct Node {\n\t\tarray<int, alpha> next, go;\n\t\tint p, pch, link = -1;\n\t\tbool is_word_end = false;\n\t\tNode(int _p = -1, int ch = -1) : p(_p), pch(ch) {\n\t\t\tfill(all(next), -1);\n\t\t\tfill(all(go), -1);\n\t\t}\n\t};\n\tV<Node> node;\n\tbool converted = false;\n\tAhoCorasick() : node(1) {}\n\tvoid add(C vi &s) {\n\t\tassert(!converted);\n\t\tint v = 0;\n\t\tfor (int c : s) {\n\t\t\tif (node[v].next[c] == -1) {\n\t\t\t\tnode[v].next[c] = ssize(node);\n\t\t\t\tnode.eb(v, c);\n\t\t\t}\n\t\t\tv = node[v].next[c];\n\t\t}\n\t\tnode[v].is_word_end = true;\n\t}\n\tint link(int v) {\n\t\tassert(converted);\n\t\treturn node[v].link;\n\t}\n\tint go(int v, int c) {\n\t\tassert(converted);\n\t\treturn node[v].go[c];\n\t}\n\tvoid convert() {\n\t\tassert(!converted);\n\t\tconverted = true;\n\t\tdeque<int> que = {0};\n\t\twhile (not que.empty()) {\n\t\t\tint v = que.front();\n\t\t\tque.pop_front();\n\t\t\tif (v == 0 or node[v].p == 0)\n\t\t\t\tnode[v].link = 0;\n\t\t\telse\n\t\t\t\tnode[v].link = go(link(node[v].p), node[v].pch);\n\t\t\tREP (c, alpha) {\n\t\t\t\tif (node[v].next[c] != -1) {\n\t\t\t\t\tnode[v].go[c] = node[v].next[c];\n\t\t\t\t\tque.eb(node[v].next[c]);\n\t\t\t\t}\n\t\t\t\telse\n\t\t\t\t\tnode[v].go[c] = v == 0 ? 0 : go(link(v), c);\n\t\t\t}\n\t\t}\n\t}\n};",
)

#code-entry(
  name: "eertree",
  hash: "a21027",
  includes: (),
  opis: [$cal(O)("nalpha" )$ konstrukcja, $cal(O)(n)$ DP oraz odzyskanie. Eertree ma korzeń ,,pusty'' w $0$ oraz ,,ujemny'' w $1$. Z wierzchołka wychodzi krawędź z literą, gdy jego słowo można otoczyć z obu stron tą literą. Funkcja `add_letter` zwraca wierzchołek odpowiadający za największy palindromiczny suffix aktualnego słowa. Suffix link prowadzi do najdłuższego palindromicznego suffixu słowa wierzchołka. Linki tworzą drzewo z $1$ jako korzeń (który ma syna $0$). Żeby policzyć liczbę wystąpień wierzchołka, po każdym dodaniu litery ,,wystarczy'' dodać $+1$ każdemu na ścieżce od `last` do korzenia po linkach. `palindromic_split_dp` zwraca na każdym prefixie (min podział palindromiczny, indeks do odzyskania min podziału, liczbę podziałów). Gdy `only_even_lens` to może nie istnieć odpowiedź, wtedy `.mn == n + 1, .cnt == 0`. `construct_min_palindromic_split` zwraca palindromiczne przedziały pokrywające słowo.],
  lang: "cpp",
  code: "// BEGIN HASH b1ff16\nconstexpr int alpha = 26;\nstruct Eertree {\n\tV<array<int, alpha>> edge;\n\tarray<int, alpha> empty;\n\tvi str = {-1}, link = {1, 0}, len = {0, -1};\n\tint last = 0;\n\tEertree() {\n\t\tempty.fill(0);\n\t\tedge.resize(2, empty);\n\t}\n\tint find(int v) {\n\t\twhile(str.end()[-1] != str.end()[-len[v] - 2])\n\t\t\tv = link[v];\n\t\treturn v;\n\t}\n\tint add_letter(int c) {\n\t\tstr.eb(c);\n\t\tlast = find(last);\n\t\tif(edge[last][c] == 0) {\n\t\t\tedge.eb(empty);\n\t\t\tlen.eb(len[last] + 2);\n\t\t\tlink.eb(edge[find(link[last])][c]);\n\t\t\tedge[last][c] = ssize(edge) - 1;\n\t\t}\n\t\treturn last = edge[last][c];\n\t}\n}; // END HASH\nint add(int a, int b) { return a + b; } // Dopisać modulo jeżeli trzeba.\n// BEGIN HASH c44f07\nstruct Dp { int mn, mn_i, cnt; };\nDp operator+(Dp l, Dp r) {\n\treturn {min(l.mn, r.mn), l.mn < r.mn ? l.mn_i : r.mn_i, add(l.cnt, r.cnt)};\n}\nV<Dp> palindromic_split_dp(vi str, bool only_even_lens = false) {\n\tint n = ssize(str);\n\tEertree t;\n\tvi big_link(2), diff(2);\n\tV<Dp> series_ans(2), ans(n, {n + 1, -1, 0});\n\tREP(i, n) {\n\t\tint last = t.add_letter(str[i]);\n\t\tif(last >= ssize(big_link)) {\n\t\t\tdiff.eb(t.len.back() - t.len[t.link.back()]);\n\t\t\tbig_link.eb(diff.back() == diff[t.link.back()] ? big_link[t.link.back()] : t.link.back());\n\t\t\tseries_ans.eb();\n\t\t}\n\t\tfor(int v = last; t.len[v] > 0; v = big_link[v]) {\n\t\t\tint j = i - t.len[big_link[v]] - diff[v];\n\t\t\tseries_ans[v] = j == -1 ? Dp{0, j, 1} : Dp{ans[j].mn, j, ans[j].cnt};\n\t\t\tif(diff[v] == diff[t.link[v]])\n\t\t\t\tseries_ans[v] = series_ans[v] + series_ans[t.link[v]];\n\t\t\tif(i % 2 == 1 or not only_even_lens)\n\t\t\t\tans[i] = ans[i] + Dp{series_ans[v].mn + 1, series_ans[v].mn_i, series_ans[v].cnt};\n\t\t}\n\t}\n\treturn ans;\n} // END HASH\n// BEGIN HASH e17097\nV<pii> construct_min_palindromic_split(V<Dp> ans) {\n\tif(ans.back().mn == ssize(ans) + 1)\n\t\treturn {};\n\tV<pii> split = {{0, ssize(ans) - 1}};\n\twhile(ans[split.back().se].mn_i != -1)\n\t\tsplit.eb(0, ans[split.back().se].mn_i);\n\treverse(all(split));\n\tREP(i, ssize(split) - 1)\n\t\tsplit[i + 1].fi = split[i].se + 1;\n\treturn split;\n} // END HASH",
)

#code-entry(
  name: "hashing",
  hash: "781b34",
  includes: (),
  opis: [Hashowanie z małą stałą. Można zmienić bazę (jeśli serio trzeba). `openssl prime -generate -bits 60` generuje losową liczbę pierwszą o $60$ bitach ($<= 1.15 dot  10^{18} $).],
  lang: "cpp",
  code: "struct Hashing {\n\tvll ha, pw;\n\tstatic constexpr ll mod = (1ll << 61) - 1;\n\tll reduce(ll x) { return x >= mod ? x - mod : x; }\n\tll mul(ll a, ll b) {\n\t\tC auto c = __int128(a) * b;\n\t\treturn reduce(ll(c & mod) + ll(c >> 61));\n\t}\n\tHashing(C vi &str, C int base = 37) {\n\t\tint len = ssize(str);\n\t\tha.resize(len + 1);\n\t\tpw.resize(len + 1, 1);\n\t\tREP(i, len) {\n\t\t\tha[i + 1] = reduce(mul(ha[i], base) + str[i] + 1);\n\t\t\tpw[i + 1] = mul(pw[i], base);\n\t\t}\n\t}\n\tll operator()(int l, int r) {\n\t\treturn reduce(ha[r + 1] - mul(ha[l], pw[r - l + 1]) + mod);\n\t}\n};",
)

#code-entry(
  name: "kmp",
  hash: "6cf4ba",
  includes: (),
  opis: [$cal(O)(n)$, zachodzi [0, pi[i]) = (i - pi[i], i]. `get_kmp({0,1,0,0,1,0,1,0,0,1\`) == {0,0,1,1,2,3,2,3,4,5}}, `get_borders({0,1,0,0,1,0,1,0,0,1\`) == {2,5,10}}.],
  lang: "cpp",
  code: "// BEGIN HASH d38133\nvi get_kmp(vi str) {\n\tint len = ssize(str);\n\tvi ret(len);\n\tfor(int i = 1; i < len; i++) {\n\t\tint pos = ret[i - 1];\n\t\twhile(pos and str[i] != str[pos])\n\t\t\tpos = ret[pos - 1];\n\t\tret[i] = pos + (str[i] == str[pos]);\n\t}\n\treturn ret;\n} // END HASH\nvi get_borders(vi str) {\n\tvi kmp = get_kmp(str), ret;\n\tint len = ssize(str);\n\twhile(len) {\n\t\tret.eb(len);\n\t\tlen = kmp[len - 1];\n\t}\n\treturn vi(rall(ret));\n}",
)

#code-entry(
  name: "lyndon-min-cyclic-rot",
  hash: "51b6f0",
  includes: (),
  opis: [$cal(O)(n)$, wyznaczanie faktoryzacji Lyndona oraz (przy jej pomocy) minimalnego suffixu oraz minimalnego przesunięcia cyklicznego. Ta faktoryzacja to unikalny podział słowa $s$ na $"w_1w_2dots"  "w_k"$, że $"w_1">= "w_2">= dots  >= "w_k"$ oraz $"w_i"$ jest ściśle mniejsze od każdego jego suffixu. `duval("abacaba") == {{0, 3\`, {4, 5}, {6, 6}}}, `min_suffix("abacab") == "ab"`, `min_cyclic_shift("abacaba") == "aabacab"`.],
  lang: "cpp",
  code: "V<pii> duval(vi s) {\n\tint n = ssize(s), i = 0;\n\tV<pii> ret;\n\twhile(i < n) {\n\t\tint j = i + 1, k = i;\n\t\twhile(j < n and s[k] <= s[j]) {\n\t\t\tk = (s[k] < s[j] ? i : k + 1);\n\t\t\t++j;\n\t\t}\n\t\twhile(i <= k) {\n\t\t\tret.eb(i, i + j - k - 1);\n\t\t\ti += j - k;\n\t\t}\n\t}\n\treturn ret;\n}\nvi min_suffix(vi s) {\n\treturn {s.begin() + duval(s).back().fi, s.end()};\n}\nvi min_cyclic_shift(vi s) {\n\tint n = ssize(s);\n\tREP(i, n)\n\t\ts.eb(s[i]);\n\tfor(auto [l, r] : duval(s))\n\t\tif(n <= r) {\n\t\t\treturn {s.begin() + l, s.begin() + l + n};\n\t\t}\n\tassert(false);\n}",
)

#code-entry(
  name: "manacher",
  hash: "f87a5b",
  includes: (),
  opis: [$cal(O)(n)$, `radius[p][i]` = $"rad"$ = największy promień palindromu parzystości $p$ o środku $i$. $L=i-"rad"+!p,   R=i+"rad"$ to palindrom. Dla `[abaababaab]` daje `[003000020], [0100141000]`.],
  lang: "cpp",
  code: "array<vi, 2> manacher(vi &in) {\n\tint n = ssize(in);\n\tarray<vi, 2> radius = {{vi(n - 1), vi(n)}};\n\tREP(parity, 2) {\n\t\tint z = parity ^ 1, L = 0, R = 0;\n\t\tREP(i, n - z) {\n\t\t\tint &rad = radius[parity][i];\n\t\t\tif(i <= R - z)\n\t\t\t\trad = min(R - i, radius[parity][L + (R - i - z)]);\n\t\t\tint l = i - rad + z, r = i + rad;\n\t\t\twhile(0 <= l - 1 && r + 1 < n && in[l - 1] == in[r + 1])\n\t\t\t\t++rad, ++r, --l;\n\t\t\tif(r > R)\n\t\t\t\tL = l, R = r;\n\t\t}\n\t}\n\treturn radius;\n}",
)

#code-entry(
  name: "pref",
  hash: "103217",
  includes: (),
  opis: [$cal(O)(n)$, zwraca tablicę prefixo prefixową $[0, "pref"[i]) = [i, i + "pref"[i])$.],
  lang: "cpp",
  code: "vi pref(vi str) {\n\tint n = ssize(str);\n\tvi ret(n);\n\tret[0] = n;\n\tint i = 1, m = 0;\n\twhile(i < n) {\n\t\twhile(m + i < n and str[m + i] == str[m])\n\t\t\tm++;\n\t\tret[i++] = m;\n\t\tm = max(0, m - 1);\n\t\tfor(int j = 1; ret[j] < m; m--)\n\t\t\tret[i++] = ret[j++];\n\t}\n\treturn ret;\n}",
)

#code-entry(
  name: "squares",
  hash: "e78cf9",
  includes: ("pref",),
  opis: [$cal(O)(n log  n)$, zwraca wszystkie skompresowane trójki $("start_l", "start_r", "len")$ oznaczające, że podsłowa zaczynające się w $["start_l", "start_r"]$ o długości $"len"$ są kwadratami, jest ich $cal(O)(n log  n)$.],
  lang: "cpp",
  code: "V<tuple<int, int, int>> squares(C vi &s) {\n\tV<tuple<int, int, int>> ans;\n\tV pos(ssize(s) + 2, -1);\n\tFOR(mid, 1, ssize(s) - 1) {\n\t\tint part = mid & ~(mid - 1), off = mid - part;\n\t\tint end = min(mid + part, ssize(s));\n\t\tV a(s.begin() + off, s.begin() + off + part),\n\t\t\tb(s.begin() + mid, s.begin() + end),\n\t\t\tra(rall(a));\n\t\tREP(j, 2) {\n\t\t\t auto z1 = pref(ra), bha = b;\n\t\t\t bha.eb(-1);\n\t\t\t for(int x : a) bha.eb(x);\n\t\t\t auto z2 = pref(bha);\n\t\t\t for(auto *v : {&z1, &z2}) {\n\t\t\t\t v[0][0] = ssize(v[0]);\n\t\t\t\t v->eb(0);\n\t\t\t }\n\t\t\t REP(c, ssize(a)) {\n\t\t\t\tint l = ssize(a) - c, x = c - min(l - 1, z1[l]),\n\t\t\t\t\ty = c - max(l - z2[ssize(b) + c + 1], j),\n\t\t\t\t\tsb = (j ? end - y - l * 2 : off + x),\n\t\t\t\t\tse = (j ? end - x - l * 2 + 1 : off + y + 1),\n\t\t\t\t\t&p = pos[l];\n\t\t\t\tif (x > y) continue;\n\t\t\t\tif (p != -1 && get<1>(ans[p]) + 1 == sb)\n\t\t\t\t\tget<1>(ans[p]) = se - 1;\n\t\t\t\telse\n\t\t\t\t\tp = ssize(ans), ans.eb(sb, se - 1, l);\n\t\t\t }\n\t\t\t a = V(rall(b));\n\t\t\t b.swap(ra);\n\t\t }\n\t}\n\treturn ans;\n}",
)

#code-entry(
  name: "suffix-array-interval",
  hash: "a0655e",
  includes: ("suffix-array-short",),
  opis: [$cal(O)("tlog"  n)$, wyznaczanie przedziałów podsłowa w tablicy suffixowej. Zwraca przedział $[l, r]$, gdzie dla każdego $i$ w $[l, r]$, $t$ jest podsłowem $"sa"."sa"[i]$ lub $[-1, -1]$ jeżeli nie ma takiego $i$.],
  lang: "cpp",
  code: "pii get_substring_sa_range(C vi &s, C vi &sa, C vi &t) {\n\tauto get_lcp = [&](int i) -> int {\n\t\tREP(k, ssize(t))\n\t\t\tif(i + k >= ssize(s) or s[i + k] != t[k])\n\t\t\t\treturn k;\n\t\treturn ssize(t);\n\t};\n\tauto get_side = [&](bool search_left) {\n\t\tint l = 0, r = ssize(sa) - 1;\n\t\twhile(l < r) {\n\t\t\tint m = (l + r + not search_left) / 2, lcp = get_lcp(sa[m]);\n\t\t\tif(lcp == ssize(t))\n\t\t\t\t(search_left ? r : l) = m;\n\t\t\telse if(sa[m] + lcp >= ssize(s) or s[sa[m] + lcp] < t[lcp])\n\t\t\t\tl = m + 1;\n\t\t\telse\n\t\t\t\tr = m - 1;\n\t\t}\n\t\treturn l;\n\t};\n\tint l = get_side(true);\n\tif(get_lcp(sa[l]) != ssize(t))\n\t\treturn {-1, -1};\n\treturn {l, get_side(false)};\n}",
)

#code-entry(
  name: "suffix-array-long",
  hash: "0c0515",
  includes: (),
  opis: [$cal(O)(n + alpha)$, $"sa"$ zawiera posortowane suffixy, zawiera pusty suffix, $"lcp"[i]$ to $"lcp"$ suffixu $"sa"[i]$ i $"sa"[i + 1]$, Dla `s = aabaaab`, `sa={7,3,4,0,5,1,6,2\`,lcp={0,2,3,1,2,0,1}}],
  lang: "cpp",
  code: "// BEGIN HASH 262977\nvoid induced_sort(C vi &vec, int alpha, vi &sa,\n\t\tC V<bool> &sl, C vi &lms_idx) {\n\tvi l(alpha), r(alpha);\n\tfor (int c : vec) {\n\t\tif (c + 1 < alpha)\n\t\t\t++l[c + 1];\n\t\t++r[c];\n\t}\n\tpartial_sum(all(l), l.begin());\n\tpartial_sum(all(r), r.begin());\n\tfill(all(sa), -1);\n\tRFOR(i, ssize(lms_idx) - 1, 0)\n\t\tsa[--r[vec[lms_idx[i]]]] = lms_idx[i];\n\tfor (int i : sa)\n\t\tif (i >= 1 and sl[i - 1])\n\t\t\tsa[l[vec[i - 1]]++] = i - 1;\n\tfill(all(r), 0);\n\tfor (int c : vec)\n\t\t++r[c];\n\tpartial_sum(all(r), r.begin());\n\tfor (int k = ssize(sa) - 1, i = sa[k]; k >= 1; --k, i = sa[k])\n\t\tif (i >= 1 and not sl[i - 1])\n\t\t\tsa[--r[vec[i - 1]]] = i - 1;\n}\nvi sa_is(C vi &vec, int alpha) {\n\tC int n = ssize(vec);\n\tvi sa(n), lms_idx;\n\tV<bool> sl(n);\n\tRFOR(i, n - 2, 0) {\n\t\tsl[i] = vec[i] > vec[i + 1] or (vec[i] == vec[i + 1] and sl[i + 1]);\n\t\tif (sl[i] and not sl[i + 1])\n\t\t\tlms_idx.eb(i + 1);\n\t}\n\treverse(all(lms_idx));\n\tinduced_sort(vec, alpha, sa, sl, lms_idx);\n\tvi new_lms_idx(ssize(lms_idx)), lms_vec(ssize(lms_idx));\n\tfor (int i = 0, k = 0; i < n; ++i)\n\t\tif (not sl[sa[i]] and sa[i] >= 1 and sl[sa[i] - 1])\n\t\t\tnew_lms_idx[k++] = sa[i];\n\tint cur = sa[n - 1] = 0;\n\tREP (k, ssize(new_lms_idx) - 1) {\n\t\tint i = new_lms_idx[k], j = new_lms_idx[k + 1];\n\t\tif (vec[i] != vec[j]) {\n\t\t\tsa[j] = ++cur;\n\t\t\tcontinue;\n\t\t}\n\t\tbool flag = false;\n\t\tfor (int a = i + 1, b = j + 1;; ++a, ++b) {\n\t\t\tif (vec[a] != vec[b]) {\n\t\t\t\tflag = true;\n\t\t\t\tbreak;\n\t\t\t}\n\t\t\tif ((not sl[a] and sl[a - 1]) or (not sl[b] and sl[b - 1])) {\n\t\t\t\tflag = not (not sl[a] and sl[a - 1] and not sl[b] and sl[b - 1]);\n\t\t\t\tbreak;\n\t\t\t}\n\t\t}\n\t\tsa[j] = (flag ? ++cur : cur);\n\t}\n\tREP (i, ssize(lms_idx))\n\t\tlms_vec[i] = sa[lms_idx[i]];\n\tif (cur + 1 < ssize(lms_idx)) {\n\t\tvi lms_sa = sa_is(lms_vec, cur + 1);\n\t\tREP (i, ssize(lms_idx))\n\t\t\tnew_lms_idx[i] = lms_idx[lms_sa[i]];\n\t}\n\tinduced_sort(vec, alpha, sa, sl, new_lms_idx);\n\treturn sa;\n}\nvi suffix_array(C vi &s, int alpha) {\n\tvi vec(ssize(s) + 1);\n\tREP(i, ssize(s))\n\t\tvec[i] = s[i] + 1;\n\tvi ret = sa_is(vec, alpha + 2);\n\treturn ret;\n} // END HASH\nvi get_lcp(C vi &s, C vi &sa) {\n\tint n = ssize(s), k = 0;\n\tvi lcp(n), rank(n);\n\tREP (i, n)\n\t\trank[sa[i + 1]] = i;\n\tfor (int i = 0; i < n; i++, k ? k-- : 0) {\n\t\tif (rank[i] == n - 1) {\n\t\t\tk = 0;\n\t\t\tcontinue;\n\t\t}\n\t\tint j = sa[rank[i] + 2];\n\t\twhile (i + k < n and j + k < n and s[i + k] == s[j + k])\n\t\t\tk++;\n\t\tlcp[rank[i]] = k;\n\t}\n\tlcp.pop_back();\n\tlcp.insert(lcp.begin(), 0);\n\treturn lcp;\n}",
)

#code-entry(
  name: "suffix-array-short",
  hash: "b8cca1",
  includes: (),
  opis: [$cal(O)("nlog"  n)$, zawiera posortowane suffixy, zawiera pusty suffix, $"lcp"[i]$ to $"lcp"$ suffixu $"sa"[i - 1]$ i $"sa"[i]$, Dla `s = aabaaab`, `sa={7,3,4,0,5,1,6,2\`,lcp={0,0,2,3,1,2,0,1}}],
  lang: "cpp",
  code: "pair<vi, vi> suffix_array(vi s, int alpha = 26) {\n\t++alpha;\n\tfor(int &c : s) ++c;\n\ts.eb(0);\n\tint n = ssize(s), k = 0, a, b;\n\tvi x(all(s));\n\tvi y(n), ws(max(n, alpha)), rank(n);\n\tvi sa = y, lcp = y;\n\tiota(all(sa), 0);\n\tfor(int j = 0, p = 0; p < n; j = max(1, j * 2), alpha = p) {\n\t\tp = j;\n\t\tiota(all(y), n - j);\n\t\tREP(i, n) if(sa[i] >= j)\n\t\t\ty[p++] = sa[i] - j;\n\t\tfill(all(ws), 0);\n\t\tREP(i, n) ws[x[i]]++;\n\t\tFOR(i, 1, alpha - 1) ws[i] += ws[i - 1];\n\t\tfor(int i = n; i--;) sa[--ws[x[y[i]]]] = y[i];\n\t\tswap(x, y);\n\t\tp = 1, x[sa[0]] = 0;\n\t\tFOR(i, 1, n - 1) a = sa[i - 1], b = sa[i], x[b] =\n\t\t\t(y[a] == y[b] && y[a + j] == y[b + j]) ? p - 1 : p++;\n\t}\n\tFOR(i, 1, n - 1) rank[sa[i]] = i;\n\tfor(int i = 0, j; i < n - 1; lcp[rank[i++]] = k)\n\t\tfor(k && k--, j = sa[rank[i] - 1];\n\t\t\ts[i + k] == s[j + k]; k++);\n\tlcp.erase(lcp.begin());\n\treturn {sa, lcp};\n}",
)

#code-entry(
  name: "suffix-automaton",
  hash: "d7a7c7",
  includes: (),
  opis: [$cal(O)("nalpha" )$ (szybsze, ale więcej pamięci) albo $cal(O)("nlog" alpha )$ (mapa), buduje suffix automaton. Wystąpienia wzorca, liczba różnych podsłów, sumaryczna długość wszystkich podsłów, leksykograficznie $k$-te podsłowo, najmniejsze przesunięcie cykliczne, liczba wystąpień podsłowa, pierwsze wystąpienie, najkrótsze niewystępujące podsłowo, longest common substring wielu słów.],
  lang: "cpp",
  code: "struct SuffixAutomaton {\n\tstatic constexpr int sigma = 26;\n\tusing Node = array<int, sigma>; // map<int, int>\n\tNode new_node;\n\tV<Node> edges;\n\tvi link = {-1}, length = {0};\n\tint last = 0;\n\tSuffixAutomaton() {\n\t\tnew_node.fill(-1);\t // -1 - stan nieistniejacy\n\t\tedges = {new_node};  // dodajemy stan startowy, ktory reprezentuje puste slowo\n\t}\n\tvoid add_letter(int c) {\n\t\tedges.eb(new_node);\n\t\tlength.eb(length[last] + 1);\n\t\tlink.eb(0);\n\t\tint r = ssize(edges) - 1, p = last;\n\t\twhile(p != -1 && edges[p][c] == -1) {\n\t\t\tedges[p][c] = r;\n\t\t\tp = link[p];\n\t\t}\n\t\tif(p != -1) {\n\t\t\tint q = edges[p][c];\n\t\t\tif(length[p] + 1 == length[q])\n\t\t\t\tlink[r] = q;\n\t\t\telse {\n\t\t\t\tedges.eb(edges[q]);\n\t\t\t\tlength.eb(length[p] + 1);\n\t\t\t\tlink.eb(link[q]);\n\t\t\t\tint q_prim = ssize(edges) - 1;\n\t\t\t\tlink[q] = link[r] = q_prim;\n\t\t\t\twhile(p != -1 && edges[p][c] == q) {\n\t\t\t\t\tedges[p][c] = q_prim;\n\t\t\t\t\tp = link[p];\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t\tlast = r;\n\t}\n\tbool is_inside(vi &s) {\n\t\tint q = 0;\n\t\tfor(int c : s) {\n\t\t\tif(edges[q][c] == -1)\n\t\t\t\treturn false;\n\t\t\tq = edges[q][c];\n\t\t}\n\t\treturn true;\n\t}\n};",
)

#code-entry(
  name: "suffix-tree",
  hash: "fdf937",
  includes: (),
  opis: [$cal(O)(n log  n)$ lub $cal(O)(n alpha )$, Dla słowa `abaab\#` (hash jest aby to zawsze liście były stanami kończącymi) stworzy `sons[0]={(\#,10),(a,4),(b,8)\`, sons[4]={(a,5),(b,6)}, sons[6]={(\#,7),(a,2)}, sons[8]={(\#,9),(a,3)}}, reszta sons'ów pusta, `slink[6]=8` i reszta slink'ów $0$ (gdzie slink jest zdefiniowany dla nie-liści jako wierzchołek zawierający ten suffix bez ostatniej literki), `up_edge_range[2]=up_edge_range[3]=(2,5), up_edge_range[5]=(3,5)` i reszta jednoliterowa. Wierzchołek 1 oraz suffix wierzchołków jest roboczy. Zachodzi `up_edge_range[0]=(-1,-1), parent[0]=0, slink[0]=1`.],
  lang: "cpp",
  code: "struct SuffixTree {\n\tC int n;\n\tC vi &_in;\n\tV<map<int, int>> sons;\n\tV<pii> up_edge_range;\n\tvi parent, slink;\n\tint tv = 0, tp = 0, ts = 2, la = 0;\n\tvoid ukkadd(int c) {\n\t\tauto &lr = up_edge_range;\nsuff:\n\t\tif (lr[tv].se < tp) {\n\t\t\tif (sons[tv].find(c) == sons[tv].end()) {\n\t\t\t\tsons[tv][c] = ts; lr[ts].fi = la; parent[ts++] = tv;\n\t\t\t\ttv = slink[tv]; tp = lr[tv].se + 1; goto suff;\n\t\t\t}\n\t\t\ttv = sons[tv][c]; tp = lr[tv].fi;\n\t\t}\n\t\tif (tp == -1 || c == _in[tp])\n\t\t\ttp++;\n\t\telse {\n\t\t\tlr[ts + 1].fi = la; parent[ts + 1] = ts;\n\t\t\tlr[ts].fi = lr[tv].fi; lr[ts].se = tp - 1;\n\t\t\tparent[ts] = parent[tv]; sons[ts][c] = ts + 1; sons[ts][_in[tp]] = tv;\n\t\t\tlr[tv].fi = tp; parent[tv] = ts;\n\t\t\tsons[parent[ts]][_in[lr[ts].fi]] = ts; ts += 2;\n\t\t\ttv = slink[parent[ts - 2]]; tp = lr[ts - 2].fi;\n\t\t\twhile (tp <= lr[ts - 2].se) {\n\t\t\t\ttv = sons[tv][_in[tp]]; tp += lr[tv].se - lr[tv].fi + 1;\n\t\t\t}\n\t\t\tif (tp == lr[ts - 2].se + 1)\n\t\t\t\tslink[ts - 2] = tv;\n\t\t\telse\n\t\t\t\tslink[ts - 2] = ts;\n\t\t\ttp = lr[tv].se - (tp - lr[ts-2].se) + 2; goto suff;\n\t\t}\n\t}\n\t// Remember to append string with a hash.\n\tSuffixTree(C vi &in, int alpha)\n\t\t: n(ssize(in)), _in(in), sons(2 * n + 1),\n\t\tup_edge_range(2 * n + 1, pair(0, n - 1)), parent(2 * n + 1), slink(2 * n + 1) {\n\t\tup_edge_range[0] = up_edge_range[1] = {-1, -1};\n\t\tslink[0] = 1;\n\t\t// When changing map to V, fill sons exactly here with -1 and replace if in ukkadd with sons[tv][c] == -1.\n\t\tREP(ch, alpha)\n\t\t\tsons[1][ch] = 0;\n\t\tfor(; la < n; ++la)\n\t\t\tukkadd(in[la]);\n\t}\n};",
)

#code-entry(
  name: "wildcard-matching",
  hash: "a35e01",
  includes: ("math/ntt",),
  opis: [$cal(O)(n log  n)$, zwraca tablicę wystąpień wzorca. Alfabet od $0$. Znaki zapytania to $-1$. Mogą być zarówno w tekście jak i we wzrocu. Dla alfabetów większych niż $15$ lepiej użyć bezpieczniejszej wersji.],
  lang: "cpp",
  code: "// BEGIN HASH ee35a0\nV<bool> wildcard_matching(vi text, vi pattern) {\n\tfor (int& e : text) ++e;\n\tfor (int& e : pattern) ++e;\n\treverse(all(pattern));\n\tint n = ssize(text), m = ssize(pattern);\n\tint sz = 1 << __lg(2 * n - 1);\n\tvi a(sz), b(sz), c(sz);\n\tauto h = [&](auto f, auto g) {\n\t\tfill(all(a), 0);\n\t\tfill(all(b), 0);\n\t\tREP(i, n) a[i] = f(text[i]);\n\t\tREP(i, m) b[i] = g(pattern[i]);\n\t\tntt(a, sz), ntt(b, sz);\n\t\tREP(i, sz) a[i] = mul(a[i], b[i]);\n\t\tntt(a, sz, true);\n\t\tREP(i, sz) c[i] = add(c[i], a[i]);\n\t};\n\th([](int x){return powi(x,3);},identity());\n\th([](int x){return sub(0, mul(2, mul(x, x)));}, [](int x){return mul(x, x);});\n\th(identity(),[](int x){return powi(x,3);});\n\tV<bool> ret(n - m + 1);\n\tFOR(i, m, n) ret[i - m] = !c[i - 1];\n\treturn ret;\n} // END HASH\nV<bool> safer_wildcard_matching(vi text, vi pattern, int alpha = 26) {\n\tstatic mt19937 rng(0); // Can be changed.\n\tint n = ssize(text), m = ssize(pattern);\n\tV ret(n - m + 1, true);\n\tvi v(alpha), a(n, -1), b(m, -1);\n\tREP(iters, 2) { // The more the better.\n\t\tREP(i, alpha) v[i] = int(rng() % (mod - 1));\n\t\tREP(i, n) if (text[i] != -1) a[i] = v[text[i]];\n\t\tREP(i, m) if (pattern[i] != -1) b[i] = v[pattern[i]];\n\t\tauto h = wildcard_matching(a, b);\n\t\tREP(i, n - m + 1) ret[i] = ret[i] & h[i];\n\t}\n\treturn ret;\n}",
)

#my-chapter("Optymalizacje")

#code-entry(
  name: "divide-and-conquer-dp",
  hash: "e7e6da",
  includes: (),
  opis: [$cal(O)("nmlog"  m)$, dla funkcji $"cost"(k,j)$ wylicza $"dp"(i,j) = "min_"{0<=q k<=q j}  "dp"(i-1,k-1) + "cost"(k,j)$. Działa tylko wtedy, gdy $"opt"(i,j-1)<= "opt"(i,j)$, a jest to zawsze spełnione, gdy $"cost"(b,c)<= "cost"(a,d)$ oraz $"cost"(a,c) + "cost"(b,d)<= "cost"(a,d) + "cost"(b,c)$ dla $a<= b<= c<= d$.],
  lang: "cpp",
  code: "vll divide_and_conquer_optimization(int n, int m, function<ll(int,int)> cost) {\n\tvll dp_before(m);\n\tauto dp_cur = dp_before;\n\tREP(i, m)\n\t\tdp_before[i] = cost(0, i);\n\tfunction<void(int,int,int,int)> compute = [&](int l, int r, int optl, int optr) {\n\t\tif (l > r)\n\t\t\treturn;\n\t\tint mid = (l + r) / 2, opt;\n\t\tpair<ll, int> best = {numeric_limits<ll>::max(), -1};\n\t\tFOR(k, optl, min(mid, optr))\n\t\t\tchmin(best, pair((k ? dp_before[k - 1] : 0) + cost(k, mid), k));\n\t\ttie(dp_cur[mid], opt) = best;\n\t\tcompute(l, mid - 1, optl, opt);\n\t\tcompute(mid + 1, r, opt, optr);\n\t};\n\tREP(i, n) {\n\t\tcompute(0, m - 1, 0, m - 1);\n\t\tswap(dp_before, dp_cur);\n\t}\n\treturn dp_before;\n}",
)

#code-entry(
  name: "dp-1d1d",
  hash: "ad7df5",
  includes: (),
  opis: [$cal(O)("nlog"  n)$, $n>0$ długość paska, `cost(i, j)` koszt odcinka $[i, j]$ Dla $a <=q b <=q c <=q d$ `cost` ma spełniać $"cost"(a, c) + "cost"(b, d) <=q "cost"(a, d) + "cost"(b, c)$. Dzieli pasek $[0, n)$ na odcinki $[0, "cuts"[0]], ..., ("cuts"[i-1], "cuts"[i]]$, gdzie `cuts.back() == n - 1`, aby sumaryczny koszt wszystkich odcinków był minimalny. `cuts` to prawe końce tych odcinków. Zwraca `(opt_cost, cuts)`. Aby maksymalizować koszt zamienić nierówności tam, gdzie wskazane. Aby uzyskać $cal(O)(n)$, należy przepisać overtake w oparciu o dodatkowe założenia, aby chodził w $cal(O)(1)$.],
  lang: "cpp",
  code: "pair<ll, vi> dp_1d1d(int n, function<ll (int, int)> cost) {\n\tV<pair<ll, int>> dp(n);\n\tvi lf(n + 2), rg(n + 2), dead(n);\n\tV<vi> events(n + 1);\n\tint beg = n, end = n + 1;\n\trg[beg] = end; lf[end] = beg;\n\tauto score = [&](int i, int j) {\n\t\treturn dp[j].fi + cost(j + 1, i);\n\t};\n\tauto overtake = [&](int a, int b, int mn) {\n\t\tint bp = mn - 1, bk = n;\n\t\twhile (bk - bp > 1) {\n\t\t\tint bs = (bp + bk) / 2;\n\t\t\tif (score(bs, a) <= score(bs, b)) // tu >=\n\t\t\t\tbk = bs;\n\t\t\telse\n\t\t\t\tbp = bs;\n\t\t}\n\t\treturn bk;\n\t};\n\tauto add = [&](int i, int mn) {\n\t\tif (lf[i] == beg)\n\t\t\treturn;\n\t\tevents[overtake(i, lf[i], mn)].eb(i);\n\t};\n\tREP (i, n) {\n\t\tdp[i] = {cost(0, i), -1};\n\t\tREP (j, ssize(events[i])) {\n\t\t\tint x = events[i][j];\n\t\t\tif (dead[x])\n\t\t\t\tcontinue;\n\t\t\tdead[lf[x]] = 1; lf[x] = lf[lf[x]];\n\t\t\trg[lf[x]] = x; add(x, i);\n\t\t}\n\t\tif (rg[beg] != end)\n\t\t\tchmin(dp[i], pair(score(i, rg[beg]), rg[beg])); // tu max\n\t\tlf[i] = lf[end]; rg[i] = end;\n\t\trg[lf[i]] = i; lf[rg[i]] = i;\n\t\tadd(i, i + 1);\n\t}\n\tvi cuts;\n\tfor (int p = n - 1; p != -1; p = dp[p].se)\n\t\tcuts.eb(p);\n\treverse(all(cuts));\n\treturn pair(dp[n - 1].fi, cuts);\n}",
)

#code-entry(
  name: "fio",
  hash: "115ad1",
  includes: (),
  opis: [FIO do wpychania kolanem. Nie należy wtedy używać cin/cout],
  lang: "cpp",
  code: "#ifdef ONLINE_JUDGE\n// write this when judge is on Windows\ninline int getchar_unlocked() { return _getchar_nolock(); }\ninline void putchar_unlocked(char c) { _putchar_nolock(c); }\n#endif\n// BEGIN HASH 1ed0dd\nint fastin() {\n\tint n = 0, c = getchar_unlocked();\n\twhile(isspace(c))\n\t\tc = getchar_unlocked();\n\twhile(isdigit(c)) {\n\t\tn = 10 * n + (c - '0');\n\t\tc = getchar_unlocked();\n\t}\n\treturn n;\n} // END HASH\n// BEGIN HASH 3abf5f\nint fastin_negative() {\n\tint n = 0, negative = false, c = getchar_unlocked();\n\twhile(isspace(c))\n\t\tc = getchar_unlocked();\n\tif(c == '-') {\n\t\tnegative = true;\n\t\tc = getchar_unlocked();\n\t}\n\twhile(isdigit(c)) {\n\t\tn = 10 * n + (c - '0');\n\t\tc = getchar_unlocked();\n\t}\n\treturn negative ? -n : n;\n} // END HASH\n// BEGIN HASH 323fab\ndouble fastin_double() {\n\tdouble x = 0, t = 1;\n\tint negative = false, c = getchar_unlocked();\n\twhile(isspace(c))\n\t\tc = getchar_unlocked();\n\tif (c == '-') {\n\t\tnegative = true;\n\t\tc = getchar_unlocked();\n\t}\n\twhile (isdigit(c)) {\n\t\tx = x * 10 + (c - '0');\n\t\tc = getchar_unlocked();\n\t}\n\tif (c == '.') {\n\t\tc = getchar_unlocked();\n\t\twhile (isdigit(c)) {\n\t\t\tt /= 10;\n\t\t\tx = x + t * (c - '0');\n\t\t\tc = getchar_unlocked();\n\t\t}\n\t}\n\treturn negative ? -x : x;\n} // END HASH\n// BEGIN HASH 0b2d96\nvoid fastout(int x) {\n\tif(x == 0) {\n\t\tputchar_unlocked('0');\n\t\tputchar_unlocked(' ');\n\t\treturn;\n\t}\n\tif(x < 0) {\n\t\tputchar_unlocked('-');\n\t\tx *= -1;\n\t}\n\tstatic char t[10];\n\tint i = 0;\n\twhile(x) {\n\t\tt[i++] = char('0' + (x % 10));\n\t\tx /= 10;\n\t}\n\twhile(--i >= 0)\n\t\tputchar_unlocked(t[i]);\n\tputchar_unlocked(' ');\n}\nvoid nl() { putchar_unlocked('\\n'); }\n// END HASH",
)

#code-entry(
  name: "knuth",
  hash: "221040",
  includes: (),
  opis: [$cal(O)(n^2)$, dla tablicy $"cost"(i,j)$ wylicza $"dp"(i,j) = "min_"{i<=q k<j}  "dp"(i,k) + "dp"(k+1,j) + "cost"(i,j)$. Działa tylko wtedy, gdy $"opt"(i,j-1)<= "opt"(i,j)<= "opt"(i+1,j)$, a jest to zawsze spełnione, gdy $"cost"(b,c)<= "cost"(a,d)$ oraz $"cost"(a,c) + "cost"(b,d)<= "cost"(a,d) + "cost"(b,c)$ dla $a<= b<= c<= d$.],
  lang: "cpp",
  code: "ll knuth_optimization(V<vll> cost) {\n\tint n = ssize(cost);\n\tV dp(n, vll(n, numeric_limits<ll>::max()));\n\tV opt(n, vi(n));\n\tREP(i, n) {\n\t\topt[i][i] = i;\n\t\tdp[i][i] = cost[i][i];\n\t}\n\tfor(int i = n - 2; i >= 0; --i)\n\t\tFOR(j, i + 1, n - 1)\n\t\t\tFOR(k, opt[i][j - 1], min(j - 1, opt[i + 1][j]))\n\t\t\t\tif(dp[i][j] >= dp[i][k] + dp[k + 1][j] + cost[i][j]) {\n\t\t\t\t\topt[i][j] = k;\n\t\t\t\t\tdp[i][j] = dp[i][k] + dp[k + 1][j] + cost[i][j];\n\t\t\t\t}\n\treturn dp[0][n - 1];\n}",
)

#code-entry(
  name: "linear-knapsack",
  hash: "5afd26",
  includes: (),
  opis: [$cal(O)("ndot" "ma" x ("w_i"))$ zamiast typowego $cal(O)("ndot" sum ("w_i"))$, pamięć $cal(O)(n+"ma" x ("w_i"))$, plecak zwracający największą otrzymywalną sumę ciężarów `<= bound`.],
  lang: "cpp",
  code: "ll knapsack(vi w, ll bound) {\n\terase_if(w, [=](int x){ return x > bound; });\n\t{\n\t\tll sum = accumulate(all(w), 0LL);\n\t\tif(sum <= bound)\n\t\t\treturn sum;\n\t}\n\tll w_init = 0;\n\tint b;\n\tfor(b = 0; w_init + w[b] <= bound; ++b)\n\t\tw_init += w[b];\n\tint W = *max_element(all(w));\n\tvi prev_s(2 * W, -1);\n\tauto get = [&](vi &v, ll i) -> int& {\n\t\treturn v[i - (bound  - W + 1)];\n\t};\n\tfor(ll mu = bound + 1; mu <= bound + W; ++mu)\n\t\tget(prev_s, mu) = 0;\n\tget(prev_s, w_init) = b;\n\tFOR(t, b, ssize(w) - 1) {\n\t\tV curr_s = prev_s;\n\t\tfor(ll mu = bound - W + 1; mu <= bound; ++mu)\n\t\t\tchmax(get(curr_s, mu + w[t]), get(prev_s, mu));\n\t\tfor(ll mu = bound + w[t]; mu >= bound + 1; --mu)\n\t\t\tfor(int j = get(curr_s, mu) - 1; j >= get(prev_s, mu); --j)\n\t\t\t\tchmax(get(curr_s, mu - w[j]), j);\n\t\tswap(prev_s, curr_s);\n\t}\n\tfor(ll mu = bound; mu >= 0; --mu)\n\t\tif(get(prev_s, mu) != -1)\n\t\t\treturn mu;\n\tassert(false);\n}",
)

#code-entry(
  name: "matroid-intersection",
  hash: "080bd2",
  includes: (),
  opis: [$cal(O)(r^2 dot  ("init" + n dot  "add"))$, where r is max independent set. Find largest subset S of [n] such that S is independent in both matroid A and B, given by their oracles, see example implementations below. Returns V V such that V[i] = 1 iff i-th element is included in found set; Zabrane z https://github.com/KacperTopolski/kactl/tree/main Zmienne w matroidach ustawiamy ręcznie aby "zainicjalizować" tylko jeśli mają komentarz co znaczą. W przeciwnym wypadku intersectMatroids zrobi robotę wołając init.],
  lang: "cpp",
  code: "// BEGIN HASH c90feb\ntemplate<class T, class U>\nV<bool> intersectMatroids(T& A, U& B, int n) {\n\tV<bool> ans(n);\n\tbool ok = 1;\n// NOTE: for weighted matroid intersection find\n// shortest augmenting paths first by weight change,\n// then by length using Bellman-Ford,\n\t// Speedup trick (only for unweighted):\n\tA.init(ans); B.init(ans);\n\tREP(i, n)\n\t\tif (A.canAdd(i) && B.canAdd(i))\n\t\t\tans[i] = 1, A.init(ans), B.init(ans);\n\t//End of speedup\n\twhile (ok) {\n\t\tV<vi> G(n);\n\t\tV<bool> good(n);\n\t\tqueue<int> que;\n\t\tvi prev(n, -1);\n\t\tA.init(ans); B.init(ans); ok = 0;\n\t\tREP(i, n) if (!ans[i]) {\n\t\t\tif (A.canAdd(i)) que.emplace(i), prev[i]=-2;\n\t\t\tgood[i] = B.canAdd(i);\n\t\t}\n\t\tREP(i, n) if (ans[i]) {\n\t\t\tans[i] = 0;\n\t\t\tA.init(ans); B.init(ans);\n\t\t\tREP(j, n) if (i != j && !ans[j]) {\n\t\t\t\tif (A.canAdd(j)) G[i].eb(j); //-cost[j]\n\t\t\t\tif (B.canAdd(j)) G[j].eb(i); // cost[i]\n\t\t\t}\n\t\t\tans[i] = 1;\n\t\t}\n\t\twhile (!que.empty()) {\n\t\t\tint i = que.front();\n\t\t\tque.pop();\n\t\t\tif (good[i]) { // best found (unweighted = shortest path)\n\t\t\t\tans[i] = 1;\n\t\t\t\twhile (prev[i] >= 0) { // alternate matching\n\t\t\t\t\tans[i = prev[i]] = 0;\n\t\t\t\t\tans[i = prev[i]] = 1;\n\t\t\t\t}\n\t\t\t\tok = 1; break;\n\t\t\t}\n\t\t\tfor(auto j: G[i]) if (prev[j] == -1)\n\t\t\t\tque.emplace(j), prev[j] = i;\n\t\t}\n\t}\n\treturn ans;\n} // END HASH\n// Matroid where each element has color\n// and set is independent iff for each color c\n// #{elements of color c} <= maxAllowed[c].\nstruct LimOracle {\n\tvi color; // color[i] = color of i-th element\n\tvi maxAllowed; // Limits for colors\n\tvi tmp;\n\t// Init oracle for independent set S; O(n)\n\tvoid init(V<bool>& S) {\n\t\ttmp = maxAllowed;\n\t\tREP(i, ssize(S)) tmp[color[i]] -= S[i];\n\t}\n\t// Check if S+{k} is independent; time: O(1)\n\tbool canAdd(int k) { return tmp[color[k]] > 0;}\n};\n// Graphic matroid - each element is edge,\n// set is independent iff subgraph is acyclic.\nstruct GraphOracle {\n\tV<pii> elems; // Ground set: graph edges\n\tint n; // Number of vertices, indexed [0;n-1]\n\tvi par;\n\tint find(int i) {\n\t\treturn par[i] == -1 ? i : par[i] = find(par[i]);\n\t}\n\t// Init oracle for independent set S; ~O(n)\n\tvoid init(V<bool>& S) {\n\t\tpar.assign(n, -1);\n\t\tREP(i, ssize(S)) if (S[i])\n\t\t\tpar[find(elems[i].fi)] = find(elems[i].se);\n\t}\n\t// Check if S+{k} is independent; time: ~O(1)\n\tbool canAdd(int k) {\n\t\treturn find(elems[k].fi) != find(elems[k].se);\n\t}\n};\n// Co-graphic matroid - each element is edge,\n// set is independent iff after removing edges\n// from graph number of connected components\n// doesn't change.\nstruct CographOracle {\n\tV<pii> elems; // Ground set: graph edges\n\tint n; // Number of vertices, indexed [0;n-1]\n\tV<vi> G;\n\tvi pre, low;\n\tint cnt;\n\tint dfs(int v, int p) {\n\t\tpre[v] = low[v] = ++cnt;\n\t\tfor(auto e: G[v]) if (e != p)\n\t\t\tchmin(low[v], pre[e] ?: dfs(e,v));\n\t\treturn low[v];\n\t}\n\t// Init oracle for independent set S; O(n)\n\tvoid init(V<bool>& S) {\n\t\tG.assign(n, {});\n\t\tpre.assign(n, 0);\n\t\tlow.resize(n);\n\t\tcnt = 0;\n\t\tREP(i,ssize(S)) if (!S[i]) {\n\t\t\tpii e = elems[i];\n\t\t\tG[e.fi].eb(e.se);\n\t\t\tG[e.se].eb(e.fi);\n\t\t}\n\t\tREP(v, n) if (!pre[v]) dfs(v, -1);\n\t}\n\t// Check if S+{k} is independent; time: O(1)\n\tbool canAdd(int k) {\n\t\tpii e = elems[k];\n\t\treturn max(pre[e.fi], pre[e.se]) != max(low[e.fi], low[e.se]);\n\t}\n};\n// Matroid equivalent to linear space with XOR\nstruct XorOracle {\n\tvll elems; // Ground set: numbers\n\tvll base;\n\t// Init for independent set S; O(n+r^2)\n\tvoid init(V<bool>& S) {\n\t\tbase.assign(63, 0);\n\t\tREP(i, ssize(S)) if (S[i]) {\n\t\t\tll e = elems[i];\n\t\t\tREP(j, ssize(base)) if ((e >> j) & 1) {\n\t\t\t\tif (!base[j]) {\n\t\t\t\t\tbase[j] = e;\n\t\t\t\t\tbreak;\n\t\t\t\t}\n\t\t\t\te ^= base[j];\n\t\t\t}\n\t\t}\n\t}\n\t// Check if S+{k} is independent; time: O(r)\n\tbool canAdd(int k) {\n\t\tll e = elems[k];\n\t\tREP(i, ssize(base)) if ((e >> i) & 1) {\n\t\t\tif (!base[i]) return 1;\n\t\t\te ^= base[i];\n\t\t}\n\t\treturn 0;\n\t}\n};",
)

#code-entry(
  name: "random",
  hash: "77ae04",
  includes: (),
  opis: [Szybsze rand.],
  lang: "cpp",
  code: "uint32_t xorshf96() {\n\tstatic uint32_t x = 123456789, y = 362436069, z = 521288629;\n\tx ^= x << 16; x ^= x >> 5; x ^= x << 1;\n\tuint32_t t = x; x = y; y = z; z = t ^ x ^ y;\n\treturn z;\n}",
)

#code-entry(
  name: "sos-dp",
  hash: "947fac",
  includes: (),
  opis: [$cal(O)(n 2^n)$, dla tablicy $A[i]$ oblicza tablicę $F["mask"] = sum _{"isubset"."eq"  "mask"} A[i]$, czyli sumę po podmaskach. Może też liczyć sumę po nadmaskach. `sos_dp(2, {4, 3, 7, 2\`)} zwraca `{4, 7, 11, 16\`}, `sos_dp(2, {4, 3, 7, 2\`, true)} zwraca `{16, 5, 9, 2\`}.],
  lang: "cpp",
  code: "vll sos_dp(int n, vll A, bool nad = false) {\n\tint N = (1 << n);\n\tif (nad) REP(i, N / 2) swap(A[i], A[(N - 1) ^ i]);\n\tauto F = A;\n\tREP(i, n)\n\t\tREP(mask, N)\n\t\t\tif ((mask >> i) & 1)\n\t\t\t\tF[mask] += F[mask ^ (1 << i)];\n\tif (nad) REP(i, N / 2) swap(F[i], F[(N - 1) ^ i]);\n\treturn F;\n}",
)

#my-chapter("Utils")

#code-entry(
  name: "dzien-probny",
  hash: "b68ef5",
  includes: ("data-structures/ordered-set",),
  opis: [Rzeczy do przetestowania w dzień próbny.],
  lang: "cpp",
  code: "// alternatywne mnożenie ll, gdyby na wypadek gdyby nie było __int128\nll llmul(ll a, ll b, ll m) {\n\treturn (a * b - (ll)((long double) a * b / m) * m + m) % m;\n}\nvoid test_int128() {\n\t__int128 x = (1llu << 62);\n\tx *= x;\n\tstring s;\n\twhile(x) {\n\t\ts += char(x % 10 + '0');\n\t\tx /= 10;\n\t}\n\tassert(s == \"61231558446921906466935685523974676212\");\n}\nvoid test_float128() {\n\t__float128 x = 4.2;\n\tassert(abs(double(x * x) - double(4.2 * 4.2)) < 1e-9);\n}\nvoid test_clock() {\n\tlong seeed = chrono::system_clock::now().time_since_epoch().count();\n\t(void) seeed;\n\tauto start = chrono::system_clock::now();\n\twhile(true) {\n\t\tauto end = chrono::system_clock::now();\n\t\tint ms = int(chrono::duration_cast<chrono::milliseconds>(end - start).count());\n\t\tif(ms > 420)\n\t\t\tbreak;\n\t}\n}\nvoid test_rd() {\n\t// czy jest sens to testowac?\n\tmt19937_64 my_rng(0);\n\tauto rd = [&](int l, int r) {\n\t\treturn uniform_int_distribution<int>(l, r)(my_rng);\n\t};\n\tassert(rd(0, 0) == 0);\n}\nvoid test_policy() {\n\tordered_set<int> s;\n\ts.insert(1);\n\ts.insert(2);\n\tassert(s.order_of_key(1) == 0);\n\tassert(*s.find_by_order(1) == 2);\n}\nvoid test_math() {\n\tconstexpr long double pi = acosl(-1);\n\tassert(3.14 < pi && pi < 3.15);\n}",
)

#code-entry(
  name: "main.py",
  hash: "a75dc7",
  includes: (),
  opis: [Przykładowy kod w Pythonie z różną funkcjonalnością.],
  lang: "py",
  code: "fib_mem = [1] * 2\ndef fill_fib(n):\n  global fib_mem\n  while len(fib_mem) <= n:\n    fib_mem.append(fib_mem[-2] + fib_mem[-1])\ndef main():\n  assert list(range(3, 6)) == [3, 4, 5]\n  s = set()\n  s.add(5)\n  for x in s:\n    print(x)\n  s = [2 * x for x in s]\n  print(eval(\"s[0] + 10\"))\n  m = {}\n  m[5] = 6\n  assert 5 in m\n  assert list(m) == [5]\n  line_list = list(map(int, input().split()))\n  print(line_list)\n  print(' '.join([\"a\", \"b\", str(5)]))\n  while True:\n    try:\n      line_int = int(input())\n    except Exception as e:\n      break\nmain()",
)

