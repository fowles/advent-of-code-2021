#import <Foundation/Foundation.h>

#import "day17.h"
#import "parsing.h"

typedef struct {
  int x, y;
  int dx, dy;
  int tx_min, tx_max;
  int ty_min, ty_max;
} State;

void Step(State* s) {
  s->x += s->dx;
  s->y += s->dy;
  if (s->dx > 0) --s->dx;
  --s->dy;
}

bool HitTarget(State* s) {
  return s->tx_min <= s->x && s->x <= s->tx_max && //
         s->ty_min <= s->y && s->y <= s->ty_max;
}

bool OvershotTarget(State* s) {
  return s->tx_max < s->x || //
         s->ty_min > s->y;
}

int EvalShot(State* orig, int dx, int dy) {
  int highest = INT_MIN;
  State s = *orig;
  s.dx = dx;
  s.dy = dy;
  while (!OvershotTarget(&s)) {
    Step(&s);
    if (s.y > highest) highest = s.y;
    if (HitTarget(&s)) return highest;
  }
  return INT_MIN;
}

int day17part1(State* s) {
  int highest = INT_MIN;
  for (int i = 0; i < 200; ++i) {
    for (int j = -200; j < 200; ++j) {
      int attempt = EvalShot(s, i, j);
      if (attempt > highest) highest = attempt;
    }
  }

  return highest;
}

int day17part2(State* s) {
  int success = 0;
  for (int i = 0; i < 200; ++i) {
    for (int j = -200; j < 200; ++j) {
      int attempt = EvalShot(s, i, j);
      if (attempt > INT_MIN) ++success;
    }
  }

  return success;
}

int day17main(int argc, const char** argv) {
  // target area: x=143..177, y=-106..-71
  id parsed = parseLines(
      splitLines(readFile(@"input/day17.txt")),
      [NSRegularExpression
          regularExpressionWithPattern:@"x=(\\d+)..(\\d+), y=(-\\d+)..(-\\d+)"
                               options:0
                                 error:NULL])[0];
  State s;
  s.x = s.y = 0;
  s.tx_min = [parsed[0] intValue];
  s.tx_max = [parsed[1] intValue];
  s.ty_min = [parsed[2] intValue];
  s.ty_max = [parsed[3] intValue];
  NSLog(@"Part 1: %d", day17part1(&s));
  NSLog(@"Part 2: %d", day17part2(&s));
  return 0;
}
