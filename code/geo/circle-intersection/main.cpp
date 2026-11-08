/*
 * Opis: Przecięcia okręgu oraz prostej $ax+by+c=0$ oraz przecięcia okręgu oraz okręgu.
 *   Gdy \texttt{ssize(circle\_circle(...)) == 3} to jest nieskończenie wiele rozwiązań.
 */
#include "../point/main.cpp"
// BEGIN HASH
V<P> circle_line(D r, D a, D b, D c) {
  P p = P(a, b);
  D len = norm(p);
  P p0 = -p * c / len;
  D d = r * r - c * c / len;
  if(sign(d) < 0)
    return {};
  if(sign(d) == 0)
    return {p0};
  p *= sqrt(d / len);
  return {
    p0 + p * P(0, 1),
    p0 - p * P(0, 1)
  };
}
V<P> circle_line(P p, D r, D a, D b, D c) {
  auto vec = circle_line(r, a, b, c + dot(p, P(a, b)));
  for (P &pt : vec)
    pt += p;
  return vec;
} // END HASH
// BEGIN HASH
V<P> circle_circle(P p1, D r1, P p2, D r2) {
  if(equal(p1, p2)) {
    if(equal(r1, r2))
      return V(3, p1 + P(r1, 0)); // inf points
    else
      return {};
  }
  p2 -= p1;
  auto vec = circle_line(r1, -2 * p2.x(), -2 * p2.y(),
      norm(p2) + r1 * r1 - r2 * r2);
  for(P &pt : vec)
    pt += p1;
  return vec;
} // END HASH
