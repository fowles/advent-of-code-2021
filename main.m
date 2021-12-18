#import <Foundation/Foundation.h>

#include <stdlib.h>

#import "day1.h"
#import "day2.h"
#import "day3.h"
#import "day4.h"
#import "day5.h"
#import "day6.h"
#import "day7.h"
#import "day8.h"

int main(int argc, const char** argv) {
  chdir(getenv("BUILD_WORKING_DIRECTORY"));
  @autoreleasepool {
    return day8main(argc, argv);
  }
}
