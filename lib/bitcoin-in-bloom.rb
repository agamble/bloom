class Bloom
  attr_reader :bit_field, :nHash, :nTweak, :size

  MAX_SIZE = 36000

  def initialize(elements, false_positive_rate=0.01, nHash=10)
    @nTweak = SecureRandom.hex.to_i

    @size = ([( -1 * elements * Math.log(false_positive_rate)) / (Math.log(2) ** 2),
              MAX_SIZE * 8].min / 8).floor

    @nHash = ((size * 8 * Math.log(2)) / elements).to_i

    @bit_field = Array.new(size, 0)

  end

  def in_range(variable, lower, upper)
    if variable > upper || variable < lower
      return false
    end
    true
  end

  def hash(data, nHashNum)
    murmurhash3(data, nHashNum * 0xFBA4C795 + @nTweak)
  end

  def insert(data)
    for i in 1..nHash do
      hash = hash(data, i)

      bit_field[hash >> 3] |= (1 << (7 & hash))
      puts 1
      puts bit_field.length
      puts (hash >> 3)
    end
  end

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

