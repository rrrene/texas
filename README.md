# Texas

## Description

Texas provides an easy way to create PDFs from LaTeX documents using ERb templates.

It does this by compiling *.tex.erb templates to *.tex files and then running pdflatex to turn the compiled templates into a PDF file.



## Installation

Install Texas at the command prompt if you haven’t yet:

    $ gem install texas



## Usage

### New project

At the command prompt, create a new Texas project:

    $ texas --new test_project
    
where “myapp” is the application name.

Change directory to myapp and start the web server:

    $ cd test_project
    $ texas
    
Run with --help or -h for options.



### Project structure    
  
In the above sample a folder named `test_project` is created. It contains the basic texas skeleton with a sample template:

    test_project/
      bin/
      contents/
        contents.tex.erb
      lib/
        helpers/
          document_helper.rb
        init.rb

It will compile the `contents/contents.tex.erb` template by default, but you can specify any other template via the command line. 

After compiling, it will copy the resulting PDF to the `bin` folder and open it.



### ERb Templates

Templates are plain ERb templates and used to generate TeX output:

    This is a sample <%= b "TeX" %> document.

This will result in 

    This is a sample \textbf{TeX} document.



### Rendering other templates

You can render any other template through the `render` method.

    <%= render :some_template %>

This will look for a template with the basename `some_template` and any of the supported extensions:

    some_template.tex
    some_template.tex.erb
    some_template.md
    some_template.md.erb

The `render` method looks in the template's path and a path with the basename of the current template.

The following example illustrates this:

Given this directory structure

    contents/
      goals/
        primary.tex.erb
        secondary.tex.erb
      goals.tex.erb
      contents.tex.erb

this would be a valid project:

    # contents.tex.erb

    <%= render :goals %>

    # goals.tex.erb

    <%= render :primary %>
    <%= render :secondary %>

The `goals` template is found, because it lives in the same directory as the template rendering it. The `primary` and `secondary` templates are found, because they live in a directory called like the template placing the `render`-call ("goals").



### Using custom helpers

In `lib/document_helper.rb` you can define your own helper methods.

Example:

    module DocumentHelper
      def current_date
        Time.now.strftime("%a, %Y-%m-%d")
      end
    end

    Texas::Template.register_helper DocumentHelper

Now you can use that method in your templates:

    Created: <%= current_date %>

To generate

    Created: Tue, 2013-04-16



### Extending Texas for a project

Since `lib/init.rb` is required by `texas` before the build process begins, you can extend its modules and classes in any way that Ruby permits.



## License

Released under the MIT License. See the LICENSE file for further details.
