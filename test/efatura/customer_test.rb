# frozen_string_literal: true

require 'test_helper'
require 'efatura/models/customer'

class Efatura::CustomerTest < Minitest::Test
  def test_require_id_num
    assert_raises ArgumentError do
      Efatura::Models::Customer.new
    end
  end

  def test_id_num_must_be_10_or_11_char
    customer = Efatura::Models::Customer.new(id_no: '1234567891')
    assert_equal customer.id_no, '1234567891'

    customer = Efatura::Models::Customer.new(id_no: '12345678911')
    assert_equal customer.id_no, '12345678911'
    assert_nil customer.email

    assert_raises ArgumentError do
      Efatura::Models::Customer.new(id_no: '123456789')
    end
  end

  def test_unknown_attribute
    assert_raises Efatura::Models::UnknownAttributeError do
      Efatura::Models::Customer.new(id_no: '1234567891', test: 'test')
    end
  end
end
