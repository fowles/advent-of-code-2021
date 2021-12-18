#import <Foundation/Foundation.h>

#import "day21.h"
#import "parsing.h"

int day21part21(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 21; i < lines.count; ++i) {
    int prev = [lines[i - 21] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day21part2(NSArray<NSString*>* lines) {
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

int day21main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day21.txt"));
  NSLog(@"Part 21: %d", day21part21(lines));
  NSLog(@"Part 2: %d", day21part2(lines));
  return 0;
}
