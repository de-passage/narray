# Multidimensional array for Ruby

class NArray < Array
	attr_reader :dimensions
	def initialize dimensions, values = nil
		if dimensions.is_a? Array and dimensions.each { |d| NArray.valid_dimension? d }
			@dimensions = dimensions.length
			if @dimensions > 1 
				super(dimensions[0]).map! { |e| NArray.new(dimensions.slice(1..-1), values) }
			else
				super(dimensions[0], values)
			end
		elsif NArray.valid_dimension? dimensions
			@dimensions = dimensions
		else
			raise "Invalid dimensions"
		end
	end

	def [] position, *positions
		raise "#{positions.length + 1} positions instead of #{dimensions}" unless positions.length + 1 == dimensions
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

	def length d = 0
		raise "Invalid dimension" if d < 0 or d > dimensions - 1
		d == 0 ? super() : _at(0).length(d - 1)
	end

	private
	def self.valid_dimension? dimension
		dimension.is_a? Integer and dimension >= 0
	end

	def _at i
		Array.instance_method(:[]).bind(self).call i
	end

end


n = NArray.new([3, 2, 4], 42)
n[0, 1, 3] = "a"
n[0,0,0] = 0
puts n.inspect
for i in 0...n.dimensions
	puts "dimension #{i}.length == #{n.length(i)}"
end
