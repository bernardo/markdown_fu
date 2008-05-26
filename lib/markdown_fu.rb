begin
  require 'maruku' 
rescue LoadError
  begin
    require 'bluecloth'
  rescue LoadError
    raise "markdown_fu plugin requires BlueCloth or Maruku to be installed." 
  end
end

module MarkdownFu

  class << self
    # Used to transform a string in Markdown format into HTML. It will
    # try to use the _Maruku_ gem, and, if it is not defined, will fall back to using
    # the _BlueCloth_ gem.
    # 
    # Overwrite this if you wish to do any kind of special processing in your Markdown
    # prior to converting.
    # 
    def translate(str)
      if Object.const_defined?(:Maruku)
        Maruku.new(str).to_html
      elsif Object.const_defined?(:BlueCloth)
        BlueCloth.new(str).to_html
      else
        raise "markdown_fu plugin requires BlueCloth or Maruku to be installed." 
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # Specifies the given field as using markdown, meaning it is passed 
    # through MarkdownFu.translate and set to the html_field.
    #
    #   class Foo < ActiveRecord::Base
    #
    #     # stores the html version of body in body_html
    #     markdown :body
    #
    #     # stores html version of markdown_body into converted_body
    #     markdown :markdown_body, :converted_body
    #
    #   end
    #
    def markdown(field_name, html_field_name = nil)
      html_field_name ||= "#{field_name.to_s}_html".to_sym
      
      before_save do |record|
        unless record.send(field_name).blank?
          record.send "#{html_field_name}=", MarkdownFu.translate(record.send(field_name))
        end
      end
      
    end
  end

end