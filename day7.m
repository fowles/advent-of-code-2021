#import <Foundation/Foundation.h>

#include <math.h>

#import "day7.h"
#import "parsing.h"

long RequiredCrabJuice(NSArray<NSString*>* crabs, long pos) {
  long crab_juice = 0;
  for (id crab in crabs) {
    crab_juice += labs([crab intValue] - pos);
  }
  return crab_juice;
}

long day7part1(NSArray<NSString*>* crabs) {
  int max_pos = 0;
  for (id crab in crabs) {
    max_pos = MAX(max_pos, [crab intValue]);
  }

  long best_juice = RequiredCrabJuice(crabs, 0);
  for (size_t pos = 1; pos < max_pos; ++pos) {
    long crab_juice = RequiredCrabJuice(crabs, pos);
    if (crab_juice < best_juice) {
      best_juice = crab_juice;
    }
  }

  return best_juice;
}

long TriangularNum(long delta) {
  delta = labs(delta);
  long res = 0;
  for (int i = 0; i <= delta; ++i) {
    res += i;
  }
  return res;
}

long RequiredCrabJuice2(NSArray<NSString*>* crabs, long pos) {
  long crab_juice = 0;
  for (id crab in crabs) {
    crab_juice += TriangularNum([crab intValue] - pos);
  }
  return crab_juice;
}

long day7part2(NSArray<NSString*>* crabs) {
  int max_pos = 0;
  for (id crab in crabs) {
    max_pos = MAX(max_pos, [crab intValue]);
  }

  long best_juice = RequiredCrabJuice2(crabs, 0);
  for (size_t pos = 1; pos < max_pos; ++pos) {
    long crab_juice = RequiredCrabJuice2(crabs, pos);
    if (crab_juice < best_juice) {
      best_juice = crab_juice;
    }
  }

  return best_juice;
}

int day7main(int argc, const char** argv) {
  id crabs = split(readFile(@"input/day7.txt"), @",");
  NSLog(@"Part 1: %ld", day7part1(crabs));
  NSLog(@"Part 2: %ld", day7part2(crabs));
  return 0;
}
