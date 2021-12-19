#import <Foundation/Foundation.h>

#import "day15.h"
#import "parsing.h"
#import "MCBinaryHeap.h"

typedef struct {
  int size;
  int risk[500][500];
} Map;

void Adjacent(const Map* m, NSPoint p, void (^block)(NSPoint p)) {
  if (p.x > 0          )  block((NSPoint){p.x - 1, p.y    });
  if (p.x < m->size - 1) block((NSPoint){p.x + 1, p.y    });
  if (p.y > 0          )  block((NSPoint){p.x    , p.y - 1});
  if (p.y < m->size - 1) block((NSPoint){p.x    , p.y + 1});
}

@interface MapPath:NSObject {
  const Map* map;
  NSMutableArray<NSValue*>* path;
  int risk;
}

+ (instancetype)init:(const Map*)m;
- (instancetype)copy;
- (NSString*)description;
- (NSPoint)curPos;
- (bool)isAtEnd;
- (MapPath*)extendMapPath:(NSValue*)pos;
- (NSComparisonResult)compare:(id)other;
- (size_t)risk;
@end

@implementation MapPath
+ (instancetype)init:(const Map*)m {
  MapPath* p = [MapPath alloc];
  p->map = m;
  p->risk = 0;
  p->path = [NSMutableArray arrayWithCapacity:8];
  [p visit:[NSValue valueWithPoint:(NSPoint){0, 0}]];
  return p;
}

- (instancetype)copy {
  MapPath* p = [MapPath alloc];
  p->map = self->map;
  p->risk = self->risk;
  p->path = [self->path mutableCopy];
  return p;
}

- (NSString*)description {
  return [NSString stringWithFormat:@"%@", self->path];
}

- (NSPoint)curPos {
  return [self->path[self->path.count - 1] pointValue];
}

- (bool)isAtEnd {
  NSPoint p = [self curPos];
  return p.x == self->map->size - 1 && p.y == self->map->size - 1;
}

- (void)visit:(NSValue*) node {
  [self->path addObject: node];
}

- (MapPath*)extendMapPath:(NSValue*)point {
  MapPath* p = [self copy];
  [p->path addObject:point];
  NSPoint pv = [point pointValue];
  p->risk += p->map->risk[(int)pv.x][(int)pv.y];
  return p;
}

- (size_t)risk {
  return self->risk;
}

- (NSComparisonResult)compare:(id)other {
  size_t lhs = [self risk];
  size_t rhs = [other risk];
  if (lhs < rhs) return NSOrderedAscending;
  if (lhs > rhs) return NSOrderedDescending;
  return NSOrderedSame;
}

@end

size_t shortestPath(Map* m) {
  id to_expand = [MCBinaryHeap heap];
  [to_expand addObject:[MapPath init:m]];
  NSMutableSet<NSValue*>* seen = [NSMutableSet setWithCapacity: 10000];
  [seen addObject:[NSValue valueWithPoint:(NSPoint){0, 0}]];

  while ([to_expand count] > 0) {
    id ex = [to_expand popMinimumObject];
    if ([ex isAtEnd]) return [ex risk];
    Adjacent(m, [ex curPos], ^(NSPoint next) {
      id val = [NSValue valueWithPoint:next];
      if ([seen containsObject:val])
        return;
      [seen addObject: val];
      [to_expand addObject:[ex extendMapPath:val]];
    });
  }
  return 0;
}

size_t day15part1(Map* m) {
  return shortestPath(m);
}

size_t day15part2(Map* m) {
  return shortestPath(m);
}

void Print(Map* m) {
  NSLog(@"Map");
  for (int i = 0; i < m->size; ++i) {
    for (int j = 0; j < m->size; ++j) {
      printf("%c", m->risk[i][j] + '0');
    }
    printf("\n");
  }
}

int day15main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day15.txt"));
  Map m;
  m.size = (int)[lines count];
  for (int i = 0; i < m.size; ++i) {
    for (int j = 0; j < m.size; ++j) {
      m.risk[i][j] = [lines[i] characterAtIndex:j] - '0';
    }
  }

  Map b;
  b.size = 5 * m.size;
  for (int i = 0; i < m.size; ++i) {
    for (int j = 0; j < m.size; ++j) {
      b.risk[i][j] = m.risk[i][j];
    }
  }
  for (int s = 1; s < 5; ++s) {
    for (int i = 0; i < m.size; ++i) {
      for (int j = 0; j < m.size; ++j) {
        int dest = m.size*s + i;

        int risk = b.risk[dest - m.size][j] + 1;
        if (risk > 9) risk = 1;
        b.risk[dest][j] = risk;
      }
    }
  }
  for (int s = 1; s < 5; ++s) {
    for (int i = 0; i < b.size; ++i) {
      for (int j = 0; j < m.size; ++j) {
        int dest = m.size*s + j;
        int risk = b.risk[i][dest - m.size] + 1;
        if (risk > 9) risk = 1;
        b.risk[i][dest] = risk;
      }
    }
  }

  NSLog(@"Part 1: %zu", day15part1(&m));
  NSLog(@"Part 2: %zu", day15part2(&b));
  return 0;
}
