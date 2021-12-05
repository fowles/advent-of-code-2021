#import <Foundation/Foundation.h>

#include <stdlib.h>

#import "day1.h"
#import "day2.h"
#import "day3.h"
#import "parsing.h"

int main(int argc, const char** argv) {
  chdir(getenv("BUILD_WORKING_DIRECTORY"));
  @autoreleasepool {
    return day3main(argc, argv);
  }
}
