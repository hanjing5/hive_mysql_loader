require 'trollop'
require_relative 'loader_helper'

opts = Trollop::options do
  opt :database, "Database Name", :type => :string             
  opt :table, "Table Name", :type => :string        
  opt :filename, "File Name", :type => :string     
  opt :username, "User Name", :type => :string    
  opt :model, "Model Name", :type => :string     
  opt :verbose, "Verbose Mode"
  opt :dryrun, "No operation. Just print out the shell commands."
end

#p opts # a hash: { :monkey=>false, :name=>nil, :num_limbs=>4, :help=>false }

# ruby loader.rb --file product_dump.tsv --table test_table --database test_db
#modelGen(@modelname)
loader = LoaderHelper.new(
                           file=opts[:filename], 
                           modelname = opts[:model], 
                           database=opts[:database], 
                           tablename=opts[:table], 
                           username=opts[:username],
                           dryrun=opts[:dryrun]
                         )
loader.databaseGen
loader.tableGen
loader.loadProducts
