module TestsNode
  def collect
    level = case
              when test.elements.first.respond_to?(:tests_a) then :a
              when test.elements.first.respond_to?(:tests_b) then :b
              else                                            :c
            end

    test_hash = ActiveSupport::OrderedHash.new
    test.elements.each { |t| test_hash[t.name.text_value] = t.send("tests_#{level}").collect }
    test_hash
  end
end
