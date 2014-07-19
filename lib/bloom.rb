module Bloom
  def murmurhash3(key, seed)
    c1 = 0xcc9e2d51
    c2 = 0x1b873593
    r1 = 15
    r2 = 13
    m = 5
    n = 0xe6546b64

    filter_32 = 0xFFFFFFFF

    len = key.length

    hash = seed

    nblocks = (len / 4)
    blocks = key

    bytes = key.unpack('L*')

    # iterate over the 4 char sections of key
    for i in 0..nblocks-1 do
      # generate bitwise representation of section
      k = bytes[i]
      k = (k * c1) & filter_32
      k = (k << r1) | (k >> (32 - r1))
      k = (k * c2) & filter_32

      hash ^= k
      hash = ((hash << r2) | (hash >> (32 - r2)))
      hash = (hash * m + n) & filter_32
    end

    k1 = 0

    bytes = key.unpack('C*')

    if len % 4 == 3
      k1 ^= (bytes[-1] << 16)
      k1 ^= (bytes[-2] << 8)
      k1 ^= (bytes[-3])
    end
    if len % 4 == 2
      k1 ^= (bytes[-1] << 8)
      k1 ^= (bytes[-2])
    end
    if len % 4 == 1
      k1 ^= bytes[-1]
    end

    if len % 4 != 0
      k1 = (k1 * c1) & filter_32
      k1 = ((k1 << r1) | (k1 >> (32 - r1))) & filter_32
      k1 = (k1 * c2) & filter_32
      hash ^= k1
    end

    p hash
    hash ^= key.length
    hash &= filter_32
    hash ^= (hash >> 16)
    hash = (hash * 0x85ebca6b) & filter_32
    hash ^= (hash >> 13)
    hash &= filter_32
    hash = (hash * 0xc2b2ae35) & filter_32
    hash ^= (hash >> 16)
    hash &= filter_32

    return hash
  end
end

