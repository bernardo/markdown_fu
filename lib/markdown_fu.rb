require 'bluecloth'

module MarkdownFu

  class << self
    def translate(str)
      BlueCloth.new(str).to_html
    end
  end

  def self.included(base)
    base.extend ClassMethods
    class << base
      attr_accessor :markdown_attribute
      attr_accessor :html_field
    end
  end

  module ClassMethods

    # Specifies the given field(s) as using markdown, meaning it is passed 
    # through MarkdownFu.translate and set to the html_field.
    #
    #   class Foo < ActiveRecord::Base
    #
    #     # stores the html version of body in body_html
    #     markdown :body
    #
    #     # stores html version of textile_body into converted_body
    #     markdown :markdown_body, :converted_body
    #
    #   end
    #
    def markdown(attr_name, html_field_name = nil)
      self.markdown_attribute  = attr_name
      self.html_field          = html_field_name || "#{attr_name.to_s}_html".to_sym
      before_save :create_markdown_field
    end
  end

protected

  def create_markdown_field
    unless send(self.class.markdown_attribute).nil?
      send("#{self.class.html_field}=", MarkdownFu.translate(send(self.class.markdown_attribute)))
    end
  end

end