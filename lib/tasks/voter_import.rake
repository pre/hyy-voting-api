namespace :voters do

  desc 'Import voters from given file in Opiskelijarekisteri format'
  task :import, [:filename] => :environment do
    unless filename=ENV['filename']
      puts "Missing parameter: filename=import_file.txt"
      exit 1
    end

    CONTAINER_NAME="ROW"

    puts "Hellurei! #{filename}"

    doc = File.open(filename) { |f| Nokogiri::XML(f) }
    #doc = File.open("../hyy-voting-data/2015-10-test/HYY-vaalit\ testi.xml") { |f| Nokogiri::XML(f) }
    # doc = File.open("testi.xml") { |f| Nokogiri::XML(f) }

    doc.xpath("//#{CONTAINER_NAME}").each do |xml_voter|
      imported_voter = ImportedVoter.build_from xml_voter
    end

  end
end
