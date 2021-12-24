#import <Foundation/Foundation.h>

#import "day23.h"
#import "parsing.h"
#import "MCBinaryHeap.h"

char DesiredLetter(int i) {
  return 'A' + (i-3)/2;
}

int DesiredHome(char c) {
  return 3 + (c - 'A')*2;
}

@interface Map:NSObject {
  // #############
  // #...........#
  // ###C#A#D#D###
  //   #B#A#B#C#
  //   #########
  @public char grid[13][5];
  @public int cost;
  Map* parent;
}


- (instancetype)copy;
- (instancetype)moveX:(int)ox Y:(int)oy toX:(int)nx Y:(int)ny;
- (NSString*)description;
- (int)cost;
- (NSComparisonResult)compare:(id)other;
- (bool)IsDone;
- (void)Adjacent:(void (^)(const Map* map))block;
- (void)DumpPath;
@end

@implementation Map
- (instancetype)copy {
  Map* p = [Map alloc];
  memcpy(p->grid, self->grid, sizeof(p->grid));
  p->cost = self->cost;
  return p;
}

- (instancetype)moveX:(int)ox Y:(int)oy toX:(int)nx Y:(int)ny {
  Map* p = [self copy];
  p->parent = self;
  char v = grid[ox][oy];
  p->grid[ox][oy] = '.';
  p->grid[nx][ny] = v;
  int step_cost = ABS(ox - nx) + ABS(oy - ny);
  switch (v) {
    case 'A': step_cost *= 1; break;
    case 'B': step_cost *= 10; break;
    case 'C': step_cost *= 100; break;
    case 'D': step_cost *= 1000; break;
  }
  p->cost += step_cost;
  return p;
}

- (NSString*)description {
  NSMutableString* res = [NSMutableString stringWithFormat:@"Map: %d\n", cost];
  for (int j = 0; j < 5; ++j) {
    for (int i = 0; i < 13; ++i) {
      [res appendFormat:@"%c", grid[i][j]];
    }
    [res appendFormat:@"\n"];
  }
  return res;
}

- (int) cost { return cost; }

- (NSComparisonResult)compare:(id)other {
  size_t lhs = [self cost];
  size_t rhs = [other cost];
  if (lhs < rhs) return NSOrderedAscending;
  if (lhs > rhs) return NSOrderedDescending;
  return NSOrderedSame;
}

- (BOOL)isEqual:(id)object {
  if ([object isKindOfClass:[self class]]) {
    Map* o = object;
    return self->cost == o->cost &&
           memcmp(self->grid, o->grid, sizeof(grid)) == 0;
  }

  return NO;
}

- (NSUInteger)hash {
  NSUInteger result = 1;
  NSUInteger prime = 31;
  for (int j = 0; j < 5; ++j) {
    for (int i = 0; i < 13; ++i) {
      result = prime * result + grid[i][j];
    }
  }
  result = prime * result + cost;
  return result;
}

- (bool)IsDone {
  return 
    grid[3][2] == 'A' && grid[3][3] == 'A' &&
    grid[5][2] == 'B' && grid[5][3] == 'B' &&
    grid[7][2] == 'C' && grid[7][3] == 'C' &&
    grid[9][2] == 'D' && grid[9][3] == 'D';
}

- (void)Adjacent:(void (^)(const Map* map))block {
  // Move from destination 1
  for (int i = 3; i < 10; i += 2) {
    if (DesiredLetter(i) == grid[i][2] && DesiredLetter(i) == grid[i][3])
      continue;

    char v = grid[i][2];
    if (v == '.') continue;
    for (int ni = i; ni > 0; --ni) {
      if (grid[ni][1] != '.') break;
      if (ni == 3 || ni == 5 || ni == 7 || ni == 9) continue;
      block([self moveX:i Y:2 toX:ni Y:1]);
    }
    for (int ni = i; ni < 13; ++ni) {
      if (grid[ni][1] != '.') break;
      if (ni == 3 || ni == 5 || ni == 7 || ni == 9) continue;
      block([self moveX:i Y:2 toX:ni Y:1]);
    }
  }

  // Move from destination 2
  for (int i = 3; i < 10; i += 2) {
    char v = grid[i][3];
    if (v == '.') continue;
    if (DesiredLetter(i) == v) continue;

    if (grid[i][2] != '.') continue;
    for (int ni = i; ni > 0; --ni) {
      if (grid[ni][1] != '.') break;
      if (ni == 3 || ni == 5 || ni == 7 || ni == 9) continue;
      block([self moveX:i Y:3 toX:ni Y:1]);
    }
    for (int ni = i; ni < 13; ++ni) {
      if (grid[ni][1] != '.') break;
      if (ni == 3 || ni == 5 || ni == 7 || ni == 9) continue;
      block([self moveX:i Y:3 toX:ni Y:1]);
    }
  }

  // Move home from corridor
  for (int i = 1; i < 12; ++i) {
    char v = grid[i][1];
    if (v == '.') continue;
    int di = DesiredHome(v);
    int delta = i < di ? 1 : -1;
    int ti;
    for (ti = i + delta; ti != di; ti += delta) {
      if (grid[ti][1] != '.') break;
    }
    if (ti != di) continue;

    if (grid[ti][2] == '.' && grid[ti][3] == '.') {
      block([self moveX:i Y:1 toX:di Y:3]);
    }
    if (grid[ti][2] == '.' && grid[ti][3] == v) {
      block([self moveX:i Y:1 toX:di Y:2]);
    }
  }
}

- (void)DumpPath {
  Map* m = self;
  while (m != nil) {
    NSLog(@"%@", m);
    m = m->parent;
  }
}
@end

int day23part1(Map* m) {
  id to_expand = [MCBinaryHeap heap];
  NSMutableSet<Map*>* seen = [NSMutableSet setWithCapacity: 10000];
  [m Adjacent:^(id next) {
    if ([seen containsObject:next]) return;
    [seen addObject:next];
    [to_expand addObject:next];
  }];
  while ([to_expand count] > 0) {
    id ex = [to_expand popMinimumObject];
    if ([ex IsDone]) {
      return [ex cost];
    }
    [ex Adjacent:^(id next) {
      if ([seen containsObject:next]) {
        return;
      }
      [seen addObject: next];
      [to_expand addObject:next];
    }];
  }
  return -1;
}

int day23part2(Map* m) {
  return 0;
}

int day23main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day23.txt"));
  Map* m = [Map alloc];
  for (int j = 0; j < 5; ++j) {
    id line = lines[j];
    for (int i = 0; i < 13; ++i) {
      if (i < [line length]) {
        m->grid[i][j] = [line characterAtIndex:i];
      } else {
        m->grid[i][j] = ' ';
      }
    }
  }
  NSLog(@"Part 1: %d", day23part1(m));
  NSLog(@"Part 2: %d", day23part2(m));
  return 0;
}
