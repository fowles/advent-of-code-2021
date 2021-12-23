#import <Foundation/Foundation.h>

#import "day22.h"
#import "parsing.h"

typedef struct {
  int low;
  int high;
} Region;

Region Intersect(Region l, Region r) {
  Region m = {INT_MAX, INT_MIN};
  if (l.high < r.low) return m;
  if (r.high < l.low) return m;
  m.low  = l.low  < r.low  ? r.low  : l.low;
  m.high = l.high < r.high ? l.high : r.high;
  return m;
}

@interface Cuboid:NSObject {
  @public Region x;
  @public Region y;
  @public Region z;
  @public bool on;
  NSMutableArray<Cuboid*>* holes;
}

+ (instancetype)init;
+ (instancetype)parse:(NSString*)s;
- (void)intersect:(Cuboid*)rhs;
- (size_t)count;
@end

@implementation Cuboid
+ (instancetype)init {
  Cuboid* c = [Cuboid alloc];
  c->holes = [NSMutableArray arrayWithCapacity:10];
  return c;
}

+ (instancetype)parse:(NSString*)line {
  Cuboid* c = [Cuboid init];
  id parsed = parseLine(
      line,
      [NSRegularExpression
          regularExpressionWithPattern:
              @"x=(-?\\d+)..(-?\\d+),y=(-?\\d+)..(-?\\d+),z=(-?\\d+)..(-?\\d+)"
                               options:0
                                 error:NULL]);
  c->x.low = [parsed[0] intValue];
  c->x.high = [parsed[1] intValue];
  c->y.low = [parsed[2] intValue];
  c->y.high = [parsed[3] intValue];
  c->z.low = [parsed[4] intValue];
  c->z.high = [parsed[5] intValue];
  if (c->x.low > c->x.high) SWAP(int, c->x.low, c->x.high);
  if (c->y.low > c->y.high) SWAP(int, c->y.low, c->y.high);
  if (c->z.low > c->z.high) SWAP(int, c->z.low, c->z.high);
  c->on = [line characterAtIndex:1] == 'n';
  return c;
}

- (void)intersect:(Cuboid*)rhs {
  Cuboid* lhs = self;
  Region rx = Intersect(lhs->x, rhs->x);
  Region ry = Intersect(lhs->y, rhs->y);
  Region rz = Intersect(lhs->z, rhs->z);
  if (rx.low == INT_MAX || ry.low == INT_MAX || rz.low == INT_MAX) return;

  Cuboid* c = [Cuboid init];
  c->x.low = rx.low;
  c->x.high = rx.high;
  c->y.low = ry.low;
  c->y.high = ry.high;
  c->z.low = rz.low;
  c->z.high = rz.high;
  c->on = false;
  for (Cuboid* h in holes) {
    [h intersect: c];
  }
  [holes addObject:c];
}

- (size_t)count {
  size_t res = 
    (size_t)(x.high - x.low + 1)*
    (size_t)(y.high - y.low + 1)*
    (size_t)(z.high - z.low + 1);
  for (Cuboid* h in holes) {
    res -= h.count;
  }
  return res;
};

- (NSString*)description {
  return [NSString
      stringWithFormat:@"%s x=%d..%d,y=%d..%d,z=%d..%d",
                       on ? "on" : "off", x.low, x.high, y.low, y.high, z.low, z.high];
}
@end

size_t day22part1(NSArray<Cuboid*>* cubes) {
  bool core[101][101][101];
  memset(core, 0, sizeof(core));
  for (int q = 0; q < 20; ++q) {
    Cuboid* c = cubes[q];
    for (int i = c->x.low; i <= c->x.high; ++i) {
      for (int j = c->y.low; j <= c->y.high; ++j) {
        for (int k = c->z.low; k <= c->z.high; ++k) {
          core[i + 50][j + 50][k + 50] = c->on;
        }
      }
    }
  }

  size_t set = 0;
  for (int i = 0; i < 101; ++i) {
    for (int j = 0; j < 101; ++j) {
      for (int k = 0; k < 101; ++k) {
        set += core[i][j][k];
      }
    }
  }
  return set;
}

size_t day22part2(NSArray<Cuboid*>* cubes) {
  NSMutableArray<Cuboid*>* active =
      [NSMutableArray arrayWithCapacity:cubes.count];
  for (Cuboid* c in cubes) {
    for (Cuboid* a in active) {
      [a intersect:c];
    }
    [active addObject: c];
  }
  size_t set = 0;
  for (Cuboid* c in active) {
    if (c->on) {
      set += [c count];
    }
  }
  return set;
}

int day22main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day22.txt"));
  NSMutableArray<Cuboid*>* cubes = [NSMutableArray arrayWithCapacity:[lines count]];
  for (id l in lines) {
    [cubes addObject:[Cuboid parse:l]];
  }
  NSLog(@"Part 1: %zu", day22part1(cubes));
  NSLog(@"Part 2: %zu", day22part2(cubes));
  return 0;
}
