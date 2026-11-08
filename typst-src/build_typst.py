import os, sys, glob, re, subprocess, json

COMMENT_TYPES = [
    ('/*', '*/'),
    ("'''", "'''"),
    ('"""', '"""'),
]

def find_start_comment(source, start=None):
    first = (-1, -1, None)
    for s, e in COMMENT_TYPES:
        i = source.find(s, start)
        if i != -1 and (i < first[0] or first[0] == -1):
            first = (i, i + len(s), e)
    return first

def get_hash(txt):
    p = subprocess.Popen(['sh', 'pdf/kactl-include/hash.sh'], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    hsh, _ = p.communicate(bytes(txt, 'utf-8'))
    return hsh.split(None, 1)[0].decode('utf-8')

def hash_fragments_or_whole(txt):
    txt = txt.split('\n')

    def hash_fragment(l, r):
        assert txt[l] == '// BEGIN HASH'
        assert txt[r].endswith('// END HASH')
        hsh = get_hash('\n'.join(txt[l + 1 : r + 1]))
        txt[l] += ' ' + hsh

    for r in range(len(txt)):
        if txt[r].endswith('// END HASH'):
            for l in range(r - 1, -1, -1):
                if txt[l] == '// BEGIN HASH':
                    hash_fragment(l, r)
                    break
    txt = '\n'.join(txt)
    return get_hash(txt), txt

def parse_include(line):
    line = line.strip()
    if line.startswith("#include"):
        return line[8:].strip()
    return None

TYPST_BUILTINS = {
    'sin', 'cos', 'tan', 'cot', 'sec', 'csc', 'arcsin', 'arccos', 'arctan',
    'sinh', 'cosh', 'tanh', 'coth', 'ln', 'log', 'exp', 'det', 'gcd', 'lcm',
    'min', 'max', 'inf', 'lim', 'mod', 'dim', 'ker', 'hom', 'arg', 'deg',
    'sum', 'prod', 'sqrt', 'root', 'binom', 'floor', 'ceil', 'abs', 'round',
    'norm', 'vec', 'mat', 'cases', 'cal', 'bb', 'frak', 'mono', 'bold', 'italic',
    'cancel', 'overbrace', 'underbrace', 'overline', 'underline', 'tilde',
    'hat', 'dot', 'ddot', 'acute', 'grave', 'check', 'breve', 'circle', 'arrow',
    'pi', 'alpha', 'beta', 'gamma', 'delta', 'epsilon', 'zeta', 'eta', 'theta',
    'iota', 'kappa', 'lambda', 'mu', 'nu', 'xi', 'omicron', 'rho', 'sigma',
    'tau', 'upsilon', 'phi', 'chi', 'psi', 'omega',
    'Gamma', 'Delta', 'Theta', 'Lambda', 'Xi', 'Pi', 'Sigma', 'Upsilon', 'Phi', 'Psi', 'Omega',
    'dots', 'divides', 'bot', 'top', 'subset', 'in', 'subset.eq', 'cancel', 'oo', 'integral'
}

def to_typst_math(m):
    m = m.replace(r'\max', 'max ')
    m = m.replace(r'\min', 'min ')
    m = m.replace(r'\int', 'integral ')
    m = m.replace(r'\ln', 'ln ')
    m = m.replace(r'\exp', 'exp ')
    m = m.replace(r'\log', 'log ')
    m = m.replace(r'\alpha', 'alpha ')
    m = m.replace(r'\pi', 'pi ')
    m = m.replace(r'\cdot', 'dot ')
    m = m.replace(r'\dots', 'dots ')
    m = m.replace(r'\ldots', 'dots ')
    m = m.replace(r'\sum', 'sum ')
    m = m.replace(r'\inf', 'oo ')
    m = m.replace(r'\subseteq', 'subset.eq ')
    m = m.replace(r'\perp', 'bot ')
    m = m.replace(r'\nmid', 'cancel(divides) ')
    m = m.replace(r'\pmod', 'mod ')
    m = m.replace(r'\bmod', 'mod ')
    m = m.replace(r'\;', ' ')
    m = m.replace(r'\_', '_')
    m = m.replace(r'\le', '<=')
    m = m.replace(r'\leq', '<=')
    m = m.replace(r'\ge', '>=')
    m = m.replace(r'\geq', '>=')
    m = m.replace(r'\neq', '!=')
    m = m.replace(r'\equiv', 'equiv')
    m = m.replace(r'\to', '->')
    m = m.replace(r'\sim', 'tilde')
    m = m.replace(r'\left', '')
    m = m.replace(r'\right', '')
    m = m.replace(r'\lfloor', 'floor(')
    m = m.replace(r'\rfloor', ')')
    m = m.replace(r'\lceil', 'ceil(')
    m = m.replace(r'\rceil', ')')
    m = re.sub(r'\\frac\{([^}]+)\}\{([^}]+)\}', r'(\1)/(\2)', m)
    m = re.sub(r'\\sqrt\{([^}]+)\}', r'sqrt(\1)', m)
    m = re.sub(r'\\text\{([^}]+)\}', r'"\1"', m)
    m = re.sub(r'\\texttt\{([^}]+)\}', r'`\1`', m)
    m = re.sub(r'\{([^{}]+)\s*\\choose\s*([^{}]+)\}', r'binom(\1, \2)', m)
    m = m.replace('ax', 'a x')
    m = m.replace('by', 'b y')
    m = m.replace('cx', 'c x')
    m = m.replace('qb', 'q b')
    m = m.replace('Ax', 'A x')
    m = m.replace('1e9', '10^9')
    m = m.replace('1e8', '10^8')
    m = m.replace('V E', 'V dot E')
    m = m.replace('n0', 'n_0')
    m = m.replace('n1', 'n_1')
    m = m.replace('k/(k+1)', '(k/(k+1))')
    m = m.replace(r'\{', '{')
    m = m.replace(r'\}', '}')
    
    parts = m.split('"')
    for i in range(0, len(parts), 2):
        def quote_ident(match):
            w = match.group(0)
            if len(w) == 1 or w in TYPST_BUILTINS:
                return w
            return f'"{w}"'
        parts[i] = re.sub(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b', quote_ident, parts[i])
    
    return '"'.join(parts)

def extract_bigo(text):
    start = text.find("O(")
    if start >= 0:
        bracketcount = 1
        end = start + 2
        while end < len(text) and bracketcount > 0:
            if text[end] == '(':
                bracketcount += 1
            elif text[end] == ')':
                bracketcount -= 1
            end += 1
        if bracketcount == 0:
            inner = text[start+2:end-1]
            return text[:start] + "$cal(O)(" + to_typst_math(inner) + ")$" + extract_bigo(text[end:])
    return text

def clean_opis(opis):
    if not opis:
        return ""
    lines = []
    for l in opis.split('\n'):
        l = l.strip()
        if l.startswith('*'):
            l = l[1:].strip()
        if l:
            lines.append(l)
    text = " ".join(lines)
    
    def tt_repl(m):
        inner = m.group(1).replace(r'\^{}', '^').replace(r'\_', '_').replace(r'\{', '{').replace(r'\}', '}')
        return f"`{inner}`"
    text = re.sub(r'\\texttt\{([^}]+(?:\{[^}]*\})*[^}]*)\}', tt_repl, text)
    
    def math_repl(m):
        return "$" + to_typst_math(m.group(1)) + "$"
    text = re.sub(r'\$([^$]+)\$', math_repl, text)
    text = extract_bigo(text)
    text = text.replace(r'\_', '_')
    text = text.replace(r'\{', '{').replace(r'\}', '}')
    return text

def parse_code_file(path, is_raw=False, raw_lang=None):
    with open(path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    foldername = os.path.basename(os.path.dirname(path)) if os.path.basename(path) == 'main.cpp' else os.path.basename(path)
    
    if is_raw:
        source = "".join(lines).strip()
        lang = raw_lang or ('cpp' if path.endswith('.cpp') else ('sh' if path.endswith('.sh') else 'raw'))
        hsh = get_hash(source) if path.endswith('.cpp') else None
        return {
            'name': foldername,
            'path': path,
            'hash': hsh,
            'includes': [],
            'opis': '',
            'lang': lang,
            'code': source
        }
        
    includelist = []
    nlines = []
    for line in lines:
        if 'exclude-line' in line:
            continue
        if 'include-line' in line:
            line = line.replace('// ', '', 1)
        had_comment = "///" in line
        keep_include = 'keep-include' in line or "<bits/stdc++.h>" in line
        line = line.split("///")[0].rstrip()
        if line == "#pragma once":
            continue
        if had_comment and not line:
            continue
        if line == '':
            continue
        include = parse_include(line)
        if include is not None and not keep_include:
            include = include.lstrip('"../').rstrip('.cpp"')
            if include.endswith('/main'):
                include = include.rstrip('/main')
            includelist.append(include)
            continue
        nlines.append(line)

    source = '\n'.join(nlines)
    nsource = ''
    start, start2, end_str = find_start_comment(source)
    end = 0
    commands = {}
    while start >= 0:
        nsource = nsource.rstrip() + source[end:start]
        end = source.find(end_str, start2)
        if end < start:
            break
        comment = source[start2:end].strip()
        end += len(end_str)
        start, start2, end_str = find_start_comment(source, end)

        commentlines = comment.split('\n')
        command = None
        value = ""
        for cline in commentlines:
            allow_command = False
            cline = cline.strip()
            if cline.startswith('*'):
                cline = cline[1:].strip()
                allow_command = True
            ind = cline.find(':')
            if allow_command and ind != -1 and ' ' not in cline[:ind]:
                if command:
                    commands[command] = value.lstrip()
                command = cline[:ind]
                value = cline[ind+1:].strip()
            else:
                value = value + '\n' + cline
        if command:
            commands[command] = value.lstrip()

    if end >= 0:
        nsource = nsource.rstrip() + source[end:]
    nsource = nsource.strip()

    hsh, nsource = hash_fragments_or_whole(nsource)
    lang = 'cpp' if path.endswith('.cpp') else ('py' if path.endswith('.py') else 'raw')
    
    return {
        'name': foldername,
        'path': path,
        'hash': hsh,
        'includes': includelist,
        'opis': clean_opis(commands.get('Opis', '')),
        'lang': lang,
        'code': nsource
    }

chapters = [
    ('headers', 'Headers', [
        ('raw', 'raw', 'code/headers/.vimrc'),
        ('raw', 'sh', 'code/headers/.bashrc'),
        ('raw', 'cpp', 'code/headers/main.cpp'),
        ('raw', 'cpp', 'code/headers/gen.cpp'),
        ('raw', 'cpp', 'code/headers/freopen.cpp'),
        ('raw', 'cpp', 'code/headers/memoryusage.cpp'),
        ('raw', 'sh', 'code/headers/memoryusage.sh'),
    ]),
    ('wzorki', 'Wzorki', 'special:wzorki'),
    ('math', 'Matma', [
        ('import', 'code/math/berlekamp-massey/main.cpp'),
        ('import', 'code/math/bignum/main.cpp'),
        ('import', 'code/math/binsearch-stern-brocot/main.cpp'),
        ('import', 'code/math/crt/main.cpp'),
        ('import', 'code/math/determinant/main.cpp'),
        ('import', 'code/math/discrete-log/main.cpp'),
        ('import', 'code/math/discrete-root/main.cpp'),
        ('import', 'code/math/extended-gcd/main.cpp'),
        ('import', 'code/math/fft-mod/main.cpp'),
        ('import', 'code/math/fft/main.cpp'),
        ('import', 'code/math/floor-sum/main.cpp'),
        ('import', 'code/math/fwht/main.cpp'),
        ('import', 'code/math/gauss/main.cpp'),
        ('import', 'code/math/integral/main.cpp'),
        ('import', 'code/math/lagrange-consecutive/main.cpp'),
        ('import', 'code/math/matrix-header/main.cpp'),
        ('import', 'code/math/matrix-inverse/main.cpp'),
        ('import', 'code/math/miller-rabin/main.cpp'),
        ('import', 'code/math/multiplicative/main.cpp'),
        ('import', 'code/math/ntt/main.cpp'),
        ('import', 'code/math/pell/main.cpp'),
        ('import', 'code/math/pi/main.cpp'),
        ('import', 'code/math/polynomial/main.cpp'),
        ('import', 'code/math/power-sum/main.cpp'),
        ('import', 'code/math/primitive-root/main.cpp'),
        ('import', 'code/math/pythagorean-triples/main.cpp'),
        ('import', 'code/math/rho-pollard/main.cpp'),
        ('import', 'code/math/same-div/main.cpp'),
        ('import', 'code/math/sieve/main.cpp'),
        ('import', 'code/math/simple-modulo/main.cpp'),
        ('import', 'code/math/simplex/main.cpp'),
        ('import', 'code/math/tonelli-shanks/main.cpp'),
        ('import', 'code/math/xor-base/main.cpp'),
    ]),
    ('data-structures', 'Struktury danych', [
        ('import', 'code/data-structures/associative-queue/main.cpp'),
        ('import', 'code/data-structures/fenwick-tree-2d/main.cpp'),
        ('import', 'code/data-structures/fenwick-tree/main.cpp'),
        ('import', 'code/data-structures/find-union/main.cpp'),
        ('import', 'code/data-structures/hash-map/main.cpp'),
        ('import', 'code/data-structures/lazy-segment-tree/main.cpp'),
        ('import', 'code/data-structures/lichao-tree/main.cpp'),
        ('import', 'code/data-structures/line-container/main.cpp'),
        ('import', 'code/data-structures/link-cut/main.cpp'),
        ('import', 'code/data-structures/majorized-set/main.cpp'),
        ('import', 'code/data-structures/ordered-set/main.cpp'),
        ('import', 'code/data-structures/persistent-treap/main.cpp'),
        ('import', 'code/data-structures/range-add/main.cpp'),
        ('import', 'code/data-structures/rmq/main.cpp'),
        ('import', 'code/data-structures/segment-tree/main.cpp'),
        ('import', 'code/data-structures/treap/main.cpp'),
    ]),
    ('graph', 'Grafy', [
        ('import', 'code/graph/2sat/main.cpp'),
        ('import', 'code/graph/biconnected/main.cpp'),
        ('import', 'code/graph/cactus-cycles/main.cpp'),
        ('import', 'code/graph/centro-decomp/main.cpp'),
        ('import', 'code/graph/coloring/main.cpp'),
        ('import', 'code/graph/de-brujin/main.cpp'),
        ('import', 'code/graph/directed-mst/main.cpp'),
        ('import', 'code/graph/dominator-tree/main.cpp'),
        ('import', 'code/graph/dynamic-connectivity/main.cpp'),
        ('import', 'code/graph/eulerian-path/main.cpp'),
        ('import', 'code/graph/hld/main.cpp'),
        ('import', 'code/graph/hld-online-bottom-up/main.cpp'),
        ('import', 'code/graph/jump-ptr/main.cpp'),
        ('import', 'code/graph/max-clique/main.cpp'),
        ('import', 'code/graph/negative-cycle/main.cpp'),
        ('import', 'code/graph/planar-graph-faces/main.cpp'),
        ('import', 'code/graph/planarity-check/main.cpp'),
        ('import', 'code/graph/scc/main.cpp'),
        ('import', 'code/graph/toposort/main.cpp'),
        ('import', 'code/graph/triangles/main.cpp'),
    ]),
    ('flow', 'Flowy i matchingi', [
        ('import', 'code/flow/blossom/main.cpp'),
        ('import', 'code/flow/dinic/main.cpp'),
        ('import', 'code/flow/gomory-hu/main.cpp'),
        ('import', 'code/flow/hopcroft-karp/main.cpp'),
        ('import', 'code/flow/hungarian/main.cpp'),
        ('import', 'code/flow/konig-theorem/main.cpp'),
        ('import', 'code/flow/matching/main.cpp'),
        ('import', 'code/flow/mcmf-dijkstra/main.cpp'),
        ('import', 'code/flow/mcmf-spfa/main.cpp'),
        ('import', 'code/flow/weighted-blossom/main.cpp'),
    ]),
    ('geo', 'Geometria', [
        ('import', 'code/geo/advanced-complex/main.cpp'),
        ('import', 'code/geo/angle-sort/main.cpp'),
        ('import', 'code/geo/angle180-intervals/main.cpp'),
        ('import', 'code/geo/area/main.cpp'),
        ('import', 'code/geo/circle-intersection/main.cpp'),
        ('import', 'code/geo/circle-tangents/main.cpp'),
        ('import', 'code/geo/closest-pair/main.cpp'),
        ('import', 'code/geo/convex-gen/main.cpp'),
        ('import', 'code/geo/convex-hull-online/main.cpp'),
        ('import', 'code/geo/convex-hull/main.cpp'),
        ('import', 'code/geo/delaunay-triangulation/main.cpp'),
        ('import', 'code/geo/furthest-pair/main.cpp'),
        ('import', 'code/geo/geo3d/main.cpp'),
        ('import', 'code/geo/halfplane-intersection/main.cpp'),
        ('import', 'code/geo/intersect-lines/main.cpp'),
        ('import', 'code/geo/is-in-hull/main.cpp'),
        ('import', 'code/geo/line/main.cpp'),
        ('import', 'code/geo/point/main.cpp'),
        ('import', 'code/geo/polygon-gen/main.cpp'),
        ('import', 'code/geo/polygon-print/main.cpp'),
        ('import', 'code/geo/voronoi-diagram/main.cpp'),
    ]),
    ('string', 'Tekstówki', [
        ('import', 'code/string/aho-corasick/main.cpp'),
        ('import', 'code/string/eertree/main.cpp'),
        ('import', 'code/string/hashing/main.cpp'),
        ('import', 'code/string/kmp/main.cpp'),
        ('import', 'code/string/lyndon-min-cyclic-rot/main.cpp'),
        ('import', 'code/string/manacher/main.cpp'),
        ('import', 'code/string/pref/main.cpp'),
        ('import', 'code/string/squares/main.cpp'),
        ('import', 'code/string/suffix-array-interval/main.cpp'),
        ('import', 'code/string/suffix-array-long/main.cpp'),
        ('import', 'code/string/suffix-array-short/main.cpp'),
        ('import', 'code/string/suffix-automaton/main.cpp'),
        ('import', 'code/string/suffix-tree/main.cpp'),
        ('import', 'code/string/wildcard-matching/main.cpp'),
    ]),
    ('optimizations', 'Optymalizacje', [
        ('import', 'code/optimizations/divide-and-conquer-dp/main.cpp'),
        ('import', 'code/optimizations/dp-1d1d/main.cpp'),
        ('import', 'code/optimizations/fio/main.cpp'),
        ('import', 'code/optimizations/knuth/main.cpp'),
        ('import', 'code/optimizations/linear-knapsack/main.cpp'),
        ('import', 'code/optimizations/matroid-intersection/main.cpp'),
        ('import', 'code/optimizations/random/main.cpp'),
        ('import', 'code/optimizations/sos-dp/main.cpp'),
    ]),
    ('utils', 'Utils', [
        ('import', 'code/utils/dzien-probny/main.cpp'),
        ('import', 'code/utils/python/main.py'),
    ]),
]

print("Generating typst-src/content.typ ...")
with open('typst-src/content.typ', 'w', encoding='utf-8') as out:
    out.write('#import "template.typ": my-chapter, code-entry\n\n')
    for ch_id, ch_title, items in chapters:
        out.write(f'#my-chapter("{ch_title}")\n\n')
        if items == 'special:wzorki':
            out.write('#include "wzorki.typ"\n\n')
        else:
            for it in items:
                if it[0] == 'raw':
                    data = parse_code_file(it[2], is_raw=True, raw_lang=it[1])
                else:
                    data = parse_code_file(it[1], is_raw=False)
                
                code_esc = json.dumps(data['code'], ensure_ascii=False)
                name_esc = json.dumps(data['name'])
                hash_esc = json.dumps(data['hash']) if data['hash'] else "none"
                # Typst array of strings: ("a", "b")
                inc_items = ", ".join(json.dumps(x) for x in data['includes'])
                if inc_items:
                    inc_esc = f"({inc_items},)"
                else:
                    inc_esc = "()"
                    
                lang_esc = json.dumps(data['lang'])
                opis_str = data['opis']
                
                out.write(f'#code-entry(\n')
                out.write(f'  name: {name_esc},\n')
                out.write(f'  hash: {hash_esc},\n')
                out.write(f'  includes: {inc_esc},\n')
                if opis_str:
                    out.write(f'  opis: [{opis_str}],\n')
                else:
                    out.write(f'  opis: none,\n')
                out.write(f'  lang: {lang_esc},\n')
                out.write(f'  code: {code_esc},\n')
                out.write(f')\n\n')

print("Finished generating typst-src/content.typ")
