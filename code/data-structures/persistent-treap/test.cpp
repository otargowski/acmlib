#include "../../utils/testing/test-wrapper.cpp"
#include "main.cpp"

vi get_all_vals(Treap::pNode n) {
	vi ret;
	if(n->l)
		ret = get_all_vals(n->l);
	ret.eb(n->val);
	if(n->r)
		for(int val : get_all_vals(n->r))
			ret.eb(val);
	return ret;
}

void test() {
	int n = rd(1, 100);

	Treap treap;
	V<Treap::pNode> roots = {nullptr};
	V<vi> values = {{}};

	while(n --> 0) {
		if(ssize(roots) > 1 and rd(0, 3) == 0) {
			roots.pop_back();
			values.pop_back();
			treap.root = roots.back();
		}
		auto v = values.back();
		int i = rd(0, ssize(v));
		int val = rd(-10, 10);
		v.insert(v.begin() + i, val);
		values.eb(v);
		treap.insert(i, val);
		roots.eb(treap.root);
		assert(v == get_all_vals(treap.root));
	}
}
