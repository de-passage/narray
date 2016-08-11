# Multidimensional array for Ruby

class NArray < Array
	def initialize dimensions = nil, *values, &blck
		if dimensions.is_a? NArray
			self.replace dimensions
		elsif dimensions.is_a? Array
			NArray.is_well_formed? dimensions
			@dimensions = calculate_dimensions dimensions
			super dimensions
		end
	end

	class << self
		# Returns the number of dimensions that can be generated from the argument while keeping the array well-formed
		#
		# Checks the maximum level of nesting so that any n-vector {v1, v2...vn} with 0 <= vm < length(m) correctly refers to an element in the structure
		def count_dimensions array
			calculate_dimensions(array).length
		end

		# Return an array of lengths for a n-array
		def calculate_dimensions array
			_count(array).take_while { |e| e >= 0 }
		end

		private
			def _count array, n = [], d = 0
				unless array.is_a? Array # if not an array, set the dimension as beeing incoherent
					n[d] = -1
					return n # and abort
				end

				# if length <= depth it means this dimension hasn't been explored yet, so we set it at the first value we encounter
				n << array.length if n.length <= d

				if array.length != n[d] #or n[d] < 0  # the second part should never be executed since array.length >= 0 (if n[d] < 0 then the first test automatically fails)
					# The dimension is in an incoherent state, abort
					n[d] = -1
					return n
				end

				# At this point the array is still in a coherent state, we just need to check sub elements unless we already know that we can't proceed further because of previous results
				array.each do |e|
					if n.length > d + 1 and n[d + 1] < 0 # In case the next element has already been decided to be incoherent
						return n # Abort
					end
					_count e, n, d + 1
				end
				n
			end

	end
end
