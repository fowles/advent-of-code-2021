#import <Foundation/Foundation.h>

#import "day6.h"
#import "parsing.h"

void AgeFish(size_t* fish_ages) {
  size_t pregers = fish_ages[0];
  for (int i = 1; i < 9; ++i) {
    fish_ages[i-1] = fish_ages[i];
  }
  fish_ages[8] = pregers;
  fish_ages[6] += pregers;
}

size_t CountFish(size_t* fish_ages) {
  size_t res = 0;
  for (int i = 0; i < 9; ++i) res += fish_ages[i];
  return res;
}

size_t day6part1(size_t* fish_ages) {
  for (int i = 0; i < 80; ++i) {
    AgeFish(fish_ages);
  }
  return CountFish(fish_ages);
}

size_t day6part2(size_t* fish_ages) {
  for (int i = 80; i < 256; ++i) {
    AgeFish(fish_ages);
  }
  return CountFish(fish_ages);
}

int day6main(int argc, const char** argv) {
  id nums = split(readFile(@"input/day6.txt"), @",");
  size_t fish_ages[9] = {};
  for (id n in nums) {
    ++fish_ages[[n intValue]];
  }
  NSLog(@"Part 1: %ld", day6part1(fish_ages));
  NSLog(@"Part 2: %ld", day6part2(fish_ages));
  return 0;
}
