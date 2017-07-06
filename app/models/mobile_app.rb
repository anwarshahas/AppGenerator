class MobileApp

	def self.data_json
		json = {
			"components":[
					{
						"id": 1,
						"type":"app_lab_image",
						"data": {
							"uri":"https://media.playstation.com/is/image/SCEA/spider-man-screen-02-ps4-us-13jun16?$MediaCarousel_Original$"
						},
						"size": {
							"width": '36',
							"height": '30'
						},
						"position": {
							"top": '0',
							"left": '0'
						},
						"style": {

						}
					},
					{
						"id": 2,
						"type": "app_lab_text",
						"data": {
							"text": "Peter Parker"
						},
						"position": {
							"top": '31',
							"left": '13'
						},
						"style": {
							"alignSelf": 'stretch',
							"textAlign": 'center',
							"color": '#0000ff',
							"fontSize": 22,
						}
					},
					{
						"id": 3,
						"type":"app_lab_image",
						"data": {
							"uri":"https://media.playstation.com/is/image/SCEA/spider-man-screen-02-ps4-us-13jun16?$MediaCarousel_Original$"
						},
						"size": {
							"width": 100,
							"height": 100
						},
						"position": {
							"top": '26',
							"left": 20
						},
						"style": {

						}
					},
					{
						"id": 4,
						"type": "app_lab_text",
						"data": {
							"text": "**** it until you make it!!!"
						},
						"size": {
							"width": '36'
						},
						"position": {
							"top": '36',
							"left": '0'
						},
						"style": {
							"alignSelf": 'stretch',
							"textAlign": 'center',
							"color": '#ff0000',
							"fontSize": 22,
						}
					},
					{
						"id": 5,
						"type": "app_lab_text",
						"data": {
							"text": "Lorem ipsum dkfjdkf dkkjdkjfkdjfkdsjfkdjkjkj jdkfjdkfjdkfj dkj dsjkfjdskfj dj kdsjfkdjf k ksdjfkdfjd jdkfjdkf kdsfkdjfkdjfkdjfjdsf dkfdkfjdkfdkjfkl dksjfdkfjd dksjfdkfjkldsjfkdjfkdfjsdkfjds kjdkfjdfjdk dsjfkds fkjfkdjf idsjfkld fkldjskfljdkf jdkjfkldjfkdsj fkdjfkldsjfkdsjfdkjfdkljfkldj fkdj fl kjfdklsfj dklfjdlksf jdkljfkldjfkldj sfkljdkfdksfkdfkdsfdklsjfldkjfdkf jdksfj dklfjdkljfdlkj"
						},
						"size": {
							"width": '36'
						},
						"position": {
							"top": '40',
							"left": '0'
						},
						"style": {
							"padding": 5,
							"alignSelf": 'stretch',
							"textAlign": 'center',
							"color": '#222222',
							"fontSize": 22,
						}
					},
				],
			"name": "splash page",
			"id": 1,
			"init_page": true
		}
	end

	def self.clone_app
		mobile_apps_root_directory = "../../MobileApps"
		selected_mobile_app_directory = mobile_apps_root_directory + "/Masters/applabpoc"
		destination_mobile_app_directory = mobile_apps_root_directory + "/GenApps/applabpoc/"
		app_name = "chakka"
		destination_app_name = destination_mobile_app_directory+app_name
		FileUtils.mkdir_p(destination_mobile_app_directory) unless File.directory?(destination_mobile_app_directory)
		FileUtils.cp_r selected_mobile_app_directory, destination_app_name  unless File.exists?(destination_app_name)
		puts "Project created"
	end

	def self.set_android_sdk
		mobile_apps_root_directory = "../../MobileApps"
		destination_mobile_app_directory = mobile_apps_root_directory + "/GenApps/applabpoc/"
		app_name = "chakka"
		destination_app_name = destination_mobile_app_directory+app_name
		android_direcotory_path = destination_app_name + '/android/'
		file_name = 'local.properties'
		path = android_direcotory_path + file_name
		content = "lsdk.dir = /Users/Prometheus/Library/Android/sdk"
		File.open(path, "w+") do |f|
  			f.write(content)
		end
	end

	def self.code_generation
		mobile_apps_root_directory = "../../MobileApps"
		destination_mobile_app_directory = mobile_apps_root_directory + "/GenApps/applabpoc/"
		app_name = "chakka"
		destination_app_name = destination_mobile_app_directory+app_name
		source_directory_path = destination_app_name + '/app/screens/'

		file_name = 'splash.js'
		path = source_directory_path + file_name

		# generate class name
		class_name = self.class_name_generation('splash')
		# creating varibles, components and styles
		dynamic_code_segments = self.generate_dyanamic_code(4)
		# picking varibles from stack
		variables = dynamic_code_segments.first
		# picking components from stack
		components = dynamic_code_segments.second
		# picking styles from stack
		styles_sheet = dynamic_code_segments.last
		# creating retun view of render method
		return_view = self.return_view(components)
		# creating render function
		render_function = self.render_function(variables, return_view)

		File.open(path, "w+") do |f|
  			f.write(self.header_files)
  			f.write(self.class_declaration(class_name, render_function))
  			f.write(self.style_sheet_generation(styles_sheet))
  			f.write(self.export_class('splash'))
		end
	end

	def self.header_files
		headers = []
		headers << "import React, { Component } from 'react';"
		headers << "import { View, Image, Text, StyleSheet } from 'react-native';"
		headers << "import AppLabImage from '../components/appLabImage';"
		headers << "import AppLabText from '../components/appLabText';"
		headers << "import * as sizeClass from '../constants/sizeClass';"

		header_string = ""
		headers.each do |h|
			header_string = header_string + h + self.new_line(1)
		end
		AppLabConstants::HEADERSTART + header_string + AppLabConstants::HEADEREND + self.new_line(1)
	end

	def self.class_declaration(class_name, render_function)
		class_name_declaration = AppLabConstants::CLASS + class_name + AppLabConstants::EXTENDS + AppLabConstants::COMPONENTS + " " + AppLabConstants::CURLBRACKETOPEN + self.new_line(2)
		class_body = render_function
		class_declaration_closing =  AppLabConstants::CURLBRACKETCLOSE + self.new_line(1)
		class_declaration = class_name_declaration +
								class_body +
							class_declaration_closing
		AppLabConstants::CLASSDECLRATIONSTART + class_declaration + AppLabConstants::CLASSDECLRATIONEND + self.new_line(1)
	end

	def self.class_name_generation(file_name)
		words = file_name.split(/[\s_]/)
		class_name = ""
		words.each do |w|
			class_name = class_name + w.capitalize
		end
		class_name
	end

	def self.generate_dyanamic_code(count)
		components = self.data_json[:components]
		variables = ""
		stack_views = ""
		styles = ""
		styles = styles + self.main_container_style
		components.each do |c|
			stack_views = stack_views + self.generate_component_with_view(count, c)
			styles = styles + self.component_view_style(c) + self.component_style(c)
			variables = variables + self.variables_declaration(c)
		end
		[variables, stack_views, styles] 
	end

	def self.variables_declaration(component)
		variables = []
		variables << "let " + self.camel_case(component[:type]) + component[:id].to_s + " = " + component[:data].to_json
		variables_string = ""
		variables.each do |v|
			variables_string = variables_string + self.tabs(2) + v + "\n"
		end
		variables_string
	end

	def self.main_container_style
		string = self.tabs(1) + "mainContainer" + " : {" + self.new_line(1)
		variables = []
		variables << "flex: 1"
		variables << "flexDirection: 'column'"
		variables_string = ""
		variables.each do |v|
			variables_string = variables_string + self.tabs(2) + v + "," + "\n"
		end
		string + variables_string + self.tabs(1) + "}" + "," + self.new_line(1)
	end

	def self.generate_component_with_view(count, component)
		type = component[:type]
		self.tabs(count) + "<View style= { styles." + self.camel_case(type)+ component[:id].to_s + "View" + " }>" + self.new_line(1) +
		self.tabs(count+1) + self.generate_component(component) + self.new_line(1) +
		self.tabs(count) + "</View>" + self.new_line(1)
	end

	def self.component_view_style(component)
		string = ""
		string = self.tabs(1) + self.camel_case(component[:type]) + component[:id].to_s + "View" + " : {" + self.new_line(1)
		flex_count = 1
		case component[:type]
		when "app_lab_image"
			flex_count = 3
		when "app_lab_text"
			flex_count = 1
		end

		variables = []
		# variables << "flex: " + flex_count.to_s
		# variables << "flexDirection: 'row'"
		# variables << "justifyContent: 'center'"
		# variables << "alignItems: 'center'"
		variables_string = ""
		variables.each do |v|
			variables_string = variables_string + self.tabs(2) + v + "," + "\n"
		end
		string + variables_string + self.tabs(1) + "}" + "," + self.new_line(1) 
	end

	def self.component_style(component)
		string = ""
		string = self.tabs(1) + self.camel_case(component[:type]) + component[:id].to_s + " : {" + self.new_line(1)
		variables = []
		variables << "position: " + "'absolute'"
		if component[:size].present?
			if component[:size][:width].present?
				if component[:size][:width].is_a? Integer
					variables << "width: " + (component[:size][:width].to_f).to_s 
				else
					variables << "width: " + "sizeClass.winWidth * " + (component[:size][:width].to_f/AppLabConstants::GRIDWIDTHCOUNT).to_s 
				end
			end
			if component[:size][:height].present?
				if component[:size][:height].is_a? Integer
					variables << "height: " + (component[:size][:height].to_f).to_s
				else
					variables << "height: " +  "sizeClass.winHeight * " + (component[:size][:height].to_f/AppLabConstants::GRIDHEIGHTCOUNT).to_s
				end
			end
		end
		if component[:position].present?
			if component[:position][:top].present?
				if component[:position][:top].is_a? Integer
					variables << "top: " + (component[:position][:top].to_f).to_s
				else
					variables << "top: " + "sizeClass.winHeight * " + (component[:position][:top].to_f/AppLabConstants::GRIDHEIGHTCOUNT).to_s
				end
			end
			if component[:position][:left].present?
				if component[:position][:left].is_a? Integer
					variables << "left: " + (component[:position][:left].to_f).to_s
				else
					variables << "left: " + "sizeClass.winWidth * " + (component[:position][:left].to_f/AppLabConstants::GRIDWIDTHCOUNT).to_s
				end
			end
		end
		if component[:style].present?
			styles = component[:style]
			styles.each do |key, value|
				if value.is_a? Integer
					variables << key.to_s + ": " + value.to_s
				else
					variables << key.to_s + ": " + "'" + value.to_s + "'"
				end
			end
		end
		
		# case component[:type]
		# when "app_lab_image"
		# 	variables << "position: " + "'absolute'"
		# 	variables << "width: " + "sizeClass.winWidth * " + (component[:size][:width]/20.0).to_s 
		# 	variables << "height: " +  "sizeClass.winHeight * " + (component[:size][:height]/20.0).to_s
		# 	variables << "top: " + "sizeClass.winHeight * " + (component[:position][:top]/20.0).to_s
		# 	variables << "left: " + "sizeClass.winWidth * " + (component[:position][:left]/20.0).to_s
		# when "app_lab_text"
		# 	variables << "position: " + "'absolute'"
		# 	variables << "alignSelf: " + "'" + "stretch" + "'"
		# 	variables << "textAlign: " + "'" + "center" + "'"
		# 	variables << "color: " + "'" + component[:color] + "'"
		# 	variables << "fontSize: " + component[:size].to_s
		# 	variables << "top: " + "sizeClass.winHeight * " + (component[:position][:top]/20.0).to_s
		# 	variables << "left: " + "sizeClass.winWidth * " + (component[:position][:left]/20.0).to_s
		# end
		variables_string = ""
		variables.each do |v|
			variables_string = variables_string + self.tabs(2) + v + "," + "\n"
		end
		string + variables_string + self.tabs(1) + "}" + "," + self.new_line(1)
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

	def self.generate_component(component)
		type = component[:type]
		id = component[:id]
		component_name = self.component_name_generation(type)
		variable_name = self.camel_case(type) + id.to_s
		"<" + component_name + " data = {" + variable_name + "} style = {styles." + variable_name +  "} />"
	end

	def self.component_name_generation(component_name)
		words = component_name.split(/[\s_]/)
		variable_name = ""
		words.each_with_index do |w, index|
			variable_name = variable_name + w.capitalize
		end
		variable_name
	end

	def self.return_view(components)
		self.tabs(2) + "return (" + self.new_line(1) +
		self.jsx_template_generation(3, components) +
		self.tabs(2) + ");" + self.new_line(1)
	end

	def self.render_function(variables, return_view)
		string = self.tabs(1) + AppLabConstants::RENDER + " " + AppLabConstants::CURLBRACKETOPEN + self.new_line(1) + self.tabs(2) + AppLabConstants::VARIABLEDECLRATIONSTART
		string = string + variables + self.tabs(2) + AppLabConstants::VARIABLEDECLRATIONEND
		string + return_view + self.tabs(1) + AppLabConstants::CURLBRACKETCLOSE + self.new_line(1)
	end

	def self.jsx_template_generation(count, components)
		self.tabs(count) + "<View style= { styles.mainContainer }>" + self.new_line(1) +
		components +
		self.tabs(count) + "</View>" + self.new_line(1)
	end

	def self.style_sheet_generation(style)
		varible_decl = 'const styles = StyleSheet.create({' + self.new_line(1)
		end_line = '});' + self.new_line(2)
		varible_decl + style + end_line
	end

	def self.export_class(name)
		"export default " + self.class_name_generation(name)
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

	def build_apk(destination_app_name)
		Dir.chdir(destination_app_name) {
			FileUtils.mkdir_p('android/app/src/main/assets') unless File.directory?('android/app/src/main/assets')
			puts "asset directory created"
			cmd = "react-native bundle --platform android --dev true --entry-file index.android.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res/"
  			%x[#{cmd}]
  			puts "bundle sucessess"
  			Dir.chdir('android') {
  				cmd = './gradlew assembleDebug'
  				%x[#{cmd}]
  			}
  			puts "build success"
		}
	end

end