#import <Foundation/Foundation.h>

#import "day16.h"
#import "parsing.h"

size_t GetBit(NSString* hex, int pos) {
  char c = [hex characterAtIndex: pos/4];
  if ('0' <= c && c <= '9') c = 0x0 + (c - '0');
  if ('A' <= c && c <= 'F') c = 0xA + (c - 'A');
  int offset = 3 - pos % 4;
  c >>= offset;
  c &= 0x1;
  return c;
}

size_t ConsumeBits(NSString* hex, int* pos, int num_bits) {
  size_t res = 0;
  while (num_bits > 0) {
    res <<= 1;
    res |= GetBit(hex, *pos);
    ++*pos;
    --num_bits;
  }
  return res;
}

size_t ConsumePacket(NSString* hex, int* pos);

size_t gTotalVersion = 0;
size_t ConsumeVersion(NSString* hex, int* pos) {
  size_t r = ConsumeBits(hex, pos, 3);
  gTotalVersion += r;
  return r;
}

size_t ConsumeTypeId(NSString* hex, int* pos) {
  return ConsumeBits(hex, pos, 3);
}

size_t ConsumeLiteral(NSString* hex, int* pos) {
  size_t res = 0;
  bool carry;
  do {
    carry = ConsumeBits(hex, pos, 1);
    res <<= 4;
    res |= ConsumeBits(hex, pos, 4);
  } while (carry);
  return res;
}

size_t ConsumeOperator(NSString* hex, int* pos,
                       size_t (^fold)(size_t lhs, size_t rhs)) {
  bool length_type_id = ConsumeBits(hex, pos, 1);
  size_t res;
  if (length_type_id) {
    size_t length_in_packets = ConsumeBits(hex, pos, 11);
    res = ConsumePacket(hex, pos);
    for (int i = 1; i < length_in_packets; ++i) {
      res = fold(res, ConsumePacket(hex, pos));
    }
  } else {
    size_t length_in_bits = ConsumeBits(hex, pos, 15);
    size_t end = *pos + length_in_bits;
    res = ConsumePacket(hex, pos);
    while (*pos < end) {
      res = fold(res, ConsumePacket(hex, pos));
    }
  }
  return res;
}

const size_t kSumType = 0x0;
const size_t kProdType = 0x1;
const size_t kMinType = 0x2;
const size_t kMaxType = 0x3;
const size_t kLitType = 0x4;
const size_t kGtType = 0x5;
const size_t kLtType = 0x6;
const size_t kEqType = 0x7;
size_t ConsumePacket(NSString* hex, int* pos) {
  ConsumeVersion(hex, pos);
  size_t type_id = ConsumeTypeId(hex, pos);
  switch (type_id) {
  case kLitType:
    return ConsumeLiteral(hex, pos);
  case kSumType:
    return ConsumeOperator(hex, pos, ^(size_t lhs, size_t rhs) {
      return lhs + rhs;
    });
  case kProdType:
    return ConsumeOperator(hex, pos, ^(size_t lhs, size_t rhs) {
      return lhs * rhs;
    });
  case kMinType:
    return ConsumeOperator(hex, pos, ^(size_t lhs, size_t rhs) {
      return lhs < rhs ? lhs : rhs;
    });
  case kMaxType:
    return ConsumeOperator(hex, pos, ^(size_t lhs, size_t rhs) {
      return lhs > rhs ? lhs : rhs;
    });
  case kGtType:
    return ConsumeOperator(hex, pos, ^(size_t lhs, size_t rhs) {
      return (size_t)(lhs > rhs);
    });
  case kLtType:
    return ConsumeOperator(hex, pos, ^(size_t lhs, size_t rhs) {
      return (size_t)(lhs < rhs);
    });
  case kEqType:
    return ConsumeOperator(hex, pos, ^(size_t lhs, size_t rhs) {
      return (size_t)(lhs == rhs);
    });
  default:
    [NSException raise:@"Parse error"
                format:@"Unsupported operation: %zu", type_id];
    return 0;
  }
}

size_t day16part1(NSString* hex) {
  int pos = 0;
  ConsumePacket(hex, &pos);
  return gTotalVersion;
}

size_t day16part2(NSString* hex) {
  int pos = 0;
  return ConsumePacket(hex, &pos);
}

int day16main(int argc, const char** argv) {
  id hex = readFile(@"input/day16.txt");
  NSLog(@"Part 1: %zu", day16part1(hex));
  NSLog(@"Part 2: %zu", day16part2(hex));
  return 0;
}
