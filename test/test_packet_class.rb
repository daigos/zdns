class TC_Packet_Class < Test::Unit::TestCase
  def test_to_s
    assert_equal("IN", ZDNS::Packet::Class::IN.to_s)
  end

  def test_to_sym
    assert_equal(:IN, ZDNS::Packet::Class::IN.to_sym)
  end

  def test_to_i
    assert_equal(1, ZDNS::Packet::Class::IN.to_i)
  end
end
