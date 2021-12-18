#import <Foundation/Foundation.h>

#import "day28.h"
#import "parsing.h"

int day28part28(NSArray<NSString*>* lines) {
  int increasing = 0;
  for (int i = 28; i < lines.count; ++i) {
    int prev = [lines[i - 28] intValue];
    int cur = [lines[i] intValue];
    if (prev < cur) {
      ++increasing;
    }
  }
  return increasing;
}

int day28part2(NSArray<NSString*>* lines) {
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

int day28main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day28.txt"));
  NSLog(@"Part 28: %d", day28part28(lines));
  NSLog(@"Part 2: %d", day28part2(lines));
  return 0;
}
