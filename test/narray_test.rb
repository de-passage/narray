require "minitest/autorun"
require "minitest/spec"
require_relative "../lib/narray"

class TestNArray < MiniTest::Test
#	def test_a_narray_can_be_created_from_a_list_of_dimensions
#		assert_equal NArray.new([2,2,2], nil), [[[nil, nil], [nil, nil]], [[nil, nil],[nil, nil]]]
#	end
#
#	def test_a_narray_can_be_created_from_a_template
#		assert_equal NArray.new( [[1,2,3], [1,2,3], [1,2,3]] ), [[1,2,3], [1,2,3], [1,2,3]]
#	end

	def test_class_calculate_dimensions_correctly
		assert_equal NArray::calculate_dimensions(Array.new(3) { Array.new (3) }), [3,3]
		assert_equal NArray::calculate_dimensions([]), [0]
		assert_equal NArray::calculate_dimensions([[], 43, [1, 2], nil]), [4]
		assert_equal NArray::calculate_dimensions("test"), []
	end

end

