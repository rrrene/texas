# Texas

## Description

Texas provides an easy way to create PDFs from LaTeX documents using ERb templates.

It does this by compiling *.tex.erb templates to *.tex files and then running pdflatex to turn the compiled templates into a PDF file.

* Plain ERb templates, no bells and whistles
* Build process, template helpers and supported formats are easily extensible


## Installation & Usage

Install Texas at the command prompt if you haven’t yet:

    $ gem install texas
    
At the command prompt, create a new Texas project:

    $ texas --new test_project
    
where “myapp” is the application name.

Change directory to myapp and start the web server:

    $ cd test_project
    $ texas
    
Run with --help or -h for options.


## Project structure    
  
In the above sample a folder named `test_project` is created. It contains the basic texas skeleton with a sample template:

    test_project/
      bin/
      contents/
        contents.tex.erb
      lib/
        helpers/
          document_helper.rb
        init.rb

It will compile the `contents/contents.tex.erb` template, copy the resulting PDF to the `bin` folder and open it.


## License

Released under the MIT License. See the LICENSE file for further details.
