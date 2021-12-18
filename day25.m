#import <Foundation/Foundation.h>

#import "day25.h"
#import "parsing.h"

int day25part25(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 25; i < lines.count; ++i) {
    int prev = [lines[i - 25] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day25part2(NSArray<NSString*>* lines) {
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

int day25main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day25.txt"));
  NSLog(@"Part 25: %d", day25part25(lines));
  NSLog(@"Part 2: %d", day25part2(lines));
  return 0;
}
