require 'rubygems'
require 'rdfa'
require 'sinatra'
require 'httparty'
require 'haml'
require 'graphviz'

get "/" do
  unless params[:url].nil?
#    File.delete("public/hello_world.svg")
    c = ParserClass.new
    url = params[:url]
    p = HTTParty.get(url)  
    @results = c.parse(p)
    @results.triples[url]=@results.triples.delete("")
    
    g = GraphViz.new( :G, :type => :graph)
    
    @results.triples.keys.each do |k|
      subject = g.add_node(k)
      @results.triples[k].each do |predicate,objects|
        objects.each do |object|
          g.add_edge(subject, g.add_node(object.to_s), :label => predicate )
        end
      end
    end
        
    g.output( :svg => "public/hello_world.svg")
    
    haml :index
  else      
    haml :escape
  end
end

class ParserClass
    acts_as_rdfa_parser
end
