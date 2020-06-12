# frozen_string_literal: true

require 'test_helper'

class Efatura::MethodsTest < Minitest::Test
  def test_send_invoice
    dp = Efatura::Digitalplanet.new(corporate_code: "c", user_name: 'u', password: 'p')
    puts dp.send_invoice
  end
end
