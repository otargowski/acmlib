/*
 * Opis: Nagłówki używane w każdym kodzie. Działa na każdy kontener i pary.
 *   \texttt{debug(a, b, c);} wypisze \texttt{[a, b, c]: a; b; c;}
 */
#pragma once

#include <bits/stdc++.h>
#define FOR(i,p,k) for(int i=(p); i<=(k); ++i)
#define REP(i,k) FOR(i,0,(k)-1)
#define RFOR(i,p,n) for(int i=(p); i>=(n); --i)
#define all(x) (x).begin(), (x).end()
#define rall(x) (x).rbegin(), (x).rend()
#define ssize(x) int((x).size())
#define fi first
#define se second
#define V vector
#define pb push_back
#define eb emplace_back
#define C const
#define pn printf("\n")
using namespace std;
typedef long long ll;
typedef V <int> vi;
typedef V <ll> vll;
typedef C int ci;
typedef C ll cll;
typedef pair <int, int> pii;
typedef pair <ll, ll> pll;
void chmin(auto &a, auto b){a=min(a,b);}
void chmax(auto &a, auto b){a=max(a,b);}
ci inf=2.1e9;
cll infll=4.5e18;
int I(){
    int z;
    scanf("%d", &z);
    //cin>>z;
    return z;
}

template<class A, class B> auto& operator<<(ostream &o, pair<A, B> p) {
	return o << '(' << p.fi << ", " << p.se << ')';
}
template<class T> auto operator<<(ostream &o, T x) -> decltype(x.end(), o) {
	o << '{'; int i = 0; for(auto e : x) o << (", ")+2*!i++ << e; return o << '}';
}

#define debug(...) {}

/*
int main() {
	cin.tie(0)->sync_with_stdio(0);

}
*/
