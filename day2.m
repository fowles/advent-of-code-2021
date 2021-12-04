#import <Foundation/Foundation.h>

#import "day2.h"
#import "parsing.h"

int day2part1(NSArray<NSArray<NSString*>*>* commands) {
  int depth = 0;
  int position = 0;
  for (id command in commands) {
    if ([command[0] isEqualToString:@"forward"]) {
      position += [command[1] intValue];
    }
    if ([command[0] isEqualToString:@"down"]) {
      depth += [command[1] intValue];
    }
    if ([command[0] isEqualToString:@"up"]) {
      depth -= [command[1] intValue];
    }
  }
  return depth * position;
}

int day2part2(NSArray<NSString*>* lines) {
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

int day2main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day2.txt"));
  id parsed = parseLines(
      lines, [NSRegularExpression regularExpressionWithPattern:@"(\\w+) (\\d+)"
                                                       options:0
                                                         error:NULL]);
  NSLog(@"Part 1: %d", day2part1(parsed));
  return 0;
}
