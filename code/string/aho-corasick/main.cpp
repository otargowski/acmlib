/*
 * Opis: O(|s|\alpha),
 * 	Konstruktor tworzy sam korzeń w \texttt{node[0]},
 * 	\texttt{add(s)} dodaje słowo,
 * 	\texttt{convert()} zamienia nieodwracalnie trie w automat Aho-Corasick,
 * 	\texttt{link(x)} zwraca suffix link,
 * 	\texttt{go(x, c)} zwraca następnik x przez literę c,
 * 	najpierw dodajemy słowa, potem robimy convert(), a na koniec używamy $go$ i $link$.
 */
constexpr int alpha = 26;
struct AhoCorasick {
	struct Node {
		array<int, alpha> next, go;
		int p, pch, link = -1;
		bool is_word_end = false;
		Node(int _p = -1, int ch = -1) : p(_p), pch(ch) {
			fill(all(next), -1);
			fill(all(go), -1);
		}
	};
	V<Node> node;
	bool converted = false;
	AhoCorasick() : node(1) {}
	void add(C V<int> &s) {
		assert(!converted);
		int v = 0;
		for (int c : s) {
			if (node[v].next[c] == -1) {
				node[v].next[c] = ssize(node);
				node.eb(v, c);
			}
			v = node[v].next[c];
		}
		node[v].is_word_end = true;
	}
	int link(int v) {
		assert(converted);
		return node[v].link;
	}
	int go(int v, int c) {
		assert(converted);
		return node[v].go[c];
	}
	void convert() {
		assert(!converted);
		converted = true;
		deque<int> que = {0};
		while (not que.empty()) {
			int v = que.front();
			que.pop_front();
			if (v == 0 or node[v].p == 0)
				node[v].link = 0;
			else
				node[v].link = go(link(node[v].p), node[v].pch);
			REP (c, alpha) {
				if (node[v].next[c] != -1) {
					node[v].go[c] = node[v].next[c];
					que.eb(node[v].next[c]);
				}
				else
					node[v].go[c] = v == 0 ? 0 : go(link(v), c);
			}
		}
	}
};
