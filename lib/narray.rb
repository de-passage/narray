# Multidimensional array for Ruby

class NArray < Array
	attr_reader :dimensions
	def initialize dimensions = nil, *values, &blck
		# Make a difference between no arguments and nil
		values = NArray::_extract values

		# In case the only parameter is a NArray, duplicate it
		if dimensions.is_a? NArray and  !NArray::_arg? values
			self.replace dimensions.dup

		# In case the parameter is an array, multiple possibilities
		elsif dimensions.is_a? Array
			# 1) The array decribes dimensions and provide a default value to fill in the blanks
			if NArray.is_valid_description? dimensions and (NArray::_arg? values or block_given?)
				# then we build the n-array recursively and fill the values with what has been provided
				@dimensions = dimensions.length
				@dimensions == 1 ?
					# A little detour to avoid warnings on nil values
					!NArray::_arg?(values) ? super(dimensions[0], &blck) : super(dimensions[0], values) :
					super( [*0...dimensions[0]].map { NArray.new(dimensions.drop(1), values, &blck) } )

			# 2) the array does not provide a default value
			elsif !NArray::_arg? values and !block_given?
				# then we create a NArray fitting the litteral given
				@dimensions = NArray.count_dimensions dimensions #inefficient but GTD
				@dimensions == 1 ?
					super(dimensions) : # giving a block here has no effect with mri and the doc doesn't say anything
					super(dimensions.map { |e| NArray.new(e) })

			# 3) the array is not a valid description but a default value is given, i.e. user mistake. Scold him!
			else
				raise RuntimeError, "#{dimensions} is not a valid description: 
				An array of striclty positive Integers is expected"
			end

		# In case the dimension is valid
		elsif NArray.is_valid_dimension? dimensions
			@dimensions = dimensions
			if dimensions == 1
				super([], &blck)
			else 
				super([NArray.new(dimensions - 1, values, &blck)])
			end

		# Empty constructor
		elsif dimensions.nil? and !NArray::_arg? values
			super(&blck)

		# Bad user, bad
		else
			raise RuntimeError \
				"Invalid dimension (expecting an Integer or array of Integer all strictly positives, got #{dimensions}"
		end
	end

	# Returns an array of the lengths of each dimension
	def lengths
		NArray.calculate_dimensions(self)
	end

	# Fetch the value at the position of the arguments
	#
	# In case the argument contains nil values, returns a NArray of the elements 
	# satisfying the coordinates given by the arguments (to-do)
	def [] *pos
		raise "1..#{dimensions} arguments expected, given #{pos.length}" if pos.length > dimensions or pos.length == 0
		pos.length == 1 ? super(*pos) : super(pos[0])[*pos.drop(1)]
	end

	# Sets the value at the position of the arguments
	def []= *pos, v
		raise "#{dimensions} arguments expected, given #{pos.length}" if pos.length != dimensions
		pos.length == 1 ? super(*pos, v) : self[pos[0]][*pos.drop(1)] = v
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

		# Check whether the argument is a valid dimension
		#
		# Returns true if dimensions is a strictly positive Integer, false otherwise
		def is_valid_dimension? dimensions
			dimensions.is_a? Integer and dimensions > 0
		end

		# Check whether the argument is a valid description of dimensions
		#
		# Returns true if the argument is an Array of values satisfying is_valid_dimension?, false otherwise
		def is_valid_description? dimensions
			dimensions.is_a? Array and dimensions.all? { |e| is_valid_dimension? e }
		end

		# Create a n-array fitting the given description
		def[] *description
			NArray.new(description)
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

		public
			def _extract args
				raise ParameterError, "Expected 1..2 arguments, got #{args.length + 1}" if args.length > 1	
				args.length == 1 ? args[0] : NArray::EmptyArgument.new
			end
			
			def _arg? arg
				!arg.is_a? NArray::EmptyArgument
			end
	end
	private
	class EmptyArgument
	end
end
