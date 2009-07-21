require 'tmpdir'

desc "Install releasenotes app non-gem dependencies"
task :deps => ["deps:rmagick"]

namespace :deps do
  
  desc "Install rmagick and all of its dependencies"
  task :rmagick => "rmagick:gem"

  namespace :rmagick do
    DOWNLOAD_DIR = Dir.tmpdir + "/rake"
    CONFIGURE="configure --prefix=/usr/local"

    desc "Install rmagick gem"
    task :gem => "/usr/local/bin/Magick-config" do
      unless `gem list -i rmagick`.chomp == "true"
        puts "Installing the rmagick gem"
        system("sudo gem install rmagick")
        puts "Installed rmagick gem"
      else
        puts "rmagick gem already installed"
      end
    end

    desc "Install ImageMagick"
    file "/usr/local/bin/Magick-config" => ["/usr/local/bin/gs", "/usr/local/share/ghostscript/fonts/a010013l.afm", "/usr/local/lib/libfontconfig.a", "/usr/local/include/freetype2", "/usr/local/lib/libjpeg.a", "/usr/local/lib/liblcms.a", "/usr/local/lib/libtiff.a", "/usr/local/lib/libpng.a", "/usr/local/lib/libwmf.a", DOWNLOAD_DIR] do
      puts "Downloading and installing ImageMagick"
      # download and install ImageMagick from source
      system("curl ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz -o #{DOWNLOAD_DIR}/ImageMagick.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/ImageMagick.tar.gz")
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
    file "/usr/local/bin/gs" => ["/usr/local/lib/libpng.a", "/usr/local/lib/libjpeg.a", DOWNLOAD_DIR] do
      puts "Downloading and installing ghostscript"
      system("curl http://ghostscript.com/releases/ghostscript-8.64.tar.bz2 -o #{DOWNLOAD_DIR}/ghostscript.tar.bz2") unless File.exists?("#{DOWNLOAD_DIR}/ghostscript.tar.bz2")
      system("tar -xjf #{DOWNLOAD_DIR}/ghostscript.tar.bz2 -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/ghostscript*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("./#{CONFIGURE}")
        system("make")
        system("sudo make install")
      end
    end

    desc "Install ghostscript fonts"
    file "/usr/local/share/ghostscript/fonts/a010013l.afm" => [DOWNLOAD_DIR, "/usr/local/bin/gs"] do
      puts "Downloading and installing ghostscript fonts"
      dir = "#{DOWNLOAD_DIR}/fonts/"
      if File.exists?(dir)
        Dir.chdir(dir) do
          system("svn cleanup")
          system("svn up -q")
        end
      else
        system("svn co -q http://svn.ghostscript.com/ghostscript/tags/ghostscript-fonts-std-8.11/ #{DOWNLOAD_DIR}/fonts")
      end
      system("sudo mkdir -p /usr/local/share/ghostscript/fonts/")
      Dir.chdir(dir) { system("ls |grep -v COPYING|grep -v ChangeLog|grep -v README|grep -v TODO|xargs -IFONT sudo cp FONT /usr/local/share/ghostscript/fonts/") }
    end

    desc "Install libWMF (for SVG support)"
    file "/usr/local/lib/libwmf.a" => DOWNLOAD_DIR do
      puts "Downloading and installing libWMF"
      system("curl http://voxel.dl.sourceforge.net/sourceforge/wvware/libwmf-0.2.8.4.tar.gz -o #{DOWNLOAD_DIR}/libwmf.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/libwmf.tar.gz")
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
    file "/usr/local/lib/libfreetype.a" => DOWNLOAD_DIR do
      puts "Downloading and installing FreeType"
      system("curl http://download.savannah.gnu.org/releases-noredirect/freetype/freetype-2.3.9.tar.bz2 -o #{DOWNLOAD_DIR}/freetype.tar.bz2") unless File.exists?("#{DOWNLOAD_DIR}/freetype.tar.bz2")
      system("tar -xjf #{DOWNLOAD_DIR}/freetype.tar.bz2 -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/freetype*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("./#{CONFIGURE}")
        system("make")
        system("sudo make install")
      end
    end
    
    file "/usr/local/lib/libpng.a" => "/usr/local/lib/libpng12.a"

    desc "Install PNG Support library"
    file "/usr/local/lib/libpng12.a" => DOWNLOAD_DIR do
      puts "Downloading and installing libPNG"
      system("curl ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-1.2.38.tar.bz2 -o #{DOWNLOAD_DIR}/libpng.tar.bz2") unless File.exists?("#{DOWNLOAD_DIR}/libpng.tar.bz2")
      system("tar -xjf #{DOWNLOAD_DIR}/libpng.tar.bz2 -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/libpng*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("./#{CONFIGURE}")
        system("make")
        system("sudo make install")
      end
    end

    desc "Install JPEG support library"
    file "/usr/local/lib/libjpeg.a" => DOWNLOAD_DIR do
      puts "Downloading and installing libJPEG"
      system("curl http://www.ijg.org/files/jpegsrc.v7.tar.gz -o #{DOWNLOAD_DIR}/jpegsrc.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/jpegsrc.tar.gz")
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
    file "/usr/local/lib/libtiff.a" => DOWNLOAD_DIR do
      puts "Downloading and installing libTIFF"
      system("curl http://dl.maptools.org/dl/libtiff/tiff-3.8.2.tar.gz -o #{DOWNLOAD_DIR}/tiff.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/tiff.tar.gz")
      system("tar -xzf #{DOWNLOAD_DIR}/tiff.tar.gz -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/tiff*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("./#{CONFIGURE}")
        system("make")
        system("sudo make install")
      end
    end

    desc "Install Little Color Management System"
    file "/usr/local/lib/liblcms.a" => ["/usr/local/lib/libtiff.a", "/usr/local/lib/libjpeg.a", DOWNLOAD_DIR] do
      puts "Downloading and installing little CMS"
      system("curl http://www.littlecms.com/lcms-1.17.tar.gz -o #{DOWNLOAD_DIR}/lcms.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/lcms.tar.gz")
      system("tar -xzf #{DOWNLOAD_DIR}/lcms.tar.gz -C #{DOWNLOAD_DIR}")
      dir = `cd #{DOWNLOAD_DIR}/lcms*/ && pwd`.chomp
      Dir.chdir(dir) do
        system("./#{CONFIGURE}")
        system("make")
        system("sudo make install")
      end
    end

    desc "Install fontconfig"
    file "/usr/local/lib/libfontconfig.a" => [DOWNLOAD_DIR, "/usr/local/include/freetype2"] do
	    puts "Downloading and installing fontconfig"
      system("curl http://fontconfig.org/release/fontconfig-2.6.0.tar.gz -o #{DOWNLOAD_DIR}/fontconfig.tar.gz") unless File.exists?("#{DOWNLOAD_DIR}/fontconfig.tar.gz")
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
