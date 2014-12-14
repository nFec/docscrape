require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pp'

complete = Array.new

for letter in 'A'..'Z'
  uri = "http://www.aerztekammer-hamburg.de/funktionen/arztsuche/ergebnisse.php3?buchstabe=8&st=&stname=&name=" + letter + "&fa=&zu=&sp=&stadtteil=&anzeige="
  puts uri
  page = Nokogiri::HTML(open(uri))
  rows = page.xpath('//table/tr')
  details = rows.collect do |row|
    detail = {}
    [
      [:Name, 'td[2]/font/text()'],
      [:FirstAndTitle, 'td[2]/font/text()[preceding-sibling::br[1]]'],
      [:Area, 'td[2]/font/text()[preceding-sibling::br[3]]'],
      [:Additional, 'td[3]/font/text()'],
      [:Contact, 'td[4]/font/text()'],
      [:Times, 'td[5]/font/text()']
    ].each do |name, xpath|
      detail[name] = row.at_xpath(xpath).to_s.strip
    end
    detail
  end
  details.delete_if {|entry| entry[:Name] == ""}
  details.delete_at 0
  details.delete_at 0
  complete.push(*details)
end
pp complete
