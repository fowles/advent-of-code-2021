#import <Foundation/Foundation.h>

#import "day21.h"
#import "parsing.h"

@interface Game : NSObject <NSCopying> {
  @public int space[2];
  @public int score[2];
  @public int turn;
};


+ (instancetype)init;
- (Game*)copy;
- (Game*)copyWithZone:(NSZone*)zone;
- (int)Advance:(int) roll;
@end

@implementation Game
+ (instancetype)init {
  Game* g = [Game alloc];
  g->space[0] = 8;
  g->space[1] = 2;
  return g;
}

- (Game*)copy {
  Game* g = [Game alloc];
  g->space[0] = self->space[0];
  g->space[1] = self->space[1];
  g->score[0] = self->score[0];
  g->score[1] = self->score[1];
  g->turn = self->turn;
  return g;
}

- (Game*)copyWithZone:(NSZone*)zone {
  return [self copy];
}

- (BOOL)isEqual:(id)object {
  if ([object isKindOfClass:[self class]]) {
    Game* o = object;
    bool b = o->space[0] == self->space[0] && //
             o->space[1] == self->space[1] && //
             o->score[0] == self->score[0] && //
             o->score[1] == self->score[1] && //
             o->turn == self->turn;
    return b;
  }

  return NO;
}

- (NSUInteger)hash {
  NSUInteger result = 1;
  NSUInteger prime = 31;
  result = prime * result + self->space[0];
  result = prime * result + self->space[1];
  result = prime * result + self->score[0];
  result = prime * result + self->score[1];
  result = prime * result + self->turn;
  return result;
}

- (NSString*)description {
  return [NSString stringWithFormat:@"%d@%d: %d vs %d@%d: %d on %d", 0,
                                    self->space[0], self->score[0],    //
                                    1, self->space[1], self->score[1], //
                                    self->turn];
}

- (int) Advance:(int)spaces {
  self->space[self->turn] += spaces;
  self->space[self->turn] %= 10;
  self->score[self->turn] += self->space[self->turn] + 1;
  self->turn = !self->turn;
  return self->score[!self->turn];
}
@end

int roll(int* die, int* count) {
  int res = 0;
  ++*count;
  res += ++*die;
  *die %= 100;
  ++*count;
  res += ++*die;
  *die %= 100;
  ++*count;
  res += ++*die;
  *die %= 100;
  return res;
}

int day21part21() {
  Game* g = [Game init];
  int die = 0;
  int roll_count = 0;
  while (true) {
    int r = roll(&die, &roll_count);
    if ([g Advance: r] >= 1000) break;
  }
  return g->score[g->turn] * roll_count;
}

size_t day21part2() {
  Game* g = [Game init];
  NSMutableDictionary<Game*, NSNumber*>* cur =
      [NSMutableDictionary dictionaryWithCapacity:512];
  NSMutableDictionary<Game*, NSNumber*>* next =
      [NSMutableDictionary dictionaryWithCapacity:512];
  cur[g] = @1;
  size_t wins[2] = {};
  while (cur.count > 0) {
    for (Game* g in cur) {
      size_t v = [cur[g] unsignedLongLongValue];
      for (int i = 1; i <= 3; ++i) {
        for (int j = 1; j <= 3; ++j) {
          for (int k = 1; k <= 3; ++k) {
            Game* n = [g copy];
            if ([n Advance:i+j+k] >= 21) {
              wins[!n->turn] += v;
            } else {
              next[n] = @(v + [next[n] unsignedLongLongValue]);
            }
          }
        }
      }
    }
    id t = cur;
    cur = next;
    next = t;
    [next removeAllObjects];
  }
  return wins[0] > wins[1] ? wins[0] : wins[1];
}

int day21main(int argc, const char** argv) {
// Player 1 starting position: 9
// Player 2 starting position: 3

  NSLog(@"Part 1: %d", day21part21());
  NSLog(@"Part 2: %zu", day21part2());
  return 0;
}
