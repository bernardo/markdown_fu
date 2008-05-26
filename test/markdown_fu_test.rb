require 'test/unit'

require 'rubygems'
gem 'activerecord', '>= 1.15.4.7794'
require 'active_record'
require 'mocha'
require "#{File.dirname(__FILE__)}/../init"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :posts do |t|
      t.column :body, :text
      t.column :body_html, :text
      t.column :comment, :text
      t.column :generated_comment, :text
      t.column :summary, :text
      t.column :summary_html, :text
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Post < ActiveRecord::Base
  markdown :body
end

class PostAndComment < Post
  markdown :comment, :generated_comment
  markdown :summary
end


class MarkdownFuTest < Test::Unit::TestCase

  def setup
    setup_db
  end

  def teardown
    teardown_db
  end
   
  def test_should_convert_all_markdown_fields_defined_in_the_class_and_super_classes
    post = PostAndComment.new(:body=>'test body', :comment=>'test comment', :summary=>'test summary')
    MarkdownFu.expects(:translate).with('test comment').returns("comment converted")
    MarkdownFu.expects(:translate).with('test body').returns("body converted")
    MarkdownFu.expects(:translate).with('test summary').returns("summary converted")
    post.save
    assert_equal "summary converted",  post.summary_html
    assert_equal "comment converted",  post.generated_comment
    assert_equal "body converted",  post.body_html
  end
  
  def test_should_not_convert_blank_fields
    post = PostAndComment.new(:body=>'', :comment=>nil)
    MarkdownFu.expects(:translate).never
    post.save
  end
  
  def test_translate_should_be_working 
    assert_equal "<p>teste</p>", MarkdownFu.translate("teste")
  end
  
end
