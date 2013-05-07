# Texas

[![Build Status](https://travis-ci.org/rrrene/texas.png?branch=master)](https://travis-ci.org/rrrene/texas) 
[![Code Climate](https://codeclimate.com/github/rrrene/texas.png)](https://codeclimate.com/github/rrrene/texas)
[![Gem Version](https://badge.fury.io/rb/texas.png)](http://badge.fury.io/rb/texas)

## Description

Texas provides an easy way to create PDFs from LaTeX documents using ERB templates.

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
      .texasrc

Let's see what we got here:

* `bin/` All the compiled PDFs will be placed in this folder
* `contents/` All templates go here.
* `lib/` Custom ruby code can be placed here. `init.rb` will be loaded automatically.
* `.texasrc` This is the configuration file for your Texas project.

Texas will compile the `contents/contents.tex.erb` template by default, but you can specify any other template via the command line. 

For example, if your `contents/` directory looks like this:

    contents/
      chapter-1.tex.erb
      chapter-2.tex.erb
      chapter-3.tex.erb
      contents.tex.erb

you can compile the `chapter-1` template separately by running 

    $ texas contents/chapter-1

After compiling, Texas will copy the resulting PDF to the `bin` folder and open it. The PDF file is named according to the compiled template, i.e. `contents.pdf` by default, `chapter-1.pdf` in above example.



### ERB Templates

Templates are stored in the `contents` folder. They are plain ERB templates and used to generate TeX output.

Open `contents/contents.tex.erb` and see the very first line:

    This is a sample <%= b "TeX" %> document.

This ERB will result in 

    This is a sample \textbf{TeX} document.



### Rendering other templates

You can divide your TeX project into as many templates as you like and render any other template through the `render` method.

    <%= render :template => "some_template" %>

Or by shorthand:

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

If you want to render multiple templates, you can provide them via the `:templates` option:
	
	# contents.tex.erb
	
    <%= render :templates => ["goals/primary", "goals/secondary"] %>

Or you can provide a glob:
	
	# contents.tex.erb
	
    <%= render :glob => "goals/*" %>

Both of the above examples result in the same rendered `contents.tex` as the original example.



## Configuration

### Basics

Every Texas project has its own `.texasrc`, a YAML configuration file.

The sample `.texasrc` that comes with every new project is a good starting point to unterstand the concept:

    # Texas config file
    # =================

    document:
      author: "Your Name"
      title: "Document Title"

    # The document hash is intended to store information relevant to your
    # templates:
    #
    # You can add anything you want here, like
    #
    # status: Draft
    # 
    # and then access it in your templates via
    #
    #   <%= document.status %>
    #

    # You can execute commands before and after the PDF is compiled,
    # and alter the commands executed by Texas to compile and open the
    # generated PDF:
    #
    # script:
    #   before: "# this run before anything else"
    #   compile: 'pdflatex -halt-on-error "<%= File.basename(build.master_file) %>"'
    #   after: "# this is run after the pdf compilation"
    #   open: 'evince "<%= build.dest_file %>"'
    #

### Document

The default `document:` section looks like this:

    document:
      author: "Your Name"
      title: "Document Title"

It is intended to store information relevant to your document, i.e. to your templates.

    document:
      author: "John Doe"
      title: "Some descriptive title"
      created_at: "2013-01-01"
      status: "First Draft"

You can access these values in your templates via the `document` object:

    <%= document.author %> -- <%= document.title %> (<%= document.status %>)

This would compile to:

    John Doe -- Some descriptive title (First Draft)

### Running scripts

In the `script:` section (commented by default) you can add shell commands that are run by Texas:

* `before:` This command will run before everything else.
* `compile:` Texas will run this command in the build_path to compile the PDF.
* `after:` This command will run after the PDF is compiled.
* `open:` Texas will run this command to open the generated PDF.

The commented examples in the `.texasrc` shown above are the default commands that are run. 

As you can see from the defaults, the use of ERB tags is supported.




## Advanced usage

### Using --watch

You can conveniently let Texas watch your project's contents and have it rebuild the PDF after changes are made.

Start Texas with the `--watch` switch:

    $ texas --watch

Now, when you edit any template, Texas will recompile your PDF and you can reload it in your PDF viewer (some, like [Evince](http://projects.gnome.org/evince/), reload the PDF automatically).



### Merge configuration

Suppose you have the following configuration in your `texasrc`:

    document:
      author: "John Doe"
      title: "Some descriptive title"
      show_secrets: false
    draft:
      document:
        show_secrets: true

If you run Texas with the `--merge-config` or `-m` switch you can specify a root-level key that will be merged with the general config:

    $ texas -m draft

The resulting configuration after the merge would be:

    document:
      author: "John Doe"
      title: "Some descriptive title"
      show_secrets: true

You can implement conditions in your templates that rely on values from the configuration:

    <% if document.show_secrets %>
      [ some info for your eyes only ]
    <% end %>

This way, you can easily compile your document in "draft mode" via the `-m` command line switch.

Another example would be to use the `-m` switch to "publish" a final version of your PDF. Take the following example:

    document:
      # [... snip ...]
    final:
      script:
        after: 'mv <%= build.dest_file %> <%= build.root %>/bin/final.pdf'
        open: 'evince "<%= build.root %>/bin/final.pdf"'

Now, if we run `texas -m final`, the generated PDF file will be renamed `final.pdf` (and that file will be opened). This way, `final.pdf` would always be the last version of your document compiled using `texas -m final`.



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
