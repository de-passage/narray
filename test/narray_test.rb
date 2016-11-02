require "minitest/autorun"
require "minitest/spec"
require_relative "../lib/n-array"

class TestNArray < MiniTest::Test
	def setup
		@d3 = NArray.new([[[1,"a"], [[], 5]], [["test", {}], [nil, [1,2]]]])
		@d3b = NArray[[[1,"a"], [[], 5]], [["test", {}], [nil, [1,2]]]]
		@dn = NArray.new([])
		@d2 = NArray.new([2,2], 2)
	end
	
	def test_a_narray_can_be_created_from_a_list_of_dimensions_and_a_default_value
		assert_equal [[nil]], NArray.new([1,1], nil)
		assert_equal [[1]], NArray.new([1,1], 1)
		assert_equal [true, true], NArray.new([2], true)
		assert_equal [[0, 0, 0], [0, 0, 0]], NArray.new([2,3]) {0}
		assert_equal [[[nil, nil], [nil, nil]], [[nil, nil],[nil, nil]]], NArray.new([2,2,2]) { nil }
		assert_equal [[[nil, nil], [nil, nil]], [[nil, nil],[nil, nil]]], NArray.new([2,2,2], nil)
	end
	
	def test_a_narray_can_be_created_from_a_dimension
		assert_equal [], NArray.new(1), "Unidimensional Array: "
		assert_equal [[]], NArray.new(2), "Bidimensional Array: "
		assert_equal [[[]]], NArray.new(3), "Tridimensional Array: "
		assert_equal 69, NArray::count_dimensions(NArray.new(69)), "69-dimensional Array (no kidding!): "
	end

	def test_a_narray_can_be_created_from_a_litteral_array
		assert_equal [1,2,3], NArray.new([1,2,3])
		assert_equal [], @dn
		assert_equal [[1,2], [1,2]], NArray.new([[1,2], [1,2]])
		assert_equal [[[1,"a"], [[], 5]], [["test", Hash.new], [nil, [1,2]]]], @d3
		assert_equal NArray.new( [[1,2,3], [1,2,3], [1,2,3]] ), [[1,2,3], [1,2,3], [1,2,3]]
	end

	def test_a_narray_can_be_created_through_braces
		assert_equal NArray[], @dn
		assert_equal @d3b, @d3
		assert_equal @d3b.lengths, @d3.lengths
		assert_equal @d3b.dimensions, @d3.dimensions
		assert_equal NArray[].dimensions, @dn.dimensions
		assert_equal NArray[].lengths, @dn.lengths
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

	def test_square_parenthesis_return_expected_result
		assert_equal 1, @d3[0,0,0]
		assert_equal "a", @d3[0,0,1]
		assert_equal [], @d3[0,1,0]
		assert_equal 5, @d3[0,1,1]
		assert_equal "test", @d3[1,0,0]
		assert_equal Hash.new, @d3[1,0,1]
		assert_equal nil, @d3[1,1,0]
		assert_equal [1,2], @d3[1,1,1]
	end

	def test_chaining_square_parenthesis_return_expected_result
		assert_equal 1, @d3[0][0][0]
		assert_equal "a", @d3[0][0][1]
		assert_equal [], @d3[0][1][0]
		assert_equal 5, @d3[0][1][1]
		assert_equal "test", @d3[1][0][0]
		assert_equal Hash.new, @d3[1][0][1]
		assert_equal nil, @d3[1][1][0]
		assert_equal [1,2], @d3[1][1][1]
	end

	def test_two_ways_of_assigning_values
		@d2[0][0] = nil
		@d2[0, 1] = "q"
		assert_equal nil, @d2[0][0]
		assert_equal "q", @d2[0][1]
		assert_equal 2, @d2[1,0]
		assert_equal 2, @d2[1,1]
	end

	def test_length_should_return_the_right_dimensions
		assert_equal 2, @d3.length
		assert_equal 2, @d3.length(1)
		assert_equal 2, @d3.length(2)
		assert_equal 2, @d2.length
		assert_equal 2, @d2.length(1)
		assert_equal 4, NArray[[[[1,2,3,4]]],[[[9,8,7,6]]]].length(3)
	end

	def test_lengths_should_return_an_array_with_the_right_lengths
		assert_equal [2,2,2], @d3.lengths
		assert_equal [2,2], @d2.lengths
		assert_equal [3,2,2,1], NArray[[[[nil],[nil]],[[nil],[nil]]],
									 [[[nil],[nil]],[[nil],[nil]]],
									 [[[nil],[nil]],[[nil],[nil]]]].lengths
	end

	def test_size_should_return_the_total_number_of_elements
		assert_equal 8, @d3.size
		assert_equal 4, @d3.size
	end
end

