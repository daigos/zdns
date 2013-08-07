class TC_Packet < Test::Unit::TestCase
  def setup
    @bin = open("#{File.dirname(__FILE__)}/../example/example_packet.bin", "r"){|f| f.read}
    @bin.force_encoding("ASCII-8BIT")
  end

  def test_new_from_buffer
    packet = ZDNS::Packet::new_from_buffer(@bin)

    # header
    assert_equal(40261, packet.header.id)

    assert_equal(ZDNS::Packet::Header::QR::RESPONSE, packet.header.qr)
    assert_equal(ZDNS::Packet::Header::OPCode::STANDARD_QUERY, packet.header.opcode)
    assert_equal(ZDNS::Packet::Header::AA::NON_AUTHORITATIVE_ANSWER, packet.header.aa)
    assert_equal(ZDNS::Packet::Header::TC::NON_TRUNCATION, packet.header.tc)
    assert_equal(ZDNS::Packet::Header::RD::RECURSION, packet.header.rd)
    assert_equal(ZDNS::Packet::Header::RA::RECURSION, packet.header.ra)
    assert_equal(0, packet.header.z)
    assert_equal(ZDNS::Packet::Header::Rcode::NO_ERROR, packet.header.rcode)

    assert_equal(1, packet.header.qdcount)
    assert_equal(23, packet.header.ancount)
    assert_equal(0, packet.header.nscount)
    assert_equal(0, packet.header.arcount)

    # questions
    assert_equal(1, packet.questions.length)

    question = packet.questions[0]
    assert_equal("google.com.", question.name)
    assert_equal(ZDNS::Packet::Type::ANY, question.type)
    assert_equal(ZDNS::Packet::Class::IN, question.cls)

    # answers
    assert_equal(23, packet.answers.length)

    answer = packet.answers[0]
    assert_equal("google.com.", answer.name)
    assert_equal(149, answer.ttl)
    assert_equal("74.125.235.164", answer.address)

    answer = packet.answers[11]
    assert_equal("google.com.", answer.name)
    assert_equal(149, answer.ttl)
    assert_equal("2404:6800:4004:805::1000", answer.address)

    answer = packet.answers[12]
    assert_equal("google.com.", answer.name)
    assert_equal(21449, answer.ttl)
    assert_equal("ns3.google.com.", answer.nsdname)

    answer = packet.answers[13]
    assert_equal("google.com.", answer.name)
    assert_equal(449, answer.ttl)
    assert_equal(20, answer.preference)
    assert_equal("alt1.aspmx.l.google.com.", answer.exchange)

    answer = packet.answers[14]
    assert_equal("google.com.", answer.name)
    assert_equal(21449, answer.ttl)
    assert_equal("ns1.google.com.", answer.mname)
    assert_equal("dns-admin.google.com.", answer.rname)
    assert_equal(2013051600, answer.serial)
    assert_equal(7200, answer.refresh)
    assert_equal(1800, answer.retry)
    assert_equal(1209600, answer.expire)
    assert_equal(300, answer.minimum)

    answer = packet.answers[20]
    assert_equal("google.com.", answer.name)
    assert_equal(3449, answer.ttl)
    assert_equal("v=spf1 include:_spf.google.com ip4:216.73.93.70/31 ip4:216.73.93.72/31 ~all", answer.txt_data)

    # authorities
    assert_equal(0, packet.authorities.length)

    # additionals
    assert_equal(0, packet.additionals.length)
  end

  def test_build
    packet = ZDNS::Packet::new_from_buffer(@bin)
    bin = packet.to_bin
    bin.force_encoding("ASCII-8BIT")
    assert_equal(@bin, bin)
  end
end
