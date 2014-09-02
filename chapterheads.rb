input_file = ARGV[0]
working_dir_split = ARGV[0].split("\\")
working_dir = working_dir_split[0...-2].join("\\")
tmp_id = File.read("#{input_file}").match(/978-?(\d{1}-?){10}/i)
tmp_dir = "S:\\resources\\bookmaker_tmp"

html_file = "#{tmp_dir}\\outputtmp.html"
pisbn = File.read("#{html_file}").scan(/Print ISBN:.*?<\/p>/).to_s.gsub(/-/,"").gsub(/Print ISBN: /,"").gsub(/<\/p>/,"").gsub(/\["/,"").gsub(/"\]/,"")

# an array of all occurances of chapters in the manuscript
chapterheads = File.read("#{html_file}").scan(/section data-type="chapter"/)

# base css files
pdf_css = File.read("S:\\resources\\torDOTcom\\css\\tor.css")
epub_css = File.read("S:\\resources\\torDOTcom\\css\\epub.css")

# if number of chapters is greater than 1, copies the css as-is to the archival dir
# if number of chapters is one or less, adds a style to suppress chapter titles to the css and then copies to the archival dir
if chapterheads.count > 1
	`copy S:\\resources\\torDOTcom\\css\\tor.css #{working_dir}\\done\\#{pisbn}\\layout\\pdf.css`
	`copy S:\\resources\\torDOTcom\\css\\epub.css #{working_dir}\\done\\#{pisbn}\\layout\\epub.css`
else
	File.open("#{working_dir}\\done\\#{pisbn}\\layout\\pdf.css", 'w') do |p|
		p.write "#{pdf_css}section[data-type='chapter']>h1{display:none;}"
	end
	File.open("#{working_dir}\\done\\#{pisbn}\\layout\\epub.css", 'w') do |e|
		e.write "#{epub_css}section[data-type='chapter']>h1{display:none;}"
	end
end

