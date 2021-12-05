#import <Foundation/Foundation.h>

#import "day5.h"
#import "parsing.h"

@interface Field:NSObject {
   int vents[1000][1000];
}

+ (instancetype)init;
- (void)addLine:(NSArray<NSString*>*)line;
- (void)addDiagonals:(NSArray<NSString*>*)line;
- (int)countDanger;
- (NSString*)area:(int)size;
@end

@implementation Field

+ (instancetype)init {
  Field* f = [Field alloc];
  memset(f->vents, 0, sizeof(int)*1000*1000);
  return f;
}

- (NSString*)area:(int)size {
  id d = [NSString stringWithFormat:@"\n<%@:%p>\n", [self className], self];
  for (int j = 0; j < size; ++j) {
    for (int i = 0; i < size; ++i) {
      d = [d stringByAppendingFormat:@"%1d", self->vents[i][j]];
    }
    d = [d stringByAppendingFormat:@"\n"];
  }
  return d;
}

- (void)addLine:(NSArray<NSString*>*)line {
  int x1 = [line[0] intValue];
  int y1 = [line[1] intValue];
  int x2 = [line[2] intValue];
  int y2 = [line[3] intValue];
  if (x1 == x2) {
    int dy = y1 < y2 ? 1 : -1;
    for (; y1 != y2; y1 += dy) {
      ++self->vents[x1][y1];
    }
    ++self->vents[x1][y1];
  } else if (y1 == y2) {
    int dx = x1 < x2 ? 1 : -1;
    for (; x1 != x2; x1 += dx) {
      ++self->vents[x1][y1];
    }
    ++self->vents[x1][y1];
  }
}

- (void)addDiagonals:(NSArray<NSString*>*)line {
  int x1 = [line[0] intValue];
  int y1 = [line[1] intValue];
  int x2 = [line[2] intValue];
  int y2 = [line[3] intValue];
  if (x1 != x2 && y1 != y2) {
    int dx = x1 < x2 ? 1 : -1;
    int dy = y1 < y2 ? 1 : -1;
    for (; x1 != x2; x1 += dx, y1 += dy) {
      ++self->vents[x1][y1];
    }
    ++self->vents[x1][y1];
  }
}

- (int)countDanger {
  int d = 0;
  for (int i = 0; i < 1000; ++i) {
    for (int j = 0; j < 1000; ++j) {
      if (self->vents[i][j] > 1) ++d;
    }
  }
  return d;
}
@end

NSInteger day5part1(Field* f) {
  return 0;
}

int day5main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day5.txt"));
  id parsed = parseLines(
      lines, [NSRegularExpression regularExpressionWithPattern:@"(\\d+)"
                                                       options:0
                                                         error:NULL]);
  Field* f = [Field init];
  for (id p in parsed) {
    [f addLine: p];
  }
  NSLog(@"Part 1: %d", [f countDanger]);
  for (id p in parsed) {
    [f addDiagonals: p];
  }
  NSLog(@"Part 2: %d", [f countDanger]);
  return 0;
}
