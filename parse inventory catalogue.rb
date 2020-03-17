class Device
	
	# define getters and setters
	attr_accessor :category, :batteryLife, :modelNum, :color, :manufacturer, :status, :yearBuilt, :price, :features


	def initialize (category, batteryLife, modelNum, color, manufacturer, status, yearBuilt, price, features)
		# format each attribute when initialize to properly sort Devices in inventory with custom comparator method
		@category = category.capitalize
		@batteryLife = batteryLife.downcase
		@modelNum = modelNum
		@color = color.downcase
		@manufacturer = manufacturer.capitalize
		if @manufacturer == "Lg"
			@manufacturer = "LG"
		end
		@status = status.downcase
		@yearBuilt = yearBuilt
		@price = price
		@features = features
	end

	# override the comparator operator used by sort methods
	def <=>(other)
		@manufacturer + @category + @modelNum <=> other.manufacturer + other.category + other.modelNum
	end
	
	# override the object to_s for formated print
	def to_s
		@category+", "+@batteryLife+", "+@modelNum+", "+@color+", "+@manufacturer+", "+@status+", "+@yearBuilt+", "+@price+", "+@features+"\n"
	end

end

class Inventory
	
	def initialize
		@inventory = Array.new
	end
	
	def importListing(listingFile)
		listingString = File.open(listingFile).each do |line|
			addToInventory(line)
		end
	end
	
	# model number is an alphanumeric string that is difficult to identify in regex from other "alphanumeric" strings like battery life or year (12hrs vs 18131A vs 2016) therefore
	# 1 - find attributes in each line using regex and then replace with the empty string ""
	# 2 - find model number attribute last so that the string consists of only of empty strings thus the only alphanumber string left will be the model number
	# errorFlag prevents any device with corrupt attributes from being pushed into the inventory (includes blank lines)
	def addToInventory(line)
		errorFlag = false
		saveLine = line
		category = line.match(/smartphone|tablet|laptop|smartwatch/i)
		line = line.gsub(/smartphone|tablet|laptop|smartwatch/i, "")
		errorFlag = errorFlag || category.nil?
		
		batteryLife = line.match(/\d+hrs/i)
		line = line.gsub(/\d+hrs/i, "")
		errorFlag = errorFlag || batteryLife.nil?
		
		color = line.match(/silver|white|black|burgundy|blue/i)
		line = line.gsub(/silver|white|black|burgundy|blue/i,"")
		errorFlag = errorFlag || color.nil?
		
		manufacturer = line.match(/apple|samsung|google|lenovo|lg/i)
		line = line.gsub(/apple|samsung|google|lenovo|lg/i, "")
		errorFlag = errorFlag || manufacturer.nil?
		
		status = line.match(/used|new|refurbished/i)
		line = line.gsub(/used|new|refurbished/i, "")
		errorFlag = errorFlag || status.nil?
		
		yearBuilt = line.match(/[,\s]+\d{4}[,\s$]/)
		if yearBuilt.nil?
			errorFlag = true
		else
			yearBuilt = yearBuilt[0].match(/\d{4}/)
			line = line.gsub(/[,\s]+\d{4}[,\s$]/, "")
		end
		
		price = line.match(/\d+\$/)
		line = line.gsub(/\d+\$/, "")
		errorFlag = errorFlag || price.nil?
		
		features = line.match(/\{.*\}/)
		line = line.gsub(/\{.*\}/, "")
		errorFlag = errorFlag || features.nil?
		
		modelNum = line.match(/[A-Za-z0-9]+/)
		errorFlag = errorFlag || modelNum.nil?
		
		if errorFlag
			puts "invalid entry: "+saveLine.to_s
		else
			
			device = Device.new(category[0], batteryLife[0], modelNum[0], color[0], manufacturer[0], status[0], yearBuilt[0], price[0], features[0])
			@inventory.push(device)
		end
	end
	
	#sort method uses custom comporator defined in Device object
	def exportListing(fileName)
		File.open(fileName, "w") do |file|
			@inventory.sort.each do |device|
				file.print device.to_s
			end
		end
	end
	
	def print2console
		if @inventory.length == 0
			puts "\nInventory empty!"
		else
			@inventory.sort.each do |device|
				print device.to_s
			end
		end
	end
end	

# main
puts "*********************"
puts "      Inventory      "
puts "*********************"

listing = Inventory.new

input = 0

while input != 4

puts "\n"
puts "1 - Show the inventory"
puts "2 - Import a listing"
puts "3 - Export a listing"
puts "4 - Exit"
puts "\n"
print "Please choose an option: "
input = gets.to_i
	case input
		when 1
			listing.print2console
			
		when 2
			print "Enter path: "
				# gets grabs the newline character at the end
				# use strip (instead of chomp) to strip all leading and trailing whitespace
				filePath = gets.strip
				if File.exists?(filePath)
					listing.importListing(filePath)
				else
					puts "Invalid input\n"
				end
		when 3
			print "Enter path: "
				filePath = gets.strip
				listing.exportListing(filePath)	
		when 4
			puts "Goodbye!"
			exit
		else
			print "Invalid input"
		end
end

