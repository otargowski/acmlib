#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

using namespace Treap;

struct Item {
	vi t;
	pNode root;
	Item() {
		root = new Node();
		t.eb(root->prio);
	}
	void check_integrity() {
		vi v;
		function<void(pNode)> dfs = [&](pNode p) {
			if (!p)
				return;
			dfs(p->l);
			v.eb(p->prio);
			dfs(p->r);
		};
		dfs(root);
		assert(t == v);
		assert(get_cnt(root) == ssize(t));
	}
};

Item con(Item a, Item b) {
	Item ret;
	merge(ret.root, a.root, b.root);
	ret.t = a.t;
	ret.t.insert(ret.t.end(), b.t.begin(), b.t.end());
	ret.check_integrity();
	return ret;
}

pair<Item, Item> cut(Item a, int pref) {
	Item l, r;
	split(a.root, pref, l.root, r.root);
	l.t = V(a.t.begin(), a.t.begin() + pref);
	r.t = V(a.t.begin() + pref, a.t.end());
	l.check_integrity();
	r.check_integrity();
	return pair(l, r);
}

void test() {
	int n = 100;
	V<Item> v(n);
	int reps = 1000;
	REP (xd, reps) {
		if (rd(0, 2) && ssize(v) > 1) {
			int p = rd(0, ssize(v) - 1);
			swap(v[p], v.back());
			auto a = v.back();
			v.pop_back();
			p = rd(0, ssize(v) - 1);
			swap(v[p], v.back());
			auto b = v.back();
			v.pop_back();
			v.eb(con(a, b));
		}
		else {
			int p = rd(0, ssize(v) - 1);
			if (ssize(v[p].t) == 1)
				continue;
			swap(v[p], v.back());
			auto a = v.back();
			v.pop_back();
			auto [l, r] = cut(a, rd(1, ssize(a.t) - 1));
			v.eb(l);
			v.eb(r);
		}
	}
}
