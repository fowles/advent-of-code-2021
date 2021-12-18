#import <Foundation/Foundation.h>

#import "day9.h"
#import "parsing.h"

#include <stdlib.h>

typedef struct {
  int heights[100][100];
} Floor;

void Adjacent(Floor* f, int i, int j,
           void (^block)(Floor* f, int i, int j)) {
  if (i > 0)  block(f, i - 1, j    );
  if (i < 99) block(f, i + 1, j    );
  if (j > 0)  block(f, i    , j - 1);
  if (j < 99) block(f, i    , j + 1);
}

int day9part1(Floor* f) {
  int risk = 0;
  for (int i = 0; i < 100; ++i) {
    for (int j = 0; j < 100; ++j) {
      __block int min = INT_MAX;
      Adjacent(f, i, j, ^void(Floor* f, int i, int j) {
          int h = f->heights[i][j];
          if (h < min) min = h;
      });
      int h = f->heights[i][j];
      if (h < min) risk += h + 1;
    }
  }
  return risk;
}

int day9part2(Floor* f) {
  id basins = [NSMutableArray arrayWithCapacity:10];
  for (int i = 0; i < 100; ++i) {
    for (int j = 0; j < 100; ++j) {
      int h = f->heights[i][j];
      if (h < 9) {
        __block int size = 0;
        void (^strong_block)(Floor* f, int i, int j);
        __block __weak void (^block)(Floor* f, int i, int j);
        block = strong_block =  ^void(Floor* f, int i, int j) {
          int h = f->heights[i][j];
          if (h == 9) return;
          ++size;
          f->heights[i][j] = 9;
          Adjacent(f, i, j, block);
        };
        block(f, i, j);
        [basins addObject:@(size)];
      }
    }
  }
  basins = [basins sortedArrayUsingSelector:@selector(compare:)];
  size_t len = [basins count];
  int prod = 1;
  for (int i = 1; i <= 3; ++i) {
    prod *= [basins[len - i] intValue];
  }
  return prod;
}

int day9main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day9.txt"));
  Floor f;
  for (int i = 0; i < 100; ++i) {
    for (int j = 0; j < 100; ++j) {
      f.heights[i][j] = [lines[i] characterAtIndex:j] - '0';
    }
  }
  NSLog(@"Part 1: %d", day9part1(&f));
  NSLog(@"Part 2: %d", day9part2(&f));
  return 0;
}
