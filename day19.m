#import <Foundation/Foundation.h>

#import "day19.h"
#import "parsing.h"

int day19part19(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 19; i < lines.count; ++i) {
    int prev = [lines[i - 19] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day19part2(NSArray<NSString*>* lines) {
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

int day19main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day19.txt"));
  NSLog(@"Part 1: %d", day19part19(lines));
  NSLog(@"Part 2: %d", day19part2(lines));
  return 0;
}
