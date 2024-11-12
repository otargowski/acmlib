/*
 * Opis: O(1), trzeba przed includem dać undef \texttt{\_GLIBCXX\_DEBUG}.
 */
#include<ext/pb_ds/assoc_container.hpp>
using namespace __gnu_pbds;
struct chash {
	C uint64_t C = ll(2e18 * acosl(-1)) + 69;
	C int RANDOM = mt19937(0)();
	size_t operator()(uint64_t x) C {
		return __builtin_bswap64((x^RANDOM) * C);
	}
};
template<class L, class R>
using hash_map = gp_hash_table<L, R, chash>;
