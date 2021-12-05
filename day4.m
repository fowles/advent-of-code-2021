#import <Foundation/Foundation.h>

#import "day4.h"
#import "parsing.h"

@interface Bingo:NSObject {
   int slots[5][5];
   bool marked[5][5];
}

+ (instancetype)init:(NSArray<NSString*>*)card;
- (bool)markValue:(NSInteger)v;
- (bool)markField:(int)x :(int)y;
- (NSInteger)unmarkedSum;
@end

@implementation Bingo

+ (instancetype)init:(NSArray<NSString*>*)card {
  if (card.count != 25) {
    [NSException raise:@"Parse error"
                format:@"Bingo card does not have 25 items:\n%@", card];
  }

  Bingo* b = [Bingo alloc];
  NSEnumerator* it = [card objectEnumerator];
  for (int i = 0; i < 5; ++i) {
    for (int j = 0; j < 5; ++j) {
      b->slots[i][j] = [[it nextObject] intValue];
      b->marked[i][j] = false;
    }
  }
  return b;
}

- (NSString*)description {
  id d = [NSString stringWithFormat:@"\n<%@:%p>\n", [self className], self];
  for (int i = 0; i < 5; ++i) {
    d = [d stringByAppendingFormat:@"%2d %2d %2d %2d %2d\n", self->slots[0][i],
                                   self->slots[1][i], self->slots[2][i],
                                   self->slots[3][i], self->slots[4][i]];
  }
  return d;
}

- (bool)markField:(int)x :(int)y {
  self->marked[x][y] = true;

  bool h = true;
  bool v = true;
  for (int i = 0; i < 5; ++i) {
    if (!self->marked[x][i]) {
      h = false;
    }
    if (!self->marked[i][y]) {
      v = false;
    }
  }
  return h || v;
}

- (bool)markValue:(NSInteger)v {
  for (int i = 0; i < 5; ++i) {
    for (int j = 0; j < 5; ++j) {
      if (self->slots[i][j] == v) {
        return [self markField: i :j];
      }
    }
  }
  return false;
}

-(NSInteger) unmarkedSum {
  NSInteger sum = 0;
  for (int i = 0; i < 5; ++i) {
    for (int j = 0; j < 5; ++j) {
      if (!self->marked[i][j]) sum += self->slots[i][j];
    }
  }
  return sum;
}

@end

NSInteger day4part1(NSArray<NSString*>* draws, NSArray<Bingo*>* cards) {
  for (id draw in draws) {
    NSInteger call = [draw integerValue];
    for (Bingo* b in cards) {
      if ([b markValue: call]) {
        return call * [b unmarkedSum];
      }
    }
  }
  return 0;
}

int day4main(int argc, const char** argv) {
  id lines = split(readFile(@"input/day4.txt"), @"\n\n");
  id parsed = parseLines(
      lines, [NSRegularExpression regularExpressionWithPattern:@"(\\d+)"
                                                       options:0
                                                         error:NULL]);
  NSArray<NSString*>* draws = parsed[0];
  [parsed removeObjectAtIndex:0];
  id cards = parseObjects(parsed, ^(NSArray<NSString*>* v) {
    return [Bingo init:v];
  });

  NSLog(@"Part 1: %ld", day4part1(draws, cards));
  return 0;
}
