require 'tmpdir'

desc "Install releasenotes app non-gem dependencies"
task :deps => ["deps:rmagick"]

# ghostscript installs jpeg, tiff, and jasper
# ImageMagick installs little-cms
# brew imagemagick doesn't seem to support png?

namespace :deps do
  
  CURRENT_VERSIONS = {
    :png => {:lib => "/usr/local/lib/libpng.a", :verlib => "/usr/local/lib/libpng14.a", :url => "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-1.4.3.tar.gz"},
    :jpeg => {:lib => "/usr/local/lib/libjpeg.a", :url => "http://www.ijg.org/files/jpegsrc.v8b.tar.gz"},
    :tiff => {:lib => "/usr/local/lib/libtiff.a", :url => "http://dl.maptools.org/dl/libtiff/tiff-3.8.2.tar.gz"},
    :littlecms => {:lib => "/usr/local/lib/liblcms.a", :url => "http://downloads.sourceforge.net/project/lcms/lcms/2.0/lcms2-2.0a.tar.gz?use_mirror=cdnetworks-us-1&5268731"},
    :fontconfig => {:lib => "/usr/local/lib/libfontconfig.a", :url => "http://cgit.freedesktop.org/fontconfig/snapshot/fontconfig-2.8.0.tar.gz"},
    :freetype => {:include => "/usr/local/include/freetype2", :url => "http://download.savannah.gnu.org/releases-noredirect/freetype/freetype-2.3.12.tar.bz2"},
    :wmf => {:lib => "/usr/local/lib/libwmf.a", :url => "http://downloads.sourceforge.net/project/wvware/libwmf/0.2.8.4/libwmf-0.2.8.4.tar.gz?use_mirror=cdnetworks-us-1&72437085"},
    :ghostscript => {:bin => "/usr/local/bin/gs", :url => "http://ghostscript.com/releases/ghostscript-8.71.tar.gz", :font => "/usr/local/share/ghostscript/fonts/a010013l.afm", :repo => "ghostscript-fonts-std-8.11"},
    :imagemagick => {:bin => "/usr/local/bin/Magick-config", :url => "ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz"}
  }
  
  desc "Install rmagick and all of its dependencies"
  task :rmagick => "rmagick:gem"

  namespace :rmagick do
    DOWNLOAD_DIR = Dir.tmpdir + "/rake"
    CONFIGURE="configure --prefix=/usr/local"

    desc "Install rmagick gem"
    task :gem => CURRENT_VERSIONS[:imagemagick][:bin] do
      unless `gem list -i rmagick`.chomp == "true"
        puts "Installing the rmagick gem"
        system("sudo gem install rmagick")
        puts "Installed rmagick gem"
      else
        puts "rmagick gem already installed"
      end
    end

    desc "Install ImageMagick"
    file CURRENT_VERSIONS[:imagemagick][:bin] => [CURRENT_VERSIONS[:ghostscript][:bin], CURRENT_VERSIONS[:ghostscript][:font], CURRENT_VERSIONS[:fontconfig][:lib], CURRENT_VERSIONS[:freetype][:include], CURRENT_VERSIONS[:jpeg][:lib], CURRENT_VERSIONS[:littlecms][:lib], CURRENT_VERSIONS[:tiff][:lib], CURRENT_VERSIONS[:png][:lib], CURRENT_VERSIONS[:wmf][:lib], DOWNLOAD_DIR] do
      puts "Downloading and installing ImageMagick"
      # download and install ImageMagick from source
      system("curl #{CURRENT_VERSIONS[:imagemagick][:url]} -o #{DOWNLOAD_DIR}/ImageMagick.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/ImageMagick.tar.gz")
