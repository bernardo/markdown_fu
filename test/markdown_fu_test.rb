require 'test/unit'
require 'rubygems'
require 'active_record'
require 'markdown_fu'

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

  def test_translate
    assert_equal "<p>Hello World!</p>", MarkdownFu.translate("Hello World!")
  end

  def test_should_convert_all_markdown_fields_defined_in_the_class_and_super_classes
    post = PostAndComment.new(:body => "test body", :comment => "test comment", :summary => "test summary")
    post.save
    assert_equal "<p>test body</p>",  post.body_html
    assert_equal "<p>test comment</p>",  post.generated_comment
    assert_equal "<p>test summary</p>",  post.summary_html
  end

  def test_should_not_convert_blank_fields
    post = PostAndComment.new(:body => "", :comment => nil)
    post.save
    assert_equal nil, post.body_html
    assert_equal nil, post.generated_comment
  end

end