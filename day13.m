#import <Foundation/Foundation.h>

#import "day13.h"
#import "parsing.h"

typedef struct {
  int x;
  int y;
  bool* dots;
} Grid;

bool* pos(Grid* g, int x, int y) { return &g->dots[x + y * g->x]; }

void Print(Grid* g) {
  int mx = 0;
  int my = 0;
  for (int j = 0; j < g->y; ++j) {
    for (int i = 0; i < g->x; ++i) {
      if (*pos(g, i, j)) {
        if (mx <= i) mx = i + 1;
        if (my <= j) my = j + 1;
      }
    }
  }

  for (int j = 0; j < my; ++j) {
    for (int i = 0; i < mx; ++i) {
      printf("%c", *pos(g, i, j) ? '#' : '.');
    }
    printf("\n");
  }
}

void FoldX(Grid* g, int line) {
  for (int i = line + 1; i < g->x; ++i) {
    for (int j = 0; j < g->y; ++j) {
      int dx = i - line;
      bool* lhs = pos(g, line - dx, j);
      bool* rhs = pos(g, line + dx, j);
      if (*rhs) {
        *lhs = *rhs;
        *rhs = false;
      }
    }
  }
}

void FoldY(Grid* g, int line) {
  for (int i = 0; i < g->x; ++i) {
    for (int j = line + 1; j < g->y; ++j) {
      int dy = j - line;
      bool* top = pos(g, i, line - dy);
      bool* bottom = pos(g, i, line + dy);
      if (*bottom) {
        *top = *bottom;
        *bottom = false;
      }
    }
  }
}

int day13part1(Grid* g, NSArray<NSArray<NSString*>*>* folds) {
  if ([folds[0][0] isEqualToString: @"x"]) {
    FoldX(g, [folds[0][1] intValue]);
  } else {
    FoldY(g, [folds[0][1] intValue]);
  }
  int res = 0;
  for (int i = 0; i < g->x; ++i) {
    for (int j = 0; j < g->y; ++j) {
      if (*pos(g, i, j)) ++res;
    }
  }
  return res;
}

int day13part2(Grid* g, NSArray<NSArray<NSString*>*>* folds) {
  for (int i = 1; i < folds.count; ++i) {
    if ([folds[i][0] isEqualToString:@"x"]) {
      FoldX(g, [folds[i][1] intValue]);
    } else {
      FoldY(g, [folds[i][1] intValue]);
    }
  }
  Print(g);
  return 0;
}

int day13main(int argc, const char** argv) {
  id parts = split(readFile(@"input/day13.txt"), @"\n\n");
  id dots =
      parseLines(splitLines(parts[0]),
                 [NSRegularExpression regularExpressionWithPattern:@"(\\d+)"
                                                           options:0
                                                             error:NULL]);

  id folds =
      parseLines(splitLines(parts[1]),
                 [NSRegularExpression regularExpressionWithPattern:@"(.)=(\\d+)"
                                                           options:0
                                                             error:NULL]);
  Grid g = {};
  for (id dot in dots) {
    int x = [dot[0] intValue];
    int y = [dot[1] intValue];
    if (g.x <= x) g.x = x + 1;
    if (g.y <= y) g.y = y + 1;
  }
  g.dots = calloc(g.x * g.y, sizeof(bool));
  for (id dot in dots) {
    int x = [dot[0] intValue];
    int y = [dot[1] intValue];
    *pos(&g, x, y) = true;
  }

  NSLog(@"Part 1: %d", day13part1(&g, folds));
  NSLog(@"Part 2: %d", day13part2(&g, folds));
  return 0;
}