#      `curl ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz -o #{DOWNLOAD_DIR}/ImageMagick.tar.gz` unless File.exists?("#{DOWNLOAD_DIR}/ImageMagick.tar.gz")
      system("tar -xzf #{DOWNLOAD_DIR}/ImageMagick.tar.gz -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/ImageMagick*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("export CPPFLAGS=-I/usr/local/include")
        system("export LDFLAGS=-L/usr/local/lib")
        system("./#{CONFIGURE} --disable-static --with-modules --without-perl --without-magick-plus-plus --with-quantum-depth=8 --with-gs-font-dir=/usr/local/share/ghostscript/fonts")
        system("make")
        system("sudo make install")
      end
    end

    desc "Install ghostscript and fonts"
    file CURRENT_VERSIONS[:ghostscript][:bin] => [CURRENT_VERSIONS[:png][:lib], CURRENT_VERSIONS[:jpeg][:lib], DOWNLOAD_DIR] do
      puts "Downloading and installing ghostscript"
      system("curl #{CURRENT_VERSIONS[:ghostscript][:url]} -o #{DOWNLOAD_DIR}/ghostscript.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/ghostscript.tar.bz2")
      system("tar -xzf #{DOWNLOAD_DIR}/ghostscript.tar.gz -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/ghostscript*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("./#{CONFIGURE}")
        system("make")
        system("sudo make install")
      end
    end

    desc "Install ghostscript fonts"
    file CURRENT_VERSIONS[:ghostscript][:font] => [DOWNLOAD_DIR, CURRENT_VERSIONS[:ghostscript][:bin]] do
      puts "Downloading and installing ghostscript fonts"
      dir = "#{DOWNLOAD_DIR}/fonts/"
      if File.exists?(dir)
        Dir.chdir(dir) do
          system("svn cleanup")
          system("svn up -q")
        end
      else
        system("svn co -q http://svn.ghostscript.com/ghostscript/tags/#{CURRENT_VERSIONS[:ghostscript][:repo]}/ #{DOWNLOAD_DIR}/fonts")
      end
      system("sudo mkdir -p /usr/local/share/ghostscript/fonts/")
      Dir.chdir(dir) { system("ls |grep -v COPYING|grep -v ChangeLog|grep -v README|grep -v TODO|xargs -IFONT sudo cp FONT /usr/local/share/ghostscript/fonts/") }
    end

    desc "Install libWMF (for SVG support)"
    file CURRENT_VERSIONS[:wmf][:lib] => DOWNLOAD_DIR do
      puts "Downloading and installing libWMF"
      system("curl -L #{CURRENT_VERSIONS[:wmf][:url]} -o #{DOWNLOAD_DIR}/libwmf.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/libwmf.tar.gz")
      system("tar -xzf #{DOWNLOAD_DIR}/libwmf.tar.gz -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/libwmf*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("./#{CONFIGURE}")
        system("make clean")
        system("make")
        system("sudo make install")
      end
    end

    desc "Install FreeType"
    file CURRENT_VERSIONS[:freetype][:lib] => DOWNLOAD_DIR do
      puts "Downloading and installing FreeType"
      system("curl #{CURRENT_VERSIONS[:freetype][:url]} -o #{DOWNLOAD_DIR}/freetype.tar.bz2") unless File.exists?("#{DOWNLOAD_DIR}/freetype.tar.bz2")
      system("tar -xjf #{DOWNLOAD_DIR}/freetype.tar.bz2 -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/freetype*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("./#{CONFIGURE}")
        system("make")
        system("sudo make install")
      end
    end
    
    file CURRENT_VERSIONS[:png][:lib] => CURRENT_VERSIONS[:png][:verlib]

    desc "Install PNG Support library"
    file CURRENT_VERSIONS[:png][:verlib] => DOWNLOAD_DIR do
      puts "Downloading and installing libPNG"
      system("curl ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-1.2.35.tar.bz2 -o #{DOWNLOAD_DIR}/libpng.tar.bz2") unless File.exists?("#{DOWNLOAD_DIR}/libpng.tar.bz2")
      system("tar -xjf #{DOWNLOAD_DIR}/libpng.tar.bz2 -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/libpng*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("./#{CONFIGURE}")
        system("make")
        system("sudo make install")
      end
    end

    desc "Install JPEG support library"
    file CURRENT_VERSIONS[:jpeg][:lib] => DOWNLOAD_DIR do
      puts "Downloading and installing libJPEG"
      system("curl http://www.ijg.org/files/jpegsrc.v6b.tar.gz -o #{DOWNLOAD_DIR}/jpegsrc.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/jpegsrc.tar.gz")
      system("tar -xzf #{DOWNLOAD_DIR}/jpegsrc.tar.gz -C #{DOWNLOAD_DIR}")
      glibtool = `which glibtool`.chomp
      target = `sw_vers -productVersion`.chomp.split(".")[0..1].join(".")
      dir = `cd #{DOWNLOAD_DIR}/jpeg*/ && pwd`.chomp
      Dir.chdir(dir) do 
        system("ln -s #{glibtool} ./libtool") unless File.exists?("#{dir}/libtool")
        system("export MACOSX_DEPLOYMENT_TARGET=#{target}")
        system("./#{CONFIGURE} --enable-shared")
        system("make")
        system("sudo make install")
      end
    end

    desc "Install TIFF support library"
    file CURRENT_VERSIONS[:tiff][:lib] => DOWNLOAD_DIR do
      puts "Downloading and installing libTIFF"
      system("curl #{CURRENT_VERSIONS[:tiff][:url]} -o #{DOWNLOAD_DIR}/tiff.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/tiff.tar.gz")
      system("tar -xzf #{DOWNLOAD_DIR}/tiff.tar.gz -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/tiff*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("./#{CONFIGURE}")
        system("make")
        system("sudo make install")
      end
    end

    desc "Install Little Color Management System"
    file CURRENT_VERSIONS[:littlecms][:lib] => [CURRENT_VERSIONS[:tiff][:lib], CURRENT_VERSIONS[:jpeg][:lib], DOWNLOAD_DIR] do
      puts "Downloading and installing little CMS"
      system("curl -L #{CURRENT_VERSIONS[:littlecms][:url]} -o #{DOWNLOAD_DIR}/lcms.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/lcms.tar.gz")
      system("tar -xzf #{DOWNLOAD_DIR}/lcms.tar.gz -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/lcms*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("./#{CONFIGURE}")
        system("make")
        system("sudo make install")
      end
    end

    desc "Install fontconfig"
    file CURRENT_VERSIONS[:fontconfig][:lib] => [DOWNLOAD_DIR, CURRENT_VERSIONS[:freetype][:include]] do
	    puts "Downloading and installing fontconfig"
      system("curl #{CURRENT_VERSIONS[:fontconfig][:url]} -o #{DOWNLOAD_DIR}/fontconfig.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/fontconfig.tar.gz")
      system("tar -xzf #{DOWNLOAD_DIR}/fontconfig.tar.gz -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/fontconfig*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("./#{CONFIGURE}")
        system("make")
        system("sudo make install")
      end
    end
  end
end

private
file DOWNLOAD_DIR do
  Dir.mkdir DOWNLOAD_DIR
end
