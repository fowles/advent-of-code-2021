#import <Foundation/Foundation.h>

#import "day23.h"
#import "parsing.h"

int day23part23(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 23; i < lines.count; ++i) {
    int prev = [lines[i - 23] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day23part2(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 3; i < lines.count; ++i) {
    int prev = [lines[i - 3] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day23main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day23.txt"));
  NSLog(@"Part 23: %d", day23part23(lines));
  NSLog(@"Part 2: %d", day23part2(lines));
  return 0;
}
