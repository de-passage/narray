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
	
	def setup
		@d3 = NArray.new([[[1,"a"], [[], 5]], [["test", []], [nil, [1,2]]]])
	end
	
	def test_a_narray_can_be_created_from_a_dimension
		assert_equal [], NArray.new(1), "Unidimensional Array: "
		assert_equal [[]], NArray.new(2), "Bidimensional Array: "
		assert_equal [[[]]], NArray.new(3), "Tridimensional Array: "
		assert_equal 69, NArray::count_dimensions(NArray.new(69)), "69-dimensional Array (no kidding!): "
	end

	def test_a_narray_can_be_created_from_a_litteral_array
		assert_equal [1,2,3], NArray.new([1,2,3])
		assert_equal [], NArray.new([])
		assert_equal [[1,2], [1,2]], NArray.new([[1,2], [1,2]])
		assert_equal [[[1,"a"], [[], 5]], [["test", []], [nil, [1,2]]]],
			NArray.new([[[1,"a"], [[], 5]], [["test", []], [nil, [1,2]]]])
	end

	def test_a_narray_should_always_have_a_dimensions_attribute_set
		assert_equal 1, NArray.new(1).dimensions
		assert_equal 2, NArray.new(2).dimensions
		assert_equal 42, NArray.new(42).dimensions
	end

	def test_class_calculate_dimensions_correctly
		assert_equal [3,3], NArray::calculate_dimensions(Array.new(3) { Array.new (3) })
		assert_equal [0], NArray::calculate_dimensions([])
		assert_equal [4], NArray::calculate_dimensions([[], 43, [1, 2], nil])
		assert_equal [], NArray::calculate_dimensions("test")
		assert_equal [4, 3, 2], NArray::calculate_dimensions(
			Array.new(4) { 
				Array.new(3) { 
					Array.new(2) { [*(1..10)].sample }}})
	end

	def test_class_count_dimensions_correctly
		assert_equal 2, NArray::count_dimensions(Array.new(3) { Array.new(3) })
		assert_equal 1, NArray::count_dimensions([])
		assert_equal 1, NArray::count_dimensions([[], 43, [1, 2], nil])
		assert_equal 0, NArray::count_dimensions("test")
		assert_equal 3, NArray::count_dimensions(
			Array.new(4) { 
				Array.new(3) { 
					Array.new(2) { [*(1..10)].sample }}})
	end
end

