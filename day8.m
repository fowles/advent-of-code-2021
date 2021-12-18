#import <Foundation/Foundation.h>

#import "day8.h"
#import "parsing.h"

#include <stdlib.h>

bool SetEquality(NSCharacterSet* lhs, NSCharacterSet* rhs) {
  return [lhs isSupersetOfSet:rhs] && [rhs isSupersetOfSet:lhs];
}

int decode(NSMutableArray<NSString*>* line) {
  int determined[10] = {};
  int counts[7] = {};
  char known[256] = {};

  id sets = [NSMutableArray arrayWithCapacity:10];
  for (int i = 0; i < 10; ++i) {
    id set = [NSCharacterSet characterSetWithCharactersInString:line[i]];
    switch (line[i].length) {
      case 2: determined[1] = i; break;
      case 3: determined[7] = i; break;
      case 4: determined[4] = i; break;
      case 7: determined[8] = i; break;
      default: break;
    }
    for (int j = 0; j < 7; ++j) {
      if ([set characterIsMember:('a' + j)]) {
        ++counts[j];
      }
    }
    [sets addObject:set];
  }

  for (int i = 0; i < 7; ++i) {
    switch (counts[i]) {
      case 9: known['f'] = 'a' + i; break; // 'f'
      case 8: break; // 'a' or 'c'
      case 7: break; // 'd' or 'g'
      case 6: known['b'] = 'a' + i; break; // 'b'
      case 4: known['e'] = 'a' + i; break; // 'e'
      default: break;
    }
  }

  for (int i = 0; i < 10; ++i) {
    switch (line[i].length) {
      case 5:
        if ([sets[i] isSupersetOfSet: sets[determined[1]]]) {
          determined[3] = i;
        } else if ([sets[i] characterIsMember: known['e']]) {
          determined[2] = i;
        } else {
          determined[5] = i;
        }
        break;
      case 6:
        if (![sets[i] isSupersetOfSet: sets[determined[1]]]) {
          determined[6] = i;
        } else if ([sets[i] characterIsMember: known['e']]) {
          determined[0] = i;
        } else {
          determined[9] = i;
        }
        break;
      default:
        break;
    }
  }

  int res = 0;
  for (int i = 10; i < line.count; ++i) {
    res *= 10;
    id set = [NSCharacterSet characterSetWithCharactersInString:line[i]];
    for (int j = 0; j < 10; ++j) {
      if (SetEquality(set, sets[determined[j]])) {
        res += j;
        break;
      }
    }
  }
  return res;
}


int day8part1(NSArray<NSArray<NSString*>*>* lines) {
  int res = 0;
  for (NSArray<NSString*>* line in lines) {
    for (int i = 10; i < line.count; ++i) {
      switch (line[i].length) {
      case 2:
      case 3:
      case 4:
      case 7:
        ++res;
        break;
      default:
        break;
      }
    }
  }
  return res;
}

int day8part2(NSArray<NSMutableArray<NSString*>*>* lines) {
  int res = 0;
  for (id line in lines) {
    res += decode(line);
  }
  return res;;
}

int day8main(int argc, const char** argv) {
  id lines = splitLines(readFile(@"input/day8.txt"));
  id parsed = parseLines(
      lines, [NSRegularExpression regularExpressionWithPattern:@"(\\w+)"
                                                       options:0
                                                         error:NULL]);
  NSLog(@"Part 1: %d", day8part1(parsed));
  NSLog(@"Part 2: %d", day8part2(parsed));
  return 0;
}
