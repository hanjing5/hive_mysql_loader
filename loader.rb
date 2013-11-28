require 'trollop'
require_relative 'loader_helper'

opts = Trollop::options do
  opt :database, "Database Name", :type => :string                    # flag --monkey, default false
  opt :table, "Table Name", :type => :string        # string --name <s>, default nil
  opt :filename, "File Name", :type => :string        # string --name <s>, default nil
  opt :username, "User Name", :type => :string        # string --name <s>, default nil
  opt :model, "Model Name", :type => :string        # string --name <s>, default nil
  opt :verbose, "Verbose Mode"
  opt :dryrun, "No operation. Just print out the shell commands."
end

p opts # a hash: { :monkey=>false, :name=>nil, :num_limbs=>4, :help=>false }

# ruby loader.rb nicotine_products.tsv Product
#modelGen(@modelname)
#loadProducts
#headerFetcher(@Filename)
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
