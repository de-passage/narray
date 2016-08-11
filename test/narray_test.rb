require "minitest/autorun"
require "minitest/spec"
require_relative "../lib/narray"

class TestNArray < MiniTest::Test
	def test_narray_should_be_created_coherent 
		valid = [ NArray[], NArray[1,2,3], NArray[[1,2], [3,4]], NArray[[[1,2], [1,2]], [[1, nil], [1, 2]]] ]
		valid.each_with_index do |a, i| 
			assert a.is_a? NArray 
			if i == 0 
				assert a.dimensions == 1, "nb.#{i} > #{a}"
			else 
				assert a.dimensions == i
			end
		end
	end

	def test_narray_should_equal_itself_only
		array_2d = NArray[[1,2,3],
						  [4,5,6]]
		dif_array_2d = NArray[[0,2,3],
							  [4,5,6]]
		array_3d = NArray[[[0,1], [2,3]],
					 	  [[4,5], [6,7]]]
		array_2d_d = array_2d.dup 
		assert_equal(array_2d, array_2d_d)
		assert_equal(array_2d, array_2d)
		refute_equal(array_2d, dif_array_2d)
		refute_equal(array_2d, array_3d)
	end

end

