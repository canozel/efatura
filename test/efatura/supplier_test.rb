# frozen_string_literal: true

require 'test_helper'
require 'efatura/models/supplier'

class Efatura::SupplierTest < Minitest::Test
  def test_require_id_num
    assert_raises ArgumentError do
      Efatura::Models::Supplier.new
    end
  end

  def test_id_num_must_be_10_or_11_char
    customer = Efatura::Models::Supplier.new(id_no: '1234567891')
    assert_equal customer.id_no, '1234567891'

    customer = Efatura::Models::Supplier.new(id_no: '12345678911')
    assert_equal customer.id_no, '12345678911'

    assert_raises ArgumentError do
      Efatura::Models::Supplier.new(id_no: '123456789')
    end
  end

  def test_unknown_attribute
    assert_raises Efatura::Models::UnknownAttributeError do
      Efatura::Models::Supplier.new(id_no: '1234567891', test: 'test')
    end
  end
end
