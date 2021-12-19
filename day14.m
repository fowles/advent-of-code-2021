#import <Foundation/Foundation.h>

#import "day14.h"
#import "parsing.h"

typedef struct {
  size_t pairs[26 * 26];
  int last;
} Polymer;

typedef struct {
  int rule[26 * 26];
} Replacements;

int make_pair_from_chars(char b, char e) { return (b - 'A') * 26 + (e - 'A'); }
int make_pair(int b, int e) { return b * 26 + e; }
int get_first(int i) { return i / 26; }
int get_second(int i) { return i % 26; }

Polymer* GrowTemplate(Polymer* p, Replacements* r) {
  Polymer* np = calloc(1, sizeof(Polymer));
  np->last = p->last;
  for (int i = 0; i < 26*26; ++i) {
    size_t count = p->pairs[i];
    if (count == 0) continue;

    int b = get_first(i);
    int e = get_second(i);
    int m = r->rule[i];
    np->pairs[make_pair(b, m)] += count;
    np->pairs[make_pair(m, e)] += count;
  }
  free(p);
  return np;
}

void Dump(Polymer* p) {
  NSLog(@"Dumping polymer");
  for (int i = 0; i < 26*26; ++i) {
    size_t count = p->pairs[i];
    if (count == 0) continue;
    int b = get_first(i);
    int e = get_second(i);
    NSLog(@"%c%c -> %zu", b + 'A', e + 'A', count);
  }
}

bool Eq(Polymer* lhs, Polymer* rhs) {
  Dump(lhs);
  Dump(rhs);
  return memcmp(lhs, rhs, sizeof(Polymer)) == 0;
}


Polymer* Grow(int steps, Polymer* p, Replacements* r) {
  for (int i = 0; i < steps; ++i) {
    p = GrowTemplate(p, r);
  }
  return p;
}

size_t Count(Polymer* p) {
  size_t counts[26] = {};
  for (int i = 0; i < 26*26; ++i) {
    counts[get_first(i)] += p->pairs[i];
  }
  ++counts[p->last];

  int min_pos = 0;
  int max_pos = 0;
  for (int i = 0; i < 26; ++i) {
    if (counts[i] > counts[max_pos]) max_pos = i;
    if (counts[i] != 0) {
      if (counts[i] < counts[min_pos] || counts[min_pos] == 0)
        min_pos = i;
    }
  }
  return counts[max_pos] - counts[min_pos];
}

Polymer* Parse(NSString* template) {
  Polymer* p = calloc(1, sizeof(Polymer));
  for (size_t i = 0; i < template.length - 1; ++i) {
    int pair = make_pair_from_chars([template characterAtIndex:i],
                                    [template characterAtIndex:i + 1]);
    ++(p->pairs[pair]);
  }
  p->last = [template characterAtIndex:template.length - 1] - 'A';
  return p;
}

size_t day14part1(Polymer* p, Replacements* r) { return Count(Grow(10, p, r)); }
size_t day14part2(Polymer* p, Replacements* r) { return Count(Grow(40, p, r)); }

int day14main(int argc, const char** argv) {
  id parts = split(readFile(@"input/day14.txt"), @"\n\n");
  NSString* template = splitLines(parts[0])[0];
  id rules =
      parseLines(splitLines(parts[1]),
                 [NSRegularExpression regularExpressionWithPattern:@"(..) -> (.)"
                                                           options:0
                                                             error:NULL]);
  Replacements* r = calloc(1, sizeof(Replacements));
  for (id rule in rules) {
    r->rule[make_pair_from_chars([rule[0] characterAtIndex:0],
                                 [rule[0] characterAtIndex:1])] =
        [rule[1] characterAtIndex:0] - 'A';
  }
  Polymer* p1 = Parse(template);
  Polymer* p2 = Parse(template);


  NSLog(@"Part 1: %zu", day14part1(p1, r));
  NSLog(@"Part 2: %zu", day14part2(p2, r));
  return 0;
}
