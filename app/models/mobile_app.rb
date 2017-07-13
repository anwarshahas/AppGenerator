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
						},
						"components": [
							{
								"id": 2,
								"type": "app_lab_image",
								"data": {
									"uri":"https://media.playstation.com/is/image/SCEA/spider-man-screen-02-ps4-us-13jun16?$MediaCarousel_Original$"
								},
								"size": {
									"width": 80,
									"height": 80
								},
								"position": {
									
								},
								"style": {
									"padding": 2,
								    "alignSelf": 'center',
								    "backgroundColor": '#ffffff'
								}
							},
							{
								"id": 3,
								"type": "app_lab_text",
								"data": {
									"text": "Peter Parker is here"
								},
								"position": {
									
								},
								"style": {
									"alignSelf": 'stretch',
									"textAlign": 'center',
									"color": '#0000ff',
									"fontSize": 22,
									"marginLeft": 10,
									"marginTop": 70,
									"backgroundColor": '#00000000'
								}
							},
						]
					},
					{
						"id": 4,
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
						"id": 5,
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
						"id": 6,
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
							"fontSize": 20,
						}
					},
					{
						"id": 7,
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
							"fontSize": 16,
						}
					},
				],
			"name": "splash page",
			"id": 1,
			"init_page": true
		}
	end

	def self.clone_app(selected_app, project_name)
		mobile_apps_root_directory = "../../MobileApps"
		selected_mobile_app_directory = mobile_apps_root_directory + "/Masters/" + selected_app
		destination_mobile_app_directory = mobile_apps_root_directory + "/GenApps/" + selected_app + "/"
		app_name = project_name
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

	def self.code_generation(selected_app, project_name, pages)
		mobile_apps_root_directory = "../../MobileApps"
		destination_mobile_app_directory = mobile_apps_root_directory + "/GenApps/" + selected_app + "/"
		app_name = project_name
		destination_app_name = destination_mobile_app_directory+app_name
		source_directory_path = destination_app_name + '/app/screens/'
		FileUtils.rm_rf Dir.glob("#{source_directory_path}/*")
		pagesList = self.screens(source_directory_path, pages)
		AppRootFile.generate_route_file(selected_app, project_name, pagesList)
	end

	def self.screens(source_directory_path, pages)
		pagesList = []
		init_page = ""
		pages.each do |page|
			components = page[:components]
			screen_code_generation(components, page[:name], source_directory_path)
			if page[:init_page]
				pagesList.insert(0, page[:name]).flatten
			else
				pagesList << page[:name]
			end
		end
		pagesList
	end

	def self.screen_code_generation(components, screen_name, source_directory_path)
		file_name =  Helper.file_name_generation(screen_name)
		path = source_directory_path + file_name

		# generate class name
		class_name = Helper.class_name_generation(screen_name)
		# creating varibles, components and styles
		dynamic_code_segments = self.generate_dyanamic_code(4, components)
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
  			f.write(self.export_class(screen_name))
		end
	end

	def self.header_files
		headers = []
		headers << "import React, { Component } from 'react';"
		headers << "import { View, Image, Text, StyleSheet } from 'react-native';"
		headers << "import AppLabImage from '../components/appLabImage';"
		headers << "import AppLabText from '../components/appLabText';"
		headers << "import AppLabButton from '../components/appLabButton';"
		headers << "import AppLabEventDetailsTile from '../components/appLabEventDetailsTile';"
		headers << "import * as sizeClass from '../constants/sizeClass';"

		header_string = ""
		headers.each do |h|
			header_string = header_string + h + Helper.new_line(1)
		end
		AppLabConstants::HEADERSTART + header_string + AppLabConstants::HEADEREND + Helper.new_line(1)
	end

	def self.class_declaration(class_name, render_function)
		class_name_declaration = AppLabConstants::CLASS + class_name + AppLabConstants::EXTENDS + AppLabConstants::COMPONENTS + Helper.spaces(1) + AppLabConstants::CURLBRACKETOPEN + Helper.new_line(2)
		class_body = render_function
		class_declaration_closing =  AppLabConstants::CURLBRACKETCLOSE + Helper.new_line(1)
		class_declaration = class_name_declaration +
								class_body +
							class_declaration_closing
		AppLabConstants::CLASSDECLRATIONSTART + class_declaration + AppLabConstants::CLASSDECLRATIONEND + Helper.new_line(1)
	end

	def self.generate_dyanamic_code(count, components, variables="", stack_views="", styles=self.main_container_style)
		components.each do |component|
			stack_views = stack_views + self.views_code_generation(count, component)
			styles = styles + self.style_code_generation(component)
			variables = variables + self.variables_code_generation(component)
		end
		[variables, stack_views, styles] 
	end

	def self.variables_code_generation(component)
		variables = []
		components = component[:components]
		if component[:data].present?
			variables << "let " + Helper.camel_case(component[:type]) + component[:id].to_s + " = " + component[:data].to_json
		end
		if component[:action].present? && component[:action][:enabled]
			variables << "let " + Helper.camel_case(component[:type]) + "Action" + component[:id].to_s + " = " + component[:action].to_json
		end
		variables_string = ""
		variables.each do |variable|
			if components.present?
				variables_string = variables_string + Helper.tabs(2) + variable + Helper.new_line(1) + self.variable_code_generation_from_sub_components(components)
			else
				variables_string = variables_string + Helper.tabs(2) + variable + Helper.new_line(1)
			end
		end
		variables_string
	end

	def self.variable_code_generation_from_sub_components(components)
		variables = ""
		components.each do |c|
			variables = variables + self.variables_code_generation(c)
		end
		variables
	end

	def self.main_container_style
		variables = []
		variables << "flex: 1"
		variables << "flexDirection: 'column'"
		variables_string = ""
		variables.each do |v|
			variables_string = variables_string + Helper.tabs(2) + v + "," + Helper.new_line(1)
		end
		Helper.tabs(1) + "mainContainer : {" + Helper.new_line(1) +
			variables_string +
		Helper.tabs(1) + "}," + Helper.new_line(1)
	end

	def self.style_code_generation(component)
		string = ""
		components = component[:components]
		string = Helper.tabs(1) + Helper.camel_case(component[:type]) + component[:id].to_s + " : {" + Helper.new_line(1)
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
		
		variables_string = ""
		variables.each do |v|
			variables_string = variables_string + Helper.tabs(2) + v + "," + Helper.new_line(1)
		end
		if components.present?
			string + variables_string + Helper.tabs(1) + "}" + "," + Helper.new_line(1) + self.style_code_generation_from_sub_components(components)
		else
			string + variables_string + Helper.tabs(1) + "}," + Helper.new_line(1)
		end
	end

	def self.style_code_generation_from_sub_components(components)
		styles = ""
		components.each do |c|
			styles = styles + style_code_generation(c)
		end
		styles
	end

	def self.views_code_generation(count, component)
		type = component[:type]
		id = component[:id]
		components = component[:components]
		component_name = self.component_name_generation(type)
		variable_name = Helper.camel_case(type) + id.to_s
		action_variable_name = Helper.camel_case(type) + "Action" + id.to_s
		if components.present?
			if component[:action].present? && component[:action][:enabled]
				Helper.tabs(count) + "<" + component_name + " data = {" + variable_name + "} style = {styles." + variable_name +  "} " + "navigation = {this.props.navigation} " + " action = {" + action_variable_name + "} " + " >" + Helper.new_line(1) +
					self.views_code_generation_from_sub_components(count, components) +
				Helper.tabs(count) + "</" + component_name + ">" + Helper.new_line(1)
			else
				Helper.tabs(count) + "<" + component_name + " data = {" + variable_name + "} style = {styles." + variable_name +  "}" + " >" + Helper.new_line(1) +
					self.views_code_generation_from_sub_components(count, components) +
				Helper.tabs(count) + "</" + component_name + ">" + Helper.new_line(1)
			end
		else
			if component[:action].present? && component[:action][:enabled]
				Helper.tabs(count) + "<" + component_name + " data = {" + variable_name + "} style = {styles." + variable_name +  "} " + "navigation = {this.props.navigation} " + " action = {" + action_variable_name + "} " + " />" + Helper.new_line(1)
			else
				Helper.tabs(count) + "<" + component_name + " data = {" + variable_name + "} style = {styles." + variable_name +  "}" + " />" + Helper.new_line(1)
			end
		end
	end

	def self.views_code_generation_from_sub_components(count, components)
		stack_views = ""
		components.each do |c|
			stack_views = stack_views + self.views_code_generation(count+1, c)
		end
		stack_views 
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
		Helper.tabs(2) + "return (" + Helper.new_line(1) +
			self.jsx_template_generation(3, components) +
		Helper.tabs(2) + ");" + Helper.new_line(1)
	end

	def self.render_function(variables, return_view)
		Helper.tabs(1) + AppLabConstants::RENDERFUNCTIONSTART +
		Helper.tabs(1) + AppLabConstants::RENDER + Helper.spaces(1) + AppLabConstants::CURLBRACKETOPEN + Helper.new_line(1) + 
			Helper.tabs(2) + AppLabConstants::VARIABLEDECLRATIONSTART +
			variables + 
			Helper.tabs(2) + AppLabConstants::VARIABLEDECLRATIONEND +
			Helper.tabs(2) + AppLabConstants::RETURNSTART +
			return_view + 
			Helper.tabs(2) + AppLabConstants::RETURNEND +
		Helper.tabs(1) + AppLabConstants::CURLBRACKETCLOSE + Helper.new_line(1) +
		Helper.tabs(1) + AppLabConstants::RENDERFUNCTIONEND
	end

	def self.jsx_template_generation(count, components)
		Helper.tabs(count) + "<View style= { styles.mainContainer }>" + Helper.new_line(1) +
			components +
		Helper.tabs(count) + "</View>" + Helper.new_line(1)
	end

	def self.style_sheet_generation(style)
		AppLabConstants::STYLESHEETSTART +
		'const styles = {' + Helper.new_line(1) +
			style +
		'};' + Helper.new_line(1) +
		AppLabConstants::STYLESHEETEND + Helper.new_line(1)
	end

	def self.export_class(name)
		"export default " + Helper.class_name_generation(name)
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