# Multidimensional array for Ruby

class NArray < Array
	attr_reader :dimensions
	def initialize dimensions, values = nil, &blck
		if dimensions.is_a? Array and dimensions.each { |d| NArray.valid_dimension? d }
			@dimensions = dimensions.length
			if @dimensions > 1 
				super(dimensions[0]).map! { |e| NArray.new(dimensions.slice(1..-1), values, &blck) }
			else
				if block_given?
					super(dimensions[0], &blck)
				else
					super(dimensions[0], values)
				end
			end
		elsif NArray.valid_dimension? dimensions
			@dimensions = dimensions
			if @dimensions > 1
				super(1) { NArray.new(dimensions - 1, values, &blck) }
			else 
				if block_given?
					super(0, &blck)
				else
					super(0, values)
				end
			end
		else
			raise "Invalid dimensions (must be a strictly positive integer or an array of lengths)"
		end
	end

	def [] position, *positions
		positions.empty? ? super(position) : super(position)[*positions]
	end

	def []= position, *positions, value
		raise "#{positions.length + 1} positions instead of #{dimensions}" unless positions.length + 1 == dimensions
		if positions.empty? 
			super position, value
		else
			_at(position)[*positions] = value
		end
	end

	def at(*positions)
		raise "#{positions.length + 1} positions instead of #{dimensions}" unless positions.length == dimensions
		self[*positions]
	end

	def length d = 0
		raise "Invalid dimension" if d < 0 or d > dimensions - 1
		d == 0 ? super() : _at(0).length(d - 1)
	end
	
	def lengths
		if dimensions == 1
			[length]
		else
			[length, *_at(0).lengths]
		end
	end

	def each &blck 
		if dimensions > 1 
			for i in 0...length
				_at(i).each(&blck)
			end
		else
			super
		end
	end

	def each_with_index index = [], &blck
		if dimensions > 1
			for i in 0...length
				_at(i).each_with_index [*index, i], &blck
			end
		else
			for i in 0...length
				yield [*index, i], at(i)
			end
		end
	end

	def size 
		flatten.length
	end

	def flatten
		inject([]) { |ary, e| ary << e }	
	end

	def collect &blck
		ret = []
		if dimensions > 1 
			for i in 0...length
				ret << _at(i).collect(&blck)
			end
		else
			for i in 0...length
				ret << (yield at(i))
			end
		end
		ret
	end

	def map &b
		collect(&b)
	end

	def push d, value
		correct_dimension? d
		if d == 0 
			if dimensions == 1
				super(value)
			else
				super(NArray.new(lengths.drop(1), value))
			end
		else 
			_each { |e| e.push(d - 1, value) }
		end
	end

	def insert
		correct_dimension? d
		if d == 0 
			if dimensions == 1
				super(value)
			else
				super(NArray.new(lengths.drop(1), value))
			end
		else 
			_each { |e| e.insert(d - 1, value) }
		end
	end

	def unshift d, value
		correct_dimension? d
		if d == 0 
			if dimensions == 1
				super(value)
			else
				super(NArray.new(lengths.drop(1), value))
			end
		else 
			_each { |e| e.unshift(d - 1, value) }
		end
	end

	def << ary

	end

	private
	def self.valid_dimension? dimension
		dimension.is_a? Integer and dimension >= 0
	end

	def correct_dimension? d
		raise "Invalid dimension (nb #{d} out of #{dimensions}, starts at 0)" if d >= dimensions or !NArray.valid_dimension?(d)
	end

	def _at i
		Array.instance_method(:[]).bind(self).call i
	end

	def _each &blck
		for i in 0...length
			yield _at(i)
		end
	end

end
