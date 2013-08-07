class TC_Packet_Type < Test::Unit::TestCase
  def test_to_s
    assert_equal("A", ZDNS::Packet::Type::A.to_s)
  end

  def test_to_sym
    assert_equal(:A, ZDNS::Packet::Type::A.to_sym)
  end

  def test_to_i
    assert_equal(1, ZDNS::Packet::Type::A.to_i)
  end

  def test_rr_class
    assert_equal(ZDNS::Packet::RR::A, ZDNS::Packet::Type::A.rr_class)
  end

  def test_model_class
    assert_equal(ZDNS::AR::Model::ARecord, ZDNS::Packet::Type::A.model_class)
  end
end
