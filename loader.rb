@@filename = ARGV[0]
@@modelname = ARGV[1]
@@Database = ARGV[2]
@@Tablename = ARGV[3]

# Uses shell to create the database
#
def databaseGen
  stt = "echo \"CREATE DATABASE #{@@Database}\" | mysql -u root"
  puts stt
  `#{stt}`
end

def tableGen
  first_frag = "echo \"CREATE TABLE #{@@Tablename} (" 
  second_frag = ")\" | mysql -u root #{@@Database}"
  # column name TEXT, 
  headers = headerFetcher(@@filename)
  limit = headers.count
  headers.each_with_index do |h, i|
    if i == limit -1
      first_frag += h + " TEXT"
    else
      first_frag += h + " TEXT,"
    end
  end
  stt = first_frag + second_frag
  puts stt
  `#{stt}`
end

#
#
# * *Args*    :
#   - ++ ->
# * *Returns* :
#   -
# * *Raises* :
#   - ++ ->
#
def headerFetcher(filename)
  headers = []
  f = File.open(filename,'r')
  f.each_with_index do |l, i|
    break if i > 0
    headers = l.split("\t")
    headers[-1] = headers[-1][0..-2]
  end
  f.close
  return headers
end

def modelGen(modelname)
  headers =  headerFetcher(@@filename)
  result = headers.join(":text ")
  result = "rails g model #{modelname} #{result}:text"
  puts result
end

# Load products
def loadProducts
  tablename = @@modelname.downcase + 's'
  puts tablename
  headers =  headerFetcher(@@filename)
  column_names = headers.join(",")
  f = File.open(@@filename)
  o = File.open("#{tablename}.csv","w")
  f.each do |l|
    o.write(l)
  end
  f.close
  o.close
  cmd_list = []
  cmd_list << "mysqlimport --columns='#{column_names}' --ignore-lines=1 --fields-terminated-by='\t' --local -u root -p #{@@Database} #{tablename}.csv"
  cmd_list << "rm #{tablename}.csv"
  cmd_list.each do |c|
    `#{c}`
  end
end

# ruby loader.rb nicotine_products.tsv Product
#modelGen(@@modelname)
#loadProducts
#headerFetcher(@@filename)
#databaseGen
tableGen
