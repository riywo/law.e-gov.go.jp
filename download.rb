require 'mechanize'
require 'awesome_print'
require 'digest/sha2'
require 'csv'
require 'pp'
require 'trollop'

class Download
  def initialize(opts)
    base_dir = ARGV[0] || File.expand_path("../data", __FILE__)
    @html_dir = File.join(base_dir, "html")
    @text_dir = File.join(base_dir, "text")
    FileUtils.mkdir_p(@html_dir)
    FileUtils.mkdir_p(@text_dir)
    @downloaded_files = File.join(base_dir, "downloaded")
    FileUtils.touch(@downloaded_files)
    @categorydict=self.generate_category
    @opts=opts
  end
  def generate_category
    categorydict=Hash.new
    button_src='H_CTG_'
    CSV.foreach('./category.csv') do |row|
      i=$.
      row.each_with_index do |r,j|
        if i==10 then
          k=j*10+i
          cat_button="#{button_src}#{k}"
        elsif j>0 then
          cat_button="#{button_src}#{j}#{i}"
        elsif j==0 then
          cat_button="#{button_src}#{i}"
        end
        categorydict[cat_button]=r
      end
    end
    categorydict
  end
  def generate_agent
    agent = Mechanize.new { |a| a.user_agent_alias = "Windows IE 9" }
    index_page = agent.get("http://law.e-gov.go.jp/cgi-bin/idxsearch.cgi")
    agent.page.encoding = 'Shift_JIS'  
    return agent,index_page
  end
  def push_buttons
    @categorydict.each do |k,v|
      (agent,index_page)=self.generate_agent
      yomi_form = index_page.forms_with(name: "index")[2]
      cat_button=yomi_form.buttons_with(name: k)
      self.read_laws(cat_button,v,index_page,agent)
    end
  end
  def shadigest(s)
    return Digest::SHA512.hexdigest(s)
  end

  def store_law(law,cat)
    link  = law.text
    File.readlines(@downloaded_files).each do |line|
      line=line.chop
      ctitle=line.split("\t")[1]
      if link =~ /^#{ctitle}$/
        return 
      end
    end
    data  = law.click.frame_with(name: "data").click
    title = data.title
    html  = data.content
    text  = data.at('/html/body').text
    #puts html
    #puts text
    digest=self.shadigest(title)
    #ap cat,digest,title
    p "cat=#{cat} digest=#{digest} title=#{title}"
    filename=nil
    msg=nil
    if @opts[:hash] then
      filename=digest
      msg="#{digest}\t#{link}\t#{cat}"
    else
      filename=title
      msg="#{title}\t#{link}\t#{cat}"
    end
    File.write(File.join(@html_dir, "#{filename}.html"), html)
    File.write(File.join(@text_dir, "#{filename}.txt"),  text)
    open(@downloaded_files, 'a') { |f| f.puts msg}
  end
  def read_laws(cat_button,cat,index_page,agent)
    cat_button.each do |button|
      button.value='@'
      ap button
      bname=button.name
      yomi_form = index_page.forms_with(name: "index")[2]
      list_page = agent.submit(yomi_form, button)
      laws = list_page.links
      lsize=laws.size
      puts "cat=#{cat} law size=#{lsize}"
      laws.each do |law|
        self.store_law(law,cat)
        sleep 3
      end
      sleep 2
    end
  end
end
if __FILE__ == $0
  opts = Trollop::options do
    opt :hash,'Use Hashed dir mode'
  end
  down = Download.new(opts)
  down.push_buttons
end
