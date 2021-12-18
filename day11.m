#import <Foundation/Foundation.h>

#import "day11.h"
#import "parsing.h"

typedef struct {
  int energy[10][10];
} Octos;

void Adjacent(int i, int j, void (^block)(int i, int j)) {
  for (int di = -1; di < 2; ++di) {
    for (int dj = -1; dj < 2; ++dj) {
      int ni = i + di;
      int nj = j + dj;
      if (ni < 0 || nj < 0 || ni >= 10 || nj >= 10) continue;
      if (ni == i && nj == j) continue;
      block(ni, nj);
    }
  }
}

#if 0
- First, the energy level of each octopus increases by 1.

- Then, any octopus with an energy level greater than 9 flashes. This increases
the energy level of all adjacent octopuses by 1, including octopuses that are
diagonally adjacent. If this causes an octopus to have an energy level greater
than 9, it also flashes. This process continues as long as new octopuses keep
having their energy level increased beyond 9. (An octopus can only flash at
    most once per step.)

- Finally, any octopus that flashed during this step has its energy level set to 0, as it used all of its energy to flash.
#endif

int Step(Octos* o) {
  __block struct { bool flashed[10][10]; } state = {};
  void (^flash)(int i, int j) = ^(int i, int j) {
    state.flashed[i][j] = true;
    Adjacent(i, j, ^(int ni, int nj) {
      ++o->energy[ni][nj];
    });
  };

  for (int i = 0; i < 10; ++i) {
    for (int j = 0; j < 10; ++j) {
      ++o->energy[i][j];
    }
  }

  bool flashed = true;
  while (flashed) {
    flashed = false;
    for (int i = 0; i < 10; ++i) {
      for (int j = 0; j < 10; ++j) {
        if (o->energy[i][j] > 9 && !state.flashed[i][j]) {
          flashed = true;
          flash(i, j);
        }
      }
    }
  }

  int flashes = 0;
  for (int i = 0; i < 10; ++i) {
    for (int j = 0; j < 10; ++j) {
      if (state.flashed[i][j]) {
        ++flashes;
        o->energy[i][j] = 0;
      }
    }
  }
  return flashes;
}

int day11part1(Octos* o) {
  int flashes = 0;
  for (int i = 0; i < 100; ++i) {
    flashes += Step(o);
  }
  return flashes;
}

int day11part2(Octos* o) {
  int step = 0;
  while (true) {
    ++step;
    if (Step(o) == 100) return step;
  }
}

int day11main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day11.txt"));
  Octos o1;
  for (int i = 0; i < 10; ++i) {
    for (int j = 0; j < 10; ++j) {
      o1.energy[i][j] = [lines[i] characterAtIndex:j] - '0';
    }
  }
  Octos o2 = o1;
  NSLog(@"Part 1: %d", day11part1(&o1));
  NSLog(@"Part 2: %d", day11part2(&o2));
  return 0;
}
