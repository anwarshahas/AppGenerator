class AppRootFile

	def self.data_json
		data = {
			"pages": [
				"splash",
				#"list",
				#"details"
				],
			"init_page":"splash"
		}
	end

	def self.generate_route_file(selected_app, project_name, pages)
		mobile_apps_root_directory = "../../MobileApps"
		destination_mobile_app_directory = mobile_apps_root_directory + "/GenApps/" + selected_app + "/"
		app_name = project_name
		destination_app_name = destination_mobile_app_directory+app_name
		source_directory_path = destination_app_name + '/app/config/'

		file_name = 'router.js'
		path = source_directory_path + file_name

		File.open(path, "w+") do |f|
  			f.write(self.header_files(pages))
  			f.write(self.generate(pages))
		end
		
	end

	def self.header_files(pages)
		headers = []
		headers << "import { StackNavigator } from 'react-navigation';"
		pages.each do |page|
			headers << "import " + Helper.class_name_generation(page) + " from '../screens/" + Helper.class_name_generation(page) + "';"
		end
		header_string = ""
		headers.each do |h|
			header_string = header_string + h + Helper.new_line(1)
		end
		AppLabConstants::HEADERSTART + header_string + AppLabConstants::HEADEREND + Helper.new_line(1)
	end

	def self.generate(pages)
		"export const Root = StackNavigator ({" + Helper.new_line(1) +
			self.screens(pages) +
		"});"
	end

	def self.screens(pages)
		screens = ""
		pages.each do |page| 
			screens = screens + self.screen(page)
		end
		screens
	end

	def self.screen(page)
		Helper.tabs(1) + Helper.class_name_generation(page) + ": {" + Helper.new_line(1) +
    		Helper.tabs(2) + "screen: " + Helper.class_name_generation(page) + Helper.new_line(1) +
  		Helper.tabs(1) + "}," + Helper.new_line(1)
	end
end