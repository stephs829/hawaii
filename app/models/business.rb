class Business < ActiveRecord::Base

  has_and_belongs_to_many :categories

  LOCATIONS = ["HONOLULU", "HILO", "KAILUA KONA", "WAILUKU", "KAILUA ", "AIEA", "WAIPAHU", "KIHEI", "LAHAINA", "KAHULUI", "LIHUE", "KANEOHE", "KAPOLEI", "KAPAA", "PEARL CITY", "TRIPLER ARMY MEDICAL CENTER", "MILILANI", "WAHIAWA", "WAIANAE", "KAMUELA", "MAKAWAO", "EWA BEACH", "KOLOA", "HALEIWA", "KEALAKEKUA" , "HAIKU", "PEARL HARBOR", "KEAAU", "KULA" , "WAIKOLOA" , "PAHOA", "WAIMANALO", "PAIA" , "KILAUEA", "HONOKAA", "KAUNAKAKAI" , "KALAHEO", "WAIMEA" , "HANALEI", "CAPTAIN COOK", "PRINCEVILLE", "WAIALUA", "LANAI CITY", "KAHUKU" , "HANA" , "VOLCANO", "KAPAAU" , "HANAPEPE" , "HOLUALOA" , "HAUULA" ]

  def self.download_factual(start, count, include_categories, category_start=2, category_end=460)
    factual = Factual.new Factual::KEY, Factual::SECRET

    limit = 50
    count = 9

    puts "Starting: #{start} #{count} #{include_categories}"

    Business::LOCATIONS[start..count].each do |locality|
      puts "Locality: #{locality}"
      (category_start..category_end).each do |category_id| #Factual lists 460 categories with IDs starting from 2
        puts "Category Id: #{category_id}"
        if include_categories
          count = factual.facets("places-us").select("region").filters("$and" => [{"category_ids" => {"$eq" => category_id}}, "locality" => "#{locality}"]).columns
        else
          count = factual.facets("places-us").select("region").filters("locality" => "#{locality}").columns
        end
        puts "Count: #{count}"

        if !count["region"].blank?
          puts "Has Key && Not Blank"
          count = (count["region"]["hi"] / limit).ceil
          if count > 9
            count = 9
          end

          (0..count).each do |i|
            filters = ["locality" => "#{locality}", "region" => "hi"]
            if include_categories
               filters << {"category_ids" => {"$eq" => category_id}}
            end
            puts "Filters #{filters}"
            rows = factual.table("places-us").filters("$and" => filters).offset(i*limit).limit(limit)
            rows.each do |row|
              business = Business.find_or_initialize_by_factual_id(row['factual_id'])
              ['name','address','address_extended','locality','postcode','latitude','longitude','region','country','tel','fax','website','email','hours_display','po_box','post_town','admin_region','chain_id','chain_name'].each do |key|
                business.send(key+'=', row[key])
              end
              if !row['category_ids'].blank?
                row['category_ids'].each do |category_id|
                  if !business.category_ids.include? category_id
                    business.categories << Category.find_or_initialize_by_id(category_id)
                  end
                end
              end
              business.save

            end
          end
        end
      end
    end
  end

  #should get all but ~900 of retail businesses in hawaii
  def self.download_factual_retail
    factual = Factual.new Factual::KEY, Factual::SECRET

    limit = 50
    count = 9

    (123..176).each do |category_id| #Factual lists 460 categories with IDs starting from 2
      count = factual.facets("places-us").select("region").filters("$and" => [{"category_ids" => {"$eq" => category_id}}, "region" => "HI"]).columns
      puts  "Category Id: #{category_id}, Count: #{count}"

      if !count["region"].blank?
        puts "Has Key && Not Blank"
        count = (count["region"]["hi"] / limit).ceil
        if count > 9
          count = 9
        end

        (0..count).each do |i|
          rows = factual.table("places-us").filters("$and" => [{"category_ids" => {"$eq" => category_id}}, "region" => "HI"]).offset(i*limit).limit(limit)
          rows.each do |row|
            business = Business.find_or_initialize_by_factual_id(row['factual_id'])
            ['name','address','address_extended','locality','postcode','latitude','longitude','region','country','tel','fax','website','email','hours_display','po_box','post_town','admin_region','chain_id','chain_name'].each do |key|
              business.send(key+'=', row[key])
            end
            if !row['category_ids'].blank?
              row['category_ids'].each do |category_id|
                if !business.category_ids.include? category_id
                  business.categories << Category.find_or_initialize_by_id(category_id)
                end
              end
            end
            puts "Business name: #{business.name}, id: #{business.id}"
            business.save

          end
        end
      end
    
    end
  
  end


end