class MobileApp

	def self.data_json
		json = {
			"page":{
				"components":[
					{
						"component": {
							"type":"app_lab_image",
							"image_url":"",
							"size": {
								"width":100,
								"height":100
							}
						},
						"position": {

						}
					},
					{
						"component": {
							"type": "app_lab_text",
							"text": "Hi how you doing??????",
							"color": "#ffdd33",
							"size": 18
						},
						"position": {

						}
					}
				],
				"name": "splash page",
				"id": 123,
				"init_page": true
			}
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
		File.open(path, "w+") do |f|
  			f.write(self.header_files)
  			f.write(self.class_declaration(self.class_name_generation('splash')))
		end
	end

	def self.variables_declaration
		variables = []
		variables << "let splashIcon = {uri: 'https://facebook.github.io/react/img/logo_og.png'};"
		variables << "let splashText = 'All Rights Reserved Facebook';"
		variables_string = ""
		variables.each do |v|
			variables_string = variables_string + self.tabs(2) + v + "\n"
		end
		variables_string
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

	def self.return_view
		self.tabs(2) + "return (" + "\n" +
		self.template_generation +
		self.tabs(2) + ");" + "\n"
	end

	def self.template_generation
		self.template_componet(3)
	end

	def self.template_componet(count)
		components = self.data_json[:page][:components]
		self.tabs(count) + "<View style= { styles.mainContainer }>" + self.new_line(1) +
		self.components(count+1, components) +
		self.tabs(count) + "</View>" + self.new_line(1)

	end

	def self.components(count ,components)
		stack_views = ""
		components.each do |c|
			type = c[:component][:type]
			stack_views = stack_views +	self.tabs(count) + "<View style= { styles." + self.camel_case(type) + " }>" + self.new_line(1) +
			self.tabs(count+1) + self.component(type) + self.new_line(1) +
			self.tabs(count) + "</View>" + self.new_line(1)
		end
		stack_views
	end

	def self.component(type)
		case type
		when "app_lab_image"
			"<AppLabImage data = {splashIcon} style = {{'width': 100, 'height': 100}} />"
		when "app_lab_text"
			"<AppLabText style = {{alignSelf: 'stretch', textAlign: 'center'}} text = {splashText} />"
		end
	end

	def self.render_function
		string = self.tabs(1) + AppLabConstants::RENDER + " " + AppLabConstants::CURLBRACKETOPEN + self.new_line(1) + self.tabs(2) + AppLabConstants::VARIABLEDECLRATIONSTART
		string = string + self.variables_declaration + self.tabs(2) + AppLabConstants::VARIABLEDECLRATIONEND
		string + self.return_view + self.tabs(1) + AppLabConstants::CURLBRACKETCLOSE + self.new_line(1)
	end

	def self.class_declaration(class_name)
		class_declaration = AppLabConstants::CLASS + class_name + AppLabConstants::EXTENDS + AppLabConstants::COMPONENTS + " " + AppLabConstants::CURLBRACKETOPEN + self.new_line(2)  + self.render_function +  AppLabConstants::CURLBRACKETCLOSE
		"\n" + AppLabConstants::CLASSDECLRATIONSTART + class_declaration + self.new_line(1) + AppLabConstants::CLASSDECLRATIONEND
	end

	def self.class_name_generation(file_name)
		words = file_name.split(/[\s_]/)
		class_name = ""
		words.each do |w|
			class_name = class_name + w.capitalize
		end
		class_name
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

	def self.header_files
		headers = []
		headers << "import React, { Component } from 'react';"
		headers << "import { View, Image, Text, StyleSheet } from 'react-native';"
		headers << "import AppLabImage from '../components/appLabImage';"
		headers << "import AppLabText from '../components/appLabText';"

		header_string = ""
		headers.each do |h|
			header_string = header_string + h + self.new_line(1)
		end
		AppLabConstants::HEADERSTART + header_string + AppLabConstants::HEADEREND
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