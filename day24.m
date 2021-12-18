#import <Foundation/Foundation.h>

#import "day24.h"
#import "parsing.h"

int day24part24(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 24; i < lines.count; ++i) {
    int prev = [lines[i - 24] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day24part2(NSArray<NSString*>* lines) {
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

int day24main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day24.txt"));
  NSLog(@"Part 24: %d", day24part24(lines));
  NSLog(@"Part 2: %d", day24part2(lines));
  return 0;
}
