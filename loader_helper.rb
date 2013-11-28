class LoaderHelper

  def initialize(filename=nil, modelname=nil, database=nil, tablename=nil, username=nil, password=nil, dryrun=false)
    @Filename = filename
    @Modelname = modelname
    @Database = database
    @Tablename = tablename
    @Username = username
    @Password = password
    @dryrun = dryrun
  end
  # Uses shell to create the database

  def databaseGen
    stt = "echo \"CREATE DATABASE #{@Database}\" | mysql -u #{@Username}"
    puts stt
    #`#{stt}` if not @dryrun
  end

  def tableGen
    first_frag = "echo \"CREATE TABLE #{@Tablename} (" 
    second_frag = ")\" | mysql -u #{@Username} #{@Database}"
    # column name TEXT, 
    headers = headerFetcher(@Filename)
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
    #`#{stt}` if not @dryrun
  end

  #
  #
  # * *Args*    :
  #   - ++ ->
  # * *Returns* :
  #   - Array of header strings
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
    headers =  headerFetcher(@Filename)
    result = headers.join(":text ")
    result = "rails g model #{modelname} #{result}:text"
    puts result
  end

  # Load products
  def loadProducts
    tablename = @Tablename
    puts "Loading #{@Filename} into #{@Tablename}..."
    headers =  headerFetcher(@Filename)
    column_names = headers.join(",")
    f = File.open(@Filename)
    o = File.open("#{tablename}.csv","w")
    f.each do |l|
      o.write(l)
    end
    f.close
    o.close
    cmd_list = []
    cmd_list << "mysqlimport --columns='#{column_names}' --ignore-lines=1 --fields-terminated-by='\t' --local -u root -p #{@Database} #{tablename}.csv"
    cmd_list << "rm #{tablename}.csv"
    cmd_list.each do |c|
      puts c
      #`#{c}` if not @dryrun
    end
  end
end
