#import <Foundation/Foundation.h>

#import "day6.h"
#import "parsing.h"

void AdvanceDay(NSMutableArray<NSString*>* fish) {
  NSUInteger s = fish.count;
  for (NSUInteger i = 0; i < s; ++i) {
    if ([fish[i] intValue] == 0) {
      fish[i] = @"6";
      [fish addObject: @"8"];
    } else {
      fish[i] = @([fish[i] intValue] - 1).stringValue;
    }
  }
}

NSInteger day6part1(NSMutableArray<NSString*>* nums) {
  for (int i = 0; i < 80; ++i) {
    AdvanceDay(nums);
  }
  return nums.count;
}

int day6main(int argc, const char** argv) {
  id nums = split(readFile(@"input/day6.txt"), @",");
  NSLog(@"Part 1: %ld", day6part1(nums));
  return 0;
}
