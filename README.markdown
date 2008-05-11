MarkdownFu
==========

"Markdown is a text-to-HTML conversion tool for web writers. Markdown allows 
you to write using an easy-to-read, easy-to-write plain text format, then 
convert it to structurally valid XHTML (or HTML)."

Markdown was created by [John Gruber][1]

This plugin will convert attributes from Markdown into html and store the result 
in <attribute>_html.

Note: This plugin is based on [textilizefu][2] by adelcambre.

Example
=======

    class Page < ActiveRecord::Base
    
      # stores the html version of content into content_html
      markdown :content
    
      # stores html version of markdown_body into converted_body
      markdown :markdown_body, :converted_body
    
    end

Copyright (c) 2008 Francesc Esplugas Marti, released under the MIT license

[1]: http://daringfireball.net/projects/markdown/
[2]: http://github.com/adelcambre/textilizefu/