class Helper

	def self.spaces(count)
		spaces = ""
		for i in 1..count
			spaces = spaces + " "
		end
		spaces
	end

	def self.tabs(count)
		tabs = ""
		for i in 1..count
			tabs = tabs + "\t"
		end
		tabs
	end

	def self.new_line(count)
		new_lines = ""
		for i in 1..count
			new_lines = new_lines + "\n"
		end
		new_lines
	end

	def self.camel_case(component_name)
		words = component_name.split(/[\s_]/)
		variable_name = ""
		words.each_with_index do |w, index|
			if index == 0
				variable_name = w.downcase
			else
				variable_name = variable_name + w.capitalize
			end
		end
		variable_name
	end

	def self.class_name_generation(file_name)
		words = file_name.split(/[\s_]/)
		class_name = ""
		words.each do |w|
			class_name = class_name + w.capitalize
		end
		class_name
	end

	def self.file_name_generation(file_name)
		self.class_name_generation(file_name) + ".js"
	end

end