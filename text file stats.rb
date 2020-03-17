# ruby regex reference: https://bneijt.nl/pr/ruby-regular-expressions/ 

# Global Variables Block (not necessary but easier to read)
$charCount = 0
$wordCount = 0
$sentenceCount = 0


# count each character in the string ignoring whitespace using regular expressions .grep
def char_count(string)
	#scan method outputs an array of elements defined by my regular expression (regex)
	$charCount = string.scan(/\S/).length
	puts "Char count: "+$charCount.to_s
	puts "------"
end

# count each word in the string and average word length
def word_stats(string)
	wordArr = string.scan(/\w+/)
	$wordCount = wordArr.length
	puts "Word count: "+ $wordCount.to_s
	
	punctuationCount = string.scan(/[:punct:]/).length
	totalWordLength = 0.0
	wordArr.each {|word| totalWordLength = totalWordLength+word.length}
	puts "Average word length: " + ((totalWordLength-punctuationCount)/$wordCount).to_s
	puts "------"
end

# count each sentence in the string and average sentence length
def sentence_stats(string)
	sentenceArr = string.scan(/[\.;]/)
	$sentenceCount = sentenceArr.length
	puts "Sentence count: "+$sentenceCount.to_s
	puts "Average sentence length: "+($wordCount.to_f/$sentenceCount).to_s
	puts "------"
end

# count each paragraph in the string.  Add 1 to count the last paragraph (if the seperation line has any whitespace it will not be counted as a paragraph separator)
# calculates average number of paragraphs per page
def paragraph_stats(string)
	paragraphCount = string.scan(/\n\n/).length+1
	puts "Paragraph count: "+paragraphCount.to_s
	puts "Average paragraph length: "+($sentenceCount.to_f/paragraphCount).to_s
	
	lineCount = string.scan(/$/).length
	pageCount = (lineCount/50.0).ceil(0)
	puts "Average Paragraphs per page: "+(paragraphCount.to_f/pageCount).to_s
	puts "------"
end

# count each line in the file. A page is defined as 50 lines.
def line_and_page_stats(string)
	lineCount = string.scan(/$/).length
	puts "Line count: "+lineCount.to_s
	puts "Page count: "+ (lineCount/50.0).ceil(0).to_s
	puts "------"
end

# ARGV allows for command line input of the argument
if ARGV.length != 1 || !File.exists?(ARGV[0])
	puts "File not given or invalid"
	puts "Usage: q1.rb filename"
	exit
end
# read text file into a single string object
text = File.read(ARGV[0])
puts "***********************"
puts "  Text File Analytics  "
puts "***********************"
puts "\n"
char_count(text)
word_stats(text)
sentence_stats(text)
paragraph_stats(text)
line_and_page_stats(text)
puts "Byte size of text file: " + text.bytesize.to_s
puts "Character density: " +($charCount.to_f/text.bytesize).to_s
puts "------"
puts "END :)"
