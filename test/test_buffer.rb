class TC_Buffer < Test::Unit::TestCase
  # read test

  def test_read_labels
    # valid labels
    buf = ZDNS::Buffer.new
    buf.write("\x03www\x06google\x03com\x00")
    buf.pos = 0
    assert_equal(["www", "google", "com", ""], buf.read_labels)

    # invalid labels
    assert_raise ZDNS::FormatError do
      buf = ZDNS::Buffer.new
      buf.write("\x03www\x06google\x03com\x01")
      buf.pos = 0
      buf.read_labels
    end
  end

  def test_read_domain
    # valid domain
    buf = ZDNS::Buffer.new
    buf.write("\x03www\x06google\x03com\x00")
    buf.pos = 0
    assert_equal("www.google.com.", buf.read_domain)

    # invalid domain
    assert_raise ZDNS::FormatError do
      buf = ZDNS::Buffer.new
      buf.write("\x03www\x06google\x03com\x01")
      buf.pos = 0
      buf.read_domain
    end
  end

  def test_read_type
    buf = ZDNS::Buffer.new
    buf.write_short(ZDNS::Packet::Type::A)
    buf.pos = 0
    assert_equal(ZDNS::Packet::Type::A, buf.read_type)
  end

  def test_read_class
    buf = ZDNS::Buffer.new
    buf.write_short(ZDNS::Packet::Class::IN)
    buf.pos = 0
    assert_equal(ZDNS::Packet::Class::IN, buf.read_class)
  end

  def test_read_ipv4
    # valid ipv4
    buf = ZDNS::Buffer.new
    buf.write("\xC0\xA8\x00\x01")
    buf.pos = 0
    assert_equal("192.168.0.1", buf.read_ipv4)

    # invalid ipv4
    assert_raise ZDNS::FormatError do
      buf = ZDNS::Buffer.new
      buf.read_ipv4
    end
  end

  def test_read_ipv6
    # valid ipv6
    buf = ZDNS::Buffer.new
    buf.write("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01")
    buf.pos = 0
    assert_equal("0:0:0:0:0:0:0:1", buf.read_ipv6)

    # invalid ipv6
    assert_raise ZDNS::FormatError do
      buf = ZDNS::Buffer.new
      buf.read_ipv6
    end
  end

  def test_read_char
    # valid char range 1byte
    buf = ZDNS::Buffer.new
    buf.write("A")
    buf.pos = 0
    assert_equal(0x41, buf.read_char)

    # invalid char range 0byte
    assert_raise ZDNS::FormatError do
      buf = ZDNS::Buffer.new
      buf.read_char
    end
  end

  def test_read_short
    # valid short range 2bytes
    buf = ZDNS::Buffer.new
    buf.write("AB")
    buf.pos = 0
    assert_equal(0x4142, buf.read_short)

    # invalid short range 1byte
    assert_raise ZDNS::FormatError do
      buf = ZDNS::Buffer.new
      buf.write("A")
      buf.read_short
    end
  end

  def test_read_long
    # valid long range 4bytes
    buf = ZDNS::Buffer.new
    buf.write("ABCD")
    buf.pos = 0
    assert_equal(0x41424344, buf.read_long)

    # invalid long range 3byte
    assert_raise ZDNS::FormatError do
      buf = ZDNS::Buffer.new
      buf.write("ABC")
      buf.read_long
    end
  end

  # write test

  def test_write_domain
    # valid domain
    buf = ZDNS::Buffer.new
    buf.write_domain("www.google.com.")
    buf.pos = 0
    assert_equal("\x03www\x06google\x03com\x00", buf.read)

    # invalid domain
    assert_raise ZDNS::FormatError do
      buf = ZDNS::Buffer.new
      buf.write_domain("invalid.domain")
    end
  end

  def test_write_ipv4
    # valid ipv4
    buf = ZDNS::Buffer.new
    buf.write_ipv4("192.168.0.1")
    buf.pos = 0
    assert_equal("\xC0\xA8\x00\x01", buf.read)

    # invalid ipv4
    assert_raise ArgumentError do
      buf = ZDNS::Buffer.new
      buf.write_ipv4("invalid ipv4")
    end
  end

  def test_write_ipv6
    # valid ipv6
    buf = ZDNS::Buffer.new
    buf.write_ipv6("::1")
    buf.pos = 0
    assert_equal("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01", buf.read)

    # invalid ipv6
    assert_raise IPAddr::InvalidAddressError do
      buf = ZDNS::Buffer.new
      buf.write_ipv6("invalid ipv6")
    end
  end

  def test_write_char
    # valid char range 1byte
    buf = ZDNS::Buffer.new
    buf.write_char(0x41)
    buf.pos = 0
    assert_equal("A", buf.read)

    # invalid char range 2bytes
    buf = ZDNS::Buffer.new
    buf.write_char(0x4142)
    buf.pos = 0
    assert_equal("B", buf.read)
  end

  def test_write_short
    # valid short range 1byte
    buf = ZDNS::Buffer.new
    buf.write_short(0x41)
    buf.pos = 0
    assert_equal("\x00A", buf.read)

    # valid short range 2bytes
    buf = ZDNS::Buffer.new
    buf.write_short(0x4142)
    buf.pos = 0
    assert_equal("AB", buf.read)

    # invalid short range 3bytes
    buf = ZDNS::Buffer.new
    buf.write_short(0x414243)
    buf.pos = 0
    assert_equal("BC", buf.read)
  end

  def test_write_long
    # valid long range 1byte
    buf = ZDNS::Buffer.new
    buf.write_long(0x41)
    buf.pos = 0
    assert_equal("\x00\x00\x00A", buf.read)

    # valid long range 2bytes
    buf = ZDNS::Buffer.new
    buf.write_long(0x4142)
    buf.pos = 0
    assert_equal("\x00\x00AB", buf.read)

    # valid long range 3bytes
    buf = ZDNS::Buffer.new
    buf.write_long(0x414243)
    buf.pos = 0
    assert_equal("\x00ABC", buf.read)

    # valid long range 4bytes
    buf = ZDNS::Buffer.new
    buf.write_long(0x41424344)
    buf.pos = 0
    assert_equal("ABCD", buf.read)

    # invalid long range 5bytes
    buf = ZDNS::Buffer.new
    buf.write_long(0x4142434445)
    buf.pos = 0
    assert_equal("BCDE", buf.read)
  end
end
